import { LightningElement } from 'lwc';
//Custom Labels
import YourAchievementsLabel from '@salesforce/label/c.YourAchievements';

export default class AchievementsList extends LightningElement {
    labels = {
        YourAchievementsLabel
    };
    
    achievements = [
        {
          Id: 1,
          UITitle: "Achievement 1",
          UIDescription: "Achievement 1 description long long description",
          Achieved: true
        },
        {
          Id: 2,
          UITitle: "Achievement 2",
          UIDescription: "Achievement 2 description long long even longer description",
          Achieved: true
        },
        {
          Id: 3,
          UITitle: "Achievement 3",
          UIDescription: "Achievement 3 description short",
          Achieved: false
        },
        {
          Id: 4,
          UITitle: "Achievement 4",
          UIDescription: "Achievement 4 description short",
          Achieved: false
        },
        {
          Id: 5,
          UITitle: "Achievement 5",
          UIDescription: "Achievement 5 description short",
          Achieved: false
        },
      ];
}