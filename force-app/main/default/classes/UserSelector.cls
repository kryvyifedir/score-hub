public with sharing class UserSelector {
	private static final String FIELDS_LIST = 'Id, FullPhotoUrl, Name';

	public static List<User> getByIds(Set<Id> ids) {
		if (ids.isEmpty()) {
			return new List<User>();
		}

		Map<String, Object> binds = new Map<String, Object> { 'ids' => ids };
		return Database.queryWithBinds('SELECT ' + FIELDS_LIST + ' FROM User WHERE Id IN :ids', binds, System.AccessLevel.SYSTEM_MODE);
	}
}