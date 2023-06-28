trigger AchievementReachedTrigger on AchievementReached__e (after insert) {
	if (Trigger.isAfter && Trigger.isInsert) {
		AchievementReachedTriggerHandler.onAfterInsert(Trigger.new);
	}
}