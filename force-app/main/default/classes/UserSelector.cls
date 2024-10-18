public with sharing class UserSelector extends BaseSelector {
	
	public static UserSelector getInstance() {
		return new UserSelector();
	}

	public override String sObjectApiName() {
		return 'User';
	}

	public override Set<String> fieldApiNames() {
		return new Set<String> {'Id', 'SmallPhotoUrl', 'Name'};
	}
}