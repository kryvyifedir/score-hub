public with sharing class SeasonsLeaderboardController {
	@TestVisible
	private static Boolean throwException = false;

	@AuraEnabled(cacheable=true)
	public static Map<String, Object> getSeasonsConfig() {
		Map<String, Object> result = new Map<String, Object>();
		try {
			if (throwException) {
				throw new TestDataFactory.TestException();
			}

			DataWrappers.SeasonConfig configWrapper = new DataWrappers.SeasonConfig();
			SeasonsConfiguration__c config = SeasonsConfiguration__c.getOrgDefaults();
			if (config != null) {
				configWrapper = SeasonsConfigDataHelper.convertToWrapper(config);
			}

			result = ControllerResponse.success(configWrapper);
		} catch (Exception e) {
			Logger.saveSingleLog('Unexpected exception caught in SeasonsLeaderboardController. ' + e.getMessage() + '. ' + e.getStackTraceString());
			result = ControllerResponse.error('Unable to get Season configuration');
		}
		return result;
	}
}