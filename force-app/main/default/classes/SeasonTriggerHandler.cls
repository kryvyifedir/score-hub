public with sharing class SeasonTriggerHandler {

	// TODO: Clean-up this code (PRIO 1)
	public static void onAfterInsert(Map<Id, Season__c> newSeasons) {
		Logger logger = new Logger();
		try {
			SeasonsConfiguration__c config = SeasonsConfiguration__c.getOrgDefaults();
			List<CronTrigger> cronJobs = [ SELECT Id, State FROM CronTrigger WHERE Id = :config.SeasonScheduledJobId__c AND State = 'WAITING' ];

			if (!cronJobs.isEmpty()) {
				logger.addLog('SeasonUserStatsBatch is already scheduled');
			} else {
				String jobName = SeasonUserStatsBatch.class + '';
				for (Season__c season : newSeasons.values()) { 
					if (season.To__c != null) {
						Long jobExecutionTimeMS = Datetime.newInstanceGmt(season.To__c, Time.newInstance(22, 0, 0, 0)).getTime();
						Long currentTimeMS = Datetime.now().getTime();
						Integer jobExecutionTimeInMinutesFromNow = (Integer) (jobExecutionTimeMS - currentTimeMS) / 1000 / 60;
	
						config.SeasonScheduledJobId__c = System.scheduleBatch(new SeasonUserStatsBatch(season.Id), jobName, jobExecutionTimeInMinutesFromNow, 200);
						update config;
						break;
					}
				}
			}
		} catch (Exception e) {
			logger.addLog('Unexpected exception caught in SeasonTriggerHandler. ' + e.getMessage() + '. ' + e.getStackTraceString());
		} finally {
			logger.commitChanges();
		}
	}


	//public with sharing class SeasonTriggerHandler {

		// TODO Complete + tests
	
		// public static void onAfterInsert(Map<Id, Season__c> newSeasons) {
		// 	Logger logger = new Logger();
		// 	try {
		// 		String jobName = SeasonUserStatsBatch.class + '';
		// 		Map<Id, Id> scheduledJobsBySeasonId = new Map<Id, Id>();
	
		// 		for (Season__c season : newSeasons.values()) { 
		// 			if (season.To__c != null) {
		// 				Long jobExecutionTimeMS = Datetime.newInstanceGmt(season.To__c, Time.newInstance(22, 0, 0, 0)).getTime();
		// 				Long currentTimeMS = Datetime.now().getTime();
		// 				Integer jobExecutionTimeInMinutesFromNow = (Integer) (jobExecutionTimeMS - currentTimeMS) / 1000 / 60;
	
		// 				Id jobId = null;
		// 				try {
		// 					jobId = System.scheduleBatch(new SeasonUserStatsBatch(season.Id), jobName + ': ' + season.Name, jobExecutionTimeInMinutesFromNow);
		// 				} catch(Exception e) {
		// 					system.debug(e);
		// 					logger.addLog('Unable to Schedule data processing for Season: ' + season.Id + '. Error: ' + e.getMessage());
		// 				}
	
		// 				if (!String.isBlank(jobId)) {
		// 					scheduledJobsBySeasonId.put(season.Id, jobId);
		// 				}
		// 			}
		// 		}
	
		// 		if (!scheduledJobsBySeasonId.keySet().isEmpty()) {
		// 			List<Season__c> seasonsToUpdate = SeasonSelector.getInstance().getByIds(scheduledJobsBySeasonId.keySet());
		// 			for (Season__c season : seasonsToUpdate) {
		// 				season.ScheduledJobId__c = scheduledJobsBySeasonId.get(season.Id);
		// 			}
		// 			update seasonsToUpdate;
		// 		}
		// 	} catch (Exception e) {
		// 		system.debug(e);
		// 		logger.addLog('Unexpected exception caught in SeasonTriggerHandler. ' + e.getMessage() + '. ' + e.getStackTraceString());
		// 	} finally {
		// 		logger.commitChanges();
		// 	}
		// }
	//}
}