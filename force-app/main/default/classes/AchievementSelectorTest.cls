@IsTest(isParallel=true)
private class AchievementSelectorTest {
	
	private static Achievement__c generateAchievement(String uniqueIdentifier) {
		Achievement__c achievement = new Achievement__c();
		achievement.Name = 'Name ' + uniqueIdentifier;
		achievement.Description__c = 'Generic description ' + uniqueIdentifier;
		achievement.Enabled__c = true;
		achievement.Goal__c = Math.round(1000 * Math.random());
		achievement.Score__c = Math.round(1000 * Math.random());
		achievement.UITitle__c = 'UI Title ' + uniqueIdentifier;
		achievement.UIDescription__c = 'UI Description ' + uniqueIdentifier;
		return  achievement;
	}

	@IsTest
	private static void getByIds_idMatches_recordReturned(){
		// Given
		Achievement__c achievement1 = generateAchievement('OK1');
		Achievement__c achievement2 = generateAchievement('OK2');
		Achievement__c achievement3 = generateAchievement('NOTOK1');
		insert new List<Achievement__c> { achievement1, achievement2, achievement3 };
		Set<Id> ids = new Set<Id>{achievement1.id, achievement2.Id};

		// When 
		List<Achievement__c> result = AchievementSelector.getByIds(ids);

		// Then
		system.assertEquals(2, result.size(), '2 records are expected to be found');
		Map<Id, Achievement__c> resultMap = new Map<Id, Achievement__c>(result);
		system.assert(resultMap.containsKey(achievement1.Id), 'First achievement is expected to be found');
		system.assert(resultMap.containsKey(achievement2.Id), 'Second achievement is expected to be found');
		system.assert(!resultMap.containsKey(achievement3.Id), 'Third achievement is expected not to be found');
	}

	@IsTest
	private static void getByIds_emptyListOfIds_emptyListReturned(){
		// Given
		Set<Id> ids = new Set<Id>();

		// When 
		List<Achievement__c> result = AchievementSelector.getByIds(ids);

		// Then
		system.assertNotEquals(null, result, 'Empty list is expected instead of null');
		system.assertEquals(0, result.size(), 'Empty list is expected');
	}

	@IsTest
	private static void getByIds_noRecordsFound_emptyListReturned(){
		// Given
		Achievement__c achievement1 = generateAchievement('EXISTS1');
		Achievement__c achievement2 = generateAchievement('EXISTS2');
		Achievement__c achievement3 = generateAchievement('REMOVED');
		insert new List<Achievement__c> { achievement1, achievement2, achievement3 };
		Set<Id> ids = new Set<Id>{ achievement3.id };
		delete new List<Achievement__c> { achievement3 };

		// When 
		List<Achievement__c> result = AchievementSelector.getByIds(ids);

		// Then
		system.assertNotEquals(null, result, 'Empty list is expected instead of null');
		system.assertEquals(0, result.size(), 'Empty list is expected');
	}
}