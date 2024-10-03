@IsTest(isParallel=true)
private class UniqueKeyFormatterTest {
	@IsTest
	private static void generateUniqueKey_idsPassed_keyGenerated(){
		// Given
		Id userId = UserInfo.getUserId();
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');

		// When
		Test.startTest();
		String result = UniqueKeyFormatter.generateUniqueKey(userId, measurement.Id);
		Test.stopTest();

		// Then
		Assert.areEqual(userId + '-' + measurement.Id, result, 'Key is expected to match the format');
	}
}