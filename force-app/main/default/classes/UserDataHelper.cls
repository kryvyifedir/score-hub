public with sharing class UserDataHelper {
	public static Map<Id, DataWrappers.UserCardData> getUserCardDataById(Set<Id> userIds, Integer allAchievementsCount) {
		Map<Id, DataWrappers.UserCardData> result = new Map<Id, DataWrappers.UserCardData>();
		List<User> users = UserSelector.getInstance().getByIds(userIds);
		Map<Id, AggregateResult> reachedAchievementsData = UserRatingsHelper.getTotalScoreAndCountByUser(userIds);
		for (User user : users) {
			AggregateResult userAchievementsData = reachedAchievementsData.get(user.Id);
			result.put(user.Id, getUserDataFromAggregateResult(user, userAchievementsData, allAchievementsCount));
		}
		return result;
	}

	public static DataWrappers.UserCardData getUserDataFromAggregateResult(User user, AggregateResult userAgResult, Integer allAchievementsCount) {
		DataWrappers.UserCardData userCardData = new DataWrappers.UserCardData();
		userCardData.Id = user.Id;
		userCardData.name = user.Name;
		userCardData.fullPhotoUrl = user.FullPhotoUrl;
		userCardData.totalAchievementsCount = allAchievementsCount;
		userCardData.totalScore = userAgResult != null ? (Decimal) userAgResult.get('score') : 0;
		userCardData.reachedAchievementsCount = userAgResult != null ? (Decimal) userAgResult.get('cnt') : 0;
		return userCardData;
	}
}