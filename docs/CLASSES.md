# Apex guidelines
All the backend logic of GameForce is done using Apex Classes. Low-code tools are not used for development.
This section is meant to explain some key concepts that are utilized across the GameForce code.

## Using BaseSelector class to retrieve data instead of direct SOQL request
GameForce relies on [`BaseSelector`](../../force-app/main/default/classes/BaseSelector.cls) class to retrieve data for different sObjects. Concreate realizations of the BaseSelector class are used to retrieve data for a specific sObject

To create a concrete realization of a BaseSelector class, child class has to realize 3 methods:
- `public String sObjectApiName()`: this method should return the API name of the sObject
- `public override Set<String> fieldApiNames()`: returns a list of field API names that will be retrieved by Selector class

`BaseSelector` class provides a set of methods that can be used to retrieve data without the need to create additional methods on the concrete selector class:
### getByFieldValue(String filterFieldApiName, String compOperator, Object values)
```
public List<sObject> getByFieldValue(String filterFieldApiName, String compOperator, Object values)
```

Parameters: 
- `filterFieldApiName`: API name of the field that is going to be used for filtering SOQL request
- `compOperator`: Comparison operator for data filtering
- `values`: a value (set of values) that will be used for filtering data

Example: 
```
getByFieldValue('Name', 'IN', new Set<String>{'Name 1', 'Name 2', 'Name 3'})
```
equals to this SOQL
```
Set<String> names = new Set<String>{'Name 1', 'Name 2', 'Name 3'}
[...WHERE Name IN :names]
```

### getByIds(Set<Id> ids)
```
public List<sObject> getByIds(Set<Id> ids)
```
Parameters: 
- `ids`: API name of the field that is going to be used for filtering SOQL request

Example: 
```
getByIds(new Set<Id>{'Id1', 'Id2', 'Id3'})
```
equals to this SOQL
```
Set<Id> ids = new Set<Id>{'Id1', 'Id2', 'Id3'}
[...WHERE Id IN :ids]
```

### getAll()
```
public List<sObject> getAll()
```

Example: 
```
getAll()
```
equals to this SOQL
```
[SELECT ... FROM ... ]
```
This method should be used with caution since it doesn't have any limitation and can result in SOQL query limit

## Using Logger class to save information about exceptions
`Logger` class is used to save information about issues that might have occured in a system. This class will be refined in future to allow storing more granular information about the issues.

There are two main method of a Logger class that are used for storing runtime issues:
### saveSingleLog(String log)
```
public static void saveSingleLog(String log)
```
Stores a single issue in a `Log__c` sObject. Asyncronous and can be called from cached LWC methods.
Example:
```
} catch (Exception e) {
    Logger.saveSingleLog('Error message');
}
```
### addLog(String log)
```
public void addLog(String log)
```
Adds a new log record, but doesn't commit changes. `commitChanges()` has to be called once all issues are collected 

## Using ControllerResponse class to pass result of Apex controller to LWC components
`ControllerResponse` class is used to wrap the result of the execution of backend controller and have a more control over the issues (expected and unexpected) that might occure during the backend controller execution.

There are 3 methods that should be used to return result of a backend controller execution in a form of `Map<String, Object>`:

### success(Object obj)
```
public static Map<String, Object> success(Object obj)
```
Example:
```
@AuraEnabled(cacheable=true)
public static Map<String, Object> method(){
    ...
    return ControllerResponse.success('value to pass to LWC');
}
```

### error(String msg)
```
public static Map<String, Object> error(String msg)
```
Example:
```
@AuraEnabled(cacheable=true)
public static Map<String, Object> method(){
    Map<String, Object> result = new Map<String, Object>();
    try {
        ...
        return ControllerResponse.success('value to pass to LWC');
    } catch (Exception e) {
        ...
        result = ControllerResponse.error('error message displayed to user');
    }
    return result;
}
```

### warning(Object msg)
```
public static Map<String, Object> warning(Object msg)
```
Example:
```
@AuraEnabled(cacheable=true)
public static Map<String, Object> method(){
    Map<String, Object> result = new Map<String, Object>();
    try {
        if (all good) {
            return ControllerResponse.success('value to pass to LWC');
        } else {
            return ControllerResponse.success('Handled issue');
        }
    } catch (Exception e) {
        ...
        result = ControllerResponse.error('error message displayed to user');
    }
    return result;
}
```

## Trigger Handlers
TBD