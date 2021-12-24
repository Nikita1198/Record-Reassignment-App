({
    
    doInit: function(component, event, helper) {
        var action = component.get("c.getValues");
        
        action.setParams({ "fromUserId": event.getParam("selectedIdUserFrom") }); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                var plValues = [];
                for (var i = 0; i < result.length; i++) {
                    plValues.push({
                        label: result[i],
                        value: result[i]
                    });
                }
                component.set("v.options", plValues);
            }
        });
    $A.enqueueAction(action);
    console.log('init MultiSelectList');
    },

    handleChange: function (component, event, helper) {
        //Get the Selected values   
        var selectedOptionsList = event.getParam("value");
        //Update the Selected Values  
        component.set('v.values', selectedOptionsList);
        //alert("Option selected with value: '" + selectedValues.toString() + "'");

        
        var expense =  component.get("v.values");
        var eventObj = $A.get("e.c:ComponentsTest");
        eventObj.setParams({"test" : expense });
        eventObj.fire();
    },

    getResult: function(component,event,helper){
        component.set("v.recordTypes", event.getParam("test"));
    },

    // function automatic called by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        component.set("v.spinner", true); 
    },
     
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);
    },

    
    
})