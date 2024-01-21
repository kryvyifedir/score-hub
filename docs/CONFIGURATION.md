# Installing from AppExchange
WIP

# Post Instalation Configuration
## Security Configuration
GameForce comes with a wide set of Permission Sets that are combined into 2 Permission Set groups. It is not recommended to assign Permission Sets directly to users. Insted Permission Set Groups are expected to be assigned: 
* GameForce Admin - For admin users and users that are expected to configure new Achievements
* GameForce User - For all other users that are expected to use GameForce and get Achievements

You can check detailed description of Permission Sets and Permission Set Groups you can check [Security Wiki Page](https://github.com/kryvyifedir/game-force/wiki/Security)

## Extending standard functionality with custom Achievements
GameForce provides a set of standard achievements that can be used right a way, once post instalation configuration is done (See standard set of achievements below). But, due to the nature of a business, standard achievements might not be enough to be an effective motivational tool. Luckily, GameForce supports creation of Custom Achievements and integration with custom logic through the means of platform events. 

### List of standard achievements:
| ## | Achievement name | Description | Score |
| -- | ---------------- | ----------- | ----- |
| 01 | Sourcer | Create 10 Leads  | 10 |
| 02 | Tracker | Create 50 Leads  | 20 |
| 03 | Hunter  | Create 100 Leads | 50 |
| 04 | Ninja   | Create 200 Leads | 100 |
| 05 | Converter    | Convert 10 Leads  | 10 |
| 06 | Transformer  | Convert 50 Leads  | 20 |
| 07 | Metamorphist | Convert 100 Leads | 100 |
| 08 | Closer        | Complete 10 Tasks  | 10 |
| 09 | Taskmaster    | Complete 50 Tasks  | 20 |
| 10 | Completionist | Complete 100 Tasks | 20 |
| 11 | Executor      | Complete 200 Tasks | 100 |
| 12 | Enthusiast   | Post 10 Chatter Posts  | 10 |
| 13 | Messenger    | Post 50 Chatter Posts  | 10 |
| 14 | Collaborator | Post 100 Chatter Posts | 20 |
| 15 | Team Player  | Post 200 Chatter Posts | 50 |
| 16 | Detective  | Close 10 Cases  | 10  |
| 17 | Watson     | Close 50 Cases  | 20  |
| 18 | Sherlock   | Close 100 Cases | 100 |

### Creating Custom Achievement:
GameForce allows and encourages you to setup a custom set of achievements that suite your use cases better than our standard set of achievements.

Here is how the new custom achievement can be configured: 
1. Create a Measurement that would define what kind of statistics is meant to be gathered for the user _(for e.g.: number of created Opportunities with Amount more than 1000 USD)_. To do this, you would need to create new records in Measurements__c sObject:

    * UniqueIdentifier__c - field value should contain a unique name for the metric. You can use any unique value, but we recomend you to use this format: CreatedOppsWithAmoutGreater1KCounter
    * Description__c - Explanation/Justification behind the metric that you are gathering.

    _**NOTE:** You can use our standard measurement to configure your custom achievement_

2. Once the measurement is created, you can create the new Achievement__c sObject that would define the achievement:

    * Measurement__c - Id of a measurement that you've created in aprevious step.
    * Name - Name for the achievement. Used by admins and won't be shown in the UI
    * UITitle__c - Achievement name that is going to be shown to user once he unlocks the achievement
    * UIDescription__c - Achievement description that is going to be shown to user once he unlocks the achievement
    * Goal__c - Goal that need to be reached by user for achievement to be treated as unlocked/reached. For example, our standard "Create 10 Leads" achievement has a Goal__c set to 10 and is related to relevant measurement called "CreatedLeadsCounter". Once user has 10 Created Leads - achievement is going to be treated as unlocked.
    * Score__c - Number of points that user gets for unlocking an achievement. Used for leaderboards.
    * Enabled__c - Allows Admin users to enable/disable achievements without removing data from the system. 
3. Once both Measurement and Achievement are defined, you can now define the logic for your new measurement to be increased per each user. This can be done in a trigger or by no-code tools built into Salesforce. In the end, each time the metric is expected to be increased for a specific user `UserMeasurementIncrement__e` platform event has to be fired by your custom logic. 
`UserMeasurementIncrement__e` fields: 
    * Increment__c - number of points to increment/decrement from a user measurement
    * MeasurementId__c - Id of the measurement that you want to change for the user
    * User Id - Id of the user

Once `UserMeasurementIncrement__e` event is fired - our internal logic will handle everything else for you.

