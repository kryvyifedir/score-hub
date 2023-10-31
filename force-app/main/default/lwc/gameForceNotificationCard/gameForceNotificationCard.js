import { LightningElement, api } from 'lwc';

export default class GameForceNotificationCard extends LightningElement {
    @api achievement

    get numberOfPoints() {
        return "+ " + this.achievement.score + " points"
    }

    get scoreClass() {
        return this.achievement.isReached ? "slds-theme_success" : "pending-badge"
    }

    get headerText() {
        return this.achievement.isReached ? "Achievement Reached" : "Your Closest Achievement"
    }

}