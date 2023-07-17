@IsTest(isParallel=true)
private class AchievementReachedEventsManagerTest {
	
	@IsTest
	private static void fireEvent_noDataExists_platformEventFired() {
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		UserMeasurement__c userMeasurement = TestDataFactory.createUserMeasurement(UserInfo.getUserId(), measurement.Id, achievement.Goal__c + 10);
		Map<Id, UserMeasurement__c> userMeasurementByIdMap = new Map<Id, UserMeasurement__c> {userMeasurement.Id => userMeasurement};

		delete [SELECT Id FROM ReachedAchievement__c];

		// When
		Test.startTest();
		AchievementReachedEventsManager eventsManager = new AchievementReachedEventsManager(userMeasurementByIdMap);
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
	private static void fireEvent_achievementReachedAlready_noPlatformEventFired() {
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		UserMeasurement__c userMeasurement = TestDataFactory.createUserMeasurement(UserInfo.getUserId(), measurement.Id, achievement.Goal__c + 10);
		ReachedAchievement__c reachedAchievement = TestDataFactory.createReachedAchievement(UserInfo.getUserId(), achievement.Id);
		Map<Id, UserMeasurement__c> userMeasurementByIdMap = new Map<Id, UserMeasurement__c> {userMeasurement.Id => userMeasurement};

		// When
		Test.startTest();
		AchievementReachedEventsManager eventsManager = new AchievementReachedEventsManager(userMeasurementByIdMap);
		List<Database.SaveResult> results = eventsManager.fireEvents();
		Test.stopTest();

		// Then
		System.assertEquals(null, results, 'Since achievement was already reached no Events are expected to be fired');
	}

	@IsTest
	private static void test_failedTest() {
		System.assertEquals(false, true, 'failed');
	}

	@IsTest
	private static void fireEvent_statsProgressIsLessThenGoal_eventNotFired() {
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		UserMeasurement__c userMeasurement = TestDataFactory.createUserMeasurement(UserInfo.getUserId(), measurement.Id, achievement.Goal__c - 10);
		Map<Id, UserMeasurement__c> userMeasurementByIdMap = new Map<Id, UserMeasurement__c> {userMeasurement.Id => userMeasurement};

		delete [SELECT Id FROM ReachedAchievement__c];

		// When
		Test.startTest();
		AchievementReachedEventsManager eventsManager = new AchievementReachedEventsManager(userMeasurementByIdMap);
		List<Database.SaveResult> results = eventsManager.fireEvents();
		Test.stopTest();

		// Then
		System.assertEquals(null, results, 'Validation is expected to prevent any Events from being sent');
	}

	@IsTest
	private static void fireEvent_emptyStatsMap_eventNotFired() {
		// Given
		Map<Id, UserMeasurement__c> userMeasurementByIdMap = new Map<Id, UserMeasurement__c>();

		// When
		Test.startTest();
		AchievementReachedEventsManager eventsManager = new AchievementReachedEventsManager(userMeasurementByIdMap);
		List<Database.SaveResult> results = eventsManager.fireEvents();
		Test.stopTest();

		// Then
		System.assertEquals(null, results, 'Validation is expected to prevent any Events from being sent');
	}
}