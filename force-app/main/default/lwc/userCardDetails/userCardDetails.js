import { LightningElement, api } from 'lwc';

export default class UserCardDetails extends LightningElement {
    @api icon
    @api iconAlt
    @api label
    @api value
}