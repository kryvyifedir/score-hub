@IsTest
public with sharing class LoggerTest {
	
	@IsTest
	private static void saveNewLog_logsAddedAndCommited_logsSaved(){
		// Given
		String log = 'LOG';
		User testUsr = TestDataFactory.createUser(UserInfo.getProfileId(), 'Test');
		TestDataFactory.assignPermissionSet(testUsr.Id, 'ScoreHubModifyLogs');

		system.runAs(testUsr) {
			// When
			Test.startTest();
			Logger logger = new Logger();
			logger.addLog(log);
			logger.commitChanges();
			Test.stopTest();

			// Then
			List<Log__c> logs = [SELECT Id, ErrorMessage__c, UserId__c, AchievementId__c FROM Log__c];
			Assert.areEqual(1, logs.size(), 'Single log is expected to be created');
			Assert.areEqual(log, logs[0].ErrorMessage__c, 'Log value is expected to be saved in Log__c field');
		}
	}

	@IsTest
	private static void saveNewLog_noLogsAddedAndCommited_nothingWasSaved(){
		// Given

		// When
		Test.startTest();
		Logger logger = new Logger();
		logger.commitChanges();
		Test.stopTest();

		// Then
		List<Log__c> logs = [SELECT Id, ErrorMessage__c FROM Log__c];
		Assert.areEqual(0, logs.size(), 'No logs are expected to be created');
	}

	@IsTest
	private static void saveNewLog_emptyLogValue_nothingWasSaved(){
		// Given
		String log = '';

		// When
		Test.startTest();
		Logger logger = new Logger();
		logger.addLog(log);
		logger.commitChanges();
		Test.stopTest();

		// Then
		List<Log__c> logs = [SELECT Id, ErrorMessage__c FROM Log__c];
		Assert.areEqual(0, logs.size(), 'No logs are expected to be created');
	}

	@IsTest
	private static void saveSingleLog_noIssues_logsSaved(){
		// Given
		String log = 'LOG';
		User testUsr = TestDataFactory.createUser(UserInfo.getProfileId(), 'Test');
		TestDataFactory.assignPermissionSet(testUsr.Id, 'ScoreHubModifyLogs');

		system.runAs(testUsr) {
			// When
			Test.startTest();
			Logger.saveSingleLog(log);
			Test.stopTest();

			// Then
			List<Log__c> logs = [SELECT Id, ErrorMessage__c FROM Log__c];
			Assert.areEqual(1, logs.size(), 'Single log is expected to be created');
			Assert.areEqual(log, logs[0].ErrorMessage__c, 'Log value is expected to be saved in Log__c field');
		}
	}
}