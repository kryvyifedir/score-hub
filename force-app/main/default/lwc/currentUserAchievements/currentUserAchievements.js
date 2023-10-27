import { LightningElement, wire } from 'lwc';
// APEX Controller methods
import getCurrentUserAchievementsList from '@salesforce/apex/AchievementsListController.getCurrentUserAchievementsList';
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

    achievements
    showError

    // Getting current user info
    @wire(getCurrentUserAchievementsList)
    wiredAchievementsList({ error, data }) {
        if (data) {
            if (data.Success) {
                this.achievements = data.Success
            } else if (data.Error) {
                console.log(JSON.stringify(data.Error))
                this.showError = true
            }
        } else if (error) {
            console.log(JSON.stringify(error))
            this.showError = true
        }
    }

    get achievementsByDate() {
        let returnValue = [];
        if (this.achievements) {
            returnValue = [...this.achievements].sort((a, b) => { return b.reachedDate - a.reachedDate });
        }

        return returnValue;
    }

    get showAchievements() {
        return this.achievements && this.achievements.length > 0
    }
}