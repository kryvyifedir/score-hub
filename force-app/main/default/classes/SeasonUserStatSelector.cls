public with sharing class SeasonUserStatSelector extends BaseSelector {
	
	public static SeasonUserStatSelector getInstance() {
		return new SeasonUserStatSelector();
	}

	public override SObjectType sObjectType() {
		return SeasonUserStat__c.getSobjectType();
	}

	public override Set<SObjectField> queryFields() {
		return new Set<SObjectField> { 
			SeasonUserStat__c.Id, 
			SeasonUserStat__c.Season__c, 
			SeasonUserStat__c.User__c, 
			SeasonUserStat__c.TotalScore__c,
			SeasonUserStat__c.TotalAchievementsReached__c
		};
	}

	public List<SeasonUserStat__c> getTopThreeByScore(Id seasonId) {
		QueryBuilder queryBuilder = selectorQueryBuilder();
		queryBuilder.addFilter(SeasonUserStat__c.Season__c, '=', 'seasonId');
		queryBuilder.addOrderByDesc(SeasonUserStat__c.TotalScore__c);
		queryBuilder.addLimit(3);
		return this.getBy(queryBuilder, new Map<String, Object>{'seasonId' => seasonId});
	}

	public List<SeasonUserStat__c> getTopThreeByCount(Id seasonId) {
		QueryBuilder queryBuilder = selectorQueryBuilder();
		queryBuilder.addFilter(SeasonUserStat__c.Season__c, '=', 'seasonId');
		queryBuilder.addOrderByDesc(SeasonUserStat__c.TotalAchievementsReached__c);
		queryBuilder.addLimit(3);
		return this.getBy(queryBuilder, new Map<String, Object>{'seasonId' => seasonId});
	}
}