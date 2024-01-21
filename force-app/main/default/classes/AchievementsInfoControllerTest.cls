@IsTest
private class AchievementsInfoControllerTest {
    @IsTest 
	private static void getUserAchievementsById_ReachedAchievementExists_AchievementListReturned() {
        // Given
		Measurement__c measurement = TestDataFactory.createMeasurement('Measurement');
		Achievement__c achievement1 = TestDataFactory.initAchievement('Ach1', measurement.Id);
		Achievement__c achievement2 = TestDataFactory.initAchievement('Ach2', measurement.Id);
		insert new List<Achievement__c> { achievement1, achievement2 };

		ReachedAchievement__c reachedAchievement = TestDataFactory.createReachedAchievement(UserInfo.getUserId(), achievement1.Id);

		// When
		Test.startTest();
        Map<String, Object> result = AchievementsInfoController.getUserAchievementsById(new List<Id>{UserInfo.getUserId()});
		Test.stopTest();

		// Then
        System.assert(result.containsKey('Success'), 'Resulting map is expected to have "Success" key');
        System.assert(!result.containsKey('Warning'), 'Resulting map is not expected to have "Warning" key');
        System.assert(!result.containsKey('Error'), 'Resulting map is not expected to have "Error" key');

		Map<Id, List<DataWrappers.AchievementCardData>> achievementsByUserIdMap = (Map<Id, List<DataWrappers.AchievementCardData>>) result.get('Success');
        List<DataWrappers.AchievementCardData> userAchievementCardDataList =  achievementsByUserIdMap.get(UserInfo.getUserId());
        
		System.assertNotEquals(null, userAchievementCardDataList, 'Achievements are expected to be found for current user');
		System.assertEquals(2, userAchievementCardDataList.size(), '2 Achievements are expected');
		for (DataWrappers.AchievementCardData achievementData : userAchievementCardDataList) {
			if (achievementData.id == achievement1.Id) {
				System.assertEquals(true, achievementData.isReached, 'First achievement for the user is expected to be marked as reached');
			} else {
				System.assertEquals(false, achievementData.isReached, 'All other achievements are expected to be not reached');
			}
		}
    }
}