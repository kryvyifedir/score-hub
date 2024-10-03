@IsTest(isParallel=true)
private class LeaderboardControllerTest {
	
	@IsTest
	private static void getTopUsersByScore_usersWithAchievementExist_userDataWrapped() {
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		ReachedAchievement__c reachedAchievement = TestDataFactory.createReachedAchievement(UserInfo.getUserId(), achievement.Id);

		// When
		Test.startTest();
		Map<String, Object> result = LeaderboardController.getTopUsersByScore();
		Test.stopTest();

		// Then
		Assert.isTrue(result.containsKey('Success'), 'Success is expected');
		Assert.isFalse(result.containsKey('Error'), 'Error is not expected');
		Assert.isFalse(result.containsKey('Warning'), 'Warning is not expected');
		List<DataWrappers.UserCardData> resultList = (List<DataWrappers.UserCardData>) result.get('Success');
		Assert.areEqual(1, resultList.size(), 'User data is expected to be packed in DataWrappers.UserCardData UI data provider');
		Assert.areEqual(UserInfo.getUserId(), resultList[0].Id, 'Packed data is expected to have an Id of current user (since he is the only one with achievements)');
	}

	@IsTest
	private static void getTopUsersByScore_exceptionExpected_exceptionIsSavedAndMessageSentToUI() {
		// Given
		LeaderboardController.throwException = true;

		// When
		Test.startTest();
		Map<String, Object> result = LeaderboardController.getTopUsersByScore();
		Test.stopTest();

		// Then
		Assert.isTrue(result.containsKey('Error'), 'Error is not expected');
		Assert.isFalse(result.containsKey('Success'), 'Success is expected');
		Assert.isFalse(result.containsKey('Warning'), 'Warning is not expected');
		Assert.areEqual('Unable to get the top 10 users by Score', (String) result.get('Error'), 'Error message is expected');
	}

	@IsTest
	private static void getTopUsersByAchievementsCount_usersWithAchievementExist_userDataWrapped() {
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		ReachedAchievement__c reachedAchievement = TestDataFactory.createReachedAchievement(UserInfo.getUserId(), achievement.Id);

		// When
		Test.startTest();
		Map<String, Object> result = LeaderboardController.getTopUsersByAchievementsCount();
		Test.stopTest();

		// Then
		Assert.isTrue(result.containsKey('Success'), 'Success is expected');
		Assert.isFalse(result.containsKey('Error'), 'Error is not expected');
		Assert.isFalse(result.containsKey('Warning'), 'Warning is not expected');
		List<DataWrappers.UserCardData> resultList = (List<DataWrappers.UserCardData>) result.get('Success');
		Assert.areEqual(1, resultList.size(), 'User data is expected to be packed in DataWrappers.UserCardData UI data provider');
		Assert.areEqual(UserInfo.getUserId(), resultList[0].Id, 'Packed data is expected to have an Id of current user (since he is the only one with achievements)');
	}

	@IsTest
	private static void getTopUsersByAchievementsCount_exceptionExpected_exceptionIsSavedAndMessageSentToUI() {
		// Given
		LeaderboardController.throwException = true;

		// When
		Test.startTest();
		Map<String, Object> result = LeaderboardController.getTopUsersByAchievementsCount();
		Test.stopTest();

		// Then
		Assert.isTrue(result.containsKey('Error'), 'Error is not expected');
		Assert.isFalse(result.containsKey('Success'), 'Success is expected');
		Assert.isFalse(result.containsKey('Warning'), 'Warning is not expected');
		Assert.areEqual('Unable to get the top 10 users by Achievements Count', (String) result.get('Error'), 'Error message is expected');
	}
}