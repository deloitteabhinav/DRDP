public without sharing class DRDW_Event_Days_TriggerHandler{
    // ### - This method takes input as the updated event days and correspondingly updates the calender roaster records - ###
    public static void updateCalenderRoaster(List<DRDW_Event_Days__c> lstTriggerNew, map<id,DRDW_Event_Days__c> oldMap){
        set<date> setDates = new set<Date>();
        set<Id> setResourceIds = new set<id>();
        for(DRDW_Event_Days__c evtDay : lstTriggerNew){
            // adding the old and the new date query
            setDates.add(oldMap.get(evtDay.id).date__c);
            setDates.add(evtDay.date__c);
            setResourceIds.add(oldMap.get(evtDay.id).DRDW_Resource__c);
        }
        
        map<String,DRDW_Calender_Per_Roaster__c> map_ResourceDate_CalRes = new map<String,DRDW_Calender_Per_Roaster__c>();
        for(DRDW_Calender_Per_Roaster__c calRoast : [Select Allocated_Date__c, DRDW_Roaster__c, Allocated_Hours__c
                                                        from DRDW_Calender_Per_Roaster__c 
                                                        where Allocated_Date__c in : setDates and
                                                            DRDW_Roaster__c in : setResourceIds]){
            map_ResourceDate_CalRes.put(calRoast.DRDW_Roaster__c + '_' + calRoast.Allocated_Date__c, calRoast);    
        }
        
        List<DRDW_Calender_Per_Roaster__c> lstCalRoastForUpsert = new List<DRDW_Calender_Per_Roaster__c>();
        String oldDateKey;
        String newDateKey;
        
        for(DRDW_Event_Days__c evtDay : lstTriggerNew){
            oldDateKey = oldMap.get(evtDay.id).DRDW_Resource__c + '_' + oldMap.get(evtDay.id).date__c;
            newDateKey = oldMap.get(evtDay.id).DRDW_Resource__c + '_' + evtDay.date__c;
            
            // updating the old calender roaster record
            If(map_ResourceDate_CalRes.containsKey(oldDateKey)){
                map_ResourceDate_CalRes.get(oldDateKey).Allocated_Hours__c -= oldMap.get(evtDay.id).Allocated_Hours__c;
            }
            // updating the new roaster record if it exist
            If(map_ResourceDate_CalRes.containsKey(newDateKey)){
                map_ResourceDate_CalRes.get(newDateKey).Allocated_Hours__c += evtDay.Allocated_Hours__c;
            }
            // else creating a new one for insert
            else{
                lstCalRoastForUpsert.add(new DRDW_Calender_Per_Roaster__c(Allocated_Date__c = evtDay.date__c, 
                                    Allocated_Hours__c = evtDay.Allocated_Hours__c, DRDW_Roaster__c = evtDay.DRDW_Resource__c));
            }
        }
        
        lstCalRoastForUpsert.addAll(map_ResourceDate_CalRes.values());
        if(lstCalRoastForUpsert.size()>0){
            GLBL_ErrorLog_Utility.logDMLDatabaseResultErrors(null,
                    Database.upsert(lstCalRoastForUpsert,DRDW_Calender_Per_Roaster__c.fields.id, false),null,
                    'DRDW','Error while updating the preferred start date on an activity');
        }
    }
    
    public static void deleteCalenderRoaster(map<id,DRDW_Event_Days__c> oldMap){
        set<date> setDates = new set<Date>();
        set<Id> setResourceIds = new set<id>();
        for(ID KeyID: oldMap.keySet()){
            // adding the old and the new date query
            setDates.add(oldMap.get(KeyID).date__c);
            //setDates.add(evtDay.date__c);
            setResourceIds.add(oldMap.get(KeyID).DRDW_Resource__c);
            
        }
            System.debug('****** '+setDates);
            System.debug('********** '+ [Select Allocated_Date__c, DRDW_Roaster__c, Allocated_Hours__c from DRDW_Calender_Per_Roaster__c where Allocated_Date__c IN: setDates and DRDW_Roaster__c IN: setResourceIds]);
        map<String,DRDW_Calender_Per_Roaster__c> map_ResourceDate_CalRes = new map<String,DRDW_Calender_Per_Roaster__c>();
        for(DRDW_Calender_Per_Roaster__c calRoast : [Select Allocated_Date__c, DRDW_Roaster__c, Allocated_Hours__c from DRDW_Calender_Per_Roaster__c where Allocated_Date__c in : setDates and DRDW_Roaster__c in : setResourceIds]){
            
            map_ResourceDate_CalRes.put(calRoast.DRDW_Roaster__c + '_' + calRoast.Allocated_Date__c, calRoast);    
        }
        
        List<DRDW_Calender_Per_Roaster__c> lstCalRoastForUpsert = new List<DRDW_Calender_Per_Roaster__c>();
        String oldDateKey;
        
        for(ID KeyID: oldMap.keySet()){
            oldDateKey = oldMap.get(KeyID).DRDW_Resource__c + '_' + oldMap.get(KeyID).date__c;           
            
            // updating the old calender roaster record
            If(map_ResourceDate_CalRes.containsKey(oldDateKey)){
            System.debug('*********t ' + map_ResourceDate_CalRes.get(oldDateKey).Allocated_Hours__c);
                map_ResourceDate_CalRes.get(oldDateKey).Allocated_Hours__c -= oldMap.get(KeyID).Allocated_Hours__c;
            }
        }
        
        lstCalRoastForUpsert.addAll(map_ResourceDate_CalRes.values());
        if(lstCalRoastForUpsert.size()>0){
            GLBL_ErrorLog_Utility.logDMLDatabaseResultErrors(null,
                    Database.upsert(lstCalRoastForUpsert,DRDW_Calender_Per_Roaster__c.fields.id, false),null,
                    'DRDW','Error while updating the preferred start date on an activity');
        }
    }
    
}