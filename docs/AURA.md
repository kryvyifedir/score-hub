# Aura LWC wrappers
Aura components are used in the project as an exception and only in cases when Aura wrapper is necessary due to some of the API not being ported to LWC yet. For example - the `GameForceUtility` aura component is a wrapper for the `gameForceNotification` LWC component due to the fact that `lightning:utilityBarAPI` isn't available in LWC yet.

## GameForceUtility 
### General information
`GameForceUtility` is an Aura wrapper for the `gameForceNotification` LWC component. It is necessary because the `lightning:utilityBarAPI` API which is available in Aura components hasn't been ported yet to LWC. 

### Technical design
`GameForceUtility` is built around two APIs: `lightning:empApi` and `lightning:utilityBarAPI` 
- `lightning:empApi` is used to intercept [`AchievementReached__c`](../force-app/main/default/objects/AchievementReached__e/) platform events and to open the utility bar component without user input in case the intercepted event includes information about the current user. See the [`GameForceUtility.cmp onInit()`](../force-app/main/default/aura/GameForceUtility/GameForceUtilityController.js) method for more information
- `lightning:utilityBarAPI` is used to open the utility bar component automatically when a new event is received and includes data relevant to current user

All data processing and rendering is done in a child [gameForceNotification](../force-app/main/default/lwc/gameForceNotification/) LWC component