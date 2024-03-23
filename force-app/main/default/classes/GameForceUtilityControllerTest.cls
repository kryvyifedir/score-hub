@IsTest
private class GameForceUtilityControllerTest {
	@IsTest
	private static void hasUtilityPermission_userWithCustomPermission_true() {
		// Given
		User usr = createTestUser(true);
		
		// When
		Test.startTest();
		Boolean result;
		system.runAs(usr) {
			 result = GameForceUtilityController.hasUtilityPermission();
		}
		Test.stopTest();
		
		// Then
		system.assert(result, 'hasUtilityPermission is expected to return true if user has access to GameForceUtilityAccess PS');
	}

	@IsTest
	private static void hasUtilityPermission_userWithoutCustomPermission_false() {
		// Given
		User usr = createTestUser(false);
		
		// When
		Test.startTest();
		Boolean result;
		system.runAs(usr) {
			 result = GameForceUtilityController.hasUtilityPermission();
		}
		Test.stopTest();
		
		// Then
		system.assert(!result, 'hasUtilityPermission is expected to return false if user doesn\'t have access to GameForceUtilityAccess PS');
	}

	private static User createTestUser(Boolean assignPermission) {
		Id profileId = UserInfo.getProfileId();
		User usr = TestDataFactory.createUser(profileId, 'Test_User');

		if (assignPermission) {
			PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'GameForceAccessNotificationUtility'];
			PermissionSetAssignment assignment = new PermissionSetAssignment();
			assignment.AssigneeId = usr.Id;
			assignment.PermissionSetId= ps.Id;
			insert assignment;
		}

		return usr;
	}
}