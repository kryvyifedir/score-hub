import { LightningElement, api } from 'lwc';

export default class AchievementCard extends LightningElement {
    @api title
    @api description
    @api isReached
}