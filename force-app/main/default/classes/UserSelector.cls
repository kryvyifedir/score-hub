public with sharing class UserSelector extends BaseSelector {
	
	public static UserSelector getInstance() {
		return new UserSelector();
	}

	public override SObjectType sObjectType() {
		return User.getSObjectType();
	}

	public override Set<SObjectField> queryFields() {
		return new Set<SObjectField> { User.Id, User.SmallPhotoUrl, User.Name };
	}
}