import { LightningElement, wire, track } from 'lwc';
import CurrentUserId from "@salesforce/user/Id";

// APEX Controller methods
import getUsersInfo from '@salesforce/apex/UserInfoController.getUsersInfo';

export default class UserView extends LightningElement {
    userId = CurrentUserId
    userIds = [CurrentUserId]
    userInfo

    // Getting current user info
    @wire(getUsersInfo, { userIds: "$userIds" })
    wiredUserInfo({ error, data }) {
        if (data) {
            if (data.Success) {
                this.userInfo = data.Success[this.userId]
            } else if (data.Error) {
                console.log(JSON.stringify(data.Error))
            }
        } else if (error) {
            console.log(JSON.stringify(error))
        }
    }

}