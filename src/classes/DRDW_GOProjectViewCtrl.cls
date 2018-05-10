Public with Sharing Class DRDW_GOProjectViewCtrl{
    Public transient Map<Id,Map<Id,List<DRDW_Event__c>>> mProjectRequestEventDetails{get;set;}
    Public transient Map<Id,DRDW_Cap_Request__c> mRequest{get;set;}
    Public transient Map<Id,DRDW_Project__c> mProject{get;set;}
    Public transient Map<Id,List<DRDW_Event_Days__c>> mEventIdEventDays{get;set;}
    Public list<DRDW_Event__c> lEvent{get;set;}
    Public String requestStatus{get;set;}
    Public String jsonString{get;set;}
    Public DRDW_GOResourceViewCtrl resourceViewObject{get;set;}
    Public set<String> PSAssigned{get;set;}
    Public boolean showGOTab{get;set;}
    Public boolean showActivityButton {get;set;} 
    Public boolean showERLButton {get;set;}  
    Public DRDW_Capability__c oActivity{get;set;}
    Public List<SelectOption> lAreaPicklist{get;set;}
    Public List<SelectOption> lActivityPicklist{get;set;}
    Public Map<String,List<SelectOption>> mAreaPicklist{get;set;}
    Public DRDW_Assign_Resource__c oAssignResource{get;set;}
    Public boolean iserroredNext{get;set;}
    Public boolean firstPage{get;set;}
    Public boolean iserrored{get;set;}
    Public set<String> groupAssigned{get;set;}
    //Public boolean iserroredAssign{get;set;}
    Public boolean iserrorAssign {get;set;}
    Public List<resourceWrapper> lResourceWrapper{get;set;}
    Public string selectedResource{get;set;}
    Public DRDW_Capability__c selectedActivity{get;set;}
    Public DRDW_Event__c selectedEvent{get;set;}
    public string resourceId{get;set;}
    Public Map<id,DRDW_Event_Days__c> mEventDay = new Map<id,DRDW_Event_Days__c>();
    Public Boolean weekEnd{get;set;}
    Public List<Date> fiveeventdates{get;set;}
    Public List<Date> seveneventdates{get;set;}
    Map<Id,DRDW_Resource__c> mResources{get;set;}
    Public DRDW_Cap_Request__c oRequest{get;set;}
    Public id ModelReqId{get;set;}
    Public List<reqResWrapper> lreqResWrapper{get;set;}
    Public id resEventId{get;set;}
    Public List<wEventRes> lwEventRes{get;set;}
    Public Boolean showResEvent{get;set;}
    Public Boolean showAssignPanel{get;set;}
    Public List<SelectOption> lSubEvents{get; set;}
    public Boolean reqfirstPage{get;set;}
    public Boolean assignResBottomPanel{get;set;}
    public Boolean reqSecondPage{get;set;}
    public Integer index{get;set;}
    Public Id DeleteAssignId{get;set;}
    Public DRDW_Assign_Resource__c oSelectResource{get;set;}
    Public DRDW_Event__c lReqEventObj{get;set;}
    Public List<SelectOption> lStudyevents{get;set;}
    Public Map<String,String> mapofsubgroup{get;set;}
    Public Boolean isValid{get;set;}
   
    public DRDW_GOProjectViewCtrl() {
        system.debug('DRDW_GOProjectViewCtrl');
        requestStatus ='All';
        firstPage = true;
        showResEvent = false;
        isValid = false;
     /*   Schema.DescribeFieldResult describeResult = DRDW_Cap_Request__c.Lab_Testing_required__c.getDescribe();
        // get the picklist values from this describe result
        List<Schema.PicklistEntry> entries = describeResult.getPicklistValues();
        // list of options to be returned to the VF page
        lSubEvents = new List<SelectOption>();
        for (Schema.PicklistEntry pEntry : entries) {
            if (pEntry.isActive()) {
                lSubEvents.add(new SelectOption(pEntry.getValue(), pEntry.getLabel()));
            }
        }   */
         lStudyevents = new List<SelectOption>();
             For(GLBL_Global_List_of_Values__c oglbl : [Select Name,RecordType.developerName from GLBL_Global_List_of_Values__c where Active__c = True AND RecordType.DeveloperName = 'DRDW_Samples_To_Collect' order by name ASC]){
            System.debug('GLBL values'+oglbl.Name);
            lStudyevents.add(new SelectOption(oglbl.Name,oglbl.Name));
            }
        lSubEvents = new List<SelectOption>();
        mapofsubgroup = new Map<String,String>();
        For(GLBL_Global_List_of_Values__c oglbl : [Select Name,Parent__r.Name,RecordType.developerName from GLBL_Global_List_of_Values__c where Active__c = True AND RecordType.DeveloperName = 'DRDW_Elanco_Go_sub_Activity' order by name ASC]){
            System.debug('GLBL values'+oglbl.Name);
            lSubEvents.add(new SelectOption(oglbl.Name,oglbl.Name));
            if(!mapofsubgroup.containsKey(oglbl.Name)){
                mapofsubgroup.put(oglbl.Name,oglbl.Parent__r.Name);
            }  
            } 
        system.debug('subgroupmap'+mapofsubgroup);      
    }
    
    
    
    Public void executeWrapperGeneratorGO(){
        system.debug('executeWrapperGenerator');        
        permissionSetAssigned();
        groupAssigned();
        system.debug('**requestStatus'+requestStatus);
        queryDetails(requestStatus);
        jsonGenerator();
        resourceViewObject = new DRDW_GOResourceViewCtrl(new DRDW_GOProjectViewCtrl());
        oAssignResource = new DRDW_Assign_Resource__c();
        selectedEvent = new DRDW_Event__c();

    }
    
     public List<SelectOption> getStatusList() {

        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = DRDW_Cap_Request__c.Request_Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            options.add(new SelectOption(pickListVal.getLabel(),pickListVal.getLabel()));
        }
            options.add(new SelectOption('All','All'));
        return options; 
        
        
    }
    public List<SelectOption> getGroupList() {
    
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = DRDW_Assign_Resource__c.Group__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            options.add(new SelectOption(pickListVal.getLabel(),pickListVal.getLabel()));
        }
            options.add(new SelectOption('All','All'));
        return options;  
    }
      
    
    //query all the records required for the report
    Public void queryDetails(string requestStatus){
        list<DRDW_Event_Days__c> lEventDays = new list<DRDW_Event_Days__c>();
        List<DRDW_Event_Days__c> lEventDaysTemp;
        mProjectRequestEventDetails = new Map<Id,Map<Id,List<DRDW_Event__c>>>();
        mRequest = new Map<Id,DRDW_Cap_Request__c>(); 
        mProject = new Map<Id,DRDW_Project__c>(); 
        list<DRDW_Event__c> lEventTemp;
        Map<Id,List<DRDW_Event__c>> mRequestEventListTemp;
        //Map<Id,Map<Id,List<DRDW_Event__c>>> mProjectRequestEventDetailsTemp;
        Set<Id> reqId = new Set<Id>();
        Set<Id> eventId = new Set<Id>();
        lEvent = new list<DRDW_Event__c>();
        mEventIdEventDays = new Map<Id,List<DRDW_Event_Days__c>>();
        List<DRDW_Cap_Request__c> lrequest;
        //query all the activities 
        system.debug('**requestStatus'+requestStatus);
        if(requestStatus != 'All'){
            lEvent = [Select Id,Event_Dates__c,Name,Frequency_UI__c,Frequency__c,Title__c,Status__c,Type__c,Event_Type__c,Event_Category__c,DRDW_Activity__c,DRDW_Activity__r.DRDW_Request__c,DRDW_Activity__r.Status__c,DRDW_Activity__r.DRDW_Request__r.Name,
            DRDW_Activity__r.DRDW_Request__r.Request_Status__c,DRDW_Activity__r.DRDW_Request__r.GO_Preferred_Start_Date__c,
            DRDW_Activity__r.DRDW_Request__r.Planned_Study_Start_Date__c,DRDW_Activity__r.DRDW_Request__r.GO_Preferred_End_Date__c,DRDW_Activity__r.DRDW_Request__r.Planned_Study_End_Date__c,DRDW_Activity__r.DRDW_Request__r.Preferred_Start_Date_Locked__c,
              DRDW_Activity__r.DRDW_Request__r.RecordType.DeveloperName,DRDW_Activity__r.DRDW_Request__r.Project__c,DRDW_Activity__r.DRDW_Request__r.Project__r.Name__c from DRDW_Event__c where (DRDW_Activity__c != null) and (DRDW_Activity__r.DRDW_Request__c != null) and (DRDW_Activity__r.DRDW_Request__r.Project__c != null)  and (DRDW_Activity__r.DRDW_Request__r.RecordType.DeveloperName = 'GO') and (DRDW_Activity__r.DRDW_Request__r.Request_Status__c =: requestStatus)
            order by createddate desc limit 50000];
            
        }
        else{
            lEvent = [Select Id,Event_Dates__c,Name,Frequency_UI__c,Frequency__c,Title__c,Status__c,Type__c,Event_Type__c,Event_Category__c,DRDW_Activity__c,DRDW_Activity__r.DRDW_Request__c,DRDW_Activity__r.Status__c,DRDW_Activity__r.DRDW_Request__r.Name,
            DRDW_Activity__r.DRDW_Request__r.Request_Status__c,DRDW_Activity__r.DRDW_Request__r.GO_Preferred_Start_Date__c,
            DRDW_Activity__r.DRDW_Request__r.Planned_Study_Start_Date__c,DRDW_Activity__r.DRDW_Request__r.GO_Preferred_End_Date__c,DRDW_Activity__r.DRDW_Request__r.Planned_Study_End_Date__c,DRDW_Activity__r.DRDW_Request__r.Preferred_Start_Date_Locked__c,
              DRDW_Activity__r.DRDW_Request__r.RecordType.DeveloperName,DRDW_Activity__r.DRDW_Request__r.Project__c,DRDW_Activity__r.DRDW_Request__r.Project__r.Name__c from DRDW_Event__c where (DRDW_Activity__c != null) and (DRDW_Activity__r.DRDW_Request__c != null) and (DRDW_Activity__r.DRDW_Request__r.Project__c != null) and (DRDW_Activity__r.DRDW_Request__r.RecordType.DeveloperName = 'GO') order by createddate desc limit 50000];         
        }
        //to create map of (Request Id, List of Event)
        for(DRDW_Event__c oEvent : lEvent){
            reqId.add(oEvent.DRDW_Activity__r.DRDW_Request__c);
            eventId.add(oEvent.Id);

            If(mProjectRequestEventDetails.containsKey(oEvent.DRDW_Activity__r.DRDW_Request__r.Project__c)){
                mRequestEventListTemp = mProjectRequestEventDetails.get(oEvent.DRDW_Activity__r.DRDW_Request__r.Project__c);
                if(mRequestEventListTemp.containsKey(oEvent.DRDW_Activity__r.DRDW_Request__c)){
                    lEventTemp = mRequestEventListTemp.get(oEvent.DRDW_Activity__r.DRDW_Request__c);
                    lEventTemp.add(oEvent);
                    mRequestEventListTemp.put(oEvent.DRDW_Activity__r.DRDW_Request__c,lEventTemp);
                    mProjectRequestEventDetails.put(oEvent.DRDW_Activity__r.DRDW_Request__r.Project__c,mRequestEventListTemp);
                }
                else{
                    lEventTemp = new list<DRDW_Event__c>();
                    lEventTemp.add(oEvent);
                    mRequestEventListTemp.put(oEvent.DRDW_Activity__r.DRDW_Request__c,lEventTemp);
                    mProjectRequestEventDetails.put(oEvent.DRDW_Activity__r.DRDW_Request__r.Project__c,mRequestEventListTemp);
                }           
            }
            else{
                mRequestEventListTemp = new Map<Id,List<DRDW_Event__c>>();
                lEventTemp = new list<DRDW_Event__c>();
                lEventTemp.add(oEvent);
                mRequestEventListTemp.put(oEvent.DRDW_Activity__r.DRDW_Request__c,lEventTemp);
                mProjectRequestEventDetails.Put(oEvent.DRDW_Activity__r.DRDW_Request__r.Project__c,mRequestEventListTemp);          
            }
        }
        //if(PSAssigned.contains(DRDW Functional Head) || PSAssigned.contains(DRDW Senior Leadership User) || PSAssigned.contains(DRDW Business Admin)
        //  || PSAssigned.contains(DRDW Financial User)) 
        if(PSAssigned.contains('DRDW_GO_User') || PSAssigned.contains('DRDW_Functional_Head') || PSAssigned.contains('DRDW_Senior_Leadership_User') || PSAssigned.contains('DRDW_Business_Admin')
                || PSAssigned.contains('DRDW_Financial_User')) {
            lEventDays = [Select Id,Name,Date__c,DRDW_Event__c,DRDW_Event__r.DRDW_Activity__c,Allocation_Percentage__c,DRDW_Resource__c,Allocated_Hours__c,DRDW_Resource__r.Name__r.Name,
            Go_Sub_Activities__c,Frequency__c,Weekend__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c,DRDW_Resource__r.Name__c from DRDW_Event_Days__c where (Type__c =:'GO') and (DRDW_Event__r.DRDW_Activity__c != null)
            and (DRDW_Event__c in: eventId) and (DRDW_Resource__c != null) and (DRDW_Resource__r.Name__c != null) order by createddate desc limit 50000];
        }
        else{
            if(PSAssigned.contains('DRDW_Scientist') || PSAssigned.contains('DRDW_Project_Manager') || PSAssigned.contains('DRDW_Study_Managers') ) {
                lEventDays = [Select Id,Name,Date__c,DRDW_Event__c,DRDW_Event__r.DRDW_Activity__c,Allocation_Percentage__c,DRDW_Resource__c,Allocated_Hours__c,DRDW_Resource__r.Name__r.Name,
                Go_Sub_Activities__c,Frequency__c,Weekend__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c,DRDW_Resource__r.Name__c from DRDW_Event_Days__c where (Type__c =:'GO') and (DRDW_Event__r.DRDW_Activity__c != null)
                and (DRDW_Event__c in: eventId) and (DRDW_Resource__c != null) and (DRDW_Resource__r.Name__c =: UserInfo.getUserId()) order by createddate desc limit 50000];
            }
        }
        for(DRDW_Event_Days__c oeventDays : lEventDays){
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
        
        if(requestStatus != 'All'){
            lrequest = [Select Id,Name,Status__c,RecordType.DeveloperName,Project__c,Project__r.Name__c from DRDW_Cap_Request__c where (Project__c != null) and (RecordType.DeveloperName = 'GO') and (Request_Status__c =: requestStatus)
            order by createddate desc limit 50000];
        }
        else{
            lrequest = [Select Id,Name,Status__c,RecordType.DeveloperName,Project__c,Project__r.Name__c from DRDW_Cap_Request__c where (Project__c != null) and (RecordType.DeveloperName = 'GO')
            order by createddate desc limit 50000];
        
        }
        set<Id> tempProjId = new set<Id>();
        Map<Id,List<Id>> mProjReqList = new Map<Id,List<Id>>();
        List<Id> reqListId;
        for(DRDW_Cap_Request__c reqTemp : lrequest){
            tempProjId.add(reqTemp.Project__c);
            if(mProjReqList.containsKey(reqTemp.Project__c)){
                reqListId = mProjReqList.get(reqTemp.Project__c);
                reqListId.add(reqTemp.Id);
                mProjReqList.put(reqTemp.Project__c,reqListId);                     
            }
            else{
                reqListId = new List<Id>();
                reqListId.add(reqTemp.Id);
                mProjReqList.put(reqTemp.Project__c,reqListId);                         
            }           
        }
        Map<Id,DRDW_Project__c> mProjectTemp = new Map<Id,DRDW_Project__c>([Select Id,Name__c,Simplified_Project_Name__c,Species__c,recordtype.name from DRDW_Project__c where Id in: tempProjId]);
        for(Id projIdTemp : mProjectTemp.keySet()){
            if(mProjReqList.containskey(projIdTemp)){
                for(Id oReqTemp : mProjReqList.get(projIdTemp)){
                    if(mProjectRequestEventDetails.containsKey(projIdTemp)){
                        mRequestEventListTemp = mProjectRequestEventDetails.get(projIdTemp);
                        if(!mRequestEventListTemp.containsKey(oReqTemp)){
                            reqId.add(oReqTemp);
                            lEventTemp = new list<DRDW_Event__c>();
                            mRequestEventListTemp.put(oReqTemp,lEventTemp);
                            mProjectRequestEventDetails.Put(projIdTemp,mRequestEventListTemp);
                        }             
                    }
                    else{
                        reqId.add(oReqTemp);
                        mRequestEventListTemp = new Map<Id,List<DRDW_Event__c>>();
                        lEventTemp = new list<DRDW_Event__c>();
                        mRequestEventListTemp.put(oReqTemp,lEventTemp);
                        mProjectRequestEventDetails.Put(projIdTemp,mRequestEventListTemp);
                    }
                }   
            }   
        }

        //query all the related Request   
        mRequest = new Map<Id,DRDW_Cap_Request__c>([Select Id,Study_Title__c,Project__c,Status__c,Planned_Study_Start_Date__c,Preferred_Start_Date_Locked__c,Planned_Study_End_Date__c,GO_Preferred_Start_Date__c,GO_Preferred_End_Date__c,Request_Status__c from DRDW_Cap_Request__c where Id in: reqId]);         
        //query all the related projects
        mProject = new Map<Id,DRDW_Project__c>([Select Id,Name__c,Simplified_Project_Name__c,Species__c,recordtype.name from DRDW_Project__c where Id in: mProjectRequestEventDetails.keyset()]);
    }
    
    //json generator
    public void jsonGenerator(){
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();
        for(Id proj : mProjectRequestEventDetails.keySet()){
            if(mProject.containskey(proj)){
                DRDW_Project__c oProject = mProject.get(proj);
                gen.writeStartObject(); 
                If(oProject.Name__c != null){
                    gen.writeStringField('title', oProject.Name__c);
                }
                else{
                    gen.writeStringField('title', '');
                }               
                //gen.writeStringField('title', oProject.Name__c);
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
                Map<Id,list<DRDW_Event__c>> mapOfEvent = mProjectRequestEventDetails.get(proj);
                for(Id reqId : mapOfEvent.keySet()){
                    gen.writeStartObject();
                    DRDW_Cap_Request__c reqObj = mRequest.get(reqId);
                    string studyTitle;
                    if(reqObj.Study_Title__c != null){
                        studyTitle = reqObj.Study_Title__c;
                    }
                    else{
                        studyTitle = '';
                    }
                    gen.writeStringField('title',studyTitle);
                    gen.writeStringField('itemId',reqId);
                    gen.writeStringField('triggerSsbModal','ssb-modal');
                    String reqLink = '/apex/DRDW_CreateGORequest?id='+reqId+'&isEdit=false';
                    gen.writeStringField('link', reqLink);                
                    //gen.writeStringField('folder', 'false');
                    gen.writeFieldName('columnFields');
                    gen.writeStartArray();
                    gen.writeStartObject();
                    String StartDateReq = '';
                    if(reqObj.Preferred_Start_Date_Locked__c == false && reqObj.Planned_Study_Start_Date__c != null){
                        StartDateReq = string.valueOf(reqObj.Planned_Study_Start_Date__c.format());
                    }
                    else{
                        if(reqObj.GO_Preferred_Start_Date__c != null){
                            StartDateReq = string.valueOf(reqObj.GO_Preferred_Start_Date__c.format());
                        }
                    } 
                    String EndDateReq = '';
                    if(reqObj.Preferred_Start_Date_Locked__c == false && reqObj.Planned_Study_End_Date__c != null){
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
                    gen.writeStartObject();
                    gen.writeStringField('key', 'status');
                    gen.writeStringField('fieldType', 'text');
                    string statusreq;
                    if(reqObj.Request_Status__c != null){
                        statusreq = reqObj.Request_Status__c;
                    }
                    else{
                        statusreq = '';
                    }
                    gen.writeStringField('value', string.valueOf(statusreq));
                    gen.writeStringField('color', colorCode(statusreq,reqObj.Planned_Study_Start_Date__c));
                    gen.writeEndObject();
                    gen.writeEndArray();
                    gen.writeFieldName('children');
                    gen.writeStartArray();
                    for(DRDW_Event__c event : mapOfEvent.get(reqId)){
                        gen.writeStartObject();
                        If(event.Event_Type__c != null){
                            gen.writeStringField('title', event.Event_Type__c);
                        }
                        else{
                            gen.writeStringField('title', '');
                        }
                        String eventLink = '/apex/DRDW_Event?id='+event.Id+'&isEdit=false';
                        gen.writeStringField('link', eventLink);
                        //start 
                        gen.writeFieldName('children');
                        gen.writeStartArray();
                        if(mEventIdEventDays.containsKey(event.Id)){
                            for(DRDW_Event_Days__c oevent : mEventIdEventDays.get(event.Id)){
                                gen.writeStartObject();
                                If(oevent.DRDW_Resource__r.Name__c != null){
                                    If(oevent.Go_Sub_Activities__c != null){
                                        gen.writeStringField('title', oevent.DRDW_Resource__r.Name__r.Name +' ('+oevent.Go_Sub_Activities__c +') ');
                                    }
                                    else{
                                        gen.writeStringField('title', oevent.DRDW_Resource__r.Name__r.Name);
                                    }
                                }
                                else{
                                    gen.writeStringField('title', '');
                                }
                                /*String actvityLink = '/apex/DRDW_Activity?id='+activity.Id+'&isEdit=false';
                                gen.writeStringField('link', actvityLink); */                            
                                gen.writeFieldName('columnFields');
                                gen.writeStartArray();
                                gen.writeStartObject();
                                gen.writeStringField('key', 'startDate');
                                //change
                                gen.writeStringField('fieldType', 'text');
                                String StartDateEvent;
                                if(oevent.Date__c != null){
                                    StartDateEvent = string.valueOf(oevent.Date__c.format());
                                }
                                else{
                                    StartDateEvent ='';                    
                                } 
                                String allocatedHours;
                                if(oevent.Allocated_Hours__c != null){
                                    allocatedHours = string.valueOf(oevent.Allocated_Hours__c) + ' ' + 'Hours';
                                }
                                else{
                                    allocatedHours ='';                    
                                } 
                                String frequencyEventdays ='';
                                if(oevent.Frequency__c != null){
                                    frequencyEventdays = oevent.Frequency__c;
                                }
                                
                                gen.writeStringField('value', StartDateEvent + ': ' +frequencyEventdays);
                                gen.writeEndObject();
                                gen.writeStartObject();
                                gen.writeStringField('key', 'status');
                                gen.writeStringField('fieldType', 'text');
                                gen.writeStringField('class', 'pad-left-20');
                                gen.writeStringField('value', string.valueOf(allocatedHours));
                                gen.writeEndObject();
                                gen.writeEndArray();
                                gen.writeEndObject();
                            }
                        }
                        gen.writeEndArray();
                        //end 
                        gen.writeFieldName('columnFields');
                        gen.writeStartArray();
                        gen.writeStartObject();
                        gen.writeStringField('key', 'startDate');
                        //change
                        gen.writeStringField('fieldType', 'text');
                        /*String eveDates = '';
                        String formattedDates = '' ;
                        if(event.Event_Dates__c != null && event.Event_Dates__c != ''){
                            eveDates = event.Event_Dates__c;  
                            List<String> lStringDates = eveDates.split(',');
                            List<Date> lDates = new List<Date>();   
                            for(String stringDate : lStringDates){
                                Date sDate = Date.valueOf(stringDate);
                                formattedDates = formattedDates + string.valueOf(sDate.format()) + ', ';
                            }
                            formattedDates = formattedDates.removeend(', ');    
                        }*/
                        String status;
                        if(event.Status__c != null){
                            status = string.valueOf(event.Status__c);
                        }
                        else{
                            status ='';                     
                        } 
                        String prefStartDate = '';
                        String frequency = '';
                        if(reqObj.GO_Preferred_Start_Date__c != null){
                            prefStartDate = string.valueOf(reqObj.GO_Preferred_Start_Date__c.format());
                        }
                        if(event.Frequency_UI__c != null){
                            frequency = event.Frequency_UI__c;
                        }
                        gen.writeStringField('value', prefStartDate + ': ' + frequency);
                        gen.writeEndObject();
                        /*gen.writeStartObject();
                        gen.writeStringField('key', 'endDate');
                        gen.writeStringField('fieldType', 'text');
                        gen.writeStringField('value', EndDate);
                        gen.writeEndObject();*/
                        gen.writeStartObject();
                        gen.writeStringField('key', 'status');
                        gen.writeStringField('fieldType', 'text');
                        gen.writeStringField('value', status);
                        gen.writeEndObject();
                        gen.writeEndArray();
                        gen.writeEndObject();
                    }
                    gen.writeEndArray();
                    gen.writeEndObject();
                }
                gen.writeEndArray();
                gen.writeEndObject();
            }
        }
        gen.writeEndArray();
        // Get the JSON string.
        jsonString = gen.getAsString();
        jsonString = jsonString.replace('null','""');
        system.debug('jsonString'+jsonString);
        
        
    }
    
    public PageReference export(){  
        PageReference exportPage = new PageReference('/apex/DRDW_GOProjectViewExport');       
        exportPage.setredirect(false);
        return exportPage;
    }
    
    Public void permissionSetAssigned(){
        showERLButton =  true;         
        PSAssigned = new set<String>();
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserInfo.getUserId()]); 
        for(PermissionSetAssignment opermission : lPermission){             
            PSAssigned.add(opermission.PermissionSet.Name);         
        } 
        if(PSAssigned.contains('DRDW_ERL_Head') || PSAssigned.contains('DRDW_Functional_Head') || PSAssigned.contains('DRDW_Senior_Leadership_User') || PSAssigned.contains('DRDW_Business_Admin')
                || PSAssigned.contains('DRDW_Financial_User') || PSAssigned.contains('DRDW_Scientist') || PSAssigned.contains('DRDW_Project_Manager') || PSAssigned.contains('DRDW_Study_Managers') ) {
            showERLButton =  true;
        } 
        if(PSAssigned.contains('DRDW_GO_User') || PSAssigned.contains('DRDW_Business_Admin') || PSAssigned.contains('DRDW_Financial_User') ) {
            showActivityButton =  true;
        } 
        if(PSAssigned.contains('DRDW_GO_User') || PSAssigned.contains('DRDW_Leadership_User') ) {
            showGOTab =  false;
            showERLButton = false;
        } 
    }
    
    
    public void addError(string s) {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, s);
        ApexPages.addMessage(myMsg);
    }  
    
     public void addInfo(string s) {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, s);
        ApexPages.addMessage(myMsg);
    }  
    
    /* removed assign resource start public void initilizeAssignResource(){
        selectedResource = null;
        iserroredNext = false;
        iserroredAssign = false;
        oAssignResource = new DRDW_Assign_Resource__c();
        selectedActivity = new DRDW_Capability__c();
        selectedEvent = new DRDW_Event__c();
        firstPage = true;          
    } removed assign resource end */
    
     public void updateGroup(){
         if (Apexpages.currentPage().getParameters().containsKey('resourceId')){
                resourceId = Apexpages.currentPage().getParameters().get('resourceId');
            }
         if(resourceId!='' && !String.isBlank(resourceId)){
                DRDW_Resource__c oResource = [select id,Department__c from DRDW_Resource__c where id=:resourceId];
                if(oResource!=null){
                    oAssignResource.Group__c = oResource.Department__c;
                }
            }   
            
    }
    
    public void getEventResources(){
        showAssignPanel = true;
        oSelectResource = new DRDW_Assign_Resource__c();
        for(wEventRes oEventRes: lwEventRes){
            if(oEventRes.index == index){
                oSelectResource = oEventRes.oAssignResource;                               
            }        
        }
    }        
    
    //Added for NewGO//
    Public void deleteEvent(){
        system.debug('********* '+resEventId);
        DRDW_Event__c oEventRes = new DRDW_Event__c();
        oEventRes = [select id from DRDW_Event__c where id =:resEventId];
        if(oEventRes != NULL){
            delete oEventRes;
            ShowRequestData();
        }
        
    }
    Public void ssbAssignError(){
        for(wEventRes oEventRes: lwEventRes){
            if(oEventRes.index == index){
                oEventRes.oAssignResource.Frequency_UI__c = ''; 
                oEventRes.oAssignResource.Group__c = '';  
                oEventRes.oAssignResource.Hours_Per_Day__c = null; 
                oAssignResource = null;
            }        
        }
    }
    
    public void getchangeshowResEvent(){
        showResEvent = false;
        system.debug('**********************************************');
    }
    
    Public void addEventRes(){   
        boolean haveNewRow = false;
        for(reqResWrapper rw : lreqResWrapper){
            if(rw.isAdded){
                haveNewRow = true;
            }
        }
        if(!haveNewRow){
            DRDW_Event__c oaddEvt = new DRDW_Event__c();
            Set<String> addResource = new Set<String>();
            reqResWrapper oreqResWrapper = new reqResWrapper(oaddEvt,true,false,addResource,'');
            lreqResWrapper.add(oreqResWrapper);
        }
    }
    
    Public void editSubAct(){
        for(reqResWrapper rrw : lreqResWrapper){
            if(rrw.oEvt.Id == resEventId){
                rrw.EditSubAct = true;
                rrw.subActList = new List<String>();
                if(rrw.oEvt.Go_Sub_Activities__c !=Null && rrw.oEvt.Go_Sub_Activities__c !='' ){
                   String subAct = rrw.oEvt.Go_Sub_Activities__c;
                    subAct = subAct.substring(1,subAct.length()-1);
                    For(String s : subAct.split(', ')){
                        system.debug('s'+s);
                        rrw.subActList.add(s);
                    }
                }
            }
        }
    }
    
    Public void SaveEditSubAct(){
        DRDW_Event__c oEventRes = new DRDW_Event__c();
        oEventRes = [select id,Go_Sub_Activities__c from DRDW_Event__c where id =:resEventId];
        for(reqResWrapper rrw : lreqResWrapper){
            if(rrw.oEvt.Id == resEventId){
                String picklist = '[';   
                for(String s:rrw.subActList){
                    picklist = picklist + s +', ' ;
                }   
                if(picklist.length()>1)
                picklist = picklist.substring(0, picklist.length()-1);
                picklist = picklist.removeEnd(',') +']';                 
                oEventRes.Go_Sub_Activities__c = picklist;
                rrw.oEvt.Go_Sub_Activities__c = picklist;
                rrw.EditSubAct = false;
            }
        }
        update oEventRes;
        ShowRequestData();
    }
    
    Public void SaveEventRes(){
        DRDW_Cap_Request__c  SaveEvtRequest = new DRDW_Cap_Request__c();
        SaveEvtRequest = [select Study_Title__c,Planned_Study_Start_Date__c,Planned_Study_End_Date__c from DRDW_Cap_Request__c where id=:ModelReqId];
        DRDW_Capability__c oReqActivity =  new DRDW_Capability__c();
        oReqActivity = [Select id from DRDW_Capability__c where DRDW_Request__c =:oRequest.id];
        DRDW_Event__c oaddEvt = new DRDW_Event__c();
        integer count = 0;
        integer insideCount = 0;
         for(reqResWrapper rw :lreqResWrapper){                      
             if(rw.isAdded){
                 rw.oEvt.DRDW_Activity__c = oReqActivity.id;
                 rw.oEvt.Study_Title__c = SaveEvtRequest.Study_Title__c;
                 rw.oEvt.Status__c= 'Unassigned';
                 rw.oEvt.Type__c = 'GO';
                 rw.isAdded = false; 
                 insideCount = count;
                  String picklist = '[';  
                 system.debug('****'+ rw.subActList);
                for(String s:rw.subActList){
                    picklist = picklist + s +', ' ;
                }   
                if(picklist.length()>1)
                picklist = picklist.substring(0, picklist.length()-1);
                picklist = picklist.removeEnd(',') +']';                 
                rw.oEvt.Go_Sub_Activities__c = picklist;
             }  
             count++;       
        }
        upsert lreqResWrapper[insideCount].oEvt;
        ShowRequestData();
    }
    
    Public void DeleteReqEvent(){        
        DRDW_Assign_Resource__c oAssignRes = new DRDW_Assign_Resource__c();
        if(!Test.isRunningTest()){
        oAssignRes = [select id from DRDW_Assign_Resource__c where id =:DeleteAssignId];
        delete oAssignRes;
        ShowReqEvent();
        }
    }
    
    Public void ShowReqEvent(){     
        isvalid = false;
        reqfirstPage = false;
        reqsecondPage = true;
        oRequest = [select Request_Status__c,Study_Title__c,Planned_Study_Start_Date__c,Planned_Study_End_Date__c from DRDW_Cap_Request__c where id=:ModelReqId];
        DRDW_Capability__c oReqActivity =  new DRDW_Capability__c();
        oReqActivity = [Select id from DRDW_Capability__c where DRDW_Request__c =:oRequest.id];
        lReqEventObj = new DRDW_Event__c();
        
        lReqEventObj = [Select id,(Select DRDW_Resource__c from DRDW_Event_Days__r),Frequency_UI__c,Event_Type__c,Go_Sub_Activities__c,Frequency__c,DRDW_Activity__r.DRDW_Request__r.GO_Preferred_Start_Date__c,DRDW_Activity__r.Related_Project__c,Event_Dates_5_Day_Res__c,Event_Dates_7_Day_Res__c from DRDW_Event__c where id =: resEventId];
        system.debug('***** '+lReqEventObj);
        DRDW_Assign_Resource__c oAssignRes = new DRDW_Assign_Resource__c();
        Map<String,DRDW_Assign_Resource__c> mAssign = new Map<String,DRDW_Assign_Resource__c>();
        
        if(lReqEventObj != NULL){
        //oAssignRes = [Select DRDW_Event__c,Go_Sub_Activities__c,DRDW_Resources__r.Name,Group__c,Hours_Per_Day__c from DRDW_Assign_Resource__c where DRDW_Event__c =:lReqEvent.id];
           for(DRDW_Assign_Resource__c oAssResource : [Select DRDW_Event__c,Go_Sub_Activities__c,Frequency_UI__c,DRDW_Resources__r.Name__r.Name,Group__c,Hours_Per_Day__c from DRDW_Assign_Resource__c where DRDW_Event__c =:lReqEventObj.id]){
               mAssign.put(oAssResource.Go_Sub_Activities__c,oAssResource);
           }
        }
        List<String> sSubActivity = new List<String>();
        sSubActivity = lReqEventObj.Go_Sub_Activities__c.replace('[','').replace(']','').split(', ');
        lwEventRes = new List<wEventRes>();        
        For(String s: sSubActivity){
            if(!mAssign.ContainsKey(s)){
                wEventRes owEventRes = new wEventRes(s,lwEventRes.size()+1,oRequest,lReqEventObj,false,new DRDW_Assign_Resource__c(),oReqActivity,mapofsubgroup.get(s));  
                lwEventRes.add(owEventRes);
            }else{
                wEventRes owEventRes = new wEventRes(s,lwEventRes.size()+1,oRequest,lReqEventObj,true,mAssign.get(s),oReqActivity,mapofsubgroup.get(s));  
                lwEventRes.add(owEventRes);
            }
        }
        //showResEvent = false;
        system.debug('subactivities'+lwEventRes);
    }
    
    Public class wEventRes{
        Public String SubEventName{get;set;}
        Public DRDW_Cap_Request__c oRequest{get;set;}
        Public DRDW_Event__c oResEvent{get;set;}
        Public DRDW_Assign_Resource__c oAssignResource{get;set;}
        Public boolean issaved{get;set;}
        Public Integer index{get;set;}
        
        Public wEventRes(String SubEventName,Integer index,DRDW_Cap_Request__c oRequest,DRDW_Event__c oResEvent,boolean isSaved,DRDW_Assign_Resource__c oAssignResource,DRDW_Capability__c oReqActivity,String groupName){
            this.SubEventName = SubEventName;
            this.oRequest = oRequest;
            this.oResEvent = oResEvent;
            this.oAssignResource = oAssignResource;
            this.oAssignResource.Go_Sub_Activities__c = SubEventName;
            this.oAssignResource.Group__c = groupName;
            this.oAssignResource.DRDW_Event__c = oResEvent.id;
            this.oAssignResource.DRDW_Activity__c = oReqActivity.id;            
            this.isSaved= isSaved;
            this.index = index;
        }
    }
    
    Public void ShowRequestData(){
        reqfirstPage = true;
        reqsecondPage = false;
        showResEvent = false;
        if(Apexpages.currentPage().getParameters().containsKey('ModelReqId')){
           ModelReqId = Apexpages.currentPage().getParameters().get('ModelReqId');
        }
        oRequest = [select Request_Status__c,Study_Title__c,Planned_Study_Start_Date__c,Planned_Study_End_Date__c from DRDW_Cap_Request__c where id=:ModelReqId];
        DRDW_Capability__c oReqActivity =  new DRDW_Capability__c();
        oReqActivity = [Select id from DRDW_Capability__c where DRDW_Request__c =:oRequest.id];
        List<DRDW_Event__c> lReqEvent = new List<DRDW_Event__c>([Select id,(Select DRDW_Resource__c from DRDW_Event_Days__r),Event_Type__c,Go_Sub_Activities__c,Frequency__c,Frequency_UI__c,Display_Order__c from DRDW_Event__c where DRDW_Activity__c =: oReqActivity.id order by Order__c ASC NULLS LAST]);
        List<DRDW_Assign_Resource__c> LoAssignRes = new List<DRDW_Assign_Resource__c>([Select DRDW_Event__c,Go_Sub_Activities__c,DRDW_Resources__r.Name__r.Name,Group__c,Hours_Per_Day__c,Frequency_UI__c from DRDW_Assign_Resource__c where DRDW_Event__c in:lReqEvent]);
        lreqResWrapper = new List<reqResWrapper>();
        Map<id,Set<String>> mEvtRes = new Map<id,Set<String>>();
        Map<Id,Map<string,string>> mEventAssignResource = new Map<Id,Map<string,string>>();
        Map<string,string> tempSubActResource;
        //Set<String> sEventResource = new Set<String>();
        for(DRDW_Assign_Resource__c oAsRes : LoAssignRes){
            if(mEvtRes.ContainsKey(oAsRes.DRDW_Event__c)){               
                mEvtRes.get(oAsRes.DRDW_Event__c).add(String.Valueof(oAsRes.DRDW_Resources__r.Name__r.Name));
            }else{
                mEvtRes.put(oAsRes.DRDW_Event__c,new Set<String>{String.Valueof(oAsRes.DRDW_Resources__r.Name__r.Name)});
            } 
            if(mEventAssignResource.ContainsKey(oAsRes.DRDW_Event__c)){               
                tempSubActResource = mEventAssignResource.get(oAsRes.DRDW_Event__c);
                tempSubActResource.put(oAsRes.Go_Sub_Activities__c,oAsRes.DRDW_Resources__r.Name__r.Name);
                mEventAssignResource.put(oAsRes.DRDW_Event__c,tempSubActResource);
            }else{
                mEventAssignResource.put(oAsRes.DRDW_Event__c,new Map<string,string>{oAsRes.Go_Sub_Activities__c=>oAsRes.DRDW_Resources__r.Name__r.Name});
            }    
        }    
                      
        for(DRDW_Event__c oEvt : lReqEvent){ 
                tempSubActResource = new Map<string,string>();
                String subactRes = '';
                if(mEventAssignResource.ContainsKey(oEvt.Id) && oEvt.Go_Sub_Activities__c != null  && oEvt.Go_Sub_Activities__c != '[]'){
                    tempSubActResource = mEventAssignResource.get(oEvt.Id);
                    for(String subact : oEvt.Go_Sub_Activities__c.replace('[','').replace(']','').split(', ')){
                        if(tempSubActResource.containskey(subact)){
                            subactRes = subactRes + subact + ': ' + tempSubActResource.get(subact) + ', ';
                        }
                        else{
                            subactRes = subactRes + subact + ', ';
                        }
                    }     
                } 
                else{
                    for(String subact : oEvt.Go_Sub_Activities__c.replace('[','').replace(']','').split(', ')){
                        subactRes = subactRes + subact + ', ';
                    }     
                }
                subactRes = subactRes.removeEnd(', ');        
                if(mEvtRes.get(oEvt.id)!=null){
                    reqResWrapper oreqResWrapper = new reqResWrapper(oEvt,false,false,mEvtRes.get(oEvt.id),subactRes);
                    lreqResWrapper.add(oreqResWrapper);
                }else{
                    reqResWrapper oreqResWrapper = new reqResWrapper(oEvt,false,false,new Set<String>(),subactRes); 
                    lreqResWrapper.add(oreqResWrapper);   
                }                 
            }                  
    }
    
    Public class reqResWrapper{       
         Public DRDW_Event__c oEvt{get;set;}
         Public Boolean isAdded{get;set;}
         Public Boolean EditSubAct{get;set;}
         Public Set<String> Resource{get;set;}
         Public List<String> subActList{get;set;}
         Public String subActResString{get;set;}
        
         Public reqResWrapper(DRDW_Event__c oEvt,Boolean isAdded,Boolean EditSubAct,Set<String> Resource,String subActResString){
             this.oEvt = oEvt;
             this.isAdded = isAdded;
             this.EditSubAct = EditSubAct;
             this.Resource = Resource;
             this.subActResString = subActResString;
         }
    }
    
    Public void groupAssigned(){
        groupAssigned = new set<String>();
        List<String> allGroupIDs = new List<String>();
        for (GroupMember gm : [SELECT Id, group.id, group.DeveloperName, group.type FROM GroupMember where (UserOrGroupId = :UserInfo.getUserId())]){
            if(DRDW_Constants.groupCapAreaMapping.containsKey(gm.group.DeveloperName)){
                groupAssigned.add(DRDW_Constants.groupCapAreaMapping.get(gm.group.DeveloperName));
            }
        }
        groupAssigned.add('Other');
    }
    
    Public Decimal getTotalAllocatedHours(Date StartDate,Date EndDate,Decimal hours,String daysPerWeek){
        Integer Count = 0;        
        for(Date sDate = StartDate;sDate<=EndDate;){  
            Datetime dt = DateTime.newInstance(sDate, Time.newInstance(0, 0, 0, 0));
            string sday = dt.format('EEEE');
            // weekend is holiday
            if(daysPerWeek == '5'){
                if(sday != 'Saturday' && sday != 'Sunday'){
                    Count++;
                }
            }
            else{
                Count++;
            }
            sDate = sDate.addDays(1);            
        }     
        return Count * hours;        
    }
    
    Public String calculateFrequency(Date preferredDate,List<Date> frequencyDates){
        String frequency = '';
        frequencyDates.sort();
        for(Date d:frequencyDates){
            Integer diff = preferredDate.daysBetween(d);
            frequency +=diff+','; 
        }
        frequency = frequency.removeEnd(',');
        return frequency;                       
    }
       

    Public List<Date> calculateDates(String eDates){
    
        List<Date> lDates = new List<Date>();    
        List<String> lStringDates = eDates.split(',');                          
        for(String sDate:lStringDates){
            lDates.add(Date.valueOf(sDate));
            
            
        }
    return lDates;
    }
    
    Public Class resourceWrapper{
        Public String ResId{get;set;}
        Public String Name{get;set;}
        Public String conflicts{get;set;}
        Public Decimal alloc{get;set;}
        Public Boolean flag{get;set;}
        Public List<DRDW_Calender_Per_Roaster__c> lcalenderPerRoasterInsert;
        Public List<DRDW_Event_Days__c> leventDaysInsert;
        Public Id projectId;
        public resourceWrapper(String ResId,String name,String conflicts,Decimal alloc,Boolean flag,List<DRDW_Calender_Per_Roaster__c> lcalenderPerRoasterInsert,List<DRDW_Event_Days__c> leventDaysInsert,Id projectId){            
            this.ResId = ResId;
            this.Name = name;
            this.conflicts = conflicts;
            this.alloc = alloc;
            this.flag = flag;
            this.lcalenderPerRoasterInsert = lcalenderPerRoasterInsert;
            this.leventDaysInsert = leventDaysInsert;     
            this.projectId = projectId;       
        }
    }
    
    
    public string colorCode(String status,Date plannedstrtdate){
        if(status == 'Draft'){
            return 'black';  
        }
        else if((status == 'Submitted' || status == 'Triage' || status == 'In Queue') && plannedstrtdate != null){
            //if(plannedstrtdate.daysbetween(system.today()) < 90){
            if(system.today() < plannedstrtdate.addDays(-90)){
                return 'orange';            
            }
            else{
                return 'red';   
            }              
        }      
        else if(status == 'Re-Submit: Change Request' || status == 'Re-Submit: Data Request'){
            return 'blue';            
        }
        else if(status == 'Approved-Locked'){
            return 'green';  
        }
        else if(status == 'Rejected'){
            return 'black';  
        } 
        else if(status == 'Waitlisted'){
            return 'purple';  
        }       
        else{
            return 'black';
        }      
    }
    
    Public void ssbAssignResource(){
        
        oAssignResource = new DRDW_Assign_Resource__c();
        showAssignPanel = false;
        for(wEventRes oEventRes: lwEventRes){
            if(oEventRes.index == index){
                oAssignResource = oEventRes.oAssignResource;        
                selectedEvent = oEventRes.oResEvent;                       
            }        
        }
        try{
            iserrorAssign = false;
            if(oAssignResource.Go_Sub_Activities__c == null || oAssignResource.Group__c == null || oAssignResource.Hours_Per_Day__c == null ||
                oAssignResource.Frequency_UI__c == null){
                addError('Please enter manadtory values.');
                iserrorAssign = true;                                         
            }           
            if(oAssignResource.Hours_Per_Day__c < 0 || oAssignResource.Hours_Per_Day__c > 24){
                addError('Hours should be between 0 - 24');
                iserrorAssign = true;
            } 
            if(!isvalid){
                 addError('Frequency is not valid.Please verify');
                 iserrorAssign = true;
            }
            if(!iserrorAssign){
                oAssignResource.Frequency__c = convertFrequency(oAssignResource.Frequency_UI__c);
                system.debug('oAssignResource.Frequency__c *='+oAssignResource.Frequency__c);
                system.debug('oAssignResource.Frequency_UI__c *='+oAssignResource.Frequency_UI__c);
                if(oAssignResource.Frequency__c == ''){
                    addError('Please verify the frequency');
                    iserrorAssign = true;
                }
            }
            if(!iserrorAssign){
                //reqfirstpage = false;
                showAssignPanel = true;
                lResourceWrapper = new List<resourceWrapper>();
                Map<Date,DRDW_Calender_Per_Roaster__c> tempMapCalenderPerYear;
                Map<Id,Map<Date,DRDW_Calender_Per_Roaster__c>> mapResourceCPR = new Map<Id,Map<Date,DRDW_Calender_Per_Roaster__c>>();
               
                if(oAssignResource.Group__c!= null){                    
                    mResources = new Map<Id,DRDW_Resource__c>([select id,Name__r.Name,Hours_Available_Per_Day__c,Days_Per_Week__c from DRDW_Resource__c where Department__c =:oAssignResource.Group__c and Hours_Available_Per_Day__c != null and Hours_Available_Per_Day__c != 0 and Type__c ='GO']);
                }                
                List<DRDW_Calender_Per_Roaster__c> lcalenderRoaster = [Select id,Over_Allocated__c,Allocated_Date__c,Allocated_Hours__c,DRDW_Roaster__c from DRDW_Calender_Per_Roaster__c where DRDW_Roaster__c in:mResources.keyset() and Allocated_Date__c != null and Allocated_Hours__c != null limit 50000];
                List<DRDW_Calender_Per_Roaster__c> lcalenderPerRoasterInsert;
                List<DRDW_Event_Days__c> leventDaysInsert;
                for(DRDW_Calender_Per_Roaster__c cproaster : lcalenderRoaster){
                    if(mapResourceCPR.containsKey(cproaster.DRDW_Roaster__c)){
                        tempMapCalenderPerYear = mapResourceCPR.get(cproaster.DRDW_Roaster__c);
                        tempMapCalenderPerYear.put(cproaster.Allocated_Date__c,cproaster);
                        mapResourceCPR.put(cproaster.DRDW_Roaster__c,tempMapCalenderPerYear);
                    }
                    else{
                        tempMapCalenderPerYear = new Map<Date,DRDW_Calender_Per_Roaster__c>();
                        tempMapCalenderPerYear.put(cproaster.Allocated_Date__c,cproaster);
                        mapResourceCPR.put(cproaster.DRDW_Roaster__c,tempMapCalenderPerYear);                   
                    }            
                }
                tempMapCalenderPerYear = new Map<Date,DRDW_Calender_Per_Roaster__c>();
                for(Id oresId : mResources.keyset()){
                    DRDW_Resource__c ores = mResources.get(oresId);
                    Decimal TotalHours = oAssignResource.Frequency__c.split(',').size()*ores.Hours_Available_Per_Day__c;
                    Decimal i = 0;          
                    String conflicts = null;
                    Decimal alloc = 0;
                    lcalenderPerRoasterInsert = new List<DRDW_Calender_Per_Roaster__c>();
                    leventDaysInsert = new List<DRDW_Event_Days__c>();
                    if(mapResourceCPR.containsKey(oresId)){
                        tempMapCalenderPerYear = mapResourceCPR.get(oresId);                   
                    }
                    else{
                        tempMapCalenderPerYear = null;
                    }
                    
                    BusinessHours bh = [Select id from BusinessHours where name = 'DRDW_ERL_Business_Hours' limit 1];    
                    Map<String,String> fivedaymap = new Map<String,String>();
                    Map<String,String> sevendaymap = new Map<String,String>(); 
                    system.debug('oAssignResource.Frequency__c *='+oAssignResource.Frequency__c);
                    if(oAssignResource.Frequency__c != null && oAssignResource.Frequency__c !=''){
                        String frequency = oAssignResource.Frequency__c;
                        system.debug('oAssignResource.Frequency__c test*='+oAssignResource.Frequency__c);
                        frequency = frequency.trim();                  
                        List<String> ldiff = frequency.split(',');
                        ldiff.sort();   
                        oAssignResource.Allocation_Start_Date__c = null;
                        oAssignResource.Allocation_End_Date__c = null;
                        Date newTempInstance;
                        Datetime fivedayDate;
                        for(String days:ldiff){                        
                            Date input = selectedEvent.DRDW_Activity__r.DRDW_Request__r.GO_Preferred_Start_Date__c.addDays(Integer.valueOf(days));                                            
                            //  seveneventDates += DateTime.newInstance(input.year(), input.month(), input.day()).format('yyyy-MM-dd')+',';
                            sevendaymap.put(DateTime.newInstance(input.year(), input.month(), input.day()).format('yyyy-MM-dd'),days);      
                            //  fiveeventDates //+=BusinessHours.add(bh.id,mapEventDates.get(evt.DRDW_Activity__c),Integer.valueOf(days)*86400000).format('yyyy-MM-dd')+',';
                            system.debug('selectedEvent.DRDW_Activity__r.DRDW_Request__r.GO_Preferred_Start_Date__c'+selectedEvent.DRDW_Activity__r.DRDW_Request__r.GO_Preferred_Start_Date__c);    
                            system.debug('days'+days);
                            system.debug('Integer.valueOf(days)'+Integer.valueOf(days));
                            system.debug('bh.id'+bh.id);
                            system.debug('*'+DateTime.newInstance(selectedEvent.DRDW_Activity__r.DRDW_Request__r.GO_Preferred_Start_Date__c,Time.newInstance(10,10,10,10)));
                            fivedayDate = BusinessHours.addGMT(bh.id,DateTime.newInstance(selectedEvent.DRDW_Activity__r.DRDW_Request__r.GO_Preferred_Start_Date__c,Time.newInstance(10,10,10,10)),(Integer.valueOf(days)*86400000.0).longValue());
                            fivedaymap.put(fivedayDate.format('yyyy-MM-dd'),days); 
                            system.debug('fivedayDate '+fivedayDate );  
                            system.debug('fivedaymap '+fivedaymap);  

                            newTempInstance = date.newinstance(fivedayDate.year(), fivedayDate.month(), fivedayDate.day());
                            
                            if(oAssignResource.Allocation_Start_Date__c == null || oAssignResource.Allocation_Start_Date__c > input ){
                                oAssignResource.Allocation_Start_Date__c = input;
                            }
                            if(oAssignResource.Allocation_End_Date__c == null || oAssignResource.Allocation_End_Date__c < newTempInstance ){
                                oAssignResource.Allocation_End_Date__c = newTempInstance;                               
                            }
                        }
                    }
                   
                    fiveeventdates = calculateDatesNew(fivedaymap.keyset());
                    
                    seveneventdates = calculateDatesNew(sevendaymap.keyset());
                    system.debug('*****!oAssignResource.Allocation_Start_Date__c'+oAssignResource.Allocation_Start_Date__c);
                    system.debug('*****!oAssignResource.Allocation_End_Date__c'+oAssignResource.Allocation_End_Date__c);
                    
                    for(Date sDate = oAssignResource.Allocation_Start_Date__c ;sDate<=oAssignResource.Allocation_End_Date__c;){  
                        Datetime dt = DateTime.newInstance(sDate, Time.newInstance(0, 0, 0, 0));
                        string sday = dt.format('EEEE');
                     // weekend is holiday   
                        if(ores.Days_Per_Week__c == '5' && fiveeventdates.contains(sDate)){         
                            
                            DRDW_Calender_Per_Roaster__c ocalenderPerRoasterInsert = new DRDW_Calender_Per_Roaster__c();
                            DRDW_Event_Days__c oeventDaysInsert = new DRDW_Event_Days__c();
                            if(tempMapCalenderPerYear != null && tempMapCalenderPerYear.containsKey(sDate) && ores.Hours_Available_Per_Day__c != 0){ 
                                DRDW_Calender_Per_Roaster__c tempcproaster = tempMapCalenderPerYear.get(sDate);
                                ocalenderPerRoasterInsert = tempcproaster;
                                ocalenderPerRoasterInsert.Allocated_Hours__c = oAssignResource.Hours_Per_Day__c + tempcproaster.Allocated_Hours__c;
                                Datetime dtAllocate = DateTime.newInstance(tempcproaster.Allocated_Date__c, Time.newInstance(0, 0, 0, 0)); 
                                system.debug('*****!@#oAssignResource.Hours_Per_Day__c'+oAssignResource.Hours_Per_Day__c);
                                system.debug('*****!@#tempcproaster.Allocated_Hours__c'+tempcproaster.Allocated_Hours__c);
                                iF(((ocalenderPerRoasterInsert.Allocated_Hours__c)/ores.Hours_Available_Per_Day__c)*100 > 75){
                                    if(conflicts != null){
                                        conflicts = conflicts + ',' + dtAllocate.format('MMM d');
                                    }
                                    else{
                                        conflicts = '' + dtAllocate.format('MMM d');
                                    } 
                                }                   
                                i = i + tempcproaster.Allocated_Hours__c;                                    
                            }
                            else{
                                ocalenderPerRoasterInsert.Allocated_Date__c = sDate;
                                ocalenderPerRoasterInsert.Allocated_Hours__c = oAssignResource.Hours_Per_Day__c;
                                ocalenderPerRoasterInsert.DRDW_Roaster__c = ores.id;                                 
                                iF(((oAssignResource.Hours_Per_Day__c)/ores.Hours_Available_Per_Day__c)*100 > 75){
                                    if(conflicts != null){
                                        conflicts = conflicts + ',' + dt.format('MMM d');
                                    }
                                    else{
                                        conflicts = '' + dt.format('MMM d');
                                    }
                                }
                                system.debug('iii*****!@#oAssignResource.Hours_Per_Day__c'+oAssignResource.Hours_Per_Day__c);
                                system.debug('iii*****!@#tempcproaster.Allocated_Hours__c'+i);
                                i = i + oAssignResource.Hours_Per_Day__c; 
                            }
                            lcalenderPerRoasterInsert.add(ocalenderPerRoasterInsert);
                            oeventDaysInsert.Allocated_Hours__c = oAssignResource.Hours_Per_Day__c;
                            oeventDaysInsert.Date__c = sDate;
                            oeventDaysInsert.DRDW_Event__c = oAssignResource.DRDW_Event__c;
                            oeventDaysInsert.DRDW_Resource__c = ores.id;
                            oeventDaysInsert.Type__c = 'GO';
                            oeventDaysInsert.Frequency__c = fivedaymap.get(dt.format('yyyy-MM-dd'));
                            oeventDaysInsert.Go_Sub_Activities__c = oAssignResource.Go_Sub_Activities__c;
                            leventDaysInsert.add(oeventDaysInsert);
                            
                        }else if(ores.Days_Per_Week__c == '7' && seveneventdates.contains(sDate)){
                            
                                DRDW_Calender_Per_Roaster__c ocalenderPerRoasterInsert = new DRDW_Calender_Per_Roaster__c();
                                DRDW_Event_Days__c oeventDaysInsert = new DRDW_Event_Days__c();
                                if(tempMapCalenderPerYear != null && tempMapCalenderPerYear.containsKey(sDate) && ores.Hours_Available_Per_Day__c != 0){ 
                                    DRDW_Calender_Per_Roaster__c tempcproaster = tempMapCalenderPerYear.get(sDate);
                                    ocalenderPerRoasterInsert = tempcproaster;
                                    ocalenderPerRoasterInsert.Allocated_Hours__c = oAssignResource.Hours_Per_Day__c + tempcproaster.Allocated_Hours__c;
                                    Datetime dtAllocate = DateTime.newInstance(tempcproaster.Allocated_Date__c, Time.newInstance(0, 0, 0, 0)); 
                                    system.debug('*****!@#oAssignResource.Hours_Per_Day__c'+oAssignResource.Hours_Per_Day__c);
                                    system.debug('*****!@#tempcproaster.Allocated_Hours__c'+tempcproaster.Allocated_Hours__c);
                                    iF(((ocalenderPerRoasterInsert.Allocated_Hours__c)/ores.Hours_Available_Per_Day__c)*100 > 75){
                                        if(conflicts != null){
                                            conflicts = conflicts + ',' + dtAllocate.format('MMM d');
                                        }
                                        else{
                                            conflicts = '' + dtAllocate.format('MMM d');
                                        } 
                                    }                   
                                    i = i + tempcproaster.Allocated_Hours__c;                                    
                                }
                                else{
                                    ocalenderPerRoasterInsert.Allocated_Date__c = sDate;
                                    ocalenderPerRoasterInsert.Allocated_Hours__c = oAssignResource.Hours_Per_Day__c;
                                    ocalenderPerRoasterInsert.DRDW_Roaster__c = ores.id;                                 
                                    iF(((oAssignResource.Hours_Per_Day__c)/ores.Hours_Available_Per_Day__c)*100 > 75){
                                        if(conflicts != null){
                                            conflicts = conflicts + ',' + dt.format('MMM d');
                                        }
                                        else{
                                            conflicts = '' + dt.format('MMM d');
                                        }
                                    }
                                    system.debug('iii*****!@#oAssignResource.Hours_Per_Day__c'+oAssignResource.Hours_Per_Day__c);
                                    system.debug('iii*****!@#tempcproaster.Allocated_Hours__c'+i);
                                    i = i + oAssignResource.Hours_Per_Day__c; 
                                }
                                lcalenderPerRoasterInsert.add(ocalenderPerRoasterInsert);
                                oeventDaysInsert.Allocated_Hours__c = oAssignResource.Hours_Per_Day__c;
                                oeventDaysInsert.Date__c = sDate;
                                oeventDaysInsert.DRDW_Event__c = oAssignResource.DRDW_Event__c;
                                oeventDaysInsert.DRDW_Resource__c = ores.id;
                                oeventDaysInsert.Type__c = 'GO';
                                oeventDaysInsert.Frequency__c = sevendaymap.get(dt.format('yyyy-MM-dd'));
                                oeventDaysInsert.Go_Sub_Activities__c = oAssignResource.Go_Sub_Activities__c;
                                leventDaysInsert.add(oeventDaysInsert);
                        }                                                  
                        sDate = sDate.addDays(1);             
                    } 
                    if(TotalHours!=0){
                        alloc = math.round((i/TotalHours)*100);
                    }
                    resourceWrapper r = new resourceWrapper(ores.id,ores.Name__r.Name,conflicts,alloc,false,lcalenderPerRoasterInsert,leventDaysInsert,selectedEvent.DRDW_Activity__r.Related_Project__c);
                    lResourceWrapper.add(r);
                    system.debug('*****!@#'+r);
                    system.debug('*****!@#'+TotalHours);
                    system.debug('*****!@#'+i);
                }
            }          
        }
        catch(exception e){
            addError(e.getmessage());
            iserroredNext = true;
            iserrorAssign = true;
        }                   
    }
    
    Public void ssbSaveResource(){
        iserrorAssign = false;
        List<DRDW_Calender_Per_Roaster__c> lcalenderPerRoasterInsertFinal;
        List<DRDW_Event_Days__c> leventDaysInsertFinal;
        List<Id> projIdList = new List<Id>();
        selectedResource = apexpages.currentpage().getparameters().get('selectedResource');
        system.debug('selectedResource**'+selectedResource);
        if(selectedResource == null || selectedResource == ''){
            addError('Please select resource');
            iserrorAssign = true;
        }
        else{
            try{ 
            
            
               /*if(oAssignResource.DRDW_Event__c != null){                    
                   
                    oAssignResource.DRDW_Activity__c = selectedEvent.DRDW_Activity__c;
                    List<Date> lDates = new List<Date>();     
                  
                    if(selectedEvent!=null){  
                        String eventDates;                         
                        if(mResources.get(selectedResource).Days_Per_Week__c == '5'){
                             eventDates = selectedEvent.Event_Dates_5_Day_Res__c;
                        }else{
                             eventDates = selectedEvent.Event_Dates_7_Day_Res__c;
                        }                        
                        List<String> lStringDates = eventDates.split(',');                          
                        for(String sDate:lStringDates){
                            lDates.add(Date.valueOf(sDate));
                        }
                      }
                        lDates.sort();            
                        system.debug('++++++Dates++++++'+lDates);     
                        if((oAssignResource.Allocation_Start_Date__c >= lDates[0] && oAssignResource.Allocation_Start_Date__c <= lDates[lDates.size()-1]) || (oAssignResource.Allocation_End_Date__c >= lDates[0] && oAssignResource.Allocation_End_Date__c <= lDates[lDates.size()-1]) || (oAssignResource.Allocation_Start_Date__c <= lDates[0] && oAssignResource.Allocation_End_Date__c >= lDates[lDates.size()-1]) ){
                            
                        }else{
                        addError('Selected Allocation Dates are out of the range of Frequency');                                    
                        iserrorAssign = true;   
                        }                                                                                                          
                    }    */               
             
                for(resourceWrapper resWrap : lResourceWrapper) {
                    if(resWrap.ResId == selectedResource){
                        oAssignResource.DRDW_Resources__c = resWrap.ResId;
                        lcalenderPerRoasterInsertFinal = resWrap.lcalenderPerRoasterInsert;
                        leventDaysInsertFinal = resWrap.leventDaysInsert;
                        projIdList.add(resWrap.projectId);
                    } 
                }
                
                // added to check if assigned resource is already assigned to Activity on the selected days.                              
               /*List<DRDW_Event_Days__c> lEventDays = new List<DRDW_Event_Days__c>();                     
               lEventDays = [select id from DRDW_Event_Days__c where DRDW_Resource__c =:oAssignResource.DRDW_Resources__c and (Date__c>=:oAssignResource.Allocation_Start_Date__c and Date__c<=:oAssignResource.Allocation_End_Date__c) and DRDW_Event__c =: oAssignResource.DRDW_Event__c]; 
               system.debug('EventDays++++++++++'+lEventDays);
               if(lEventDays!=null && lEventDays.size()>0){
                         addError('This resource is already allocated to this same Event on the same day');
                         iserrorAssign = true;
                 }  */                
                system.debug('*****!@# oAssignResource '+oAssignResource);
                system.debug('*****!@# lcalenderPerRoasterInsertFinal'+lcalenderPerRoasterInsertFinal);
                system.debug('*****!@# leventDaysInsertFinal '+leventDaysInsertFinal);
                system.debug('*****!@# lprojIdList '+projIdList);
                if(!iserrorAssign){
                    update selectedEvent;                    
                    upsert lcalenderPerRoasterInsertFinal;
                    insert leventDaysInsertFinal;     
                    DRDW_RecordSharing.getRecordIdShare(projIdList,true,true,oAssignResource.DRDW_Resources__c); 
                    insert oAssignResource;       
                    isvalid = true;              
                }        
            }catch(exception e){
                if('Attempt to de-reference a null object' == e.getmessage() || 'Attempted to upsert a null list' == e.getmessage()){
                    addError('Some error occured.Please try again.');
                    iserrorAssign = true;
                }
                else{
                
                    addError(e.getmessage());
                    iserrorAssign = true;
                }
            }
        }                     
    }
    
    Public List<Date> calculateDatesNew(set<string> eDates){
        
        List<Date> lDates = new List<Date>();                  
        for(String sDate:eDates){
            lDates.add(Date.valueOf(sDate));  
        }
        return lDates;
    }
    
    Public static string convertFrequency(string frequencyUI){
        String frequencyBackend = '';
        
        try{            
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
            frequencyBackend = frequencyBackend.removeEnd(',');        
        }
        catch(exception e){
             system.debug('error'+e.getmessage());
        }   
        return frequencyBackend;
    }
    
}