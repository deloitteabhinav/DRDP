trigger DRDW_RequestTrigger on DRDW_Cap_Request__c (before Insert,before Update,before Delete,after Update) {

    DRDW_RequestTriggerHandler handler = new DRDW_RequestTriggerHandler();
    
    if (Trigger.isUpdate && Trigger.isAfter) {
     //   DRDW_Research_TriggerHandler.Checkupdates(Trigger.oldMap, Trigger.newMap, Trigger.new);
    }
    
    if(Trigger.isInsert && Trigger.isBefore){
        handler.UserLookups(Trigger.new);
        System.debug('Inside insert trigger');
        handler.UpdateFinalDatetobeConsidered(Trigger.new);
    }
    else if(Trigger.isInsert && Trigger.isAfter){
        //handler.onAfterInsert(Trigger.new,Trigger.newMap);
    }
    
    if(Trigger.isUpdate && Trigger.isBefore){
    System.debug('Inside update trigger');
        handler.UpdateFinalDatetobeConsidered(Trigger.new);
    }
    
    if(Trigger.isUpdate && Trigger.isAfter){
        system.debug('Inside after update trigger');
        handler.OnAfterUpdate(Trigger.newMap, Trigger.oldMap);
        handler.changePreferedDate(Trigger.newMap, Trigger.oldMap);
        
    }
    
    if(Trigger.isDelete && Trigger.isBefore){
      handler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
    }



}