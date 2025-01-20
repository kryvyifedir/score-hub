public with sharing class QueryBuilder {

	String queryString;

	public QueryBuilder(SObjectType sObjectType, Set<SObjectField> queryFields) {
		Set<String> fieldApiNames = new Set<String>();
		for (SObjectField queryField : queryFields) {
			fieldApiNames.add(queryField + '');
		}

		queryString = 'SELECT ' + String.join(fieldApiNames, ', ') + ' FROM ' + sObjectType;
	}

	public QueryBuilder addFilter(SObjectField filterFieldApiName, String compOperator, String bindVariableName) {
		queryString += ' WHERE ' + filterFieldApiName + ' ' + compOperator + ' :' + bindVariableName;
		return this;
	}

	public QueryBuilder addOrderBy(SObjectField orderByField) {
		return this.addOrderBy(orderByField, false);
	}

	public QueryBuilder addOrderBy(SObjectField orderByField, Boolean descending) {
		String order = descending ? 'DESC' : 'ASC';
		queryString += ' ORDER BY ' + orderByField + ' ' + order;
		return this;
	}

	public QueryBuilder addLimit(Integer numberOfRecords) {
		queryString += ' LIMIT ' + String.valueOf(numberOfRecords);
		return this;
	}

	public String SOQL() {
		return queryString;
	}
}