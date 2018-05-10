public class DRDW_EventTriggerHandler {
    
    Public static List<DRDW_Assign_Resource__c> lresAllocDeleteFinal;
     
    public Static void OnBeforeUpdate(List<DRDW_Event__c> oldObjects, List<DRDW_Event__c> updatedObjects,Map<id,DRDW_Event__c> MapObjectMap){
        // BEFORE UPDATE LOGIC        
        Set<Id> activityIds = new Set<Id>();   
        Map<Id,Id> mapEventAct = new Map<Id,Id>();
        Map<Id,Date> mapEventDates = new Map<Id,Date>();
        for(DRDW_Event__c evt:updatedObjects){  
            mapEventAct.put(evt.id,evt.DRDW_Activity__c);
        }                         
        Map<Id,DRDW_Capability__c> mapActivities = new Map<Id,DRDW_Capability__c>([select id,DRDW_Request__r.GO_Preferred_Start_Date__c from DRDW_Capability__c where id in:mapEventAct.values()]);
        for(DRDW_Event__c oevt:updatedObjects){
            mapEventDates.put(mapEventAct.get(oevt.id),mapActivities.get(oevt.DRDW_Activity__c).DRDW_Request__r.GO_Preferred_Start_Date__c);
        }
        system.debug('****MAP*****'+mapEventDates); 
        BusinessHours bh = [Select id from BusinessHours where name = 'DRDW_ERL_Business_Hours' limit 1];        
        for(DRDW_Event__c evt:updatedObjects){            
            if(evt.Type__c == 'GO'){
                if(evt.Frequency__c!=null && evt.Frequency__c!=''){
                    String seveneventDates = '';
                    String fiveeventDates = '';
                    String frequency = evt.Frequency__c;
                    frequency = frequency.trim();                  
                    List<String> ldiff = frequency.split(',');
                    ldiff.sort();
                    if(evt.DRDW_Activity__c!=null){
                        for(String days:ldiff){
                           // system.debug('inside before event'+mapEventDates.get(evt.id));                      
                            Date input = mapEventDates.get(evt.DRDW_Activity__c).addDays(Integer.valueOf(days));                                            
                            seveneventDates += DateTime.newInstance(input.year(), input.month(), input.day()).format('yyyy-MM-dd')+',';
                            fiveeventDates += BusinessHours.addGmt(bh.id,DateTime.newInstance(mapEventDates.get(evt.DRDW_Activity__c),Time.newInstance(10,10,10,10)),Integer.valueOf(days)* 86400000).format('yyyy-MM-dd')+',';
                           system.debug('BH****'+BusinessHours.addGmt(bh.id,mapEventDates.get(evt.DRDW_Activity__c),Integer.valueOf(days)* 86400000));
                           system.debug('Pdate++++++'+mapEventDates.get(evt.DRDW_Activity__c));
                           system.debug('fiveeventDates******'+fiveeventDates);
                        }
                    }
                    evt.Event_Dates_7_Day_Res__c= seveneventDates.removeEnd(',');
                    evt.Event_Dates_5_Day_Res__c= fiveeventDates.removeEnd(',');
                }
            }        
        }              
    }
    
    public  Static void OnBeforeDelete(List<DRDW_Event__c> ObjectsToDelete,Map<id,DRDW_Event__c> MapObjectMap){
        // BEFORE DELETE LOGIC        
        List<DRDW_Assign_Resource__c> lassignResource = [Select Id,DRDW_Event__c from DRDW_Assign_Resource__c where DRDW_Event__c=:MapObjectMap.keyset()];
        if(lassignResource != null && lassignResource.size() > 0){
            delete lassignResource;
        }
    }
    
    Public static void OnAfterUpdate(Map<Id,DRDW_Event__c> newMap,Map<Id,DRDW_Event__c> oldMap){

        lresAllocDeleteFinal = new List<DRDW_Assign_Resource__c>();
                
        for(Id eventId : newMap.keyset()){
            DRDW_Event__c newEvent = newMap.get(eventId);
            DRDW_Event__c oldEvent = oldMap.get(eventId);
            system.debug('newEvent.Type__c'+newEvent.Type__c);
            system.debug('newEvent.Go_Sub_Activities__c '+newEvent.Go_Sub_Activities__c );
            system.debug('oldEvent.Go_Sub_Activities__c '+oldEvent.Go_Sub_Activities__c );
            if(('GO' == newEvent.Type__c) && (newEvent.Go_Sub_Activities__c != oldEvent.Go_Sub_Activities__c)){
                generateDeleteResourceAlloc(newEvent,oldEvent);
            }
        }
        system.debug('lresAllocDeleteFinal'+lresAllocDeleteFinal);
        if(lresAllocDeleteFinal.size() > 0 ){
            delete lresAllocDeleteFinal;
        }
        
    }
    
    Public static void generateDeleteResourceAlloc(DRDW_Event__c newEvent,DRDW_Event__c oldEvent) {
        
        List<DRDW_Assign_Resource__c> lassignResourceDelete = new List<DRDW_Assign_Resource__c>();
        Set<String> setSubActivityNew = new Set<String>();
        Set<String> setSubActivityOld = new Set<String>();
        Set<String> setResourceAllocDelete = new Set<String>();
        if(newEvent.Go_Sub_Activities__c != oldEvent.Go_Sub_Activities__c){
            if(newEvent.Go_Sub_Activities__c != null && newEvent.Go_Sub_Activities__c != '[]'){
                setSubActivityNew.addAll(newEvent.Go_Sub_Activities__c.replace('[','').replace(']','').split(', '));
            }
            if(oldEvent.Go_Sub_Activities__c != null && oldEvent.Go_Sub_Activities__c != '[]'){
                setSubActivityOld.addAll(oldEvent.Go_Sub_Activities__c.replace('[','').replace(']','').split(', '));
            }           
            system.debug('setSubActivityNew'+setSubActivityNew);
            system.debug('setSubActivityOld'+setSubActivityOld);
            for(String gosubact : setSubActivityOld){
                if(!setSubActivityNew.contains(gosubact)){
                    //delete event
                    setResourceAllocDelete.add(gosubact);
                }
            }
        }
        
        if(setResourceAllocDelete.size() > 0 ){
            
            lassignResourceDelete = [Select Id from DRDW_Assign_Resource__c where Go_Sub_Activities__c in: setResourceAllocDelete and DRDW_Event__c =: newEvent.Id];
            
        }
        
        if(lassignResourceDelete.size() > 0 ){
            lresAllocDeleteFinal.addAll(lassignResourceDelete);
        }
        
    } 
    
    public static void OnBeforeInsert(List<DRDW_Event__c> newObjects){
        
        try{
            for(DRDW_Event__c evt:newObjects){            
                if(evt.Type__c == 'GO'){
                    evt.Display_Order__c = DisplayOrderSet(evt.Event_Type__c);
                    if(evt.Frequency_UI__c!=null && evt.Frequency_UI__c!=''){
                        String frequencyUI = evt.Frequency_UI__c;
                        String frequencyBackend = '';
                        frequencyUI = frequencyUI.trim();                  
                        List<String> freqList = frequencyUI.split(',');
                        for(String freq:freqList){
                            if(freq.contains('-')){
                                if(freq.split('-').size() == 2 && freq.split('-')[0] == '' ){
                                    frequencyBackend = frequencyBackend + freq + ',' ;                              
                                }
                                else{ 
                                    integer max = 0;
                                    integer min = 0;
                                    integer firstNumber = 0;
                                    integer secondNumber = 0;
                                    if(freq.split('-').size() == 2 && freq.split('-')[0] != '' && freq.split('-')[1] != ''){
                                        firstNumber = integer.valueof(freq.split('-')[0]);
                                        secondNumber = integer.valueof(freq.split('-')[1]);
                                    }
                                    if(freq.split('-').size() == 3 && freq.split('-')[0] == '' && freq.split('-')[1] != '' && freq.split('-')[2] != ''){
                                        firstNumber = integer.valueof(freq.split('-')[1]) * -1;
                                        secondNumber = integer.valueof(freq.split('-')[2]);                                 
                                    }
                                    if(freq.split('-').size() == 3 && freq.split('-')[1] == '' && freq.split('-')[0] != '' && freq.split('-')[2] != ''){
                                        firstNumber = integer.valueof(freq.split('-')[1]);
                                        secondNumber = integer.valueof(freq.split('-')[2]) * -1;                                    
                                    }
                                    if(freq.split('-').size() == 4 && freq.split('-')[1] != '' && freq.split('-')[3] != ''){
                                        firstNumber = integer.valueof(freq.split('-')[1]) * -1;
                                        secondNumber = integer.valueof(freq.split('-')[3]) * -1;                                    
                                    }
                                                                    
                                    if(firstNumber > secondNumber){
                                        max = firstNumber;
                                        min = secondNumber;
                                    }
                                    else{
                                        max = secondNumber;
                                        min = firstNumber;                                      
                                    }
                                    for(integer i=min; i<=max ; i++){
                                        frequencyBackend = frequencyBackend + string.valueOf(i) + ',' ;
                                    }                                                                                       
                                }
                            }
                            else{
                                frequencyBackend = frequencyBackend + freq + ',' ;
                            }
                        }
                        evt.Frequency__c = frequencyBackend.removeEnd(',');
                    }                   
                }               
            }        
        }
        catch(exception e){
             system.debug('error'+e.getmessage());
        }
    
    }
    
     public static String DisplayOrderSet(String EventName){
         if(EventName == 'Obtain Animals'){
             return '1';
         }else if(EventName == 'Animal Arrival'){
             return '2';
         }else if(EventName == 'Select Animals'){
             return '3';
         }else if(EventName == 'Randomize Animals'){
             return '4';
         }else if(EventName == 'Acclimation'){
             return '5';
         }else if(EventName == 'Drug Administration'){
             return '6';
         }else if(EventName == 'Pre challenge'){
             return '7';
         }else if(EventName == 'Challenge'){
             return '8';
         }else if(EventName == 'Post Challenge'){
             return '9';
         }else if(EventName == 'Vaccination'){
             return '10';
         }else if(EventName == 'Immunization'){
             return '11';
         }else if(EventName == 'Clinical Observations'){
             return '12';
         }else if(EventName == 'Health Observation(s)'){
             return '13';
         }else if(EventName == 'Blood Sample Collection'){
             return '14';
         }else if(EventName == 'Tissue Sample Collection'){
             return '15';
         }else if(EventName == 'Rectal temperatures'){
             return '16';
         }else if(EventName == 'Fasting'){
             return '17';
         }else if(EventName == 'Swabs'){
             return '18';
         }else if(EventName == 'Fecal Sample'){
             return '19';
         }else if(EventName == 'Ultrasound'){
             return '20';
         }else if(EventName == 'Xrays'){
             return '21';
         }else if(EventName == 'Measure Shedding'){
             return '22';
         }else if(EventName == 'Abscess Exudate/Culture'){
             return '23';
         }else if(EventName == 'Implants'){
             return '24';
         }else if(EventName == 'Scoring'){
             return '25';
         }else if(EventName == 'Euthanize'){
             return '26';
         }else if(EventName == 'Necropsy'){
             return '27';
         }else if(EventName == 'Final Study Day'){
             return '28';
         }else{
             return null;
         }
     }
}