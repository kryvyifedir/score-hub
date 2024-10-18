@IsTest
public with sharing class UserSelectorTest {

	@IsTest
	private static void sObjectApiName_sObjectNameReturned_nameIsValidated() {
		// Given
		UserSelector selector = UserSelector.getInstance();
		
		// When
		Test.startTest();
		String result = selector.sObjectApiName();
		Test.stopTest();

		// Then 
		Assert.areEqual('User', result, 'User sObject ApiName is expected');
	}

	@IsTest
	private static void fieldApiNames_sObjectNameReturned_fieldSetIsValidated() {
		// Given
		UserSelector selector = UserSelector.getInstance();
		
		// When
		Test.startTest();
		Set<String> result = selector.fieldApiNames();
		Test.stopTest();

		// Then 
		Set<String> expectedSet = new Set<String> {'Id', 'SmallPhotoUrl', 'Name'};
		Assert.areEqual(expectedSet, result, 'A specific field set is expected');
	}
	
	@IsTest
	private static void getByIds_recordWithIdExists_recordsReturned(){
		// Given
		Id profileId = UserInfo.getProfileId();
		User user1 = TestDataFactory.createUser(profileId, 'user1');
		User user2 = TestDataFactory.createUser(profileId, 'user2');

		// When 
		Test.startTest();
		List<User> result = UserSelector.getInstance().getByIds(new Set<Id>{ user1.Id });
		Map<Id, User> resultMap = new Map<Id, User>(result);
		Test.stopTest();

		// Then
		Assert.areEqual(1, result.size(), 'Record is expected to be found');
		Assert.isTrue(resultMap.containsKey(user1.Id), 'Map is expected to have a specific user');
		Assert.isFalse(resultMap.containsKey(user2.Id), 'Map is not expected to have a specific user');
	}

	@IsTest
	private static void getAll_recordsExists_recordsReturned(){
		// Given
		Id profileId = UserInfo.getProfileId();
		User user1 = TestDataFactory.createUser(profileId, 'user1');
		User user2 = TestDataFactory.createUser(profileId, 'user2');

		// When 
		Test.startTest();
		List<User> result = UserSelector.getInstance().getAll();
		Map<Id, User> resultMap = new Map<Id, User>(result);
		Test.stopTest();

		List<User> users = [SELECT Id FROM USER];

		// Then
		Assert.areEqual(users.size(), result.size(), 'All records are expected to be returned by selector');
	}

	@IsTest
	private static void getByIds_emptyIdsSet_emptyListReturned(){
		// Given
		Set<Id> ids = new Set<Id>();

		// When 
		Test.startTest();
		List<User> result = UserSelector.getInstance().getByIds(ids);
		Test.stopTest();

		// Then
		Assert.isNotNull(result, 'Empty list is expected');
		Assert.areEqual(0, result.size(), 'Empty list is expected');
	}
}