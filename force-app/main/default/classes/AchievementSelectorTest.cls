@IsTest(isParallel=true)
private class AchievementSelectorTest {

	@IsTest
	private static void sObjectType_sObjectTypeReturned_nameIsValidated() {
		// Given
		AchievementSelector selector = AchievementSelector.getInstance();
		
		// When
		Test.startTest();
		SObjectType result = selector.sObjectType();
		Test.stopTest();

		// Then 
		Assert.areEqual(Achievement__c.getSobjectType(), result, 'Achievement__c sObjectType is expected');
	}

	@IsTest
	private static void queryFields_sObjectFieldsReturned_fieldSetIsValidated() {
		// Given
		AchievementSelector selector = AchievementSelector.getInstance();
		
		// When
		Test.startTest();
		Set<SObjectField> result = selector.queryFields();
		Test.stopTest();

		// Then 
		Set<SObjectField> expectedSet = new Set<SObjectField> { Achievement__c.Id, Achievement__c.Name, Achievement__c.Description__c, Achievement__c.Goal__c, Achievement__c.Score__c, Achievement__c.UITitle__c, Achievement__c.UIDescription__c, Achievement__c.Measurement__c};
		Assert.areEqual(expectedSet, result, 'A specific field set is expected');
	}
}