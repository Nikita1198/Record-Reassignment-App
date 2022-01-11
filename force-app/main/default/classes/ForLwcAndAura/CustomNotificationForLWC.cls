public without sharing class CustomNotificationForLWC {

    public static void notifyUsers(Set<String> recipientsIds, String targetId, String nameOfObject, Integer numberOfRecords, Boolean key, String userName) {
        
        // Get the Id for our custom notification type
        CustomNotificationType notificationType = 
            [SELECT Id, DeveloperName 
             FROM CustomNotificationType 
             WHERE DeveloperName='Developer_notification'];
        
        // Create a new custom notification
        Messaging.CustomNotification notification = new Messaging.CustomNotification();

        // Set the contents for the notification
        notification.setTitle('Record Reassignment app');
        if(key == true){
            notification.setBody('Congratulations! ' + numberOfRecords +' '+ nameOfObject +' type records have been reassigned!');
        }
        if(key == false){
            notification.setBody('Sorry! But there are no records in the ' + nameOfObject +' where owner is '+ userName + '.');
        }

        // Set the notification type and target!
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId(targetId);
        
        // Actually send the notification
        try {
            notification.send(recipientsIds);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
    }
}