@IsTest(isParallel=true)
private class SeasonsConfigDataHelperTest {

	@IsTest
	private static void activateConfiguration_noExistingConfig_configCreated() {
		// Given
		// When
		Test.startTest();
		SeasonsConfigDataHelper.activateConfiguration('month', Date.today().addDays(5));
		Test.stopTest();

		// Then
		SeasonsConfiguration__c result = SeasonsConfiguration__c.getOrgDefaults();
		Assert.areEqual(true, result.IsActive__c, 'Expected to update existing config');
		Assert.areEqual('month', result.Cadence__c, 'Expected to update existing config');
		Assert.areEqual(Date.today().addDays(5), result.StartDate__c, 'Expected to update existing config');
	}

	@IsTest
	private static void activateConfiguration_configExists_configUpdated() {
		// Given
		SeasonsConfiguration__c config = new SeasonsConfiguration__c(
			IsActive__c = false,
			Cadence__c = 'year',
			StartDate__c = Date.today()
		);
		insert config;

		// When
		Test.startTest();
		SeasonsConfigDataHelper.activateConfiguration('month', Date.today().addDays(5));
		Test.stopTest();

		// Then
		SeasonsConfiguration__c result = SeasonsConfiguration__c.getOrgDefaults();
		Assert.areEqual(config.Id, result.Id, 'Expected to update existing config');
		Assert.areEqual(true, result.IsActive__c, 'Expected to update existing config');
		Assert.areEqual('month', result.Cadence__c, 'Expected to update existing config');
		Assert.areEqual(Date.today().addDays(5), result.StartDate__c, 'Expected to update existing config');
	}

	@IsTest 
	private static void activateConfiguration_activateFirstTime_seasonCreated() {
		// Given
		// When
		Test.startTest();
		SeasonsConfigDataHelper.activateConfiguration('month', Date.today().addDays(5));
		Test.stopTest();

		// Then
		List<Season__c> seasons = [SELECT Id, To__c FROM Season__c];
		Assert.areEqual(1, seasons.size(), 'Single season is expected to be created');
		Assert.areEqual(Date.today().addDays(4), seasons[0].To__c, 'To__c date of new season is expected to be set as StartDate -1');
	}

	@IsTest 
	private static void activateConfiguration_activateAfterDeactivation_seasonCreated() {
		// Given
		Season__c oldDeactivatedSeason = TestDataFactory.createSeason(Date.today().addDays(-10), Date.today().addDays(-5));

		// When
		Test.startTest();
		SeasonsConfigDataHelper.activateConfiguration('month', Date.today().addDays(5));
		Test.stopTest();

		// Then
		List<Season__c> seasons = [SELECT Id, From__c, To__c FROM Season__c ORDER BY To__c DESC LIMIT 1];
		
		Assert.areNotEqual(oldDeactivatedSeason.Id, seasons[0].Id, 'New season is expected to be created');
		Assert.areEqual(Date.today().addDays(-4), seasons[0].From__c, 'From__c date of new season is expected to be set as To__c date of deactivated season +1 day');
		Assert.areEqual(seasons[0].From__c.addMonths(1).addDays(-1), seasons[0].To__c, 'From__c date + cadence');
	}

	@IsTest 
	private static void activateConfiguration_modifyWithOngoingSeason_seasonModified() {
		// Given
		SeasonsConfigDataHelper.activateConfiguration('month', Date.today().addDays(5));
		List<Season__c> seasons = [SELECT Id, From__c, To__c FROM Season__c ORDER BY To__c DESC LIMIT 1];
		Season__c activeSeason = seasons[0];
		activeSeason.From__c = Date.today().addDays(-10);
		update activeSeason;

		// When
		Test.startTest();
		SeasonsConfigDataHelper.activateConfiguration('year', Date.today().addDays(5));
		Test.stopTest();

		// Then
		seasons = [SELECT Id, From__c, To__c FROM Season__c ORDER BY To__c DESC LIMIT 1];
		Season__c modifiedSeason = seasons[0];
		
		Assert.areEqual(activeSeason.Id, modifiedSeason.Id, 'No new season is expected to be created');
		Assert.areNotEqual(activeSeason.To__c, modifiedSeason.To__c, 'To__c value is updated to match new cadence');
		Assert.areEqual(modifiedSeason.From__c.addYears(1).addDays(-1), modifiedSeason.To__c, 'To__c value is updated to match new cadence');
	}

	@IsTest
	private static void deactivateConfiguration_configExists_configUpdated() {
		// Given
		SeasonsConfiguration__c config = new SeasonsConfiguration__c(
			IsActive__c = true,
			Cadence__c = 'year',
			StartDate__c = Date.today()
		);
		insert config;

		// When
		Test.startTest();
		SeasonsConfigDataHelper.deactivateConfiguration();
		Test.stopTest();

		// Then
		SeasonsConfiguration__c result = SeasonsConfiguration__c.getOrgDefaults();
		Assert.areEqual(config.Id, result.Id, 'Expected to update existing config');
		Assert.areEqual(false, result.IsActive__c, 'Expected to update existing config');
	}

	@IsTest 
	private static void deactivateConfiguration_futureSeasonsExist_futureSeasonsDeleted() {
		// Given
		SeasonsConfigDataHelper.activateConfiguration('month', Date.today().addDays(5));

		// When
		Test.startTest();
		SeasonsConfigDataHelper.deactivateConfiguration();
		Test.stopTest();

		// Then
		List<Season__c> seasons = [SELECT Id, From__c, To__c FROM Season__c ORDER BY To__c DESC LIMIT 1];
		Assert.isTrue(seasons.isEmpty(), 'Future seasons are expected to be deleted');
	}

	@IsTest 
	private static void convertToWrapper_configPassed_wrapperReturned() {
		// Given 
		SeasonsConfiguration__c config = new SeasonsConfiguration__c(
			IsActive__c = true,
			Cadence__c = 'year',
			StartDate__c = Date.today()
		);
		insert config;

		// When
		Test.startTest();
		DataWrappers.SeasonConfig result = SeasonsConfigDataHelper.convertToWrapper(config);
		Test.stopTest();

		// Then
		Assert.areEqual(config.Id, result.id, 'Expected to return wrapper with correct id value');
		Assert.areEqual(config.IsActive__c, result.isActive, 'Expected to return wrapper with correct isActive value');
		Assert.areEqual(config.Cadence__c, result.cadence, 'Expected to return wrapper with correct cadence value');
		Assert.areEqual(config.StartDate__c, result.startDate, 'Expected to return wrapper with correct startDate value');
	}
}