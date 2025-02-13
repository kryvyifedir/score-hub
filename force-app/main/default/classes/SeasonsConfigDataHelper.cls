public with sharing class SeasonsConfigDataHelper {

	public static void activateConfiguration(String cadence, Date startDate) {
		SeasonsConfiguration__c config = SeasonsConfiguration__c.getOrgDefaults();
		config.IsActive__c = true;
		config.StartDate__c = startDate;
		config.Cadence__c = cadence;
		upsert config;

		// TODO: Check if there is a season alread **not sure how, need to think**
		// TODO: If no season exist - Call SeasonDataHelper.startNextSeason();
		// TODO: If season exists **not sure what to do**
		// TODO: Maybe add LastSeasonId field to config to store season?
	}

	public static void deactivateConfiguration() {
		SeasonsConfiguration__c config = SeasonsConfiguration__c.getOrgDefaults();
		if (config.Id != null) {
			config.IsActive__c = false;
			if (String.isNotBlank(config.SeasonScheduledJobId__c)) {
				System.abortJob(config.SeasonScheduledJobId__c);
			}
			update config;

			// TODO: Check if there is a season alread **not sure how, need to think**
			// TODO: If there is a season set To__c date to today
			// TODO: Maybe add LastSeasonId field to config to store season?
		}
	}

	public static DataWrappers.SeasonConfig convertToWrapper(SeasonsConfiguration__c config) {
		DataWrappers.SeasonConfig configWrapper = new DataWrappers.SeasonConfig();
		configWrapper.id = config.Id;
		configWrapper.isActive = config.IsActive__c;
		configWrapper.cadence = config.Cadence__c;
		configWrapper.startDate = config.StartDate__c;
		return configWrapper;
	}
}