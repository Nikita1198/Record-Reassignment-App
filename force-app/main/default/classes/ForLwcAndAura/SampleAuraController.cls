public class SampleAuraController {
     
    public static String fieldAPIName {get; set;}

    @AuraEnabled(cacheable=true)  
    public static List<sobject> findRecords(String searchKey, String objectName) {  
      string searchText = '\'' + String.escapeSingleQuotes(searchKey) + '%\'';  
      string query = 'SELECT Id, Name FROM ' +objectName+ ' WHERE Name LIKE '+searchText+' ';  
      return Database.query('SELECT Id, Name FROM ' +objectName+ ' WHERE Name LIKE '+searchText+' ');  
    }   

    @AuraEnabled(cacheable=true)
    public static void getPiklistValues(String fromUserId, String toUserId, List<String> recordType ) {
        System.debug(fromUserId);
        System.debug(toUserId);
        System.debug(recordType);

        User fromUser = [SELECT Name,Email FROM User Where Id = :fromUserId];
        User toUser = [SELECT Name,Email FROM User Where Id = :toUserId];

        try{
            for(String sel : recordType){
                ReassigningRecords reassign  = new ReassigningRecords();

                reassign.query = 'SELECT Id ' + 
                            ' From '+ sel +
                            ' WHERE OwnerId = \'' + fromUserId +'\'';
                reassign.entity = sel;
                reassign.field = 'OwnerId';
                reassign.value = toUserId;
                reassign.fromUserId = fromUserId;
                reassign.toUserName = fromUser.Name;

                Id batchInstanceId = Database.executeBatch(reassign);
            }
        }catch(DMLException e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error!'));
        }
        /*
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        mail.setToAddresses(new String[] {fromUser.email, toUser.email });
        mail.setReplyTo('batch@acme.com');
        mail.setSenderDisplayName('App notification');
        mail.setSubject('Record Reassignment app');
        mail.setPlainTextBody('From user ' + fromUser.Name + ' to user ' + toUser.Name + ', this types of records were reassigned: '+ recordType +'.');

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        */
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getValues(String fromUserId) {
        List<String> options = new List<String>();

        if(fromUserId == null && fromUserId == null){
            System.debug('Sorry! User Id Error!');
            System.debug('User ID: ' + fromUserId);
            options.add('Nothing');
        }else {
            System.debug(fromUserId);
            
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
            List<String> typeOfObject = new List<String>();
            
    
            List<Schema.SObjectType> objNames = gd.values();
                    for (Schema.SObjectType cr : objNames) {
                        String relName = cr.getDescribe().getName();
                        
                        if (relName != null){
                            Map<String, Schema.SObjectField> fieldMap = gd.get(relName).getDescribe().fields.getMap();
                                for(Schema.SObjectField sfield : fieldMap.Values()){
                                    Schema.Describefieldresult dfield = sfield.getDescribe();
    
                                    fieldAPIName = dfield.getname();
    
                                    if(fieldAPIName == 'OwnerId' && dfield.isUpdateable() == true && dfield.isAccessible() == true){
                                        //options.add(new SelectOption(relName, relName)); 
                                        typeOfObject.add(relName);
                                    }
                                }
                            }
                        }
                    
                    for(String ty : typeOfObject){
                        String query = 'select Id'+' From '+ty+' WHERE OwnerId = \'' + fromUserId + '\'';
                        List<sObject> recordList = Database.query(query);
    
                        if(recordList!=null && !recordList.isEmpty()){
                            options.add(ty);
                        }
                    }
                    
                    
            System.debug(options);
            
        }
            return options; 
    }
}