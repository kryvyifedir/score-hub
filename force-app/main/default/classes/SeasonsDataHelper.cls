public with sharing class SeasonsDataHelper {

	SeasonsConfiguration__c config;
	private static final Set<String> SUPPORTED_CADENCE_VALUES = new Set<String>{ 'month', 'quarter', 'year' };

	public SeasonsDataHelper() {
		config = SeasonsConfiguration__c.getOrgDefaults();
	}
	
	public Season__c createNewSeason() {
		return this.createNewSeason((Date)null);
	}

	public Season__c createNewSeason(Id seasonId) {
		Season__c lastSeason = (Season__c)SeasonSelector.getInstance().getByIds(new Set<Id>{ seasonId }).get(0);
		return this.createNewSeason(lastSeason.To__c);
	}

	private Season__c createNewSeason(Date lastSeasonToDate) {
		Season__c newSeason = new Season__c();
		if (this.validate()) {
			newSeason.From__c = lastSeasonToDate == null ? null : lastSeasonToDate.addDays(1);
			newSeason.To__c = newSeason.From__c == null ? config.StartDate__c.addDays(-1) : this.calculateNextToDate(newSeason.From__c);

			if (newSeason.To__c == null) {
				Logger.saveSingleLog('Unable to initialize next season - unable to identify To date');
			} else {
				insert newSeason;
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

	@TestVisible
	private Date calculateNextToDate(Date baseDate) {
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