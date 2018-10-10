/*
* @author Victor Fuentes Sangabriel <vfuentessangabrie@deloitte.com>
* class TaskWrapper
* @description: used to wrap DRDW_Project & DRDW_Proj_Activity objects
*/
trigger DependencyValidation on DRDW_Proj_Activity__c (before update) {
    // IMPORTANT! Iterate over Trigg.new because doing a soql query will NOT allow us to see the updated records with status = completed
    // since the records have not yet been committed to the DB
    /*  
Set<Id> potentiallyProblematicRecords = new Set<Id>();

// We are only interested in records that now have their status set to complete
for(DRDW_Proj_Activity__c newRec : Trigger.new){
if(newRec.Status__c == 'Completed') potentiallyProblematicRecords.add(newRec.id);
}

List<Related_Capability_Activity__c> dependencies = [SELECT Id, 
Capability_Activity__c,
Dependent_Capability_Activity__r.Status__c,
Dependent_Capability_Activity__r.Name
FROM Related_Capability_Activity__c 
WHERE Capability_Activity__c IN: potentiallyProblematicRecords
AND Dependent_Capability_Activity__r.Status__c != 'Completed'];


for(Related_Capability_Activity__c dependency : dependencies){
if(Trigger.newMap.get(dependency.Capability_Activity__c) != null){
Trigger.newMap.get(dependency.Capability_Activity__c).addError('Cannot change status to completed because dependent activity '+dependency.Dependent_Capability_Activity__r.Name+' has not been completed yet');
}
} */
    
    List<Related_Capability_Activity__c> dependencies = new List<Related_Capability_Activity__c>();
    
    dependencies = [SELECT Id,Dependency_Type__c, 
                    Capability_Activity__c,
                    Capability_Activity__r.Name,
                    Capability_Activity__r.Status__c,
                    Dependent_Capability_Activity__r.Status__c,
                    Dependent_Capability_Activity__r.Name
                    FROM Related_Capability_Activity__c 
                    WHERE Dependent_Capability_Activity__c in :Trigger.new];
    
    Map<ID,String> errorMap = new Map<ID,String>();                                                 
    for(Related_Capability_Activity__c oRelated:dependencies){
        
        if(oRelated.Dependency_Type__c=='Finish to start (FS)'){
            if(oRelated.Capability_Activity__r.Status__c!='Completed' && (Trigger.newMap.get(oRelated.Dependent_Capability_Activity__c).Status__c =='On-going' || Trigger.newMap.get(oRelated.Dependent_Capability_Activity__c).Status__c =='Completed') ){
                if(!errorMap.containsKey(oRelated.Dependent_Capability_Activity__c)){
                    errorMap.put(oRelated.Dependent_Capability_Activity__c,'');
                }
                String er = errorMap.get(oRelated.Dependent_Capability_Activity__c);
                er = er + 'Cannot change status because of dependency type ( Finish to start (FS)) for dependent Activity '+oRelated.Capability_Activity__r.Name+' has not been completed yet \n';
                errorMap.put(oRelated.Dependent_Capability_Activity__c, er);
            }
        }else if(oRelated.Dependency_Type__c=='Finish to finish (FF)'){
            
            if(oRelated.Capability_Activity__r.Status__c!='Completed' && (Trigger.newMap.get(oRelated.Dependent_Capability_Activity__c).Status__c =='Completed') ){
                if(!errorMap.containsKey(oRelated.Dependent_Capability_Activity__c)){
                    errorMap.put(oRelated.Dependent_Capability_Activity__c,'');
                }
                String er = errorMap.get(oRelated.Dependent_Capability_Activity__c);
                er = er + 'Cannot change status because of dependency type ( Finish to finish (FF)) for dependent Activity '+oRelated.Capability_Activity__r.Name+' has not been completed yet \n';
                errorMap.put(oRelated.Dependent_Capability_Activity__c, er);
            }
            
        }else if(oRelated.Dependency_Type__c=='Start to start (SS)'){
            
            if((oRelated.Capability_Activity__r.Status__c!='On-going' && oRelated.Capability_Activity__r.Status__c!='Completed') && (Trigger.newMap.get(oRelated.Dependent_Capability_Activity__c).Status__c =='On-going' || Trigger.newMap.get(oRelated.Dependent_Capability_Activity__c).Status__c =='Completed')){
                if(!errorMap.containsKey(oRelated.Dependent_Capability_Activity__c)){
                    errorMap.put(oRelated.Dependent_Capability_Activity__c,'');
                }
                String er = errorMap.get(oRelated.Dependent_Capability_Activity__c);
                er = er + 'Cannot change status because of dependency type ( Start to start (SS)) for dependent Activity '+oRelated.Capability_Activity__r.Name+' has not been Started yet \n';
                errorMap.put(oRelated.Dependent_Capability_Activity__c, er);
            }
            
        }else if(oRelated.Dependency_Type__c=='Start to finish (SF)'){
            
            if((oRelated.Capability_Activity__r.Status__c!='On-going' && oRelated.Capability_Activity__r.Status__c!='Completed') && (Trigger.newMap.get(oRelated.Dependent_Capability_Activity__c).Status__c =='Completed')){
                if(!errorMap.containsKey(oRelated.Dependent_Capability_Activity__c)){
                    errorMap.put(oRelated.Dependent_Capability_Activity__c,'');
                }
                String er = errorMap.get(oRelated.Dependent_Capability_Activity__c);
                er = er + 'Cannot change status because of dependency type ( Start to finish (SF)) for dependent Activity '+oRelated.Capability_Activity__r.Name+' has not been Started yet \n';
                errorMap.put(oRelated.Dependent_Capability_Activity__c, er);
            }
            
        }
        
    }   
    
    for(DRDW_Proj_Activity__c act:Trigger.New){
        
        if(errorMap.containsKey(act.Id)){
            Trigger.newMap.get(act.Id).addError(errorMap.get(act.Id));
        }
        
    }
    
}