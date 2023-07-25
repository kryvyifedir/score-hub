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
    @api totalAchievementsCount

    @api
    get getNumberOfAchievementsPercentage() {
        return this.totalAchievementsCount && this.userInfo.numberOfAchievements ? 
            result = 100 * this.userInfo.numberOfAchievements / this.totalAchievementsCount : null
    }

    @api
    get getNumberOfAchievements() {
        let numberOfAchievements = this.userInfo.numberOfAchievements ? this.userInfo.numberOfAchievements : 0
        return this.totalAchievementsCount ? 
            numberOfAchievements + " " + this.labels.OutOfLabel + " " + this.totalAchievementsCount : numberOfAchievements
    }

    @api
    get getScore() {
        return this.userInfo.totalScore ? this.userInfo.totalScore : 0;
    }
}