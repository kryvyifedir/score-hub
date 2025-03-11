public with sharing class SeasonsConfigDataHelper {

	public static void activateConfiguration(String cadence, Date startDate) {
		SeasonsConfiguration__c config = SeasonsConfiguration__c.getOrgDefaults();
		config.IsActive__c = true;
		config.StartDate__c = startDate;
		config.Cadence__c = cadence;
		DMLService.upsertRecord(new List<SeasonsConfiguration__c>{config}, System.AccessLevel.SYSTEM_MODE);

		SeasonsDataHelper seasonsHelper = new SeasonsDataHelper();
		Season__c latestSeason = (Season__c)SeasonSelector.getInstance().getLatestSeason();

		if (latestSeason?.Id == null) {
			// Activating first time - pre-season needs to be created
			seasonsHelper.startNextSeason();
		} else if (latestSeason.From__c != null) {
			// Not a pre-season, it's a regular season
			if (latestSeason.To__c < Date.today()) {
				// Activating after it was deactivated - new season needs to be created from the date of the last completed season
				Date fromDate = latestSeason.To__c.addDays(1);
				Date toDate = config.StartDate__c.addDays(-1);
				seasonsHelper.startNextSeason(fromDate, toDate);
			}
			// } else if (latestSeason.To__c >= Date.today()) {
			// Modifying current season that wasn't deactivated yet is out of scope from 
			// initial Seasons feature release
			// }
		} else if (latestSeason.From__c == null) {
			// Pre-season exists but cadence or date was modified
			// 1. modify To__c date according to new StartDate__c
			latestSeason.To__c = config.StartDate__c.addDays(-1);
			DMLService.updateRecord(new List<Season__c>{latestSeason}, System.AccessLevel.SYSTEM_MODE);

			// 2. cancel currently scheduled job
			if (String.isNotBlank(config.SeasonScheduledJobId__c)) {
				System.abortJob(config.SeasonScheduledJobId__c);
			}

			// 3. Schedule new job for newly calculated To__c date and save it to config
			if (!Test.isRunningTest()) {
				Integer jobExecutionTimeInMinutesFromNow = SchedulerService.calculateMinutesBetweenDates(Datetime.now(), DateTime.newInstance(latestSeason.To__c, Time.newInstance(10, 0, 0, 0)));
				config.SeasonScheduledJobId__c = System.scheduleBatch(new SeasonUserStatsBatch(latestSeason.Id), SeasonUserStatsBatch.class + '_' + latestSeason.Id, jobExecutionTimeInMinutesFromNow);
				DMLService.upsertRecord(new List<SeasonsConfiguration__c>{config}, System.AccessLevel.SYSTEM_MODE);
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
			config.StartDate__c = Date.today();
			DMLService.updateRecord(new List<SeasonsConfiguration__c>{config}, System.AccessLevel.SYSTEM_MODE);

			List<Season__c> futureSeasons = (List<Season__c>)SeasonSelector.getInstance().getByFieldValue(Season__c.To__c, '>=', Date.today());
			DMLService.deleteRecord(futureSeasons, System.AccessLevel.SYSTEM_MODE);
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