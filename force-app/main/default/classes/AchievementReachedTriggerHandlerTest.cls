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
		Assert.isNotNull(result, 'ReachedAchievement__c are expected to be created');
		Assert.areEqual(1, result.size(), 'Single ReachedAchievement__c is expected to be created');
		Assert.areEqual(userId, result[0].User__c, 'User__c filed value is expected to match userId');
		Assert.areEqual(achievement.Id, result[0].Achievement__c, 'User__c filed value is expected to match userId');
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
		Assert.areEqual(1, result.size(), 'No new ReachedAchievement__c are expected to be created');
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
		Assert.isNotNull(result, 'ReachedAchievement__c are expected to be created');
		Assert.areEqual(1, result.size(), 'Single ReachedAchievement__c is expected to be created');
		Assert.areEqual(userId, result[0].User__c, 'User__c filed value is expected to match userId');
		Assert.areEqual(achievement.Id, result[0].Achievement__c, 'User__c filed value is expected to match userId');
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
		Assert.isTrue(result.isEmpty(), 'No new ReachedAchievement__c are expected to be created');
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
		Assert.isTrue(result.isEmpty(), 'No new ReachedAchievement__c are expected to be created');
	}

	@IsTest
	private static void onAfterInsert_201AchievementsReached_recordsCreated() {
		// Given
		Id userId = UserInfo.getUserId();
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		List<Achievement__c> achievements = new List<Achievement__c>();
		for (Integer i = 0; i <= 201; i++) {
			achievements.add(TestDataFactory.initAchievement('Achievement' + i, measurement.Id));
		}
		insert achievements;

		List<AchievementReached__e> events = new List<AchievementReached__e>();
		for (Achievement__c achievement : achievements) {
			events.add(new AchievementReached__e(UserId__c = userId, AchievementId__c = achievement.Id));
		}

		// When
		Test.startTest();
		EventBus.publish(events);
		Test.stopTest();

		// Then
		List<ReachedAchievement__c> result = [SELECT Id, Key__c, User__c, Achievement__c FROM ReachedAchievement__c];
		Assert.isNotNull(result, 'ReachedAchievement__c are expected to be created');
		Assert.areEqual(202, result.size(), 'Single ReachedAchievement__c is expected to be created');
	}
}