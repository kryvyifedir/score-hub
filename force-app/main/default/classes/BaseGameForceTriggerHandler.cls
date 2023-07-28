public virtual class BaseGameForceTriggerHandler {
	Map<String, Id> measurementIdsByUniqueIds = new Map<String, Id>();

	public BaseGameForceTriggerHandler () {
		initMeasurementsIds();
	}
	
	private void initMeasurementsIds() {
		for (String measurementUniqueId : Constants.MEASUREMENT_UNIQUE_IDS) {
			measurementIdsByUniqueIds.put(measurementUniqueId, null);
		}

		List<Measurement__c> measurements = (List<Measurement__c>) MeasurementSelector.getInstance().getByFieldValue('UniqueIdentifier__c', 'IN', Constants.MEASUREMENT_UNIQUE_IDS);
		for (Measurement__c measurement : measurements) {
			measurementIdsByUniqueIds.put(measurement.UniqueIdentifier__c, measurement.Id);
		}
	}

	public void fireEvents(List<SObject> objects, String userFieldApiName, String measurementUniqueId) {
		List<UserMeasurementIncrement__e> events = new List<UserMeasurementIncrement__e>();
		Id measurementId = measurementIdsByUniqueIds.get(measurementUniqueId);
		if (measurementId == null) {
			return;
		}

		Map<Id, Decimal> incrementsByUserId = new Map<Id, Decimal>();

		for (SObject obj : objects) {
			Id userId = (Id) obj.get(userFieldApiName);
			if (incrementsByUserId.containsKey(userId)) {
				Decimal value = incrementsByUserId.get(userId);
				incrementsByUserId.put(userId, value + 1);
			} else {
				incrementsByUserId.put(userId, 1);
			}
		}

		if (incrementsByUserId.isEmpty()) {
			return;
		}

		for (Id key : incrementsByUserId.keySet()) {
			UserMeasurementIncrement__e event = new UserMeasurementIncrement__e();
			event.UserId__c = key;
			event.MeasurementId__c = measurementId;
			event.Increment__c = incrementsByUserId.get(key);
			events.add(event);
		}

		if (!events.isEmpty()) {
			EventBus.publish(events);
		}
	}
}