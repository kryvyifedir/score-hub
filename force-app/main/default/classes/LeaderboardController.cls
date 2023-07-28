public with sharing class LeaderboardController {
	@AuraEnabled(cacheable=true)
	public static Map<String, Object> getTotalNumberOfAchievements() {
		Integer result;
		try {
			result = AchievementSelector.getInstance().getAll().size();
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

		List<User> users = UserSelector.getInstance().getByIds(userIds);
		Map<Id, AggregateResult> reachedAchievementsData = UserRatingsHelper.getTotalScoreAndCountByUser(userIds);
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

	// private static Map<Id, List<AchievementWrapper>> getAchievementsPerUser(Set<Id> userIds) {
	// 	Map<Id, List<AchievementWrapper>> result = new Map<Id, List<AchievementsWrapper>>();
	// 	List<Achievement__c> allAchievements = AchievementSelector.getAll();
	// 	Map<Id, Set<Id>> reachedAchievementIdsByUserId = ReachedAchievementSelector.getReachedAchievementIdsIdByUserIds(userIds);

	// 	for (Id userId : userIds) {
	// 		if (!result.containsKey(userId)) {
	// 			result.put(userId, new List<AchievementsWrapper>());
	// 		}
	// 		List<AchievementsWrapper> userAchievements = result.get(userId);

	// 		for (Achievement__c achievement : allAchievements) {
	// 			AchievementWrapper achievementWrapper = new AchievementWrapper();
	// 			achievementWrapper.id = achievement.Id;
	// 			achievementWrapper.uiTitle = achievement.UITitle__c;
	// 			achievementWrapper.uiDescription = achievement.UIDescription__c;
	// 			if (reachedAchievementIdsByUserId.containsKey(userId) && reachedAchievementIdsByUserId.get(userId).contains(achievement.Id)) {
	// 				achievementWrapper.achieved = true;
	// 			} else {
	// 				achievementWrapper.false = true;
	// 			}
	// 			userAchievements.add(achievementWrapper);
	// 		}
	// 	}

	// 	return result;
	// }
	
	public class UserInfoWrapper {
		@AuraEnabled
		public Id id { get; set; }
		@AuraEnabled
		public String name { get; set; }
		@AuraEnabled
		public String fullPhotoUrl { get; set; }
		@AuraEnabled
		public Decimal numberOfAchievements { get; set; }
		@AuraEnabled
		public Decimal totalScore { get; set; }
	}

	public class AchievementWrapper {
		@AuraEnabled
		public Id id { get; set; }
		@AuraEnabled
		public String uiTitle { get; set; }
		@AuraEnabled
		public String uiDescription { get; set; }
		@AuraEnabled
		public Boolean achieved { get; set; }
	}
}