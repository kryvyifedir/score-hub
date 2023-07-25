import { LightningElement, wire, track } from 'lwc';
// APEX Controller methods
import getTotalNumberOfAchievements from '@salesforce/apex/LeaderboardController.getTotalNumberOfAchievements';
import getCurrentUserInfo from '@salesforce/apex/LeaderboardController.getCurrentUserInfo';
//Custom Labels
import YourAchievementsLabel from '@salesforce/label/c.YourAchievements';

export default class UserView extends LightningElement {
    labels = {
        YourAchievementsLabel
    };

    // Getting total number of achievements
    @wire(getTotalNumberOfAchievements)
    wiredTotalNumberOfAchievements({ error, data }) {
        if (data) {
            if (data.Success) {
                console.log(JSON.stringify(data.Success))
                this.totalAchievementsCount = data.Success
            } else if (data.Error) {
                console.log(JSON.stringify(data.Error))
            }
        } else if (error) {
            console.log(JSON.stringify(error))
        }
    }

    // Getting current user info
    @wire(getCurrentUserInfo)
    wiredUserInfo({ error, data }) {
        if (data) {
            if (data.Success) {
                this.userInfo = data.Success
            } else if (data.Error) {
                console.log(JSON.stringify(data.Error))
            }
        } else if (error) {
            console.log(JSON.stringify(error))
        }
    }

    @track userInfo
    @track totalAchievementsCount
}