@IsTest(isParallel=true)
private class UserMeasurementTriggerHandlerTest {
	@IsTest
	private static void getMeasurementsWithUpdatedProgress_currentProgressIsChanged_recordsReturned() {
		// Given
		Id userId = UserInfo.getUserId();
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurment');
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		UserMeasurement__c userMeasurementNew1 = TestDataFactory.createUserMeasurement(userId, measurement.Id, 10);
		UserMeasurement__c userMeasurementNew2 = TestDataFactory.createUserMeasurement(userId, measurement.Id, 10);

		UserMeasurement__c oldMeasurement1 = new UserMeasurement__c(Id = userMeasurementNew1.Id);
		oldMeasurement1.Value__c = userMeasurementNew1.Value__c + 1;
		UserMeasurement__c oldMeasurement2 = new UserMeasurement__c(Id = userMeasurementNew2.Id);
		oldMeasurement2.Value__c = userMeasurementNew2.Value__c;

		Map<Id, UserMeasurement__c> newMap = new Map<Id, UserMeasurement__c> { userMeasurementNew1.Id => userMeasurementNew1, userMeasurementNew2.Id => userMeasurementNew2 };
		Map<Id, UserMeasurement__c> oldMap = new Map<Id, UserMeasurement__c> { oldMeasurement1.Id => oldMeasurement1, oldMeasurement2.Id => oldMeasurement2 };

		// When
		Test.startTest();
		Map<Id, UserMeasurement__c> result = UserMeasurementTriggerHandler.getMeasurementsWithUpdatedProgress(newMap, oldMap);
		Test.stopTest();

		// Then
		Assert.areEqual(1, result.size(), 'Only one UserMeasurement__c record is expected to be returned');
		Assert.isTrue(result.containsKey(userMeasurementNew1.Id), 'Changed UserMeasurement__c is expected to be included');
		Assert.isFalse(result.containsKey(userMeasurementNew2.Id), 'Not changed UserMeasurement__c is not expected to be included');
	}

	@IsTest
	private static void getMeasurementsWithUpdatedProgress_oldMapIsEmpty_newMapIsReturned() {
		// Given
		Id userId = UserInfo.getUserId();
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurment');
		Achievement__c achievement = TestDataFactory.createAchievement('Test', measurement.Id);
		UserMeasurement__c userMeasurementNew1 = TestDataFactory.createUserMeasurement(userId, measurement.Id, 10);
		UserMeasurement__c userMeasurementNew2 = TestDataFactory.createUserMeasurement(userId, measurement.Id, 10);

		Map<Id, UserMeasurement__c> newMap = new Map<Id, UserMeasurement__c> { userMeasurementNew1.Id => userMeasurementNew1, userMeasurementNew2.Id => userMeasurementNew2 };
		Map<Id, UserMeasurement__c> oldMap = new Map<Id, UserMeasurement__c> ();

		// When
		Test.startTest();
		Map<Id, UserMeasurement__c> result = UserMeasurementTriggerHandler.getMeasurementsWithUpdatedProgress(newMap, oldMap);
		Test.stopTest();

		// Then
		Assert.areEqual(2, result.size(), 'Only one UserMeasurement__c record is expected to be returned');
		Assert.isTrue(result.containsKey(userMeasurementNew1.Id), 'Since there are no old UserMeasurement__c records to compare, all "new" records are treated as "changed"');
		Assert.isTrue(result.containsKey(userMeasurementNew2.Id), 'Since there are no old UserMeasurement__c records to compare, all "new" records are treated as "changed"');
	}

	@IsTest
	private static void getMeasurementsWithUpdatedProgress_newMapIsEmpty_emptyMapIsReturned() {
		// Given
		Map<Id, UserMeasurement__c> newMap = new Map<Id, UserMeasurement__c> ();
		Map<Id, UserMeasurement__c> oldMap = new Map<Id, UserMeasurement__c> ();

		// When
		Test.startTest();
		Map<Id, UserMeasurement__c> result = UserMeasurementTriggerHandler.getMeasurementsWithUpdatedProgress(newMap, oldMap);
		Test.stopTest();

		// Then
		Assert.isNotNull(result, 'Empty map is expected but not null');
		Assert.areEqual(0, result.size(), 'Empty map is expected but not null');
	}

	@IsTest
	private static void onAfterInsert_201RecordsInserted_eventsFired() {
		// Given
		Id userId = UserInfo.getUserId();
		List<Measurement__c> measurements = new List<Measurement__c>();
		for (Integer i = 0; i <= 201; i++) {
			measurements.add(TestDataFactory.initMeasurement('Measurement' + i));
		}
		insert measurements;
		
		List<UserMeasurement__c> userMeasurements = new List<UserMeasurement__c>();
		for (Measurement__c measurement : measurements) {
			userMeasurements.add(new UserMeasurement__c(User__c = userId, Measurement__c = measurement.Id, Value__c = 1));
		}

		// When
		try {
			Test.startTest();
			insert userMeasurements;
			Test.stopTest();

			// Then
		} catch (Exception e) {
			Assert.fail('No exception is expected once events are fired');
		}
	}

	@IsTest
	private static void onAfterUpdate_201RecordsInserted_eventsFired() {
		// Given
		Id userId = UserInfo.getUserId();
		List<Measurement__c> measurements = new List<Measurement__c>();
		for (Integer i = 0; i <= 201; i++) {
			measurements.add(TestDataFactory.initMeasurement('Measurement' + i));
		}
		insert measurements;
		
		List<UserMeasurement__c> userMeasurements = new List<UserMeasurement__c>();
		for (Measurement__c measurement : measurements) {
			userMeasurements.add(new UserMeasurement__c(User__c = userId, Measurement__c = measurement.Id, Value__c = 1));
		}
		insert userMeasurements;

		for (UserMeasurement__c userMeasurement : userMeasurements) {
			userMeasurement.Value__c = 10;
		}

		// When
		try {
			Test.startTest();
			update userMeasurements;
			Test.stopTest();

			// Then
		} catch (Exception e) {
			Assert.fail('No exception is expected once events are fired');
		}
	}
}