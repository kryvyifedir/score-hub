import { LightningElement, wire } from 'lwc';
import Toast from 'lightning/toast';

// APEX Controller methods
import getSeasonsConfig from '@salesforce/apex/SeasonsLeaderboardController.getSeasonsConfig';
import getSeasonsCount from '@salesforce/apex/SeasonsLeaderboardController.getTotalNumberOfSeasons';

//Custom Labels
import LoadingLabel from '@salesforce/label/c.Loading';
import SomethingWentWrongErrorTitle from '@salesforce/label/c.SomethingWentWrongErrorTitle';
import RetrieveSeasonConfigErrorMsg from '@salesforce/label/c.RetrieveSeasonConfigErrorMsg';
import SeasonsAreNotEnabledHeader from '@salesforce/label/c.SeasonsAreNotEnabledHeader';
import SeasonsAreNotEnabledSubheader from '@salesforce/label/c.SeasonsAreNotEnabledSubheader';

export default class SeasonsLeaderboard extends LightningElement {
    labels = {
        LoadingLabel, SomethingWentWrongErrorTitle, RetrieveSeasonConfigErrorMsg, SeasonsAreNotEnabledHeader, SeasonsAreNotEnabledSubheader
    };

    isError = false;
    isLoading = true;

    isConfigActive = false;

    maxSeasonsCount = 0;
    currentSeasonNumber = 0;

    connectedCallback(){
        Promise.all([
            getSeasonsConfig(),
            getSeasonsCount()
        ]).then(results => {
            if (results[0].Success) {
                this.isConfigActive = results[0].Success.isActive
            } else {
                this.isError = true;
                console.log(JSON.stringify(results[0].Error))
                console.log(JSON.stringify(results[0].Warning))
                Toast.show({
                    label: this.labels.SomethingWentWrongErrorTitle,
                    message: this.labels.RetrieveSeasonConfigErrorMsg,
                    variant: 'error'
                }, this)
            }

            if (!results[1].Error && !results[1].Warning) {
                this.maxSeasonsCount = results[1].Success
            } else {
                this.isError = true;
                console.log(JSON.stringify(results[1].Error))
                console.log(JSON.stringify(results[1].Warning))
                Toast.show({
                    label: this.labels.SomethingWentWrongErrorTitle,
                    message: 'TODO proper msg',
                    variant: 'error'
                }, this)
            }
        }).catch(error => {
            console.log(JSON.stringify(error))
            this.isError = true;
            Toast.show({
                label: this.labels.SomethingWentWrongErrorTitle,
                message: 'TODO MSG',
                variant: 'error'
            }, this)

        }).finally(() => {
            this.isLoading = false;
        });
    }

    get isConfigNotActive() {
        return !this.isConfigActive
    }
}