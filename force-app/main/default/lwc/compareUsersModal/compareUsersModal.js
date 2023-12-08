import { LightningElement, api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class CompareUsersModal extends LightningModal {
    @api content;

    handleOkay() {
        this.close('okay');
    }
}