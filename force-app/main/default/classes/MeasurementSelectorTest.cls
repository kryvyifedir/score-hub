@IsTest(isParallel=true)
private class MeasurementSelectorTest {
	@IsTest
	private static void getByIds_recordWithIdExists_recordsReturned(){
		// Given
		Measurement__c measurement1 = TestDataFactory.createMeasurement('Found');
		Measurement__c measurement2 = TestDataFactory.createMeasurement('Not found');

		// When 
		Test.startTest();
		List<Measurement__c> result = MeasurementSelector.getByIds(new Set<Id>{ measurement1.Id });
		Map<Id,Measurement__c> resultMap = new Map<Id,Measurement__c>(result);
		Test.stopTest();

		// Then
		System.assertEquals(1, result.size(), 'Record is expected to be found');
		System.assert(resultMap.containsKey(measurement1.Id), 'Map is expected to have a specific measurement');
		System.assert(!resultMap.containsKey(measurement2.Id), 'Map is not expected to have a specific measurement');
	}

	@IsTest
	private static void getByIds_emptyIdsSet_emptyListReturned(){
		// Given
		Set<Id> ids = new Set<Id>();

		// When 
		Test.startTest();
		List<Measurement__c> result = MeasurementSelector.getByIds(ids);
		Test.stopTest();

		// Then
		System.assertNotEquals(null, result, 'Empty list is expected');
		System.assertEquals(0, result.size(), 'Empty list is expected');
	}

	@IsTest
	private static void getByIds_noRecordsFound_emptyListReturned(){
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement('REMOVED');
		Id measurementId = measurement.Id;
		delete new List<Measurement__c> { measurement };

		// When 
		Test.startTest();
		List<Measurement__c> result = MeasurementSelector.getByIds(new Set<Id> { measurementId });
		Test.stopTest();

		// Then
		System.assertNotEquals(null, result, 'Empty list is expected');
		System.assertEquals(0, result.size(), 'Empty list is expected');
	}
}