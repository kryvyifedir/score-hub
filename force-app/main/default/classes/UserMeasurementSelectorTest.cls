@IsTest(isParallel=true)
private class UserMeasurementSelectorTest {
	
	@IsTest
	private static void sObjectType_sObjectTypeReturned_nameIsValidated() {
		// Given
		UserMeasurementSelector selector = UserMeasurementSelector.getInstance();
		
		// When
		Test.startTest();
		SObjectType result = selector.sObjectType();
		Test.stopTest();

		// Then 
		Assert.areEqual(UserMeasurement__c.getSobjectType(), result, 'UserMeasurement__c sObject ApiName is expected');
	}

	@IsTest
	private static void queryFields_sObjectFieldsReturned_fieldSetIsValidated() {
		// Given
		UserMeasurementSelector selector = UserMeasurementSelector.getInstance();
		
		// When
		Test.startTest();
		Set<SObjectField> result = selector.queryFields();
		Test.stopTest();

		// Then 
		Set<SObjectField> expectedSet = new Set<SObjectField> { UserMeasurement__c.Id, UserMeasurement__c.Name, UserMeasurement__c.Key__c, UserMeasurement__c.Measurement__c, UserMeasurement__c.User__c, UserMeasurement__c.Value__c };
		Assert.areEqual(expectedSet, result, 'A specific field set is expected');
	}
}