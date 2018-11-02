/*
* @author Victor Fuentes Sangabriel <vfuentessangabrie@deloitte.com>
* class TaskWrapper
* @description: used to wrap DRDW_Project & DRDW_Proj_Activity objects
*/
trigger DependencyValidation on DRDW_Proj_Activity__c (before update, before insert, after update, after insert, after delete) {
    
    if(Trigger.isUpdate){
        if(Trigger.isBefore){
            DependencyValidator_TriggerHandler.vaidateDependency(Trigger.New , Trigger.newMap);
        }
        if(Trigger.isAfter){
            DependencyValidator_TriggerHandler.updateAveragePercentage(Trigger.New , Trigger.newMap , Trigger.oldMap);
        }
    }
    
    if(Trigger.isInsert){
        if(Trigger.isAfter){
            DependencyValidator_TriggerHandler.updateAveragePercentage(Trigger.New , Trigger.newMap , null);
        }
    }
    
    if(Trigger.isDelete){
        if(Trigger.isAfter){
            DependencyValidator_TriggerHandler.updateAveragePercentage(Trigger.old , null , Trigger.oldMap);
        }
    }
    
    
}