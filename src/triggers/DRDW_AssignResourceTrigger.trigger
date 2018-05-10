trigger DRDW_AssignResourceTrigger on DRDW_Assign_Resource__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
       
    
    if(Trigger.isInsert && Trigger.isBefore){
     //   DRDW_AssignResourceTriggerHandler.onBeforeInsert(Trigger.new);
    }
    else if(Trigger.isInsert && Trigger.isAfter){
        DRDW_AssignResourceTriggerHandler.OnAfterInsert(Trigger.new);
        
    }
    
    else if(Trigger.isUpdate && Trigger.isBefore){
    //  DRDW_AssignResourceTriggerHandler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap);
    }
    else if(Trigger.isUpdate && Trigger.isAfter){
    //    DRDW_AssignResourceTriggerHandler.OnAfterUpdate(Trigger.new, Trigger.oldMap);
        
    }
    
    else if(Trigger.isDelete && Trigger.isBefore){
      DRDW_AssignResourceTriggerHandler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
    }
    else if(Trigger.isDelete && Trigger.isAfter){
     // DRDW_AssignResourceTriggerHandler.OnAfterDelete(Trigger.old, Trigger.oldMap);
        
    }
    
    else if(Trigger.isUnDelete){
    //  DRDW_AssignResourceTriggerHandler.OnUndelete(Trigger.new);    
    }
    
}