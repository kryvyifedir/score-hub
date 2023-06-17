public with sharing class MeasurementSelector {

	private static final String FIELDS_LIST = 
		'Id, ' +
		'Name, ' +
		'UniqueIdentifier__c, ' +
		'Description__c, ' +
		'(SELECT Id, Goal__c FROM Achievements__r)';

	public static List<Measurement__c> getByIds(Set<Id> ids) {
		if (ids.isEmpty()) {
			return new List<Measurement__c>();
		}

		Map<String, Object> binds = new Map<String, Object> { 'ids' => ids };
		return Database.queryWithBinds('SELECT ' + FIELDS_LIST + ' FROM Measurement__c WHERE Id IN :ids', binds, System.AccessLevel.SYSTEM_MODE);
	}
}