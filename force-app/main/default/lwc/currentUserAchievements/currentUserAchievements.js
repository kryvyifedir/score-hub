import { LightningElement, wire } from 'lwc';
// APEX Controller methods
import getCurrentUserAchievementsList from '@salesforce/apex/AchievementsListController.getCurrentUserAchievementsList';
//Custom Labels
import YourAchievementsLabel from '@salesforce/label/c.YourAchievements';

export default class CurrentUserAchievements extends LightningElement {
    labels = {
        YourAchievementsLabel
    };

    achievements

    // Getting current user info
    @wire(getCurrentUserAchievementsList)
    wiredAchievementsList({ error, data }) {
        if (data) {
            if (data.Success) {
                this.achievements = data.Success
            } else if (data.Error) {
                console.log(JSON.stringify(data.Error))
            }
        } else if (error) {
            console.log(JSON.stringify(error))
        }
    }

    get threeMostRecentAchievements() {
        let returnValue = [];
        if (this.achievements) {
            returnValue = [...this.achievements].sort((a, b) => { return b.reachedDate - a.reachedDate });//.slice(0, 4);
        }

        return returnValue;
    }
}