public with sharing class UserMeasurementTriggerHandler {
	public static void onAfterInsert(Map<Id, UserMeasurement__c> newMap) {
		try {
			AchievementReachedEventsManager eventsManager = new AchievementReachedEventsManager(newMap);
			eventsManager.fireEvents();
		} catch (Exception e) {
			Logger.saveSingleLog('UserMeasurement__c onAfterInsert trigger issue: ' + e.getMessage());
		}
	}

	public static void onAfterUpdate(Map<Id, UserMeasurement__c> newMap, Map<Id, UserMeasurement__c> oldMap) {
		try {
			Map<Id, UserMeasurement__c> changedMeasurements = UserMeasurementTriggerHandler.getMeasurementsWithUpdatedProgress(newMap, oldMap);
			AchievementReachedEventsManager eventsManager = new AchievementReachedEventsManager(changedMeasurements);
			eventsManager.fireEvents();
		} catch (Exception e) {
			Logger.saveSingleLog('UserMeasurement__c onAfterUpdate trigger issue: ' + e.getMessage());
		}
	}

	public static Map<Id, UserMeasurement__c> getMeasurementsWithUpdatedProgress(Map<Id, UserMeasurement__c> newMap, Map<id, UserMeasurement__c> oldMap) {
		if (newMap == null || newMap.isEmpty()) {
			return new Map<Id, UserMeasurement__c>();
		}
		
		if (oldMap == null || oldMap.isEmpty()) {
			return (Map<Id, UserMeasurement__c>) newMap;
		}
		
		List<UserMeasurement__c> changedMeasurements = new List<UserMeasurement__c>();
		for (Id statId : newMap.keySet()) {
			UserMeasurement__c statNew = (UserMeasurement__c) newMap.get(statId);
			UserMeasurement__c statOld = (UserMeasurement__c) oldMap.get(statId);
			if (statOld != null && 
				statNew != null && 
				statNew.Value__c != statOld.Value__c) {
				changedMeasurements.add(statNew);
			}
		}
		return new Map<Id, UserMeasurement__c> (changedMeasurements);
	}
}