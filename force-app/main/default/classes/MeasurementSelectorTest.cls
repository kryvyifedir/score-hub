@IsTest(isParallel=true)
private class MeasurementSelectorTest {
	@IsTest
	private static void sObjectApiName_sObjectNameReturned_nameIsValidated() {
		// Given
		MeasurementSelector selector = MeasurementSelector.getInstance();
		
		// When
		Test.startTest();
		String result = selector.sObjectApiName();
		Test.stopTest();

		// Then 
		Assert.areEqual('Measurement__c', result, 'Measurement__c sObject ApiName is expected');
	}

	@IsTest
	private static void fieldApiNames_sObjectNameReturned_fieldSetIsValidated() {
		// Given
		MeasurementSelector selector = MeasurementSelector.getInstance();
		
		// When
		Test.startTest();
		Set<String> result = selector.fieldApiNames();
		Test.stopTest();

		// Then 
		Set<String> expectedSet = new Set<String> {'Id', 'Name', 'UniqueIdentifier__c', 'Description__c'};
		Assert.areEqual(expectedSet, result, 'A specific field set is expected');
	}
}