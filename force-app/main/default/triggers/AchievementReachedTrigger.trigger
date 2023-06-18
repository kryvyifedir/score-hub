trigger AchievementReachedTrigger on AchievementReached__e (after insert) {
	try {
		if (Trigger.isAfter && Trigger.isInsert) {
			AchievementReachedTriggerHandler.onAfterInsert(Trigger.new);
		}
	} catch (Exception e) {
		Logger.saveSingleLog('Unexpected exception caught in AchievementReachedTrigger. ' + e.getMessage() + '. ' + e.getStackTraceString());
	}
}