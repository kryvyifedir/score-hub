@IsTest(isParallel=true)
private class LeadTriggerHandlerTest {
	@IsTest
	private static void onAfterInsert_201RecordsInserted_userMeasurementsCreated(){
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement(Constants.CREATED_LEADS_COUNTER_ID);
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		List<Lead> leads = new List<Lead>();
		for (Integer i = 0; i <= 201; i++) {
			leads.add(TestDataFactory.initLead('TestLead' + i));
		}

		// When
		Test.startTest();
		insert leads;
		Test.stopTest();

		// Then
		List<UserMeasurement__c> result = [SELECT Id, User__c, Measurement__c, Value__c FROM UserMeasurement__c];
		System.assertEquals(1, result.size(), 'Single UserMeasurement__c is expected for all 201 Lead records');
		System.assertEquals(202, result[0].Value__c, 'Single UserMeasurement__c Value is expected to a total number of Leads');
	}

	@IsTest
	private static void onAfterUpdate_201RecordsConverted_userMeasurementsCreated(){
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement(Constants.CONVERTED_LEADS_COUNTER_ID);
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		List<Lead> leads = new List<Lead>();
		for (Integer i = 0; i <= 201; i++) {
			leads.add(TestDataFactory.initLead('TestLead' + i));
		}
		insert leads;

		LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];

		// When
		Test.startTest();
		List<Database.LeadConvert> leadsToConvert = new List<Database.LeadConvert>();
		for (Lead newLead : leads) {
			Database.LeadConvert leadToConvert = new Database.LeadConvert();
			leadToConvert.setConvertedStatus(convertStatus.MasterLabel);
			leadToConvert.setLeadId(newLead.id);
			leadsToConvert.add(leadToConvert);
		}
		Database.convertLead(leadsToConvert);
		Test.stopTest();

		// Then
		List<UserMeasurement__c> result = [SELECT Id, User__c, Measurement__c, Value__c FROM UserMeasurement__c];
		System.assertEquals(1, result.size(), 'Single UserMeasurement__c is expected for all 201 Lead records');
		System.assertEquals(202, result[0].Value__c, 'Single UserMeasurement__c Value is expected to a total number of Leads');
	}

	@IsTest
	private static void fireEventsForNewLeads_measurementSetupIsMissing_userMeasurementsNotCreated(){
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement('WEIRD NAME');
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		List<Lead> leads = new List<Lead>{ 
			TestDataFactory.initLead('TestLead') 
		};

		// When
		Test.startTest();
		insert leads;
		Test.stopTest();

		// Then
		List<UserMeasurement__c> result = [SELECT Id, User__c, Measurement__c, Value__c FROM UserMeasurement__c];
		System.assertEquals(0, result.size(), 'Zero UserMeasurement__c is expected to be created');
	}

	@IsTest
	private static void onAfterUpdate_newMapIsNull_ExceptionIsExpected(){
		// Given
		// When
		Test.startTest();
		LeadTriggerHandler.onAfterUpdate(null, null);
		Test.stopTest();

		// Then
		List<Log__c> result = [SELECT Id FROM Log__c];
		System.assertEquals(1, result.size(), 'Error Log is expected to be created');
	}
}