public with sharing class Logger {
	
	List<Log__c> logs = new List<Log__c>();

	public Logger () { }

	public void addLog(String log) {
		Log__c scoreHubLog = new Log__c();
		if (String.isBlank(log)) {
			return;
		}

		scoreHubLog.ErrorMessage__c = log;
		logs.add(scoreHubLog);
	}

	public void commitChanges() {
		if (logs.isEmpty()) {
			return;
		}

		if (Log__c.SObjectType.getDescribe().isAccessible() && 
			Log__c.SObjectType.getDescribe().isCreateable() &&
			Schema.SObjectType.Log__c.fields.ErrorMessage__c.isAccessible() && 
			Schema.SObjectType.Log__c.fields.ErrorMessage__c.isCreateable()) {
			Database.insert(logs);
		}
	}

	public static void saveSingleLog(String log) {
		if (!System.isFuture() && !System.isBatch() && !System.isQueueable() && !System.isScheduled()) {
			saveSingleLogAsync(log);
		} else {
			saveSingleLogSync(log);
		}
	}

	@future
	private static void saveSingleLogAsync(String log) {
		saveSingleLogSync(log);
	}

	private static void saveSingleLogSync(String log) {
		Logger logger = new Logger();
		logger.addLog(log);
		logger.commitChanges();
	}

}