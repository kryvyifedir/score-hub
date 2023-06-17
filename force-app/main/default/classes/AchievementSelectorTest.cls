@IsTest
private class AchievementSelectorTest {

	@IsTest
	private static void getByIds_recordWithIdExists_recordsReturned(){
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement1 = TestDataFactory.createAchievement('Found', measurement.Id);
		Achievement__c achievement2 = TestDataFactory.createAchievement('Not found', measurement.Id);

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
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement = TestDataFactory.createAchievement('REMOVED', measurement.Id);
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

	@IsTest
	private static void getReachedAchievementsByAchievementId_reachedAchievementsExist_mapReturned() {
		// Given
		Id profileId = UserInfo.getProfileId();
		User user1 = TestDataFactory.createUser(profileId, 'user1');
		User user2 = TestDataFactory.createUser(profileId, 'user2');
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement1 = TestDataFactory.createAchievement('Achievement1', measurement.Id);
		Achievement__c achievement2 = TestDataFactory.createAchievement('Achievement2', measurement.Id);
		ReachedAchievement__c reached1 = TestDataFactory.createReachedAchievement(user1.Id, achievement1.Id);
		ReachedAchievement__c reached2 = TestDataFactory.createReachedAchievement(user1.Id, achievement2.Id);
		ReachedAchievement__c reached3 = TestDataFactory.createReachedAchievement(user2.Id, achievement1.Id);

		// When
		Test.startTest();
		Map<Id, Map<String, ReachedAchievement__c>> result = AchievementSelector.getReachedAchievementsByAchievementId(new Set<Id> { achievement1.Id, achievement2.Id });
		Test.stopTest();

		// Then
		System.assertNotEquals(null, result.isEmpty(), 'result expected to be populated');
		System.assertNotEquals(0, result.size(), 'result expected to be populated');
		System.assert(result.containsKey(achievement1.Id));
		Map<String, ReachedAchievement__c> achievement1Result = result.get(achievement1.Id);
		System.assert(achievement1Result.containsKey(user1.Id + '-' + achievement1.Id), 'Expected to get AchievementReached by key');
		System.assert(achievement1Result.containsKey(user2.Id + '-' + achievement1.Id), 'Expected to get AchievementReached by key');

		System.assert(result.containsKey(achievement2.Id));
		Map<String, ReachedAchievement__c> achievement2Result = result.get(achievement2.Id);
		System.assert(achievement2Result.containsKey(user1.Id + '-' + achievement2.Id), 'Expected to get AchievementReached by key');
		
	}

	@IsTest
	private static void getReachedAchievementsByAchievementId_emptyListOfIds_emptyMapReturned() {
		// Given

		// When
		Test.startTest();
		Map<Id, Map<String, ReachedAchievement__c>> result = AchievementSelector.getReachedAchievementsByAchievementId(new Set<Id>());
		Test.stopTest();

		// Then
		System.assertNotEquals(null, result.isEmpty(), 'result expected to be not null');
		System.assert(result.isEmpty(), 'result is expected to be empty');
		
	}
}