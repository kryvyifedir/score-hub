public with sharing class AchievementIncrementHandler {

	public static void onAfterInsert(List<AchievementIncrement__e> events) {
		// SPLIT THIS SPAGHETTI
		List<UserStat__c> statsToInsert = new List<UserStat__c>();
		Map<Id, UserStat__c> statsToUpdate = new Map<Id, UserStat__c>();
		
		Set<Id> userIds = new Set<Id>();
		Set<Id> achievementIds = new Set<Id>();
		for (AchievementIncrement__e event : events) {
			userIds.add(event.UserId__c);
			achievementIds.add(event.Achievement__c);
		}

		// CHANGE TO USER SELECTOR
		Map<Id, User> usersMap = new Map<Id, User> ([SELECT ID FROM User WHERE Id IN :userIds]);
		Map<Id, Achievement__c> achievementsMap = new Map<Id, Achievement__c> (AchievementSelector.getByIds(achievementIds));

		List<UserStat__c> existingStats = UserStatSelector.getByUserIds(userIds);
		UserStatMapper existingStatsMapper = new UserStatMapper(existingStats);

		for (AchievementIncrement__e event : events) {
			User user = usersMap.get(event.UserId__c);
			Achievement__c achievement = achievementsMap.get(event.Achievement__c);

			if (user == null || achievement == null) {
				continue;
			}

			UserStat__c existingStat = existingStatsMapper.findByUserIdAndachievementId(event.UserId__c, event.Achievement__c);
			if (existingStat != null) {
				if (!statsToUpdate.containsKey(existingStat.Id)) {
					statsToUpdate.put(existingStat.Id, existingStat);
				}

				statsToUpdate.get(existingStat.Id).CurrentProgress__c += event.Increment__c;
			} else {
				statsToInsert.add(new UserStat__c(Achievement__c = event.Achievement__c, UserId__c = event.UserId__c, CurrentProgress__c = event.Increment__c));
			}
		}

		statsToInsert.addAll(statsToUpdate.values());
		if (!statsToInsert.isEmpty()) {
			// Use proper Database class operations
			upsert statsToInsert;
		}
	}
}