public with sharing class UserRatingsHelper {
	public static Map<Id, AggregateResult> getTotalScoreAndCountByUser(Set<Id> ids) {
		Map<Id, AggregateResult> result = new Map<Id, AggregateResult>();
		if (ids.isEmpty()) {
			return result;
		}

		Map<String, Object> binds = new Map<String, Object> { 'ids' => ids };
		List<AggregateResult> aggregateResults = Database.queryWithBinds('SELECT User__c, SUM(Score__c)score, COUNT(Id)cnt FROM ReachedAchievement__c WHERE User__c IN :ids GROUP BY User__c ', binds, System.AccessLevel.SYSTEM_MODE);
		
		for (AggregateResult aggregateResult : aggregateResults) {
			result.put((Id) aggregateResult.get('SidebarApps__User__c'), aggregateResult);
		}
	
		return result;
	}

	public static List<Id> getTopUsersByScore() {
		Map<String, Object> binds = new Map<String, Object>();
		List<AggregateResult> aggregateResults = Database.queryWithBinds('SELECT User__c, SUM(Score__c)score, COUNT(Id)cnt FROM ReachedAchievement__c GROUP BY User__c ORDER BY SUM(Score__c) DESC LIMIT 10', binds, System.AccessLevel.SYSTEM_MODE);
		List<Id> topUserIds = new List<Id>();
		for (AggregateResult aggregateResult : aggregateResults) {
			topUserIds.add((Id) aggregateResult.get('SidebarApps__User__c'));
		}

		return topUserIds;
	}

	public static List<Id> getTopUsersByAchievementsCount() {
		Map<String, Object> binds = new Map<String, Object>();
		List<AggregateResult> aggregateResults = Database.queryWithBinds('SELECT User__c, SUM(Score__c)score, COUNT(Id)cnt FROM ReachedAchievement__c GROUP BY User__c ORDER BY COUNT(Id) DESC LIMIT 10', binds, System.AccessLevel.SYSTEM_MODE);
		List<Id> topUserIds = new List<Id>();
		for (AggregateResult aggregateResult : aggregateResults) {
			topUserIds.add((Id) aggregateResult.get('SidebarApps__User__c'));
		}

		return topUserIds;
	}
}