trigger CaseTrigger on Case (after update) {
	if (Trigger.isAfter) {
		if (Trigger.isUpdate) {
			CaseTriggerHandler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
		}
	}
}