public with sharing class UserStatTriggerHelper {

	public static Map<Id, UserStat__c> getStatsWithUpdatedProgress(Map<Id, sObject> newMap, Map<id, sObject> oldMap) {
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