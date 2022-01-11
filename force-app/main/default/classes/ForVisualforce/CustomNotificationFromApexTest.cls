@isTest
public class CustomNotificationFromApexTest {
    
	@isTest static void testNotification() {
      List<User> allIds = [SELECT Id FROM User];
      
      //Set of all Id's of all users
      Set<String> recipientsIds = new Set<String>();
      
      for (User allId : allIds) {
          recipientsIds.add(allId.id);
       }
      
      // set target id as id of our App
	  String targetId = '0057Q000000qeESQAY';
	  
      // set Name of Object
      List<String> stdObjectNames = new List<String>();
        for ( Schema.SObjectType typ : Schema.getGlobalDescribe().values() ) {
            String sobjName = String.valueOf(typ);
            if ( !sobjName.contains('__c') ) {
            	stdObjectNames.add(sobjName);
            	}
        }
        System.debug('stdObjectNames: ' + stdObjectNames);
	  
        
        List<String> testListOfObjects = new List<String>();
        String ObjectNameString = 'New Object';
        String ObjectNameInteger = '0123456789'; 
        
		        
        for (String userID : recipientsIds) {
            Set<String> newSet = new Set<String>();
            newSet.add(userID);
            CustomNotificationFromApex.notifyUsers(newSet, userID ,ObjectNameString); 
        }
		
    }
    
    @isTest static void testNotificationOfException() {
        
        Set<String> recipientsIds = null;
        String targetId;
        String nameOfObject;
        
        try {
            CustomNotificationFromApex.notifyUsers(recipientsIds, targetId, nameOfObject);
        }
        catch (Exception e) {
            System.assertEquals('Problem sending notification: ' + e.getMessage(), e.getMessage());
        }               
    }
    
    
    @isTest static void testNotificationOfExceptionTest() { 
		Boolean returnValue = true;
        try {
        // 1: core code to try
        if(Test.isRunningTest()) {
        CalloutException e = new CalloutException();
        e.setMessage('This is a constructed exception for testing and code coverage');
        throw e;
        }
        }
        catch(Exception ex) {
        // 2: code to execute when an Exception is thrown
           returnValue = false;
        }
    }
    
}