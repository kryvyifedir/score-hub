import { LightningElement, api } from 'lwc';
import Toast from 'lightning/toast';

// APEX Controller methods
import getSeasonsConfig from '@salesforce/apex/SeasonsLeaderboardController.getSeasonsConfig';
import getSeasonsCount from '@salesforce/apex/SeasonsLeaderboardController.getTotalNumberOfSeasons';
import getSeasonData from '@salesforce/apex/SeasonsLeaderboardController.getSeasonData';

//Custom Labels
import LoadingLabel from '@salesforce/label/c.Loading';
import SomethingWentWrongErrorTitle from '@salesforce/label/c.SomethingWentWrongErrorTitle';
import RetrieveSeasonConfigErrorMsg from '@salesforce/label/c.RetrieveSeasonConfigErrorMsg';
import SeasonsAreNotEnabledHeader from '@salesforce/label/c.SeasonsAreNotEnabledHeader';
import SeasonsAreNotEnabledSubheader from '@salesforce/label/c.SeasonsAreNotEnabledSubheader';
import OrderByCountLabel from '@salesforce/label/c.OrderByCount';
import OrderByScoreLabel from '@salesforce/label/c.OrderByScore';

export default class SeasonsLeaderboard extends LightningElement {
    labels = {
        LoadingLabel, SomethingWentWrongErrorTitle, RetrieveSeasonConfigErrorMsg, SeasonsAreNotEnabledHeader, SeasonsAreNotEnabledSubheader, OrderByCountLabel, OrderByScoreLabel
    };

    isError = false;
    errorTitle = '';
    errorMsg = '';
    isLoading = true;

    isConfigActive = false;

    maxSeasonsCount = 0;
    currentSeasonNumber = 0;

    seasonData = null;

    connectedCallback() {
        this.isLoading = true
        this.isError = false
        Promise.all([
            getSeasonsConfig(),
            getSeasonsCount(),
            getSeasonData({ offset: this.currentSeasonNumber })
        ])
        .then(results => {
            // Handle getSeasonsConfig
            if (results[0].Success) {
                this.isConfigActive = results[0].Success.isActive
            } else {
                this.isError = true
                console.log(JSON.stringify(results[0].Error))
                console.log(JSON.stringify(results[0].Warning))
                this.errorTitle = this.labels.SomethingWentWrongErrorTitle
                this.errorMsg = this.labels.RetrieveSeasonConfigErrorMsg
            }

            // Handle getSeasonsCount
            if (!results[1].Error && !results[1].Warning) {
                this.maxSeasonsCount = results[1].Success
            } else {
                this.isError = true
                console.log(JSON.stringify(results[1].Error))
                console.log(JSON.stringify(results[1].Warning))
                this.errorTitle = this.labels.SomethingWentWrongErrorTitle
                this.errorMsg = 'TODO proper msg'
            }

            // Handle getSeasonData
            if (results[2] && results[2].Success) {
                this.seasonData = results[2].Success
            } else {
                this.isError = true
                console.log(JSON.stringify(results[2].Error))
                console.log(JSON.stringify(results[2].Warning))
                this.errorTitle = this.labels.SomethingWentWrongErrorTitle
                this.errorMsg = 'TODO proper msg'
            }
        })
        .catch(error => {
            this.isError = true
            console.log(JSON.stringify(error))
            this.errorTitle = this.labels.SomethingWentWrongErrorTitle
            this.errorMsg = 'TODO proper msg'
        })
        .finally(() => {
            this.isLoading = false
            this.stateChange();
        })
    }

    get isConfigNotActive() {
        return !this.isConfigActive
    }

    get isCurrentSeason() {
        return this.currentSeasonNumber === 0
    }

    get ongoingSeasonMessage() {
        let msg = "We are still gathering statistics for an ongoing season."
        msg += " Leaderboard will be available after season ends."

        if (this.maxSeasonsCount > 1) {
            msg += " You can check the leaderboards for previous seasons by clikcing the 'back' arrow-button on top"
        }

        return msg
    }

    


    get topThreeByScore() {
        return this.seasonData?.topThreeByScore
    }

    get topThreeByCount() {
        return this.seasonData?.topThreeByCount
    }
    
    @api
    backButtonClick() {
        this.currentSeasonNumber++;
        this.stateChange();
        this.fetchSeasonData();
    }

    @api
    forwardButtonClick() {
        this.currentSeasonNumber--;
        this.stateChange();
        this.fetchSeasonData();
    }

    fetchSeasonData() {
        this.isLoading = true;
        getSeasonData({ offset: this.currentSeasonNumber })
            .then(result => {
                if (result && result.Success) {
                    this.seasonData = result.Success;
                } else {
                    this.isError = true;
                    console.log(JSON.stringify(result.Error));
                    console.log(JSON.stringify(result.Warning));
                    this.errorTitle = this.labels.SomethingWentWrongErrorTitle;
                    this.errorMsg = 'TODO proper msg';
                }
            })
            .catch(error => {
                this.isError = true;
                console.log(JSON.stringify(error));
                this.errorTitle = this.labels.SomethingWentWrongErrorTitle;
                this.errorMsg = 'TODO proper msg';
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    stateChange() {
        let headerText = 'Seasons'

        if (this.isConfigActive) {
            if (this.currentSeasonNumber === 0) {
                headerText = 'Season: Ongoing'
            } else if (!this.dateFrom()) {
                headerText = 'Season: Pre-season'
            } else {
                headerText = 'Season: ' + this.dateFrom() + ' - ' + this.dateTo()
            }
        } 

        const changedEvent = new CustomEvent("changed", { detail: { 
            isBackButtonDisabled: this.currentSeasonNumber === this.maxSeasonsCount - 1,
            isForwardButtonDisabled: this.currentSeasonNumber === 0 ,
            header: headerText}})
        this.dispatchEvent(changedEvent);
    }

    dateFrom() {
        return this.seasonData?.dateFrom ? this.seasonData?.dateFrom : '...'
    }

    dateTo() {
        return this.seasonData?.dateTo ? this.seasonData?.dateTo : '...'
    }
}