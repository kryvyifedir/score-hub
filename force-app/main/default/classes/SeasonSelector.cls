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
}