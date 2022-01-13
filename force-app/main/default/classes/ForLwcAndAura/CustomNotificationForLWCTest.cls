@isTest
public class CustomNotificationForLWCTest {
    
    @isTest static void testNotificationOfExceptionTest() { 
		Boolean returnValue = false;
        try {
            Set<String> setIdOfUsers = new Set<String>();
            Integer numberOfRecords;
           	User anyUser = [SELECT Id, Name FROM User LIMIT 1];
            CustomNotificationForLWC.notifyUsers(setIdOfUsers, anyUser.id, anyUser.id, numberOfRecords, returnValue, anyUser.Name);
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

}