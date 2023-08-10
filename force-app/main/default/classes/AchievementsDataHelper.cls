public with sharing class AchievementsDataHelper {
	public static Map<Id, List<DataWrappers.AchievementCardData>> getAchievementsDataPerUserId(Set<Id> userIds) {
		Map<Id, List<DataWrappers.AchievementCardData>> result = new Map<Id, List<DataWrappers.AchievementCardData>>();
		List<Achievement__c> allAchievements = AchievementSelector.getInstance().getAll();
		Map<Id, Set<Id>> reachedAchievementIdsByUserId = new Map<Id, Set<Id>>();
		List<ReachedAchievement__c> reachedAchievements = ReachedAchievementSelector.getInstance().getByFieldValue('User__c', 'IN', userIds);
		for (ReachedAchievement__c reachedAchievement : reachedAchievements) {
			if (!reachedAchievementIdsByUserId.containsKey(reachedAchievement.User__c)) {
				reachedAchievementIdsByUserId.put(reachedAchievement.User__c, new Set<Id>());
			} 
			reachedAchievementIdsByUserId.get(reachedAchievement.User__c).add(reachedAchievement.Achievement__c);
		}

		for (Id userId : userIds) {
			if (!result.containsKey(userId)) {
				result.put(userId, new List<DataWrappers.AchievementCardData>());
			}
			List<DataWrappers.AchievementCardData> userAchievements = result.get(userId);

			for (Achievement__c achievement : allAchievements) {
				Boolean isReached = reachedAchievementIdsByUserId.containsKey(userId) && reachedAchievementIdsByUserId.get(userId).contains(achievement.Id);
				DataWrappers.AchievementCardData achievementCardData = initAchievementCardData(achievement, isReached);
				userAchievements.add(achievementCardData);
			}
		}

		return result;
	}

	public static DataWrappers.AchievementCardData initAchievementCardData(Achievement__c achievement, Boolean isReached) {
		DataWrappers.AchievementCardData achievementWrapper = new DataWrappers.AchievementCardData();
		achievementWrapper.id = achievement.Id;
		achievementWrapper.uiTitle = achievement.UITitle__c;
		achievementWrapper.uiDescription = achievement.UIDescription__c;
		achievementWrapper.isReached = isReached;
		return achievementWrapper;
	}
}