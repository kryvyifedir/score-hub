import { LightningElement, wire } from 'lwc';
// APEX Controller methods
import getCurrentUserAchievementsList from '@salesforce/apex/AchievementsListController.getCurrentUserAchievementsList';
//Custom Labels
import YourAchievementsLabel from '@salesforce/label/c.YourAchievements';

export default class CurrentUserAchievements extends LightningElement {
    labels = {
        YourAchievementsLabel
    };

    achievementsListUnsorted

    get achievementsList() {
        // a.sort(function(x, y) {
        //     return (x === y)? 0 : x? -1 : 1;
        // });
        return this.achievementsListUnsorted
    }

    // Getting current user info
    @wire(getCurrentUserAchievementsList)
    wiredAchievementsList({ error, data }) {
        if (data) {
            if (data.Success) {
                this.achievementsListUnsorted = data.Success
            } else if (data.Error) {
                console.log(JSON.stringify(data.Error))
            }
        } else if (error) {
            console.log(JSON.stringify(error))
        }
    }
}