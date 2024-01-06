trigger TaskTrigger on Task (after insert, after update) {
	if (Trigger.isAfter) {
		if (Trigger.isInsert) {
			TaskTriggerHandler.onAfterInsert(Trigger.newMap);
		}

		if (Trigger.isUpdate) {
			TaskTriggerHandler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
		}
	}
}