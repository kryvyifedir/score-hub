@IsTest(isParallel=false)
private class SeasonUserMeasurementsBatchTest {

	@TestSetup
	private static void setup() {
		SeasonsConfiguration__c config = new SeasonsConfiguration__c();
		config.IsActive__c = true;
		config.Cadence__c = 'month';
		config.StartDate__c = Date.today();
		insert config;
	}
	
	@IsTest
	private static void execute_allDataExists_userMeasurementsStored() {
		// Given 
		User testUser = TestDataFactory.createUser(UserInfo.getProfileId(), 'Test_SidebarApps');
		Season__c currentSeason = TestDataFactory.createSeason(Date.today().addDays(-3), Date.today());

		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		UserMeasurement__c userMeasurement = TestDataFactory.createUserMeasurement(testUser.Id, measurement.Id, 10);

		// When 
		Test.startTest();
		Database.executeBatch(new SeasonUserMeasurementsBatch(currentSeason.Id), 200);
		Test.stopTest();

		// Then
		List<UserMeasurement__c> userMeasurements = [SELECT Id FROM UserMeasurement__c];
		Assert.isTrue(userMeasurements.isEmpty(), 'UserMeasurement__c sObject records are supposed to be cleaned-up');

		List<SeasonUserMeasurement__c> seasonUserMeasurements = [SELECT Id, User__c, Season__c, Measurement__c, Value__c FROM SeasonUserMeasurement__c];
		Assert.areEqual(1, seasonUserMeasurements.size(), 'Each UserMeasurement__c is expected to be migrated');

		SeasonUserMeasurement__c seasonReachedAchievement = seasonUserMeasurements[0];
		Assert.areEqual(currentSeason.Id, seasonReachedAchievement.Season__c, 'User Id is expected to be migrated');
		Assert.areEqual(testUser.Id, seasonReachedAchievement.User__c, 'User Id is expected to be migrated');
		Assert.areEqual(measurement.Id, seasonReachedAchievement.Measurement__c, 'Measurement Id is expected to be migrated');
		Assert.areEqual(10, seasonReachedAchievement.Value__c, 'Value is expected to be migrated');
	}

	@IsTest
	private static void execute_200userMeasurements_200userMeasurementsStored() {
		// Given 
		User testUser = TestDataFactory.createUser(UserInfo.getProfileId(), 'Test_SidebarApps');
		Season__c currentSeason = TestDataFactory.createSeason(Date.today().addDays(-3), Date.today());

		List<Measurement__c> testMeasurements = new List<Measurement__c>();
		for (Integer i = 0; i < 200; i++) {
			testMeasurements.add(TestDataFactory.initMeasurement('Measurement' + String.valueOf(i)));
		}
		insert testMeasurements;
		testMeasurements = [SELECT Id FROM Measurement__c];

		List<UserMeasurement__c> userMeasurements = new List<UserMeasurement__c>();
		for (Measurement__c measurement : testMeasurements) {
			userMeasurements.add(TestDataFactory.initUserMeasurement(testUser.Id, measurement.Id, 10));
		}
		insert userMeasurements;

		// When 
		Test.startTest();
		Database.executeBatch(new SeasonUserMeasurementsBatch(currentSeason.Id), 200);
		Test.stopTest();

		// Then
		userMeasurements = [SELECT Id FROM UserMeasurement__c];
		Assert.isTrue(userMeasurements.isEmpty(), 'UserMeasurement__c sObject records are supposed to be cleaned-up');

		List<SeasonUserMeasurement__c> seasonUserMeasurements = [SELECT Id, User__c FROM SeasonUserMeasurement__c];
		Assert.areEqual(200, seasonUserMeasurements.size(), 'Each UserMeasurement__c is expected to be migrated');
	}

	@IsTest
	private static void execute_seasonIdIsWrong_exceptionIsThrown() {
		// Given 
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');

		// When 
		try { 
			Test.startTest();
			Database.executeBatch(new SeasonUserMeasurementsBatch(measurement.Id), 200);
			Test.stopTest();

		// Then
			Assert.fail('Exception is expected to be thrown');
		} catch (SeasonUserMeasurementsBatch.SeasonUserMeasurementsBatchException e) {
			String msg = 'Unable to execute SeasonUserMeasurementsBatch. Provided season id is either null or is not of Season__c type';
			Assert.areEqual(msg, e.getMessage(), 'SeasonUserMeasurementsBatchException exception is expected');
		} catch (Exception e) {
			Assert.fail('Exception of SeasonUserMeasurementsBatchException is expected');
		}
	}
}