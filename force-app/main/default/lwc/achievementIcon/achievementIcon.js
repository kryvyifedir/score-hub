import { LightningElement, api } from 'lwc';

export default class AchievementIcon extends LightningElement {
    @api achievement
    @api size

    get getAchievementFallbackIcon() {
        return this.achievement && this.achievement.isReached ? "standard:task2" : "standard:trailhead"
    }

    get iconSize() {
        return this.size ? this.size : "medium"
    }
}