@IsTest(isParallel=false)
private class DMLServiceTest {
	@IsTest
	private static void insertRecord_allMandatoryFields_recordInserted() {
		System.runAs(TestDataFactory.createUserTestAdmin()) {
			// Given
			Measurement__c measurement = TestDataFactory.initMeasurement(Constants.CHATTER_POSTS_COUNTER_ID);
			
			// When
			Test.startTest();
			List<Measurement__c> measurements = (List<Measurement__c>) DMLService.insertRecord(new List<sObject>{measurement}, System.AccessLevel.USER_MODE);
			Test.stopTest();

			// Then
			Assert.isFalse(measurements.isEmpty(), 'Records is expected to be inserted');
			Assert.isNotNull(measurements[0].Id, 'Records is expected to be inserted');
		}
	}

	@IsTest
	private static void insertRecord_missingRequiredField_logInserted() {
		System.runAs(TestDataFactory.createUserTestAdmin()) {
			// Given
			Id measurementId;
			Achievement__c achievement = TestDataFactory.initAchievement('Test Achievement', measurementId);
			
			// When
			Test.startTest();
			List<Achievement__c> measurements = (List<Achievement__c>) DMLService.insertRecord(new List<sObject>{achievement}, System.AccessLevel.USER_MODE);
			Test.stopTest();

			// Then
			Assert.isFalse(measurements.isEmpty(), 'Records is not expected to be inserted');
			Assert.isNull(measurements[0].Id, 'Records is not expected to be inserted');

			List<Log__c> logs = [SELECT Id FROM Log__c];
			Assert.isFalse(logs.isEmpty(), 'Log is expected to be created');
		}
	}

	@IsTest
	private static void updateRecord_allMandatoryFields_recordUpdated() {
		System.runAs(TestDataFactory.createUserTestAdmin()) {
			// Given
			Measurement__c measurement = TestDataFactory.createMeasurement(Constants.CHATTER_POSTS_COUNTER_ID);
			measurement.UniqueIdentifier__c = 'Updated Name';
			
			// When
			Test.startTest();
			List<Measurement__c> measurements = (List<Measurement__c>) DMLService.updateRecord(new List<sObject>{measurement}, System.AccessLevel.USER_MODE);
			Test.stopTest();

			// Then
			List<Measurement__c> result = [SELECT Id, UniqueIdentifier__c FROM Measurement__c WHERE Id = :measurement.Id];
			Assert.areEqual('Updated Name', result[0].UniqueIdentifier__c, 'Records is expected to be udpated');
		}
	}

	@IsTest
	private static void updateRecord_missingRequiredField_logInserted() {
		System.runAs(TestDataFactory.createUserTestAdmin()) {
			// Given
			Measurement__c measurement = TestDataFactory.createMeasurement(Constants.CHATTER_POSTS_COUNTER_ID);
			Achievement__c achievement = TestDataFactory.createAchievement('Test Achievement', measurement.Id);
			achievement.UITitle__c = null;
			
			// When
			Test.startTest();
			List<Achievement__c> measurements = (List<Achievement__c>) DMLService.updateRecord(new List<sObject>{achievement}, System.AccessLevel.USER_MODE);
			Test.stopTest();

			// Then
			List<Achievement__c> result = [SELECT Id, UITitle__c FROM Achievement__c WHERE Id = :achievement.Id];
			Assert.isNotNull(result[0].UITitle__c, 'Records is expected to be udpated');

			List<Log__c> logs = [SELECT Id FROM Log__c];
			Assert.isFalse(logs.isEmpty(), 'Log is expected to be created');
		}
	}

	@IsTest
	private static void upsertRecord_allMandatoryFields_recordUpdated() {
		System.runAs(TestDataFactory.createUserTestAdmin()) {
			// Given
			Measurement__c measurement = TestDataFactory.createMeasurement(Constants.CHATTER_POSTS_COUNTER_ID);
			measurement.UniqueIdentifier__c = 'Updated Name';
			
			// When
			Test.startTest();
			List<Measurement__c> measurements = (List<Measurement__c>) DMLService.upsertRecord(new List<sObject>{measurement}, System.AccessLevel.USER_MODE);
			Test.stopTest();

			// Then
			List<Measurement__c> result = [SELECT Id, UniqueIdentifier__c FROM Measurement__c WHERE Id = :measurement.Id];
			Assert.areEqual('Updated Name', result[0].UniqueIdentifier__c, 'Records is expected to be udpated');
		}
	}

	@IsTest
	private static void upsertRecord_missingRequiredField_logInserted() {
		System.runAs(TestDataFactory.createUserTestAdmin()) {
			// Given
			Measurement__c measurement = TestDataFactory.createMeasurement(Constants.CHATTER_POSTS_COUNTER_ID);
			Achievement__c achievement = TestDataFactory.createAchievement('Test Achievement', measurement.Id);
			achievement.UITitle__c = null;
			
			// When
			Test.startTest();
			List<Achievement__c> measurements = (List<Achievement__c>) DMLService.upsertRecord(new List<sObject>{achievement}, System.AccessLevel.USER_MODE);
			Test.stopTest();

			// Then
			List<Achievement__c> result = [SELECT Id, UITitle__c FROM Achievement__c WHERE Id = :achievement.Id];
			Assert.isNotNull(result[0].UITitle__c, 'Records is expected to be udpated');

			List<Log__c> logs = [SELECT Id FROM Log__c];
			Assert.isFalse(logs.isEmpty(), 'Log is expected to be created');
		}
	}

	@IsTest
	private static void deleteRecord_noAccessIssue_recordDeleted() {
		System.runAs(TestDataFactory.createUserTestAdmin()) {
			// Given
			Measurement__c measurement = TestDataFactory.createMeasurement(Constants.CHATTER_POSTS_COUNTER_ID);
			
			// When
			Test.startTest();
			DMLService.deleteRecord(new List<sObject>{measurement}, System.AccessLevel.USER_MODE);
			Test.stopTest();

			// Then
			List<Measurement__c> result = [SELECT Id, UniqueIdentifier__c FROM Measurement__c WHERE Id = :measurement.Id];
			Assert.isTrue(result.isEmpty(), 'Record is expected to be deleted');
		}
	}
	
}