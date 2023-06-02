public with sharing class AchievementReachedPayloadBulkifier {
	
	@TestVisible
	Map<Id, Set<Id>> achievementIdsByUserIdMap;

	public AchievementReachedPayloadBulkifier() {
		achievementIdsByUserIdMap = new Map<Id, Set<Id>>();
	}

	public void addUserAchievement(Id userId, Id achievementId) {
		if (!achievementIdsByUserIdMap.containsKey(userId)) {
			achievementIdsByUserIdMap.put(userId, new Set<Id>());
		}

		achievementIdsByUserIdMap.get(userId).add(achievementId);
	}

	public List<String> getPayloads() {
		List<String> jsonPayloads = new List<String>();

		for (Id userId : achievementIdsByUserIdMap.keySet()) {
			List<ReachedAchievement> achievements = new List<ReachedAchievement>();
			Set<Id> achievementIds = achievementIdsByUserIdMap.get(userId);
			for (Id achievementId : achievementIds) {
				ReachedAchievement achievement = new ReachedAchievement();
				achievement.userId = userId;
				achievement.achievementId = achievementId;
				achievements.add(achievement);

				if (achievements.size() == 10) {
					jsonPayloads.add(JSON.serialize(achievements));
					achievements = new List<ReachedAchievement>();
				}
			}

			if (!achievements.isEmpty()) {
				jsonPayloads.add(JSON.serialize(achievements));
			}
		}

		return jsonPayloads;
	}

	public class ReachedAchievement {
		public Id userId;
		public Id achievementId;
	}
}