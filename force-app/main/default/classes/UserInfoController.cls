public with sharing class UserInfoController {
	@AuraEnabled(cacheable=true)
	public static Map<String, Object> getCurrentUserInfo() {
		DataWrappers.UserCardData result;
		try {
			Id userId = UserInfo.getUserId();
			Integer allAchievementsCount = AchievementSelector.getInstance().getAll().size();
			result = UserDataHelper.getUserCardDataById(new Set<Id> { userId }, allAchievementsCount).get(userId);
		} catch (Exception e) {
			Logger.saveSingleLog('Unexpected exception caught in UserAchievementsController. ' + e.getMessage() + '. ' + e.getStackTraceString());
			return ControllerResponse.error('Unable to get total achievements count');
		}

		return ControllerResponse.success(result);
	}
}