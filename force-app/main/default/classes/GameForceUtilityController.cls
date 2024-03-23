public with sharing class GameForceUtilityController {
	@AuraEnabled
	public static Boolean hasUtilityPermission(){
		return FeatureManagement.checkPermission('GameForceUtilityAccess');
	}
}