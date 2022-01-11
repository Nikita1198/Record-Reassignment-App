public without sharing class CustomNotificationFromApex {

    public static Boolean notifyUsers(Set<String> recipientsIds, String targetId, String nameOfObject) {

        // Variable for test
        Boolean key;

        // Get the Id for our custom notification type
        CustomNotificationType notificationType = 
            [SELECT Id, DeveloperName 
             FROM CustomNotificationType 
             WHERE DeveloperName='Developer_notification'];
        
        // Create a new custom notification
        Messaging.CustomNotification notification = new Messaging.CustomNotification();

        // Set the contents for the notification
        notification.setTitle('Record Reassignment app');
        notification.setBody('Congratulations! ' + nameOfObject +' have been reassigned!');

        // Set the notification type and target
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId(targetId);
        
        // Actually send the notification
        try {
            notification.send(recipientsIds);
            System.debug(notification);
        }
        catch (Exception e) {
            key = false;
            System.debug('Problem sending notification: ' + e.getMessage());
        }
        return key;
    }
}