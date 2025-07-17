public with sharing class SeasonSelector extends BaseSelector {
	
	public static SeasonSelector getInstance() {
		return new SeasonSelector();
	}

	public override SObjectType sObjectType() {
		return Season__c.getSobjectType();
	}

	public override Set<SObjectField> queryFields() {
		return new Set<SObjectField> { Season__c.Id, Season__c.From__c, Season__c.To__c, Season__c.IsActive__c };
	}

	public Season__c getLatestSeason() {
		QueryBuilder queryBuilder = selectorQueryBuilder();
		queryBuilder.addOrderByDesc(Season__c.To__c);
		queryBuilder.addLimit(1);
		List<Season__c> seasons = this.getBy(queryBuilder);
		return (!seasons.isEmpty()) ? seasons[0] : null;
	}

	public Season__c getSeasonWithOffset(Integer offset) {
		QueryBuilder queryBuilder = selectorQueryBuilder();
		queryBuilder.addOrderByDesc(Season__c.To__c);
		queryBuilder.addLimit(1);
		queryBuilder.addOffset(offset);
		List<Season__c> seasons = this.getBy(queryBuilder);
		return (!seasons.isEmpty()) ? seasons[0] : null;
	}

	public Integer getSeasonCount() {
		QueryBuilder queryBuilder = selectorQueryBuilder();
		// Even when cadence is set to month, this is more then enough
		queryBuilder.addLimit(120);
		List<Season__c> seasons = this.getBy(queryBuilder);
		return (!seasons.isEmpty()) ? seasons.size() : 0;
	}
}