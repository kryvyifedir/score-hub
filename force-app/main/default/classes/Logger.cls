public with sharing class Logger {
	
	List<Log__c> logs = new List<Log__c>();

	public Logger () { }

	public void addLog(String log) {
		Log__c gameForceLog = new Log__c();
		if (String.isBlank(log)) {
			return;
		}

		gameForceLog.ErrorMessage__c = log;
		logs.add(gameForceLog);
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

	@future
	public static void saveSingleLog(String log) {
		Logger logger = new Logger();
		logger.addLog(log);
		logger.commitChanges();
	}
}