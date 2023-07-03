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

	public static Map<String, Measurement__c> getByUniqueIds(Set<String> uniqueIds) {
		Map<String, Measurement__c> result = new Map<String, Measurement__c>();
		
		if (uniqueIds.isEmpty()) {
			return result;
		}

		Map<String, Object> binds = new Map<String, Object> { 'ids' => uniqueIds };
		List<Measurement__c> measurements = Database.queryWithBinds('SELECT ' + FIELDS_LIST + ' FROM Measurement__c WHERE UniqueIdentifier__c IN :ids', binds, System.AccessLevel.SYSTEM_MODE);
		for (Measurement__c measurement : measurements) {
			result.put(measurement.UniqueIdentifier__c, measurement);
		}
		return result;
	}
}