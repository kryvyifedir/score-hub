public with sharing class NextSeasonSchedulable implements Schedulable{
	@TestVisible
	private static Boolean throwException = false;

	public void execute(SchedulableContext sc) {
		try {
			if (throwException) {
				throw new TestDataFactory.TestException();
			}

			SeasonsConfiguration__c config = SeasonsConfiguration__c.getOrgDefaults();
			if (config.IsActive__c) {
				Season__c currentSeason = SeasonSelector.getInstance().getLatestSeason();
				config.SeasonScheduledJobId__c = Database.executeBatch(new SeasonUserStatsBatch(currentSeason.Id));
				update config;
			}
		} catch (Exception e) {
			Logger.saveSingleLog('Unable to execute next Season creation. NextSeasonSchedulable has failed: ' + e.getMessage() + '. ' + e.getStackTraceString());
		}
	}
}