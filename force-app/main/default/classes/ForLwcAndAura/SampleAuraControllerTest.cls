@isTest
public class SampleAuraControllerTest {
	
    static testMethod void testfindRecords() {
    
        
        // Insert test Users 
    	Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u1 = new User(Alias = 'fromUser',  FirstName='Sam', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Smit', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='newuserjoni@testorg.com');
         
        User u2 = new User(Alias = 'toUser',FirstName='Jones', Email='newuser@testorg.com',
                           EmailEncodingKey='UTF-8', LastName='Jack', LanguageLocaleKey='en_US',
                           LocaleSidKey='en_US', ProfileId = p.Id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='standarduseriron@testorg.com');
        
        insert u1;
        insert u2;
        
        //User testUserFrom = [SELECT Name from User Where Id =: u1.Id];
        //User testUserTo = [SELECT Name from User Where Id =: u2.Id];
        
        // List of Record type
        List<String> recordType = new List<String>{
            		'Account',
             	   	'Contact',
                	'Lead',
                     'Opportunity',
                        'Case',
                        'Task'};
        List<String> recordTypeNull = new List<String>{
            		'Nothing'};

        //availableValues - Names
        List<String> availableValues = new List<String>();
      
        //Test data
        System.runAs(u1) {
                // The following code runs as user 'u1' 
             List<Account> lstAccount= new List<Account>();
                for(Integer i=0 ;i <10;i++) {
                    Account acc = new Account();
                    acc.Name ='Test Name'+i;
                    lstAccount.add(acc);
                    availableValues.add(acc.Name);
                }
                
                List<Contact> lstContact= new List<Contact>();
                for(Integer i=0 ;i <10;i++) {
                    Contact acc = new Contact();
                    acc.FirstName ='Test Name'+i;
                    acc.LastName ='Test Name'+i;
                    lstContact.add(acc);
                }
                
                List<Lead> lstLead= new List<Lead>();
                for(Integer i=0 ;i <10;i++) {
                    Lead acc = new Lead();
                    acc.FirstName ='Test Name'+i;
                    acc.LastName ='Test Name'+i;
                    acc.Company ='Test Name'+i;
                    lstLead.add(acc);
                }
                
                List<Opportunity> lstOpportunity= new List<Opportunity>();
                for(Integer i=0 ;i <10;i++) {
                    Opportunity acc = new Opportunity();
                    acc.Name ='Test Name'+i;
                    acc.StageName ='Test Name'+i;
                    acc.CloseDate = system.today();
                    lstOpportunity.add(acc);
                }
                
                List<Case> lstCase= new List<Case>();
                for(Integer i=0 ;i <100;i++) {
                    Case acc = new Case();
                    acc.SuppliedName ='Test Name'+i;
                    lstCase.add(acc);
                }
                
                List<Task> lstTask= new List<Task>();
                for(Integer i=0 ;i <10;i++) {
                    Task acc = new Task();
                    lstTask.add(acc);
                }
                
                insert lstAccount;
                insert lstContact;
                insert lstLead;
                insert lstOpportunity;
                insert lstCase;
                insert lstTask;
            
                try{
                    String testId = null;
                    System.assertEquals(recordTypeNull,
                             SampleAuraController.getValues(testId));
                    System.assertEquals(recordType,SampleAuraController.getValues(u1.Id));
                }catch(Exception e) {
                        system.debug('Error');
                    }
            }
        
        
        try {
            for(String obj : recordType) {
                for(String val : availableValues) {
                    System.debug(SampleAuraController.findRecords(val,obj));
                }
            } 
        } catch(Exception e) {
            system.debug('Error');
        }
        
        
        
            System.runAs(u2){
                try{
                    Test.startTest(); 
                SampleAuraController.getPiklistValues(u1.id, u2.id, recordType );
                }catch(Exception e) {
                    system.debug('Error');
                }
            	
            	 
            }

        	Test.stopTest();
                            
        
    }
}