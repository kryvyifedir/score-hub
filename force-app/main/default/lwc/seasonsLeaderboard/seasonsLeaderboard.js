import { LightningElement, wire } from 'lwc';
import Toast from 'lightning/toast';

// APEX Controller methods
import getSeasonsConfig from '@salesforce/apex/SeasonsLeaderboardController.getSeasonsConfig';

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

    isConfigActive = false;
    loadingConfig = true;

    get showLoading() {
        return this.loadingConfig;
    }

    get isConfigNotActive() {
        return !this.isConfigActive
    }

    @wire(getSeasonsConfig)
    wiredSeasonsConfig({ data, error }) {
        if (data) {
            if (data.Success) {
                var result = data.Success;
                this.isConfigActive = result.isActive
                this.loadingConfig = false;
            } else if (data.Error) {
                console.log(JSON.stringify(data.Error))
                Toast.show({
                    label: this.labels.SomethingWentWrongErrorTitle,
                    message: this.labels.RetrieveSeasonConfigErrorMsg,
                    variant: 'error'
                }, this)
            }
        } else if (error) {
            console.log(JSON.stringify(error))
            Toast.show({
                label: this.labels.SomethingWentWrongErrorTitle,
                message: this.labels.RetrieveSeasonConfigErrorMsg,
                variant: 'error'
            }, this)
        }
    }
}