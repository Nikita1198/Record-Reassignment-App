({
    helperMethodTo :  function(component) {
        var selectedName = component.get("v.selectedRecordNameTo");
        var selectedId = component.get("v.selectedRecordIdTo");
        var eventObj = $A.get("e.c:ComponentsForUsersTo");
        eventObj.setParams({"selectedNameUserTo": selectedName ,
                           "selectedIdUserTo" : selectedId});
        eventObj.fire();
    },

    helperMethodFrom :  function(component) {
        var selectedName = component.get("v.selectedRecordNameFrom");
         var selectedId = component.get("v.selectedRecordIdFrom");
         var eventObj = $A.get("e.c:ComponentsForUsers");
         eventObj.setParams({"selectedNameUserFrom": selectedName ,
                            "selectedIdUserFrom" : selectedId});
         eventObj.fire();
    }
})
