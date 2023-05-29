public with sharing class AchievementSelector {
	private static final String FIELDS_LIST = 'Id, Name, Description__c, Enabled__c, Goal__c, Score__c, UITitle__c, UIDescription__c';

	public static List<Achievement__c> getByIds(Set<Id> ids) {
		if (ids.isEmpty()) {
			return new List<Achievement__c>();
		}

		Map<String, Object> binds = new Map<String, Object> { 'ids' => ids };
		return Database.queryWithBinds('SELECT ' + FIELDS_LIST + ' FROM Achievement__c WHERE Id IN :ids', binds, System.AccessLevel.SYSTEM_MODE);
	}
}