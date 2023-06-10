public with sharing class UserStatMapper {

	Map<Id, Map<Id, UserStat__c>> userStatByAchievementIdAndUserIdMap = new Map<Id, Map<Id, UserStat__c>>();
	
	public UserStatMapper(List<UserStat__c> stats) {
		initMap(stats);
	}

	private void initMap(List<UserStat__c> stats) {
		for (UserStat__c stat : stats) {
			if (!userStatByAchievementIdAndUserIdMap.containsKey(stat.UserId__c)) {
				userStatByAchievementIdAndUserIdMap.put(stat.UserId__c, new Map<Id, UserStat__c>());
			}

			userStatByAchievementIdAndUserIdMap.get(stat.UserId__c).put(stat.Achievement__c, stat);
		}
	}

	public UserStat__c findByUserIdAndAchievementId(Id userId, Id achievementId) {
		return userStatByAchievementIdAndUserIdMap.get(userId)?.get(achievementId);
	}
}