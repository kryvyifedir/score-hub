public with sharing class GameForceConfig {
	public static void config() {
		List<Measurement__c> measurementsToInsert = new List<Measurement__c>();
		List<Achievement__c> achievementsToInsert = new List<Achievement__c>();

		Measurement__c createLeadMeasurement = new Measurement__c();
		createLeadMeasurement.UniqueIdentifier__c = Constants.CREATED_LEADS_COUNTER_ID;
		createLeadMeasurement.Description__c = 'Number of Leads that were created by user';
		measurementsToInsert.add(createLeadMeasurement);

		Measurement__c convertedLeadMeasurement = new Measurement__c(
			UniqueIdentifier__c = Constants.CONVERTED_LEADS_COUNTER_ID, 
			Description__c = 'Number of Leads that were converted by user');
		measurementsToInsert.add(convertedLeadMeasurement);

		Measurement__c completedTasksMeasurement = new Measurement__c(
			UniqueIdentifier__c = Constants.COMPLETED_TASKS_COUNTER_ID, 
			Description__c = 'Number of Tasks that were completed by user');
		measurementsToInsert.add(completedTasksMeasurement);

		Measurement__c chatterPostsMeasurement = new Measurement__c(
			UniqueIdentifier__c = Constants.CHATTER_POSTS_COUNTER_ID,
			Description__c = 'Number of Tasks that were completed by user');
		measurementsToInsert.add(chatterPostsMeasurement);

		Measurement__c closedCasesMeasurement = new Measurement__c(
			UniqueIdentifier__c = Constants.CLOSED_CASES_ID,
			Description__c = 'Number of Cases that were closed by user');
		measurementsToInsert.add(closedCasesMeasurement);

		insert measurementsToInsert;

		// Created Leads achievements
		Achievement__c created10Leads = new Achievement__c(
			Measurement__c = createLeadMeasurement.Id,
			Name = 'Created Leads LVL1',
			UITitle__c = 'Sourcer',
			UIDescription__c = 'Created 10 Leads',
			Description__c = 'Standard Achievement, that can be reached by creating 10 different Leads',
			Goal__c = 10,
			Score__c = 10,
			Enabled__c = true);
		achievementsToInsert.add(created10Leads);

		Achievement__c created50Leads = new Achievement__c(
			Measurement__c = createLeadMeasurement.Id,
			Name = 'Created Leads LVL2',
			UITitle__c = 'Tracker',
			UIDescription__c = 'Created 50 Leads',
			Description__c = 'Standard Achievement, that can be reached by creating 50 different Leads',
			Goal__c = 50,
			Score__c = 20,
			Enabled__c = true);
		achievementsToInsert.add(created50Leads);

		Achievement__c created100Leads = new Achievement__c(
			Measurement__c = createLeadMeasurement.Id,
			Name = 'Created Leads LVL3',
			UITitle__c = 'Hunter',
			UIDescription__c = 'Created 100 Leads',
			Description__c = 'Standard Achievement, that can be reached by creating 100 different Leads',
			Goal__c = 100,
			Score__c = 50,
			Enabled__c = true);
		achievementsToInsert.add(created100Leads);

		Achievement__c created200Leads = new Achievement__c(
			Measurement__c = createLeadMeasurement.Id,
			Name = 'Created Leads LVL4',
			UITitle__c = 'Ninja',
			UIDescription__c = 'Created 200 Leads',
			Description__c = 'Standard Achievement, that can be reached by creating 200 different Leads',
			Goal__c = 200,
			Score__c = 100,
			Enabled__c = true);
		achievementsToInsert.add(created200Leads);

		// Converted Leads achievements
		Achievement__c converted10Leads = new Achievement__c(
			Measurement__c = convertedLeadMeasurement.Id,
			Name = 'Converted Leads LVL1',
			UITitle__c = 'Converter',
			UIDescription__c = 'Converted 10 Leads',
			Description__c = 'Standard Achievement, that can be reached by converting 10 different Leads to Accounts/Contacts/Opportunities',
			Goal__c = 10,
			Score__c = 10,
			Enabled__c = true);
		achievementsToInsert.add(converted10Leads);

		Achievement__c converted50Leads = new Achievement__c(
			Measurement__c = convertedLeadMeasurement.Id,
			Name = 'Converted Leads LVL2',
			UITitle__c = 'Transformer',
			UIDescription__c = 'Converted 50 Leads',
			Description__c = 'Standard Achievement, that can be reached by converting 50 different Leads to Accounts/Contacts/Opportunities',
			Goal__c = 50,
			Score__c = 20,
			Enabled__c = true);
		achievementsToInsert.add(converted50Leads);

		Achievement__c converted100Leads = new Achievement__c(
			Measurement__c = convertedLeadMeasurement.Id,
			Name = 'Converted Leads LVL3',
			UITitle__c = 'Metamorphist',
			UIDescription__c = 'Converted 100 Leads',
			Description__c = 'Standard Achievement, that can be reached by converting 100 different Leads to Accounts/Contacts/Opportunities',
			Goal__c = 100,
			Score__c = 100,
			Enabled__c = true);
		achievementsToInsert.add(converted100Leads);

		// Completed Tasks achievements
		Achievement__c complete10Tasks = new Achievement__c(
			Measurement__c = completedTasksMeasurement.Id,
			Name = 'Completed Tasks LVL1',
			UITitle__c = 'Closer',
			UIDescription__c = 'Complete 10 Tasks',
			Description__c = 'Standard Achievement, that can be reached by completing 10 different tasks',
			Goal__c = 10,
			Score__c = 10,
			Enabled__c = true);
		achievementsToInsert.add(complete10Tasks);

		Achievement__c complete50Tasks = new Achievement__c(
			Measurement__c = completedTasksMeasurement.Id,
			Name = 'Completed Tasks LVL2',
			UITitle__c = 'Taskmaster',
			UIDescription__c = 'Complete 50 Tasks',
			Description__c = 'Standard Achievement, that can be reached by completing 50 different tasks',
			Goal__c = 50,
			Score__c = 20,
			Enabled__c = true);
		achievementsToInsert.add(complete50Tasks);

		Achievement__c complete100Tasks = new Achievement__c(
			Measurement__c = completedTasksMeasurement.Id,
			Name = 'Completed Tasks LVL3',
			UITitle__c = 'Completionist',
			UIDescription__c = 'Complete 100 Tasks',
			Description__c = 'Standard Achievement, that can be reached by completing 100 different tasks',
			Goal__c = 100,
			Score__c = 20,
			Enabled__c = true);
		achievementsToInsert.add(complete100Tasks);

		Achievement__c complete200Tasks = new Achievement__c(
			Measurement__c = completedTasksMeasurement.Id,
			Name = 'Completed Tasks LVL4',
			UITitle__c = 'Executor',
			UIDescription__c = 'Complete 200 Tasks',
			Description__c = 'Standard Achievement, that can be reached by completing 200 different tasks',
			Goal__c = 200,
			Score__c = 100,
			Enabled__c = true);
		achievementsToInsert.add(complete200Tasks);

		// Posted chatted posts achievements
		Achievement__c chatter10Posts = new Achievement__c(
			Measurement__c = chatterPostsMeasurement.Id,
			Name = 'Chatter Posts LVL1',
			UITitle__c = 'Enthusiast',
			UIDescription__c = 'Create 10 Chatter posts',
			Description__c = 'Standard Achievement, that can be reached by creating 10 posts in Chatter',
			Goal__c = 10,
			Score__c = 10,
			Enabled__c = true);
		achievementsToInsert.add(chatter10Posts);

		Achievement__c chatter50Posts = new Achievement__c(
			Measurement__c = chatterPostsMeasurement.Id,
			Name = 'Chatter Posts LVL3',
			UITitle__c = 'Messenger',
			UIDescription__c = 'Create 50 Chatter posts',
			Description__c = 'Standard Achievement, that can be reached by creating 50 posts in Chatter',
			Goal__c = 50,
			Score__c = 10,
			Enabled__c = true);
		achievementsToInsert.add(chatter50Posts);

		Achievement__c chatter100Posts = new Achievement__c(
			Measurement__c = chatterPostsMeasurement.Id,
			Name = 'Chatter Posts LVL3',
			UITitle__c = 'Collaborator',
			UIDescription__c = 'Create 100 Chatter posts',
			Description__c = 'Standard Achievement, that can be reached by creating 100 posts in Chatter',
			Goal__c = 100,
			Score__c = 20,
			Enabled__c = true);
		achievementsToInsert.add(chatter100Posts);

		Achievement__c chatter200Posts = new Achievement__c(
			Measurement__c = chatterPostsMeasurement.Id,
			Name = 'Chatter Posts LVL4',
			UITitle__c = 'Team Player',
			UIDescription__c = 'Create 200 Chatter posts',
			Description__c = 'Standard Achievement, that can be reached by creating 200 posts in Chatter',
			Goal__c = 200,
			Score__c = 50,
			Enabled__c = true);
		achievementsToInsert.add(chatter200Posts);

		Achievement__c case10Closed = new Achievement__c(
			Measurement__c = closedCasesMeasurement.Id,
			Name = 'Cases Closed LVL1',
			UITitle__c = 'Detective',
			UIDescription__c = 'Close 10 cases',
			Description__c = 'Standard Achievement, that can be reached by closing 10 Cases',
			Goal__c = 10,
			Score__c = 10,
			Enabled__c = true);
		achievementsToInsert.add(case10Closed);

		Achievement__c case50Closed = new Achievement__c(
			Measurement__c = closedCasesMeasurement.Id,
			Name = 'Cases Closed LVL2',
			UITitle__c = 'Watson',
			UIDescription__c = 'Close 50 cases',
			Description__c = 'Standard Achievement, that can be reached by closing 50 Cases',
			Goal__c = 50,
			Score__c = 20,
			Enabled__c = true);
		achievementsToInsert.add(case50Closed);

		Achievement__c case100Closed = new Achievement__c(
			Measurement__c = closedCasesMeasurement.Id,
			Name = 'Cases Closed LVL3',
			UITitle__c = 'Sherlock',
			UIDescription__c = 'Close 100 cases',
			Description__c = 'Standard Achievement, that can be reached by closing 50 Cases',
			Goal__c = 100,
			Score__c = 100,
			Enabled__c = true);
		achievementsToInsert.add(case100Closed);
		

		insert achievementsToInsert;
	}
}