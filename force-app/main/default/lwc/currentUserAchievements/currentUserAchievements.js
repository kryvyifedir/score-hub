import { LightningElement, wire } from 'lwc';
import CurrentUserId from "@salesforce/user/Id";
// APEX Controller methods
import getUserAchievementsById from '@salesforce/apex/AchievementsInfoController.getUserAchievementsById';
//Custom Labels
import YourAchievementsLabel from '@salesforce/label/c.YourAchievements';
import ErrorLabel from '@salesforce/label/c.Error';
import ErrorLoadingAchievementsLabel from '@salesforce/label/c.ErrorLoadingAchievements';
import NoAchievementsFoundLabel from '@salesforce/label/c.NoAchievementsFound';
import ContactAdministratorLabel from '@salesforce/label/c.ContactAdministrator';

export default class CurrentUserAchievements extends LightningElement {
    labels = {
        YourAchievementsLabel,
        ErrorLabel,
        ErrorLoadingAchievementsLabel,
        NoAchievementsFoundLabel,
        ContactAdministratorLabel
    };

    userId = CurrentUserId
    userIds = [CurrentUserId]
    achievements
    isError = false
    isLoading = true

    // Getting current user info
    @wire(getUserAchievementsById, { userIds: "$userIds" })
    wiredAchievementsList({ error, data }) {
        if (data) {
            if (data.Success) {
                this.achievements = data.Success[this.userId]
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

    get showAchievements() {
        return this.achievements && this.achievements.length > 0
    }

    get showEmpty() {
        return !this.isLoading && !(this.achievements && this.achievements.length > 0)
    }
}