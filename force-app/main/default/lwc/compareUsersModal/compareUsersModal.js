import { LightningElement, api, wire } from 'lwc';
import LightningModal from 'lightning/modal';

// APEX Controller methods
import getUserInfoById from '@salesforce/apex/UserInfoController.getUserInfoById';

export default class CompareUsersModal extends LightningModal {
    @api content;
    userInfo1
    userInfo2

    // Getting current user info
    @wire(getUserInfoById, { userIds: "$content" })
    wiredUserInfo({ error, data }) {
        if (data) {
            if (data.Success) {
                this.userInfo1 = data.Success[this.content[0]]
                console.log(JSON.stringify(this.userInfo1))
                this.userInfo2 = data.Success[this.content[1]]
                console.log(JSON.stringify(this.userInfo2))
            } else if (data.Error) {
                console.log(JSON.stringify(data.Error))
            }
        } else if (error) {
            console.log(JSON.stringify(error))
        }
    }

    handleOkay() {
        this.close('okay');
    }
}