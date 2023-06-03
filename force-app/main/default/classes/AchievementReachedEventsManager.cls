public with sharing class AchievementReachedEventsManager {

	Map<Id, UserStat__c> userStatsByIdMap = new Map<Id, UserStat__c>();
	Map<Id, Achievement__c> achievementByIdMap = new Map<Id, Achievement__c>();

	public AchievementReachedEventsManager(Map<Id, UserStat__c> userStatsByIdMap) {
		this.userStatsByIdMap = userStatsByIdMap;
		this.populateAchievementsMap();
	}

	public List<Database.SaveResult> fireEvents() {
		List<Database.SaveResult> results;
		if (validate()) {
			List<AchievementReached__e> achievementReachedEvents = new List<AchievementReached__e>();
			for (UserStat__c stat : userStatsByIdMap.values()) {
				Achievement__c achievement = achievementByIdMap.get(stat.Achievement__c);
				if (achievement != null && 
					stat.CurrentProgress__c >= achievement.Goal__c && 
					!stat.Reached__c) {
					AchievementReached__e event = new AchievementReached__e();
					event.UserId__c = stat.UserId__c;
					event.AchievementId__c = stat.Achievement__c;
					achievementReachedEvents.add(event);
				}
			}

			if (!achievementReachedEvents.isEmpty()) {
				results = EventBus.publish(achievementReachedEvents);
			}
		}
		return results;
	}

	private void populateAchievementsMap() {
		Set<Id> achievementIds = new Set<Id>();
		for (UserStat__c userStat : userStatsByIdMap.values()) {
			achievementIds.add(userStat.Achievement__c);
		}
		achievementByIdMap = new Map<Id, Achievement__c>(AchievementSelector.getByIds(achievementIds));
	}
	
	private Boolean validate() {
		Boolean result = true;

		if (userStatsByIdMap.isEmpty() || achievementByIdMap.isEmpty()) {
			result = false;
		}

		return result;
	}
}