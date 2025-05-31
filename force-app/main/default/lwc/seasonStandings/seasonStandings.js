import { LightningElement, api } from 'lwc';

export default class SeasonStandings extends LightningElement {
    @api standings;

    get goldAvatar() {
        return this.getAvatar(this.standings?.[0])
    }

    get silverAvatar() {
        return this.getAvatar(this.standings?.[1])
    }

    get bronzeAvatar() {
        return this.getAvatar(this.standings?.[2])
    }

    get goldName() {
        return this.getName(this.standings?.[0])
    }

    get silverName() {
        return this.getName(this.standings?.[1])
    }

    get bronzeName() {
        return this.getName(this.standings?.[2])
    }

    getAvatar(standing) {
        return standing?.smallPhotoUrl ? standing.smallPhotoUrl : "https://www.lightningdesignsystem.com/assets/images/avatar2.jpg"
    }

    getName(standing) {
        return standing?.name ? standing.name : "no user"
    }
}