public with sharing class ReachedAchievementSelector extends BaseSelector {
	
	public static ReachedAchievementSelector getInstance() {
		return new ReachedAchievementSelector();
	}

	public override SObjectType sObjectType() {
		return ReachedAchievement__c.getSobjectType();
	}

	public override Set<SObjectField> queryFields() {
		return new Set<SObjectField> { ReachedAchievement__c.Id, ReachedAchievement__c.Key__c, ReachedAchievement__c.User__c, ReachedAchievement__c.Achievement__c, ReachedAchievement__c.Score__c, ReachedAchievement__c.CreatedDate };
	}
}