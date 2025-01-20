public with sharing class AchievementSelector extends BaseSelector {

	public static AchievementSelector getInstance() {
		return new AchievementSelector();
	}

	public override SObjectType sObjectType() {
		return Achievement__c.getSobjectType();
	}

	public override Set<SObjectField> queryFields() {
		return new Set<SObjectField> { Achievement__c.Id, Achievement__c.Name, Achievement__c.Description__c, Achievement__c.Goal__c, Achievement__c.Score__c, Achievement__c.UITitle__c, Achievement__c.UIDescription__c, Achievement__c.Measurement__c};
	}
}