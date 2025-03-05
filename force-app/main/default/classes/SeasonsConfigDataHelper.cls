public with sharing class SeasonsConfigDataHelper {

	public static void activateConfiguration(String cadence, Date startDate) {
		SeasonsConfiguration__c config = SeasonsConfiguration__c.getOrgDefaults();
		config.IsActive__c = true;
		config.StartDate__c = startDate;
		config.Cadence__c = cadence;
		upsert config;

		SeasonsDataHelper seasonsHelper = new SeasonsDataHelper();
		Season__c latestSeason = (Season__c)SeasonSelector.getInstance().getLatestSeason();

		if (latestSeason?.Id == null) {
			// Activating first time - pre-season needs to be created
			seasonsHelper.startNextSeason();
		} else if (latestSeason.From__c != null) {
			// We don't want to modify anything for pre-season since its To__c date is bound to 
			// config StartDate__c and it's not calculated based on cadence
			if (latestSeason.To__c < Date.today()) {
				// Activating after it was deactivated - new season needs to be created from the date of the last completed season
				seasonsHelper.startNextSeason(latestSeason.Id);
			} else if (latestSeason.To__c >= Date.today()) {
				// Season is already active but cadence was modified
				// 1. modify To__c date of the currently active season
				latestSeason.To__c = seasonsHelper.calculateNextToDate(latestSeason.From__c);
				update latestSeason;
	
				// 2. cancel currently scheduled job
				if (String.isNotBlank(config.SeasonScheduledJobId__c)) {
					System.abortJob(config.SeasonScheduledJobId__c);
				}
	
				// 3. Schedule new job for newly calculated To__c date and save it to config
				if (!Test.isRunningTest()) {
					Integer jobExecutionTimeInMinutesFromNow = SchedulerService.calculateMinutesBetweenDates(Datetime.now(), DateTime.newInstance(latestSeason.To__c, Time.newInstance(10, 0, 0, 0)));
					config.SeasonScheduledJobId__c = System.scheduleBatch(new SeasonUserStatsBatch(latestSeason.Id), SeasonUserStatsBatch.class + '_' + latestSeason.Id, jobExecutionTimeInMinutesFromNow);
					upsert config;
				}
			}
		}
	}

	public static void deactivateConfiguration() {
		SeasonsConfiguration__c config = SeasonsConfiguration__c.getOrgDefaults();
		if (config.Id != null) {
			if (String.isNotBlank(config.SeasonScheduledJobId__c)) {
				System.abortJob(config.SeasonScheduledJobId__c);
			}
			config.IsActive__c = false;
			config.SeasonScheduledJobId__c = null;
			update config;

			List<Season__c> futureSeasons = (List<Season__c>)SeasonSelector.getInstance().getByFieldValue(Season__c.To__c, '>=', Date.today());
			delete futureSeasons;
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