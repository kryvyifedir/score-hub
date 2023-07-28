public with sharing class MeasurementSelector extends BaseSelector {

	public static MeasurementSelector getInstance() {
		return new MeasurementSelector();
	}

	public override String sObjectApiName() {
		return 'Measurement__c';
	}

	public override Set<String> fieldApiNames() {
		return new Set<String> {'Id', 'Name', 'UniqueIdentifier__c', 'Description__c'};
	}
}