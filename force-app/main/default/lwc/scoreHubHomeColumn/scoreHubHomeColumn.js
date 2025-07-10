import { LightningElement, api } from 'lwc';

export default class ScoreHubHomeColumn extends LightningElement {
    @api hideHeader

    get showHeader() {
        return !this.hideHeader
    }
}