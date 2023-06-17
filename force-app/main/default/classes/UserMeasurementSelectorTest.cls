@IsTest
private class UserMeasurementSelectorTest {
	
	@IsTest
	private static void getByKey_recordWithKeyExists_recordsReturned(){
		// Given
		Id profileId = UserInfo.getProfileId();

		User user1 = TestDataFactory.createUser(profileId, 'user1');
		User user2 = TestDataFactory.createUser(profileId, 'user2');
		Measurement__c measurement = TestDataFactory.createMeasurement('measurement');

		UserMeasurement__c userMeasurement1 = TestDataFactory.createUserMeasurement(user1.Id, measurement.Id, 1);
		UserMeasurement__c userMeasurement2 = TestDataFactory.createUserMeasurement(user2.Id, measurement.Id, 1);

		Map<Id, Id> measurementIdByUserIdMap = new Map<Id, Id> { user1.Id => measurement.Id };

		// When 
		Test.startTest();
		Map<String, UserMeasurement__c> result = UserMeasurementSelector.getByKeys(measurementIdByUserIdMap);
		Test.stopTest();

		// Then
		System.assertEquals(1, result.size(), 'Record is expected to be found');
		System.assert(result.containsKey(user1.Id + '-' + measurement.Id), 'Map is expected to have a specific user userMeasurement');
		System.assertEquals(userMeasurement1.Id, result.get(user1.Id + '-' + measurement.Id).Id, 'Map is expected to have a specific user userMeasurement');
		System.assert(!result.containsKey(user2.Id + '-' + measurement.Id), 'Map is not expected to have a specific user userMeasurement');
	}

	@IsTest
	private static void getByKey_mapIsEmpty_emptyResult(){
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement('measurement');
		Map<Id, Id> measurementIdByUserIdMap = new Map<Id, Id> {UserInfo.getUserId() => measurement.Id};

		// When 
		Test.startTest();
		Map<String, UserMeasurement__c> result = UserMeasurementSelector.getByKeys(measurementIdByUserIdMap);
		Test.stopTest();

		// Then
		System.assertNotEquals(null, result, 'Empty map is expected to be returned');
		System.assertEquals(0, result.size(), 'Empty map is expected to be returned');
	}

	@IsTest
	private static void getByKey_userStatDoesntExist_emptyResult(){
		// Given
		Map<Id, Id> measurementIdByUserIdMap = new Map<Id, Id>();

		// When 
		Test.startTest();
		Map<String, UserMeasurement__c> result = UserMeasurementSelector.getByKeys(measurementIdByUserIdMap);
		Test.stopTest();

		// Then
		System.assertNotEquals(null, result, 'Empty map is expected to be returned');
		System.assertEquals(0, result.size(), 'Empty map is expected to be returned');
	}
}