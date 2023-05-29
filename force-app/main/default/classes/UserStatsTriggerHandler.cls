public with sharing class UserStatsTriggerHandler {
	public static void onBeforeInsert(Map<Id, sObject> newMap) {

	}

	public static void onBeforeUpdate(Map<Id, sObject> newMap, Map<Id, sObject> oldMap) {
		List<AchievementReached__e> achievementsReached = new List<AchievementReached__e>();
		
		Set<Id> achievementIds = new Set<Id>();
		List<UserStat__c> changedStats = new List<UserStat__c>();
		for (Id statId : newMap.keySet()) {
			UserStat__c statNew = (UserStat__c) newMap.get(statId);
			UserStat__c statOld = (UserStat__c) newMap.get(statId);

			if (statNew.CurrentProgress__c > statOld.CurrentProgress__c) {
				changedStats.add(statNew);
				achievementIds.add(changedStats.Achievement__c);
			}
		}

		if (achievementIds.isEmpty() || changedStats.isEmpty()) {
			return;
		}

		List<Achievement__c> achievements = AchievementSelector.getByIds(achievementIds);
		if (achievements.isEmpty()) {
			return;
		}

		Map<Id, Achievement__c> achievementsMap = new Map<Id, Achievement__c> (achievements);

		for (UserStat__c stat : changedStats) {
			Achievement__c achievement = achievementsMap.get(stat.Achievement__c);
			if (stat.CurrentProgress__c >= achievement.Goal__c && !stat.Reached__c) {
				stat.Reached__c = true;

				// System to format Payload split it into valid JSONs of 131072 length and pack them in 
				// AchievementReached__e event
			}
		}

		if (!achievementsReached.isEmpty()) {
			// Call method to publish events
			List<Database.SaveResult> results = EventBus.publish(inkEvents);

			// Inspect publishing result for each event
			for (Database.SaveResult sr : results) {
				if (sr.isSuccess()) {
					System.debug('Successfully published event.');
				} else {
					for(Database.Error err : sr.getErrors()) {
						System.debug('Error returned: ' +
									err.getStatusCode() +
									' - ' +
									err.getMessage());
					}
				}  
			}
		}
	}
}