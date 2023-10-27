import { LightningElement, api, wire } from 'lwc';

import Id from "@salesforce/user/Id";
import getAchievementById from '@salesforce/apex/GameForceNotificationController.getAchievementById'
import getClosestReachableAchievement from '@salesforce/apex/GameForceNotificationController.getClosestReachableAchievement'

//Custom Labels
import ErrorLabel from '@salesforce/label/c.Error';

export default class GameForceNotification extends LightningElement {
    labels = {
        ErrorLabel
    };

    @api achievementId
    userId = Id;
    achievement

    isLoading = false;
    isError = true;
    achievementReachedEventReceived

    // @wire(getAchievementById, { achievementId: "$achievementId" })
    // wiredAchievementData({ error, data }) {
    //     if (data) {
    //         if (data.Success) {
    //             this.achievement = data.Success
    //             this.achievementReachedEventReceived = true;
    //             this.isLoading = false;
    //         } else if (data.Error) {
    //             console.log(JSON.stringify(data.Error))
    //             isError = true;
    //         }
    //     } else if (error) {
    //         console.log(JSON.stringify(error))
    //         isError = true;
    //     }
    // }

    // @wire(getClosestReachableAchievement, { userId: "$userId" })
    // wiredGetClosesReachableAchievement({ error, data }) {
    //     if (data) {
    //         if (data.Success) {
    //             this.achievement = data.Success
    //             this.achievementReachedEventReceived = false
    //         } else if (data.Error) {
    //             console.log(JSON.stringify(data.Error))
    //             this.isError = true
    //         }
    //     } else if (error) {
    //         console.log(JSON.stringify(error))
    //         this.isError = true
    //     }
    //     this.isLoading = false;
    // }
}