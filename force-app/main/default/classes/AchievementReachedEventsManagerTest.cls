@IsTest(isParallel=true)
private class AchievementReachedEventsManagerTest {

	@IsTest
	private static void fireEventNumberOfEventsTest() {
		// Given
		Achievement__c achievement = TestDataFactory.initAchievement('01');
		insert achievement;

		UserStat__c stat = TestDataFactory.initUserStat(UserInfo.getUserId(), achievement.Id);
		insert stat;
		stat.CurrentProgress__c = achievement.Goal__c + 1;

		Map<Id, UserStat__c> userStatByIdMap = new Map<Id, UserStat__c> {stat.Id => stat};

		// When
		Test.startTest();
		AchievementReachedEventsManager eventsManager = new AchievementReachedEventsManager(userStatByIdMap);
		List<Database.SaveResult> results = eventsManager.fireEvents();
		Test.stopTest();

		// Then
		System.assertNotEquals(null, results, 'Results are expected to be returned by the method');
		System.assertEquals(1, results.size(), 'Single event is expected to be sent per 1 stat');
		for (Database.SaveResult result : results) {
			System.assert(result.isSuccess(), 'Event is expected to be sent without any issues');
		}
	}

	@IsTest
	private static void fireEventEmptyMapValidationTest() {
		// Given
		Map<Id, UserStat__c> userStatByIdMap = new Map<Id, UserStat__c>();

		// When
		Test.startTest();
		AchievementReachedEventsManager eventsManager = new AchievementReachedEventsManager(userStatByIdMap);
		List<Database.SaveResult> results = eventsManager.fireEvents();
		Test.stopTest();

		// Then
		System.assertEquals(null, results, 'Validation is expected to prevent any Events from being sent');
	}
}