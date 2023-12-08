import { LightningElement, api } from 'lwc';
import CompareUsersModal from 'c/compareUsersModal';
import CurrentUserId from "@salesforce/user/Id";

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

    currentUserId = CurrentUserId;
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
        if (this.currentUserId && event.detail && this.currentUserId !== event.detail) {
            const result = await CompareUsersModal.open({
                label: 'test',
                size: 'medium',
                description: 'Accessible description of modal\'s purpose',
                content: [this.currentUserId, event.detail],
            });
        }
    }
}