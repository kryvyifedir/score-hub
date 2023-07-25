public with sharing class AchievementSelector {
	private static final String FIELDS_LIST = 
		'Id, ' +
		'Name, ' +
		'Description__c, ' +
		'Enabled__c, ' +
		'Goal__c, ' +
		'Score__c, ' +
		'UITitle__c, ' +
		'UIDescription__c, ' +
		'(SELECT Id, Key__c, User__c, Achievement__c FROM ReachedAchievements__r)';

	public static List<Achievement__c> getByIds(Set<Id> ids) {
		if (ids.isEmpty()) {
			return new List<Achievement__c>();
		}

		Map<String, Object> binds = new Map<String, Object> { 'ids' => ids };
		return Database.queryWithBinds('SELECT ' + FIELDS_LIST + ' FROM Achievement__c WHERE Id IN :ids', binds, System.AccessLevel.SYSTEM_MODE);
	}

	public static Map<Id, Map<String, ReachedAchievement__c>> getReachedAchievementsByAchievementId(Set<Id> ids) {
		Map<Id, Map<String, ReachedAchievement__c>> reachedAchievementByAchievementIdsMap = new Map<Id, Map<String, ReachedAchievement__c>>();

		if (ids.isEmpty()) {
			return reachedAchievementByAchievementIdsMap;
		}

		Map<String, Object> binds = new Map<String, Object> { 'ids' => ids };
		List<Achievement__c> achievements = Database.queryWithBinds('SELECT ' + FIELDS_LIST + ' FROM Achievement__c WHERE Id IN :ids', binds, System.AccessLevel.SYSTEM_MODE);

		for (Achievement__c achievement : achievements) {
			Map<String, ReachedAchievement__c> reachedAchievementsByIdMap = new Map<String, ReachedAchievement__c>();
			List<ReachedAchievement__c> reachedAchievements = achievement.ReachedAchievements__r;
			for (ReachedAchievement__c reachedAchievement : reachedAchievements) {
				reachedAchievementsByIdMap.put(reachedAchievement.Key__c, reachedAchievement);
			}

			reachedAchievementByAchievementIdsMap.put(achievement.Id, reachedAchievementsByIdMap);
		}

		return reachedAchievementByAchievementIdsMap;
	}

	public static Integer getTotalCount() {
		return Database.countQuery('SELECT COUNT() FROM Achievement__c', System.AccessLevel.SYSTEM_MODE);
	}
}