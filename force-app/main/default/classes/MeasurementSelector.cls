public with sharing class MeasurementSelector extends BaseSelector {

	public static MeasurementSelector getInstance() {
		return new MeasurementSelector();
	}

	public override SObjectType sObjectType() {
		return Measurement__c.getSobjectType();
	}

	public override Set<SObjectField> queryFields() {
		return new Set<SObjectField> { Measurement__c.Id, Measurement__c.Name, Measurement__c.UniqueIdentifier__c, Measurement__c.Description__c };
	}
}