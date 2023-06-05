# GameForce

## What is GameForce?
<sub>Note: This is a draft of readme file, it is going to be updated alongside the progress made in the repository.</sub>

GameForce is an opensource project that aims to bring a xbox/playstation-like achievemtns into Salesforce. Gamification is a proven and inobtrusive way to boost engagement and productivity by leveraging the natural competitive instinct in people. It can help employees develop their skills and be more motivated when they have goals to work towards. In fact, gamification can increase productivity by up to 40%! But when it comes to modern CRM and ERP systems this is a rather underutilized approach. GameForce aims to change that!

## Contributing to the project
Contributing to the project is appreciated, but contribution rules are yet to be formilized. Please, contact @kryvyifedir for contribution guidance and rules for now

# Instalation and Configuration
GameForce is distributed through Salesforce AppExhange. It can be found under the link:

## Installing from AppExchange
### WIP

## Post Instalation Configuration
### CONFIGURING SECURITY
### CONFIGURING PAGE LAYOUTS

## Extending Standard functionality
GameForce provides a set of standard achievements that can be used right a way, once post instalation configuration is done (See standard set of achievements below). But, due to the nature of a business, standard achievements might not be enough to be an effective motivational tool. Luckily, GameForce supports creation of Custom Achievements and integration with custom logic through the means of platform events. 
### Creating Custom Achievement
### Utilizing Platform Event to track Progress

# Repository Contents
## Custom sObjects
### [Achievement__c](force-app/main/default/objects/Achievement__c/)
`Achievement__c` sObject stores the list of available achievements.
| Field  | Type | Purpose |
| ------------- | ------------- | ------------- |
| UITitle__c  | Text (255)  | Achievement name shown to user in the UI. Supports plain text and label references |
| UIDescription__c  | Text (255)  | Achievement description shown to user in the UI. Supports plain text and label references |
| Description__c  | Text (32768)  | Achievement description for admin purposes |
| Enabled__c  | Checkbox  | Disables the achievement. "False" by default |
| Goal__c  | Decimal (18:0)  | Numeric goal that user has to achieve for achievement to be considered "reached" for that user  |
| Score__c  | Decimal (18:0) | Number of points granted to user after achievement is "reached". Used for leaderboards |
### [UserStat__c](force-app/main/default/objects/UserStat__c/)
`UserStat__c` sObject is used to track progress towards reaching an achievement for each user
| Field  | Type | Purpose |
| ------------- | ------------- | ------------- |
| UserId__c  | Lookup | Reference to a User |
| Achievement__c  | MasterDetail | Reference to an Achievement |
| CurrentProgress__c  | Decimal (18:0) | Numeric value representing the progress for a specific user towards an Achievement. Once value is equal or greater then value of Achievement__c.Goal__c - Achievement is considered to be "reached"|
| Reached__c  | Checkbox | Marked as true, once Achievement is "reached"|

## Platform events
### [AchievementIncrement__e](force-app/main/default/objects/AchievementIncrement__e/)
Event that has to be used to increment the progress for a specific user towards a specific achievement
| Field  | Type | Purpose |
| ------------- | ------------- | ------------- |
| UserId__c  | Id | Id of a user |
| Achievement__c  | Id | Id of an Achievement |
| Achievement__c  | Number (18:0) | Value that is going to be added to a CurrentProgress__c field in UserStat__c sObject |

### [AchievementReached__e](force-app/main/default/objects/AchievementIncrement__e/)
Event that is fired once user has reached an Achievement. 
| Field  | Type | Purpose |
| ------------- | ------------- | ------------- |
| UserId__c  | Id | Id of a user |
| Achievement__c  | Id | Id of an Achievement |

## Apex Classes
### [AchievementReachedEventsManager](force-app/main/default/classes/AchievementReachedEventsManager/)
Class that hosts the logic related to firing `AchievementReached__e` events once `UserStat__c.CurrentProgress__c` reaches the value saved in `Achievement__c.Goal__c` field

### [AchievementSelector](force-app/main/default/classes/AchievementSelector/)
Class that hosts methods with SOQL queries related to `Achievement__c` sObject

### [TestDataFactory](force-app/main/default/classes/TestDataFactory/)
Data generation methods for unit tests

### [UserStatTriggerHelper](force-app/main/default/classes/TestDataFactory/)
Class that hosts the logic related to the execution of `UserStat__c` sObject trigger

## Permission Sets
### [GameForceAdmin](force-app/main/default/permissionsets/GameForceAdmin.permissionset-meta.xml)
TBD

### [GameForceUser](force-app/main/default/permissionsets/GameForceUser.permissionset-meta.xml)
TBD

