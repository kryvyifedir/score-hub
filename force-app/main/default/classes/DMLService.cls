public with sharing class DMLService {

	public static List<SObject> insertRecord(List<SObject> records, System.AccessLevel accessLevel) {
		List<Database.SaveResult> results = Database.insert(records, false, accessLevel);
		Logger logger = new Logger();
		
		for (Database.SaveResult result : results) {
			if (!result.isSuccess()) {
				for (Database.Error error : result.getErrors()) {
					logger.addLog('Unable to insert: ' + error.getMessage());
				}
			}
		}

		logger.commitChanges();

		return records;
	}

	public static List<SObject> updateRecord(List<SObject> records, System.AccessLevel accessLevel) {
		List<Database.SaveResult> results = Database.update(records, false, accessLevel);
		Logger logger = new Logger();
		
		for (Database.SaveResult result : results) {
			if (!result.isSuccess()) {
				for (Database.Error error : result.getErrors()) {
					logger.addLog('Unable to update: ' + error.getMessage());
				}
			}
		}

		logger.commitChanges();

		return records;
	}

	public static void deleteRecord(List<SObject> records, System.AccessLevel accessLevel) {
		List<Database.DeleteResult> results = Database.delete(records, false, accessLevel);
		Logger logger = new Logger();
		
		for (Database.DeleteResult result : results) {
			if (!result.isSuccess()) {
				for (Database.Error error : result.getErrors()) {
					logger.addLog('Unable to delete: ' + error.getMessage());
				}
			}
		}

		logger.commitChanges();
	}

	public static List<SObject> upsertRecord(List<SObject> records, System.AccessLevel accessLevel) {
		List<Database.UpsertResult> results = Database.upsert(records, false, accessLevel);
		Logger logger = new Logger();
		
		for (Database.UpsertResult result : results) {
			if (!result.isSuccess()) {
				for (Database.Error error : result.getErrors()) {
					logger.addLog('Unable to upsert: ' + error.getMessage());
				}
			}
		}

		logger.commitChanges();

		return records;
	}
}