public with sharing class AchievementReachedEventsManager {

	Map<Id, UserMeasurement__c> userMeasurementsByIdMap = new Map<Id, UserMeasurement__c>();
	Map<Id, List<Achievement__c>> achievementByMeasurementIdMap = new Map<Id, List<Achievement__c>>();
	Map<Id, Map<String, ReachedAchievement__c>> reachedAchievementsByAchievementIdMap = new Map<Id, Map<String, ReachedAchievement__c>>();

	public AchievementReachedEventsManager(Map<Id, UserMeasurement__c> userMeasurementsByIdMap) {
		this.userMeasurementsByIdMap = userMeasurementsByIdMap;
		this.populateAchievementsByMeasurementIdMap();
		this.populateReachedAchievementsByAchievementIdMap();
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

		List<Measurement__c> measurements = MeasurementSelector.getByIds(measurementIds);
		for (Measurement__c measurement : measurements) {
			List<Achievement__c> achievements = measurement.Achievements__r;
			if (achievements != null && !achievements.isEmpty()) {
				achievementByMeasurementIdMap.put(measurement.Id, achievements);
			}
		}
	}

	private void populateReachedAchievementsByAchievementIdMap() {
		Set<Id> achievementIds = new Set<Id>();
		for (Id key : achievementByMeasurementIdMap.keySet()) {
			List<Achievement__c> achievements = achievementByMeasurementIdMap.get(key);
			for (Achievement__c achievement : achievements) {
				achievementIds.add(achievement.Id);
			}
		}

		reachedAchievementsByAchievementIdMap = AchievementSelector.getReachedAchievementsByAchievementId(achievementIds);
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
		String key = userId + '-' + achievementId;

		if (reachedAchievementsByAchievementIdMap.get(achievementId)?.get(key) != null) {
			result = true;
		}

		return result;
	}
}