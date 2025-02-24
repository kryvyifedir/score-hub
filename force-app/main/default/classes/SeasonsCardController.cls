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

			DataWrappers.SeasonConfig configWrapper = new DataWrappers.SeasonConfig();
			SeasonsConfiguration__c config = SeasonsConfiguration__c.getOrgDefaults();
			if (config.Id != null) {
				configWrapper = SeasonsConfigDataHelper.convertToWrapper(config);
			} else {
				configWrapper.isActive = false;
				configWrapper.cadence = 'month';
				Date nextMonth = Date.today().addMonths(1);
				configWrapper.startDate = Date.newInstance(nextMonth.year(), nextMonth.month(), 1);
			}

			result = ControllerResponse.success(configWrapper);
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
			result = ControllerResponse.success(true);
		} catch (Exception e) {
			Logger.saveSingleLog('Unexpected exception caught in SeasonsCardController. ' + e.getMessage() + '. ' + e.getStackTraceString());
			result = ControllerResponse.error('Unable to deactivate Seassons feature');
		}
		return result;
	}
}