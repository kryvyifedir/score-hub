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

	public static DataWrappers.AchievementCardData getClosestAchievementForUser(Id userId) {
		DataWrappers.AchievementCardData result = new DataWrappers.AchievementCardData();
		List<Achievement__c> achievements = AchievementSelector.getInstance().getAll();
		Map<Id, Achievement__c> achievementByIdsMap = new Map<Id, Achievement__c>(achievements);

		List<UserMeasurement__c> userMeasurements = UserMeasurementSelector.getInstance().getByFieldValue('User__c', 'IN', new Set<Id>{ userId });
		Map<Id, UserMeasurement__c> userMeasurementsByMeasurementIdMap = new Map<Id, UserMeasurement__c>();
		for (UserMeasurement__c measurement : userMeasurements) {
			userMeasurementsByMeasurementIdMap.put(measurement.Measurement__c, measurement);
		}

		Decimal smallestDelta = 0;
		Achievement__c searchResult = new Achievement__c();
		for (Achievement__c achievement : achievements) {
			if (userMeasurementsByMeasurementIdMap.containsKey(achievement.Measurement__c)) {
				UserMeasurement__c measurement = userMeasurementsByMeasurementIdMap.get(achievement.Measurement__c);
				if (achievement.Goal__c > measurement.Value__c && 
					(achievement.Goal__c - measurement.Value__c < smallestDelta || smallestDelta == 0) ) {
					smallestDelta = achievement.Goal__c - measurement.Value__c;
					searchResult = achievement;
				}
			} else if (achievement.Goal__c < smallestDelta || smallestDelta == 0) {
				smallestDelta = achievement.Goal__c;
				searchResult = achievement;
			}
		}

		// REFACTOR THIS SHIT
		ReachedAchievement__c nullReachedAchievement;
		return AchievementsDataHelper.initAchievementCardData(searchResult, nullReachedAchievement);
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