public with sharing class AchievementsInfoController {
	@AuraEnabled(cacheable=true)
	public static Map<String, Object> getUserAchievementsById(List<Id> userIds){
		Map<String, Object> result = new Map<String, Object>();
		try {
			Map<Id, List<DataWrappers.AchievementCardData>> achievementsByUserIdMap = AchievementsDataHelper.getAchievementsDataPerUserId(new Set<Id>(userIds));
			result = ControllerResponse.success(achievementsByUserIdMap);
		} catch (Exception e) {
			Logger.saveSingleLog('Unexpected exception caught in AchievementsController. ' + e.getMessage() + '. ' + e.getStackTraceString());
			result = ControllerResponse.error('Unable to get the list of achievements for current user');
		}
		return result;
	}
}