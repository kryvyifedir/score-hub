public with sharing class SeasonsDataHelper {
	public static void createNewSeason() {
		SeasonsConfiguration__c config = SeasonsConfiguration__c.getOrgDefaults();

		// THIS METHOD WILL SEARCH FOR EXISTING SEASON
		// IF NO SEASON EXIST - CREATE PRE-SEASON USING config.StartDate TO FROM__C and TO__C as StartDate + Cadence
		// IF EXISTS - FROM__C = LAST_SEASON.DATE_TO + 1, TO__C = LAST_SEASON.DATE_TO + Cadence

		// Seasson__c NEEDS AN After Insert TRIGGER
		// TRIGGER WILL SCHEDULE NEW JOB AND SAVE JOB ID TO SeasonsConfiguration__c

		// JOB WILL
		// MOVE DATA
		// CREATE NEW SEASON
	}
}