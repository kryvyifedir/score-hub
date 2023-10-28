# GameForce Platform events
GameForce relies on platfomr events to track changes in user measurements as well as notifying users about unlocked achievements. Platform events are used as a means for integration with the logic outside of the GameForce and obfuscate complex data changes/validations that are required for GameForce to properly track users progress

## AchievementReached__e 
`AchievementReached__e` platform event is fired whenever user reaches a specific achievement.

Payload:
- `AchievementId__c`: Id from `Achievement__c` sObject
- `UserId__c`: User Id

Whenever `AchievementReached__e` platform event is fired, `GameForceUtility` aura component handles the event, and shows a pop-up notification to a user, in case his user id matches the one in eent payload.
Also, `AchievementReachedTrigger` fires a logic that stores the information about reached achievement in `AchievementReached__c` sObject.

## UserMeasurementIncrement__e
`UserMeasurementIncrement__e` platform event is fired whenever there has to be a change of user metric. It is meant to be fired by sObject triggers for a standard list of achievements, or by flows/triggers in case custom achievements are set in a system.

Payload:
- `MeasurementId__c`: Id from `Measurement__c` sObject that needs to be changed
- `UserId__c`: User Id
- `Increment__c`: numeric value that needs to be added/removed from a `UserMeasurement__c` sObject record