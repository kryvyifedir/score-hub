import { LightningElement } from 'lwc';
//Custom Labels
import TopUsersLabel from '@salesforce/label/c.TopUsers';
import SeasonsLeaderboardLabel from '@salesforce/label/c.SeasonsLeaderboard';

export default class ScoreHubHome extends LightningElement {
    labels = {
        TopUsersLabel, SeasonsLeaderboardLabel
    };
}