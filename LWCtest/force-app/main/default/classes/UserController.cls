public with sharing class UserController {
    
    @AuraEnabled
    public static List<User> findUser(String searchKey){
        String key = '%' + searchKey + '%';
        return [SELECT Name, IsActive FROM User WHERE Name LIKE :key LIMIT 10];
    }
}
