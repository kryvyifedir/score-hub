trigger UserMeasurementIncrementTrigger on UserMeasurementIncrement__e (after insert) {
	if (Trigger.isAfter) {
		UserMeasurementIncrementTriggerHandler.onAfterInsert(Trigger.new);
	}
}