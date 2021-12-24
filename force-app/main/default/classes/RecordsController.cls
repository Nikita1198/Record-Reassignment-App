global class RecordsController {

    public Boolean FirstBlock{get;set;}
    public Boolean SecondBlock{get;set;}
    public Boolean ThirdBlock{get;set;}

    global User fromUser{get; set;}
    public User toUser{get; set;}
    global Order__c order {get; set;}

   // private ApexPages.StandardSetController controller;
    //private PageReference savePage;
    private Set<String> unSelectedNames = new Set<String>();
    public Set<String> selectedNames = new Set<String>();
    private Set<String> finall = new Set<String>();
    
    public List<String> selected { get; set; }
    public List<String> unselected { get; set; }

    public String fieldAPIName {get; set;}

    private List<String> countRecords = new List<String>();

    public RecordsController()
    {
        fromUser = new User();
        toUser = new User();
        order = new Order__c();
        FirstBlock = true;
        SecondBlock = false;
        ThirdBlock = false;
        
    }

    public void searchUsers(){  
        try {
            fromUser = [select Id
                            ,Name 
                            ,IsActive
                            ,Email  
                            from User 
                        where Name LIKE :order.fromUserName__c
                        LIMIT 1];
            toUser = [select Id
                        ,Name 
                        ,IsActive 
                        ,Email   
                        from User 
                    where Name LIKE :order.toUserName__c
                    LIMIT 1];
            order.fromUserId__c = fromUser.Id;
            order.toUserId__c = toUser.Id;

            if(order.fromUserId__c == fromUser.Id && order.toUserId__c == toUser.Id){

                Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
                List<String> typeOfObject = new List<String>();

                List<Schema.SObjectType> objNames = gd.values();
                for (Schema.SObjectType cr : objNames) {
                    String relName = cr.getDescribe().getName();
                    
                    if (relName != null){
                        Map<String, Schema.SObjectField> fieldMap = gd.get(relName).getDescribe().fields.getMap();
                            for(Schema.SObjectField sfield : fieldMap.Values()){
                                Schema.Describefieldresult dfield = sfield.getDescribe();

                                fieldAPIName = dfield.getname();

                                if(fieldAPIName == 'OwnerId' && dfield.isUpdateable() == true && dfield.isAccessible() == true){
                                    //options.add(new SelectOption(relName, relName)); 
                                    typeOfObject.add(relName);
                                }
                            }
                        }
                    }
                
                for(String ty : typeOfObject){
                    String query = 'select Id'+' From '+ty+' WHERE OwnerId = \'' + order.fromUserId__c+'\'';
                    List<sObject> recordList = Database.query(query);

                    if(recordList!=null && !recordList.isEmpty()){
                        unselectedNames.add(ty);
                    }
                }
                
                
            }

        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error! Check that the user names you entered are correct. One of the user names is entered wrong!'));
        }
        SecondBlock = true;
        FirstBlock = false;
    }

    public void backFirstPage() {
        FirstBlock = true;
        SecondBlock = false;
     }

    public void backSecond() {
        ThirdBlock = false;
        SecondBlock = true;
    }

    public void next() {
        if(selectedOptions==null || selectedOptions.isEmpty() || selectedNames==null || selectedNames.isEmpty()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error! You must select at least one record type object from the list!'));
        }else if(selectedOptions!=null || !selectedOptions.isEmpty() || selectedNames!=null || !selectedNames.isEmpty()){
            ThirdBlock = true;
            SecondBlock = false;
        }
    }

   /* 
    private final User use; //User sobject
	
	//initializes the private member variable u by using the getRecord method from the standard controller
	public RecordsController(ApexPages.StandardController stdController) {
		this.use = (User)stdController.getRecord();
	}
	
	//builds a picklist of user names based on their profile
	public List<selectOption> getMgrs() {
		List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
		options.add(new selectOption('', '- None -')); //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below
		for (User users : [SELECT Id, Name FROM User Where IsActive = true ]) { //query for User records with IsActive
			options.add(new selectOption(users.Id, users.Name)); //for all records found - add them to the picklist options
		}
		return options; //return the picklist options
	}*/
 

    public List<SelectOption> selectedOptions { 
        get {
            List<SelectOption> options = new List<SelectOption>();
            List<String> sorted = new List<String>(selectedNames);
            sorted.sort();
            
            for (String s: sorted) {
                options.add(new SelectOption(s, s));
            }
            return options;
            
        }
    }


    public List<SelectOption> unSelectedOptions { 
        get {
            List<SelectOption> options = new List<SelectOption>();
            
            for(String fin : unselectedNames){
                options.add(new SelectOption(fin, fin));
            }
            options.sort();
            return options;
        }
    }


    public void doSelect() {
        for (String s: selected) {
            selectedNames.add(s);
            unselectedNames.remove(s);
        }
    }

    public void doUnSelect() {
        for (String s: unselected) {
            unSelectedNames.add(s);
            selectedNames.remove(s);
        }
    }


    public PageReference confirm(){
        try{
            List<String> setObjects = new List<String>();
            for(SelectOption sel : selectedOptions){
                setObjects.add(sel.getValue());

                ReassigningRecords reassign  = new ReassigningRecords();

                reassign.query = 'SELECT Id ' + 
                            ' From '+ sel.getValue() +
                            ' WHERE OwnerId = \'' + order.fromUserId__c +'\'';
                reassign.entity = sel.getValue();
                reassign.field = 'OwnerId';
                reassign.value = order.toUserId__c;
                reassign.fromUserId = order.fromUserId__c;


                Id batchInstanceId = Database.executeBatch(reassign);
            }
            //ReassigningRecords.ReassigningRecords(order.fromUserId__c, order.toUserId__c, setObjects);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            mail.setToAddresses(new String[] {fromUser.email, toUser.email });
            mail.setReplyTo('batch@acme.com');
            mail.setSenderDisplayName('App notification');
            mail.setSubject('Record Reassignment app');
            mail.setPlainTextBody('From user ' + fromUser.Name + ' to user ' + toUser.Name + ', this types of records were reassigned: '+ setObjects +'.');

            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
        }catch(DMLException e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error!'));
        }
        

        PageReference pageRef = new PageReference('https://mindful-moose-jialmd-dev-ed.lightning.force.com/lightning/page/home');
        return pageRef;
    }



    



}