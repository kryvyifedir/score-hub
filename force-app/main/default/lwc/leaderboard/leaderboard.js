import { LightningElement, api, wire } from 'lwc';
// APEX Controller methods
import getTopUsersByScore from '@salesforce/apex/LeaderboardController.getTopUsersByScore';
import getTopUsersByAchievementsCount from '@salesforce/apex/LeaderboardController.getTopUsersByAchievementsCount';
//Custom Labels
import TopUsersLabel from '@salesforce/label/c.TopUsers';
import OrderByCountLabel from '@salesforce/label/c.OrderByCount';
import OrderByScoreLabel from '@salesforce/label/c.OrderByScore';

export default class Leaderboard extends LightningElement {
    labels = {
        TopUsersLabel, OrderByCountLabel, OrderByScoreLabel
    };

    topUsersByScore = []
    topUsersByScoreReady = false;
    topUsersByScoreError = false;
    topUsersByAchievementsCount = []
    topUsersByAchievementsCountReady = false;
    topUsersByAchievementsCountError = false;

    @wire(getTopUsersByScore)
    wiredTopUserByScore({ error, data }) {
        if (data) {
            if (data.Success) {
                this.topUsersByScore = data.Success
                this.topUsersByScoreReady = true
                this.topUsersByScoreError = false
            } else if (data.Error) {
                console.log(JSON.stringify(data.Error))
                this.topUsersByScoreError = true
            }
        } else if (error) {
            console.log(JSON.stringify(error))
            this.topUsersByScoreError = true
        }
    }

    @wire(getTopUsersByAchievementsCount)
    wiredTopUserByAchievementsCount({ error, data }) {
        if (data) {
            if (data.Success) {
                this.topUsersByAchievementsCount = data.Success
                this.topUsersByAchievementsCountReady = true
                this.topUsersByAchievementsCountError = false
            } else if (data.Error) {
                console.log(JSON.stringify(data.Error))
                this.topUsersByAchievementsCountError = true
            }
        } else if (error) {
            console.log(JSON.stringify(error))
            this.topUsersByAchievementsCountError = true
        }
    }

    get getTopUsersByScoreOrdered() {
        let returnValue = [];
        if (this.topUsersByScore) {
            returnValue = [...this.topUsersByScore].sort((a, b) => { return b.totalScore - a.totalScore });
        }
        return returnValue;
    }

    get getTopUsersByAchievementsCountOrdered() {
        let returnValue = [];
        if (this.topUsersByScore) {
            returnValue = [...this.topUsersByAchievementsCount].sort((a, b) => { return b.reachedAchievementsCount - a.reachedAchievementsCount });
        }
        return returnValue;
    }
}