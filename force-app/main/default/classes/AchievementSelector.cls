public with sharing class AchievementSelector extends BaseSelector {

	public static AchievementSelector getInstance() {
		return new AchievementSelector();
	}

	public override String sObjectApiName() {
		return 'Achievement__c';
	}

	public override Set<String> fieldApiNames() {
		return new Set<String> {'Id', 'Name', 'Description__c', 'Enabled__c', 'Goal__c', 'Score__c', 'UITitle__c', 'UIDescription__c', 'Measurement__c'};
	}
}