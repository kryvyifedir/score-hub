public with sharing class LeadTriggerHandler extends BaseGameForceTriggerHandler {

	public static void onAfterInsert(List<Lead> leads) {
		try { 
			LeadTriggerHandler handler = new LeadTriggerHandler();
			handler.fireEvents(leads, 'OwnerId', Constants.CREATED_LEADS_COUNTER_ID);
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
				handler.fireEvents(convertedLeads, 'OwnerId', Constants.CONVERTED_LEADS_COUNTER_ID);
			}
		} catch (Exception e) {
			Logger.saveSingleLog('Unexpected exception caught in LeadTriggerHandler. ' + e.getMessage() + '. ' + e.getStackTraceString());
		}
	}
}