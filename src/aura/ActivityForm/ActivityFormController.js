({
    handleRangeChange : function(component, event, helper) {
        var percent = component.get('v.simpleRecord.Percent_Complete__c');
        if(percent == 100){
            component.set('v.simpleRecord.Status__c','Completed');
            var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
            component.set('v.simpleRecord.End_Date__c',today);
        }
        component.find("recordEditor").saveRecord($A.getCallback(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                console.log("Save completed successfully.");
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                console.log('Problem saving record, error: ' + 
                            JSON.stringify(saveResult.error));
                if (saveResult.state === "ERROR") {
                    var errMsg = "";
                    // saveResult.error is an array of errors, 
                    // so collect all errors into one message
                    for (var i = 0; i < saveResult.error.length; i++) {
                        errMsg += saveResult.error[i].message + "\n";
                    }
                    component.set("v.recordError", errMsg);
                } else {
                    component.set("v.recordError", "");
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: 'sticky',
                    message: component.get("v.recordError"),
                    type : 'error'
                });
                toastEvent.fire();
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        }));
    }
})