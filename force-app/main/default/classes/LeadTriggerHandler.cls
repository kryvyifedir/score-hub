public with sharing class LeadTriggerHandler {
	
	Map<String, Id> measurementIdsByUniqueIds = new Map<String, Id> {
		Constants.CREATED_LEADS_COUNTER_ID => null, 
		Constants.CONVERTED_LEADS_COUNTER_ID => null
	};

	public LeadTriggerHandler () {
		initMeasurementsIds();
	}
	
	private void initMeasurementsIds() {
		Set<String> leadMeasurements = new Set<String> { Constants.CREATED_LEADS_COUNTER_ID, Constants.CONVERTED_LEADS_COUNTER_ID };
		Map<String, Measurement__c> measurementsByUniqueIdMap = MeasurementSelector.getByUniqueIds(leadMeasurements);

		if (measurementsByUniqueIdMap.containsKey(Constants.CREATED_LEADS_COUNTER_ID)) {
			measurementIdsByUniqueIds.put(Constants.CREATED_LEADS_COUNTER_ID, measurementsByUniqueIdMap.get(Constants.CREATED_LEADS_COUNTER_ID).Id);
		}

		if (measurementsByUniqueIdMap.containsKey(Constants.CONVERTED_LEADS_COUNTER_ID)) {
			measurementIdsByUniqueIds.put(Constants.CONVERTED_LEADS_COUNTER_ID, measurementsByUniqueIdMap.get(Constants.CONVERTED_LEADS_COUNTER_ID).Id);
		}
	}

	public void fireEvents(List<Lead> leads, String measurementUniqueId) {
		List<UserMeasurementIncrement__e> events = new List<UserMeasurementIncrement__e>();
		Id measurementId = measurementIdsByUniqueIds.get(measurementUniqueId);
		if (measurementId == null) {
			return;
		}

		Map<Id, Decimal> incrementsByUserId = new Map<Id, Decimal>();

		for (Lead lead : leads) {
			if (incrementsByUserId.containsKey(lead.OwnerId)) {
				Decimal value = incrementsByUserId.get(lead.OwnerId);
				incrementsByUserId.put(lead.OwnerId, value + 1);
			} else {
				incrementsByUserId.put(lead.OwnerId, 1);
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

	public static void onAfterInsert(List<Lead> leads) {
		try { 
			LeadTriggerHandler handler = new LeadTriggerHandler();
			handler.fireEvents(leads, Constants.CREATED_LEADS_COUNTER_ID);
		} catch (Exception e) {
			Logger.saveSingleLog('Unexpected exception caught in LeadTriggerHandler. ' + e.getMessage() + '. ' + e.getStackTraceString());
		}
	}

	public static void onAfterUpdate(Map<Id, Lead> newLeads, Map<Id, Lead> oldLeads) {
		try {
			List<Lead> convertedLeads = new List<Lead>();
			for (Id leadId : newLeads.keySet()) {
				if (oldLeads.get(leadId).IsConverted == false && newLeads.get(leadId).IsConverted == true) {
					convertedLeads.add(newLeads.get(leadId));
				}
			}

			if (!convertedLeads.isEmpty()) {
				LeadTriggerHandler handler = new LeadTriggerHandler();
				handler.fireEvents(convertedLeads, Constants.CONVERTED_LEADS_COUNTER_ID);
			}
		} catch (Exception e) {
			Logger.saveSingleLog('Unexpected exception caught in LeadTriggerHandler. ' + e.getMessage() + '. ' + e.getStackTraceString());
		}
	}
}