@IsTest(isParallel=false)
private class SeasonsDataHelperTest {

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
	private static void startNextSeason_seasonExists_newSeasonCreated() {
		// Given
		SeasonsConfiguration__c config = new SeasonsConfiguration__c();
		config.IsActive__c = true;
		config.Cadence__c = 'month';
		config.StartDate__c = Date.today();
		insert config;

		Date today = Date.today();
		Season__c oldSeason = TestDataFactory.createSeason(today.addDays(-6), today);
		
		// When
		Test.startTest();
		SeasonsDataHelper helper = new SeasonsDataHelper();
		Season__c season = helper.startNextSeason(oldSeason.Id);
		Test.stopTest();

		// Then
		Assert.isNotNull(season.Id, 'New season was created');
		Assert.areEqual(today.addDays(1), season.From__c, 'From date is expected to be set the next day after last season to date');
		Assert.areEqual(season.From__c.addMonths(1).addDays(-1), season.To__c, 'To date is expected to be set as From date + cadence - one day');
	}

	@IsTest
	private static void startNextSeason_noSeasonExists_preSeasonCreated() {
		// Given
		SeasonsConfiguration__c config = new SeasonsConfiguration__c();
		config.IsActive__c = true;
		config.Cadence__c = 'month';
		config.StartDate__c = Date.today().addDays(7);
		insert config;

		Date today = Date.today();

		// When
		Test.startTest();
		SeasonsDataHelper helper = new SeasonsDataHelper();
		Season__c season = helper.startNextSeason();
		Test.stopTest();

		// Then
		Assert.isNotNull(season.Id, 'New season was created');
		Assert.areEqual(null, season.From__c, 'Pre seasson doesnt expect to have from date');
		Assert.areEqual(config.StartDate__c.addDays(-1), season.To__c, 'Pre season to date is expected to be set to StartDate from config');
	}

	@IsTest
	private static void validate_featureNotActive_logSaved() {
		// Given
		SeasonsConfiguration__c config = new SeasonsConfiguration__c();
		config.IsActive__c = false;
		config.Cadence__c = 'month';
		config.StartDate__c = Date.today().addDays(7);
		insert config;

		// When
		Test.startTest();
		SeasonsDataHelper helper = new SeasonsDataHelper();
		Boolean result = helper.validate();
		Test.stopTest();

		// Then
		Assert.areEqual(false, result, 'Validation is expected to fail');
	}

	@IsTest
	private static void validate_cadenceIsWrong_logSaved() {
		// Given
		SeasonsConfiguration__c config = new SeasonsConfiguration__c();
		config.IsActive__c = true;
		config.Cadence__c = 'monthly';
		config.StartDate__c = Date.today().addDays(7);
		insert config;

		// When
		Test.startTest();
		SeasonsDataHelper helper = new SeasonsDataHelper();
		Boolean result = helper.validate();
		Test.stopTest();

		// Then
		Assert.areEqual(false, result, 'Validation is expected to fail');
	}

	@IsTest
	private static void calculateNextToDate_monthlyCadence_endOfTheMonth() {
		// Given
		SeasonsConfiguration__c config = new SeasonsConfiguration__c();
		config.IsActive__c = true;
		config.Cadence__c = 'month';
		config.StartDate__c = Date.today().addDays(7);
		insert config;

		Date startDate = Date.newInstance(2025, 01, 01);
		Date expectedDate = Date.newInstance(2025, 01, 31);

		// When
		Test.startTest();
		SeasonsDataHelper helper = new SeasonsDataHelper();
		Date resultDate = helper.calculateNextToDate(startDate);
		Test.stopTest();

		// Then
		Assert.areEqual(expectedDate, resultDate, 'End of the month -1 day is expected');
	}

	@IsTest
	private static void calculateNextToDate_startOfFebruary_endOfFebruary() {
		// Given
		SeasonsConfiguration__c config = new SeasonsConfiguration__c();
		config.IsActive__c = true;
		config.Cadence__c = 'month';
		config.StartDate__c = Date.newInstance(2025, 02, 01);
		insert config;

		Date startDate = Date.newInstance(2025, 02, 01);
		Date expectedDate = Date.newInstance(2025, 02, 28);

		// When
		Test.startTest();
		SeasonsDataHelper helper = new SeasonsDataHelper();
		Date resultDate = helper.calculateNextToDate(startDate);
		Test.stopTest();

		// Then
		Assert.areEqual(expectedDate, resultDate, 'End of February is expected instead of beginning of March');
	}

	@IsTest
	private static void calculateNextToDate_startOfFebruary_endOfFebruaryNextYear() {
		// Given
		SeasonsConfiguration__c config = new SeasonsConfiguration__c();
		config.IsActive__c = true;
		config.Cadence__c = 'year';
		config.StartDate__c = Date.newInstance(2027, 02, 01);
		insert config;

		Date startDate = Date.newInstance(2027, 03, 01);
		Date expectedDate = Date.newInstance(2028, 02, 29); // In 2028 there are 29 days

		// When
		Test.startTest();
		SeasonsDataHelper helper = new SeasonsDataHelper();
		Date resultDate = helper.calculateNextToDate(startDate);
		Test.stopTest();

		// Then
		Assert.areEqual(expectedDate, resultDate, 'End of February is expected instead of beginning of March');
	}

	@IsTest
	private static void calculateNextToDate_quarterlyCadence_endOfQuarter() {
		// Given
		SeasonsConfiguration__c config = new SeasonsConfiguration__c();
		config.IsActive__c = true;
		config.Cadence__c = 'quarter';
		config.StartDate__c = Date.today().addDays(7);
		insert config;

		Date startDate = Date.newInstance(2025, 01, 01);
		Date expectedDate = Date.newInstance(2025, 03, 31);

		// When
		Test.startTest();
		SeasonsDataHelper helper = new SeasonsDataHelper();
		Date resultDate = helper.calculateNextToDate(startDate);
		Test.stopTest();

		// Then
		Assert.areEqual(expectedDate, resultDate, 'End of the quarter -1 day is expected');
	}

	@IsTest
	private static void calculateNextToDate_fourQuartersPassed_sameResultAsEndOfYear() {
		// Given
		SeasonsConfiguration__c config = new SeasonsConfiguration__c();
		config.IsActive__c = true;
		config.Cadence__c = 'quarter';
		config.StartDate__c = Date.today().addDays(7);
		insert config;

		Date startDate = Date.newInstance(2025, 01, 01);
		Date expectedDate = Date.newInstance(2025, 12, 31);

		// When
		Test.startTest();
		SeasonsDataHelper helper = new SeasonsDataHelper();
		Date quarter1 = helper.calculateNextToDate(startDate);
		Date quarter2 = helper.calculateNextToDate(quarter1.addDays(1));
		Date quarter3 = helper.calculateNextToDate(quarter2.addDays(1));
		Date quarter4 = helper.calculateNextToDate(quarter3.addDays(1));
		Test.stopTest();

		// Then
		Assert.areEqual(expectedDate, quarter4, '4 quarters should result in the same end date as yearly cadence');
	}

	@IsTest
	private static void calculateNextToDate_yearlyCadence_endOfQuarter() {
		// Given
		SeasonsConfiguration__c config = new SeasonsConfiguration__c();
		config.IsActive__c = true;
		config.Cadence__c = 'year';
		config.StartDate__c = Date.today().addDays(7);
		insert config;

		Date startDate = Date.newInstance(2025, 01, 01);
		Date expectedDate = Date.newInstance(2025, 12, 31);

		// When
		Test.startTest();
		SeasonsDataHelper helper = new SeasonsDataHelper();
		Date resultDate = helper.calculateNextToDate(startDate);
		Test.stopTest();

		// Then
		Assert.areEqual(expectedDate, resultDate, 'End of the year -1 day is expected');
	}

	@IsTest
	private static void getSeasonTopThreeStandings_statsExist_topThreeReturned() {
		// Given
		Season__c season = TestDataFactory.createSeason(Date.today(), Date.today().addDays(30));
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
		SeasonsDataHelper helper = new SeasonsDataHelper();
		DataWrappers.SeasonData seasonData = helper.getSeasonTopThreeStandings(season);
		Test.stopTest();

		// Then
		Assert.areEqual(seasonData.dateFrom, season.From__c, 'Season dates are expected to be populated');
		Assert.areEqual(seasonData.dateTo, season.To__c, 'Season dates are expected to be populated');

		List<DataWrappers.UserCardData> topThreeByScore = seasonData.topThreeByScore;
		Assert.isNotNull(topThreeByScore, 'Top three users are expected to be packed in the wrapper');
		Assert.areEqual(300, topThreeByScore[0].totalScore, 'Highest score should be first');
		Assert.areEqual(200, topThreeByScore[1].totalScore, 'Second highest score should be second');
		Assert.areEqual(150, topThreeByScore[2].totalScore, 'Third highest score should be third');

		List<DataWrappers.UserCardData> topThreeByCount = seasonData.topThreeByCount;

		Assert.isNotNull(topThreeByCount, 'Top three users are expected to be packed in the wrapper');
		Assert.areEqual(7, topThreeByCount[0].reachedAchievementsCount, 'Highest score should be first');
		Assert.areEqual(5, topThreeByCount[1].reachedAchievementsCount, 'Second highest score should be second');
		Assert.areEqual(3, topThreeByCount[2].reachedAchievementsCount, 'Third highest score should be third');
	}

	@IsTest
	private static void getSeasonTopThreeStandings_statsDontExist_emptyListReturned() {
		// Given
		Season__c season = TestDataFactory.createSeason(Date.today(), Date.today().addDays(30));
		// No stats inserted

		// When
		Test.startTest();
		SeasonsDataHelper helper = new SeasonsDataHelper();
		DataWrappers.SeasonData seasonData = helper.getSeasonTopThreeStandings(season);
		Test.stopTest();

		// Then
		List<DataWrappers.UserCardData> topThreeByScore = seasonData.topThreeByScore;
		Assert.isNotNull(topThreeByScore, 'Top three users are expected to be packed in the wrapper');
		Assert.isTrue(topThreeByScore.isEmpty(), 'Top three by score is expected to be empty');

		List<DataWrappers.UserCardData> topThreeByCount = seasonData.topThreeByCount;
		Assert.isNotNull(topThreeByCount, 'Top three users are expected to be packed in the wrapper');
		Assert.isTrue(topThreeByCount.isEmpty(), 'Top three by score is expected to be empty');
	}
}