import { LightningElement, api } from 'lwc';

export default class AchievementListItem extends LightningElement {
    @api title
    @api description
    @api isReached

    get getAchievementFallbackIcon() {
        return this.isReached ? "standard:task2" : "standard:trailhead"
    }
}