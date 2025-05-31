@IsTest(isParallel=true)
private class SeasonsLeaderboardControllerTest {
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
    private static void getSeasonData_seasonExists_seasonReturned() {
        // Given
        Date today = Date.today();
        Season__c season1 = TestDataFactory.initSeason(today, today.addDays(5));
        Season__c season2 = TestDataFactory.initSeason(today.addDays(6), today.addDays(15));
        insert new List<Season__c> { season1, season2 };

        // When
        Test.startTest();
        Map<String, Object> resultMap = SeasonsLeaderboardController.getSeasonData(0);
        Test.stopTest();

        // Then
        Assert.isTrue(resultMap.containsKey('Success'), 'Success is expected');
        Assert.isFalse(resultMap.containsKey('Error'), 'Error is not expected');
        Assert.isFalse(resultMap.containsKey('Warning'), 'Warning is not expected');
        Object wrapperObj = resultMap.get('Success');
        System.assertNotEquals(null, wrapperObj, 'Wrapper should not be null');
    }

    @IsTest
    private static void getSeasonData_seasonDoesNotExist_nullReturned() {
        // Given
        // No seasons inserted

        // When
        Test.startTest();
        Map<String, Object> resultMap = SeasonsLeaderboardController.getSeasonData(0);
        Test.stopTest();

        // Then
        Assert.isTrue(resultMap.containsKey('Success'), 'Success is expected');
        Assert.isFalse(resultMap.containsKey('Error'), 'Error is not expected');
        Assert.isFalse(resultMap.containsKey('Warning'), 'Warning is not expected');
        Assert.areEqual(null, resultMap.get('Success'), 'Null is expected when no season exists');
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