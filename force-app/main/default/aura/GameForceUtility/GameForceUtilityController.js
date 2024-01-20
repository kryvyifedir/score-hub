({
    // Sets an empApi error handler on component initialization
    onInit : function(component, event, helper) {
        const empApi = component.find('empApi');
        const channel = '/event/GameForce__AchievementReached__e';
        const replayId = -1;

        empApi.subscribe(channel, replayId, $A.getCallback(eventReceived => {
            console.log('Received event ', JSON.stringify(eventReceived));
            if (eventReceived.data && eventReceived.data.payload && eventReceived.data.payload.GameForce__UserId__c) {
                var userId = $A.get("$SObjectType.CurrentUser.Id");
                if (userId === eventReceived.data.payload.GameForce__UserId__c) {
                    component.set("v.achievementId", eventReceived.data.payload.GameForce__AchievementId__c);
                    var utilityAPI = component.find("utilitybar");
                    utilityAPI.openUtility();
                }
            }
        }))
        .then(subscription => {
            // Subscription response received.
            // We haven't received an event yet.
            console.log('Subscription request sent to: ', subscription.channel);
        });

        empApi.onError($A.getCallback(error => {
            // console.error for deubgging purposes
            //console.error('EMP API error: ', JSON.stringify(error));
        }));
    }
})
