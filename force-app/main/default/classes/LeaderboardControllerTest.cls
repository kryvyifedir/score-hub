@IsTest
private class LeaderboardControllerTest {

	@IsTest
	private static void getTotalNumberOfAchievements_achievementExists_countReturned() {
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement1 = TestDataFactory.createAchievement('Ach1', measurement.Id);
		Achievement__c achievement2 = TestDataFactory.createAchievement('Ach2', measurement.Id);
		Achievement__c achievement3 = TestDataFactory.createAchievement('Ach3', measurement.Id);

		// When 
		Test.startTest();
		Map<String, Object> result = LeaderboardController.getTotalNumberOfAchievements();
		Test.stopTest();

		// Then
		System.assert(result.containsKey('Success'), 'Map is expected to contain Success key');
		System.assert(!result.containsKey('Error'), 'Map is expected to contain Error key');
		System.assert(!result.containsKey('Warning'), 'Map is expected to contain Warning key');
		System.assertEquals(3, (Decimal) result.get('Success'), ' 3 records are expected to be returned');
	}

	@IsTest
	private static void getUserInfoById_userWithReachedAchivementsExists_infoReturned() {
		// Given
		User usr = [SELECT Id, Name, FullPhotoUrl FROM User WHERE ID = :UserInfo.getUserId() LIMIT 1];
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement1 = TestDataFactory.createAchievement('Ach1', measurement.Id);
		Achievement__c achievement2 = TestDataFactory.createAchievement('Ach2', measurement.Id);
		ReachedAchievement__c reachedAchievement1 = TestDataFactory.createReachedAchievement(usr.Id, achievement1.Id);
		ReachedAchievement__c reachedAchievement2 = TestDataFactory.createReachedAchievement(usr.Id, achievement2.Id);

		// When 
		Test.startTest();
		Map<String, Object> result = LeaderboardController.getCurrentUserInfo();
		Test.stopTest();

		// Then
		System.assert(result.containsKey('Success'), 'Map is expected to contain Success key');
		System.assert(!result.containsKey('Error'), 'Map is expected to contain Error key');
		System.assert(!result.containsKey('Warning'), 'Map is expected to contain Warning key');
		LeaderboardController.UserInfoWrapper userInfoWrapper = (LeaderboardController.UserInfoWrapper) result.get('Success');
		System.assertEquals(usr.Name, userInfoWrapper.name, 'Name of current user is expected to be returned');
		System.assertEquals(usr.FullPhotoUrl, userInfoWrapper.fullPhotoUrl, 'FullPhotoUrl of current user is expected to be returned');
		System.assertEquals(2, userInfoWrapper.numberOfAchievements, 'Total number of achievements is expected');
		System.assertEquals(achievement1.Score__c + achievement2.Score__c, userInfoWrapper.totalScore, 'Total score of all reached achievements is expected');
	}
}