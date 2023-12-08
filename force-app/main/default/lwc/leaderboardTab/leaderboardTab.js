import { LightningElement, api } from 'lwc';
import ModalTest from 'c/compareUsersModal';

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

    async handleUserCardClicked(event) {
        const result = await ModalTest.open({
            // `label` is not included here in this example.
            // it is set on lightning-modal-header instead
            label: 'test',
            size: 'large',
            description: 'Accessible description of modal\'s purpose',
            content: 'Passed into content api',
        });
        // if modal closed with X button, promise returns result = 'undefined'
        // if modal closed with OK button, promise returns result = 'okay'
        console.log(result);
    }
}