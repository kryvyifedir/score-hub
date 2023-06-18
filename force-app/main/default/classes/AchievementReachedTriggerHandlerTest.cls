@IsTest(isParallel=true)
private class AchievementReachedTriggerHandlerTest {
	@IsTest
	private static void processEvents_noExistingReachedAchievements_recordCreated() {
		// Given
		Id userId = UserInfo.getUserId();
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		List<AchievementReached__e> events = new List<AchievementReached__e> {
			new AchievementReached__e(UserId__c = userId, AchievementId__c = achievement.Id)
		};

		// When
		Test.startTest();
		AchievementReachedTriggerHandler handler = new AchievementReachedTriggerHandler(events);
		handler.processEvents();
		Test.stopTest();

		// Then
		List<ReachedAchievement__c> result = [SELECT Id, Key__c, User__c, Achievement__c FROM ReachedAchievement__c];
		System.assertNotEquals(null, result, 'ReachedAchievement__c are expected to be created');
		System.assertEquals(1, result.size(), 'Single ReachedAchievement__c is expected to be created');
		System.assertEquals(userId, result[0].User__c, 'User__c filed value is expected to match userId');
		System.assertEquals(achievement.Id, result[0].Achievement__c, 'User__c filed value is expected to match userId');
	}

	@IsTest
	private static void processEvents_existingReachedAchievement_noRecordCreated() {
		// Given
		Id userId = UserInfo.getUserId();
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		ReachedAchievement__c reachedAchievement = TestDataFactory.createReachedAchievement(userId, achievement.Id);
		List<AchievementReached__e> events = new List<AchievementReached__e> {
			new AchievementReached__e(UserId__c = userId, AchievementId__c = achievement.Id)
		};

		// When
		Test.startTest();
		AchievementReachedTriggerHandler handler = new AchievementReachedTriggerHandler(events);
		handler.processEvents();
		Test.stopTest();

		// Then
		List<ReachedAchievement__c> result = [SELECT Id, Key__c, User__c, Achievement__c FROM ReachedAchievement__c];
		System.assertEquals(1, result.size(), 'No new ReachedAchievement__c are expected to be created');
	}

	@IsTest
	private static void processEvents_multipleEventsWithSameIds_singleRecordCreated() {
		// Given
		Id userId = UserInfo.getUserId();
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		List<AchievementReached__e> events = new List<AchievementReached__e> {
			new AchievementReached__e(UserId__c = userId, AchievementId__c = achievement.Id),
			new AchievementReached__e(UserId__c = userId, AchievementId__c = achievement.Id),
			new AchievementReached__e(UserId__c = userId, AchievementId__c = achievement.Id)
		};

		// When
		Test.startTest();
		AchievementReachedTriggerHandler handler = new AchievementReachedTriggerHandler(events);
		handler.processEvents();
		Test.stopTest();

		// Then
		List<ReachedAchievement__c> result = [SELECT Id, Key__c, User__c, Achievement__c FROM ReachedAchievement__c];
		System.assertNotEquals(null, result, 'ReachedAchievement__c are expected to be created');
		System.assertEquals(1, result.size(), 'Single ReachedAchievement__c is expected to be created');
		System.assertEquals(userId, result[0].User__c, 'User__c filed value is expected to match userId');
		System.assertEquals(achievement.Id, result[0].Achievement__c, 'User__c filed value is expected to match userId');
	}

	@IsTest
	private static void processEvents_invalidUserId_logRecordCreated() {
		// Given
		Id userId = UserInfo.getUserId();
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		List<AchievementReached__e> events = new List<AchievementReached__e> {
			new AchievementReached__e(UserId__c = achievement.Id, AchievementId__c = achievement.Id)
		};

		// When
		Test.startTest();
		AchievementReachedTriggerHandler handler = new AchievementReachedTriggerHandler(events);
		handler.processEvents();
		Test.stopTest();

		// Then
		List<ReachedAchievement__c> result = [SELECT Id, Key__c, User__c, Achievement__c FROM ReachedAchievement__c];
		List<Log__c> resultLogs = [SELECT Id FROM Log__c];
		System.assertEquals(0, result.size(), 'No new ReachedAchievement__c are expected to be created');
		System.assertEquals(1, resultLogs.size(), 'Log__c record is expected to be created');
	}

	@IsTest
	private static void processEvents_invalidAchievementId_logRecordCreated() {
		// Given
		Id userId = UserInfo.getUserId();
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		List<AchievementReached__e> events = new List<AchievementReached__e> {
			new AchievementReached__e(UserId__c = userId, AchievementId__c = userId)
		};

		// When
		Test.startTest();
		AchievementReachedTriggerHandler handler = new AchievementReachedTriggerHandler(events);
		handler.processEvents();
		Test.stopTest();

		// Then
		List<ReachedAchievement__c> result = [SELECT Id, Key__c, User__c, Achievement__c FROM ReachedAchievement__c];
		List<Log__c> resultLogs = [SELECT Id FROM Log__c];
		System.assertEquals(0, result.size(), 'No new ReachedAchievement__c are expected to be created');
		System.assertEquals(1, resultLogs.size(), 'Log__c record is expected to be created');
	}

	@IsTest
	private static void onAfterInsert_noExistingReachedAchievements_recordCreated() {
		// Given
		Id userId = UserInfo.getUserId();
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		List<AchievementReached__e> events = new List<AchievementReached__e> {
			new AchievementReached__e(UserId__c = userId, AchievementId__c = achievement.Id)
		};

		// When
		Test.startTest();
		EventBus.publish(events);
		Test.stopTest();

		// Then
		List<ReachedAchievement__c> result = [SELECT Id, Key__c, User__c, Achievement__c FROM ReachedAchievement__c];
		System.assertNotEquals(null, result, 'ReachedAchievement__c are expected to be created');
		System.assertEquals(1, result.size(), 'Single ReachedAchievement__c is expected to be created');
		System.assertEquals(userId, result[0].User__c, 'User__c filed value is expected to match userId');
		System.assertEquals(achievement.Id, result[0].Achievement__c, 'User__c filed value is expected to match userId');
	}
}