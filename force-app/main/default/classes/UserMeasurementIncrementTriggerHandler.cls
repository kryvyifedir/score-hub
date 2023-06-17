public with sharing class UserMeasurementIncrementTriggerHandler {
	Logger logger = new Logger();
	List<UserMeasurementIncrement__e> eventsToProcess = new List<UserMeasurementIncrement__e>();
	Map<Id, User> existingUsersMap = new Map<Id, User>();
	Map<Id, Measurement__c> existingMeasurementsMap = new Map<Id, Measurement__c>();
	Map<String, UserMeasurement__c> existingUserMeasurementsMap = new Map<String, UserMeasurement__c>();
	Map<String, UserMeasurement__c> measurementsToUpsert = new Map<String, UserMeasurement__c>();

	public UserMeasurementIncrementTriggerHandler(List<UserMeasurementIncrement__e> events) {
		eventsToProcess = events;
		initExistingSObjectMaps(events);
	}

	private void initExistingSObjectMaps(List<UserMeasurementIncrement__e> events) {
		Set<Id> userIdsFromEvents = new Set<Id>();
		Set<Id> measurementIdsFromEvents = new Set<Id>();
		Map<Id, Id> measurementIdsByUserIdsMap = new Map<Id, Id>();
		for (UserMeasurementIncrement__e event : events) {
			userIdsFromEvents.add(event.UserId__c);
			measurementIdsFromEvents.add(event.MeasurementId__c);
			measurementIdsByUserIdsMap.put(event.UserId__c, event.MeasurementId__c);
		}

		existingUsersMap = new Map<Id, User> (UserSelector.getByIds(userIdsFromEvents));
		existingMeasurementsMap = new Map<Id, Measurement__c> (MeasurementSelector.getByIds(measurementIdsFromEvents));
		existingUserMeasurementsMap = UserMeasurementSelector.getByKeys(measurementIdsByUserIdsMap);
	}

	public void processEvents() {
		try {
			for (UserMeasurementIncrement__e event : eventsToProcess) {
				if (!this.validateEvent(event)) {
					continue;
				}

				String upsertMapKey = event.UserId__c + '-' + event.MeasurementId__c;
				if (measurementsToUpsert.containsKey(upsertMapKey)) {
					measurementsToUpsert.get(upsertMapKey).Value__c += event.Increment__c;
				} else if (existingUserMeasurementsMap.containsKey(upsertMapKey)) {
					measurementsToUpsert.put(upsertMapKey, existingUserMeasurementsMap.get(upsertMapKey));
					measurementsToUpsert.get(upsertMapKey).Value__c += event.Increment__c;
				} else {
					measurementsToUpsert.put(upsertMapKey, new UserMeasurement__c(Measurement__c = event.MeasurementId__c, User__c = event.UserId__c, Value__c = event.Increment__c));
				}
			}

			this.commitChanges();
		} catch (Exception e) {
			logger.addLog('Unexpected exception was caught: ' + e.getMessage());
		} finally {
			logger.commitChanges();
		}
	}

	private Boolean validateEvent(UserMeasurementIncrement__e event) {
		User user = existingUsersMap.get(event.UserId__c);
		if (user == null) {
			logger.addLog(formatErrorMessage('User with Id: ' + event.UserId__c + ' haven\'t been found in a system.', event));
			return false;
		}

		Measurement__c measurement = existingMeasurementsMap.get(event.MeasurementId__c);
		if (measurement == null) {
			logger.addLog(formatErrorMessage('Achievement with Id: ' + event.MeasurementId__c + ' haven\'t been found in a system.', event));
			return false;
		}

		if (event.Increment__c == null || event.Increment__c == 0) {
			logger.addLog(formatErrorMessage('User Measurement wasn\'t updated since Increment value is missing', event));
			return false;
		}

		return true;
	}

	@TestVisible
	private String formatErrorMessage(String prefix, UserMeasurementIncrement__e event) {
		String result = prefix;

		if (event != null) {
			String eventStr = 'UserMeasurementIncrement__e: '
				+ ' {UserId__c: ' + event.UserId__c + ','
				+ ' MeasurementId__c: ' + event.MeasurementId__c + ','
				+ ' Increment__c: ' + event.Increment__c + '}';
			prefix = prefix + ' ' + eventStr;
		}

		return result;
	}

	private void commitChanges() {
		if (measurementsToUpsert.isEmpty()) {
			return;
		}

		// Use proper Database class operations and throw events 
		List<Database.UpsertResult> upsertResults = Database.upsert(measurementsToUpsert.values(), false);
		// Create an error log for each faild upsert record in Issue #26
		for (Database.UpsertResult upsertResult : upsertResults) {
			if (!upsertResult.isSuccess()) {
				for (Database.Error error : upsertResult.getErrors()) {
					logger.addLog('Unable to upsert User Measurement: ' + error.getMessage());
				}
			}
		}
	}

	public static void onAfterInsert(List<UserMeasurementIncrement__e> events) {
		try {
			UserMeasurementIncrementTriggerHandler handler = new UserMeasurementIncrementTriggerHandler(events);
			handler.processEvents();
		} catch (Exception e) {
			Logger.saveSingleLog('UserMeasurementIncrement__e onAfterInsert trigger issue: ' + e.getMessage());
		}
	}
}