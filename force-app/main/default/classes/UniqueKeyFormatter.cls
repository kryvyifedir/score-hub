public with sharing class UniqueKeyFormatter {
	public static String generateUniqueKey(Id userId, Id entityId) {
		return userId + '-' + entityId;
	}
}