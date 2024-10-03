@IsTest(isParallel=true)
private class UserMeasurementSelectorTest {
	
	@IsTest
	private static void sObjectApiName_sObjectNameReturned_nameIsValidated() {
		// Given
		UserMeasurementSelector selector = UserMeasurementSelector.getInstance();
		
		// When
		Test.startTest();
		String result = selector.sObjectApiName();
		Test.stopTest();

		// Then 
		Assert.areEqual('UserMeasurement__c', result, 'UserMeasurement__c sObject ApiName is expected');
	}

	@IsTest
	private static void fieldApiNames_sObjectNameReturned_fieldSetIsValidated() {
		// Given
		UserMeasurementSelector selector = UserMeasurementSelector.getInstance();
		
		// When
		Test.startTest();
		Set<String> result = selector.fieldApiNames();
		Test.stopTest();

		// Then 
		Set<String> expectedSet = new Set<String> {'Id', 'Name', 'Key__c', 'Measurement__c', 'User__c', 'Value__c'};
		Assert.areEqual(expectedSet, result, 'A specific field set is expected');
	}
}