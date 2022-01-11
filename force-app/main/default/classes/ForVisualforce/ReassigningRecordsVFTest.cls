@IsTest
public class ReassigningRecordsVFTest {
 
 	static testMethod void testMethod1() {
        
        // Setup test Users
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u1 = new User(Alias = 'fromUser', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='newuserjoni@testorg.com');
        
        User u2 = new User(Alias = 'toUser', Email='newuser@testorg.com',
                           EmailEncodingKey='UTF-8', LastName='Testing_2', LanguageLocaleKey='en_US',
                           LocaleSidKey='en_US', ProfileId = p.Id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='standarduseriron@testorg.com');
 
        List<String> listObj = new List<String>{
            		'Account',
             	   	'Contact',
                	'Lead',
                     'Opportunity',
                       'Case',
                        'Task'};

		System.runAs(u1) {
            // The following code runs as user 'u' 
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
            System.debug('Current id: ' + u1.id);


                            
        List<Account> lstAccount= new List<Account>();
        for(Integer i=0 ;i <100;i++) {
            Account acc = new Account();
            acc.Name ='Test Name'+i;
            lstAccount.add(acc);
        }
        
        List<Contact> lstContact= new List<Contact>();
        for(Integer i=0 ;i <100;i++) {
            Contact acc = new Contact();
            acc.FirstName ='Test Name'+i;
            acc.LastName ='Test Name'+i;
            lstContact.add(acc);
        }
        
        List<Lead> lstLead= new List<Lead>();
        for(Integer i=0 ;i <100;i++) {
            Lead acc = new Lead();
            acc.FirstName ='Test Name'+i;
            acc.LastName ='Test Name'+i;
            acc.Company ='Test Name'+i;
            lstLead.add(acc);
        }
        
        List<Opportunity> lstOpportunity= new List<Opportunity>();
        for(Integer i=0 ;i <100;i++) {
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
        for(Integer i=0 ;i <100;i++) {
            Task acc = new Task();
            lstTask.add(acc);
        }
        
        insert lstAccount;
        insert lstContact;
        insert lstLead;
        insert lstOpportunity;
        insert lstCase;
        insert lstTask;
        }

        System.runAs(u2){
            
        Test.startTest();
    
        
            for(String objects : listObj){
                ReassigningRecordsVF obj = new ReassigningRecordsVF();
         
                obj.query = 'SELECT Id FROM ' + objects +
                    ' WHERE OwnerId = \'' + u1.Id +'\'';
                obj.entity = objects;
                obj.field = 'OwnerId'; 
                obj.value = u2.Id;
                obj.fromUserId = u1.Id;
            
                DataBase.executeBatch(obj); 
        	} 
        }
        Test.stopTest();
    }
}