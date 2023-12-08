@IsTest
private class UserInfoControllerTest {
	@IsTest
	private static void getUsersInfo_userWithReachedAchivementsExists_infoReturned() {
		// Given
		User usr = [SELECT Id, Name, FullPhotoUrl FROM User WHERE ID = :UserInfo.getUserId() LIMIT 1];
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement1 = TestDataFactory.createAchievement('Ach1', measurement.Id);
		Achievement__c achievement2 = TestDataFactory.createAchievement('Ach2', measurement.Id);
		ReachedAchievement__c reachedAchievement1 = TestDataFactory.createReachedAchievement(usr.Id, achievement1.Id);
		ReachedAchievement__c reachedAchievement2 = TestDataFactory.createReachedAchievement(usr.Id, achievement2.Id);

		// When 
		Test.startTest();
		Map<String, Object> result = UserInfoController.getUsersInfo(new List<Id> { usr.Id });
		Test.stopTest();

		// Then
		System.assert(result.containsKey('Success'), 'Map is expected to contain Success key');
		System.assert(!result.containsKey('Error'), 'Map is not expected to contain Error key');
		System.assert(!result.containsKey('Warning'), 'Map is not expected to contain Warning key');
		Map<Id, DataWrappers.UserCardData> cardDataMap = (Map<Id, DataWrappers.UserCardData>) result.get('Success');
		System.assert(cardDataMap != null, 'Map with userInfo is expected to be returned');
		DataWrappers.UserCardData cardData = cardDataMap.get(usr.Id);
		System.assertEquals(usr.Name, cardData.name, 'Name of current user is expected to be returned');
		System.assertEquals(usr.FullPhotoUrl, cardData.fullPhotoUrl, 'FullPhotoUrl of current user is expected to be returned');
		System.assertEquals(2, cardData.reachedAchievementsCount, 'Total number of reached achievements is expected');
		System.assertEquals(2, cardData.totalAchievementsCount, 'Total number of achievements is expected');
		System.assertEquals(achievement1.Score__c + achievement2.Score__c, cardData.totalScore, 'Total score of all reached achievements is expected');
	}
}