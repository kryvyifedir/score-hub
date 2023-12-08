public with sharing class UserInfoController {
	@AuraEnabled(cacheable=true)
	public static Map<String, Object> getUsersInfo(List<Id> userIds) {
		Map<Id, DataWrappers.UserCardData> result = new Map<Id, DataWrappers.UserCardData>();
		try {
			Integer allAchievementsCount = AchievementSelector.getInstance().getAll().size();
			result = UserDataHelper.getUserCardDataById(new Set<Id>(userIds), allAchievementsCount);
		} catch (Exception e) {
			Logger.saveSingleLog('Unexpected exception caught in UserInfoController. ' + e.getMessage() + '. ' + e.getStackTraceString());
			return ControllerResponse.error('Unable to get total achievements count');
		}

		return ControllerResponse.success(result);
	}
}