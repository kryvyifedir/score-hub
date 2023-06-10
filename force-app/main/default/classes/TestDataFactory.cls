@IsTest 
public class TestDataFactory {	
	
	public static Achievement__c initAchievement(String uniqueIdentifier) {
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

	public static Achievement__c createAchievement(String uniqueIdentifier) {
		Achievement__c achievement = TestDataFactory.initAchievement(uniqueIdentifier);
		insert achievement;
		return achievement;
	}

	public static UserStat__c initUserStat(Id userId, Id achievementId) {
		UserStat__c stat = new UserStat__c();
		stat.UserId__c = userId;
		stat.Achievement__c = achievementId;
		stat.CurrentProgress__c = 0;
		stat.Reached__c = false;
		return stat;
	}

	public static UserStat__c initUserStat(Id userId, Id achievementId, Decimal progress) {
		UserStat__c stat = new UserStat__c();
		stat.UserId__c = userId;
		stat.Achievement__c = achievementId;
		stat.CurrentProgress__c = progress;
		stat.Reached__c = false;
		return stat;
	}

	public static UserStat__c createUserStat(Id userId, Id achievementId) {
		UserStat__c stat = TestDataFactory.initUserStat(userId, achievementId);
		insert stat;
		return stat;
	}

	public static UserStat__c createUserStat(Id userId, Id achievementId, Decimal progress) {
		UserStat__c stat = TestDataFactory.initUserStat(userId, achievementId, progress);
		insert stat;
		return stat;
	}

	public static User initUser(Id profileId, String lastName) {
		User user = new User();
		user.ProfileId = profileId;
		user.LastName = lastName;
		user.Email = lastName + '@gameforce.com';
		user.Username = lastName + '@gameforce.com';
		user.Title = lastName + ' title';
		user.Alias = 'alias';
		user.TimeZoneSidKey = 'America/Los_Angeles';
		user.EmailEncodingKey = 'UTF-8';
    	user.LanguageLocaleKey = 'en_US';
		user.LocaleSidKey = 'en_US';

		return user;
	}

	public static User createUser(Id profileId, String lastName) {
		User user = initUser(profileId, lastName);
		insert user;
		return user;
	}
}