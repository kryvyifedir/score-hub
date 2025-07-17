@IsTest
private class UserDataHelperTest {
	@IsTest
	private static void getUserInfoById_userWithReachedAchivementsExists_infoReturned() {
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement1 = TestDataFactory.initAchievement('Ach1', measurement.Id);
		Achievement__c achievement2 = TestDataFactory.initAchievement('Ach2', measurement.Id);
		insert new List<Achievement__c> { achievement1, achievement2 };

		Id profileId = UserInfo.getProfileId();
		User usr1 = TestDataFactory.initUser(profileId, 'user1');
		User usr2 = TestDataFactory.initUser(profileId, 'user2');
		insert new List<User> { usr1, usr2 };

		ReachedAchievement__c reachedAchievement1 = TestDataFactory.initReachedAchievement(usr1.Id, achievement1.Id);
		ReachedAchievement__c reachedAchievement2 = TestDataFactory.initReachedAchievement(usr1.Id, achievement2.Id);
		insert new List<ReachedAchievement__c> { reachedAchievement1, reachedAchievement2 };

		// When 
		Test.startTest();
		Map<Id, DataWrappers.UserCardData> result = UserDataHelper.getUserCardDataById(new Set<Id> { usr1.Id, usr2.Id }, 2);
		Test.stopTest();

		// Then
		DataWrappers.UserCardData usr1DataCard = result.get(usr1.Id);
		Assert.areEqual(usr1.Id, usr1DataCard.id);
		Assert.areEqual(2, usr1DataCard.totalAchievementsCount);
		Assert.areEqual(2, usr1DataCard.reachedAchievementsCount, 'Two reached achievement is expected to be counted');
		Assert.areEqual(achievement1.Score__c + achievement2.Score__c, usr1DataCard.totalScore, 'Total score of all reached achievements is expected');

		Assert.isTrue(result.containsKey(usr2.Id));
		DataWrappers.UserCardData usr2DataCard = result.get(usr2.Id);
		Assert.areEqual(usr2.Id, usr2DataCard.id);
		Assert.areEqual(2, usr2DataCard.totalAchievementsCount);
		Assert.areEqual(0, usr2DataCard.reachedAchievementsCount, 'Zero reached achievements exist so value is expected to be 0');
		Assert.areEqual(0, usr2DataCard.totalScore, 'There are no reached achievements for second user, so score should be zero');
	}

	@IsTest
	private static void getUserDataFromSeasonStats_validInput_wrapperReturned() {
		// Given
		User usr = [SELECT Id, Name, SmallPhotoUrl FROM User WHERE ID = :UserInfo.getUserId() LIMIT 1];
		Season__c testSeason = TestDataFactory.createSeason(Date.today().addDays(-3), Date.today());
		SeasonUserStat__c stat = TestDataFactory.initSeasonUserStat(testSeason.Id, usr.Id, 123, 4);
		Integer allAchievementsCount = 10;

		// When
		Test.startTest();
		DataWrappers.UserCardData result = UserDataHelper.getUserDataFromSeasonStats(usr, stat, allAchievementsCount);
		Test.stopTest();

		// Then
		Assert.areEqual(usr.Id, result.Id, 'User Id should match');
		Assert.areEqual(usr.Name, result.name, 'User name should match');
		Assert.areEqual(usr.SmallPhotoUrl, result.smallPhotoUrl, 'Small photo URL should match');
		Assert.areEqual(allAchievementsCount, result.totalAchievementsCount, 'Total achievements count should match');
		Assert.areEqual(123, result.totalScore, 'Total score should match');
		Assert.areEqual(4, result.reachedAchievementsCount, 'Reached achievements count should match');
	}
}