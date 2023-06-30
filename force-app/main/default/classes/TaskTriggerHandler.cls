public with sharing class TaskTriggerHandler {
	Map<String, Id> measurementIdsByUniqueIds = new Map<String, Id> {
		Constants.COMPLETED_TASKS_COUNTER_ID => null
	};

	public TaskTriggerHandler () {
		initMeasurementsIds();
	}
	
	private void initMeasurementsIds() {
		Set<String> taskMeasurements = new Set<String> { Constants.COMPLETED_TASKS_COUNTER_ID };
		Map<String, Measurement__c> taskMeasurementsByUniqueIdMap = MeasurementSelector.getByUniqueIds(taskMeasurements);

		if (taskMeasurementsByUniqueIdMap.containsKey(Constants.COMPLETED_TASKS_COUNTER_ID)) {
			measurementIdsByUniqueIds.put(Constants.COMPLETED_TASKS_COUNTER_ID, taskMeasurementsByUniqueIdMap.get(Constants.COMPLETED_TASKS_COUNTER_ID).Id);
		}
	}

	public void fireEvents(List<Task> tasks, String measurementUniqueId) {
		List<UserMeasurementIncrement__e> events = new List<UserMeasurementIncrement__e>();
		Id measurementId = measurementIdsByUniqueIds.get(measurementUniqueId);
		if (measurementId == null) {
			return;
		}

		Map<Id, Decimal> incrementsByUserId = new Map<Id, Decimal>();

		for (Task task : tasks) {
			if (incrementsByUserId.containsKey(task.OwnerId)) {
				Decimal value = incrementsByUserId.get(task.OwnerId);
				incrementsByUserId.put(task.OwnerId, value + 1);
			} else {
				incrementsByUserId.put(task.OwnerId, 1);
			}
		}

		if (incrementsByUserId.isEmpty()) {
			return;
		}

		for (Id key : incrementsByUserId.keySet()) {
			UserMeasurementIncrement__e event = new UserMeasurementIncrement__e();
			event.UserId__c = key;
			event.MeasurementId__c = measurementId;
			event.Increment__c = incrementsByUserId.get(key);
			events.add(event);
		}

		if (!events.isEmpty()) {
			EventBus.publish(events);
		}

	}

	private static List<Task> getTasksToProcess(Map<Id, Task> newTasks, Map<Id, Task> oldTasks) {
		List<Task> tasksToProcess = new List<Task>();

		for (Id taskId : newTasks.keySet()) {
			Task newTask = newTasks.get(taskId);

			if(newTask.Status == 'Completed') {
				Task oldTask = oldTasks?.get(taskId);
				if (!(oldTask != null && oldTask.Status == 'Completed')) {
					tasksToProcess.add(newTask);
				}
			}
		}

		return tasksToProcess;
	}

	public static void onAfterInsert(Map<Id, Task> newTasks) {
		try {
			List<Task> tasksToProcess = getTasksToProcess(newTasks, null);
			if (!tasksToProcess.isEmpty()) {
				TaskTriggerHandler handler = new TaskTriggerHandler();
				handler.fireEvents(tasksToProcess, Constants.COMPLETED_TASKS_COUNTER_ID);
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
				handler.fireEvents(tasksToProcess, Constants.COMPLETED_TASKS_COUNTER_ID);
			}
		} catch (Exception e) {
			Logger.saveSingleLog('Unexpected exception caught in TaskTriggerHandler. ' + e.getMessage() + '. ' + e.getStackTraceString());
		}
	}
}