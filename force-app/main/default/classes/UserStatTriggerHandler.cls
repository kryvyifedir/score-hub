public with sharing class UserStatTriggerHandler {

	public static void onAfterInsert(Map<Id, UserStat__c> newMap) {
		try {
			AchievementReachedEventsManager eventsManager = new AchievementReachedEventsManager(newMap);
			eventsManager.fireEvents();
		} catch (Exception e) {
			GameForceLogger.saveSingleLog('UserStat__c onAfterInsert trigger issue: ' + e.getMessage(), null, null);
		}
	}

	public static void onAfterUpdate(Map<Id, UserStat__c> newMap, Map<Id, UserStat__c> oldMap) {
		try {
			Map<Id, UserStat__c> changedStats = UserStatTriggerHandler.getStatsWithUpdatedProgress(newMap, oldMap);
			AchievementReachedEventsManager eventsManager = new AchievementReachedEventsManager(changedStats);
			eventsManager.fireEvents();
		} catch (Exception e) {
			GameForceLogger.saveSingleLog('UserStat__c onAfterUpdate trigger issue: ' + e.getMessage(), null, null);
		}
	}

	public static Map<Id, UserStat__c> getStatsWithUpdatedProgress(Map<Id, UserStat__c> newMap, Map<id, UserStat__c> oldMap) {
		if (newMap == null || newMap.isEmpty()) {
			return new Map<Id, UserStat__c>();
		}
		
		if (oldMap == null || oldMap.isEmpty()) {
			return (Map<Id, UserStat__c>) newMap;
		}
		
		List<UserStat__c> changedStats = new List<UserStat__c>();
		for (Id statId : newMap.keySet()) {
			UserStat__c statNew = (UserStat__c) newMap.get(statId);
			UserStat__c statOld = (UserStat__c) oldMap.get(statId);
			if (statOld != null && 
				statNew != null && 
				statNew.CurrentProgress__c != statOld.CurrentProgress__c) {
				changedStats.add(statNew);
			}
		}
		return new Map<Id, UserStat__c> (changedStats);
	}

}