import { LightningElement, api, wire } from 'lwc';

import hasUtilityAccess from '@salesforce/customPermission/ScoreHubUtilityAccess';

import Id from "@salesforce/user/Id";
import getAchievementById from '@salesforce/apex/ScoreHubNotificationController.getAchievementById'
import getClosestReachableAchievement from '@salesforce/apex/ScoreHubNotificationController.getClosestReachableAchievement'

//Custom Labels
import ErrorLabel from '@salesforce/label/c.Error';
import UnableToRetrieveAchievementsDataLabel from '@salesforce/label/c.UnableToRetrieveAchievementsData';
import Oopslabel from '@salesforce/label/c.Oops';
import YouDontHaveAccessToScoreHubLabel from '@salesforce/label/c.YouDontHaveAccessToScoreHub';

export default class ScoreHubNotification extends LightningElement {
    labels = {
        ErrorLabel, UnableToRetrieveAchievementsDataLabel, Oopslabel, YouDontHaveAccessToScoreHubLabel
    };

    @api achievementId
    @api
    get userId() {
        return this.currentUserId ? this.currentUserId : Id;
    }

    set userId(value) {
        this.currentUserId = value;
    }

    currentUserId;
    reachedAchievement;
    closestAchievement;

    isLoading = false;
    isError;

    @wire(getAchievementById, { achievementId: "$achievementId" })
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

    get userHasUtilityAccess(){
        return hasUtilityAccess;
    }

    get showReached() {
        return this.achievementId
    }

    get showClosest() {
        return !this.achievementId
    }
}