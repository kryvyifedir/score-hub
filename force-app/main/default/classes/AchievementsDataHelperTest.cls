@IsTest
private class AchievementsDataHelperTest {
	@IsTest 
	private static void getAchievementsPerUser_ReachedAchievementExists_AchievementListReturned() {
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement1 = TestDataFactory.initAchievement('Ach1', measurement.Id);
		Achievement__c achievement2 = TestDataFactory.initAchievement('Ach2', measurement.Id);
		insert new List<Achievement__c> { achievement1, achievement2 };

		Id profileId = UserInfo.getProfileId(); 
		User user1 = TestDataFactory.initUser(profileId, 'user1');
		User user2 = TestDataFactory.initUser(profileId, 'user2');
		insert new List<User> { user1, user2 };

		ReachedAchievement__c reachedAchievement = TestDataFactory.createReachedAchievement(user1.Id, achievement1.Id);

		// When
		Test.startTest();
		Map<Id, List<DataWrappers.AchievementCardData>> result = AchievementsDataHelper.getAchievementsDataPerUserId(new Set<Id>{ user1.Id, user2.Id });
		Test.stopTest();

		// Then
		Assert.isTrue(result.containsKey(user1.Id), 'Map is expected to have keys for both users');
		Assert.isTrue(result.containsKey(user2.Id), 'Map is expected to have keys for both users');

		List<DataWrappers.AchievementCardData> resultUser1 = result.get(user1.Id);
		Assert.areEqual(2, resultUser1.size(), '2 Achievements are expected');
		for (DataWrappers.AchievementCardData achievementData : resultUser1) {
			if (achievementData.id == achievement1.Id) {
				Assert.isTrue(achievementData.isReached, 'First achievement for the first user is expected to be marked as reached');
			} else {
				Assert.isFalse(achievementData.isReached, 'All other achievements are expected to be not reached');
			}
		}

		List<DataWrappers.AchievementCardData> resultUser2 = result.get(user2.Id);
		Assert.areEqual(2, resultUser2.size(), '2 Achievements are expected');
		for (DataWrappers.AchievementCardData achievementData : resultUser2) {
			Assert.isFalse(achievementData.isReached, 'All achievements for second user are expected to be not reached');
		}
	}

	@IsTest 
	private static void getClosestAchievementForUser_NoReachedAchievement_FirstAchievementByGoalReturned() {
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement1 = TestDataFactory.initAchievement('Ach1', measurement.Id);
		achievement1.Goal__c = 100;
		Achievement__c achievement2 = TestDataFactory.initAchievement('Ach2', measurement.Id);
		achievement2.Goal__c = 200;
		insert new List<Achievement__c> {achievement1, achievement2};

		// When
		Test.startTest();
		DataWrappers.AchievementCardData result = AchievementsDataHelper.getClosestAchievementForUser(UserInfo.getUserId());
		Test.stopTest();

		Assert.areEqual(achievement1.Id, result.id, 'Information about achievement 1 is expected to be returned');
	}

	@IsTest 
	private static void getClosestAchievementForUser_FirstAchievementReached_SecondAchievementReturned() {
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement1 = TestDataFactory.initAchievement('Ach1', measurement.Id);
		achievement1.Goal__c = 100;
		Achievement__c achievement2 = TestDataFactory.initAchievement('Ach2', measurement.Id);
		achievement2.Goal__c = 200;
		insert new List<Achievement__c> {achievement1, achievement2};
		UserMeasurement__c userMeasurement = TestDataFactory.createUserMeasurement(UserInfo.getUserId(), measurement.Id, 120);

		// When
		Test.startTest();
		DataWrappers.AchievementCardData result = AchievementsDataHelper.getClosestAchievementForUser(UserInfo.getUserId());
		Test.stopTest();

		Assert.areEqual(achievement2.Id, result.id, 'Information about achievement 2 is expected to be returned');
	}

	@IsTest 
	private static void getClosestAchievementForUser_AllReached_NullReturned() {
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement1 = TestDataFactory.initAchievement('Ach1', measurement.Id);
		achievement1.Goal__c = 100;
		Achievement__c achievement2 = TestDataFactory.initAchievement('Ach2', measurement.Id);
		achievement2.Goal__c = 200;
		insert new List<Achievement__c> {achievement1, achievement2};
		UserMeasurement__c userMeasurement = TestDataFactory.createUserMeasurement(UserInfo.getUserId(), measurement.Id, 220);

		// When
		Test.startTest();
		DataWrappers.AchievementCardData result = AchievementsDataHelper.getClosestAchievementForUser(UserInfo.getUserId());
		Test.stopTest();

		Assert.isNull(result.id, 'Null is expected since all achievements were reached');
	}

	@IsTest 
	private static void getClosestAchievementForUser_FirstAchievementReachedButThirdIsSmaller_ThirdAchievementReturned() {
		// Given
		Measurement__c measurement1 = TestDataFactory.createMeasurement('Measurement1');
		Measurement__c measurement2 = TestDataFactory.createMeasurement('Measurement2');
		Achievement__c achievement1 = TestDataFactory.initAchievement('Ach1', measurement1.Id);
		achievement1.Goal__c = 100;
		Achievement__c achievement2 = TestDataFactory.initAchievement('Ach2', measurement1.Id);
		achievement2.Goal__c = 200;
		Achievement__c achievement3 = TestDataFactory.initAchievement('Ach3', measurement2.Id);
		achievement3.Goal__c = 10;
		insert new List<Achievement__c> {achievement1, achievement2, achievement3};
		UserMeasurement__c userMeasurement = TestDataFactory.createUserMeasurement(UserInfo.getUserId(), measurement1.Id, 120);

		// When
		Test.startTest();
		DataWrappers.AchievementCardData result = AchievementsDataHelper.getClosestAchievementForUser(UserInfo.getUserId());
		Test.stopTest();

		Assert.areEqual(achievement3.Id, result.id, 'Information about achievement 3 is expected to be returned');
	}

	@IsTest
	private static void initAchievementCardData_reachedAchievementExists_AchievementCardDataReturned() {
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement1 = TestDataFactory.createAchievement('Ach1', measurement.Id);
		ReachedAchievement__c reachedAchievement = TestDataFactory.createReachedAchievement(UserInfo.getUserId(), achievement1.Id);
		reachedAchievement = [SELECT Id, CreatedDate FROM ReachedAchievement__c LIMIT 1];

		// When 
		Test.startTest();
		DataWrappers.AchievementCardData cardData = AchievementsDataHelper.initAchievementCardData(achievement1, reachedAchievement);
		Test.stopTest();

		// Then
		Assert.areEqual(achievement1.Id, cardData.Id);
		Assert.areEqual(achievement1.Name, cardData.name);
		Assert.areEqual(achievement1.Measurement__c, cardData.measurementId);
		Assert.areEqual(achievement1.UITitle__c, cardData.uiTitle);
		Assert.areEqual(achievement1.UIDescription__c, cardData.uiDescription);
		Assert.areEqual(achievement1.Score__c, cardData.score);
		Assert.isTrue(cardData.isReached);
		Assert.areEqual(reachedAchievement.CreatedDate.getTime(), cardData.ReachedDate);
	}

	@IsTest
	private static void initAchievementCardData_reachedAchievementDoesntExist_AchievementCardDataReturned() {
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement1 = TestDataFactory.createAchievement('Ach1', measurement.Id);

		// When 
		Test.startTest();
		DataWrappers.AchievementCardData cardData = AchievementsDataHelper.initAchievementCardData(achievement1, null);
		Test.stopTest();

		// Then
		Assert.areEqual(achievement1.Id, cardData.Id);
		Assert.areEqual(achievement1.Name, cardData.name);
		Assert.areEqual(achievement1.Measurement__c, cardData.measurementId);
		Assert.areEqual(achievement1.UITitle__c, cardData.uiTitle);
		Assert.areEqual(achievement1.UIDescription__c, cardData.uiDescription);
		Assert.areEqual(achievement1.Score__c, cardData.score);
		Assert.isFalse(cardData.isReached);
		Assert.areEqual(0, cardData.ReachedDate);
	}

	
}