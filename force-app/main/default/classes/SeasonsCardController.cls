public with sharing class SeasonsCardController {
	@TestVisible
	private static Boolean throwException = false;

	@AuraEnabled(cacheable=true)
	public static Map<String,Object> getSeasonsConfig() {
		Map<String, Object> result = new Map<String, Object>();
		try {
			if (throwException) {
				throw new TestDataFactory.TestException();
			}

			result = ControllerResponse.success(SeasonsConfigDataHelper.getDefaultConfiguration());
		} catch (Exception e) {
			Logger.saveSingleLog('Unexpected exception caught in SeasonsCardController. ' + e.getMessage() + '. ' + e.getStackTraceString());
			result = ControllerResponse.error('Unable to get Seassons Configuration');
		}
		return result;
	}

	@AuraEnabled(cacheable=false)
	public static Map<String,Object> activateModifySeasons(String cadence, Date startDate) {
		Map<String, Object> result = new Map<String, Object>();
		try {
			if (throwException) {
				throw new TestDataFactory.TestException();
			}

			// TODO: If no seasons existed - create new season
			// TODO: If it existed: ???
			SeasonsConfigDataHelper.activateConfiguration(cadence, startDate);
			result = ControllerResponse.success(true);
		} catch (Exception e) {
			Logger.saveSingleLog('Unexpected exception caught in SeasonsCardController. ' + e.getMessage() + '. ' + e.getStackTraceString());
			result = ControllerResponse.error('Unable to activate/modify Seassons feature');
		}
		return result;
	}

	@AuraEnabled(cacheable=false)
	public static Map<String,Object> deactivateSeasons() {
		Map<String, Object> result = new Map<String, Object>();
		try {
			if (throwException) {
				throw new TestDataFactory.TestException();
			}
			
			SeasonsConfiguration__c config = SeasonsConfiguration__c.getOrgDefaults();
			SeasonsConfigDataHelper.deactivateConfiguration();
			// TODO: Set To__c date for the last season to Today()
		} catch (Exception e) {
			Logger.saveSingleLog('Unexpected exception caught in SeasonsCardController. ' + e.getMessage() + '. ' + e.getStackTraceString());
			result = ControllerResponse.error('Unable to deactivate Seassons feature');
		}
		return result;
	}
}