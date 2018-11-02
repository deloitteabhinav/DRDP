Public class DependencyValidator_TriggerHandler{

    public Static void vaidateDependency(List<DRDW_Proj_Activity__c> newList, Map<Id,DRDW_Proj_Activity__c> newMap){
        List<Related_Capability_Activity__c> dependencies = new List<Related_Capability_Activity__c>();
    
    dependencies = [SELECT Id,Dependency_Type__c, 
                    Capability_Activity__c,
                    Capability_Activity__r.Name,
                    Capability_Activity__r.Status__c,
                    Dependent_Capability_Activity__r.Status__c,
                    Dependent_Capability_Activity__r.Name
                    FROM Related_Capability_Activity__c 
                    WHERE Dependent_Capability_Activity__c in :newList];
    
    Map<ID,String> errorMap = new Map<ID,String>();                                                 
    for(Related_Capability_Activity__c oRelated:dependencies){
        
        if(oRelated.Dependency_Type__c=='Finish to start (FS)'){
            if(oRelated.Capability_Activity__r.Status__c!='Completed' && (newMap.get(oRelated.Dependent_Capability_Activity__c).Status__c =='On-going' || newMap.get(oRelated.Dependent_Capability_Activity__c).Status__c =='Completed') ){
                if(!errorMap.containsKey(oRelated.Dependent_Capability_Activity__c)){
                    errorMap.put(oRelated.Dependent_Capability_Activity__c,'');
                }
                String er = errorMap.get(oRelated.Dependent_Capability_Activity__c);
                er = er + 'Cannot change status because of dependency type ( Finish to start (FS)) for dependent Activity '+oRelated.Capability_Activity__r.Name+' has not been completed yet \n';
                errorMap.put(oRelated.Dependent_Capability_Activity__c, er);
            }
        }else if(oRelated.Dependency_Type__c=='Finish to finish (FF)'){
            
            if(oRelated.Capability_Activity__r.Status__c!='Completed' && (newMap.get(oRelated.Dependent_Capability_Activity__c).Status__c =='Completed') ){
                if(!errorMap.containsKey(oRelated.Dependent_Capability_Activity__c)){
                    errorMap.put(oRelated.Dependent_Capability_Activity__c,'');
                }
                String er = errorMap.get(oRelated.Dependent_Capability_Activity__c);
                er = er + 'Cannot change status because of dependency type ( Finish to finish (FF)) for dependent Activity '+oRelated.Capability_Activity__r.Name+' has not been completed yet \n';
                errorMap.put(oRelated.Dependent_Capability_Activity__c, er);
            }
            
        }else if(oRelated.Dependency_Type__c=='Start to start (SS)'){
            
            if((oRelated.Capability_Activity__r.Status__c!='On-going' && oRelated.Capability_Activity__r.Status__c!='Completed') && (newMap.get(oRelated.Dependent_Capability_Activity__c).Status__c =='On-going' || newMap.get(oRelated.Dependent_Capability_Activity__c).Status__c =='Completed')){
                if(!errorMap.containsKey(oRelated.Dependent_Capability_Activity__c)){
                    errorMap.put(oRelated.Dependent_Capability_Activity__c,'');
                }
                String er = errorMap.get(oRelated.Dependent_Capability_Activity__c);
                er = er + 'Cannot change status because of dependency type ( Start to start (SS)) for dependent Activity '+oRelated.Capability_Activity__r.Name+' has not been Started yet \n';
                errorMap.put(oRelated.Dependent_Capability_Activity__c, er);
            }
            
        }else if(oRelated.Dependency_Type__c=='Start to finish (SF)'){
            
            if((oRelated.Capability_Activity__r.Status__c!='On-going' && oRelated.Capability_Activity__r.Status__c!='Completed') && (newMap.get(oRelated.Dependent_Capability_Activity__c).Status__c =='Completed')){
                if(!errorMap.containsKey(oRelated.Dependent_Capability_Activity__c)){
                    errorMap.put(oRelated.Dependent_Capability_Activity__c,'');
                }
                String er = errorMap.get(oRelated.Dependent_Capability_Activity__c);
                er = er + 'Cannot change status because of dependency type ( Start to finish (SF)) for dependent Activity '+oRelated.Capability_Activity__r.Name+' has not been Started yet \n';
                errorMap.put(oRelated.Dependent_Capability_Activity__c, er);
            }
            
        }
        
    }   
    
    for(DRDW_Proj_Activity__c act:newList){
        
        if(errorMap.containsKey(act.Id)){
            newMap.get(act.Id).addError(errorMap.get(act.Id));
        }
        
    }
    }
    
    public static void updateAveragePercentage(List<DRDW_Proj_Activity__c> newList , Map<Id,DRDW_Proj_Activity__c> newMap , Map<Id,DRDW_Proj_Activity__c> oldMap){
        set<Id> sParentActivityId = new set<Id>();
        List<DRDW_Project__c> lProjToBeUpdated = new List<DRDW_Project__c>();
        if(Trigger.isUpdate){
            for(DRDW_Proj_Activity__c oPA : newList){
                if(oldMap.get(oPA.Id).Percent_Complete__c != oPA.Percent_Complete__c)
                sParentActivityId.add(oPA.Parent_Project__c);
            }
        }
        
        if(Trigger.isInsert || Trigger.isDelete){
            for(DRDW_Proj_Activity__c oPA : newList){
                sParentActivityId.add(oPA.Parent_Project__c);
            }
        }
        
        if(!sParentActivityId.isEmpty()){
            for(DRDW_Project__c oProject : [select id,DRDW_Progress_Complete__c,(select id,Percent_Complete__c from Proj_Activities__r) from DRDW_Project__c where id IN: sParentActivityId]){
                Decimal percent = 0;
                for(DRDW_Proj_Activity__c oPA : oProject.Proj_Activities__r){
                    if(oPA.Percent_Complete__c != null)
                        percent += oPA.Percent_Complete__c;
                    else
                       percent += 0; 
                }
                if(oProject.Proj_Activities__r.size()>0){
                    percent = percent/oProject.Proj_Activities__r.size();
                    oProject.DRDW_Progress_Complete__c = percent;
                    sParentActivityId.remove(oProject.Id);
                    lProjToBeUpdated.add(oProject);
                }
            }
        }
        if(!sParentActivityId.isEmpty()){
            for(Id oProjId : sParentActivityId){
                DRDW_Project__c newProject = new DRDW_Project__c(Id = oProjId , DRDW_Progress_Complete__c = 0);
                lProjToBeUpdated.add(newProject);
            }
        }
        if(lProjToBeUpdated.size()>0){
            update lProjToBeUpdated;
        }
    }
}