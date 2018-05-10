trigger DRDW_BudgetMasterTrigger on DRDW_Budget_Master__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    
    DRDW_BudgetMasterTriggerHandler handler = new DRDW_BudgetMasterTriggerHandler();
    
    if(Trigger.isInsert && Trigger.isBefore){
        handler.onBeforeInsert(Trigger.new);
    }
    else if(Trigger.isInsert && Trigger.isAfter){
        handler.OnAfterInsert(Trigger.new);
        
    }
    
    else if(Trigger.isUpdate && Trigger.isBefore){
    //  handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap);
    }
    else if(Trigger.isUpdate && Trigger.isAfter){
        handler.OnAfterUpdate(Trigger.new, Trigger.oldMap);
        
    }
    
    else if(Trigger.isDelete && Trigger.isBefore){
      handler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
    }
    else if(Trigger.isDelete && Trigger.isAfter){
     // handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
        
    }
    
    else if(Trigger.isUnDelete){
    //  handler.OnUndelete(Trigger.new);    
    }
}