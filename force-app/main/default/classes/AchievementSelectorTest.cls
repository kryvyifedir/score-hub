@IsTest(isParallel=true)
private class AchievementSelectorTest {

	@IsTest
	private static void getByIds_recordWithIdExists_recordsReturned(){
		// Given
		Achievement__c achievement1 = TestDataFactory.createAchievement('Found');
		Achievement__c achievement2 = TestDataFactory.createAchievement('Not found');

		// When 
		Test.startTest();
		List<Achievement__c> result = AchievementSelector.getByIds(new Set<Id>{ achievement1.Id });
		Map<Id,Achievement__c> resultMap = new Map<Id,Achievement__c>(result);
		Test.stopTest();

		// Then
		System.assertEquals(1, result.size(), 'Record is expected to be found');
		System.assert(resultMap.containsKey(achievement1.Id), 'Map is expected to have a specific achievement');
		System.assert(!resultMap.containsKey(achievement2.Id), 'Map is not expected to have a specific achievement');
	}

	@IsTest
	private static void getByIds_emptyIdsSet_emptyListReturned(){
		// Given
		Set<Id> ids = new Set<Id>();

		// When 
		Test.startTest();
		List<Achievement__c> result = AchievementSelector.getByIds(ids);
		Test.stopTest();

		// Then
		System.assertNotEquals(null, result, 'Empty list is expected');
		System.assertEquals(0, result.size(), 'Empty list is expected');
	}

	@IsTest
	private static void getByIds_noRecordsFound_emptyListReturned(){
		// Given
		Achievement__c achievement = TestDataFactory.createAchievement('REMOVED');
		Id achievementId = achievement.Id;
		delete new List<Achievement__c> { achievement };

		// When 
		Test.startTest();
		List<Achievement__c> result = AchievementSelector.getByIds(new Set<Id> { achievementId });
		Test.stopTest();

		// Then
		System.assertNotEquals(null, result, 'Empty list is expected');
		System.assertEquals(0, result.size(), 'Empty list is expected');
	}
}