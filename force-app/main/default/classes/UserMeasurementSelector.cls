public with sharing class UserMeasurementSelector extends BaseSelector {

	public static UserMeasurementSelector getInstance() {
		return new UserMeasurementSelector();
	}

	public override SObjectType sObjectType() {
		return UserMeasurement__c.getSobjectType();
	}

	public override Set<SObjectField> queryFields() {
		return new Set<SObjectField> { UserMeasurement__c.Id, UserMeasurement__c.Name, UserMeasurement__c.Key__c, UserMeasurement__c.Measurement__c, UserMeasurement__c.User__c, UserMeasurement__c.Value__c };
	}
}