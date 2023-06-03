trigger UserStatTrigger on UserStat__c (after insert, after update) {
	if (Trigger.isAfter) {
		if (Trigger.isInsert) {
			UserStatTriggerHelper.onAfterInsert(Trigger.newMap);
		}

		if (Trigger.isUpdate) {
			UserStatTriggerHelper.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
		}
	}
}