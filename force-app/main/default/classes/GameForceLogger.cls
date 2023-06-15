public with sharing class GameForceLogger {
	
	List<GameForceLog__c> logs = new List<GameForceLog__c>();

	public GameForceLogger () {

	}

	public void addLog(String log, String userId, String achievementId) {
		GameForceLog__c gameForceLog = new GameForceLog__c();
		gameForceLog.Log__C = log;
		if (!String.isBlank(userId)) {
			gameForceLog.UserId__c = userId;
		}

		if (!String.isBlank(achievementId)) {
			gameForceLog.AchievementId__c = achievementId;
		}

		logs.add(gameForceLog);
	}

	public void commitChanges() {
		if (logs.isEmpty()) {
			return;
		}

		Database.insert(logs);
	}

	public static void saveSingleLog(String log, String userId, String achievementId) {
		GameForceLogger logger = new GameForceLogger();
		logger.addLog(log, userId, achievementId);
		logger.commitChanges();
	}
}