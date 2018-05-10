trigger DRDW_Event_Days_Trigger on DRDW_Event_Days__c (after update,before delete) {
    if(Trigger.isAfter && Trigger.isUpdate){
        // calling the triger handler to update the corresponding calender raster records
        DRDW_Event_Days_TriggerHandler.updateCalenderRoaster(Trigger.new, Trigger.oldMap);
    }
    
    if(Trigger.isBefore && Trigger.isDelete){
        // calling the triger handler to update the corresponding calender raster records
        DRDW_Event_Days_TriggerHandler.deleteCalenderRoaster(Trigger.oldMap);
    }
}