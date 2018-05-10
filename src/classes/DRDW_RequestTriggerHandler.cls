/****************************************************************************************************************************************** 
 * Class Name   : DRDW_RequestTriggerHandler 
 * Description  : Class to perform operations on Request
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
public class DRDW_RequestTriggerHandler {
    
    /*Public List<DRDW_Event__c> leventInsertFinal;
    Public List<DRDW_Event__c> leventDeleteFinal; 
    Public Map<Id,Id> mReqActivityId;*/

// Update user lookup values on Request once created
    Public void UserLookups(List<DRDW_Cap_Request__c> NewCapReqList){

      Set<ID> PrjIds = new Set<ID>();
    
      for(DRDW_Cap_Request__c oCapreq : NewCapReqList){
      PrjIds.add(oCapreq.Project__c);          
      }

      List<DRDW_Project__c> lstprjs = [Select Id, Name, RP_Project_Manager__c,Research_Project_Lead__c from DRDW_Project__c Where Id =: PrjIds];

      for(DRDW_Cap_Request__c oCapreq : NewCapReqList){
        for(DRDW_Project__c oPrj : lstprjs){
            if(oCapreq.Project__c == oPrj.Id){

              if(oPrj.RP_Project_Manager__c != null){
                      System.debug('Inside PM'+oPrj.RP_Project_Manager__c);
                        oCapreq.Project_PM__c = oPrj.RP_Project_Manager__c;

              }
              if(oPrj.Research_Project_Lead__c != null){
                      System.debug('Inside RPL'+oPrj.Research_Project_Lead__c);
                        oCapreq.Project_RPL__c = oPrj.Research_Project_Lead__c;

              }

            }
        }
      }
        
    }

     Public void UpdateReqActivity(List<DRDW_Cap_Request__c> NewCapReqList){
         id recordTypeId = Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('GO').getRecordTypeId();
         Map<id,List<DRDW_Cap_Request__c>> mReqActivity = new Map<id,List<DRDW_Cap_Request__c>>();
         List<DRDW_Capability__c> lcap = new list<DRDW_Capability__c>([select Title__c,Related_Project__c,DRDW_Request__c,Capability__c,Capability_Area__c,Actual_End_Date__c,Actual_Start_Date__c,Planned_End_Date__c,Planned_Start_Date__c from DRDW_Capability__c where DRDW_Request__c IN:NewCapReqList]);
         
         For(DRDW_Cap_Request__c req : NewCapReqList){
            if(mReqActivity.ContainsKey(req.Id)){
                mReqActivity.get(req.Id).add(req);
            }else{
                mReqActivity.put(req.Id,new List<DRDW_Cap_Request__c>{req});
            }
         }
         
         for(DRDW_Capability__c c : lcap){
             
         }
     }
     
     Public void OnBeforeDelete(List<DRDW_Cap_Request__c> NewCapReqList,Map<id,DRDW_Cap_Request__c> oldMap){
         List<DRDW_Capability__c> lActivity = new List<DRDW_Capability__c>([Select id from DRDW_Capability__c where DRDW_Request__c IN:NewCapReqList]);
         if(!lActivity.isEmpty()){
             delete lActivity;
         }
     }

     Public void UpdateFinalDatetobeConsidered(List<DRDW_Cap_Request__c> NewCapReqList){
     System.debug('Inside insert triggerhandler');

         for(DRDW_Cap_Request__c oCapreq : NewCapReqList){

            if(oCapreq.Preferred_Start_Date_Locked__c == true && oCapreq.GO_Preferred_Start_Date__c != null){
                System.debug('Inside Locked'+oCapreq.Preferred_Start_Date_Locked__c+oCapreq.GO_Preferred_Start_Date__c);
                oCapreq.FinalDateTobeConsidered__c = oCapreq.GO_Preferred_Start_Date__c;
            }else if(oCapreq.Preferred_Start_Date_Locked__c == false && oCapreq.Planned_Study_Start_Date__c != null){
                System.debug('Inside Locked'+oCapreq.Preferred_Start_Date_Locked__c+oCapreq.Planned_Study_Start_Date__c);
                oCapreq.FinalDateTobeConsidered__c = oCapreq.Planned_Study_Start_Date__c;
            }
         }

     }
     
    Public void OnAfterUpdate(Map<Id,DRDW_Cap_Request__c> newMap,Map<Id,DRDW_Cap_Request__c> oldMap){

        /*Id recordTypeId = Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('GO').getRecordTypeId();
        leventInsertFinal = new List<DRDW_Event__c>();
        leventDeleteFinal = new List<DRDW_Event__c>();
        mReqActivityId = new Map<Id,Id>();
        List<DRDW_Capability__c> lActivity = new List<DRDW_Capability__c>([Select id,DRDW_Request__c from DRDW_Capability__c where DRDW_Request__c IN:newMap.keyset() and RecordType.Name = 'Study Activity']);
         
        for(DRDW_Capability__c oactivity : lActivity){
            mReqActivityId.put(oactivity.DRDW_Request__c,oactivity.Id);
        }
                
        for(Id reqId : newMap.keyset()){
            DRDW_Cap_Request__c newReq = newMap.get(reqId);
            DRDW_Cap_Request__c oldReq = oldMap.get(reqId);
            if((recordTypeId == newReq.recordTypeId) && (newReq.Lab_Testing_Required__c != oldReq.Lab_Testing_Required__c || newReq.Samples_to_collect_new__c != oldReq.Samples_to_collect_new__c)){
                generateEvents(newReq,oldReq);
            }
        }
        
        if(leventInsertFinal.size() > 0 ){
            insert leventInsertFinal;
        }
        if(leventDeleteFinal.size() > 0 ){
            delete leventDeleteFinal;
        }*/
        
    }
    
    /* Public void generateEvents(DRDW_Cap_Request__c newReq,DRDW_Cap_Request__c oldReq) {
        
        List<DRDW_Event__c> leventInsert = new List<DRDW_Event__c>();
        List<DRDW_Event__c> leventDelete = new List<DRDW_Event__c>();
        Set<String> setLabTestingReqOld = new Set<String>();
        Set<String> setLabTestingReqNew = new Set<String>();
        Set<String> setSamplesToCollectNew = new Set<String>();
        Set<String> setSamplesToCollectOld = new Set<String>();
        Set<String> setEventReqDelete = new Set<String>();
        DRDW_Event__c oevent;
        if(newReq.Lab_Testing_Required__c != oldReq.Lab_Testing_Required__c && mReqActivityId.containskey(newReq.Id)){
            if(newReq.Lab_Testing_Required__c != null){
                setLabTestingReqNew.addAll(newReq.Lab_Testing_Required__c.split(';'));
            }
            if(oldReq.Lab_Testing_Required__c != null){
                setLabTestingReqOld.addAll(oldReq.Lab_Testing_Required__c.split(';'));
            }
            for(String labtestingReq : setLabTestingReqNew){
                if(!setLabTestingReqOld.contains(labtestingReq)){
                    oevent = new DRDW_Event__c();
                    oevent.Event_Category__c = 'Lab';
                    oevent.Type__c = 'GO';
                    oevent.Study_Title__c = newReq.Study_Title__c;
                    oevent.Status__c = 'Unassigned';
                    oevent.Event_Type__c = labtestingReq;
                    oevent.DRDW_Activity__c = mReqActivityId.get(newReq.Id);
                    leventInsert.add(oevent);
                }
            }
            for(String labtestingReq : setLabTestingReqOld){
                if(!setLabTestingReqNew.contains(labtestingReq)){
                    //delete event
                    setEventReqDelete.add(labtestingReq);
                }
            }
        }
        if(newReq.Samples_to_collect_new__c != oldReq.Samples_to_collect_new__c && mReqActivityId.containskey(newReq.Id)){
            if(newReq.Samples_to_collect_new__c != null && newReq.Samples_to_collect_new__c != '[]'){
                setSamplesToCollectNew.addAll(newReq.Samples_to_collect_new__c.replace('[','').replace(']','').split(','));
            }
            if(oldReq.Samples_to_collect_new__c != null && oldReq.Samples_to_collect_new__c != '[]'){
                setSamplesToCollectOld.addAll(oldReq.Samples_to_collect_new__c.replace('[','').replace(']','').split(','));
            }

            for(String samplestocollect : setSamplesToCollectNew){
                if(!setSamplesToCollectOld.contains(samplestocollect)){
                    oevent = new DRDW_Event__c();
                    oevent.Event_Category__c = 'Sample';
                    oevent.Type__c = 'GO';
                    oevent.Study_Title__c = newReq.Study_Title__c;
                    oevent.Status__c = 'Unassigned';
                    oevent.Event_Type__c = samplestocollect;
                    oevent.DRDW_Activity__c = mReqActivityId.get(newReq.Id);
                    leventInsert.add(oevent);
                }
            }
            
            for(String samplestocollect : setSamplesToCollectOld){
                if(!setSamplesToCollectNew.contains(samplestocollect)){
                    //delete event
                    setEventReqDelete.add(samplestocollect);
                }
            }

        }
        
        if(setEventReqDelete.size() > 0 ){
            
            leventDelete = [Select Id from DRDW_Event__c where Event_Type__c in : setEventReqDelete and DRDW_Activity__r.DRDW_Request__c =: newReq.Id and DRDW_Activity__r.DRDW_Request__r.RecordType.Name = 'GO' ];
            
        }
        
        if(leventInsert.size() > 0 ){
            leventInsertFinal.addAll(leventInsert);
        }
        if(leventDelete.size() > 0 ){
            leventDeleteFinal.addAll(leventDelete);
        }
        
     } */
     
      Public void changePreferedDate(Map<Id,DRDW_Cap_Request__c> newMap,Map<Id,DRDW_Cap_Request__c> oldMap){
        Id recordTypeId = Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('GO').getRecordTypeId();
                
        List<DRDW_Capability__c> lCaps = new List<DRDW_Capability__c>();
        lCaps = [select id,DRDW_Request__c,Proposed_Start_Date__c from DRDW_Capability__c where DRDW_Request__c in:newMap.keySet() and RecordType.Name = 'Study Activity']; 
        List<DRDW_Capability__c> updatedActivity = new List<DRDW_Capability__c>();          
        for(DRDW_Capability__c oCap:lCaps){
                    if(oCap.Proposed_Start_Date__c !=newMap.get(oCap.DRDW_Request__c).GO_Preferred_Start_Date__c){
                        oCap.Proposed_Start_Date__c = newMap.get(oCap.DRDW_Request__c).GO_Preferred_Start_Date__c;
                        updatedActivity.add(oCap);
                    }
            }       
        if(updatedActivity.size()>0){
            update updatedActivity;
        }             
     }

}