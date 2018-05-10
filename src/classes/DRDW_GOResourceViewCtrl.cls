Public with Sharing Class DRDW_GOResourceViewCtrl{
    Public transient Map<Id,DRDW_Project__c> mProject{get;set;}
    Public transient Map<Id,DRDW_Event__c> mEvent{get;set;}
    Public transient Map<Id,DRDW_Resource__c> mResources{get;set;}
    Public transient Map<Id,DRDW_Cap_Request__c> mRequest{get;set;}
    Public transient Map<Id,List<DRDW_Event_Days__c>> mEventIdEventDays{get;set;}
    Public transient Map<Id,Map<Id,set<Id>>> mResourceIdProjectIdsRequestIds{get;set;}
    Public transient Map<Id,set<Id>> mRequestIdEventIds{get;set;}
    //Public transient Map<Id,set<Id>> mResourceIdProjectIds{get;set;}
    Public transient list<DRDW_Event_Days__c> lEventDays{get;set;}
    Public transient Map<Id,Map<Date,Decimal>> mRoasterPerDayAllocation{get;set;}
    Public transient Map<Id,Map<Date,Decimal>> mRoasterPerDayAllocationPer{get;set;}
    Public String gogroup{get;set;}
    Public String jsonStringResource{get;set;}
    Public set<String> PSAssignedResource{get;set;}
    Public transient Map<id,DRDW_Event_Days__c> mEventDay{get;set;}
    
    public DRDW_GOResourceViewCtrl(DRDW_GOProjectViewCtrl controller) {    
        gogroup ='All';
    }

    public DRDW_GOResourceViewCtrl() {
       
    }

    Public void executeWrapperGenerator(){
        permissionSetAssignedResource();
        queryDetails(gogroup);//gogroup);
        jsonGenerator();
    }

    Public void executeWrapperGeneratorOnLoad(){
        gogroup ='All';
        permissionSetAssignedResource();
        queryDetails(gogroup);//gogroup);
        jsonGenerator();
    }

    Public void executeWrapperGeneratorExport(){
        permissionSetAssignedResource();
        gogroup = Apexpages.currentPage().getParameters().get('gogroup');
        system.debug('testvvvv****'+gogroup);
        queryDetails(gogroup);//gogroup);
        jsonGenerator();
         mEventDay = new Map<id,DRDW_Event_Days__c>();
        for(DRDW_Event_Days__c EventDay : lEventDays){
            mEventDay.put(EventDay.id,EventDay);
        }
    }
    
    //query all the records required for the report
    Public void queryDetails(string gogroup){
        lEventDays = new list<DRDW_Event_Days__c>();
        List<DRDW_Event_Days__c> lEventDaysTemp;
        set<Id> setEventIds;
        set<Id> setProjIds =  new set<Id>();
        set<Id> setRequestIds;
        set<Id> setRequestIdsQuery =  new set<Id>();
        mEventIdEventDays = new Map<Id,List<DRDW_Event_Days__c>>();
        Map<Id,set<Id>> mProjIdRequestIds = new Map<Id,set<Id>>();
        mRequestIdEventIds = new Map<Id,set<Id>>();
        mResourceIdProjectIdsRequestIds = new  Map<Id,Map<Id,Set<Id>>>();
        mEvent = new Map<Id,DRDW_Event__c>(); 
        mResources = new Map<Id,DRDW_Resource__c>();
        mProject = new Map<Id,DRDW_Project__c>();
        mRequest = new Map<Id,DRDW_Cap_Request__c>();
        if(PSAssignedResource.contains('DRDW_GO_User') || PSAssignedResource.contains('DRDW_Senior_Leadership_User') || PSAssignedResource.contains('DRDW_Business_Admin') || PSAssignedResource.contains('DRDW_Financial_User')) {
            if(gogroup != 'All'){
                lEventDays = [Select Id,Name,Date__c,DRDW_Event__c,DRDW_Event__r.DRDW_Activity__c,Allocation_Percentage__c,DRDW_Resource__c,Allocated_Hours__c,DRDW_Resource__r.Name__r.Name,DRDW_Resource__r.Hours_Available_Per_Day__c,
                Weekend__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__r.Name__c,DRDW_Event__r.DRDW_Activity__r.Title__c,
                DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Planned_Study_Start_Date__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.GO_Preferred_End_Date__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Planned_Study_End_Date__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Preferred_Start_Date_Locked__c,
                Go_Sub_Activities__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.GO_Preferred_Start_Date__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Study_Title__c,DRDW_Event__r.Event_Type__c                   
                from DRDW_Event_Days__c where (DRDW_Resource__r.Department__c =: gogroup) and (Type__c =:'GO') and (DRDW_Event__r.DRDW_Activity__c != null)
                and (DRDW_Event__r.DRDW_Activity__r.DRDW_Request__c != null) and (DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c != null) and (DRDW_Resource__r.Hours_Available_Per_Day__c!=null) and (DRDW_Resource__r.Name__c != null) order by createddate desc limit 50000];
            }
            else{
                lEventDays = [Select Id,Name,Date__c,DRDW_Event__c,DRDW_Event__r.DRDW_Activity__c,Allocation_Percentage__c,DRDW_Resource__c,Allocated_Hours__c,DRDW_Resource__r.Name__r.Name,DRDW_Resource__r.Hours_Available_Per_Day__c,
                Weekend__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__r.Name__c,DRDW_Event__r.DRDW_Activity__r.Title__c,
                DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Planned_Study_Start_Date__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.GO_Preferred_End_Date__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Planned_Study_End_Date__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Preferred_Start_Date_Locked__c,
                Go_Sub_Activities__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.GO_Preferred_Start_Date__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Study_Title__c,DRDW_Event__r.Event_Type__c                   
                from DRDW_Event_Days__c where (Type__c =:'GO') and (DRDW_Event__r.DRDW_Activity__c != null) and (DRDW_Event__r.DRDW_Activity__r.DRDW_Request__c != null) and (DRDW_Resource__r.Hours_Available_Per_Day__c!=null) and (DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c != null)and (DRDW_Resource__r.Name__c != null) order by createddate desc limit 50000];          
            }
        }
        else{
            if(PSAssignedResource.contains('DRDW_Scientist') || PSAssignedResource.contains('DRDW_Project_Manager') || PSAssignedResource.contains('DRDW_Study_Managers') || PSAssignedResource.contains('DRDW_ERL')) {
                if(gogroup != 'All'){
                    lEventDays = [Select Id,Name,Date__c,DRDW_Event__c,DRDW_Event__r.DRDW_Activity__c,Allocation_Percentage__c,DRDW_Resource__c,Allocated_Hours__c,DRDW_Resource__r.Name__r.Name,DRDW_Resource__r.Hours_Available_Per_Day__c,
                    Weekend__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__r.Name__c,DRDW_Event__r.DRDW_Activity__r.Title__c,
                    DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Planned_Study_Start_Date__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.GO_Preferred_End_Date__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Planned_Study_End_Date__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Preferred_Start_Date_Locked__c,
                    Go_Sub_Activities__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.GO_Preferred_Start_Date__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Study_Title__c,DRDW_Event__r.Event_Type__c                   
                    from DRDW_Event_Days__c where (DRDW_Resource__r.Department__c =: gogroup) and (Type__c =:'GO') and (DRDW_Event__r.DRDW_Activity__c != null)
                    and (DRDW_Event__r.DRDW_Activity__r.DRDW_Request__c != null) and (DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c != null) and (DRDW_Resource__r.Hours_Available_Per_Day__c!=null) and (DRDW_Resource__r.Name__c =: UserInfo.getUserId()) order by createddate desc limit 50000];
                }
                else{
                    lEventDays = [Select Id,Name,Date__c,DRDW_Event__c,DRDW_Event__r.DRDW_Activity__c,Allocation_Percentage__c,DRDW_Resource__c,Allocated_Hours__c,DRDW_Resource__r.Name__r.Name,DRDW_Resource__r.Hours_Available_Per_Day__c,
                    Weekend__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__r.Name__c,DRDW_Event__r.DRDW_Activity__r.Title__c,
                    DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Planned_Study_Start_Date__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.GO_Preferred_End_Date__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Planned_Study_End_Date__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Preferred_Start_Date_Locked__c,
                    Go_Sub_Activities__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.GO_Preferred_Start_Date__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Study_Title__c,DRDW_Event__r.Event_Type__c               
                    from DRDW_Event_Days__c where (Type__c =:'GO') and (DRDW_Event__r.DRDW_Activity__c != null) and (DRDW_Event__r.DRDW_Activity__r.DRDW_Request__c != null) and (DRDW_Resource__r.Hours_Available_Per_Day__c!=null) and (DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c != null)and (DRDW_Resource__r.Name__c =: UserInfo.getUserId()) order by createddate desc limit 50000];          
                }
            }
        } 

        for(DRDW_Event_Days__c oeventDays : lEventDays){
            setProjIds.add(oeventDays.DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c);
            setRequestIdsQuery.add(oeventDays.DRDW_Event__r.DRDW_Activity__r.DRDW_Request__c);
            if(mRequestIdEventIds.containsKey(oeventDays.DRDW_Event__r.DRDW_Activity__r.DRDW_Request__c)){
                setEventIds = mRequestIdEventIds.get(oeventDays.DRDW_Event__r.DRDW_Activity__r.DRDW_Request__c);
                setEventIds.add(oeventDays.DRDW_Event__c);
                mRequestIdEventIds.put(oeventDays.DRDW_Event__r.DRDW_Activity__r.DRDW_Request__c,setEventIds);
            }
            else{
                setEventIds = new set<Id>();
                setEventIds.add(oeventDays.DRDW_Event__c);
                mRequestIdEventIds.put(oeventDays.DRDW_Event__r.DRDW_Activity__r.DRDW_Request__c,setEventIds);             
            }
            system.debug('*before inside*'+mResourceIdProjectIdsRequestIds.keyset());             
            if(mResourceIdProjectIdsRequestIds.containsKey(oeventDays.DRDW_Resource__c)){
                mProjIdRequestIds = mResourceIdProjectIdsRequestIds.get(oeventDays.DRDW_Resource__c);
                if(mProjIdRequestIds.containsKey(oeventDays.DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c)){
                    setRequestIds = mProjIdRequestIds.get(oeventDays.DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c);
                    setRequestIds.add(oeventDays.DRDW_Event__r.DRDW_Activity__r.DRDW_Request__c);
                    mProjIdRequestIds.put(oeventDays.DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c,setRequestIds);
                }
                else{
                    setRequestIds = new set<Id>();
                    setRequestIds.add(oeventDays.DRDW_Event__r.DRDW_Activity__r.DRDW_Request__c);
                    mProjIdRequestIds.put(oeventDays.DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c,setRequestIds);             
                }  
                mResourceIdProjectIdsRequestIds.put(oeventDays.DRDW_Resource__c,mProjIdRequestIds);
            }
            else{
                mProjIdRequestIds = new Map<Id,set<Id>>();
                setRequestIds = new set<Id>();    
                setRequestIds.add(oeventDays.DRDW_Event__r.DRDW_Activity__r.DRDW_Request__c);
                mProjIdRequestIds.put(oeventDays.DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c,setRequestIds);
                mResourceIdProjectIdsRequestIds.put(oeventDays.DRDW_Resource__c,mProjIdRequestIds);
            }
            if(mEventIdEventDays.containsKey(oeventDays.DRDW_Event__c)){
                lEventDaysTemp = mEventIdEventDays.get(oeventDays.DRDW_Event__c);
                lEventDaysTemp.add(oeventDays);
                mEventIdEventDays.put(oeventDays.DRDW_Event__c,lEventDaysTemp);
            }
            else{
                lEventDaysTemp = new List<DRDW_Event_Days__c>();
                lEventDaysTemp.add(oeventDays);
                mEventIdEventDays.put(oeventDays.DRDW_Event__c,lEventDaysTemp);
            }
 
        }

        Map<Id,DRDW_Calender_Per_Roaster__c> mCalenderPerRoaster = new Map<Id,DRDW_Calender_Per_Roaster__c>([Select Id,Allocated_Date__c,Allocated_Hours__c,Allocation_Percentage__c,DRDW_Roaster__c from DRDW_Calender_Per_Roaster__c where (DRDW_Roaster__c in:mResourceIdProjectIdsRequestIds.keyset()) and (Allocation_Percentage__c != 0) and (Allocated_Hours__c != null) order by createddate desc limit 50000]);
        
        DRDW_Calender_Per_Roaster__c tempcalPerRoaster = new DRDW_Calender_Per_Roaster__c();
        mRoasterPerDayAllocation = new Map<Id,Map<Date,Decimal>>();
        mRoasterPerDayAllocationPer = new Map<Id,Map<Date,Decimal>>();
        Map<Date,Decimal> mDateAllocation;
        
        for(Id calPerRoaster : mCalenderPerRoaster.keyset()){
            tempcalPerRoaster = mCalenderPerRoaster.get(calPerRoaster);
            if(mRoasterPerDayAllocation.containsKey(tempcalPerRoaster.DRDW_Roaster__c)){
                mDateAllocation = mRoasterPerDayAllocation.get(tempcalPerRoaster.DRDW_Roaster__c);
                mDateAllocation.put(tempcalPerRoaster.Allocated_Date__c,tempcalPerRoaster.Allocated_Hours__c);
                mRoasterPerDayAllocation.put(tempcalPerRoaster.DRDW_Roaster__c,mDateAllocation);                     
            }
            else{
                mDateAllocation = new Map<Date,Decimal>();
                mDateAllocation.put(tempcalPerRoaster.Allocated_Date__c,tempcalPerRoaster.Allocated_Hours__c);
                mRoasterPerDayAllocation.put(tempcalPerRoaster.DRDW_Roaster__c,mDateAllocation);                                             
            }           
        }
        
        for(Id calPerRoaster : mCalenderPerRoaster.keyset()){
            tempcalPerRoaster = mCalenderPerRoaster.get(calPerRoaster);
            if(mRoasterPerDayAllocationPer.containsKey(tempcalPerRoaster.DRDW_Roaster__c)){
                mDateAllocation = mRoasterPerDayAllocationPer.get(tempcalPerRoaster.DRDW_Roaster__c);
                mDateAllocation.put(tempcalPerRoaster.Allocated_Date__c,tempcalPerRoaster.Allocation_Percentage__c);
                mRoasterPerDayAllocationPer.put(tempcalPerRoaster.DRDW_Roaster__c,mDateAllocation);                     
            }
            else{
                mDateAllocation = new Map<Date,Decimal>();
                mDateAllocation.put(tempcalPerRoaster.Allocated_Date__c,tempcalPerRoaster.Allocation_Percentage__c);
                mRoasterPerDayAllocationPer.put(tempcalPerRoaster.DRDW_Roaster__c,mDateAllocation);                                             
            }           
        }
        
        /*mActivity = new Map<Id,DRDW_Capability__c>([Select Id,Name,Title__c,DRDW_Request__c,Actual_End_Date__c,Actual_Start_Date__c,Planned_End_Date__c,Planned_Start_Date__c,Status__c,
        DRDW_Request__r.RecordType.DeveloperName,DRDW_Request__r.Project__c from DRDW_Capability__c where (Id in: mActIdEventDays.keyset()) and (DRDW_Request__c != null) and (DRDW_Request__r.Project__c != null) and (DRDW_Request__r.RecordType.DeveloperName = 'ERL')
        order by createddate desc limit 50000]);*/
        mResources = new Map<Id,DRDW_Resource__c>([Select Id,Days_Per_Week__c,Name__r.Name,Hours_Available_Per_Day__c from DRDW_Resource__c where (Id in: mResourceIdProjectIdsRequestIds.keyset()) and (Name__c != null) and (Hours_Available_Per_Day__c!=null)order by createddate desc limit 50000]);
        //query all the related projects
        mProject = new Map<Id,DRDW_Project__c>([Select Id,Name__c,Simplified_Project_Name__c,Species__c,recordtype.name from DRDW_Project__c where Id in: setProjIds]);
        mRequest = new Map<Id,DRDW_Cap_Request__c>([Select Id,Study_Title__c,Project__c,Status__c,Planned_Study_Start_Date__c,Preferred_Start_Date_Locked__c,Planned_Study_End_Date__c,GO_Preferred_Start_Date__c,GO_Preferred_End_Date__c,Request_Status__c from DRDW_Cap_Request__c where Id in: setRequestIdsQuery]);         
        
        mEvent = new Map<Id,DRDW_Event__c>([Select Id,Frequency_UI__c,Event_Dates_5_Day_Res__c,Event_Dates_7_Day_Res__c,Frequency__c,Name,Title__c,Status__c,Type__c,Event_Type__c,Event_Category__c,DRDW_Activity__c,DRDW_Activity__r.DRDW_Request__c,DRDW_Activity__r.Status__c,DRDW_Activity__r.DRDW_Request__r.Name,
            DRDW_Activity__r.DRDW_Request__r.Request_Status__c,DRDW_Activity__r.DRDW_Request__r.GO_Preferred_Start_Date__c,
            DRDW_Activity__r.DRDW_Request__r.Planned_Study_Start_Date__c,DRDW_Activity__r.DRDW_Request__r.GO_Preferred_End_Date__c,DRDW_Activity__r.DRDW_Request__r.Planned_Study_End_Date__c,DRDW_Activity__r.DRDW_Request__r.Preferred_Start_Date_Locked__c,
              DRDW_Activity__r.DRDW_Request__r.RecordType.DeveloperName,DRDW_Activity__r.DRDW_Request__r.Project__c,DRDW_Activity__r.DRDW_Request__r.Project__r.Name__c from DRDW_Event__c where (Id in: mEventIdEventDays.keyset()) and (DRDW_Activity__c != null) and (DRDW_Activity__r.DRDW_Request__c != null) and (DRDW_Activity__r.DRDW_Request__r.Project__c != null)  and (DRDW_Activity__r.DRDW_Request__r.RecordType.DeveloperName = 'GO')
            order by createddate desc limit 50000]);
            
        
        
    }

    //json generator
    public void jsonGenerator(){
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();
        for(Id resource : mResourceIdProjectIdsRequestIds.keySet()){
            Map<Date,Decimal> mDateAllocation = mRoasterPerDayAllocation.get(resource);
            Map<Date,Decimal> mDateAllocationPer = mRoasterPerDayAllocationPer.get(resource);
            gen.writeStartObject();            
            gen.writeStringField('title', mResources.get(resource).Name__r.Name);
            gen.writeStringField('folder', 'true');
            gen.writeStringField('sfdcId', mResources.get(resource).Id);
            gen.writeStringField('trigger','resource-modal');
            gen.writeFieldName('children');        
            gen.writeStartArray();
            Map<Id,Set<Id>> tempMapProjectReq = mResourceIdProjectIdsRequestIds.get(resource);
            for(Id proj : tempMapProjectReq.keyset()){
                Set<Id> tempSetReq = tempMapProjectReq.get(proj);
                DRDW_Project__c oProject = mProject.get(proj);
                gen.writeStartObject();            
                gen.writeStringField('title', oProject.Name__c);
                //Project Link
                string projectLink;
                if(oProject.recordtype.name == 'Assessment Project'){
                    projectLink = '/apex/DRDW_CreateAssessment?id='+oProject.id;
                } 
                if(oProject.recordtype.name == 'Generation Project'){
                    projectLink = '/apex/DRDW_CreateGeneration?id='+oProject.id;
                }
                if(oProject.recordtype.name == 'Idea Project'){
                    projectLink = '/apex/DRDW_CreateIdea?id='+oProject.id+'&isEdit=false';
                }
                gen.writeStringField('link', projectLink);                
                gen.writeStringField('folder', 'true');
                gen.writeFieldName('children');
                gen.writeStartArray();
                for(Id req : tempSetReq){
                    DRDW_Cap_Request__c reqObj = mRequest.get(req);
                    gen.writeStartObject();            
                    string studyTitle;
                    if(reqObj.Study_Title__c != null){
                        studyTitle = reqObj.Study_Title__c;
                    }
                    else{
                        studyTitle = '';
                    }
                    gen.writeStringField('title', studyTitle);
                    String reqLink = '/apex/DRDW_CreateGORequest?id='+req+'&isEdit=false';
                    gen.writeStringField('link', reqLink);                
                    gen.writeFieldName('columnFields');
                    gen.writeStartArray();
                    gen.writeStartObject();
                    String StartDateReq = '';
                    if((reqObj.Preferred_Start_Date_Locked__c == null || reqObj.Preferred_Start_Date_Locked__c == false) && reqObj.Planned_Study_Start_Date__c != null){
                        StartDateReq = string.valueOf(reqObj.Planned_Study_Start_Date__c.format());
                    }
                    else{
                        if(reqObj.GO_Preferred_Start_Date__c != null){
                            StartDateReq = string.valueOf(reqObj.GO_Preferred_Start_Date__c.format());
                        }
                    } 
                    String EndDateReq = '';
                    if((reqObj.Preferred_Start_Date_Locked__c == null || reqObj.Preferred_Start_Date_Locked__c == false) && reqObj.Planned_Study_End_Date__c != null){
                        EndDateReq = string.valueOf(reqObj.Planned_Study_End_Date__c.format());
                    }
                    else{
                        if(reqObj.GO_Preferred_End_Date__c != null){
                            EndDateReq = string.valueOf(reqObj.GO_Preferred_End_Date__c.format());
                        }
                    } 
                    gen.writeStringField('key', 'date');
                    gen.writeStringField('fieldType', 'text');
                    gen.writeStringField('value', StartDateReq +' - '+EndDateReq);
                    gen.writeEndObject();
                    gen.writeEndArray();            
                    
                    gen.writeFieldName('children');
                    gen.writeStartArray();
                    for(Id eventId : mRequestIdEventIds.get(req)){
                        gen.writeStartObject();
                        //gen.writeStringField('folder', '');
                        DRDW_Event__c event;
                        if(mEvent.containsKey(eventId)){
                            event = mEvent.get(eventId);
                        }
                        if(event != null){
                            If(event.Event_Type__c != null){
                                gen.writeStringField('title', event.Event_Type__c);
                            }
                            else{
                                gen.writeStringField('title', '');
                            }
                            String eventLink = '/apex/DRDW_Event?id='+event.Id+'&isEdit=false';
                            gen.writeStringField('link', eventLink);
                            gen.writeFieldName('children');
                            gen.writeStartArray();
                            //Decimal avgAllocationPerc = 0;
                            List<DRDW_Event_Days__c> eventDaysList = mEventIdEventDays.get(eventId);  
                            for(DRDW_Event_Days__c eventDays : eventDaysList ){
                                if(resource == eventDays.DRDW_Resource__c){
                                    gen.writeStartObject();
                                    If(eventDays.Go_Sub_Activities__c != null){
                                        gen.writeStringField('title', eventDays.Go_Sub_Activities__c);
                                    }
                                    else{
                                        gen.writeStringField('title', '');
                                    }
                                    gen.writeStringField('icon', 'false');
                                    gen.writeFieldName('columnFields');
                                    gen.writeStartArray();
                                    gen.writeStartObject();
                                    gen.writeStringField('key', 'startDate');
                                    //change
                                    gen.writeStringField('fieldType', 'text');
                                    String StartDateEvent;
                                    Decimal allocationperevent = 0;
                                    if(eventDays.Date__c != null){
                                        StartDateEvent = string.valueOf(eventDays.Date__c.format());
                                        if(mDateAllocationPer != null && mDateAllocationPer.containskey(eventDays.Date__c)){
                                            allocationperevent = mDateAllocationPer.get(eventDays.Date__c);
                                        }
                                    }
                                    else{
                                        StartDateEvent = '';                    
                                    } 
                                     
                                     
                                    gen.writeStringField('value', StartDateEvent);
                                    gen.writeEndObject();
                                    gen.writeStartObject();
                                    gen.writeStringField('key', 'endDate');
                                    gen.writeStringField('fieldType', 'text');
                                    gen.writeStringField('value', string.valueOf(eventDays.Allocated_Hours__c));
                                    gen.writeEndObject();
                                    gen.writeStartObject();
                                    gen.writeStringField('key', 'notes');
                                    gen.writeStringField('fieldType', 'text');
                                    gen.writeStringField('value', string.valueOf(math.round(allocationperevent))+'%');
                                    gen.writeStringField('color', colorCode(allocationperevent));
                                    gen.writeEndObject();
                                    gen.writeEndArray();
                                    gen.writeEndObject();
                                }
                            }
                            gen.writeEndArray();
                            gen.writeFieldName('columnFields');
                            gen.writeStartArray();
                            String eveDates = '';
                            String status;
                            if(event.Status__c != null){
                                status = string.valueOf(event.Status__c);
                            }
                            else{
                                status ='';                     
                            } 
                            
                            Integer Count = 0;  
                            Decimal avgAllocationPerc = 0; 
                            Decimal avgAllocPerRoaster = 0;  
                            //String formattedDates = '' ;
                            
                            /*if(event.Event_Dates__c != null){   
                                eveDates = event.Event_Dates__c;  
                                List<String> lStringDates = eveDates.split(',');
                                List<Date> lDates = new List<Date>();   
                                for(String stringDate : lStringDates){
                                    Date sDate = Date.valueOf(stringDate);
                                    //formattedDates = formattedDates + string.valueOf(sDate.format()) + ', ';
                                    Datetime dt = DateTime.newInstance(sDate, Time.newInstance(0, 0, 0, 0));
                                    string sday = dt.format('EEEE');
                                    if(mResources.get(resource).Days_Per_Week__c == '5' && sday != 'Saturday' && sday != 'Sunday'){  
                                        if(mDateAllocation.containsKey(sDate)){
                                                avgAllocationPerc = avgAllocationPerc + mDateAllocation.get(sDate);
                                            }
                                        Count++;
                                    }
                                    else if(mResources.get(resource).Days_Per_Week__c != '5'){
                                        if(mDateAllocation.containsKey(sDate)){
                                                avgAllocationPerc = avgAllocationPerc + mDateAllocation.get(sDate);
                                            }
                                        Count++;
                                    }   
                                }
                            }    */
                            
                            if((event.Event_Dates_5_Day_Res__c != null && mResources.get(resource).Days_Per_Week__c == '5') ||
                                 (event.Event_Dates_7_Day_Res__c != null && mResources.get(resource).Days_Per_Week__c != '5')){   
                                
                                if(mResources.get(resource).Days_Per_Week__c == '5'){
                                    eveDates = event.Event_Dates_5_Day_Res__c; 
                                }
                                else{
                                    eveDates = event.Event_Dates_7_Day_Res__c;
                                } 
                                List<String> lStringDates = eveDates.split(',');
                                List<Date> lDates = new List<Date>();   
                                for(String stringDate : lStringDates){
                                    Date sDate = Date.valueOf(stringDate);
                                    //formattedDates = formattedDates + string.valueOf(sDate.format()) + ', ';
                                    Datetime dt = DateTime.newInstance(sDate, Time.newInstance(0, 0, 0, 0));
                                    string sday = dt.format('EEEE');
                                    if(mDateAllocation.containsKey(sDate)){
                                            avgAllocationPerc = avgAllocationPerc + mDateAllocation.get(sDate);
                                        }
                                    Count++;   
                                }
                            }  
                            if(count != 0 && mResources.get(resource).Hours_Available_Per_Day__c != 0){
                                avgAllocPerRoaster = (avgAllocationPerc/(count * mResources.get(resource).Hours_Available_Per_Day__c))*100;
                            } 
                            /*if(formattedDates != ''){
                                formattedDates = formattedDates.removeend(', ');
                            }  */  
                            String prefStartDate = '';
                            String frequency = '';
                            if(reqObj.GO_Preferred_Start_Date__c != null){
                                prefStartDate = string.valueOf(reqObj.GO_Preferred_Start_Date__c.format());
                            }
                            if(event.Frequency_UI__c != null){
                                frequency = event.Frequency_UI__c.replace(',', ', ');
                            }     
                            gen.writeStartObject();
                            //change
                            gen.writeStringField('key', 'startDate');
                            gen.writeStringField('fieldType', 'text');
                            gen.writeStringField('value', prefStartDate + ': ' + frequency);
                            //gen.writeStringField('value', formattedDates);
                            gen.writeEndObject();
                            gen.writeStartObject();
                            gen.writeStringField('key', 'Hours');
                            gen.writeStringField('fieldType', 'text');
                            gen.writeStringField('value', '');
                            gen.writeEndObject();  
                            gen.writeStartObject();
                            gen.writeStringField('key', 'notes');
                            gen.writeStringField('fieldType', 'text');
                            system.debug('eventDaysList'+eventDaysList);
                            system.debug('avgAllocationPerc'+avgAllocationPerc);
                            gen.writeStringField('value', string.valueOf(math.round(avgAllocPerRoaster))+'%');
                            gen.writeStringField('color', colorCode(avgAllocPerRoaster));
                            gen.writeEndObject();                    
                            gen.writeEndArray(); 
                        }
                        gen.writeEndObject();
                    }
                    gen.writeEndArray();
                    gen.writeEndObject();          
                }
                gen.writeEndArray();
                gen.writeEndObject();     
            }
            gen.writeEndArray();
            gen.writeEndObject();              
        }
        gen.writeEndArray();
        // Get the JSON string.
        jsonStringResource = gen.getAsString();
        jsonStringResource = jsonStringResource.replace('null','""');
    }

    public PageReference exportResource(){  
        PageReference exportPage = new PageReference('/apex/DRDW_GOResourceViewExport?gogroup='+EncodingUtil.URLENCODE(gogroup,'UTF-8'));       
        exportPage.setredirect(false);
        return exportPage;    
    }

    Public void permissionSetAssignedResource(){
        PSAssignedResource = new set<String>();
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserInfo.getUserId()]); 
        for(PermissionSetAssignment opermission : lPermission){             
            PSAssignedResource.add(opermission.PermissionSet.Name);         
        } 
    }  

    public string colorCode(Decimal allocationPerc){
        if(allocationPerc <= 50){
            return 'green';            
        }
        else if(allocationPerc <= 75 && allocationPerc > 50){
            return 'yellow';  
        }
        else{
            return 'red';  
        }       
    }
}