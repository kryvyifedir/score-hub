@IsTest(isParallel=false)
private class SeasonReachedAchievementsBatchTest {
	@IsTest
	private static void execute_allDataExists_reachedAchievementsStored() {
		// Given 
		User userWithAchievement = TestDataFactory.createUser(UserInfo.getProfileId(), 'Test_SidebarApps');
		Season__c currentSeason = TestDataFactory.createSeason(Date.today().addDays(-3), Date.today());

		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		ReachedAchievement__c reachedAchievement = TestDataFactory.createReachedAchievement(userWithAchievement.Id, achievement.Id);

		// When 
		Test.startTest();
		Database.executeBatch(new SeasonReachedAchievementsBatch(currentSeason.Id), 200);
		Test.stopTest();

		// Then
		List<ReachedAchievement__c> reachedAchievements = [SELECT Id FROM ReachedAchievement__c];
		Assert.isTrue(reachedAchievements.isEmpty(), 'ReachedAchievement__c sObject records are supposed to be cleaned-up');

		List<SeasonReachedAchievement__c> seasonReachedAchievements = [SELECT Id, User__c, Season__c, Achievement__c FROM SeasonReachedAchievement__c];
		Assert.areEqual(1, seasonReachedAchievements.size(), 'Each ReachedAchievement__c is expected to be migrated');

		SeasonReachedAchievement__c seasonReachedAchievement = seasonReachedAchievements[0];
		Assert.areEqual(currentSeason.Id, seasonReachedAchievement.Season__c, 'Season is expected to be set');
		Assert.areEqual(userWithAchievement.Id, seasonReachedAchievement.User__c, 'User Id is expected to be migrated');
		Assert.areEqual(achievement.Id, seasonReachedAchievement.Achievement__c, 'Achievement Id is expected to be migrated');
	}

	@IsTest
	private static void execute_200reachedAchievements_200reachedAchievementsStored() {
		// Given 
		User userWithAchievement = TestDataFactory.createUser(UserInfo.getProfileId(), 'Test_SidebarApps');
		Season__c currentSeason = TestDataFactory.createSeason(Date.today().addDays(-3), Date.today());

		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		
		List<Achievement__c> testAchievements = new List<Achievement__c>();
		for (Integer i = 0; i < 200; i++) {
			testAchievements.add(TestDataFactory.initAchievement('Achievement' + String.valueOf(i), measurement.Id));
		}
		insert testAchievements;
		testAchievements = [SELECT Id FROM Achievement__c];

		List<ReachedAchievement__c> reachedAchievements = new List<ReachedAchievement__c>();
		for (Achievement__c achievement : testAchievements) {
			reachedAchievements.add(TestDataFactory.initReachedAchievement(userWithAchievement.Id, achievement.Id));
		}
		insert reachedAchievements;

		// When 
		Test.startTest();
		Database.executeBatch(new SeasonReachedAchievementsBatch(currentSeason.Id), 200);
		Test.stopTest();

		// Then
		reachedAchievements = [SELECT Id FROM ReachedAchievement__c];
		Assert.isTrue(reachedAchievements.isEmpty(), 'ReachedAchievement__c sObject records are supposed to be cleaned-up');

		List<SeasonReachedAchievement__c> seasonReachedAchievements = [SELECT Id, User__c, Achievement__c FROM SeasonReachedAchievement__c];
		Assert.areEqual(200, seasonReachedAchievements.size(), 'Each ReachedAchievement__c is expected to be migrated');
	}

	@IsTest
	private static void execute_seasonIdIsWrong_exceptionIsThrown() {
		// Given 
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');

		// When 
		try { 
			Test.startTest();
			Database.executeBatch(new SeasonReachedAchievementsBatch(measurement.Id), 200);
			Test.stopTest();

			Assert.fail('Exception is expected to be thrown');
		} catch (SeasonReachedAchievementsBatch.SeasonReachedAchievementsBatchException e) {
			String msg = 'Unable to execute SeasonReachedAchievementsBatch. Provided season id is either null or is not of Season__c type';
			Assert.areEqual(msg, e.getMessage(), 'SeasonReachedAchievementsBatchException exception is expected');
		} catch (Exception e) {
			Assert.fail('Exception of SeasonReachedAchievementsBatchException is expected');
		}
		
	}
}