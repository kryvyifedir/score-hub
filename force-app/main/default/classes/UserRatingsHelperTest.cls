@IsTest
private class UserRatingsHelperTest {
	@IsTest
	private static void getTotalScoreAndCountByUser_usersPasses_groupedValuesReturned(){
		// Given
		Id profileId = UserInfo.getProfileId();
		User user1 = TestDataFactory.createUser(profileId, 'FirstUser');
		User user2 = TestDataFactory.createUser(profileId, 'SecondUser');
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement1 = TestDataFactory.createAchievement('Achievement1', measurement.Id);
		Achievement__c achievement2 = TestDataFactory.createAchievement('Achievement2', measurement.Id);
		Achievement__c achievement3 = TestDataFactory.createAchievement('Achievement3', measurement.Id);
		ReachedAchievement__c reachedAchievement1 = TestDataFactory.createReachedAchievement(user1.Id, achievement1.Id);
		ReachedAchievement__c reachedAchievement2 = TestDataFactory.createReachedAchievement(user1.Id, achievement2.Id);
		ReachedAchievement__c reachedAchievement3 = TestDataFactory.createReachedAchievement(user1.Id, achievement3.Id);
		ReachedAchievement__c reachedAchievement4 = TestDataFactory.createReachedAchievement(user2.Id, achievement1.Id);
		Set<Id> userIds = new Set<Id>{ user1.Id, user2.Id };

		// When
		Test.startTest();
		Map<Id, AggregateResult> result = UserRatingsHelper.getTotalScoreAndCountByUser(userIds);
		Test.stopTest();

		// Then
		System.assert(result.containsKey(user1.Id), 'AggregateResult is expected to exist in map');
		System.assertEquals(3, (Decimal) result.get(user1.Id).get('cnt'), 'Total count of reached achievements is expected to be 3');
		System.assertEquals(achievement1.Score__c + achievement2.Score__c + achievement3.Score__c, (Decimal) result.get(user1.Id).get('score'), 'Score should match the total of reached scores for the user');
		System.assert(result.containsKey(user2.Id), 'AggregateResult is expected to exist in map');
		System.assertEquals(1, (Decimal) result.get(user2.Id).get('cnt'), 'Total count of reached achievements is expected to be 3');
		System.assertEquals(achievement1.Score__c, (Decimal) result.get(user2.Id).get('score'), 'Score should match the total of reached scores for the user');
	}

	@IsTest
	private static void getTotalScoreAndCountByUser_emptyList_emptyMapReturned(){
		// Given
		Set<Id> userIds = new Set<Id>();

		// When
		Test.startTest();
		Map<Id, AggregateResult> result = UserRatingsHelper.getTotalScoreAndCountByUser(userIds);
		Test.stopTest();

		// Then
		System.assert(result.isEmpty(), 'Map is expected to be empty');
	}

	@IsTest
	private static void getTotalScoreAndCountByUser_userWithNoAchievements_emptyMapReturned(){
		// Given
		Set<Id> userIds = new Set<Id>{UserInfo.getUserId()};

		// When
		Test.startTest();
		Map<Id, AggregateResult> result = UserRatingsHelper.getTotalScoreAndCountByUser(userIds);
		Test.stopTest();

		// Then
		System.assert(result.isEmpty(), 'Map is expected to be empty');
	}
}