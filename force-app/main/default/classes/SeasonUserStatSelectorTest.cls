@IsTest(isParallel=false)
private class SeasonUserStatSelectorTest {

	@TestSetup
	static void setup() {
		Id profileId = UserInfo.getProfileId();
		Season__c season = TestDataFactory.createSeason(Date.today(), Date.today().addDays(30));
		User user1 = TestDataFactory.initUser(profileId, 'User1');
		User user2 = TestDataFactory.initUser(profileId, 'User2');
		User user3 = TestDataFactory.initUser(profileId, 'User3');
		User user4 = TestDataFactory.initUser(profileId, 'User4');
		insert new List<User>{user1, user2, user3, user4};

		List<SeasonUserStat__c> stats = new List<SeasonUserStat__c>{
			TestDataFactory.initSeasonUserStat(season.Id, user1.Id, 100, 5),
			TestDataFactory.initSeasonUserStat(season.Id, user2.Id, 200, 3),
			TestDataFactory.initSeasonUserStat(season.Id, user3.Id, 300, 7),
			TestDataFactory.initSeasonUserStat(season.Id, user4.Id, 150, 2)
		};
		insert stats;
	}

	@IsTest
	private static void getTopThreeByScore_moreThenThreeExist_topThreeReturned() {
		// Given
		Season__c season = [SELECT Id FROM Season__c LIMIT 1];	

		// When
		Test.startTest();
		List<SeasonUserStat__c> topThree = SeasonUserStatSelector.getInstance().getTopThreeByScore(season.Id);
		Test.stopTest();

		// Then
		System.assertEquals(3, topThree.size(), 'Should return only top 3');
		System.assertEquals(300, topThree[0].TotalScore__c, 'Highest score should be first');
		System.assertEquals(200, topThree[1].TotalScore__c, 'Second highest score should be second');
		System.assertEquals(150, topThree[2].TotalScore__c, 'Third highest score should be third');
	}

	@IsTest
	private static void getTopThreeByCount_moreThenThreeExist_topThreeReturned() {
		// Given
		Season__c season = [SELECT Id FROM Season__c LIMIT 1];	

		// When
		Test.startTest();
		List<SeasonUserStat__c> topThree = SeasonUserStatSelector.getInstance().getTopThreeByCount(season.Id);
		Test.stopTest();

		// Then
		System.assertEquals(3, topThree.size(), 'Should return only top 3');
		System.assertEquals(7, topThree[0].TotalAchievementsReached__c, 'Highest count should be first');
		System.assertEquals(5, topThree[1].TotalAchievementsReached__c, 'Second highest count should be second');
		System.assertEquals(3, topThree[2].TotalAchievementsReached__c, 'Third highest count should be third');
	}
}