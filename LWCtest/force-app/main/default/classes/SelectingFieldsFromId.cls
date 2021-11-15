public with sharing class SelectingFieldsFromId {
    

    @AuraEnabled
    public static List<User> SelectingFieldsFromId(String searchKey){
        Id recordId = '%'+ searchKey +'%';
 
        DescribeSObjectResult descResult = recordId.getSObjectType().getDescribe();
        List<String> fieldList = new List<String>(descResult.Fields.getMap().keySet());
        
        String query = ' SELECT ' + String.join(fieldList, ',') + ' FROM ' + descResult.getName() + ' WHERE ' + ' id = :recordId';
        List<sObject> records = Database.query(query);
        
        return records;
    }
    
}
