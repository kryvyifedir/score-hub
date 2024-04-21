@IsTest 
public class TestDataFactory {	

	public class TestException extends Exception {}
	
	public static Measurement__c initMeasurement(String uniqueIdentifier) {
		Measurement__c measurement = new Measurement__c();
		measurement.UniqueIdentifier__c = uniqueIdentifier;
		return measurement;
	}

	public static Measurement__c createMeasurement(String uniqueIdentifier) {
		Measurement__c measurement = initMeasurement(uniqueIdentifier);
		insert measurement;
		return measurement;
	}

	public static Achievement__c initAchievement(String uniqueIdentifier, Id measurementId) {
		Achievement__c achievement = new Achievement__c();
		achievement.Name = 'Name ' + uniqueIdentifier;
		achievement.Description__c = 'Generic description ' + uniqueIdentifier;
		achievement.Goal__c = 100 + Math.round(1000 * Math.random());
		achievement.Score__c = 100 + Math.round(1000 * Math.random());
		achievement.UITitle__c = 'UI Title ' + uniqueIdentifier;
		achievement.UIDescription__c = 'UI Description ' + uniqueIdentifier;
		achievement.Measurement__c = measurementId;
		return  achievement;
	}

	public static Achievement__c createAchievement(String uniqueIdentifier, Id measurementId) {
		Achievement__c achievement = TestDataFactory.initAchievement(uniqueIdentifier, measurementId);
		insert achievement;
		return achievement;
	}

	public static UserMeasurement__c initUserMeasurement(Id userId, Id measurementId, Decimal value) {
		UserMeasurement__c userMeasurement = new UserMeasurement__c();
		userMeasurement.User__c = userId;
		userMeasurement.Measurement__c = measurementId;
		userMeasurement.Value__c = value;
		return userMeasurement;
	}

	public static UserMeasurement__c createUserMeasurement(Id userId, Id measurementId, Decimal value) {
		UserMeasurement__c userMeasurement = initUserMeasurement(userId, measurementId, value);
		insert userMeasurement;
		return userMeasurement;
	}

	public static ReachedAchievement__c initReachedAchievement(Id userId, Id achievementId) {
		ReachedAchievement__c reachedAchievement = new ReachedAchievement__c();
		reachedAchievement.User__c = userId;
		reachedAchievement.Achievement__c = achievementId;
		return reachedAchievement;
	}

	public static ReachedAchievement__c createReachedAchievement(Id userId, Id achievementId) {
		ReachedAchievement__c reachedAchievement = initReachedAchievement(userId, achievementId);
		insert reachedAchievement;
		return reachedAchievement;
	}

	public static User initUser(Id profileId, String lastName) {
		User user = new User();
		user.ProfileId = profileId;
		user.LastName = lastName;
		user.Email = lastName + '@scoreHub.com';
		user.Username = lastName + '@scoreHub.com';
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

	public static Lead initLead(String name) {
		Lead newLead = new Lead();
		newLead.LastName = name;
		newLead.Company = name + ' COMPANY';
		return newLead;
	}

	public static Task initTask(String subject, String status) {
		Task task = new Task();
		task.Subject = subject;
		task.Status = status;
		return task;
	}

	public static FeedItem initFeedItem(String status) {
		FeedItem post = new FeedItem();
		post.ParentId = UserInfo.getUserId();
		post.Status = status;
		post.Body = 'Post body';
		return post;
	}

	public static Case initCase(String status) {
		Case newCase = new Case();
		newCase.OwnerId = UserInfo.getUserId();
		newCase.Status = status;
		return newCase;
	}

	public static void assignPermissionSet(Id userId, String psName) {
		PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = :psName];
		insert new PermissionSetAssignment(
			AssigneeId = userId,
			PermissionSetId = ps.Id
		);
	}
}