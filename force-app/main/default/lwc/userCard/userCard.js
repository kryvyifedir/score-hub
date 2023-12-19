import { LightningElement, api } from 'lwc';
//Custom Labels
import PersonalScoreLabel from '@salesforce/label/c.PersonalScore';
import NumberOfAchievementsLabel from '@salesforce/label/c.NumberOfAchievements';
import LoadingLabel from '@salesforce/label/c.Loading';
import OutOfLabel from '@salesforce/label/c.OutOf';
import AvatarAltTextLabel from '@salesforce/label/c.AvatarAltText';

export default class UserCard extends LightningElement {
    labels = {
        PersonalScoreLabel, NumberOfAchievementsLabel, LoadingLabel, OutOfLabel, AvatarAltTextLabel
    };

    @api userInfo

    @api 
    get getShowProgressBar() {
        return this.userInfo.totalAchievementsCount ? true : false
    }

    @api
    get getNumberOfAchievementsPercentage() {
        return this.userInfo.totalAchievementsCount ? 100 * this.userInfo.reachedAchievementsCount / this.userInfo.totalAchievementsCount : 0
    }

    @api
    get getNumberOfAchievements() {
        let reachedAchievementsCount = this.userInfo.reachedAchievementsCount ? this.userInfo.reachedAchievementsCount : 0
        return this.userInfo.totalAchievementsCount ? 
            reachedAchievementsCount + " " + this.labels.OutOfLabel + " " + this.userInfo.totalAchievementsCount : reachedAchievementsCount
    }

    @api
    get getScore() {
        return this.userInfo.totalScore ? this.userInfo.totalScore : 0;
    }

    handleUserCardClicked() {
        this.dispatchEvent(new CustomEvent("clicked", { detail: this.userInfo.id }));
    }
}