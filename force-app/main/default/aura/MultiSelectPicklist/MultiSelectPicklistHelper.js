({
    helperGet : function(component, event) {
        component.set("v.selectedId", event.getParam("selectedIdUserFrom"));
    },
        
    performShowingLoggedInUserDetails : function(component, event) {
        //component.set("v.selectedId", event.getParam("selectedIdUserFrom"));

        var action = component.get("c.getValues");

        action.setParams({ "fromUserId": component.get("v.selectedId") }); 
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
                
            }else {
                console.log('Failed with state: ' + state);
            } 
        });
        $A.enqueueAction(action);
    },

    

})
