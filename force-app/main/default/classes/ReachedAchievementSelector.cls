public with sharing class ReachedAchievementSelector {
	private static final String FIELDS_LIST = 'Id, Key__c, User__c, Achievement__c, Score__c';

	public static Map<Id, AggregateResult> getGroupedScoreAndCountByUser(Set<Id> userIds) {
		Map<Id, AggregateResult> result = new Map<Id, AggregateResult>();
		if (userIds.isEmpty()) {
			return result;
		}

		Map<String, Object> binds = new Map<String, Object> { 'userIds' => userIds };
		List<AggregateResult> aggregateResults = Database.queryWithBinds('SELECT User__c, SUM(Score__c)score, COUNT(Id)cnt FROM ReachedAchievement__c WHERE User__c IN :userIds GROUP BY User__c ', binds, System.AccessLevel.SYSTEM_MODE);
		for (AggregateResult aggregateResult : aggregateResults) {
			result.put((Id) aggregateResult.get('User__c'), aggregateResult);
		}
	
		return result;
	}

	// public static Map<String, ReachedAchievement__c> getReachedAchievementsByKey(Set<String> keys) {
	// 	Map<String, ReachedAchievement__c> result = new Map<String, ReachedAchievement__c>();
	// 	if (keys.isEmpty()) {
	// 		return result;
	// 	}

	// 	Map<String, Object> binds = new Map<String, Object> { 'keys' => keys };
	// 	List<ReachedAchievement__c> reachedAchievements = Database.queryWithBinds('SELECT ' + FIELDS_LIST + ' FROM reachedAchievement WHERE Id Key__c : keys', binds, System.AccessLevel.SYSTEM_MODE);
	// 	for (ReachedAchievement__c reachedAchievement : reachedAchievements) {
	// 		result.put(reachedAchievement.Key__c, reachedAchievement);
	// 	}
	// 	return result;
	// }

	// public static Map<Id, Set<Id>> getReachedAchievementIdsIdByUserIds(Set<Id> userIds) {
	// 	Map<Id, Set<Id>> result = new Map<Id, Set<Id>>();
	// 	if (userIds.isEmpty()) {
	// 		return result;
	// 	}

	// 	Map<String, Object> binds = new Map<String, Object> { 'userIds' => userIds };
	// 	List<ReachedAchievement__c> reachedAchievements = Database.queryWithBinds('SELECT ' + FIELDS_LIST + ' FROM ReachedAchievement__c WHERE User__c IN :userIds', binds, System.AccessLevel.SYSTEM_MODE);
	// 	for (ReachedAchievement__c reachedAchievement : reachedAchievements) {
	// 		if (!result.containsKey(reachedAchievement.User__c)) {
	// 			result.put(reachedAchievement.User__c, new Set<Id>());
	// 		}
	// 		result.get(reachedAchievement.User__c).add(reachedAchievement.Achievement__c);
	// 	}
	// }
}