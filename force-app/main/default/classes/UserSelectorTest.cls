@IsTest
public with sharing class UserSelectorTest {
	
	@IsTest
	private static void getByIds_recordWithIdExists_recordsReturned(){
		// Given
		Id profileId = UserInfo.getProfileId();
		User user1 = TestDataFactory.createUser(profileId, 'user1');
		User user2 = TestDataFactory.createUser(profileId, 'user2');

		// When 
		List<User> result = UserSelector.getByIds(new Set<Id>{ user1.Id });
		Map<Id, User> resultMap = new Map<Id, User>(result);

		// Then
		System.assertEquals(1, result.size(), 'Record is expected to be found');
		System.assert(resultMap.containsKey(user1.Id), 'Map is expected to have a specific user');
		System.assert(!resultMap.containsKey(user2.Id), 'Map is not expected to have a specific user');
	}

	@IsTest
	private static void getByIds_emptyIdsSet_emptyListReturned(){
		// Given
		Set<Id> ids = new Set<Id>();

		// When 
		List<User> result = UserSelector.getByIds(ids);

		// Then
		System.assertNotEquals(null, result, 'Empty list is expected');
		System.assertEquals(0, result.size(), 'Empty list is expected');
	}
}