@IsTest(isParallel=true)
private class UserStatTriggerTest {

	private static List<Achievement__c> createAchievements(Integer numberOfAchivements) {
		List<Achievement__c> achievements = new List<Achievement__c>();
		for (Integer i = 0; i < numberOfAchivements; i++) {
			Achievement__c achievement = TestDataFactory.initAchievement(String.valueOf(i));
			achievement.Goal__c = 5;
			achievements.add(achievement);
		}
		insert achievements;
		return achievements;
	}

	private static List<UserStat__c> initUserStats(List<Achievement__c> achievements, Integer currentProgress) {
		Id userId = UserInfo.getUserId();
		List<UserStat__c> stats = new List<UserStat__c>();
		for (Achievement__c achievement : achievements) {
			UserStat__c stat = TestDataFactory.initUserStat(userId, achievement.Id);
			stat.CurrentProgress__c = currentProgress;
			stats.add(stat);
		}

		return stats;
	}

	@IsTest
	private static void onAfterInsert_201RecordsInserted_noException() {
		// Given
		List<Achievement__c> achievements = createAchievements(201);
		List<UserStat__c> stats = initUserStats(achievements, 20);

		// When
		Test.startTest();
		insert stats;
		Test.stopTest();

		// Then
		system.assert(true, 'No exception is expected when inserting running more then 200 records');
	}

	@IsTest
	private static void onAfterUpdate_201RecordsUpdated_noException() {
		// Given
		List<Achievement__c> achievements = createAchievements(201);
		List<UserStat__c> stats = initUserStats(achievements, 0);
		insert stats;

		// When
		Test.startTest();
		for (UserStat__c stat : stats) {
			stat.CurrentProgress__c = 20;
		}
		update stats;
		Test.stopTest();

		// Then
		system.assert(true, 'No exception is expected when inserting running more then 200 records');
	}
}