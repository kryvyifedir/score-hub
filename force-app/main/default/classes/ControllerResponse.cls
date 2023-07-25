public with sharing class ControllerResponse {
    public static Map<String, Object> success(Object obj) {
        return new Map<String, Object> {'Success' => obj};
    }
    
    public static Map<String, Object> error(String msg) {
        return new Map<String, Object> {'Error' => msg};
    }
    public static Map<String, Object> warning(Object msg) {
        return new Map<String, Object> {'Warning' => msg};
    }
}