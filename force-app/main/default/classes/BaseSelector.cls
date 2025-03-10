public abstract with sharing class BaseSelector {

	public abstract SObjectType sObjectType();
	public abstract Set<SObjectField> queryFields();

	public QueryBuilder selectorQueryBuilder() {
		return new QueryBuilder(sObjectType(), queryFields());
	}

	public List<sObject> getBy(QueryBuilder queryBuilder, Map<String, Object> binds) {
		List<sObject> result = new List<sObject>(); 

		if (queryBuilder != null && binds != null) {
			result = Database.queryWithBinds(queryBuilder.SOQL(), binds, System.AccessLevel.SYSTEM_MODE);
		}

		return result;
	}

	public List<sObject> getBy(QueryBuilder queryBuilder) {
		Map<String, Object> binds = new Map<String, Object>();
		return this.getBy(queryBuilder, binds);
	}

	public List<sObject> getByFieldValue(SObjectField sObjectField, String compOperator, Object values) {
		QueryBuilder builder = selectorQueryBuilder();
		builder.addFilter(sObjectField, compOperator, 'value');
		return getBy(builder, new Map<String, Object>{'value' => values});
	}

	public List<sObject> getAll() {
		QueryBuilder builder = selectorQueryBuilder();
		return getBy(builder);
	}

	public List<sObject> getByIds(Set<Id> ids) {
		return getByFieldValue(sObjectType().getDescribe().fields.getMap().get('id'), ' IN ', (Object) ids);
	}
}