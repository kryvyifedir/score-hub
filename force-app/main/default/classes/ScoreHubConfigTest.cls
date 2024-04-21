@IsTest(isParallel=true)
private class ScoreHubConfigTest {
	@IsTest
	private static void config_noRecordsExist_recordsCreated(){
		// Given
		InstallContext context;

		// When
		Test.startTest();
		ScoreHubConfig config = new ScoreHubConfig();
		config.onInstall(context);
		Test.stopTest();

		List<Measurement__c> result1 = [SELECT Id FROM Measurement__c];
		System.assertEquals(5, result1.size(), '5 measurements are expected to be created');
		List<Achievement__c> result2 = [SELECT Id FROM Achievement__c];
		System.assertEquals(18, result2.size(), '18 achievements are expected to be created');
	}
}