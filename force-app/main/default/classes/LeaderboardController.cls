public with sharing class LeaderboardController {
	
	@AuraEnabled(cacheable=true)
	public static Map<String, Object> getTotalNumberOfAchievements() {
		Integer result;
		try {
			result = AchievementSelector.getTotalCount();
		} catch (Exception e) {
			Logger.saveSingleLog('Unexpected exception caught in UserAchievementsController. ' + e.getMessage() + '. ' + e.getStackTraceString());
			return ControllerResponse.error('Unable to get total achievements count');
		}

		return ControllerResponse.success(result);
	}

	@AuraEnabled(cacheable=true)
	public static Map<String, Object> getCurrentUserInfo() {
		UserInfoWrapper result;
		try {
			Id userId = UserInfo.getUserId();
			result = getUserInfoById(new Set<Id> { userId }).get(userId);
		} catch (Exception e) {
			Logger.saveSingleLog('Unexpected exception caught in UserAchievementsController. ' + e.getMessage() + '. ' + e.getStackTraceString());
			return ControllerResponse.error('Unable to get total achievements count');
		}

		return ControllerResponse.success(result);
	}

	private static Map<Id, UserInfoWrapper> getUserInfoById(Set<Id> userIds) {
		Map<Id, UserInfoWrapper> result = new Map<Id, UserInfoWrapper>();

		List<User> users = UserSelector.getByIds(userIds);
		Map<Id, AggregateResult> reachedAchievementsData = ReachedAchievementSelector.getGroupedScoreAndCountByUser(userIds);
		for (User user : users) {
			AggregateResult userAchievementsData = reachedAchievementsData.get(user.Id);
			UserInfoWrapper userInfoWrapper = new UserInfoWrapper();
			userInfoWrapper.Id = user.Id;
			userInfoWrapper.name = user.Name;
			userInfoWrapper.fullPhotoUrl = user.FullPhotoUrl;
			userInfoWrapper.totalScore = (Decimal) userAchievementsData?.get('score');
			userInfoWrapper.numberOfAchievements = (Decimal) userAchievementsData?.get('cnt');
			result.put(user.Id, userInfoWrapper);
		}
		return result;
	}
	
	public class UserInfoWrapper {
		@AuraEnabled
		public Id Id { get; set; }
		@AuraEnabled
		public String name { get; set; }
		@AuraEnabled
		public String fullPhotoUrl { get; set; }
		@AuraEnabled
		public Decimal numberOfAchievements { get; set; }
		@AuraEnabled
		public Decimal totalScore { get; set; }
	}
}