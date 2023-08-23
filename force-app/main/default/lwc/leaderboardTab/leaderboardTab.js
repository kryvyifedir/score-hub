import { LightningElement, api } from 'lwc';
//Custom Labels
import LoadingLabel from '@salesforce/label/c.Loading';
import BeTheFirstOneLabel from '@salesforce/label/c.BeTheFirstOne';
import NoOneHasUnlockedAchievementLabel from '@salesforce/label/c.NoOneHasUnlockedAchievement';
import ErrorLabel from '@salesforce/label/c.Error';
import UnableToLoadLeadeboardLabel from '@salesforce/label/c.UnableToLoadLeadeboard';

export default class LeaderboardTab extends LightningElement {
    labels = {
        LoadingLabel, BeTheFirstOneLabel, NoOneHasUnlockedAchievementLabel, ErrorLabel, UnableToLoadLeadeboardLabel
    };

    @api users = []
    @api isReady = false
    @api isError = false

    get showData() {
        return this.isReady && this.users && this.users.length !== 0 && !this.isError
    }

    get showEmpty() {
        return this.isReady && this.users && this.users.length === 0 && !this.isError
    }

    get showLoading() {
        return !this.isReady && !this.isError
    }

    get showError() {
        return this.isError
    }
}