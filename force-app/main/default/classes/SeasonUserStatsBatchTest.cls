@IsTest(isParallel=false)
private class SeasonUserStatsBatchTest {
	
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
	private static void execute_seasonIdIsWrong_exceptionIsThrown() {
		// Given 
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');

		// When 
		try { 
			Test.startTest();
			Database.executeBatch(new SeasonUserStatsBatch(measurement.Id), 200);
			Test.stopTest();

			Assert.fail('Exception is expected to be thrown');
		} catch (SeasonUserStatsBatch.SeasonUserStatsBatchException e) {
			String msg = 'Unable to execute SeasonUserStatsBatch. Provided season id is either null or is not of Season__c type';
			Assert.areEqual(msg, e.getMessage(), 'SeasonUserStatsBatchException exception is expected');
		} catch (Exception e) {
			Assert.fail('Exception of SeasonUserStatsBatchException is expected');
		}
		
	}

}