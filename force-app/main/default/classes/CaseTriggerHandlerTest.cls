@IsTest(isParallel=true)
public with sharing class CaseTriggerHandlerTest {
    @IsTest
	private static void onAfterUpdate_201RecordsClosed_userMeasurementsCreated(){
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement(Constants.CLOSED_CASES_ID);
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		List<Case> cases = new List<Case>();
		for (Integer i = 0; i <= 201; i++) {
			cases.add(TestDataFactory.initCase('New'));
		}
		insert cases;

		// When
		Test.startTest();
		for (Case newCase : cases) {
			newCase.Status = 'Closed';
		}
		update cases;
		Test.stopTest();

		// Then
		List<UserMeasurement__c> result = [SELECT Id, User__c, Measurement__c, Value__c FROM UserMeasurement__c];
		System.assertEquals(1, result.size(), 'Single UserMeasurement__c is expected for all 201 Case records');
		System.assertEquals(202, result[0].Value__c, 'Single UserMeasurement__c Value is expected to a total number of Cases');
	}

	@IsTest
	private static void fireEventsForNewCases_measurementSetupIsMissing_userMeasurementsNotCreated(){
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement('WEIRD NAME');
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		List<Case> cases = new List<Case>{ 
			TestDataFactory.initCase('New') 
		};
		insert cases;

		// When
		Test.startTest();
		for (Case newCase : cases) {
			newCase.Status = 'Closed';
		}
		update cases;
		Test.stopTest();

		// Then
		List<UserMeasurement__c> result = [SELECT Id, User__c, Measurement__c, Value__c FROM UserMeasurement__c];
		System.assertEquals(0, result.size(), 'Zero UserMeasurement__c is expected to be created');
	}

	@IsTest
	private static void onAfterUpdate_newMapIsNull_exceptionIsCreated(){
		// Given
		// When
		Test.startTest();
		CaseTriggerHandler.onAfterUpdate(null, null);
		Test.stopTest();

		// Then
		List<Log__c> result = [SELECT Id FROM Log__c];
		System.assertEquals(1, result.size(), 'Error Log is expected to be created');
	}
}