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

	@AuraEnabled(cacheable=true)
	public static Map<String, Object> getTotalNumberOfSeasons() {
		Map<String, Object> result = new Map<String, Object>();
		try {
			if (throwException) {
				throw new TestDataFactory.TestException();
			}

			Integer count = SeasonSelector.getInstance().getSeasonCount();
			result = ControllerResponse.success(count);
		} catch (Exception e) {
			Logger.saveSingleLog('Unexpected exception caught in SeasonsLeaderboardController. ' + e.getMessage() + '. ' + e.getStackTraceString());
			result = ControllerResponse.error('Unable to get Total Number of Season');
		}
		return result;
	}

	@AuraEnabled(cacheable=true)
	public static Map<String, Object> getSeasonData(Integer offset) {
		Map<String, Object> result = new Map<String, Object>();
		try {
			if (throwException) {
				throw new TestDataFactory.TestException();
			}

			Season__c season = SeasonSelector.getInstance().getSeasonWithOffset(offset);
			result = ControllerResponse.success(season != null ? new SeasonsDataHelper().convertToWrapper(season) : null);
		} catch (Exception e) {
			Logger.saveSingleLog('Unexpected exception caught in SeasonsLeaderboardController. ' + e.getMessage() + '. ' + e.getStackTraceString());
			result = ControllerResponse.error('Unable to get Seasons Information');
		}
		return result;
	}

}