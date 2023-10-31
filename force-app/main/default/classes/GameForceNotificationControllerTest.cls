@IsTest(isParallel=true)
private class GameForceNotificationControllerTest {
	
	@IsTest
	private static void getAchievementById_allDataExists_AchievementReturned() {
		// Given
		Id userId = UserInfo.getUserId();
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		ReachedAchievement__c reachedAchievement = TestDataFactory.createReachedAchievement(userId, achievement.Id);
		
		// When
		Test.startTest();
		Map<String, Object> result = GameForceNotificationController.getAchievementById(achievement.Id, userId);
		Test.stopTest();

		// Then
		System.assert(result.containsKey('Success'), 'Success is expected');
		System.assert(!result.containsKey('Error'), 'Error is not expected');
		System.assert(!result.containsKey('Warning'), 'Warning is not expected');
		DataWrappers.AchievementCardData resultObj = (DataWrappers.AchievementCardData) result.get('Success');
		System.assertEquals(achievement.Id, resultObj.id, 'Achievement is expected to be returned');
	}

	@IsTest
	private static void getAchievementById_noDataExists_AchievementReturned() {
		// Given
		Id userId = UserInfo.getUserId();

		// When
		Test.startTest();
		Map<String, Object> result = GameForceNotificationController.getAchievementById(userId, userId);
		Test.stopTest();

		// Then
		System.assert(result.containsKey('Success'), 'Success is expected');
		System.assert(!result.containsKey('Error'), 'Error is not expected');
		System.assert(!result.containsKey('Warning'), 'Warning is not expected');
		DataWrappers.AchievementCardData resultObj = (DataWrappers.AchievementCardData) result.get('Success');
		System.assertEquals(null, resultObj, 'null is expected to be returned');
	}

	@IsTest
	private static void getAchievementById_noReachedAchievement_AchievementReturned() {
		// Given
		Id userId = UserInfo.getUserId();
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		
		// When
		Test.startTest();
		Map<String, Object> result = GameForceNotificationController.getAchievementById(achievement.Id, userId);
		Test.stopTest();

		// Then
		System.assert(result.containsKey('Success'), 'Success is expected');
		System.assert(!result.containsKey('Error'), 'Error is not expected');
		System.assert(!result.containsKey('Warning'), 'Warning is not expected');
		DataWrappers.AchievementCardData resultObj = (DataWrappers.AchievementCardData) result.get('Success');
		System.assertEquals(achievement.Id, resultObj.id, 'Achievement is expected to be returned');
	}

	@IsTest
	private static void getAchievementById_UnexpectedException_ExceptionHandled() {
		// Given
		GameForceNotificationController.throwException = true;
		Id userId = UserInfo.getUserId();
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		
		// When
		Test.startTest();
		Map<String, Object> result = GameForceNotificationController.getAchievementById(achievement.Id, userId);
		Test.stopTest();

		// Then
		System.assert(!result.containsKey('Success'), 'Success is expected');
		System.assert(result.containsKey('Error'), 'Error is not expected');
		System.assert(!result.containsKey('Warning'), 'Warning is not expected');
		System.assertEquals('Unable to get Achievement by Id', (String) result.get('Error'), 'Error message is expected');
		List<Log__c> logs = [SELECT Id FROM Log__c];
		System.assertEquals(1, logs.size(), 'Expected to save logs about unhandleded exception');
	}

	@IsTest
	private static void getClosestReachableAchievement_UserIdPassed_ClosesAchievementReturned() {
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement1 = TestDataFactory.initAchievement('Ach1', measurement.Id);
		achievement1.Goal__c = 100;
		Achievement__c achievement2 = TestDataFactory.initAchievement('Ach2', measurement.Id);
		achievement2.Goal__c = 200;
		insert new List<Achievement__c> {achievement1, achievement2};
		UserMeasurement__c userMeasurement = TestDataFactory.createUserMeasurement(UserInfo.getUserId(), measurement.Id, 120);

		// When
		Test.startTest();
		Map<String, Object> result = GameForceNotificationController.getClosestReachableAchievement(UserInfo.getUserId());
		Test.stopTest();

		// Then
		System.assert(result.containsKey('Success'), 'Success is expected');
		System.assert(!result.containsKey('Error'), 'Error is not expected');
		System.assert(!result.containsKey('Warning'), 'Warning is not expected');
		DataWrappers.AchievementCardData resultObj = (DataWrappers.AchievementCardData) result.get('Success');
		System.assertEquals(achievement2.Id, resultObj.id, 'Information about achievement 2 is expected to be returned');
	}

	@IsTest
	private static void getClosestReachableAchievement_UnexpectedException_ExceptionHandled() {
		// Given
		GameForceNotificationController.throwException = true;
		
		// When
		Test.startTest();
		Map<String, Object> result = GameForceNotificationController.getClosestReachableAchievement(UserInfo.getUserId());
		Test.stopTest();

		// Then
		System.assert(!result.containsKey('Success'), 'Success is expected');
		System.assert(result.containsKey('Error'), 'Error is not expected');
		System.assert(!result.containsKey('Warning'), 'Warning is not expected');
		System.assertEquals('Unable to get the closes achievement by user Id', (String) result.get('Error'), 'Error message is expected');
		List<Log__c> logs = [SELECT Id FROM Log__c];
		System.assertEquals(1, logs.size(), 'Unable to get Achievement by Id');
	}
}