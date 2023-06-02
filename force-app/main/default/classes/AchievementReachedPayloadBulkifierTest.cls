@IsTest
private class AchievementReachedPayloadBulkifierTest {

	@IsTest
	private static void addUserAchievementTest(){
		// Given
		Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;
		User user1 = TestDataFactory.initUser(profileId, 'user1');
		User user2 = TestDataFactory.initUser(profileId, 'user2');
		insert new List<User>{ user1, user2 };

		Achievement__c achievement1 = TestDataFactory.initAchievement('user11');
		Achievement__c achievement2 = TestDataFactory.initAchievement('user12');
		Achievement__c achievement3 = TestDataFactory.initAchievement('user21');
		insert new List<Achievement__c>{ achievement1, achievement2, achievement3 };

		// When 
		AchievementReachedPayloadBulkifier payloadBulkifier = new AchievementReachedPayloadBulkifier();
		payloadBulkifier.addUserAchievement(user1.Id, achievement1.Id);
		payloadBulkifier.addUserAchievement(user1.Id, achievement2.Id);
		payloadBulkifier.addUserAchievement(user2.Id, achievement3.Id);

		// Then
		system.assertEquals(2, payloadBulkifier.achievementIdsByUserIdMap.keySet().size(), 'Internal map is expected to have 2 user Ids as keys');
		system.assert(payloadBulkifier.achievementIdsByUserIdMap.containsKey(user1.Id), 'Internal map is expected to have 2 user Ids as keys');
		system.assert(payloadBulkifier.achievementIdsByUserIdMap.containsKey(user2.Id), 'Internal map is expected to have 2 user Ids as keys');
		system.assertEquals(2, payloadBulkifier.achievementIdsByUserIdMap.get(user1.Id).size(), '2 achievements are expected to be saved for user1');
		system.assert(payloadBulkifier.achievementIdsByUserIdMap.get(user1.Id).contains(achievement1.Id), 'User user1 set of achievements is expected to have achivement 1 and 2');
		system.assert(payloadBulkifier.achievementIdsByUserIdMap.get(user1.Id).contains(achievement2.Id), 'User user1 set of achievements is expected to have achivement 1 and 2');
		system.assertEquals(1, payloadBulkifier.achievementIdsByUserIdMap.get(user2.Id).size(), '1 achievement is expected to be saved for user2');
		system.assert(payloadBulkifier.achievementIdsByUserIdMap.get(user2.Id).contains(achievement3.Id), 'User user2 set of achievements is expected to have achivement 3');
	}

	@IsTest
	private static void getPayloadsValidateResultingJSONTest(){
		// Given
		Id userId = UserInfo.getUserId();
		Achievement__c achievement = TestDataFactory.initAchievement('achievement');
		insert achievement;
		String expectedJSON = '[{"userId":"' + userId + '","achievementId":"' + achievement.Id + '"}]';

		// When
		AchievementReachedPayloadBulkifier payloadBulkifier = new AchievementReachedPayloadBulkifier();
		payloadBulkifier.addUserAchievement(userId, achievement.Id);
		List<String> result = payloadBulkifier.getPayloads();

		// Then
		system.assertEquals(expectedJSON, result[0], 'Formatted JSON is expected to match a specific format');
	}

	@IsTest
	private static void getPayloadsSplittingRecordsInChunksOfTenTest(){
		// Given
		Id userId = UserInfo.getUserId();
		List<Achievement__c> achievements = new List<Achievement__c>();
		for (Integer i = 0 ; i < 11; i++) {
			achievements.add(TestDataFactory.initAchievement(String.valueOf(i)));
		}
		insert achievements;

		// When
		AchievementReachedPayloadBulkifier payloadBulkifier = new AchievementReachedPayloadBulkifier();
		for (Achievement__c achievement : achievements) {
			payloadBulkifier.addUserAchievement(userId, achievement.Id);
		}
		List<String> result = payloadBulkifier.getPayloads();

		// Then
		system.assertEquals(2, result.size(), 'Since there are more then 10 achievements added in total, result is expected to have 2 payloads');
		system.assert(result[0].length() < 131072, 'JSON string size for one chunk is expected to be less then 131072 symbols to fit the payload');
	}
}