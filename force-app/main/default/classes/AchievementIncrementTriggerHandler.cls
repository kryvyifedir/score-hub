public with sharing class AchievementIncrementTriggerHandler {
	GameForceLogger logger = new GameForceLogger();
	List<AchievementIncrement__e> eventsToProcess = new List<AchievementIncrement__e>();
	Map<Id, User> existingUsersMap = new Map<Id, User>();
	Map<Id, Achievement__c> existingAchievementsMap = new Map<Id, Achievement__c>();
	Map<String, UserStat__c> existingUserStatMap = new Map<String, UserStat__c>();
	Map<String, UserStat__c> statsToUpsert = new Map<String, UserStat__c>();

	public AchievementIncrementTriggerHandler(List<AchievementIncrement__e> events) {
		eventsToProcess = events;
		initExistingSObjectMaps(events);
	}

	private void initExistingSObjectMaps(List<AchievementIncrement__e> events) {
		Set<Id> userIdsFromEvents = new Set<Id>();
		Set<Id> achievementIdsFromEvents = new Set<Id>();
		Map<Id, Id> achievementIdByUserIdsMap = new Map<Id, Id>();
		for (AchievementIncrement__e event : events) {
			userIdsFromEvents.add(event.UserId__c);
			achievementIdsFromEvents.add(event.Achievement__c);
			achievementIdByUserIdsMap.put(event.UserId__c, event.Achievement__c);
		}

		existingUsersMap = new Map<Id, User> (UserSelector.getByIds(userIdsFromEvents));
		existingAchievementsMap = new Map<Id, Achievement__c> (AchievementSelector.getByIds(achievementIdsFromEvents));
		existingUserStatMap = UserStatSelector.getByKeys(achievementIdByUserIdsMap);
	}

	public void processEvents() {
		try {
			for (AchievementIncrement__e event : eventsToProcess) {
				if (!this.validateEvent(event)) {
					continue;
				}

				String upsertMapKey = event.UserId__c + '-' + event.Achievement__c;
				if (statsToUpsert.containsKey(upsertMapKey)) {
					statsToUpsert.get(upsertMapKey).CurrentProgress__c += event.Increment__c;
				} else if (existingUserStatMap.containsKey(upsertMapKey)) {
					statsToUpsert.put(upsertMapKey, existingUserStatMap.get(upsertMapKey));
					statsToUpsert.get(upsertMapKey).CurrentProgress__c += event.Increment__c;
				} else {
					statsToUpsert.put(upsertMapKey, new UserStat__c(Achievement__c = event.Achievement__c, UserId__c = event.UserId__c, CurrentProgress__c = event.Increment__c));
				}
			}

			this.commitChanges();
		} catch (Exception e) {
			logger.addLog('Unexpected exception was caught: ' + e.getMessage(), null, null);
		} finally {
			logger.commitChanges();
		}
	}

	private Boolean validateEvent(AchievementIncrement__e event) {
		User user = existingUsersMap.get(event.UserId__c);
		if (user == null) {
			logger.addLog('User with Id: ' + event.UserId__c + ' haven\'t been found in a system.', event.UserId__c, event.Achievement__c);
			return false;
		}

		Achievement__c achievement = existingAchievementsMap.get(event.Achievement__c);
		if (achievement == null) {
			logger.addLog('Achievement with Id: ' + event.Achievement__c + ' haven\'t been found in a system.', event.UserId__c, event.Achievement__c);
			return false;
		}

		if (event.Increment__c == null || event.Increment__c == 0) {
			logger.addLog('User Stat wasn\'t updated since Increment value is missing', event.UserId__c, event.Achievement__c);
			return false;
		}

		return true;
	}

	private void commitChanges() {
		if (statsToUpsert.isEmpty()) {
			return;
		}

		// Use proper Database class operations and throw events 
		List<Database.UpsertResult> upsertResults = Database.upsert(statsToUpsert.values(), false);
		// Create an error log for each faild upsert record in Issue #26
		for (Database.UpsertResult upsertResult : upsertResults) {
			if (!upsertResult.isSuccess()) {
				for (Database.Error error : upsertResult.getErrors()) {
					logger.addLog('Unable to update User Stat: ' + error.getMessage() , null, null);
				}
			}
		}
	}

	public static void onAfterInsert(List<AchievementIncrement__e> events) {
		try {
			AchievementIncrementTriggerHandler handler = new AchievementIncrementTriggerHandler(events);
			handler.processEvents();
		} catch (Exception e) {
			GameForceLogger.saveSingleLog('AchievementIncrement__e onAfterInsert trigger issue: ' + e.getMessage(), null, null);
		}
	}
}