@isTest
public class CustomNotificationForLWCTest {
    
	@isTest static void testNotification() {
        CustomNotificationForLWC notification = new CustomNotificationForLWC();
        
        
    }
    
    @isTest static void testNotificationOfException() {
        
        Set<String> recipientsIds = null;
        String targetId = null;
        String nameOfObject = null;
        Integer numberOfRecords = null;
        Boolean key;
        String userName = null; 
        
        try {
            CustomNotificationForLWC.notifyUsers(recipientsIds, targetId, nameOfObject, numberOfRecords, key, userName);
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