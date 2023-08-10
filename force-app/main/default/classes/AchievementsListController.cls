public with sharing class AchievementsListController {
	@AuraEnabled(cacheable=true)
	public static Map<String, Object> getCurrentUserAchievementsList(){
		Map<String, Object> result = new Map<String, Object>();
		try {
			List<DataWrappers.AchievementCardData> achievementsList = AchievementsDataHelper.getAchievementsDataPerUserId(new Set<Id>{UserInfo.getUserId()}).get(UserInfo.getUserId());
			result = ControllerResponse.success(achievementsList);
		} catch (Exception e) {
			Logger.saveSingleLog('Unexpected exception caught in AchievementsController. ' + e.getMessage() + '. ' + e.getStackTraceString());
			result = ControllerResponse.error('Unable to get the list of achievements for current user');
		}
		return result;
	}
}