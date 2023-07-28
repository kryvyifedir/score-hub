public with sharing class UserRatingsHelper {
    public static Map<Id, AggregateResult> getTotalScoreAndCountByUser(Set<Id> ids) {
		Map<Id, AggregateResult> result = new Map<Id, AggregateResult>();
		if (ids.isEmpty()) {
			return result;
		}

		Map<String, Object> binds = new Map<String, Object> { 'ids' => ids };
		List<AggregateResult> aggregateResults = Database.queryWithBinds('SELECT User__c, SUM(Score__c)score, COUNT(Id)cnt FROM ReachedAchievement__c WHERE User__c IN :ids GROUP BY User__c ', binds, System.AccessLevel.SYSTEM_MODE);
		for (AggregateResult aggregateResult : aggregateResults) {
			result.put((Id) aggregateResult.get('User__c'), aggregateResult);
		}
	
		return result;
	}
}