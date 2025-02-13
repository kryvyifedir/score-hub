// TODO: Redo once SeasonsConfigDataHelper is refactored
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

	// TODO: activateConfiguration_seasonDoesntExist_seasonCreated
	// TODO: activateConfiguration_seasonExist_seasonUpdated???

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

	// TODO: deactivateConfiguration_jobScheduled_jobUnscheduled
	// TODO: deactivateConfiguration_seasonExists_ToDateUpdated
}