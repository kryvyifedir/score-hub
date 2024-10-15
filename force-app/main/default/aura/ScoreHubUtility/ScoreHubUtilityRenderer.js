({
    unrender : function(component, helper) {
        this.superUnrender();
        // Clean up event subscription
        var empApi = component.find("empApi");
        const subscription = component.get('v.subscription');
        empApi.unsubscribe(subscription, $A.getCallback(unsubscribed => {
            console.log('Unsubscribed from channel '+ unsubscribed.subscription);
            component.set('v.subscription', null);
        }));
    }
})
