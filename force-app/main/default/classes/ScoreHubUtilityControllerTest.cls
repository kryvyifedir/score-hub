@IsTest
private class ScoreHubUtilityControllerTest {
	@IsTest
	private static void hasUtilityPermission_userWithCustomPermission_true() {
		// Given
		User usr = TestDataFactory.createUser(UserInfo.getProfileId(), 'Test');
		TestDataFactory.assignPermissionSet(usr.Id, 'ScoreHubAccessNotificationUtility');
		
		// When
		Test.startTest();
		Boolean result;
		system.runAs(usr) {
			 result = ScoreHubUtilityController.hasUtilityPermission();
		}
		Test.stopTest();
		
		// Then
		system.assert(result, 'hasUtilityPermission is expected to return true if user has access to ScoreHubUtilityAccess PS');
	}

	@IsTest
	private static void hasUtilityPermission_userWithoutCustomPermission_false() {
		// Given
		User usr = TestDataFactory.createUser(UserInfo.getProfileId(), 'Test');
		
		// When
		Test.startTest();
		Boolean result;
		system.runAs(usr) {
			 result = ScoreHubUtilityController.hasUtilityPermission();
		}
		Test.stopTest();
		
		// Then
		system.assert(!result, 'hasUtilityPermission is expected to return false if user doesn\'t have access to ScoreHubUtilityAccess PS');
	}
}