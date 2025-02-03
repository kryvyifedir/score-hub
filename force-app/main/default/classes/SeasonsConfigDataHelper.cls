public with sharing class SeasonsConfigDataHelper {

	public static DataWrappers.SeasonConfig getDefaultConfiguration() {
		DataWrappers.SeasonConfig configWrapper = new DataWrappers.SeasonConfig();

		SeasonsConfiguration__c config = SeasonsConfiguration__c.getOrgDefaults();
		if (config.Id != null) {
			configWrapper.id = config.Id;
			configWrapper.isActive = config.IsActive__c;
			configWrapper.cadence = config.Cadence__c;
			configWrapper.startDate = config.StartDate__c;
		} else {
			configWrapper = initDefaultConfiguration();
		}
		return configWrapper;
	}

	public static DataWrappers.SeasonConfig initDefaultConfiguration() {
		DataWrappers.SeasonConfig configWrapper = new DataWrappers.SeasonConfig();
		configWrapper.isActive = false;
		configWrapper.cadence = 'month';
		Date nextMonth = Date.today().addMonths(1);
		configWrapper.startDate = Date.newInstance(nextMonth.year(), nextMonth.month(), 1);
		return configWrapper;
	}

	public static void activateConfiguration(String cadence, Date startDate) {
		SeasonsConfiguration__c config = SeasonsConfiguration__c.getOrgDefaults();
		config.IsActive__c = true;
		config.StartDate__c = startDate;
		config.Cadence__c = cadence;
		upsert config;
	}

	public static void deactivateConfiguration() {
		SeasonsConfiguration__c config = SeasonsConfiguration__c.getOrgDefaults();
		if (config.Id != null) {
			config.IsActive__c = false;
			config.SeasonScheduledJobId__c = null;
			update config;
		}
	}
}