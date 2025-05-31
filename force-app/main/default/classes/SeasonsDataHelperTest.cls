@IsTest(isParallel=true)
private class SeasonsDataHelperTest {

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
	private static void convertToWrapper_validSeason_returnsCorrectWrapper() {
		// Given
		Date fromDate = Date.newInstance(2024, 6, 1);
		Date toDate = Date.newInstance(2024, 6, 30);
		Season__c season = new Season__c(From__c = fromDate, To__c = toDate);

		// When
		SeasonsDataHelper helper = new SeasonsDataHelper();
		DataWrappers.SeasonData wrapper = helper.convertToWrapper(season);

		// Then
		Assert.areEqual(fromDate, wrapper.dateFrom, 'Wrapper dateFrom should match season From__c');
		Assert.areEqual(toDate, wrapper.dateTo, 'Wrapper dateTo should match season To__c');
	}
}