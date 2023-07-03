trigger FeedItemTrigger on FeedItem (after insert, after update) {
	if (Trigger.isAfter) {
		if (Trigger.isInsert) {
			FeedItemTriggerHandler.onAfterInsert(Trigger.newMap);
		}

		if (Trigger.isUpdate) {
			FeedItemTriggerHandler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
		}
	}
}