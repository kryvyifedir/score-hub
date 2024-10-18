import { LightningElement, api } from 'lwc';
//Custom Labels
import YourAchievementsLabel from '@salesforce/label/c.YourAchievements';

export default class AchievementsList extends LightningElement {
    labels = {
        YourAchievementsLabel
    };

    @api achievements

    get orderedList() {
        let unorderedList = [... this.achievements]
        unorderedList.sort((a, b) => {
            if (a.measurementId.localeCompare(b.measurementId) === 0) {
                return a.name.localeCompare(b.name);
            } else {
                return a.measurementId.localeCompare(b.measurementId);
            }
        });

        return unorderedList
    }
}