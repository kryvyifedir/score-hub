@IsTest(isParallel=true)
private class UserStatTriggerHelperTest {

	@IsTest
	private static void getStatsWithUpdatedProgressTest() {
		// Given
		Achievement__c achievement = TestDataFactory.initAchievement('01');
		insert achievement;

		UserStat__c statNew1 = TestDataFactory.initUserStat(UserInfo.getUserId(), achievement.Id);
		UserStat__c statNew2 = TestDataFactory.initUserStat(UserInfo.getUserId(), achievement.Id);
		insert new List<UserStat__c> { statNew1, statNew2 };

		UserStat__c oldStat1 = new UserStat__c(Id = statNew1.Id);
		oldStat1.CurrentProgress__c = statNew1.CurrentProgress__c + 1;
		UserStat__c oldStat2 = new UserStat__c(Id = statNew2.Id);
		oldStat2.CurrentProgress__c = statNew2.CurrentProgress__c;

		Map<Id, UserStat__c> newMap = new Map<Id, UserStat__c> { statNew1.Id => statNew1, statNew2.Id => statNew2 };
		Map<Id, UserStat__c> oldMap = new Map<Id, UserStat__c> { oldStat1.Id => oldStat1, oldStat2.Id => oldStat2 };

		// When
		Map<Id, UserStat__c> result = UserStatTriggerHelper.getStatsWithUpdatedProgress(newMap, oldMap);

		// Then
		System.assertEquals(1, result.size(), 'Only one UserStat__c record is expected to be returned');
		System.assert(result.containsKey(statNew1.Id), 'Changed UserStat__c is expected to be included');
		System.assert(!result.containsKey(statNew2.Id), 'Not changed UserStat__c is not expected to be included');

	}

	@IsTest
	private static void getStatsWithUpdatedEmptyOldMapTest() {
		// Given
		Achievement__c achievement = TestDataFactory.initAchievement('01');
		insert achievement;

		UserStat__c statNew1 = TestDataFactory.initUserStat(UserInfo.getUserId(), achievement.Id);
		UserStat__c statNew2 = TestDataFactory.initUserStat(UserInfo.getUserId(), achievement.Id);
		insert new List<UserStat__c> { statNew1, statNew2 };

		Map<Id, UserStat__c> newMap = new Map<Id, UserStat__c> { statNew1.Id => statNew1, statNew2.Id => statNew2 };
		Map<Id, UserStat__c> oldMap = new Map<Id, UserStat__c> ();

		// When
		Map<Id, UserStat__c> result = UserStatTriggerHelper.getStatsWithUpdatedProgress(newMap, oldMap);

		// Then
		System.assertEquals(2, result.size(), 'Only one UserStat__c record is expected to be returned');
		System.assert(result.containsKey(statNew1.Id), 'Since there are no old UserStat__c records to compare, all "new" records are treated as "changed"');
		System.assert(result.containsKey(statNew2.Id), 'Since there are no old UserStat__c records to compare, all "new" records are treated as "changed"');
	}

	@IsTest
	private static void getStatsWithUpdatedEmptyNewMapTest() {
		// Given
		Map<Id, UserStat__c> newMap = new Map<Id, UserStat__c> ();
		Map<Id, UserStat__c> oldMap = new Map<Id, UserStat__c> ();

		// When
		Map<Id, UserStat__c> result = UserStatTriggerHelper.getStatsWithUpdatedProgress(newMap, oldMap);

		// Then
		System.assertNotEquals(null, result, 'Empty map is expected but not null');
		System.assertEquals(0, result.size(), 'Empty map is expected but not null');
	}
}