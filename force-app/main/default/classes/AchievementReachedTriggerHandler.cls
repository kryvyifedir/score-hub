public with sharing class AchievementReachedTriggerHandler {
	Logger logger = new Logger();
	List<AchievementReached__e> eventsToProcess = new List<AchievementReached__e>();
	Map<Id, User> existingUsersMap = new Map<Id, User>();
	Map<Id, Map<String, ReachedAchievement__c>> existingReachedAchievementsMap = new Map<Id, Map<String, ReachedAchievement__c>>();
	Map<String, ReachedAchievement__c> reachedAchievementsToInsert = new Map<String, ReachedAchievement__c>();

	public AchievementReachedTriggerHandler(List<AchievementReached__e> events) {
		eventsToProcess = events;
		init(events);
	}

	private void init(List<AchievementReached__e> events) {
		Set<Id> achievementIds = new Set<Id>();
		Set<Id> userIds = new Set<Id>();

		for (AchievementReached__e event : events) {
			achievementIds.add(event.AchievementId__c);
			userIds.add(event.userId__c);
		}

		existingUsersMap = new Map<Id, User> (UserSelector.getByIds(userIds));
		existingReachedAchievementsMap = AchievementSelector.getReachedAchievementsByAchievementId(achievementIds);
	}

	public void processEvents() {
		try {
			for (AchievementReached__e event : eventsToProcess) {
				if (!isValidEvent(event)) {
					continue;
				}

				String userAchievementKey = event.UserId__c + '-' + event.AchievementId__c;
				Map<String, ReachedAchievement__c> reachedAchievements = existingReachedAchievementsMap.get(event.AchievementId__c);
				if (reachedAchievements.isEmpty() || !reachedAchievements.containsKey(userAchievementKey)) {
					ReachedAchievement__c reachedAchievement = new ReachedAchievement__c();
					reachedAchievement.User__c = event.UserId__c;
					reachedAchievement.Achievement__c = event.AchievementId__c;
					reachedAchievementsToInsert.put(userAchievementKey, reachedAchievement);
				}
			}

			commitChanges();
		} catch (Exception e) {
			logger.addLog('Exception caught: ' + e.getMessage() + '. ' + e.getStackTraceString());
		} finally {
			logger.commitChanges();
		}
		
	}

	private Boolean isValidEvent(AchievementReached__e event) {
		Boolean result = true;
		if (!isValidUserId(event.UserId__c)) {
			logger.addLog('Unable to save AchievementReached record: UserId__c ' + event.UserId__c + ' value doesn\'t match any existing User record.');
			result = false;
		}

		if (!isValidAchievementId(event.AchievementId__c)) {
			logger.addLog('Unable to save AchievementReached record: AchievementId__c ' + event.AchievementId__c + ' value doesn\'t match any existing Achievement__c record.');
			result = false;
		}

		return result;
	}

	private void commitChanges() {
		if (reachedAchievementsToInsert.isEmpty()) {
			return;
		}

		Database.SaveResult[] saveResults = Database.insert(reachedAchievementsToInsert.values(), false);
		for (Database.SaveResult saveResult : saveResults) {
			if (!saveResult.isSuccess()) {
				for (Database.Error error : saveResult.getErrors()) {
					logger.addLog('Unable to insert ReachedAchievement__c: ' + error.getMessage());
				}
			}
		}
	}

	private Boolean isValidUserId(Id userId) {
		return existingUsersMap.containsKey(userId);
	}

	private Boolean isValidAchievementId(Id achievementId) {
		return existingReachedAchievementsMap.containsKey(achievementId);
	}

	public static void onAfterInsert(List<AchievementReached__e> events) {
		AchievementReachedTriggerHandler handler = new AchievementReachedTriggerHandler(events);
		handler.processEvents();
	}
}