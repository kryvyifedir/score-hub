import { LightningElement, api } from 'lwc';

export default class CardLine extends LightningElement {
    @api icon
    @api iconAlt
    @api label
    @api value
}