public with sharing class SeasonReachedAchievementsBatch implements Database.Batchable<sObject>, Database.Stateful {
	public Id currentSeasonId;

	public SeasonReachedAchievementsBatch(Id seasonId) {
		SeasonsConfiguration__c config = SeasonsConfiguration__c.getOrgDefaults();
		if (config.IsActive__c != true) {
			throw new SeasonReachedAchievementsBatchException('SeasonReachedAchievementsBatch execution was stopped - Seasons feature is not active');
		}

		if (seasonId == null || seasonId.getSobjectType() != Season__c.getSobjectType()) {
			throw new SeasonReachedAchievementsBatchException('Unable to execute SeasonReachedAchievementsBatch. Provided season id is either null or is not of Season__c type'); 
		}

		currentSeasonId = seasonId;
	}

	public Database.QueryLocator start(Database.BatchableContext bc) {
		String queryString = 'SELECT Id, Achievement__c, User__c FROM ReachedAchievement__c';
		return Database.getQueryLocator(queryString);
	}

	public void execute(Database.BatchableContext bc, List<sObject> scope) {
		// TODO: (LAST PRIO) Run static validation and fix access issues
		List<SeasonReachedAchievement__c> seasonReachedAchievementsToCreate = new List<SeasonReachedAchievement__c>();

		for (ReachedAchievement__c reachedAchievement : (List<ReachedAchievement__c>)scope) {
			SeasonReachedAchievement__c seasonReachedAchievement = new SeasonReachedAchievement__c();
			seasonReachedAchievement.Season__c = currentSeasonId;
			seasonReachedAchievement.User__c = reachedAchievement.User__c;
			seasonReachedAchievement.Achievement__c = reachedAchievement.Achievement__c;

			seasonReachedAchievementsToCreate.add(seasonReachedAchievement);
		}
		insert seasonReachedAchievementsToCreate;
		delete scope;
	}

	public void finish(Database.BatchableContext bc) {
		AsyncApexJob asyncJobInfo = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
				FROM AsyncApexJob WHERE Id = :bc.getJobId()];

		if (asyncJobInfo.NumberOfErrors != 0 || asyncJobInfo.Status == 'Failed') {
			Logger.saveSingleLog('SeasonReachedAchievementsBatch with Id: ' + asyncJobInfo.Id +' has failed. New Season is not going to be created.');
		} else {
			Database.executeBatch(new SeasonUserMeasurementsBatch(this.currentSeasonId));
		}
	}

	public class SeasonReachedAchievementsBatchException extends Exception {}
}