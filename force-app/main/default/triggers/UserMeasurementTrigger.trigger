trigger UserMeasurementTrigger on UserMeasurement__c (after insert, after update) {
	if (Trigger.isAfter) {
		if (Trigger.isInsert) {
			UserMeasurementTriggerHandler.onAfterInsert(Trigger.newMap);
		}

		if (Trigger.isUpdate) {
			UserMeasurementTriggerHandler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
		}
	}
}