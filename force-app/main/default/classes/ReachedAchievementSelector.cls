public with sharing class ReachedAchievementSelector extends BaseSelector {
	
	public static ReachedAchievementSelector getInstance() {
		return new ReachedAchievementSelector();
	}

	public override String sObjectApiName() {
		return 'ReachedAchievement__c';
	}

	public override Set<String> fieldApiNames() {
		return new Set<String> {'Id', 'Key__c', 'User__c', 'Achievement__c', 'Score__c'};
	}
}