@IsTest(isParallel=true)
private class UserMeasurementIncrTriggerHandlerTest{
	
	@IsTest
	private static void processEvents_singleEventStatsDoesntExist_userStatCreated() {
		// Given
		Id userId = UserInfo.getUserId();
		Measurement__c measurement = TestDataFactory.createMeasurement('measurement');
		UserMeasurementIncrement__e event = new UserMeasurementIncrement__e(UserId__c = userId, MeasurementId__c = measurement.Id, Increment__c = 1);

		// When
		Test.startTest();
		UserMeasurementIncrementTriggerHandler handler = new UserMeasurementIncrementTriggerHandler(new List<UserMeasurementIncrement__e> { event });
		handler.processEvents();
		Test.stopTest();

		// Then
		List<UserMeasurement__c> measurements = [SELECT Id, Value__c FROM UserMeasurement__c WHERE User__c = :userId AND Measurement__c = :measurement.Id];
		system.assertEquals(1, measurements.size(), 'Single stat is expected to be created');
		system.assertEquals(1, measurements[0].Value__c, 'Value__c value should be increased for the sum of the increments from the event');
	}

	@IsTest
	private static void processEvents_multipleEventsWithSameIds_userStatCreated() {
		// Given
		Id userId = UserInfo.getUserId();
		Measurement__c measurement = TestDataFactory.createMeasurement('measurement');
		UserMeasurementIncrement__e event1 = new UserMeasurementIncrement__e(UserId__c = userId, MeasurementId__c = measurement.Id, Increment__c = 1);
		UserMeasurementIncrement__e event2 = new UserMeasurementIncrement__e(UserId__c = userId, MeasurementId__c = measurement.Id, Increment__c = 2);

		// When
		Test.startTest();
		UserMeasurementIncrementTriggerHandler handler = new UserMeasurementIncrementTriggerHandler(new List<UserMeasurementIncrement__e> { event1, event2 });
		handler.processEvents();
		Test.stopTest();

		// Then
		List<UserMeasurement__c> measurements = [SELECT Id, Value__c FROM UserMeasurement__c WHERE User__c = :userId AND Measurement__c = :measurement.Id];
		system.assertEquals(1, measurements.size(), 'Single stat is expected to be created');
		system.assertEquals(3, measurements[0].Value__c, 'Value__c value should be increased for the sum of the increments from the event');
	}

	@IsTest
	private static void processEvents_existingUserStat_userStatUpdated() {
		// Given
		Id userId = UserInfo.getUserId();
		Measurement__c measurement = TestDataFactory.createMeasurement('measurement');
		UserMeasurement__c stat = TestDataFactory.createUserMeasurement(userId, measurement.Id, 10);

		UserMeasurementIncrement__e event = new UserMeasurementIncrement__e(UserId__c = userId, MeasurementId__c = measurement.Id, Increment__c = 1);

		// When
		Test.startTest();
		UserMeasurementIncrementTriggerHandler handler = new UserMeasurementIncrementTriggerHandler(new List<UserMeasurementIncrement__e> { event });
		handler.processEvents();
		Test.stopTest();

		// Then
		List<UserMeasurement__c> measurements = [SELECT Id, Value__c FROM UserMeasurement__c WHERE User__c = :userId AND Measurement__c = :measurement.Id];
		system.assertEquals(1, measurements.size(), 'Single stat is expected to be created');
		system.assertEquals(stat.Id, measurements[0].Id, 'Existing UserMeasurement__c is expected to be updated');
		system.assertEquals(11, measurements[0].Value__c, 'Value__c value should be increased for the sum of the increments from the event');
	}

	@IsTest
	private static void processEvents_nonExistingMeasurementId_logCreated() {
		// Given
		Id userId = UserInfo.getUserId();
		Measurement__c measurement = TestDataFactory.createMeasurement('measurement');
		String measurementId = measurement.Id;
		delete measurement;
		UserMeasurementIncrement__e event = new UserMeasurementIncrement__e(UserId__c = userId, MeasurementId__c = measurementId, Increment__c = 1);

		// When
		Test.startTest();
		UserMeasurementIncrementTriggerHandler handler = new UserMeasurementIncrementTriggerHandler(new List<UserMeasurementIncrement__e> { event });
		handler.processEvents();
		Test.stopTest();

		// Then
		List<Log__c> logs = [SELECT Id, ErrorMessage__c FROM Log__c];
		System.assertEquals(1, logs.size(), 'Error Log is expected to be created');
	}

	@IsTest
	private static void processEvents_incrementIsNull_logCreated() {
		// Given
		Id userId = UserInfo.getUserId();
		Measurement__c measurement = TestDataFactory.createMeasurement('measurement');
		UserMeasurementIncrement__e event = new UserMeasurementIncrement__e(UserId__c = userId, MeasurementId__c = measurement.Id, Increment__c = 0);

		// When
		Test.startTest();
		UserMeasurementIncrementTriggerHandler handler = new UserMeasurementIncrementTriggerHandler(new List<UserMeasurementIncrement__e> { event });
		handler.processEvents();
		Test.stopTest();

		// Then
		List<Log__c> logs = [SELECT Id, ErrorMessage__c FROM Log__c];
		System.assertEquals(1, logs.size(), 'Error Log is expected to be created');
	}

	@IsTest
	private static void onAfterInsert_201EventsGetsPublished_userStatsCreated() {
		// Given
		Id userId = UserInfo.getUserId();
		List<Measurement__c> measurements = new List<Measurement__c>();
		for (Integer i = 0; i <= 201; i++) {
			measurements.add(TestDataFactory.initMeasurement('Measurement' + i));
		}
		insert measurements;

		List<UserMeasurementIncrement__e> events = new List<UserMeasurementIncrement__e>();
		for (Measurement__c measurement : measurements) {
			events.add(new UserMeasurementIncrement__e(UserId__c = userId, MeasurementId__c = measurement.Id, Increment__c = 1));
		}

		// When
		Test.startTest();
		EventBus.publish(events);
		Test.stopTest();

		// Then
		List<UserMeasurement__c> userMeasurements = [SELECT Id, Value__c FROM UserMeasurement__c WHERE User__c = :userId];
		system.assertEquals(202, userMeasurements.size(), 'Single stat is expected to be created');
	}

}