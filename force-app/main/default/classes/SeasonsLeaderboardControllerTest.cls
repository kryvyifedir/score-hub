@IsTest(isParallel=false)
private class SeasonsLeaderboardControllerTest {

	@TestSetup
	static void setup() {
		Id profileId = UserInfo.getProfileId();
		User user1 = TestDataFactory.initUser(profileId, 'UserTest1');
		User user2 = TestDataFactory.initUser(profileId, 'UserTest2');
		User user3 = TestDataFactory.initUser(profileId, 'UserTest3');
		User user4 = TestDataFactory.initUser(profileId, 'UserTest4');
		insert new List<User>{user1, user2, user3, user4};
	}

	@IsTest
	private static void getSeasonsConfig_configExists_configReturned() {
		// Given
		SeasonsConfiguration__c config = new SeasonsConfiguration__c(
			IsActive__c = true,
			Cadence__c = 'year',
			StartDate__c = Date.today()
		);
		insert config;
		
		// When
		Test.startTest();
		Map<String, Object> resultMap = SeasonsLeaderboardController.getSeasonsConfig();
		Test.stopTest();

		// Then
		Assert.isTrue(resultMap.containsKey('Success'), 'Success is expected');
		Assert.isFalse(resultMap.containsKey('Error'), 'Error is not expected');
		Assert.isFalse(resultMap.containsKey('Warning'), 'Warning is not expected');
		DataWrappers.SeasonConfig result = (DataWrappers.SeasonConfig)resultMap.get('Success');
		Assert.areEqual(config.Id, result.id, 'Existing config is expected to be returned');
		Assert.areEqual(config.IsActive__c, result.isActive, 'Existing config is expected to be returned');
		Assert.areEqual(config.Cadence__c, result.cadence, 'Existing config is expected to be returned');
		Assert.areEqual(config.StartDate__c, result.startDate, 'Existing config is expected to be returned');
	}

	@IsTest
	private static void getSeasonsConfig_configDoesntExist_nothingReturned() {
		// Given
		
		// When
		Test.startTest();
		Map<String, Object> resultMap = SeasonsLeaderboardController.getSeasonsConfig();
		Test.stopTest();

		// Then
		Assert.isTrue(resultMap.containsKey('Success'), 'Success is expected');
		Assert.isFalse(resultMap.containsKey('Error'), 'Error is not expected');
		Assert.isFalse(resultMap.containsKey('Warning'), 'Warning is not expected');
		DataWrappers.SeasonConfig result = (DataWrappers.SeasonConfig)resultMap.get('Success');
		Assert.areEqual(null, result.id, 'Nothing is returned');
		Assert.areEqual(false, result.isActive, 'isActive is set to false');
	}

	@IsTest
	private static void getSeasonsConfig_exceptionThrown_exceptionHandled() {
		// Given
		SeasonsLeaderboardController.throwException = true;
		
		// When
		Test.startTest();
		Map<String, Object> resultMap = SeasonsLeaderboardController.getSeasonsConfig();
		Test.stopTest();

		// Then
		Assert.isFalse(resultMap.containsKey('Success'), 'Success is not expected');
		Assert.isTrue(resultMap.containsKey('Error'), 'Error is expected');
		Assert.isFalse(resultMap.containsKey('Warning'), 'Warning is not expected');
	}

	@IsTest
	private static void getTotalNumberOfSeasons_seasonsExist_numberIsReturned() {
		// Given
		Integer expectedNumberOfSeasons = 10;
		Date today = Date.today();

		List<Season__c> testData = new List<Season__c>();
		for (Integer i = 0; i < expectedNumberOfSeasons; i++) {
			testData.add(
				TestDataFactory.initSeason(today.addDays(i), today.addDays(i + 1))
			);
		}

		insert testData;

		// When
		Test.startTest();
		Map<String, Object> resultMap = SeasonsLeaderboardController.getTotalNumberOfSeasons();
		Test.stopTest();

		// Then
		Assert.isTrue(resultMap.containsKey('Success'), 'Success is expected');
		Assert.isFalse(resultMap.containsKey('Error'), 'Error is not expected');
		Assert.isFalse(resultMap.containsKey('Warning'), 'Warning is not expected');
		Integer result = (Integer)resultMap.get('Success');
		Assert.areEqual(10, result, 'Count of existing seasons is expected');
	}


	@IsTest
	private static void getTotalNumberOfSeasons_exceptionThrown_exceptionHandled() {
		// Given
		SeasonsLeaderboardController.throwException = true;
		
		// When
		Test.startTest();
		Map<String, Object> resultMap = SeasonsLeaderboardController.getTotalNumberOfSeasons();
		Test.stopTest();

		// Then
		Assert.isFalse(resultMap.containsKey('Success'), 'Success is not expected');
		Assert.isTrue(resultMap.containsKey('Error'), 'Error is expected');
		Assert.isFalse(resultMap.containsKey('Warning'), 'Warning is not expected');
	}

	@IsTest
	private static void getSeasonData_seasonWithTopUsersExists_seasonReturned() {
		// Given
		Date today = Date.today();
		Season__c season = TestDataFactory.createSeason(today, today.addDays(5));

		List<String> userLastNames =new List<string>{'UserTest1', 'UserTest2', 'UserTest3', 'UserTest4'};
		List<User> users = [SELECT Id FROM User WHERE LastName IN :userLastNames];

		List<SeasonUserStat__c> stats = new List<SeasonUserStat__c>{
			TestDataFactory.initSeasonUserStat(season.Id, users[0].Id, 100, 5),
			TestDataFactory.initSeasonUserStat(season.Id, users[1].Id, 200, 3),
			TestDataFactory.initSeasonUserStat(season.Id, users[2].Id, 300, 7),
			TestDataFactory.initSeasonUserStat(season.Id, users[3].Id, 150, 2)
		};
		insert stats;

		// When
		Test.startTest();
		Map<String, Object> resultMap = SeasonsLeaderboardController.getSeasonData(0);
		Test.stopTest();

		// Then
		Assert.isTrue(resultMap.containsKey('Success'), 'Success is expected');
		Assert.isFalse(resultMap.containsKey('Error'), 'Error is not expected');
		Assert.isFalse(resultMap.containsKey('Warning'), 'Warning is not expected');

		DataWrappers.SeasonData wrapperObj = (DataWrappers.SeasonData) resultMap.get('Success');
		Assert.isNotNull(wrapperObj, 'Wrapper should not be null');
		Assert.areEqual(wrapperObj.dateFrom, season.From__c, 'Season dates are expected to be populated');
		Assert.areEqual(wrapperObj.dateTo, season.To__c, 'Season dates are expected to be populated');

		List<DataWrappers.UserCardData> topThreeByScore = wrapperObj.topThreeByScore;
		Assert.isNotNull(topThreeByScore, 'Top three users are expected to be packed in the wrapper');
		Assert.areEqual(300, topThreeByScore[0].totalScore, 'Highest score should be first');
		Assert.areEqual(200, topThreeByScore[1].totalScore, 'Second highest score should be second');
		Assert.areEqual(150, topThreeByScore[2].totalScore, 'Third highest score should be third');

		List<DataWrappers.UserCardData> topThreeByCount = wrapperObj.topThreeByCount;

		Assert.isNotNull(topThreeByCount, 'Top three users are expected to be packed in the wrapper');
		Assert.areEqual(7, topThreeByCount[0].reachedAchievementsCount, 'Highest score should be first');
		Assert.areEqual(5, topThreeByCount[1].reachedAchievementsCount, 'Second highest score should be second');
		Assert.areEqual(3, topThreeByCount[2].reachedAchievementsCount, 'Third highest score should be third');
	}

	@IsTest
	private static void getSeasonData_seasonDoesNotExist_errorIsReturned() {
		// Given
		// No seasons inserted

		// When
		Test.startTest();
		Map<String, Object> resultMap = SeasonsLeaderboardController.getSeasonData(0);
		Test.stopTest();

		// Then
		Assert.isFalse(resultMap.containsKey('Success'), 'Success is not expected');
		Assert.isTrue(resultMap.containsKey('Error'), 'Error is expected since season wasn\'t found');
		Assert.isFalse(resultMap.containsKey('Warning'), 'Warning is not expected');
	}

	@IsTest
	private static void getSeasonData_exceptionThrown_exceptionHandled() {
		// Given
		SeasonsLeaderboardController.throwException = true;

		// When
		Test.startTest();
		Map<String, Object> resultMap = SeasonsLeaderboardController.getSeasonData(0);
		Test.stopTest();

		// Then
		Assert.isFalse(resultMap.containsKey('Success'), 'Success is not expected');
		Assert.isTrue(resultMap.containsKey('Error'), 'Error is expected');
		Assert.isFalse(resultMap.containsKey('Warning'), 'Warning is not expected');
	}
}