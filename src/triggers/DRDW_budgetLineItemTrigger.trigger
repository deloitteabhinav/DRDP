trigger DRDW_budgetLineItemTrigger on DRDW_Budget_Line_Item__c (After insert,After Update,Before insert,before delete) {

    DRDW_budgetLineItemTriggerHandler handler = new DRDW_budgetLineItemTriggerHandler();
    
    if(Trigger.isUpdate){
        DRDW_budgetLineItemTriggerHandler.insertBudgetSummary(Trigger.New,Trigger.oldMap);
    }
    
    
    if(Trigger.isInsert && Trigger.isBefore){
        handler.onBeforeInsert(Trigger.new);
    }
    else if(Trigger.isInsert && Trigger.isAfter){
        DRDW_budgetLineItemTriggerHandler.insertBudgetSummary(Trigger.New,Trigger.oldMap);
    }
    if(Trigger.isDelete && Trigger.isBefore){
    DRDW_budgetLineItemTriggerHandler.deleteBudgetSummary(Trigger.old,Trigger.oldMap);
        
    }

}