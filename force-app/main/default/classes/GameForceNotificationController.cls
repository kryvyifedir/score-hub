public with sharing class GameForceNotificationController {
	@TestVisible
	private static Boolean throwException = false;

	@AuraEnabled(cacheable=true)
	public static Map<String, Object> getAchievementById(String achievementId, String userId){
		Map<String, Object> result = new Map<String, Object>();
		try {
			if (throwException) {
				throw new TestDataFactory.TestException();
			}

			List<Achievement__c> achievements = AchievementSelector.getInstance().getByIds(new Set<Id> { achievementId });
			List<ReachedAchievement__c> reachedInformation = ReachedAchievementSelector.getInstance().getByFieldValue('Key__c', '=', UniqueKeyFormatter.generateUniqueKey(userId, achievementId));
			
			if (achievements == null || achievements.isEmpty()) {
				return ControllerResponse.success(null);
			} else {
				if (reachedInformation == null || reachedInformation.isEmpty()) {
					result = ControllerResponse.success(AchievementsDataHelper.initAchievementCardData(achievements[0]));
				} else {
					result = ControllerResponse.success(AchievementsDataHelper.initAchievementCardData(achievements[0], reachedInformation[0]));
				}
			}
		} catch (Exception e) {
			Logger.saveSingleLog('Unexpected exception caught in GameForceNotificationController. ' + e.getMessage() + '. ' + e.getStackTraceString());
			result = ControllerResponse.error('Unable to get Achievement by Id');
		}
		return result;
	}

	@AuraEnabled(cacheable=true)
	public static Map<String, Object> getClosestReachableAchievement(String userId){
		Map<String, Object> result = new Map<String, Object>();
		try {
			if (throwException) {
				throw new TestDataFactory.TestException();
			}

			DataWrappers.AchievementCardData closestAchievement = AchievementsDataHelper.getClosestAchievementForUser(userId);
			result = ControllerResponse.success(closestAchievement);
		} catch (Exception e) {
			Logger.saveSingleLog('Unexpected exception caught in LeaderboardController. ' + e.getMessage() + '. ' + e.getStackTraceString());
			result = ControllerResponse.error('Unable to get the closes achievement by user Id');
		}
		return result;
	}
}