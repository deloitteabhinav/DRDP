public class DRDW_ActivityTriggerHandler {
    public Static void OnBeforeInsert(List<DRDW_Capability__c> newObjects){
        // EXECUTE BEFORE INSERT LOGIC
        Set<Id> projIds = new Set<Id>();
        Id recordtype = Schema.SObjectType.DRDW_Capability__c.getRecordTypeInfosByName().get('Request Activity').getRecordTypeId();
        for(DRDW_Capability__c c: newObjects){
            if(c.Related_Project__c != NULL && c.Title__c !=NULL && c.RecordTypeID == recordtype){
                c.UniqueProjActTitle__c = c.Related_Project__c + c.Title__c;
                c.Proposed_Start_Date__c = c.Planned_Start_Date__c;
            }
            if(c.Related_Project__c!=null){
                projIds.add(c.Related_Project__c);
            }
        }        
        List<DRDW_Project__c> lProjects = new List<DRDW_Project__c>();
        lProjects = [select id,Business_Unit__c,Name__c from DRDW_Project__c where id in:projIds];        
        Map<Id,String> mapProjectBU = new Map<Id,String>();  
        Map<Id,String> mapProjectName = new Map<Id,String>();     
        for(DRDW_Project__c oProject:lProjects){
            if(oProject.Business_Unit__c!=null){
                mapProjectBU.put(oProject.id,oProject.Business_Unit__c);
            }
            mapProjectName.put(oProject.id,oProject.Name__c);
        }        
        for(DRDW_Capability__c oCap:newObjects){
            if(oCap.Related_Project__c!=null){
                if(mapProjectBU.get(oCap.Related_Project__c)!=null){
                    oCap.Project_Business_Unit__c = mapProjectBU.get(oCap.Related_Project__c);
                    if(mapProjectName.get(oCap.Related_Project__c)!=null){
                        oCap.Related_Project_bck__c = mapProjectName.get(oCap.Related_Project__c);
                    }
                }
            }
        }
    }
    
    public Static void OnAfterInsert(List<DRDW_Capability__c> newObjects){
        // EXECUTE AFTER INSERT LOGIC
        // Request for which event needs to be created.
        Set<Id> reqId = new Set<Id>();
        List<DRDW_Cap_Request__c> lCapReq = new List<DRDW_Cap_Request__c>();
        Map<Id,Id> mReqActivityId = new Map<Id,Id>(); 
        Id studyRecordtype = Schema.SObjectType.DRDW_Capability__c.getRecordTypeInfosByName().get('Study Activity').getRecordTypeId(); 
        Map<String,List<DRDW_Capability__c>> mapOfActivities = DRDW_ActivityERLFlow.getActivities(newObjects);        
        if(mapOfActivities!=null){            
            List<DRDW_Capability__c> erlActivities = mapOfActivities.get('ERL');            
            if(erlActivities!=null){
                try{                
                    List<DRDW_Event__c> lEvents = DRDW_ActivityERLFlow.createERLEvent(erlActivities);                
                }catch(Exception e){                   
                    System.debug('Error'+e);                   
                }                
            }                       
        }
        /*for(DRDW_Capability__c cap : newObjects){
            if(cap.RecordtypeId == studyRecordtype){ 
                reqId.add(cap.DRDW_Request__c);
                mReqActivityId.put(cap.DRDW_Request__c,cap.Id);
            }    
        }    
        //Querying to insert events 
        lCapReq = [select id,recordType.Name,Lab_Testing_Required__c,Samples_to_collect_new__c,Study_Title__c from DRDW_Cap_Request__c where id in : reqId];
        insertEvents(lCapReq,mReqActivityId);   
        system.debug('**lCapReq*'+lCapReq);  
        system.debug('**mReqActivityId*'+mReqActivityId);  */
    }
    
    public Static void OnAfterUpdate(List<DRDW_Capability__c> oldObjects,List<DRDW_Capability__c> updatedObjects,Map<id,DRDW_Capability__c> MapObjectMap){
        // AFTER UPDATE LOGIC                
        Id studyRecordtype = Schema.SObjectType.DRDW_Capability__c.getRecordTypeInfosByName().get('Study Activity').getRecordTypeId();        
        Id requestRecordtype = Schema.SObjectType.DRDW_Capability__c.getRecordTypeInfosByName().get('Request Activity').getRecordTypeId();
        Set<DRDW_Capability__c> actWithUpdatedPrefStartDate = new Set<DRDW_Capability__c>();
        Map<Id,List<DRDW_Capability__c>> reqActivitiesmap = new Map<Id,List<DRDW_Capability__c>>();
        for(DRDW_Capability__c cap:updatedObjects){ 
            // checking for both record types (study and request)
            if(cap.RecordTypeId == requestRecordtype || cap.RecordTypeId == studyRecordtype){
                if(cap.RecordTypeId == requestRecordtype){
                    if(!reqActivitiesmap.containsKey(cap.DRDW_Request__c)){
                        reqActivitiesmap.put(cap.DRDW_Request__c,new List<DRDW_Capability__c>());
                    }
                    reqActivitiesmap.get(cap.DRDW_Request__c).add(cap);   
                }          
                // only if the proposed start date is changed, we should shift the resource allocation
                if(cap.Proposed_Start_Date__c != MapObjectMap.get(cap.id).Proposed_Start_Date__c){
                    actWithUpdatedPrefStartDate.add(cap);
                }      
            }
        }
        //calling the function to shift the assign Resources records
        DRDW_EventDays_Utility.updateAssignedResources(actWithUpdatedPrefStartDate, MapObjectMap);
        //calling the function to shift the eventdays
        DRDW_EventDays_Utility.shiftEventDays(actWithUpdatedPrefStartDate, MapObjectMap);
        List<DRDW_Cap_Request__c> lRequests = new List<DRDW_Cap_Request__c>();
        lRequests = [select id,Status__c,recordtypeid from DRDW_Cap_Request__c where id in:reqActivitiesmap.keySet()];
        for(DRDW_Cap_Request__c r:lRequests){          
            Integer assigned = 0;
            Integer unassigned = 0;
            Integer total = 0;
            if(reqActivitiesmap.get(r.id)!=null){                
                for(DRDW_Capability__c c:reqActivitiesmap.get(r.id)){                    
                    if(c.Status__c == 'Unassigned')
                        unassigned++;                        
                    if(c.Status__c == 'Assigned')
                        assigned++;
                }                
                total = reqActivitiesmap.get(r.id).size();                                                  
                if(unassigned == total){               
                    r.Status__c = 'Unassigned';                    
                }else{
                    r.Status__c = 'Partially Assigned';
                }                   
                if(assigned == total)
                    r.Status__c = 'Assigned';                    
                System.debug('Assigned'+assigned+'Unassigned'+unassigned+'Total'+total);                
            }                                
        }        
        update lRequests;                
    }
    
    public  Static void OnBeforeDelete(List<DRDW_Capability__c> ObjectsToDelete,Map<id,DRDW_Capability__c> MapObjectMap){
        // BEFORE DELETE LOGIC        
        Id recordtype = Schema.SObjectType.DRDW_Capability__c.getRecordTypeInfosByName().get('Request Activity').getRecordTypeId();       
        List<DRDW_Capability__c> lActivities = new List<DRDW_Capability__c>();       
        for(DRDW_Capability__c c:ObjectsToDelete){            
            if(c.RecordTypeId == recordtype){               
                lActivities.add(c);                          
            }            
        }                 
        if(lActivities.size()>0){
            try{
                system.debug('+++++++++++'+lActivities);
                List<DRDW_Budget_Master__c> oBudget = new List<DRDW_Budget_Master__c>();
                oBudget.addAll([Select id from DRDW_Budget_Master__c where Activity__c IN:lActivities]);
                if(!oBudget.isEmpty()){
                    Delete oBudget;
                }
                DRDW_ActivityERLFlow.deleteERLEvent(lActivities);                
            }catch(Exception e){                    
                System.debug('Error'+e);                   
            }   
        }        
    }
    
    /*Public static void insertEvents(List<DRDW_Cap_Request__c> NewCapReqList,Map<Id,Id> mReqActivityId){      
        List<DRDW_Cap_Request__c> oCapreqList =  new List<DRDW_Cap_Request__c>();
        List<DRDW_Event__c> leventInsert = new List<DRDW_Event__c>();
        for(DRDW_Cap_Request__c req : NewCapReqList){           
            if(mReqActivityId.containskey(req.Id) && req.recordType.Name == 'GO' && (req.Lab_Testing_Required__c != NULL || req.Samples_to_collect_new__c != NULL)){
                DRDW_Event__c oevent;
                if(req.Lab_Testing_Required__c != NULL){
                    List<String> lLabTestingReq = req.Lab_Testing_Required__c.split(';');
                    for(String labtestingReq : lLabTestingReq){
                        oevent = new DRDW_Event__c();
                        oevent.Event_Category__c = 'Lab';
                        oevent.Type__c = 'GO';
                        oevent.Study_Title__c = req.Study_Title__c;
                        oevent.Status__c = 'Unassigned';
                        oevent.Event_Type__c = labtestingReq;
                        oevent.DRDW_Activity__c = mReqActivityId.get(req.Id);
                        leventInsert.add(oevent);
                    }
                }
                if(req.Samples_to_collect_new__c != NULL && req.Samples_to_collect_new__c != '[]'){
                    List<String> lSamplesToCollect = req.Samples_to_collect_new__c.replace('[','').replace(']','').split(',');
                    for(String samplestocollect : lSamplesToCollect){
                        oevent = new DRDW_Event__c();
                        oevent.Event_Category__c = 'Sample';
                        oevent.Type__c = 'GO';
                        oevent.Study_Title__c = req.Study_Title__c;
                        oevent.Status__c = 'Unassigned';
                        oevent.Event_Type__c = samplestocollect;
                        oevent.DRDW_Activity__c = mReqActivityId.get(req.Id);
                        leventInsert.add(oevent);
                    }
                }                               
            }           
        }
        if(leventInsert.size() > 0){
            insert leventInsert;
        }
    }*/
}