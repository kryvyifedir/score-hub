@IsTest(isParallel=true)
private class ReachedAchievementSelectorTest {
	@IsTest
	private static void sObjectType_sObjectTypeReturned_nameIsValidated() {
		// Given
		ReachedAchievementSelector selector = ReachedAchievementSelector.getInstance();
		
		// When
		Test.startTest();
		SObjectType result = selector.sObjectType();
		Test.stopTest();

		// Then 
		Assert.areEqual(ReachedAchievement__c.getSobjectType(), result, 'ReachedAchievement__c sObject ApiName is expected');
	}

	@IsTest
	private static void queryFields_sObjectFieldsReturned_fieldSetIsValidated() {
		// Given
		ReachedAchievementSelector selector = ReachedAchievementSelector.getInstance();
		
		// When
		Test.startTest();
		Set<SObjectField> result = selector.queryFields();
		Test.stopTest();

		// Then 
		Set<SObjectField> expectedSet = new Set<SObjectField> { ReachedAchievement__c.Id, ReachedAchievement__c.Key__c, ReachedAchievement__c.User__c, ReachedAchievement__c.Achievement__c, ReachedAchievement__c.Score__c, ReachedAchievement__c.CreatedDate };
		Assert.areEqual(expectedSet, result, 'A specific field set is expected');
	}
}