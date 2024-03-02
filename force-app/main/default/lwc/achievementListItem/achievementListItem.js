import { LightningElement, api } from 'lwc';

export default class AchievementListItem extends LightningElement {
    @api achievement

    get badgeScore() {
        return "+ " + this.achievement.score
    }

    get badgeStyle() {
        return this.achievement.isReached ? "slds-theme_success" : ""
    }
}