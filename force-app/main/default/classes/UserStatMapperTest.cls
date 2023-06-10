@IsTest
private class UserStatMapperTest {
	
	@IsTest
	private static void findByUserIdAndAchievementId_statWithIdsExists_existingStatReturned() {
		// Given
		Id profileId = UserInfo.getProfileId();

		User user1 = TestDataFactory.createUser(profileId, 'user1');
		User user2 = TestDataFactory.createUser(profileId, 'user2');
		Achievement__c achievement1 = TestDataFactory.createAchievement('achievement1');
		Achievement__c achievement2 = TestDataFactory.createAchievement('achievement2');

		UserStat__c stat1 = TestDataFactory.initUserStat(user1.Id, achievement1.Id);
		UserStat__c stat2 = TestDataFactory.initUserStat(user2.Id, achievement1.Id);
		UserStat__c stat3 = TestDataFactory.initUserStat(user2.Id, achievement2.Id);
		List<UserStat__c> stats = new List<UserStat__c> { stat1, stat2, stat3 };
		insert stats;

		// When
		UserStatMapper mapper = new UserStatMapper(stats);
		UserStat__c result1 = mapper.findByUserIdAndAchievementId(user1.Id, achievement1.Id);
		UserStat__c result2 = mapper.findByUserIdAndAchievementId(user2.Id, achievement1.Id);
		UserStat__c result3 = mapper.findByUserIdAndAchievementId(user2.Id, achievement2.Id);

		// Then
		System.assertEquals(stat1.Id, result1.Id, 'stat1 is expected to be returned for the combination of user1 and achievement 1');
		System.assertEquals(stat2.Id, result2.Id, 'stat1 is expected to be returned for the combination of user2 and achievement 1');
		System.assertEquals(stat3.Id, result3.Id, 'stat1 is expected to be returned for the combination of user2 and achievement 2');
	}

	@IsTest
	private static void findByUserIdAndAchievementId_statWithIdsDoesntExists_nullReturned() {
		// Given
		Id profileId = UserInfo.getProfileId();

		User user1 = TestDataFactory.createUser(profileId, 'user1');
		User user2 = TestDataFactory.createUser(profileId, 'user2');
		Achievement__c achievement1 = TestDataFactory.createAchievement('achievement1');

		UserStat__c stat1 = TestDataFactory.initUserStat(user1.Id, achievement1.Id);
		List<UserStat__c> stats = new List<UserStat__c> { stat1 };
		insert stats;

		// When
		UserStatMapper mapper = new UserStatMapper(stats);
		UserStat__c result = mapper.findByUserIdAndAchievementId(user2.Id, achievement1.Id);

		// Then
		System.assertEquals(null, result, 'null is expected since combination of user2 and achievement1 doesnt exist in UserStat__c');
	}
}