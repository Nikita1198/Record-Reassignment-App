({  
    onAccountSelectionFrom : function(component, event, helper) {  
         component.set("v.selectedRecordNameFrom", event.getParam('selectedValue'));  
         component.set("v.selectedRecordIdFrom", event.getParam('selectedRecordId'));  
    },

    onAccountSelectionTo : function(component, event) {  
        component.set("v.selectedRecordNameTo", event.getParam('selectedValue'));  
        component.set("v.selectedRecordIdTo", event.getParam('selectedRecordId'));  
   }

}) 