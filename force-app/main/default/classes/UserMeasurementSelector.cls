public with sharing class UserMeasurementSelector {
	private static final String FIELDS_LIST = 'Id, Name, Key__c, Measurement__c, User__c, Value__c';

	public static Map<String, UserMeasurement__c> getByKeys(Map<Id, Id> measurementIdsByUserIdsMap) {
		Map<String, UserMeasurement__c> result = new Map<String, UserMeasurement__c>();

		if (measurementIdsByUserIdsMap == null || measurementIdsByUserIdsMap.isEmpty()) {
			return result;
		}

		Set<String> keys = new Set<String>();
		for (Id userId : measurementIdsByUserIdsMap.keySet()) {
			Id measurementId = measurementIdsByUserIdsMap.get(userId);

			keys.add(userId + '-' + measurementId);
		}

		Map<String, Object> binds = new Map<String, Object> { 'keys' => keys };
		List<UserMeasurement__c> stats = Database.queryWithBinds('SELECT ' + FIELDS_LIST + ' FROM UserMeasurement__c WHERE Key__c IN :keys', binds, System.AccessLevel.SYSTEM_MODE);
		if (stats == null || stats.isEmpty()) {
			return result;
		}

		for (UserMeasurement__c stat : stats) {
			result.put(stat.Key__c, stat);
		}

		return result;
	}
}