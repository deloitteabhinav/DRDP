/*
 * @author Victor Fuentes Sangabriel <vfuentessangabrie@deloitte.com>
 * class TaskWrapper
 * @description: used to wrap DRDW_Project & DRDW_Proj_Activity objects
 */
trigger DependencyValidation on DRDW_Proj_Activity__c (before update) {
    // IMPORTANT! Iterate over Trigg.new because doing a soql query will NOT allow us to see the updated records with status = completed
    // since the records have not yet been committed to the DB
	
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
    }
}