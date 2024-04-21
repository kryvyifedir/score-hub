public with sharing class CaseTriggerHandler extends BaseScoreHubTriggerHandler {
    public static void onAfterUpdate(Map<Id, Case> newCases, Map<Id, Case> oldCases) {
		try {
			List<Case> casesToProcess = getCasesToProcess(newCases, oldCases);
			if (!casesToProcess.isEmpty()) {
				CaseTriggerHandler handler = new CaseTriggerHandler();
				handler.fireEvents(casesToProcess, 'OwnerId', Constants.CLOSED_CASES_ID);
			}
		} catch (Exception e) {
			Logger.saveSingleLog('Unexpected exception caught in CaseTriggerHandler. ' + e.getMessage() + '. ' + e.getStackTraceString());
		}
	}

    private static List<Case> getCasesToProcess(Map<Id, Case> newCases, Map<Id, Case> oldCases) {
		List<Case> casesToProcess = new List<Case>();

		for (Id caseId : newCases.keySet()) {
			Case newCase = newCases.get(caseId);

			if(newCase.Status == 'Closed') {
				Case oldCase = oldCases?.get(caseId);
				if (oldCase == null || oldCase.Status != 'Closed') {
					casesToProcess.add(newCase);
				}
			}
		}

		return casesToProcess;
	}
}