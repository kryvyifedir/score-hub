public with sharing class AchievementsDataHelper {
	public static Map<Id, List<DataWrappers.AchievementCardData>> getAchievementsDataPerUserId(Set<Id> userIds) {
		Map<Id, List<DataWrappers.AchievementCardData>> result = new Map<Id, List<DataWrappers.AchievementCardData>>();
		List<Achievement__c> allAchievements = AchievementSelector.getInstance().getAll();
		Map<String, ReachedAchievement__c> reachedAchievementByKeyMap = new Map<String, ReachedAchievement__c>();
		List<ReachedAchievement__c> reachedAchievements = ReachedAchievementSelector.getInstance().getByFieldValue('User__c', 'IN', userIds);
		for (ReachedAchievement__c reachedAchievement : reachedAchievements) {
			reachedAchievementByKeyMap.put(reachedAchievement.Key__c, reachedAchievement);
		}

		for (Id userId : userIds) {
			if (!result.containsKey(userId)) {
				result.put(userId, new List<DataWrappers.AchievementCardData>());
			}
			List<DataWrappers.AchievementCardData> userAchievements = result.get(userId);

			for (Achievement__c achievement : allAchievements) {
				String key = UniqueKeyFormatter.generateUniqueKey(userId, achievement.Id);
				ReachedAchievement__c reachedAchievement = reachedAchievementByKeyMap.get(key);
				DataWrappers.AchievementCardData achievementCardData = initAchievementCardData(achievement, reachedAchievement);
				userAchievements.add(achievementCardData);
			}
		}

		return result;
	}

	public static DataWrappers.AchievementCardData initAchievementCardData(Achievement__c achievement, ReachedAchievement__c reachedAchievement) {
		DataWrappers.AchievementCardData achievementWrapper = new DataWrappers.AchievementCardData();
		achievementWrapper.id = achievement.Id;
		achievementWrapper.uiTitle = achievement.UITitle__c;
		achievementWrapper.uiDescription = achievement.UIDescription__c;
		if (reachedAchievement != null) {
			achievementWrapper.isReached = true;
			achievementWrapper.ReachedDate = reachedAchievement.CreatedDate.getTime();
		} else {
			achievementWrapper.isReached = false;
			achievementWrapper.ReachedDate = 0;
		}
		return achievementWrapper;
	}
}