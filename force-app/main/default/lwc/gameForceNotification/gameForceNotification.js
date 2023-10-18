import { LightningElement, api, wire } from 'lwc';

import Id from "@salesforce/user/Id";
import getAchievementById from '@salesforce/apex/GameForceNotificationController.getAchievementById'
import getClosesReachableAchievement from '@salesforce/apex/GameForceNotificationController.getClosesReachableAchievement'

//Custom Labels
import KeepItUpLabel from '@salesforce/label/c.KeepItUp';
import NoAchievementsUnlockedYetLabel from '@salesforce/label/c.NoAchievementsUnlockedYet';

export default class GameForceNotification extends LightningElement {
    labels = {
        KeepItUpLabel, NoAchievementsUnlockedYetLabel
    };

    @api achievementId
    userId = Id;
    achievement

    isLoading = true;
    achievementReachedEventReceived

    @wire(getAchievementById, { achievementId: "$achievementId" })
    wiredAchievementData({ error, data }) {
        if (data) {
            if (data.Success) {
                this.achievement = data.Success
                this.achievementReachedEventReceived = true;
                this.isLoading = false;
            } else if (data.Error) {
                console.log(JSON.stringify(data.Error))
            }
        } else if (error) {
            console.log(JSON.stringify(error))
        }
    }

    @wire(getClosesReachableAchievement, { userId: "$userId" })
    wiredGetClosesReachableAchievement({ error, data }) {
        if (data) {
            if (data.Success) {
                this.achievement = data.Success
                this.achievementReachedEventReceived = false;
                this.isLoading = false;
            } else if (data.Error) {
                console.log(JSON.stringify(data.Error))
            }
        } else if (error) {
            console.log(JSON.stringify(error))
        }
    }
}