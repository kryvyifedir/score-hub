@IsTest(isParallel=true)
private class SeasonSelectorTest {
	@IsTest
	private static void sObjectType_sObjectTypeReturned_nameIsValidated() {
		// Given
		SeasonSelector selector = SeasonSelector.getInstance();
		
		// When
		Test.startTest();
		SObjectType result = selector.sObjectType();
		Test.stopTest();

		// Then 
		Assert.areEqual(Season__c.getSobjectType(), result, 'Season__c sObjectType is expected');
	}

	@IsTest
	private static void queryFields_sObjectFieldsReturned_fieldSetIsValidated() {
		// Given
		SeasonSelector selector = SeasonSelector.getInstance();
		
		// When
		Test.startTest();
		Set<SObjectField> result = selector.queryFields();
		Test.stopTest();

		// Then 
		Set<SObjectField> expectedSet = new Set<SObjectField> { Season__c.Id, Season__c.From__c, Season__c.To__c, Season__c.IsActive__c };
		Assert.areEqual(expectedSet, result, 'A specific field set is expected');
	}

	@IsTest
	private static void getLatestSeason_twoSeasonsExist_latestSeasonReturned() {
		// Given
		SeasonSelector selector = SeasonSelector.getInstance();

		Date today = Date.today();
		Season__c season1 = TestDataFactory.initSeason(today, today.addDays(5));
		Season__c season2 = TestDataFactory.initSeason(today.addDays(6), today.addDays(15));
		insert new List<Season__c> { season1, season2 };

		// When
		Test.startTest();
		Season__c latestSeason = selector.getLatestSeason();
		Test.stopTest();

		// Then
		Assert.areEqual(season2.Id, latestSeason.Id, 'Latest season is expected to be returned');
	}

	@IsTest
	private static void getSeasonWithOffset_requestingRecordWithOffset_recordWithOffsetIsReturned() {
		// Given
		SeasonSelector selector = SeasonSelector.getInstance();

		Date today = Date.today();
		Season__c season1 = TestDataFactory.initSeason(today, today.addDays(5));
		Season__c season2 = TestDataFactory.initSeason(today.addDays(6), today.addDays(15));
		Season__c season3 = TestDataFactory.initSeason(today.addDays(16), today.addDays(31));
		Season__c season4 = TestDataFactory.initSeason(today.addDays(32), today.addDays(45));
		insert new List<Season__c> { season1, season2, season3, season4 };

		// When
		Test.startTest();
		Season__c result = selector.getSeasonWithOffset(2);
		Test.stopTest();

		// Then
		Assert.areEqual(season2.Id, result.Id, 'Third season ordered by date desc is expected');
		Assert.areEqual(today.addDays(6), result.From__c, 'Third season ordered by date desc is expected');
		Assert.areEqual(today.addDays(6), result.From__c, 'Third season ordered by date desc is expected');
	}

	@IsTest
	private static void getSeasonCount_lessThen120SeasonsExist_countIsReturned() {
		// Given
		SeasonSelector selector = SeasonSelector.getInstance();
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
		Integer result = selector.getSeasonCount();
		Test.stopTest();

		// Then
		Assert.areEqual(10, result, 'Count is expected to be returned');
	}

	@IsTest
	private static void getSeasonCount_moreThen120SeasonsExist_maxCount120IsReturned() {
		// Given
		SeasonSelector selector = SeasonSelector.getInstance();
		Integer expectedNumberOfSeasons = 256;
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
		Integer result = selector.getSeasonCount();
		Test.stopTest();

		// Then
		Assert.areEqual(120, result, 'Max count is expected to be 120');
	}

	@IsTest
	private static void getSeasonCount_noSeasonsExist_zeroIsReturned() {
		// Given
		SeasonSelector selector = SeasonSelector.getInstance();

		// When
		Test.startTest();
		Integer result = selector.getSeasonCount();
		Test.stopTest();

		// Then
		Assert.areEqual(0, result, '0 is expected if no Seasons exist');
	}
}