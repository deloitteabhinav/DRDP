Public with Sharing Class DRDW_ERLResourceViewCtrl{
    Public transient Map<Id,DRDW_Project__c> mProject{get;set;}
    Public transient Map<Id,DRDW_Capability__c> mActivity{get;set;}
    Public transient Map<Id,DRDW_Resource__c> mResources{get;set;}
    Public transient Map<Id,List<DRDW_Event_Days__c>> mActIdEventDays{get;set;}
    Public transient Map<Id,set<Id>> mProjIdActIds{get;set;}
    Public transient Map<Id,set<Id>> mResourceIdProjectIds{get;set;}
    Public transient list<DRDW_Event_Days__c> lEventDays{get;set;}
    Public transient Map<Id,Map<Date,Decimal>> mRoasterPerDayAllocation{get;set;}
    Public transient Map<Id,Map<Date,Decimal>> mRoasterPerDayAllocationPer{get;set;}
    Public String activitArea{get;set;}
    Public String jsonStringResource{get;set;}
    Public set<String> PSAssignedResource{get;set;}
    Public transient Map<id,DRDW_Event_Days__c> mEventDay{get;set;}
    
    public DRDW_ERLResourceViewCtrl(DRDW_ERLProjectViewCtrl controller) {    
        activitArea ='All';
    }

    public DRDW_ERLResourceViewCtrl() {
       
    }

    Public void executeWrapperGenerator(){
        permissionSetAssignedResource();
        queryDetails(activitArea);//activitArea);
        jsonGenerator();
    }

    Public void executeWrapperGeneratorOnLoad(){
        activitArea ='All';
        permissionSetAssignedResource();
        queryDetails(activitArea);//activitArea);
        jsonGenerator();
    }

    Public void executeWrapperGeneratorExport(){
        permissionSetAssignedResource();
        activitArea = Apexpages.currentPage().getParameters().get('activitArea');
        system.debug('testvvvv****'+activitArea);
        queryDetails(activitArea);//activitArea);
        jsonGenerator();
         mEventDay = new Map<id,DRDW_Event_Days__c>();
        for(DRDW_Event_Days__c EventDay : lEventDays){
            mEventDay.put(EventDay.id,EventDay);
        }
    }
    
    
    /*public List<SelectOption> getActivityAreaList() {
        List<SelectOption> options = new List<SelectOption>();
        For(GLBL_Global_List_of_Values__c oglbl : [Select Name,RecordType.developerName from GLBL_Global_List_of_Values__c where Active__c = True AND RecordType.DeveloperName = 'DRDW_Elanco_Capability_Area' order by name ASC]){
        options.add(new SelectOption(oglbl.Name,oglbl.Name));
        }
        options.add(new SelectOption('All','All'));
        return options; 
    }*/
    //query all the records required for the report
    Public void queryDetails(string activitArea){
        lEventDays = new list<DRDW_Event_Days__c>();
        List<DRDW_Event_Days__c> lEventDaysTemp;
        set<Id> setActIds;
        set<Id> setProjIds;
        mActIdEventDays = new Map<Id,List<DRDW_Event_Days__c>>();
        mProjIdActIds = new Map<Id,set<Id>>();
        mResourceIdProjectIds = new Map<Id,set<Id>>();
        mActivity = new Map<Id,DRDW_Capability__c>(); 
        mResources = new Map<Id,DRDW_Resource__c>();
        mProject = new Map<Id,DRDW_Project__c>();
        if(PSAssignedResource.contains('DRDW_ERL_Head') || PSAssignedResource.contains('DRDW_Functional_Head') || PSAssignedResource.contains('DRDW_Senior_Leadership_User') || PSAssignedResource.contains('DRDW_Business_Admin')
                || PSAssignedResource.contains('DRDW_Financial_User')) {
            if(activitArea != 'All'){
                lEventDays = [Select Id,Name,Date__c,DRDW_Event__c,DRDW_Event__r.DRDW_Activity__c,Allocation_Percentage__c,DRDW_Resource__c,Allocated_Hours__c,DRDW_Resource__r.Name__r.Name,DRDW_Resource__r.Hours_Available_Per_Day__c,
                Weekend__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__r.Name__c,DRDW_Event__r.DRDW_Activity__r.Title__c,
                DRDW_Event__r.DRDW_Activity__r.Actual_End_Date__c,DRDW_Event__r.DRDW_Activity__r.Actual_Start_Date__c,DRDW_Event__r.DRDW_Activity__r.Planned_End_Date__c,DRDW_Event__r.DRDW_Activity__r.Planned_Start_Date__c
                from DRDW_Event_Days__c where (DRDW_Resource__r.Department__c =: activitArea) and (Type__c =:'ERL') and (DRDW_Event__r.DRDW_Activity__c != null)
                and (DRDW_Event__r.DRDW_Activity__r.DRDW_Request__c != null) and (DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c != null) and (DRDW_Resource__r.Hours_Available_Per_Day__c!=null) and (DRDW_Resource__r.Name__c != null) order by createddate desc limit 50000];
            }
            else{
                lEventDays = [Select Id,Name,Date__c,DRDW_Event__c,DRDW_Event__r.DRDW_Activity__c,Allocation_Percentage__c,DRDW_Resource__c,Allocated_Hours__c,DRDW_Resource__r.Name__r.Name,DRDW_Resource__r.Hours_Available_Per_Day__c,
                Weekend__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__r.Name__c,DRDW_Event__r.DRDW_Activity__r.Title__c,
                DRDW_Event__r.DRDW_Activity__r.Actual_End_Date__c,DRDW_Event__r.DRDW_Activity__r.Actual_Start_Date__c,DRDW_Event__r.DRDW_Activity__r.Planned_End_Date__c,DRDW_Event__r.DRDW_Activity__r.Planned_Start_Date__c
                from DRDW_Event_Days__c where (Type__c =:'ERL') and (DRDW_Event__r.DRDW_Activity__c != null) and (DRDW_Event__r.DRDW_Activity__r.DRDW_Request__c != null) and (DRDW_Resource__r.Hours_Available_Per_Day__c!=null) and (DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c != null)and (DRDW_Resource__r.Name__c != null) order by createddate desc limit 50000];          
            }
        }
        else{
            if(PSAssignedResource.contains('DRDW_Scientist') || PSAssignedResource.contains('DRDW_Project_Manager') || PSAssignedResource.contains('DRDW_Study_Managers') || PSAssignedResource.contains('DRDW_ERL')) {
                if(activitArea != 'All'){
                    lEventDays = [Select Id,Name,Date__c,DRDW_Event__c,DRDW_Event__r.DRDW_Activity__c,Allocation_Percentage__c,DRDW_Resource__c,Allocated_Hours__c,DRDW_Resource__r.Name__r.Name,DRDW_Resource__r.Hours_Available_Per_Day__c,
                    Weekend__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__r.Name__c,DRDW_Event__r.DRDW_Activity__r.Title__c,
                    DRDW_Event__r.DRDW_Activity__r.Actual_End_Date__c,DRDW_Event__r.DRDW_Activity__r.Actual_Start_Date__c,DRDW_Event__r.DRDW_Activity__r.Planned_End_Date__c,DRDW_Event__r.DRDW_Activity__r.Planned_Start_Date__c
                    from DRDW_Event_Days__c where (DRDW_Resource__r.Department__c =: activitArea) and (Type__c =:'ERL') and (DRDW_Event__r.DRDW_Activity__c != null)
                    and (DRDW_Event__r.DRDW_Activity__r.DRDW_Request__c != null) and (DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c != null) and (DRDW_Resource__r.Hours_Available_Per_Day__c!=null) and (DRDW_Resource__r.Name__c =: UserInfo.getUserId()) order by createddate desc limit 50000];
                }
                else{
                    lEventDays = [Select Id,Name,Date__c,DRDW_Event__c,DRDW_Event__r.DRDW_Activity__c,Allocation_Percentage__c,DRDW_Resource__c,Allocated_Hours__c,DRDW_Resource__r.Name__r.Name,DRDW_Resource__r.Hours_Available_Per_Day__c,
                    Weekend__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__r.Name__c,DRDW_Event__r.DRDW_Activity__r.Title__c,
                    DRDW_Event__r.DRDW_Activity__r.Actual_End_Date__c,DRDW_Event__r.DRDW_Activity__r.Actual_Start_Date__c,DRDW_Event__r.DRDW_Activity__r.Planned_End_Date__c,DRDW_Event__r.DRDW_Activity__r.Planned_Start_Date__c
                    from DRDW_Event_Days__c where (Type__c =:'ERL') and (DRDW_Event__r.DRDW_Activity__c != null) and (DRDW_Event__r.DRDW_Activity__r.DRDW_Request__c != null) and (DRDW_Resource__r.Hours_Available_Per_Day__c!=null) and (DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c != null)and (DRDW_Resource__r.Name__c =: UserInfo.getUserId()) order by createddate desc limit 50000];          
                }
            }
        } 
        
        for(DRDW_Event_Days__c oeventDays : lEventDays){
            if(mProjIdActIds.containsKey(oeventDays.DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c)){
                setActIds = mProjIdActIds.get(oeventDays.DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c);
                setActIds.add(oeventDays.DRDW_Event__r.DRDW_Activity__c);
                mProjIdActIds.put(oeventDays.DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c,setActIds);
            }
            else{
                setActIds = new set<Id>();
                setActIds.add(oeventDays.DRDW_Event__r.DRDW_Activity__c);
                mProjIdActIds.put(oeventDays.DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c,setActIds);             
            }             
            if(mResourceIdProjectIds.containsKey(oeventDays.DRDW_Resource__c)){
                setProjIds = mResourceIdProjectIds.get(oeventDays.DRDW_Resource__c);
                setProjIds.add(oeventDays.DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c);
                mResourceIdProjectIds.put(oeventDays.DRDW_Resource__c,setProjIds);
            }
            else{
                setProjIds = new set<Id>();
                setProjIds.add(oeventDays.DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c);
                mResourceIdProjectIds.put(oeventDays.DRDW_Resource__c,setProjIds);             
            }
            if(mActIdEventDays.containsKey(oeventDays.DRDW_Event__r.DRDW_Activity__c)){
                lEventDaysTemp = mActIdEventDays.get(oeventDays.DRDW_Event__r.DRDW_Activity__c);
                lEventDaysTemp.add(oeventDays);
                mActIdEventDays.put(oeventDays.DRDW_Event__r.DRDW_Activity__c,lEventDaysTemp);
            }
            else{
                lEventDaysTemp = new List<DRDW_Event_Days__c>();
                lEventDaysTemp.add(oeventDays);
                mActIdEventDays.put(oeventDays.DRDW_Event__r.DRDW_Activity__c,lEventDaysTemp);
            }
        }
        
        Map<Id,DRDW_Calender_Per_Roaster__c> mCalenderPerRoaster = new Map<Id,DRDW_Calender_Per_Roaster__c>([Select Id,Allocated_Date__c,Allocated_Hours__c,Allocation_Percentage__c,DRDW_Roaster__c from DRDW_Calender_Per_Roaster__c where (DRDW_Roaster__c in:mResourceIdProjectIds.keyset()) and (Allocation_Percentage__c != 0) and (Allocated_Hours__c != null) order by createddate desc limit 50000]);
        
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
        
        mActivity = new Map<Id,DRDW_Capability__c>([Select Id,Name,Title__c,DRDW_Request__c,Actual_End_Date__c,Actual_Start_Date__c,Planned_End_Date__c,Planned_Start_Date__c,Status__c,
        DRDW_Request__r.RecordType.DeveloperName,DRDW_Request__r.Project__c from DRDW_Capability__c where (Id in: mActIdEventDays.keyset()) and (DRDW_Request__c != null) and (DRDW_Request__r.Project__c != null) and (DRDW_Request__r.RecordType.DeveloperName = 'ERL')
        order by createddate desc limit 50000]);
        mResources = new Map<Id,DRDW_Resource__c>([Select Id,Name__r.Name,Hours_Available_Per_Day__c from DRDW_Resource__c where (Id in:mResourceIdProjectIds.keyset()) and (Name__c != null) and (Hours_Available_Per_Day__c!=null)order by createddate desc limit 50000]);
        //query all the related projects
        mProject = new Map<Id,DRDW_Project__c>([Select Id,Name__c,Simplified_Project_Name__c,Species__c,recordtype.name from DRDW_Project__c where Id in: mProjIdActIds.keyset()]);
        
        
    }

    //json generator
    public void jsonGenerator(){
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();
        for(Id resource : mResourceIdProjectIds.keySet()){
            Map<Date,Decimal> mDateAllocation = mRoasterPerDayAllocation.get(resource);
            Map<Date,Decimal> mDateAllocationPer = mRoasterPerDayAllocationPer.get(resource);
            gen.writeStartObject();            
            gen.writeStringField('title', mResources.get(resource).Name__r.Name);
            gen.writeStringField('folder', 'true');
            gen.writeStringField('sfdcId', mResources.get(resource).Id);
            gen.writeStringField('trigger','resource-modal');
            gen.writeFieldName('children');        
            gen.writeStartArray();
            for(Id proj : mResourceIdProjectIds.get(resource)){
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
                for(Id actId : mProjIdActIds.get(proj)){
                    gen.writeStartObject();
                    //gen.writeStringField('folder', '');
                    DRDW_Capability__c activity;
                    system.debug('actId*****'+actId);
                    if(mActivity.containsKey(actId)){
                        activity = mActivity.get(actId);
                    }
                    if(activity != null){
                        If(activity.Title__c != null){
                            gen.writeStringField('title', activity.Title__c);
                        }
                        else{
                            gen.writeStringField('title', '');
                        }
                        String actvityLink = '/apex/DRDW_ViewActivity?id='+activity.Id+'&isEdit=false';
                        gen.writeStringField('link', actvityLink);
                        gen.writeFieldName('children');
                        gen.writeStartArray();
                        //Decimal avgAllocationPerc = 0;
                        List<DRDW_Event_Days__c> eventDaysList = mActIdEventDays.get(actId);  
                        for(DRDW_Event_Days__c eventDays : eventDaysList ){
                            if(resource == eventDays.DRDW_Resource__c){
                                gen.writeStartObject();
                                gen.writeStringField('title', '');
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
                                    /*if(mResources.get(resource).Hours_Available_Per_Day__c > 0){
                                        allocationperevent = (mDateAllocation.get(eventDays.Date__c)/mResources.get(resource).Hours_Available_Per_Day__c)*100;
                                    }  */
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
                                //avgAllocationPerc = avgAllocationPerc + eventDays.Allocation_Percentage__c;
                            }
                        }
                        gen.writeEndArray();
                        gen.writeFieldName('columnFields');
                        gen.writeStartArray();
                        gen.writeStartObject();
                        //change
                        gen.writeStringField('key', 'startDate');
                        gen.writeStringField('fieldType', 'text');
                        String StartDate;
                        Date StartDateCal;
                        Date EndDateCal;
                        if(activity.Actual_Start_Date__c != null){
                            StartDate = string.valueOf(activity.Actual_Start_Date__c.format());
                            StartDateCal = activity.Actual_Start_Date__c;
                        }
                        else{
                            if(activity.Planned_Start_Date__c != null){
                                StartDate = string.valueOf(activity.Planned_Start_Date__c.format());
                                StartDateCal = activity.Planned_Start_Date__c;
                            }
                            else{
                                StartDate ='';                    
                            }
                        } 
                        String EndDate;
                        if(activity.Actual_End_Date__c != null){
                            EndDate = string.valueOf(activity.Actual_End_Date__c.format());
                            EndDateCal = activity.Actual_End_Date__c;
                        }
                        else{
                            if(activity.Planned_End_Date__c != null){
                                EndDate = string.valueOf(activity.Planned_End_Date__c.format());
                                EndDateCal = activity.Planned_End_Date__c;
                            }
                            else{
                                EndDate ='';                    
                            } 
                        }
                        Integer Count = 0;  
                        Decimal avgAllocationPerc = 0; 
                        Decimal avgAllocPerRoaster = 0;  
                        if((StartDateCal != null) && (EndDateCal != null) && mDateAllocation != null && mDateAllocation.size() > 0){   
                            for(Date sDate = StartDateCal;sDate<=EndDateCal;){ 
                                Datetime dt = DateTime.newInstance(sDate, Time.newInstance(0, 0, 0, 0));
                                string sday = dt.format('EEEE');
                                if(sday != 'Saturday' && sday != 'Sunday'){
                                    if(mDateAllocation.containsKey(sDate)){
                                        avgAllocationPerc = avgAllocationPerc + mDateAllocation.get(sDate);
                                    }
                                    Count++;
                                }
                                sDate = sDate.addDays(1);            
                            }
                        }
                        if(count != 0 && mResources.get(resource).Hours_Available_Per_Day__c != 0){
                            avgAllocPerRoaster = (avgAllocationPerc/(count * mResources.get(resource).Hours_Available_Per_Day__c))*100;
                        }      
                        
                        gen.writeStringField('value', StartDate+' - '+EndDate);
                        gen.writeEndObject();
                        gen.writeStartObject();
                        gen.writeStringField('key', 'endDate');
                        gen.writeStringField('fieldType', 'text');
                        gen.writeStringField('value', '');
                        gen.writeEndObject();
                        gen.writeStartObject();
                        gen.writeStringField('key', 'notes');
                        gen.writeStringField('fieldType', 'text');
                        system.debug('eventDaysList'+eventDaysList);
                        system.debug('avgAllocationPerc'+avgAllocationPerc);
                        /*if(eventDaysList!= null && eventDaysList.Size() != 0){
                            system.debug('string.valueOf(avgAllocationPerc/eventDaysList.Size())**'+string.valueOf(avgAllocationPerc/eventDaysList.Size()));
                            gen.writeStringField('value', string.valueOf(math.round(avgAllocationPerc/eventDaysList.Size()))+'%');
                            gen.writeStringField('color', colorCode(avgAllocationPerc/eventDaysList.Size()));
                        }
                        else{*/
                        gen.writeStringField('value', string.valueOf(math.round(avgAllocPerRoaster))+'%');
                        gen.writeStringField('color', colorCode(avgAllocPerRoaster));
                        //}
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
        // Get the JSON string.
        jsonStringResource = gen.getAsString();
        jsonStringResource = jsonStringResource.replace('null','""');
    }

    public PageReference exportResource(){  
        PageReference exportPage = new PageReference('/apex/DRDW_ERLResourcetViewExport?activitArea='+EncodingUtil.URLENCODE(activitArea,'UTF-8'));       
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