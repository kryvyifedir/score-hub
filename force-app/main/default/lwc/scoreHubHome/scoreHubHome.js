import { LightningElement } from 'lwc';
//Custom Labels
import TopUsersLabel from '@salesforce/label/c.TopUsers';
import SeasonsLeaderboardLabel from '@salesforce/label/c.SeasonsLeaderboard';

export default class ScoreHubHome extends LightningElement {
    labels = {
        TopUsersLabel, SeasonsLeaderboardLabel
    };

    isBackButtonDisabled = false
    isForwardButtonDisabled = false
    seasonsColumnHeader = 'Seasons'

    backButtonClick() {
        this.template.querySelector("c-seasons-leaderboard")?.backButtonClick();
    }

    forwardButtonClick() {
        this.template.querySelector("c-seasons-leaderboard")?.forwardButtonClick();
    }

    handleLeaderboardChange(event) {
        this.isBackButtonDisabled = event.detail.isBackButtonDisabled
        this.isForwardButtonDisabled = event.detail.isForwardButtonDisabled
        this.seasonsColumnHeader = event.detail.header
    }
}