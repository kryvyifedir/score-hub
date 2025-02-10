trigger SeasonTrigger on Season__c (after insert) {
    if (Trigger.isAfter) {
		if (Trigger.isInsert) {
			SeasonTriggerHandler.onAfterInsert(Trigger.newMap);
		}
    }
}