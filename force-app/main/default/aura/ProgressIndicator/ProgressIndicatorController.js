({  
    
    handleNext : function(component,event,helper){
        
        var getselectedStep = component.get("v.selectedStep");
        if(getselectedStep == "step1"){

                    var userFrom = component.get("v.selectedNameUserFrom");
                    var userTo = component.get("v.selectedNameUserTo");

                    if(userFrom =="" || userTo =="" || userFrom == null || userTo == null){

                        component.find('notifLib').showNotice({
                            "variant": "error",
                            "header": " Oops... Something has gone wrong!",
                            "message": "Unfortunately, you have not completed all the fields!",
                        });
                }else if(userFrom === userTo){
                    component.find('notifLib').showNotice({
                        "variant": "error",
                        "header": " Oops... Something has gone wrong!",
                        "message": "You cannot transfer records to the same user! Please select two different users!",
                    });
                }else{                    
                component.set("v.check", "true");
                component.set("v.selectedStep", "step2");
            }
        }
        else if(getselectedStep == "step2"){

                    var options = component.get("v.recordTypes");

                    if(options =="" || options == null || options[0] == 'Nothing'){

                        component.find('notifLib').showNotice({
                            "variant": "error",
                            "header": " Oops... Something has gone wrong!",
                            "message": "Unfortunately, you have to select at least one type of record!",
                        });
                }else{
                    component.set("v.selectedStep", "step3");
            }
            
        }
    },
     
    handlePrev : function(component,event,helper){
        var getselectedStep = component.get("v.selectedStep");
        if(getselectedStep == "step2"){
            component.set("v.selectedStep", "step1");
        }
        else if(getselectedStep == "step3"){
            component.set("v.selectedStep", "step2");
        }
    },
     
    handleFinish : function(component,event,helper){

        var action = component.get("c.getPiklistValues");
        
        action.setParams({ "fromUserId": component.get("v.selectedIdUserFrom"),
                           "toUserId": component.get("v.selectedIdUserTo"),
                         "recordType":  component.get("v.recordTypes")}); 
        action.setCallback(this, function(response) {
        console.log(response);
        var state = response.getState();
            if (state === "SUCCESS"){
                console.log('SUCCESS with state: ' + state);
            }else {
                console.log('Failed with state: ' + state);
            } 
        });
        $A.enqueueAction(action);

        alert('Finished...');
        component.set("v.selectedStep", "step1");
        $A.get('e.force:refreshView').fire();
    },
     

    selectStep1 : function(component,event,helper){
        component.set("v.selectedStep", "step1");
    },
    selectStep2 : function(component,event,helper){
        component.set("v.selectedStep", "step2");
    },
    selectStep3 : function(component,event,helper){
        component.set("v.selectedStep", "step3");
    },
    


    getResult: function(component,event,helper){
        component.set("v.recordTypes", event.getParam("test"));
    },

    getResultFrom : function(component,event,helper){
        component.set("v.selectedNameUserFrom", event.getParam("selectedNameUserFrom"));
        component.set("v.selectedIdUserFrom", event.getParam("selectedIdUserFrom"));
    },

    getResultTo : function(component,event,helper){
        component.set("v.selectedNameUserTo", event.getParam("selectedNameUserTo"));
        component.set("v.selectedIdUserTo", event.getParam("selectedIdUserTo"));
        
    },



})