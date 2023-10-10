import { LightningElement } from 'lwc';
//Custom Labels
import KeepItUpLabel from '@salesforce/label/c.KeepItUp';
import NoAchievementsUnlockedYetLabel from '@salesforce/label/c.NoAchievementsUnlockedYet';

export default class GameForceNotification extends LightningElement {
    labels = {
        KeepItUpLabel, NoAchievementsUnlockedYetLabel
    };

    isLoading
    achievementReachedEventReceived = true

}