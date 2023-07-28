@IsTest(isParallel=true)
private class AchievementSelectorTest {

	@IsTest
	private static void sObjectApiName_sObjectNameReturned_nameIsValidated() {
		// Given
		AchievementSelector selector = AchievementSelector.getInstance();
		
		// When
		Test.startTest();
		String result = selector.sObjectApiName();
		Test.stopTest();

		// Then 
		system.assertEquals('Achievement__c', result, 'Achievement__c sObject ApiName is expected');
	}

	@IsTest
	private static void fieldApiNames_sObjectNameReturned_fieldSetIsValidated() {
		// Given
		AchievementSelector selector = AchievementSelector.getInstance();
		
		// When
		Test.startTest();
		Set<String> result = selector.fieldApiNames();
		Test.stopTest();

		// Then 
		Set<String> expectedSet = new Set<String> {'Id', 'Name', 'Description__c', 'Enabled__c', 'Goal__c', 'Score__c', 'UITitle__c', 'UIDescription__c', 'Measurement__c'};
		system.assertEquals(expectedSet, result, 'A specific field set is expected');
	}
}