@IsTest(isParallel=true)
private class AchievementIncrementTriggerHandlerTest {
	
	@IsTest
	private static void processEvents_singleEventStatsDoesntExist_userStatCreated() {
		// Given
		Id userId = UserInfo.getUserId();
		Achievement__c achievement = TestDataFactory.createAchievement('achievement');
		AchievementIncrement__e event = new AchievementIncrement__e(UserId__c = userId, Achievement__c = achievement.Id, Increment__c = 1);

		// When
		Test.startTest();
		AchievementIncrementTriggerHandler handler = new AchievementIncrementTriggerHandler(new List<AchievementIncrement__e> { event });
		handler.processEvents();
		Test.stopTest();

		// Then
		List<UserStat__c> stats = [SELECT Id, CurrentProgress__c FROM UserStat__c WHERE UserId__c = :userId AND Achievement__c = :achievement.Id];
		system.assertEquals(1, stats.size(), 'Single stat is expected to be created');
		system.assertEquals(1, stats[0].CurrentProgress__c, 'CurrentProgress__c value should be increased for the sum of the increments from the event');
	}

	@IsTest
	private static void processEvents_multipleEventsWithSameIds_userStatCreated() {
		// Given
		Id userId = UserInfo.getUserId();
		Achievement__c achievement = TestDataFactory.createAchievement('achievement');
		AchievementIncrement__e event1 = new AchievementIncrement__e(UserId__c = userId, Achievement__c = achievement.Id, Increment__c = 1);
		AchievementIncrement__e event2 = new AchievementIncrement__e(UserId__c = userId, Achievement__c = achievement.Id, Increment__c = 2);

		// When
		Test.startTest();
		AchievementIncrementTriggerHandler handler = new AchievementIncrementTriggerHandler(new List<AchievementIncrement__e> { event1, event2 });
		handler.processEvents();
		Test.stopTest();

		// Then
		List<UserStat__c> stats = [SELECT Id, CurrentProgress__c FROM UserStat__c WHERE UserId__c = :userId AND Achievement__c = :achievement.Id];
		system.assertEquals(1, stats.size(), 'Single stat is expected to be created');
		system.assertEquals(3, stats[0].CurrentProgress__c, 'CurrentProgress__c value should be increased for the sum of the increments from the event');
	}

	@IsTest
	private static void processEvents_existingUserStat_userStatUpdated() {
		// Given
		Id userId = UserInfo.getUserId();
		Achievement__c achievement = TestDataFactory.createAchievement('achievement');
		UserStat__c stat = TestDataFactory.createUserStat(userId, achievement.Id, 10);

		AchievementIncrement__e event = new AchievementIncrement__e(UserId__c = userId, Achievement__c = achievement.Id, Increment__c = 1);

		// When
		Test.startTest();
		AchievementIncrementTriggerHandler handler = new AchievementIncrementTriggerHandler(new List<AchievementIncrement__e> { event });
		handler.processEvents();
		Test.stopTest();

		// Then
		List<UserStat__c> stats = [SELECT Id, CurrentProgress__c FROM UserStat__c WHERE UserId__c = :userId AND Achievement__c = :achievement.Id];
		system.assertEquals(1, stats.size(), 'Single stat is expected to be created');
		system.assertEquals(stat.Id, stats[0].Id, 'Existing UserStat__c is expected to be updated');
		system.assertEquals(11, stats[0].CurrentProgress__c, 'CurrentProgress__c value should be increased for the sum of the increments from the event');
	}

	@IsTest
	private static void onAfterInsert_eventGetsPublished_userStatCreated() {
		// Given
		Id userId = UserInfo.getUserId();
		Achievement__c achievement = TestDataFactory.createAchievement('achievement');

		// When
		Test.startTest();
		AchievementIncrement__e event = new AchievementIncrement__e(UserId__c = userId, Achievement__c = achievement.Id, Increment__c = 1);
		EventBus.publish(new List<AchievementIncrement__e> { event });
		Test.stopTest();

		// Then
		List<UserStat__c> stats = [SELECT Id, CurrentProgress__c FROM UserStat__c WHERE UserId__c = :userId AND Achievement__c = :achievement.Id];
		system.assertEquals(1, stats.size(), 'Single stat is expected to be created');
		system.assertEquals(1, stats[0].CurrentProgress__c, 'CurrentProgress__c value should be increased for the sum of the increments from the event');
	}

}