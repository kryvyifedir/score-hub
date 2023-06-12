public with sharing class UserStatSelector {
	private static final String FIELDS_LIST = 'Id, Key__c, Name, Achievement__c, CurrentProgress__c, Reached__c, UserId__c';

	public static List<UserStat__c> getByUserIds(Set<Id> userIds) {
		if (userIds.isEmpty()) {
			return new List<UserStat__c>();
		}

		Map<String, Object> binds = new Map<String, Object> { 'userIds' => userIds };
		return Database.queryWithBinds('SELECT ' + FIELDS_LIST + ' FROM UserStat__c WHERE UserId__c IN :userIds', binds, System.AccessLevel.SYSTEM_MODE);
	}

	public static Map<String, UserStat__c> getByKeys(Map<Id, Id> achievementIdsByUserIdsMap) {
		Map<String, UserStat__c> result = new Map<String, UserStat__c>();

		if (achievementIdsByUserIdsMap == null || achievementIdsByUserIdsMap.isEmpty()) {
			return result;
		}

		Set<String> keys = new Set<String>();
		for (Id userId : achievementIdsByUserIdsMap.keySet()) {
			Id achievementId = achievementIdsByUserIdsMap.get(userId);

			keys.add(userId + '-' + achievementId);
		}

		Map<String, Object> binds = new Map<String, Object> { 'keys' => keys };
		List<UserStat__c> stats = Database.queryWithBinds('SELECT ' + FIELDS_LIST + ' FROM UserStat__c WHERE Key__c IN :keys', binds, System.AccessLevel.SYSTEM_MODE);
		if (stats == null || stats.isEmpty()) {
			return result;
		}

		for (UserStat__c stat : stats) {
			result.put(stat.Key__c, stat);
		}

		return result;
	}
}