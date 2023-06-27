@IsTest(isParallel=true)
private class GameForceConfigTest {
	@IsTest
	private static void config_noRecordsExist_recordsCreated(){
		// Given

		// When
		Test.startTest();
		GameForceConfig.config();
		Test.stopTest();

		List<Measurement__c> result1 = [SELECT Id FROM Measurement__c];
		System.assertEquals(4, result1.size(), '4 measurements are expected to be created');
		List<Achievement__c> result2 = [SELECT Id FROM Achievement__c];
		System.assertEquals(15, result2.size(), '15 achievements are expected to be created');
	}
}