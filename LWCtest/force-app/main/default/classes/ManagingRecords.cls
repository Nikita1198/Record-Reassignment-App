public with sharing class ManagingRecords {
   
    /*@AuraEnabled(cacheable=true)
    public static List<sobject> findRec(String fromUser, String toUser, String[] objectsName){
        for(String objects: objectsName ){
            if(objects == 'Account'){
                List<Account> accounts = new Query('Account').
                                         selectField('Name').
                                         addConditionEq('OwnerId', fromUser).
                                         run();
                for (Account acc : accounts) {
                acc.OwnerId = toUser ;
                }
                List<Account> toInsert = accounts;
                update toInsert;
            }
            if(objects == 'Lead'){
                List<Lead> leads = new Query('Lead').
                                         selectField('Name').
                                         addConditionEq('OwnerId', fromUser).
                                         run();
                for (Lead acc : leads) {
                acc.OwnerId = toUser ;
                }
                List<Lead> toInsert = leads;
                update toInsert;
            }
            if(objects == 'Contact'){
                List<Contact> contacts = new Query('Contact').
                                         selectField('Name').
                                         addConditionEq('OwnerId', fromUser).
                                         run();
                for (Contact acc : contacts) {
                acc.OwnerId = toUser ;
                }
                List<Contact> toInsert = contacts;
                update toInsert;
            }
            if(objects == 'Task'){
                List<Task> tasks = new Query('Task').
                                         addConditionEq('OwnerId', fromUser).
                                         run();
                for (Task acc : tasks) {
                acc.OwnerId = toUser ;
                }
                List<Task> toInsert = tasks;
                update toInsert;
            }
            if(objects == 'Event'){
                List<Event> events = new Query('Event').
                                         addConditionEq('OwnerId', fromUser).
                                         run();
                for (Event acc : events) {
                acc.OwnerId = toUser ;
                }
                List<Event> toInsert = events;
                update toInsert;
            }
            if(objects == 'Opportunity'){
                List<Opportunity> opportunities = new Query('Opportunity').
                                         selectField('Name').
                                         addConditionEq('OwnerId', fromUser).
                                         run();
                for (Opportunity acc : opportunities) {
                acc.OwnerId = toUser ;
                }
                List<Opportunity> toInsert = opportunities;
                update toInsert;
            }
        
        }
        return null;
    }


   /* @AuraEnabled(cacheable=true)
    public static List<Account> getAccount(String fromUser, String toUser){
        try {
             List<Account> result = new Query('Account').
                                         selectField('Name').
                                         addConditionEq('OwnerId', fromUser).
                                         run();
                for (Account acc : result) {
                acc.OwnerId = toUser ;
                }
                List<Account> toInsert = result;
                update toInsert;

                return result;

        } catch (DMLException e) {
            throw new AuraHandledException(e.getMessage());
        }
    }*/

    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOppty(String fromUser) {
        return [SELECT Id, Name FROM Opportunity WHERE OwnerId = :fromUser];
    }
    @AuraEnabled(cacheable=true)
    public static List<Account> getAcc(String fromUser) {
        return [SELECT Id, Name FROM Account WHERE OwnerId = :fromUser];
    }
    @AuraEnabled(cacheable=true)
    public static List<Event> getEven(String fromUser) {
        return [SELECT Id FROM Event WHERE OwnerId = :fromUser];
    }
    @AuraEnabled(cacheable=true)
    public static List<Task> getTask(String fromUser) {
        return [SELECT Id FROM Task WHERE OwnerId = :fromUser];
    }
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContact(String fromUser) {
        return [SELECT Id, Name FROM Contact WHERE OwnerId = :fromUser];
    }
    @AuraEnabled(cacheable=true)
    public static List<Lead> getLead(String fromUser) {
        return [SELECT Id, Name FROM Lead WHERE OwnerId = :fromUser];
    }

    @AuraEnabled
    public static void updateOppty(String fromUser, String toUser, String[] objectsName) {
    
        for(String objects: objectsName ){
            if(objects == 'Opportunity'){
                for (List<Opportunity> oppts:
                    [SELECT Id, Name FROM Opportunity WHERE OwnerId = :fromUser]) {
                        for(Opportunity o : oppts) {
                            o.OwnerId = toUser;
                        }
                        update oppts;
                    }
            }
            if(objects == 'Account'){
                for (List<Account> acc:
                    [SELECT Id, Name FROM Account WHERE OwnerId = :fromUser]) {
                        for(Account a : acc) {
                            a.OwnerId = toUser;
                        }
                        update acc;
                    }
            }
            if(objects == 'Event'){
                for (List<Event> event:
                    [SELECT Id FROM Event WHERE OwnerId = :fromUser]) {
                        for(Event e : event) {
                            e.OwnerId = toUser;
                        }
                        update event;
                    }
            }
            if(objects == 'Task'){
                for (List<Task> task:
                    [SELECT Id FROM Task WHERE OwnerId = :fromUser]) {
                        for(Task t : task) {
                            t.OwnerId = toUser;
                        }
                        update task;
                    }
            }
            if(objects == 'Contact'){
                for (List<Contact> contact:
                    [SELECT Id, Name FROM Contact WHERE OwnerId = :fromUser]) {
                        for(Contact c : contact) {
                            c.OwnerId = toUser;
                        }
                        update contact;
                    }
            }
            if(objects == 'Lead'){
                for (List<Lead> leads:
                    [SELECT Id, Name FROM Lead WHERE OwnerId = :fromUser]) {
                        for(Lead l : leads) {
                            l.OwnerId = toUser;
                        }
                        update leads;
                    }
            }
        }
            return;
    }



}