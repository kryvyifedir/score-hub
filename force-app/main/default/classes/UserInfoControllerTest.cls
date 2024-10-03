@IsTest
private class UserInfoControllerTest {
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
		Map<String, Object> result = UserInfoController.getUserInfoById(new List<Id> { usr.Id });
		Test.stopTest();

		// Then
		Assert.isTrue(result.containsKey('Success'), 'Map is expected to contain Success key');
		Assert.isFalse(result.containsKey('Error'), 'Map is not expected to contain Error key');
		Assert.isFalse(result.containsKey('Warning'), 'Map is not expected to contain Warning key');
		Map<Id, DataWrappers.UserCardData> cardDataMap = (Map<Id, DataWrappers.UserCardData>) result.get('Success');
		Assert.isNotNull(cardDataMap, 'Map with userInfo is expected to be returned');
		DataWrappers.UserCardData cardData = cardDataMap.get(usr.Id);
		Assert.areEqual(usr.Name, cardData.name, 'Name of current user is expected to be returned');
		Assert.areEqual(usr.FullPhotoUrl, cardData.fullPhotoUrl, 'FullPhotoUrl of current user is expected to be returned');
		Assert.areEqual(2, cardData.reachedAchievementsCount, 'Total number of reached achievements is expected');
		Assert.areEqual(2, cardData.totalAchievementsCount, 'Total number of achievements is expected');
		Assert.areEqual(achievement1.Score__c + achievement2.Score__c, cardData.totalScore, 'Total score of all reached achievements is expected');
	}
	
	@IsTest
	private static void getUserInfoById_UnexpectedException_ExceptionHandled() {
		// Given
		UserInfoController.throwException = true;
		User usr = [SELECT Id, Name, FullPhotoUrl FROM User WHERE ID = :UserInfo.getUserId() LIMIT 1];
		
		// When
		Test.startTest();
		Map<String, Object> result = UserInfoController.getUserInfoById(new List<Id> { usr.Id });
		Test.stopTest();

		// Then
		Assert.isFalse(result.containsKey('Success'), 'Success is expected');
		Assert.isTrue(result.containsKey('Error'), 'Error is not expected');
		Assert.isFalse(result.containsKey('Warning'), 'Warning is not expected');
		Assert.areEqual('Unable to get total achievements count', (String) result.get('Error'), 'Error message is expected');
	}
}