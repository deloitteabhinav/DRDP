trigger DRDW_ActivityTrigger on DRDW_Capability__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
       
    
    if(Trigger.isInsert && Trigger.isBefore){
        DRDW_ActivityTriggerHandler.onBeforeInsert(Trigger.new);
    }
    else if(Trigger.isInsert && Trigger.isAfter){
        DRDW_ActivityTriggerHandler.OnAfterInsert(Trigger.new);
        
    }
    
    else if(Trigger.isUpdate && Trigger.isBefore){
    //  DRDW_ActivityTriggerHandler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap);
    }
    else if(Trigger.isUpdate && Trigger.isAfter){
        DRDW_ActivityTriggerHandler.OnAfterUpdate(Trigger.old,Trigger.new, Trigger.oldMap);
        
    }
    
    else if(Trigger.isDelete && Trigger.isBefore){
      DRDW_ActivityTriggerHandler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
    }
    else if(Trigger.isDelete && Trigger.isAfter){
     // DRDW_ActivityTriggerHandler.OnAfterDelete(Trigger.old, Trigger.oldMap);
        
    }
    
    else if(Trigger.isUnDelete){
    //  DRDW_ActivityTriggerHandler.OnUndelete(Trigger.new);    
    }
    
}