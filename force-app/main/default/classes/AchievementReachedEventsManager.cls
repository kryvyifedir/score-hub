public with sharing class AchievementReachedEventsManager {

	Map<Id, UserMeasurement__c> userMeasurementsByIdMap = new Map<Id, UserMeasurement__c>();
	Map<Id, List<Achievement__c>> achievementByMeasurementIdMap = new Map<Id, List<Achievement__c>>();
	Map<String, ReachedAchievement__c> existingReachedAchievementsByKey = new Map<String, ReachedAchievement__c>();

	public AchievementReachedEventsManager(Map<Id, UserMeasurement__c> userMeasurementsByIdMap) {
		this.userMeasurementsByIdMap = userMeasurementsByIdMap;
		this.populateAchievementsByMeasurementIdMap();
		this.populateExistingReachedAchievementsByKey();

		system.debug('Test forked PR');
	}

	public List<Database.SaveResult> fireEvents() {
		List<Database.SaveResult> results;
		if (validate()) {
			List<AchievementReached__e> achievementReachedEvents = new List<AchievementReached__e>();
			for (UserMeasurement__c userMeasurement : userMeasurementsByIdMap.values()) {
				List<Achievement__c> relatedAchievements = achievementByMeasurementIdMap.get(userMeasurement.Measurement__c);
				for (Achievement__c achievement : relatedAchievements) {
					if (achievement.Goal__c <= userMeasurement.Value__c &&
						!achievementReachedExists(userMeasurement.User__c, achievement.Id)) {
						AchievementReached__e event = new AchievementReached__e();
						event.UserId__c = userMeasurement.User__c;
						event.AchievementId__c = achievement.Id;
						achievementReachedEvents.add(event);
					}
				}
			}

			if (!achievementReachedEvents.isEmpty()) {
				results = EventBus.publish(achievementReachedEvents);
			}
		}
		return results;
	}

	private void populateAchievementsByMeasurementIdMap() {
		Set<Id> measurementIds = new Set<Id>();
		for(UserMeasurement__c userMeasurement : userMeasurementsByIdMap.values()) {
			measurementIds.add(userMeasurement.Measurement__c);
		}

		List<Achievement__c> achievements = AchievementSelector.getInstance().getByFieldValue('Measurement__c', 'IN', measurementIds);
		for (Achievement__c achievement : achievements) {
			if (!achievementByMeasurementIdMap.containsKey(achievement.Measurement__c)) {
				achievementByMeasurementIdMap.put(achievement.Measurement__c, new List<Achievement__c>());
			}
			achievementByMeasurementIdMap.get(achievement.Measurement__c).add(achievement);
		}
	}

	private void populateExistingReachedAchievementsByKey() {
		Set<Id> userIds = new Set<Id>();
		for(UserMeasurement__c userMeasurement : userMeasurementsByIdMap.values()) {
			userIds.add(userMeasurement.User__c);
		}
		
		List<ReachedAchievement__c> reachedAchievements = ReachedAchievementSelector.getInstance().getByFieldValue('User__c', 'IN', userIds);
		for (ReachedAchievement__c reachedAchievement : reachedAchievements) {
			existingReachedAchievementsByKey.put(reachedAchievement.Key__c, reachedAchievement);
		}
	}
	
	private Boolean validate() {
		Boolean result = true;

		if (userMeasurementsByIdMap.isEmpty() || achievementByMeasurementIdMap.isEmpty()) {
			result = false;
		}

		return result;
	}

	private Boolean achievementReachedExists(Id userId, Id achievementId) {
		Boolean result = false;
		String key = UniqueKeyFormatter.generateUniqueKey(userId, achievementId);

		if (existingReachedAchievementsByKey.containsKey(key)) {
			result = true;
		}

		return result;
	}
}
