// ### - methods of this utility class are invoked from DRDW_ActivityTriggerHandler - ###
public without sharing class DRDW_EventDays_Utility{
    private static List<BusinessHours> lstBusHour;
    private static Time zeroTime = Time.newInstance(0, 0, 0, 0);
    static{
        lstBusHour = [Select id from BusinessHours where name = 'DRDW_ERL_Business_Hours' limit 1];
    }
    
    // ### - This method takes a set of Activity records whose proposed date has changed and returns a map of 
    // activity id with set of event days - ###
    public static map<Id,Set<DRDW_Event_Days__c>> getEventDays(Set<DRDW_Capability__c> actWithUpdatedPrefStartDate){
        map<Id,Set<DRDW_Event_Days__c>> map_ActId_EventDays = new map<Id,Set<DRDW_Event_Days__c>>();
        map<Id,Set<DRDW_Event__c>> map_ActId_Event = new map<Id,Set<DRDW_Event__c>>();
        map<Id,Id> map_eventId_ActivityId = new map<Id,Id>();
        
        // ### - generating a map of activity Id and set of events - ###
        for(DRDW_Event__c evt : [Select DRDW_Activity__c from DRDW_Event__c where DRDW_Activity__c in : actWithUpdatedPrefStartDate]){
            map_eventId_ActivityId.put(evt.id, evt.DRDW_Activity__c);
            if(!map_ActId_Event.containsKey(evt.DRDW_Activity__c)){
                map_ActId_Event.put(evt.DRDW_Activity__c, new Set<DRDW_Event__c>());
            }
            map_ActId_Event.get(evt.DRDW_Activity__c).add(evt);
        }
        
        // ### - generating a map of activity id and set of event days - ###
        Id activityId;
        for(DRDW_Event_Days__c evtDay : [Select Date__c, DRDW_Event__c, DRDW_Resource__r.Days_Per_Week__c
                                            from DRDW_Event_Days__c 
                                            where DRDW_Event__c in : map_eventId_ActivityId.keySet()]){
            activityId = map_eventId_ActivityId.get(evtDay.DRDW_Event__c);
            if(!map_ActId_EventDays.containsKey(activityId)){
                map_ActId_EventDays.put(activityId, new Set<DRDW_Event_Days__c>());
            }
            map_ActId_EventDays.get(activityId).add(evtDay);
        }
        return map_ActId_EventDays;
    }
    
    // ### - this method takes activties with updated preferred start date and gives back the related 
    // assign resource records - ###
    private static map<id,List<DRDW_Assign_Resource__c>> getAssignedResources(Set<DRDW_Capability__c> actWithUpdatedPrefStartDate){
        map<id,List<DRDW_Assign_Resource__c>> map_ActId_AssignRes = new map<id,List<DRDW_Assign_Resource__c>>();
        for(DRDW_Assign_Resource__c assRes : [Select Allocation_End_Date__c,Allocation_Start_Date__c, DRDW_Activity__c,
                                                DRDW_Resources__r.Days_Per_Week__c
                                                from DRDW_Assign_Resource__c
                                                where DRDW_Activity__c in : actWithUpdatedPrefStartDate]){
            if(!map_ActId_AssignRes.containsKey(assRes.DRDW_Activity__c)){
                map_ActId_AssignRes.put(assRes.DRDW_Activity__c , new List<DRDW_Assign_Resource__c>());
            }
            map_ActId_AssignRes.get(assRes.DRDW_Activity__c).add(assRes); 
        }
        return map_ActId_AssignRes;
    }
    
    private static date calculateNewDate(Date oriDate, boolean fiveDayWeek, Date oldSrtDate, Date newSrtDate){
        Date newDate = oriDate;
        if(oldSrtDate == null){
            oldSrtDate = newSrtDate;
        }
        If(fiveDayWeek){
            If(lstBusHour != null && lstBusHour.size()>0){
                // calculating the diffInMilliSec considering the weekends.
                    Long diffInMilliSec = BusinessHours.diff(lstBusHour[0].id,
                                               DateTime.newInstance(oldSrtDate,Time.newInstance(10,10,10,10)),
                                               DateTime.newInstance(newSrtDate,Time.newInstance(10,10,10,10)));
                    newDate = BusinessHours.addGMT(lstBusHour[0].id,
                             DateTime.newInstance(oriDate,Time.newInstance(10,10,10,10)),
                              diffInMilliSec).Date();
                    //System.debug('### oriDate ###' + oriDate);
                    //System.debug('### diff in days ###' + diffInMilliSec/86400000);
                    //System.debug('### newDate  ###' + newDate );
            }
        }
        else{
            newDate = oriDate.addDays(oldSrtDate.daysBetween(newSrtDate));
        }
                return newDate;
    }
    
    public static void updateAssignedResources(Set<DRDW_Capability__c> actWithUpdatedPrefStartDate, Map<id,DRDW_Capability__c> oldMap){
        List<DRDW_Assign_Resource__c> lstAssignResForUpd = new List<DRDW_Assign_Resource__c> ();
        map<id,List<DRDW_Assign_Resource__c>> map_ActId_AssignRes = getAssignedResources(actWithUpdatedPrefStartDate);
        if(map_ActId_AssignRes != null && map_ActId_AssignRes.size()>0){
            for(DRDW_Capability__c cap: actWithUpdatedPrefStartDate){
                for(DRDW_Assign_Resource__c assRes : map_ActId_AssignRes.get(cap.id)){
                
                    // if the resource works only 5 days a week
                    if(assRes.DRDW_Resources__r.Days_Per_Week__c == '5'){
                        assRes.Allocation_Start_Date__c = calculateNewDate(assRes.Allocation_Start_Date__c, true, oldmap.get(cap.id).Proposed_Start_Date__c, cap.Proposed_Start_Date__c);
                        assRes.Allocation_End_Date__c = calculateNewDate(assRes.Allocation_End_Date__c, true, oldmap.get(cap.id).Proposed_Start_Date__c, cap.Proposed_Start_Date__c);
                        
                    }
                    else{
                        assRes.Allocation_Start_Date__c = calculateNewDate(assRes.Allocation_Start_Date__c, false, oldmap.get(cap.id).Proposed_Start_Date__c, cap.Proposed_Start_Date__c);
                        assRes.Allocation_End_Date__c = calculateNewDate(assRes.Allocation_End_Date__c, false, oldmap.get(cap.id).Proposed_Start_Date__c, cap.Proposed_Start_Date__c);
                    }
                    lstAssignResForUpd.add(assRes);
                }
            }
        }
        if(lstAssignResForUpd.size()>0){
            GLBL_ErrorLog_Utility.logDMLDatabaseResultErrors(Database.update(lstAssignResForUpd, false),null,null,'DRDW','Error while updating the preferred start date on an activity');
        }
    }
    
    // ### - This method takes a set of activites whose proposed start date has shifted and
    // accordingly shifts the event days associated with those activites - ###
    public static void shiftEventDays(Set<DRDW_Capability__c> actWithUpdatedPrefStartDate,Map<id,DRDW_Capability__c> oldMap){
        List<DRDW_Event_Days__c> lstEventDaysToUpdate = new List<DRDW_Event_Days__c>();
        
        // getting the corresponding eventDays
        map<Id,Set<DRDW_Event_Days__c>> map_ActId_EventDays = getEventDays(actWithUpdatedPrefStartDate); 
        
        // the crux of the logic
        for(DRDW_Capability__c cap : actWithUpdatedPrefStartDate){
            if(map_ActId_EventDays.get(cap.id) != null){
                for(DRDW_Event_Days__c evtDay : map_ActId_EventDays.get(cap.id)){
                    // if the resource works only 5 days a week
                    if(evtDay.DRDW_Resource__r.Days_Per_Week__c == '5'){
                        evtDay.Date__c = calculateNewDate(evtDay.Date__c, true, oldmap.get(cap.id).Proposed_Start_Date__c, cap.Proposed_Start_Date__c);
                    }
                    else{
                        evtDay.Date__c = calculateNewDate(evtDay.Date__c, false, oldmap.get(cap.id).Proposed_Start_Date__c, cap.Proposed_Start_Date__c);
                    }
                    lstEventDaysToUpdate.add(evtDay);
                }
            }
        }
        if(lstEventDaysToUpdate.size()>0){
            GLBL_ErrorLog_Utility.logDMLDatabaseResultErrors(Database.update(lstEventDaysToUpdate, false),null,null,'DRDW','Error while updating the preferred start date on an activity');
        }
    }

}