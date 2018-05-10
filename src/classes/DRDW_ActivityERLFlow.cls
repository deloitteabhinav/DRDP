public class DRDW_ActivityERLFlow{
    // returns map of string(ERL,GO) and Activities
    public Static Map<String,List<DRDW_Capability__c>> getActivities(List<DRDW_Capability__c> oActivities){
        Id recordtype = Schema.SObjectType.DRDW_Capability__c.getRecordTypeInfosByName().get('Request Activity').getRecordTypeId();
        Id erlid = Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('ERL').getRecordTypeId();
        Id goid = Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('GO').getRecordTypeId();
        List<DRDW_Capability__c> erlList = new List<DRDW_Capability__c>();
        List<DRDW_Capability__c> goList = new List<DRDW_Capability__c>();
        Set<Id> reqSet = new Set<Id>();
        for(DRDW_Capability__c c:oActivities){
            if(c.RecordTypeId == recordtype && c.Type__c == 'ERL'){
                erlList.add(c); 
            }
            else if(c.RecordTypeId == recordtype && c.Type__c == 'GO'){
                goList.add(c);
            }
        }
        Map<String,List<DRDW_Capability__c>> mapOfActivities = new Map<String,List<DRDW_Capability__c>>();
        mapOfActivities.put('ERL',erlList);
        mapOfActivities.put('GO',goList);
        return mapOfActivities;
    }

    // Create ERL events for Activities
    public Static List<DRDW_Event__c> createERLEvent(List<DRDW_Capability__c> oActivities){
        List<DRDW_Event__c> lEvents = new List<DRDW_Event__c>();
        for(DRDW_Capability__c c:oActivities){
            DRDW_Event__c e = new DRDW_Event__c();
            e.DRDW_Activity__c = c.id;
            e.type__c = 'ERL';
            lEvents.add(e);
        }
        try{
            insert lEvents;
            return lEvents;
        }
        catch(Exception e){
            return null;
        }
    }

    //Create ERL EventDays
    public static void createERLEventDays(List<DRDW_Capability__c> oActivities,List<DRDW_Event__c> lEvents){
        Map<Id,DRDW_Capability__c> mapOfActivities = new Map<Id,DRDW_Capability__c>();
        DRDW_Event_Days__c eDays;
        List<DRDW_Event_Days__c> lEventdays = new List<DRDW_Event_Days__c>();
        DRDW_Capability__c cap;
        for(DRDW_Capability__c c:oActivities){          
            mapOfActivities.put(c.id,c);
        }
        for(DRDW_Event__c e:lEvents){
            if(mapOfActivities.get(e.DRDW_Activity__c)!=null){
                cap = mapOfActivities.get(e.DRDW_Activity__c);
                Date enddate = cap.Planned_End_Date__c;   
                for(Date startdate = cap.Planned_Start_Date__c;startdate<=enddate;startdate=startdate.addDays(1)){
                    eDays = new DRDW_Event_Days__c();
                    eDays.Date__c = startdate;
                    eDays.DRDW_Event__c = e.id;
                    eDays.Type__c = 'ERL';
                    lEventdays.add(eDays);
                }               
            }
        }
        try{
            insert lEventdays;          
        }
        catch(Exception e){
        }
    }   

    // Create ERL events for Activities
    public Static void deleteERLEvent(List<DRDW_Capability__c> oActivities){
        List<DRDW_Event__c> lEvents = [select id from DRDW_Event__c where DRDW_Activity__c in :oActivities];
        if(lEvents!=null){
            try{
                delete lEvents;
            }catch(Exception e){
                System.debug('Error'+e);
            }
        }
    }
}