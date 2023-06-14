trigger UserStatTrigger on UserStat__c (after insert, after update) {
	if (Trigger.isAfter) {
		if (Trigger.isInsert) {
			UserStatTriggerHandler.onAfterInsert(Trigger.newMap);
		}

		if (Trigger.isUpdate) {
			UserStatTriggerHandler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
		}
	}
}