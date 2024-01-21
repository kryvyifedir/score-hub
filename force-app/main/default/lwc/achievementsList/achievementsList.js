import { LightningElement, api } from 'lwc';
//Custom Labels
import YourAchievementsLabel from '@salesforce/label/c.YourAchievements';

export default class AchievementsList extends LightningElement {
    labels = {
        YourAchievementsLabel
    };

    @api achievements
}