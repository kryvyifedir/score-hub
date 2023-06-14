trigger AchievementIncrementTrigger on AchievementIncrement__e (after insert) {
	if (Trigger.isInsert && Trigger.isAfter) {
		AchievementIncrementTriggerHandler.onAfterInsert(Trigger.new);
	}
}