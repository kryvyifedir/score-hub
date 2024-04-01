public abstract with sharing class BaseSelector {

	public abstract String sObjectApiName();
	public abstract Set<String> fieldApiNames();

	public List<sObject> getByFieldValue(String filterFieldApiName, String compOperator, Object values) {
		List<sObject> result = new List<sObject>(); 
		if (values != null) {
			Map<String, Object> binds = new Map<String, Object> { 'values' => values };
			result = Database.queryWithBinds(
				'SELECT ' + queryFieldApiNamesStr() + ' FROM ' + sObjectApiName() + ' ' +
				'WHERE ' + filterFieldApiName + ' ' + compOperator + ' :values', 
				binds, System.AccessLevel.SYSTEM_MODE);
		}
		return result; 
	}

	public List<sObject> getAll() {
		Map<String, Object> binds = new Map<String, Object> ();
		return Database.queryWithBinds('SELECT ' + queryFieldApiNamesStr() + ' FROM ' + sObjectApiName(), binds, System.AccessLevel.SYSTEM_MODE);
	}

	public List<sObject> getByIds(Set<Id> ids) {
		return this.getByFieldValue('Id', 'IN', (Object) ids); 
	}

	private String queryFieldApiNamesStr() {
		return String.escapeSingleQuotes(String.join(new List<String>(fieldApiNames()), ','));
	}

	// private String queryFieldApiNamesStr() {
	// 	List<String> validFieldApiNames = new List<String>();
	// 	Map<String, Schema.SObjectField> fieldsMap = Schema.getGlobalDescribe().get('GameForce__'+sObjectApiName()).getDescribe().fields.getMap();

	// 	for (String fieldApiName : fieldApiNames()) {
	// 		if (fieldsMap.get(fieldApiName).getDescribe().isAccessible()) {
	// 			validFieldApiNames.add(fieldApiName);
	// 		}
	// 	}
	// 	return String.escapeSingleQuotes(String.join(validFieldApiNames, ','));
	// }
}