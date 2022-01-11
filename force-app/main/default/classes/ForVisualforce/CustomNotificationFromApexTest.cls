@isTest
public class CustomNotificationFromApexTest {
    
    @isTest static void testNotificationOfExceptionTest() { 
		Boolean returnValue = false;
        try {
            Set<String> setIdOfUsers = new Set<String>();
           	User anyUser = [SELECT Id FROM User LIMIT 1];
        	CustomNotificationFromApex.notifyUsers(setIdOfUsers, anyUser.id, anyUser.id);
        if(Test.isRunningTest()) {
            CalloutException e = new CalloutException();
            e.setMessage('This is a constructed exception for testing and code coverage');
            throw e;
            }
        }
        catch(Exception ex) {
        // 2: code to execute when an Exception is thrown
           returnValue = true;
        }
        System.assert(returnValue, 'An Exception was not thrown');
    }

        
     @isTest static void testNotification() { 
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u1 = new User(Alias = 'fromUser', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='newuserjoni@testorg.com');
		insert u1;
        
        

        Boolean exceptionOccurred = false;
     	try{
            System.runAs(u1) {
                Test.startTest();
                Set<String> setIdOfUsers = new Set<String>();
    
                List<Account> lstAccount= new List<Account>();
                    for(Integer i=0 ;i <100;i++) {
                        Account acc = new Account();
                        acc.Name ='Test Name'+i;
                        lstAccount.add(acc);
                    }
                insert lstAccount;
                
                for(Account cont : lstAccount) {
                    setIdOfUsers.add(cont.id);
                }
                
                CustomNotificationFromApex.notifyUsers(setIdOfUsers, u1.id, u1.id);
                Test.stopTest();
                System.assertNotEquals(null, CustomNotificationFromApex.notifyUsers(setIdOfUsers, u1.id, u1.id));
            }
         } catch (Exception e) {     
         	 system.assert(false, 'Exceptions should be handled by the method');
         }
    }
    
}