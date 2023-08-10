import { LightningElement, wire, track } from 'lwc';
// APEX Controller methods
import getCurrentUserInfo from '@salesforce/apex/UserInfoController.getCurrentUserInfo';

export default class UserView extends LightningElement {

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