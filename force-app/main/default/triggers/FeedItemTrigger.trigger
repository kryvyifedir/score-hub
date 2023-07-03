trigger FeedItemTrigger on FeedItem (after insert, after update) {
	if (Trigger.isAfter) {
		if (Trigger.isInsert) {
			FeedItemHandler.onAfterInsert(Trigger.newMap);
		}

		if (Trigger.isUpdate) {
			FeedItemHandler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
		}
	}
}