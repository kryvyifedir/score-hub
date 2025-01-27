public with sharing class SeasonUserStatsBatch implements Database.Batchable<sObject>, Database.Stateful {
	public Id currentSeasonId;

	public SeasonUserStatsBatch(Id seasonId) {
		if (seasonId == null || seasonId.getSobjectType() != Season__c.getSobjectType()) {
			throw new SeasonUserStatsBatchException('Unable to execute SeasonUserStatsBatch. Provided season id is either null or is not of Season__c type'); 
		}

		currentSeasonId = seasonId;
	}

	public Database.QueryLocator start(Database.BatchableContext bc) {
		String queryString = 'SELECT Id FROM User';
		if (Test.isRunningTest()) {
			// When running test on Customer Orgs it is possbile that there will be more then 
			// 200 users already, which will make test fail, since it can't enque more then 1 batch
			queryString = 'SELECT Id FROM User WHERE LastName LIKE \'Test_SidebarApps%\'';
		} 

		return Database.getQueryLocator(queryString);
	}

	public void execute(Database.BatchableContext bc, List<sObject> scope) {
		Set<Id> userIds = new Set<Id>(); 

		for (sObject sObj : scope) {
			userIds.add(sObj.Id);
		}

		Map<Id, DataWrappers.UserCardData> seasonResultsMap = UserDataHelper.getUserCardDataById(userIds, 0);
		List<SeasonUserStat__c> seasonResultsToInsert = new List<SeasonUserStat__c>();
		for (Id userId : seasonResultsMap.keySet()) {
			DataWrappers.UserCardData seasonResult = seasonResultsMap.get(userId);
			if (seasonResult.reachedAchievementsCount == 0 ) {
				continue;
			}

			SeasonUserStat__c seasonResultRecord = new SeasonUserStat__c();
			seasonResultRecord.Season__c = currentSeasonId;
			seasonResultRecord.User__c = userId;
			seasonResultRecord.TotalAchievementsReached__c = seasonResult.reachedAchievementsCount;
			seasonResultRecord.TotalScore__c = seasonResult.totalScore;

			seasonResultsToInsert.add(seasonResultRecord);
		}

		insert seasonResultsToInsert;
	}

	public void finish(Database.BatchableContext bc) {
		// TODO: SAVE LOG IF ERROR
        // AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
        // TotalJobItems, CreatedBy.Email
        // FROM AsyncApexJob WHERE Id =
        // :bc.getJobId()];

		Database.executeBatch(new SeasonReachedAchievementsBatch(this.currentSeasonId));
	}

	public class SeasonUserStatsBatchException extends Exception {}
}