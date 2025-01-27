public with sharing class SeasonsDataHelper {
	public static void createNewSeason() {
		SeasonsConfiguration__c config = SeasonsConfiguration__c.getOrgDefaults();

		// TODO: 
		// - THIS METHOD WILL SEARCH FOR EXISTING SEASON
		// - IF NO SEASON EXIST - CREATE PRE-SEASON USING config.StartDate TO FROM__C and TO__C as StartDate + Cadence
		// - IF EXISTS - FROM__C = LAST_SEASON.DATE_TO + 1, TO__C = LAST_SEASON.DATE_TO + Cadence

		// - Seasson__c NEEDS AN After Insert TRIGGER
		// - TRIGGER WILL SCHEDULE NEW JOB AND SAVE JOB ID TO SeasonsConfiguration__c

		// - SCHEDULABLE JOB WILL CALL SeasonUserStatsBatch
		// + SeasonUserStatsBatch WILL SAVE USER STATS AND CALL SeasonReachedAchievementsBatch
		// + SeasonReachedAchievementsBatch WILL SAVE REACHED ACHIVEMENTS AND CALL SeasonUserMeasurementsBatch
		// + SeasonUserMeasurementsBatch WILL SAVE USER MEASUREMENTS AND CALL SeasonsDataHelper
		// - SeasonsDataHelper WILL CREATE NEW SEASON
	}
}