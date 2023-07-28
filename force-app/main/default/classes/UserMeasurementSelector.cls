public with sharing class UserMeasurementSelector extends BaseSelector {

	public static UserMeasurementSelector getInstance() {
		return new UserMeasurementSelector();
	}

	public override String sObjectApiName() {
		return 'UserMeasurement__c';
	}

	public override Set<String> fieldApiNames() {
		return new Set<String> {'Id', 'Name', 'Key__c', 'Measurement__c', 'User__c', 'Value__c'};
	}
}