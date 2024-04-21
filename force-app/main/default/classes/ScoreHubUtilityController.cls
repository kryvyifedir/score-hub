public with sharing class ScoreHubUtilityController {
	@AuraEnabled
	public static Boolean hasUtilityPermission(){
		return FeatureManagement.checkPermission('ScoreHubUtilityAccess');
	}
}