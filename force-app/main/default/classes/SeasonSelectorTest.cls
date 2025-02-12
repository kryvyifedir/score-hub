@IsTest(isParallel=true)
private class SeasonSelectorTest {
	@IsTest
	private static void sObjectType_sObjectTypeReturned_nameIsValidated() {
		// Given
		SeasonSelector selector = SeasonSelector.getInstance();
		
		// When
		Test.startTest();
		SObjectType result = selector.sObjectType();
		Test.stopTest();

		// Then 
		Assert.areEqual(Season__c.getSobjectType(), result, 'Season__c sObjectType is expected');
	}

	@IsTest
	private static void queryFields_sObjectFieldsReturned_fieldSetIsValidated() {
		// Given
		SeasonSelector selector = SeasonSelector.getInstance();
		
		// When
		Test.startTest();
		Set<SObjectField> result = selector.queryFields();
		Test.stopTest();

		// Then 
		Set<SObjectField> expectedSet = new Set<SObjectField> { Season__c.Id, Season__c.From__c, Season__c.To__c, Season__c.IsActive__c };
		Assert.areEqual(expectedSet, result, 'A specific field set is expected');
	}
}