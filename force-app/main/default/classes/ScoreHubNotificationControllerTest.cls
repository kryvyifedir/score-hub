@IsTest(isParallel=true)
private class ScoreHubNotificationControllerTest {
	
	@IsTest
	private static void getAchievementById_allDataExists_AchievementReturned() {
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		
		// When
		Test.startTest();
		Map<String, Object> result = ScoreHubNotificationController.getAchievementById(achievement.Id);
		Test.stopTest();

		// Then
		Assert.isTrue(result.containsKey('Success'), 'Success is expected');
		Assert.isFalse(result.containsKey('Error'), 'Error is not expected');
		Assert.isFalse(result.containsKey('Warning'), 'Warning is not expected');
		DataWrappers.AchievementCardData resultObj = (DataWrappers.AchievementCardData) result.get('Success');
		Assert.areEqual(achievement.Id, resultObj.id, 'Achievement is expected to be returned');
	}

	@IsTest
	private static void getAchievementById_noDataExists_AchievementReturned() {
		// Given
		Id userId = UserInfo.getUserId();

		// When
		Test.startTest();
		Map<String, Object> result = ScoreHubNotificationController.getAchievementById(userId);
		Test.stopTest();

		// Then
		Assert.isTrue(result.containsKey('Success'), 'Success is expected');
		Assert.isFalse(result.containsKey('Error'), 'Error is not expected');
		Assert.isFalse(result.containsKey('Warning'), 'Warning is not expected');
		DataWrappers.AchievementCardData resultObj = (DataWrappers.AchievementCardData) result.get('Success');
		Assert.areEqual(null, resultObj, 'null is expected to be returned');
	}

	@IsTest
	private static void getAchievementById_noReachedAchievement_AchievementReturned() {
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		
		// When
		Test.startTest();
		Map<String, Object> result = ScoreHubNotificationController.getAchievementById(achievement.Id);
		Test.stopTest();

		// Then
		Assert.isTrue(result.containsKey('Success'), 'Success is expected');
		Assert.isFalse(result.containsKey('Error'), 'Error is not expected');
		Assert.isFalse(result.containsKey('Warning'), 'Warning is not expected');
		DataWrappers.AchievementCardData resultObj = (DataWrappers.AchievementCardData) result.get('Success');
		Assert.areEqual(achievement.Id, resultObj.id, 'Achievement is expected to be returned');
	}

	@IsTest
	private static void getAchievementById_UnexpectedException_ExceptionHandled() {
		// Given
		ScoreHubNotificationController.throwException = true;
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		
		// When
		Test.startTest();
		Map<String, Object> result = ScoreHubNotificationController.getAchievementById(achievement.Id);
		Test.stopTest();

		// Then
		Assert.isFalse(result.containsKey('Success'), 'Success is expected');
		Assert.isTrue(result.containsKey('Error'), 'Error is not expected');
		Assert.isFalse(result.containsKey('Warning'), 'Warning is not expected');
		Assert.areEqual('Unable to get Achievement by Id', (String) result.get('Error'), 'Error message is expected');
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
		Map<String, Object> result = ScoreHubNotificationController.getClosestReachableAchievement(UserInfo.getUserId());
		Test.stopTest();

		// Then
		Assert.isTrue(result.containsKey('Success'), 'Success is expected');
		Assert.isFalse(result.containsKey('Error'), 'Error is not expected');
		Assert.isFalse(result.containsKey('Warning'), 'Warning is not expected');
		DataWrappers.AchievementCardData resultObj = (DataWrappers.AchievementCardData) result.get('Success');
		Assert.areEqual(achievement2.Id, resultObj.id, 'Information about achievement 2 is expected to be returned');
	}

	@IsTest
	private static void getClosestReachableAchievement_UnexpectedException_ExceptionHandled() {
		// Given
		ScoreHubNotificationController.throwException = true;
		
		// When
		Test.startTest();
		Map<String, Object> result = ScoreHubNotificationController.getClosestReachableAchievement(UserInfo.getUserId());
		Test.stopTest();

		// Then
		Assert.isFalse(result.containsKey('Success'), 'Success is expected');
		Assert.isTrue(result.containsKey('Error'), 'Error is not expected');
		Assert.isFalse(result.containsKey('Warning'), 'Warning is not expected');
		Assert.areEqual('Unable to get the closes achievement by user Id', (String) result.get('Error'), 'Error message is expected');
	}
}