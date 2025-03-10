@IsTest(isParallel=true)
private class MeasurementSelectorTest {
	@IsTest
	private static void sObjectType_sObjectTypeReturned_nameIsValidated() {
		// Given
		MeasurementSelector selector = MeasurementSelector.getInstance();
		
		// When
		Test.startTest();
		SObjectType result = selector.sObjectType();
		Test.stopTest();

		// Then 
		Assert.areEqual(Measurement__c.getSobjectType(), result, 'Measurement__c sObject ApiName is expected');
	}

	@IsTest
	private static void queryFields_sObjectFieldsReturned_fieldSetIsValidated() {
		// Given
		MeasurementSelector selector = MeasurementSelector.getInstance();
		
		// When
		Test.startTest();
		Set<SObjectField> result = selector.queryFields();
		Test.stopTest();

		// Then 
		Set<SObjectField> expectedSet = new Set<SObjectField> { Measurement__c.Id, Measurement__c.Name, Measurement__c.UniqueIdentifier__c, Measurement__c.Description__c };
		Assert.areEqual(expectedSet, result, 'A specific field set is expected');
	}
}