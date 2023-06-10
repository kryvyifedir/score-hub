public with sharing class AchievementIncrementHandler {
	List<AchievementIncrement__e> eventsToProcess = new List<AchievementIncrement__e>();
	Map<Id, User> existingUsersMap = new Map<Id, User>();
	Map<Id, Achievement__c> existingAchievementsMap = new Map<Id, Achievement__c>();
	Map<Id, UserStat__c> existingUserStatMap = new Map<Id, UserStat__c>();
	UserStatMapper userStatsMapper;

	List<UserStat__c> statsToInsert = new List<UserStat__c>();
	Map<Id, UserStat__c> statsToUpdate = new Map<Id, UserStat__c>();

	public AchievementIncrementHandler(List<AchievementIncrement__e> events) {
		eventsToProcess = events;
		initExistingSObjectMaps(events);
		initUserStatMapper();
	}

	private void initExistingSObjectMaps(List<AchievementIncrement__e> events) {
		Set<Id> userIdsFromEvents = new Set<Id>();
		Set<Id> achievementIdsFromEvents = new Set<Id>();
		for (AchievementIncrement__e event : events) {
			userIdsFromEvents.add(event.UserId__c);
			achievementIdsFromEvents.add(event.Achievement__c);
		}

		existingUsersMap = new Map<Id, User> (UserSelector.getByIds(userIdsFromEvents));
		existingUserStatMap = new Map<Id, UserStat__c> (UserStatSelector.getByUserIds(userIdsFromEvents));
		existingAchievementsMap = new Map<Id, Achievement__c> (AchievementSelector.getByIds(achievementIdsFromEvents));
	}

	private void initUserStatMapper() {
		userStatsMapper = new UserStatMapper(existingUserStatMap.values());
	}

	public void processEvents() {
		for (AchievementIncrement__e event : eventsToProcess) {
			User user = existingUsersMap.get(event.UserId__c);
			Achievement__c achievement = existingAchievementsMap.get(event.Achievement__c);

			if (user == null || achievement == null) {
				// Add new platform event here
				continue;
			}

			UserStat__c existingStat = userStatsMapper.findByUserIdAndAchievementId(event.UserId__c, event.Achievement__c);
			if (existingStat != null) {
				if (!statsToUpdate.containsKey(existingStat.Id)) {
					statsToUpdate.put(existingStat.Id, existingStat);
				}

				statsToUpdate.get(existingStat.Id).CurrentProgress__c += event.Increment__c;
			} else {
				statsToInsert.add(new UserStat__c(Achievement__c = event.Achievement__c, UserId__c = event.UserId__c, CurrentProgress__c = event.Increment__c));
			}
		}

		this.commitChanges();
	}

	private void commitChanges() {
		statsToInsert.addAll(statsToUpdate.values());
		if (!statsToInsert.isEmpty()) {
			return;
		}

		// Use proper Database class operations and throw events 
		upsert statsToInsert;
	}

	public static void onAfterInsert(List<AchievementIncrement__e> events) {
		AchievementIncrementHandler handler = new AchievementIncrementHandler(events);
		handler.processEvents();
	}
}