@IsTest(isParallel=true)
private class AchievementSelectorTest {

	@IsTest
	private static void getByIdsReturnsRecordsWhenFoundTest(){
		// Given
		Achievement__c achievement1 = TestDataFactory.initAchievement('OK1');
		Achievement__c achievement2 = TestDataFactory.initAchievement('OK2');
		Achievement__c achievement3 = TestDataFactory.initAchievement('NOTOK1');
		insert new List<Achievement__c> { achievement1, achievement2, achievement3 };
		Set<Id> ids = new Set<Id>{achievement1.id, achievement2.Id};

		// When 
		List<Achievement__c> result = AchievementSelector.getByIds(ids);

		// Then
		System.assertEquals(2, result.size(), '2 records are expected to be found');
		Map<Id, Achievement__c> resultMap = new Map<Id, Achievement__c>(result);
		System.assert(resultMap.containsKey(achievement1.Id), 'First achievement is expected to be found');
		System.assert(resultMap.containsKey(achievement2.Id), 'Second achievement is expected to be found');
		System.assert(!resultMap.containsKey(achievement3.Id), 'Third achievement is expected not to be found');
	}

	@IsTest
	private static void getByIdsEmptyNonNullListTest(){
		// Given
		Set<Id> ids = new Set<Id>();

		// When 
		List<Achievement__c> result = AchievementSelector.getByIds(ids);

		// Then
		System.assertNotEquals(null, result, 'Empty list is expected instead of null');
		System.assertEquals(0, result.size(), 'Empty list is expected');
	}

	@IsTest
	private static void getByIds_noRecordsFound_emptyListReturned(){
		// Given
		Achievement__c achievement1 = TestDataFactory.initAchievement('EXISTS1');
		Achievement__c achievement2 = TestDataFactory.initAchievement('EXISTS2');
		Achievement__c achievement3 = TestDataFactory.initAchievement('REMOVED');
		insert new List<Achievement__c> { achievement1, achievement2, achievement3 };
		Set<Id> ids = new Set<Id>{ achievement3.id };
		delete new List<Achievement__c> { achievement3 };

		// When 
		List<Achievement__c> result = AchievementSelector.getByIds(ids);

		// Then
		System.assertNotEquals(null, result, 'Empty list is expected instead of null');
		System.assertEquals(0, result.size(), 'Empty list is expected');
	}
}