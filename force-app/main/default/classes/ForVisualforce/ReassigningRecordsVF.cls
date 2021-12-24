public with sharing class ReassigningRecordsVF implements Database.Batchable<sObject> {
    
    public String email; 
    public String query;
    public String entity;
    public String field;
    public String value;
    public String fromUserId;


    public Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   public void execute(Database.BatchableContext BC, 
                       List<sObject> scope){
      for(Sobject s : scope){
          s.put(field,value); 
      }     
      update scope;
   }
   public void finish(Database.BatchableContext BC){

    Set<String> rep = new Set<String>{fromUserId, value};
    CustomNotificationFromApex.notifyUsers(rep, value, entity);
    }




    // Future method
    // --------------------------------------------------------------------------------------------------------
    /*
    @future
    public static void ReassigningRecords(String fromUserId, String toUserId, List<String> selectedOptions) {

         
        for(String so : selectedOptions){
            String query = 'SELECT Id ' + 
                           ' From '+ so +
                           ' WHERE OwnerId = \'' + fromUserId +'\'';

            List<sObject> recordList = Database.query(query);
            
                for(sObject rec : recordList){
                    String getOwnerId = (String)rec.put('OwnerId', toUserId);
                    //String oldDesc = (String)acc.put('description', 'new desc');
                    //getOwnerId = toUserId;

                    //System.debug(rec);
                }
                
                Database.update(recordList);
                
            }
        
    }
    */

}
