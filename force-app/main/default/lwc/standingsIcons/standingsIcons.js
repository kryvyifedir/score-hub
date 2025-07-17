import { LightningElement, api } from 'lwc';

export default class StandingsIcons extends LightningElement {
    @api icon

    get first() {
        return this.icon === "1";
    }

    get second() {
        return this.icon === "2";
    }

    get third() {
        return this.icon === "3";
    }
}