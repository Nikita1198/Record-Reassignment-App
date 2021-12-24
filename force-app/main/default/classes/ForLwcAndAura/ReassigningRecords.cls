public with sharing class ReassigningRecords implements Database.Batchable<sObject>, Database.stateful{
    
    public String email; 
    public String query;
    public String entity;
    public String field;
    public String value;
    public String fromUserId;
    public String toUserName;
    public Boolean key = true;

    public Integer totalAmtOfRecords = 0; 

    public Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   public void execute(Database.BatchableContext BC, 
                       List<sObject> scope){
      for(Sobject s : scope){
          s.put(field,value); 
      }
      
      totalAmtOfRecords += scope.size();
      update scope;
   }
   public void finish(Database.BatchableContext BC){
        System.debug('Succsses');
        system.debug('Total amount of records processed :' + totalAmtOfRecords);
        Set<String> rep = new Set<String>{fromUserId, value};
        if(totalAmtOfRecords != 0){
            CustomNotificationForLWC.notifyUsers(rep, value, entity,totalAmtOfRecords, key, toUserName);
        }
        if(totalAmtOfRecords == 0){
            key = false;
            CustomNotificationForLWC.notifyUsers(rep, value, entity,totalAmtOfRecords, key,  toUserName);
        }
    }

}