import { LightningElement, api } from 'lwc';

export default class AchievementCard extends LightningElement {
    @api title
    @api descriptions
    @api achieved
}