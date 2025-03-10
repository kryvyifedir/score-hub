
@isTest
private class SchedulerServiceTest {

	@isTest
	static void calculateMinutesBetweenDates_validDates_correctMinutesReturned() {
		// Given
		Datetime startDate = Datetime.newInstance(2025, 2, 13, 10, 0, 0);
		Datetime endDate = Datetime.newInstance(2025, 2, 13, 12, 0, 0);

		// When
		Test.startTest();
		Integer minutes = SchedulerService.calculateMinutesBetweenDates(startDate, endDate);
		Test.stopTest();

		// Then
		Assert.areEqual(120, minutes, 'Expected 120 minutes between the given dates');
	}

	@isTest
	static void calculateMinutesBetweenDates_sameDates_zeroMinutesReturned() {
		// Given
		Datetime startDate = Datetime.newInstance(2025, 2, 13, 10, 0, 0);
		Datetime endDate = Datetime.newInstance(2025, 2, 13, 10, 0, 0);

		// When
		Test.startTest();
		Integer minutes = SchedulerService.calculateMinutesBetweenDates(startDate, endDate);
		Test.stopTest();

		// Then
		Assert.areEqual(0, minutes, 'Expected 0 minutes between the same dates');
	}

	@isTest
	static void calculateMinutesBetweenDates_endDateBeforeStartDate_negativeMinutesReturned() {
		// Given
		Datetime startDate = Datetime.newInstance(2025, 2, 13, 12, 0, 0);
		Datetime endDate = Datetime.newInstance(2025, 2, 13, 10, 0, 0);

		// When
		Test.startTest();
		Integer minutes = SchedulerService.calculateMinutesBetweenDates(startDate, endDate);
		Test.stopTest();

		// Then
		Assert.areEqual(-120, minutes, 'Expected -120 minutes when end date is before start date');
	}

	@isTest
	static void calculateMinutesBetweenDates_datesWithFourMonthsInBetween_correctMinutesReturned() {
		// Given
		Datetime startDate = Datetime.newInstance(2025, 6, 13, 10, 0, 0);
		Datetime endDate = Datetime.newInstance(2025, 10, 13, 10, 0, 0);

		// When
		Test.startTest();
		Integer minutes = SchedulerService.calculateMinutesBetweenDates(startDate, endDate);
		Test.stopTest();

		// Then
		Date d1 = Date.newInstance(2025, 6, 13);
		Date d2 = Date.newInstance(2025, 10, 13);
		Integer daysBetween = d1.daysBetween(d2);

		Integer expectedMinutes = (daysBetween * 24) * 60; 
		Assert.areEqual(expectedMinutes, minutes, 'Expected minutes between dates with 4 months in between');
	}
}