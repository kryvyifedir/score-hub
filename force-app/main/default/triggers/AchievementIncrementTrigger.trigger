trigger AchievementIncrementTrigger on AchievementIncrement__e (after insert) {
	if (Trigger.isInsert && Trigger.isAfter) {
		AchievementIncrementHandler.onAfterInsert(Trigger.new);
	}
}