public class DRDW_AssignResourceTriggerHandler {
    public Static void OnAfterInsert(List<DRDW_Assign_Resource__c> newObjects){
        // EXECUTE AFTER INSERT LOGIC
        set<id> assignResIdSet = new set<id>();
        set<Id> eventIdSet = new Set<Id>();
        for(DRDW_Assign_Resource__c assignRes : newObjects){
            if(assignRes.DRDW_Activity__c != null){
                assignResIdSet.add(assignRes.DRDW_Activity__c);
            }
            if(assignRes.DRDW_Event__c!=null){
                eventIdSet.add(assignRes.DRDW_Event__c);
            }           
        }
        if(assignResIdSet.size() > 0 ){
            List<DRDW_Capability__c> lRelatedActivity = [Select Id,Status__c from DRDW_Capability__c where Id in: assignResIdSet and Status__c != 'Assigned'];
            for(DRDW_Capability__c orelAct : lRelatedActivity){
                orelAct.Status__c = 'Assigned';
            }
            if(lRelatedActivity != null && lRelatedActivity.size() > 0){
                update lRelatedActivity;
            }           
        }
        if(eventIdSet.size()>0){                                 
          /*  List<DRDW_Event__c> lEvents = new List<DRDW_Event__c>();
            lEvents = [select id,Event_Dates__c,Status__c,frequency__c,Type__c from DRDW_Event__c where Id in: eventIdSet and Type__c = 'GO'];
            Map<Id,List<String>> mEventFrequency = new Map<Id,List<String>>();
            
             if(lEvents.size()>0){
                List<DRDW_Event_Days__c> lEventdays = new List<DRDW_Event_Days__c>();                
                lEventdays = [select id,Date__c,DRDW_Event__c,frequency__c from DRDW_Event_Days__c where DRDW_Event__c in:lEvents];  
                for(DRDW_Event_Days__c evtDay:lEventdays){
                    if(!mEventFrequency.containsKey(evtDay.DRDW_Event__c)){
                        mEventFrequency.put(evtDay.DRDW_Event__c,new List<String>());
                    }
                    mEventFrequency.get(evtDay.DRDW_Event__c).add(evtDay.Frequency__c);
                }       
                for(DRDW_Event__c evt:lEvents){
                    Integer count=0;
                    List<String> evtFrequency = evt.Frequency__c.split(',');
                    if(mEventFrequency.get(evt.id)!=null){
                        List<String> dayFrequency = mEventFrequency.get(evt.id);        
                        for(String f:dayFrequency){
                            if(evtFrequency.contains(f)){
                                count++;
                            }
                        }
                     }
                    if(count ==evtFrequency.size()){
                        evt.Status__c = 'Assigned';
                    }else if(count < evtFrequency.size() && count!=0){
                        evt.Status__c = 'Partially Assigned';
                    }else{
                        evt.Status__c = 'Unassigned';
                    }
                }   */
                  List<DRDW_Event__c> lEvents = new List<DRDW_Event__c>();
                  lEvents = [select id,Event_Dates__c,Status__c,frequency__c,Go_Sub_Activities__c,Type__c from DRDW_Event__c where Id in: eventIdSet and Type__c = 'GO'];
                  List<DRDW_Assign_Resource__c> lAssignRes = [select id,Go_Sub_Activities__c,DRDW_Event__c from DRDW_Assign_Resource__c where DRDW_Event__c in:lEvents];
                  
                  Map<Id,List<DRDW_Assign_Resource__c>> mapofeventResource = new  Map<Id,List<DRDW_Assign_Resource__c>>();
                  Map<Id,Set<String>> mapEventSub = new Map<Id,Set<String>>();
                  Map<Id,Set<String>> mapEventSubchild = new Map<Id,Set<String>>();
                  
                   if(lEvents.size()>0){
                        for(DRDW_Event__c eve:lEvents){
                            List<String> lsubact = new List<String>();
                            lsubact = eve.Go_Sub_Activities__c.replace('[','').replace(']','').split(', ');              
                            if(!mapEventSub.containskey(eve.id)){
                                Set<String> ssubact = new Set<String>();
                                mapEventSub.put(eve.id,ssubact);
                            }
                            mapEventSub.get(eve.id).addAll(lsubact);
                        }
                        
                        if(lAssignRes.size()>0){
                            for(DRDW_Assign_Resource__c oAssign:lAssignRes){
                                if(!mapEventSubchild.containskey(oAssign.DRDW_Event__c)){
                                    Set<String> ssubact = new Set<String>();
                                    mapEventSubchild.put(oAssign.DRDW_Event__c,ssubact);
                                }
                                mapEventSubchild.get(oAssign.DRDW_Event__c).add(oAssign.Go_Sub_Activities__c);
                            }
                        }
                        
                        for(DRDW_Event__c eve:lEvents){
                            if(mapEventSubchild.get(eve.id).size()==mapEventSub.get(eve.id).size()){
                                eve.Status__c = 'Assigned';
                            }else{
                                eve.Status__c = 'Partially Assigned';
                            }
                        }
                   }
                   
                update lEvents;                    
                                                             
        }
    }

    public  Static void OnBeforeDelete(List<DRDW_Assign_Resource__c> ObjectsToDelete,Map<id,DRDW_Assign_Resource__c> MapObjectMap){
        // BEFORE DELETE LOGIC
        Set<id> deleteResId = new set<id>();
        Set<id> EventId = new set<id>();
        List<id> lassignRes;
        Map<id,list<id>> mEventlAssignRes = new Map<id,list<id>>();
        for(DRDW_Assign_Resource__c oAssRes : ObjectsToDelete ){
            if(oAssRes.DRDW_Event__c!= null){
                if(mEventlAssignRes.containskey(oAssRes.DRDW_Event__c)){
                    lassignRes = mEventlAssignRes.get(oAssRes.DRDW_Event__c);
                    lassignRes.add(oAssRes.Id);
                    mEventlAssignRes.put(oAssRes.DRDW_Event__c,lassignRes);
                }
                else{
                    lassignRes = new List<id>();
                    lassignRes.add(oAssRes.Id);
                    mEventlAssignRes.put(oAssRes.DRDW_Event__c,lassignRes);
                }
                EventId.add(oAssRes.DRDW_Event__c);
                deleteResId.add(oAssRes.DRDW_Resources__c);
            }          
        }
        List<DRDW_Event_Days__c> EventsToDel = new List<DRDW_Event_Days__c>([Select id,Date__c,DRDW_Event__c,Type__c,Go_Sub_Activities__c from DRDW_Event_Days__c where DRDW_Resource__c IN:deleteResId AND DRDW_Event__c IN:EventId]);
        
        List<DRDW_Event_Days__c> EventsToDelFinal = new List<DRDW_Event_Days__c>();
        for(DRDW_Event_Days__c eventDel : EventsToDel){
            if(mEventlAssignRes.containskey(eventDel.DRDW_Event__c)){
                for(Id assignRes : mEventlAssignRes.get(eventDel.DRDW_Event__c)){
                    if(((MapObjectMap.get(assignRes).Allocation_End_Date__c >= eventDel.Date__c && MapObjectMap.get(assignRes).Allocation_Start_Date__c <= eventDel.Date__c) && eventDel.Type__c == 'ERL')
                        || ((MapObjectMap.get(assignRes).Go_Sub_Activities__c == eventDel.Go_Sub_Activities__c) && eventDel.Type__c == 'GO')){
                        EventsToDelFinal.add(eventDel);
                    }
                }
            }
        }
        
        if(EventsToDelFinal.size() > 0){
            delete EventsToDelFinal;
        }
    }
}