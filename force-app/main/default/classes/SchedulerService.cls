public with sharing class SchedulerService {
	public static Integer calculateMinutesBetweenDates(Datetime startDate, Datetime endDate) {
		Long milliseconds = endDate.getTime() - startDate.getTime();
		return (Integer) (milliseconds / 1000 / 60);
	}
}