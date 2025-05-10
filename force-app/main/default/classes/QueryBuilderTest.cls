@IsTest(isParallel=true)
private class QueryBuilderTest {

	@IsTest
	private static void queryBuilderConstructor_parametersPassed_genericSOQLFormatted() {
		// Given
		SObjectType type = Account.getSObjectType();
		Set<sObjectField> fields = new Set<sObjectField> { Account.Name, Account.Phone };

		// When
		Test.startTest();
		QueryBuilder builder = new QueryBuilder(type, fields);
		Test.stopTest();

		// Then
		String expectedSOQLQuery = 'SELECT Name, Phone FROM Account';
		Assert.areEqual(expectedSOQLQuery, builder.SOQL(), 'Expected SOQL to be formatted by builder');
	}

	@IsTest
	private static void addFilter_paramsPassed_soqlWithQueryFilter() {
		// Given
		SObjectType type = Account.getSObjectType();
		Set<sObjectField> fields = new Set<sObjectField> { Account.Name, Account.Phone };

		// When
		Test.startTest();
		QueryBuilder builder = new QueryBuilder(type, fields);
		builder.addFilter(Account.Name, '==', 'bindName');
		Test.stopTest();

		// Then
		String expectedSOQLQuery = 'SELECT Name, Phone FROM Account WHERE Name == :bindName';
		Assert.areEqual(expectedSOQLQuery, builder.SOQL(), 'Expected SOQL to be formatted by builder');
	}

	@IsTest
	private static void addOrderBy_ascOptionIsUsed_soqlIsOrderedByDesc() {
		// Given
		SObjectType type = Account.getSObjectType();
		Set<sObjectField> fields = new Set<sObjectField> { Account.Name, Account.Phone };

		// When
		Test.startTest();
		QueryBuilder builder = new QueryBuilder(type, fields);
		builder.addOrderBy(Account.Name);
		Test.stopTest();

		// Then
		String expectedSOQLQuery = 'SELECT Name, Phone FROM Account ORDER BY Name ASC';
		Assert.areEqual(expectedSOQLQuery, builder.SOQL(), 'Expected SOQL to be formatted by builder');
	}

	@IsTest
	private static void addOrderBy_paramsPassed_soqlWithLimit() {
		// Given
		SObjectType type = Account.getSObjectType();
		Set<sObjectField> fields = new Set<sObjectField> { Account.Name, Account.Phone };

		// When
		Test.startTest();
		QueryBuilder builder = new QueryBuilder(type, fields);
		builder.addOrderBy(Account.Name, true);
		Test.stopTest();

		// Then
		String expectedSOQLQuery = 'SELECT Name, Phone FROM Account ORDER BY Name DESC';
		Assert.areEqual(expectedSOQLQuery, builder.SOQL(), 'Expected SOQL to be formatted by builder');
	}

	@IsTest
	private static void addLimit_descOptionIsUsed_soqlIsOrderedByDesc() {
		// Given
		SObjectType type = Account.getSObjectType();
		Set<sObjectField> fields = new Set<sObjectField> { Account.Name, Account.Phone };

		// When
		Test.startTest();
		QueryBuilder builder = new QueryBuilder(type, fields);
		builder.addLimit(10);
		Test.stopTest();

		// Then
		String expectedSOQLQuery = 'SELECT Name, Phone FROM Account LIMIT 10';
		Assert.areEqual(expectedSOQLQuery, builder.SOQL(), 'Expected SOQL to be formatted by builder');
	}

	@IsTest
	private static void addOffset_offsetIsAdded_resultIsOffset() {
		// Given
		SObjectType type = Account.getSObjectType();
		Set<sObjectField> fields = new Set<sObjectField> { Account.Name, Account.Phone };

		// When
		Test.startTest();
		QueryBuilder builder = new QueryBuilder(type, fields);
		builder.addOffset(10);
		Test.stopTest();

		// Then
		String expectedSOQLQuery = 'SELECT Name, Phone FROM Account OFFSET 10';
		Assert.areEqual(expectedSOQLQuery, builder.SOQL(), 'Expected SOQL to be formatted by builder');
	}
	
}