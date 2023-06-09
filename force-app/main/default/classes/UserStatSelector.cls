public with sharing class UserStatSelector {
	private static final String FIELDS_LIST = 'Id, Name, Achievement__c, CurrentProgress__c, Reached__c, UserId__c';

	public static List<UserStat__c> getByUserIds(Set<Id> ids) {
		if (ids.isEmpty()) {
			return new List<UserStat__c>();
		}

		Map<String, Object> binds = new Map<String, Object> { 'ids' => ids };
		return Database.queryWithBinds('SELECT ' + FIELDS_LIST + ' FROM UserStat__c WHERE UserId__c IN :ids', binds, System.AccessLevel.SYSTEM_MODE);
	}
}