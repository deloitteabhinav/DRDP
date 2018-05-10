trigger DRDW_ResearchTrigger on DRDW_Project__c (after update, before delete, before insert,After insert,before update) {

    DRDW_Research_TriggerHandler handler = new DRDW_Research_TriggerHandler();
    
    if (Trigger.isUpdate && Trigger.isAfter) {
     //   DRDW_Research_TriggerHandler.Checkupdates(Trigger.oldMap, Trigger.newMap, Trigger.new);
    }
    
   /* if(Trigger.isDelete){
        DRDW_Research_TriggerHandler.Handledelete(Trigger.oldMap,Trigger.old);
    } */
    
    
    if(Trigger.isInsert && Trigger.isBefore){
        handler.onBeforeInsert(Trigger.new);
    }
    else if(Trigger.isInsert && Trigger.isAfter){
        handler.onAfterInsert(Trigger.new,Trigger.newMap);
    }
    
    if(Trigger.isUpdate && Trigger.isBefore){
      handler.OnBeforeUpdate(Trigger.new, Trigger.newMap);
    }
    
    else if(Trigger.isUpdate && Trigger.isAfter){
        handler.OnAfterUpdate(Trigger.new, Trigger.oldMap);
        
    }
    
    if(Trigger.isDelete && Trigger.isBefore){
      handler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
    }

    
    
}