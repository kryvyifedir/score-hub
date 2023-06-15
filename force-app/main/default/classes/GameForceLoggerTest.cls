@IsTest(isParallel=true)
public with sharing class GameForceLoggerTest {
	
	@IsTest
	private static void saveNewLog_logsAddedAndCommited_logsSaved(){
		// Given
		String userId = 'userId';
		String achievementId = 'achievementId';
		String log = 'LOG';

		// When
		Test.startTest();
		GameForceLogger logger = new GameForceLogger();
		logger.addLog(log, userId, achievementId);
		logger.commitChanges();
		Test.stopTest();

		// Then
		List<GameForceLog__c> logs = [SELECT Id, Log__c, UserId__c, AchievementId__c FROM GameForceLog__c];
		System.assertEquals(1, logs.size(), 'Single log is expected to be created');
		System.assertEquals(log, logs[0].Log__c, 'Log value is expected to be saved in Log__c field');
		System.assertEquals(userId, logs[0].UserId__c, 'User Id value is expected to be saved in UserId__c field');
		System.assertEquals(achievementId, logs[0].AchievementId__c, 'Achievement Id value is expected to be saved in AchievementId__c field');
	}

	@IsTest
	private static void saveNewLog_noLogsAddedAndCommited_nothingWasSaved(){
		// Given

		// When
		Test.startTest();
		GameForceLogger logger = new GameForceLogger();
		logger.commitChanges();
		Test.stopTest();

		// Then
		List<GameForceLog__c> logs = [SELECT Id, Log__c, UserId__c, AchievementId__c FROM GameForceLog__c];
		System.assertEquals(0, logs.size(), 'No logs are expected to be created');
	}

	@IsTest
	private static void saveSingleLog_noIssues_logsSaved(){
		// Given
		String userId = 'userId';
		String achievementId = 'achievementId';
		String log = 'LOG';

		// When
		Test.startTest();
		GameForceLogger.saveSingleLog(log, userId, achievementId);
		Test.stopTest();

		// Then
		List<GameForceLog__c> logs = [SELECT Id, Log__c, UserId__c, AchievementId__c FROM GameForceLog__c];
		System.assertEquals(1, logs.size(), 'Single log is expected to be created');
		System.assertEquals(log, logs[0].Log__c, 'Log value is expected to be saved in Log__c field');
		System.assertEquals(userId, logs[0].UserId__c, 'User Id value is expected to be saved in UserId__c field');
		System.assertEquals(achievementId, logs[0].AchievementId__c, 'Achievement Id value is expected to be saved in AchievementId__c field');
	}
}