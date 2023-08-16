@IsTest(isParallel=true)
private class ReachedAchievementSelectorTest {
	@IsTest
	private static void sObjectApiName_sObjectNameReturned_nameIsValidated() {
		// Given
		ReachedAchievementSelector selector = ReachedAchievementSelector.getInstance();
		
		// When
		Test.startTest();
		String result = selector.sObjectApiName();
		Test.stopTest();

		// Then 
		system.assertEquals('ReachedAchievement__c', result, 'ReachedAchievement__c sObject ApiName is expected');
	}

	@IsTest
	private static void fieldApiNames_sObjectNameReturned_fieldSetIsValidated() {
		// Given
		ReachedAchievementSelector selector = ReachedAchievementSelector.getInstance();
		
		// When
		Test.startTest();
		Set<String> result = selector.fieldApiNames();
		Test.stopTest();

		// Then 
		Set<String> expectedSet = new Set<String> {'Id', 'Key__c', 'User__c', 'Achievement__c', 'Score__c', 'CreatedDate'};
		system.assertEquals(expectedSet, result, 'A specific field set is expected');
	}
}