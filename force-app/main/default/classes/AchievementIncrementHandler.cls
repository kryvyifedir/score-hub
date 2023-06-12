public with sharing class AchievementIncrementHandler {
	List<AchievementIncrement__e> eventsToProcess = new List<AchievementIncrement__e>();
	Map<Id, User> existingUsersMap = new Map<Id, User>();
	Map<Id, Achievement__c> existingAchievementsMap = new Map<Id, Achievement__c>();
	Map<String, UserStat__c> existingUserStatMap = new Map<String, UserStat__c>();

	Map<String, UserStat__c> statsToUpsert = new Map<String, UserStat__c>();

	public AchievementIncrementHandler(List<AchievementIncrement__e> events) {
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
		for (AchievementIncrement__e event : eventsToProcess) {
			User user = existingUsersMap.get(event.UserId__c);
			Achievement__c achievement = existingAchievementsMap.get(event.Achievement__c);

			if (user == null || achievement == null || event.Increment__c == null || event.Increment__c == 0) {
				// handle issue loging here in Issue #26
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
	}

	private void commitChanges() {
		if (statsToUpsert.isEmpty()) {
			return;
		}

		// Use proper Database class operations and throw events 
		List<Database.UpsertResult> upsertResults = Database.upsert(statsToUpsert.values(), false);
		// Create an error log for each faild upsert record in Issue #26
		/*for (Database.UpsertResult upsertResults : upsertResults) {

		}*/
	}

	public static void onAfterInsert(List<AchievementIncrement__e> events) {
		AchievementIncrementHandler handler = new AchievementIncrementHandler(events);
		handler.processEvents();
	}
}