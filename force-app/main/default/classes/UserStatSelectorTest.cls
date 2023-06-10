@IsTest
private class UserStatSelectorTest {
	@IsTest
	private static void getByUserIds_recordWithIdExists_recordsReturned(){
		// Given
		Id profileId = UserInfo.getProfileId();

		User user1 = TestDataFactory.createUser(profileId, 'user1');
		User user2 = TestDataFactory.createUser(profileId, 'user2');
		Achievement__c achievement = TestDataFactory.createAchievement('achievement');

		UserStat__c stat1 = TestDataFactory.createUserStat(user1.Id, achievement.Id);
		UserStat__c stat2 = TestDataFactory.createUserStat(user2.Id, achievement.Id);

		// When 
		List<UserStat__c> result = UserStatSelector.getByUserIds(new Set<Id>{ user1.Id });
		Map<Id, UserStat__c> resultMap = new Map<Id, UserStat__c>(result);

		// Then
		System.assertEquals(1, result.size(), 'Record is expected to be found');
		System.assert(resultMap.containsKey(stat1.Id), 'Map is expected to have a specific user stat');
		System.assert(!resultMap.containsKey(stat2.Id), 'Map is not expected to have a specific user stat');
	}

	@IsTest
	private static void getByUserIds_emptyIdsSet_emptyListReturned(){
		// Given
		Set<Id> ids = new Set<Id>();

		// When 
		List<UserStat__c> result = UserStatSelector.getByUserIds(ids);

		// Then
		System.assertNotEquals(null, result, 'Empty list is expected');
		System.assertEquals(0, result.size(), 'Empty list is expected');
	}

	@IsTest
	private static void getByUserIds_noRecordsFound_emptyListReturned(){
		// Given
		Id profileId = UserInfo.getProfileId();
		User user = TestDataFactory.createUser(profileId, 'user');
		Achievement__c achievement = TestDataFactory.createAchievement('achievement');
		UserStat__c stat = TestDataFactory.createUserStat(user.Id, achievement.Id);
		Id userStatId = stat.id;
		delete stat;

		// When 
		List<UserStat__c> result = UserStatSelector.getByUserIds(new Set<Id> { userStatId });

		// Then
		System.assertNotEquals(null, result, 'Empty list is expected');
		System.assertEquals(0, result.size(), 'Empty list is expected');
	}
}