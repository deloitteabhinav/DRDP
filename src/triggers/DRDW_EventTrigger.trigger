trigger DRDW_EventTrigger on DRDW_Event__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
       
    
    if(Trigger.isInsert && Trigger.isBefore){
         DRDW_EventTriggerHandler.OnBeforeInsert(Trigger.new);
    }
    else if(Trigger.isInsert && Trigger.isAfter){
      
        
    }
    
    else if(Trigger.isUpdate && Trigger.isBefore){
        DRDW_EventTriggerHandler.OnBeforeUpdate(Trigger.old,Trigger.new,Trigger.oldMap);
    }
    else if(Trigger.isUpdate && Trigger.isAfter){
        DRDW_EventTriggerHandler.OnAfterUpdate(Trigger.newMap,Trigger.oldMap); 
    }
    
    else if(Trigger.isDelete && Trigger.isBefore){
       DRDW_EventTriggerHandler.OnBeforeDelete(Trigger.old,Trigger.oldMap);
    }
    else if(Trigger.isDelete && Trigger.isAfter){       
    }
    
    else if(Trigger.isUnDelete){
   
    }
    
}