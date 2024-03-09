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
    @api
    get userId() {
        return this.user_id ? this.user_id : Id;
    }

    set userId(value) {
        this.user_id = value;
    }

    user_id;
    reachedAchievement;
    closestAchievement;

    isLoading = false;
    isError;

    @wire(getAchievementById, { achievementId: "$achievementId", userId: "$userId" })
    wiredAchievementData({ error, data }) {
        if (data) {
            if (data.Success) {
                this.reachedAchievement = data.Success
                this.isLoading = false;
            } else if (data.Error) {
                console.log(JSON.stringify(data.Error))
                this.isError = true;
            }
        } else if (error) {
            console.log(JSON.stringify(error))
            this.isError = true;
        }
    }

    @wire(getClosestReachableAchievement, { userId: "$userId" })
    wiredGetClosesReachableAchievement({ error, data }) {
        if (data) {
            if (data.Success) {
                this.closestAchievement = data.Success
                this.isLoading = false;
            } else if (data.Error) {
                console.log(JSON.stringify(data.Error))
                this.isError = true
                this.isLoading = false;
            }
        } else if (error) {
            console.log(JSON.stringify(error))
            this.isError = true
            this.isLoading = false;
        }
    }

    get showReached() {
        return this.reachedAchievement
    }

    get showClosest() {
        return this.closestAchievement && !this.achievementId && !this.reachedAchievement
    }
}