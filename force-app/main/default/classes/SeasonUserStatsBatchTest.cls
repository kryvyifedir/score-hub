@IsTest(isParallel=false)
private class SeasonUserStatsBatchTest {

	@TestSetup
	private static void setup() {
		SeasonsConfiguration__c config = new SeasonsConfiguration__c();
		config.IsActive__c = true;
		config.Cadence__c = 'month';
		config.StartDate__c = Date.today();
		insert config;
	}
	
	@IsTest
	private static void execute_allDataExists_userStatsStored() {
		// Given 
		User userWithAchievement = TestDataFactory.createUser(UserInfo.getProfileId(), 'Test_SidebarApps');
		Season__c currentSeason = TestDataFactory.createSeason(Date.today().addDays(-3), Date.today());

		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement1 = TestDataFactory.createAchievement('Achievement1', measurement.Id);
		ReachedAchievement__c reachedAchievement1 = TestDataFactory.createReachedAchievement(userWithAchievement.Id, achievement1.Id);

		Achievement__c achievement2 = TestDataFactory.createAchievement('Achievement2', measurement.Id);
		ReachedAchievement__c reachedAchievement2 = TestDataFactory.createReachedAchievement(userWithAchievement.Id, achievement2.Id);
		
		// When 
		Test.startTest();
		Database.executeBatch(new SeasonUserStatsBatch(currentSeason.Id), 200);
		Test.stopTest();

		// Then
		List<SeasonUserStat__c> stats = [SELECT Id, Season__c, User__c, TotalAchievementsReached__c, TotalScore__c FROM SeasonUserStat__c];
		Assert.areEqual(1, stats.size(), 'Single SeasonUserStat__c is expected to be created for each user who had achievements');

		SeasonUserStat__c stat = stats[0];
		Assert.areEqual(currentSeason.Id, stat.Season__c, 'Stats are expected to be saved for current Season');
		Assert.areEqual(userWithAchievement.Id, stat.User__c, 'Stats are expected to be saved for current Season');
		Assert.areEqual(2, stat.TotalAchievementsReached__c, 'TotalAchievementsReached__c is expected to have the number of total achievements reached by user');
		Assert.areEqual(achievement1.Score__c + achievement2.Score__c, stat.TotalScore__c, 'TotalScore__c is expected to have a total score of all achievements reached by user');
	}

	@IsTest
	private static void execute_200usersWithAchievements_200userStatsCreated() {
		// Given 
		Season__c currentSeason = TestDataFactory.createSeason(Date.today().addDays(-3), Date.today());

		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);

		Id profileId = UserInfo.getProfileId();
		List<User> testUsers = new List<User>();
		for (Integer i = 0; i < 200; i++) {
			testUsers.add(TestDataFactory.initUser(profileId, 'Test_SidebarApps' + String.valueOf(i)));
		}
		insert testUsers;

		List<ReachedAchievement__c> reachedAchievements = new List<ReachedAchievement__c>();
		testUsers = [SELECT Id FROM User WHERE LastName LIKE 'Test_SidebarApps%'];
		for (User testUser : testUsers) {
			reachedAchievements.add(TestDataFactory.initReachedAchievement(testUser.Id, achievement.Id));
		}
		insert reachedAchievements;

		// When 
		Test.startTest();
		Database.executeBatch(new SeasonUserStatsBatch(currentSeason.Id), 200);
		Test.stopTest();

		// Then
		List<SeasonUserStat__c> stats = [SELECT Id, Season__c, User__c, TotalAchievementsReached__c, TotalScore__c FROM SeasonUserStat__c];
		Assert.areEqual(200, stats.size(), 'Single SeasonUserStat__c is expected to be created for each user who had achievements');
	}

	@IsTest
	private static void execute_seasonsAreDisabled_exceptionIsThrown() {
		// Given 
		SeasonsConfiguration__c config = SeasonsConfiguration__c.getOrgDefaults();
		config.IsActive__c = false;
		update config;
		
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');

		// When 
		try { 
			Test.startTest();
			Database.executeBatch(new SeasonUserStatsBatch(measurement.Id), 200);
			Test.stopTest();

		// Then
			Assert.fail('Exception is expected to be thrown');
		} catch (SeasonUserStatsBatch.SeasonUserStatsBatchException e) {
			String msg = 'SeasonUserStatsBatch execution was stopped - Seasons feature is not active';
			Assert.areEqual(msg, e.getMessage(), 'SeasonUserStatsBatchException exception is expected');
		} catch (Exception e) {
			Assert.fail('Exception of SeasonUserStatsBatchException is expected');
		}
	}

	@IsTest
	private static void execute_seasonIdIsWrong_exceptionIsThrown() {
		// Given 
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');

		// When 
		try { 
			Test.startTest();
			Database.executeBatch(new SeasonUserStatsBatch(measurement.Id), 200);
			Test.stopTest();

		// Then
			Assert.fail('Exception is expected to be thrown');
		} catch (SeasonUserStatsBatch.SeasonUserStatsBatchException e) {
			String msg = 'Unable to execute SeasonUserStatsBatch. Provided season id is either null or is not of Season__c type';
			Assert.areEqual(msg, e.getMessage(), 'SeasonUserStatsBatchException exception is expected');
		} catch (Exception e) {
			Assert.fail('Exception of SeasonUserStatsBatchException is expected');
		}
	}

	@IsTest
	private static void execute_allDataExists_fullIntegrationCheck() {
		// Given 
		User userWithAchievement = TestDataFactory.createUser(UserInfo.getProfileId(), 'Test_SidebarApps');
		Season__c currentSeason = TestDataFactory.createSeason(Date.today().addDays(-3), Date.today());

		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		UserMeasurement__c userMeasurement = TestDataFactory.createUserMeasurement(userWithAchievement.Id, measurement.Id, 10);

		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		ReachedAchievement__c reachedAchievement = TestDataFactory.createReachedAchievement(userWithAchievement.Id, achievement.Id);

		// When 
		Test.startTest();
		Database.executeBatch(new SeasonUserStatsBatch(currentSeason.Id), 200);
		Test.stopTest();

		// Then
		// Creatin SeasonUserStat__c
		List<SeasonUserStat__c> stats = [SELECT Id, Season__c, User__c, TotalAchievementsReached__c, TotalScore__c FROM SeasonUserStat__c];
		Assert.areEqual(1, stats.size(), 'Single SeasonUserStat__c is expected to be created for each user who had achievements');

		// Migrating ReachedAchievement__c
		List<ReachedAchievement__c> reachedAchievements = [SELECT Id FROM ReachedAchievement__c];
		Assert.isTrue(reachedAchievements.isEmpty(), 'ReachedAchievement__c sObject records are supposed to be cleaned-up');
		List<SeasonReachedAchievement__c> seasonReachedAchievements = [SELECT Id, User__c, Season__c, Achievement__c FROM SeasonReachedAchievement__c];
		Assert.areEqual(1, seasonReachedAchievements.size(), 'Each ReachedAchievement__c is expected to be migrated');

		// Migrating UserMeasurement__c
		List<UserMeasurement__c> userMeasurements = [SELECT Id FROM UserMeasurement__c];
		Assert.isTrue(userMeasurements.isEmpty(), 'UserMeasurement__c sObject records are supposed to be cleaned-up');
		List<SeasonUserMeasurement__c> seasonUserMeasurements = [SELECT Id, User__c, Season__c, Measurement__c, Value__c FROM SeasonUserMeasurement__c];
		Assert.areEqual(1, seasonUserMeasurements.size(), 'Each UserMeasurement__c is expected to be migrated');

		// New Season created
		List<Season__c> newSeason = [SELECT Id, From__c, To__c FROM Season__c WHERE Id != :currentSeason.Id];
		Assert.isFalse(newSeason.isEmpty(), 'New Season is expected to be created');
	}

	@IsTest
	private static void finalize_batchExecutedCorrectly_newBatchEnqueued() {
		// Given 
		User userWithAchievement = TestDataFactory.createUser(UserInfo.getProfileId(), 'Test_SidebarApps');
		Season__c currentSeason = TestDataFactory.createSeason(Date.today().addDays(-3), Date.today());

		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement1 = TestDataFactory.createAchievement('Achievement1', measurement.Id);
		ReachedAchievement__c reachedAchievement1 = TestDataFactory.createReachedAchievement(userWithAchievement.Id, achievement1.Id);

		Achievement__c achievement2 = TestDataFactory.createAchievement('Achievement2', measurement.Id);
		ReachedAchievement__c reachedAchievement2 = TestDataFactory.createReachedAchievement(userWithAchievement.Id, achievement2.Id);
		
		// When 
		Test.startTest();
		Id jobId = Database.executeBatch(new SeasonUserStatsBatch(currentSeason.Id), 200);
		Test.stopTest();

		// Then
		List<AsyncApexJob> asyncJobInfo = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
				FROM AsyncApexJob WHERE Id != :jobId];
		Assert.isFalse(asyncJobInfo.isEmpty(), 'New job is expected to be enqueued.');
	}

}