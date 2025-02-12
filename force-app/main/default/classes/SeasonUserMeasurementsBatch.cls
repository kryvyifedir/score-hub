public with sharing class SeasonUserMeasurementsBatch implements Database.Batchable<sObject>, Database.Stateful {
	public Id currentSeasonId;

	public SeasonUserMeasurementsBatch(Id seasonId) {
		SeasonsConfiguration__c config = SeasonsConfiguration__c.getOrgDefaults();
		if (config.IsActive__c != true) {
			throw new SeasonUserMeasurementsBatchException('SeasonUserMeasurementsBatch execution was stopped - Seasons feature is not active');
		}

		if (seasonId == null || seasonId.getSobjectType() != Season__c.getSobjectType()) {
			throw new SeasonUserMeasurementsBatchException('Unable to execute SeasonUserMeasurementsBatch. Provided season id is either null or is not of Season__c type'); 
		}

		currentSeasonId = seasonId;
	}

	public Database.QueryLocator start(Database.BatchableContext bc) {
		String queryString = 'SELECT Id, Measurement__c, User__c, Value__c FROM UserMeasurement__c';
		return Database.getQueryLocator(queryString);
	}

	public void execute(Database.BatchableContext bc, List<sObject> scope) {
		List<SeasonUserMeasurement__c> seasonUserMeasurementsToCreate = new List<SeasonUserMeasurement__c>();

		for (UserMeasurement__c userMeasurement : (List<UserMeasurement__c>)scope) {
			SeasonUserMeasurement__c seasonUserMeasurement = new SeasonUserMeasurement__c();
			seasonUserMeasurement.Season__c = currentSeasonId;
			seasonUserMeasurement.User__c = userMeasurement.User__c;
			seasonUserMeasurement.Measurement__c = userMeasurement.Measurement__c;
			seasonUserMeasurement.Value__c = userMeasurement.Value__c;

			seasonUserMeasurementsToCreate.add(seasonUserMeasurement);
		}
		insert seasonUserMeasurementsToCreate;
		delete scope;
	}

	public void finish(Database.BatchableContext bc) {
		AsyncApexJob asyncJobInfo = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
				FROM AsyncApexJob WHERE Id = :bc.getJobId()];

		if (asyncJobInfo.NumberOfErrors != 0 || asyncJobInfo.Status == 'Failed') {
			Logger.saveSingleLog('SeasonUserMeasurementsBatch with Id: ' + asyncJobInfo.Id +' has failed. New Season is not going to be created.');
		} else {
			SeasonsDataHelper helper = new SeasonsDataHelper();
			helper.createNewSeason(this.currentSeasonId);
		}
	}

	public class SeasonUserMeasurementsBatchException extends Exception {}
}