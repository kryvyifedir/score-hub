public with sharing class AchievementsInfoController {
	@TestVisible
	private static Boolean throwException = false;

	@AuraEnabled(cacheable=true)
	public static Map<String, Object> getUserAchievementsById(List<Id> userIds){
		Map<String, Object> result = new Map<String, Object>();
		try {
			if (throwException) {
				throw new TestDataFactory.TestException();
			}

			Map<Id, List<DataWrappers.AchievementCardData>> achievementsByUserIdMap = AchievementsDataHelper.getAchievementsDataPerUserId(new Set<Id>(userIds));
			result = ControllerResponse.success(achievementsByUserIdMap);
		} catch (Exception e) {
			Logger.saveSingleLog('Unexpected exception caught in AchievementsController. ' + e.getMessage() + '. ' + e.getStackTraceString());
			result = ControllerResponse.error('Unable to get the list of achievements for current user');
		}
		return result;
	}
}