public with sharing class Constants {
    public static final String CREATED_LEADS_COUNTER_ID = 'CreatedLeadsCounter';
    public static final String CONVERTED_LEADS_COUNTER_ID = 'ConvertedLeadsCounter';
    public static final String COMPLETED_TASKS_COUNTER_ID = 'CompletedTasksCounter';
    public static final String CHATTER_POSTS_COUNTER_ID = 'ChatterPostsCounter';
    public static final String CLOSED_CASES_ID = 'ClosedCasesId';

    public static final Set<String> MEASUREMENT_UNIQUE_IDS = new Set<String> {
        CREATED_LEADS_COUNTER_ID, CONVERTED_LEADS_COUNTER_ID, COMPLETED_TASKS_COUNTER_ID, CHATTER_POSTS_COUNTER_ID, CLOSED_CASES_ID
    };
}