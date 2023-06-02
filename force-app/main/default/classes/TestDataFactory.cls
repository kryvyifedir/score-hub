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

	public static User initUser(String lastName) {
		User user = new User();
		user.ProfileId = [SELECT Id FROM Profile LIMIT 1].Id;
		user.LastName = lastName;
		user.Email = lastName + '@gameforce.com';
		user.Email = lastName + '@gameforce.com';
		user.Alias = lastName + ' alias';
		user.Title = lastName + ' title';
		return user;
	}
}