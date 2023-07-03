public with sharing class FeedItemTriggerHandler extends BaseGameForceTriggerHandler{
	
	public static void onAfterInsert(Map<Id, FeedItem> newPosts) {
		try {
			List<FeedItem> postsToProcess = getFeedItemsToProcess(newPosts, null);

			if (!postsToProcess.isEmpty()) {
				FeedItemTriggerHandler handler = new FeedItemTriggerHandler();
				handler.fireEvents(postsToProcess, 'CreatedById', Constants.CHATTER_POSTS_COUNTER_ID);
			}
		} catch (Exception e) {
			Logger.saveSingleLog('Unexpected exception caught in FeedItemTriggerHandler. ' + e.getMessage() + '. ' + e.getStackTraceString());
		}
	}

	public static void onAfterUpdate(Map<Id, FeedItem> newPosts, Map<Id, FeedItem> oldPosts) {
		try {
			List<FeedItem> postsToProcess = getFeedItemsToProcess(newPosts, oldPosts);

			if (!postsToProcess.isEmpty()) {
				FeedItemTriggerHandler handler = new FeedItemTriggerHandler();
				handler.fireEvents(postsToProcess, 'CreatedById', Constants.CHATTER_POSTS_COUNTER_ID);
			}
		} catch (Exception e) {
			Logger.saveSingleLog('Unexpected exception caught in FeedItemTriggerHandler. ' + e.getMessage() + '. ' + e.getStackTraceString());
		}
	}

	private static List<FeedItem> getFeedItemsToProcess(Map<Id, FeedItem> newFeedItems, Map<Id, FeedItem> oldFeedItems) {
		List<FeedItem> feedItemsToProcess = new List<FeedItem>();

		for (Id taskId : newFeedItems.keySet()) {
			FeedItem newFeedItem = newFeedItems.get(taskId);

			if(newFeedItem.Status == 'Published') {
				FeedItem oldFeedItem = oldFeedItems?.get(taskId);
				if (!(oldFeedItem != null && oldFeedItem.Status == 'Published')) {
					feedItemsToProcess.add(newFeedItem);
				}
			}
		}

		return feedItemsToProcess;
	}
}