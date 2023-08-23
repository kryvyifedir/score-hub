public with sharing class LeaderboardController {
	
	@TestVisible
	private static Boolean throwException = false;

	@AuraEnabled(cacheable=true)
	public static Map<String, Object> getTopUsersByScore(){
		Map<String, Object> result = new Map<String, Object>();
		try {
			if (throwException) {
				throw new TestDataFactory.TestException();
			}
 
			Set<Id> topUserIds = new Set<Id>(UserRatingsHelper.getTopUsersByScore());
			Integer allAchievementsCount = AchievementSelector.getInstance().getAll().size();
			Map<Id, DataWrappers.UserCardData> userCardsInfo = UserDataHelper.getUserCardDataById(topUserIds, allAchievementsCount);
			result = ControllerResponse.success(userCardsInfo.values());
		} catch (Exception e) {
			Logger.saveSingleLog('Unexpected exception caught in LeaderboardController. ' + e.getMessage() + '. ' + e.getStackTraceString());
			result = ControllerResponse.error('Unable to get the top 10 users by Score');
		}
		return result;
	}

	@AuraEnabled(cacheable=true)
	public static Map<String, Object> getTopUsersByAchievementsCount(){
		Map<String, Object> result = new Map<String, Object>();
		try {
			if (throwException) {
				throw new TestDataFactory.TestException();
			}

			Set<Id> topUserIds = new Set<Id>(UserRatingsHelper.getTopUsersByAchievementsCount());
			Integer allAchievementsCount = AchievementSelector.getInstance().getAll().size();
			Map<Id, DataWrappers.UserCardData> userCardsInfo = UserDataHelper.getUserCardDataById(topUserIds, allAchievementsCount);
			result = ControllerResponse.success(userCardsInfo.values());
		} catch (Exception e) {
			Logger.saveSingleLog('Unexpected exception caught in LeaderboardController. ' + e.getMessage() + '. ' + e.getStackTraceString());
			result = ControllerResponse.error('Unable to get the top 10 users by Achievements Count');
		}
		return result;
	}
}