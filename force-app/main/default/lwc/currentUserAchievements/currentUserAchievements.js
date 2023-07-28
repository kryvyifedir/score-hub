import { LightningElement } from 'lwc';
//Custom Labels
import YourAchievementsLabel from '@salesforce/label/c.YourAchievements';

export default class CurrentUserAchievements extends LightningElement {
    labels = {
        YourAchievementsLabel
    };
}