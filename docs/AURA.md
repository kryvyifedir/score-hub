# Aura LWC wrappers
Aura components are used in the project as an exception and only in cases when Aura wrapper is necessary for LWC due to some of the API not being ported to LWC yet. For example - `GameForceUtility` aura compoenent is a wrapper for `gameForceNotification` LWC component due to the fact that `lightning:utilityBarAPI` isn't available in LWC yet.

## GameForceUtility 
### General information
`GameForceUtility` is an Aura wrapper for `gameForceNotification` LWC component. It is necessary because `lightning:utilityBarAPI` API which is available in Aura components wasn't ported yet to LWC. 

### Technical design
`GameForceUtility` is built around two APIs: `lightning:empApi` and `lightning:utilityBarAPI` 
- `lightning:empApi` is used to intercept [`AchievementReached__c`](../force-app/main/default/objects/AchievementReached__e/) platform events and to open the utility bar component without user input in case the intercepted event includes information about current user. See the [`GameForceUtility.cmp onInit()`](../force-app/main/default/aura/GameForceUtility/GameForceUtilityController.js) method for more information
- `lightning:utilityBarAPI` is used to open the utility bar component automatically when new event is received and includes data relevant for current user

All data processing and rendering is done in a child [gameForceNotification](../force-app/main/default/lwc/gameForceNotification/) LWC component

TEST Change