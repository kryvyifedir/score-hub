public with sharing class UserMeasurementIncrementTriggerHandler {
	Logger logger = new Logger();
	List<UserMeasurementIncrement__e> eventsToProcess = new List<UserMeasurementIncrement__e>();
	Map<String, UserMeasurement__c> existingUserMeasurementsMap = new Map<String, UserMeasurement__c>();
	Map<String, UserMeasurement__c> measurementsToUpsert = new Map<String, UserMeasurement__c>();

	public UserMeasurementIncrementTriggerHandler(List<UserMeasurementIncrement__e> events) {
		eventsToProcess = events;
		initExistingSObjectMaps(events);
	}

	private void initExistingSObjectMaps(List<UserMeasurementIncrement__e> events) {
		Set<String> userMeasurementKeys = new Set<String>();
		for (UserMeasurementIncrement__e event : events) {
			userMeasurementKeys.add(UniqueKeyFormatter.generateUniqueKey(event.UserId__c, event.MeasurementId__c));
		}
		
		List<UserMeasurement__c> userMeasurements = (List<UserMeasurement__c>) UserMeasurementSelector.getInstance().getByFieldValue('Key__c', 'IN', userMeasurementKeys);
		for (UserMeasurement__c userMeasurement : userMeasurements) {
			existingUserMeasurementsMap.put(userMeasurement.Key__c, userMeasurement);
		}
	}

	public void processEvents() {
		try {
			for (UserMeasurementIncrement__e event : eventsToProcess) {
				if (!this.validateEvent(event)) {
					continue;
				}

				String upsertMapKey = UniqueKeyFormatter.generateUniqueKey(event.UserId__c, event.MeasurementId__c);
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
		try {
			Id userId = Id.valueOf(event.UserId__c);
			if (userId?.getSObjectType() != User.getSObjectType()) {
				logger.addLog(formatErrorMessage('Id: ' + event.UserId__c + ' is not a valid User Id.', event));
				return false;
			}

			Id measurementId = Id.valueOf(event.MeasurementId__c);
			if (measurementId?.getSObjectType() != Measurement__c.getSObjectType()) {
				logger.addLog(formatErrorMessage('Achievement Id: ' + event.MeasurementId__c + ' is not a valid Achievement Id.', event));
				return false;
			}

			if (event.Increment__c == null || event.Increment__c == 0) {
				logger.addLog(formatErrorMessage('User Measurement wasn\'t updated since Increment value is missing', event));
				return false;
			}
		} catch (Exception e) {
			logger.addLog(formatErrorMessage('Critical faliure:' + e.getMessage() + '; ' + e.getStackTraceString(), event));
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