@IsTest(isParallel=true)
private class TaskTriggerHandlerTest {
	@IsTest
	private static void onAfterInsert_201RecordsInserted_userMeasurementsCreated(){
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement(Constants.COMPLETED_TASKS_COUNTER_ID);
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		List<Task> tasks = new List<Task>();
		for (Integer i = 0; i <= 201; i++) {
			tasks.add(TestDataFactory.initTask('Call', 'Completed'));
		}

		// When
		Test.startTest();
		insert tasks;
		Test.stopTest();

		// Then
		List<UserMeasurement__c> result = [SELECT Id, User__c, Measurement__c, Value__c FROM UserMeasurement__c];
		System.assertEquals(1, result.size(), 'Single UserMeasurement__c is expected for all 201 Task records');
		System.assertEquals(202, result[0].Value__c, 'Single UserMeasurement__c Value is expected to a total number of Tasks');
	}

	@IsTest
	private static void onAfterUpdate_201RecordsInserted_userMeasurementsCreated(){
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement(Constants.COMPLETED_TASKS_COUNTER_ID);
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		List<Task> tasks = new List<Task>();
		for (Integer i = 0; i <= 201; i++) {
			tasks.add(TestDataFactory.initTask('Call', 'Not Started'));
		}
		insert tasks;

		// When
		Test.startTest();
		for (Task task: tasks) {
			task.Status = 'Completed';
		}
		update tasks;
		Test.stopTest();

		// Then
		List<UserMeasurement__c> result = [SELECT Id, User__c, Measurement__c, Value__c FROM UserMeasurement__c];
		System.assertEquals(1, result.size(), 'Single UserMeasurement__c is expected for all 201 Task records');
		System.assertEquals(202, result[0].Value__c, 'Single UserMeasurement__c Value is expected to a total number of Tasks');
	}

	@IsTest
	private static void onAfterInsert_missingMeasurement_noUserMeasurementsCreated(){
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement('MISSING MEASUREMENT');
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		List<Task> tasks = new List<Task>();
		for (Integer i = 0; i <= 201; i++) {
			tasks.add(TestDataFactory.initTask('Call', 'Completed'));
		}

		// When
		Test.startTest();
		insert tasks;
		Test.stopTest();

		// Then
		List<UserMeasurement__c> result = [SELECT Id, User__c, Measurement__c, Value__c FROM UserMeasurement__c];
		System.assertEquals(0, result.size(), 'Zero UserMeasurement__c is expected to be created');
	}
}