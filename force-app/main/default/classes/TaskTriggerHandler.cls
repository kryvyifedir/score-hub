public with sharing class TaskTriggerHandler extends BaseGameForceTriggerHandler {

	public static void onAfterInsert(Map<Id, Task> newTasks) {
		try {
			List<Task> tasksToProcess = getTasksToProcess(newTasks, null);
			if (!tasksToProcess.isEmpty()) {
				TaskTriggerHandler handler = new TaskTriggerHandler();
				handler.fireEvents(tasksToProcess, 'OwnerId', Constants.COMPLETED_TASKS_COUNTER_ID);
			}
		} catch (Exception e) {
			Logger.saveSingleLog('Unexpected exception caught in TaskTriggerHandler. ' + e.getMessage() + '. ' + e.getStackTraceString());
		}
	}

	public static void onAfterUpdate(Map<Id, Task> newTasks, Map<Id, Task> oldTasks) {
		try {
			List<Task> tasksToProcess = getTasksToProcess(newTasks, oldTasks);
			if (!tasksToProcess.isEmpty()) {
				TaskTriggerHandler handler = new TaskTriggerHandler();
				handler.fireEvents(tasksToProcess, 'OwnerId', Constants.COMPLETED_TASKS_COUNTER_ID);
			}
		} catch (Exception e) {
			Logger.saveSingleLog('Unexpected exception caught in TaskTriggerHandler. ' + e.getMessage() + '. ' + e.getStackTraceString());
		}
	}

	private static List<Task> getTasksToProcess(Map<Id, Task> newTasks, Map<Id, Task> oldTasks) {
		List<Task> tasksToProcess = new List<Task>();

		for (Id taskId : newTasks.keySet()) {
			Task newTask = newTasks.get(taskId);

			if(newTask.Status == 'Completed') {
				Task oldTask = oldTasks?.get(taskId);
				if (oldTask == null || oldTask.Status != 'Completed') {
					tasksToProcess.add(newTask);
				}
			}
		}

		return tasksToProcess;
	}
}