public with sharing class SeasonsDataHelper {

	SeasonsConfiguration__c config;
	private static final Set<String> SUPPORTED_CADENCE_VALUES = new Set<String>{ 'month', 'quarter', 'year' };

	public SeasonsDataHelper() {
		config = SeasonsConfiguration__c.getOrgDefaults();
	}
	
	public Season__c startNextSeason() {
		Date fromDate = null;
		Date toDate = config.StartDate__c.addDays(-1);
		return this.startNextSeason(fromDate, toDate);
	}

	public Season__c startNextSeason(Id seasonId) {
		Season__c lastSeason = (Season__c)SeasonSelector.getInstance().getByIds(new Set<Id>{ seasonId }).get(0);
		Date fromDate = lastSeason.To__c.addDays(1);
		Date toDate = this.calculateNextToDate(fromDate);
		return this.startNextSeason(fromDate, toDate);
	}

	public Season__c startNextSeason(Date fromDate, Date toDate) {
		Season__c newSeason = new Season__c();
		if (this.validate()) {
			newSeason.From__c = fromDate;
			newSeason.To__c = toDate;
			if (newSeason.To__c == null) {
				Logger.saveSingleLog('Unable to initialize next season - unable to define To date');
			} else {
				DMLService.insertRecord(new List<Season__c>{newSeason}, System.AccessLevel.SYSTEM_MODE);

				if (!Test.isRunningTest()) {
					Integer jobExecutionTimeInMinutesFromNow = SchedulerService.calculateMinutesBetweenDates(Datetime.now(), DateTime.newInstance(newSeason.To__c, Time.newInstance(10, 0, 0, 0)));
					config.SeasonScheduledJobId__c = System.scheduleBatch(new SeasonUserStatsBatch(newSeason.Id), SeasonUserStatsBatch.class + '_' + newSeason.Id, jobExecutionTimeInMinutesFromNow);
					
					DMLService.updateRecord(new List<SeasonsConfiguration__c>{config}, System.AccessLevel.SYSTEM_MODE);
				}
			}
		}

		return newSeason;
	}

	@TestVisible
	private Boolean validate() {
		Boolean result = true;

		if (config?.IsActive__c != true) {
			result = false;
			Logger.saveSingleLog('Unable to initialize next season - Seasons Feature is disabled');
		} else if (!SUPPORTED_CADENCE_VALUES.contains(config?.Cadence__c)) {
			result = false;
			Logger.saveSingleLog('Unable to initialize next season - Selected Cadence is not supported');
		}

		return result;
	}

	public Date calculateNextToDate(Date baseDate) {
		Date result;

		if (baseDate != null) {
			if (config.Cadence__c.toLowercase() == 'month') {
				result = baseDate.addMonths(1).addDays(-1);
			} else if (config.Cadence__c.toLowercase() == 'quarter') {
				result = baseDate.addMonths(3).addDays(-1);
			} else if (config.Cadence__c.toLowercase() == 'year') {
				result = baseDate.addYears(1).addDays(-1);
			}
		}

		return result;
	}
}