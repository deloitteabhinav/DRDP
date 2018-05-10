Public with Sharing Class DRDW_ERLProjectViewCtrl{
    Public transient Map<Id,Map<Id,List<DRDW_Capability__c>>> mProjectRequestActivityDetails{get;set;}
    Public transient Map<Id,DRDW_Cap_Request__c> mRequest{get;set;}
    Public transient Map<Id,DRDW_Project__c> mProject{get;set;}
    Public transient Map<Id,List<DRDW_Event_Days__c>> mActIdEventDays{get;set;}
    Public list<DRDW_Capability__c> lActivity{get;set;}
    Public String activitStatus{get;set;}
    Public String jsonString{get;set;}
    Public DRDW_ERLResourceViewCtrl resourceViewObject{get;set;}
    Public set<String> PSAssigned{get;set;}
    Public boolean showERLTab{get;set;}
    Public boolean showActivityButton {get;set;} 
    Public boolean showGOButton {get;set;}  
    Public DRDW_Capability__c oActivity{get;set;}
    Public List<SelectOption> lAreaPicklist{get;set;}
    Public List<SelectOption> lActivityPicklist{get;set;}
    Public Map<String,List<SelectOption>> mAreaPicklist{get;set;}
    Public DRDW_Assign_Resource__c oAssignResource{get;set;}
    Public boolean iserroredNext{get;set;}
    Public boolean firstPage{get;set;}
    Public boolean iserrored{get;set;}
    Public set<String> groupAssigned{get;set;}
    Public boolean iserroredAssign{get;set;}
    Public List<resourceWrapper> lResourceWrapper{get;set;}
    Public string selectedResource{get;set;}
    Public DRDW_Capability__c selectedActivity{get;set;}
    public string resourceId{get;set;}
    Public Map<id,DRDW_Event_Days__c> mEventDay = new Map<id,DRDW_Event_Days__c>();
    
    public DRDW_ERLProjectViewCtrl() {
        system.debug('DRDW_ERLProjectViewCtrl');
        activitStatus ='All';
        firstPage = true;
    }
    
    Public void executeWrapperGeneratorERL(){
        system.debug('executeWrapperGenerator');        
        permissionSetAssigned();
        groupAssigned();
        queryDetails(activitStatus);//activitStatus);
        jsonGenerator();
        initilizeActivity();
        resourceViewObject = new DRDW_ERLResourceViewCtrl(new DRDW_ERLProjectViewCtrl());
        oAssignResource = new DRDW_Assign_Resource__c();
        //resourceViewObject.executeWrapperGeneratorOnLoad();
    }
    
    public List<SelectOption> getStatusList() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = DRDW_Capability__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            options.add(new SelectOption(pickListVal.getLabel(),pickListVal.getLabel()));
        }
        options.add(new SelectOption('All','All'));
        return options; 
    }
    public List<SelectOption> getActivityAreaList() {
        List<SelectOption> options = new List<SelectOption>();
        For(GLBL_Global_List_of_Values__c oglbl : [Select Name,RecordType.developerName from GLBL_Global_List_of_Values__c where Active__c = True AND RecordType.DeveloperName = 'DRDW_Elanco_Capability_Area' order by name ASC]){
            options.add(new SelectOption(oglbl.Name,oglbl.Name));
        }
        options.add(new SelectOption('All','All'));
        return options; 
    }
    
    //query all the records required for the report
    Public void queryDetails(string activitStatus){
        list<DRDW_Event_Days__c> lEventDays = new list<DRDW_Event_Days__c>();
        List<DRDW_Event_Days__c> lEventDaysTemp;
        mProjectRequestActivityDetails = new Map<Id,Map<Id,List<DRDW_Capability__c>>>();
        mRequest = new Map<Id,DRDW_Cap_Request__c>(); 
        mProject = new Map<Id,DRDW_Project__c>(); 
        list<DRDW_Capability__c> lActivityTemp;
        Map<Id,List<DRDW_Capability__c>> mRequestActivityListTemp;
        Map<Id,Map<Id,List<DRDW_Capability__c>>> mProjectRequestActivityDetailsTemp;
        Set<Id> reqId = new Set<Id>();
        Set<Id> actId = new Set<Id>();
        lActivity = new list<DRDW_Capability__c>();
        mActIdEventDays = new Map<Id,List<DRDW_Event_Days__c>>();
        //query all the activities 
        if(activitStatus != 'All'){
            lActivity = [Select Id,Name,Title__c,DRDW_Request__c,Actual_End_Date__c,Actual_Start_Date__c,Planned_End_Date__c,Planned_Start_Date__c,Status__c,DRDW_Request__r.Name,
            DRDW_Request__r.RecordType.DeveloperName,DRDW_Request__r.Project__c,DRDW_Request__r.Project__r.Name__c from DRDW_Capability__c where (DRDW_Request__c != null) and (DRDW_Request__r.Project__c != null) and (Status__c =: activitStatus) and (DRDW_Request__r.RecordType.DeveloperName = 'ERL')
            order by createddate desc limit 50000];
        }
        else{
            lActivity = [Select Id,Name,Title__c,DRDW_Request__c,Actual_End_Date__c,Actual_Start_Date__c,Planned_End_Date__c,Planned_Start_Date__c,Status__c,DRDW_Request__r.Name,
            DRDW_Request__r.RecordType.DeveloperName,DRDW_Request__r.Project__c,DRDW_Request__r.Project__r.Name__c from DRDW_Capability__c where (DRDW_Request__c != null) and (DRDW_Request__r.Project__c != null) and (DRDW_Request__r.RecordType.DeveloperName = 'ERL') order by createddate desc limit 50000];         
        }
        //to create map of (Request Id, List of Activity)
        for(DRDW_Capability__c oActivity : lActivity){
            reqId.add(oActivity.DRDW_Request__c);
            actId.add(oActivity.Id);
            If(mProjectRequestActivityDetails.containsKey(oActivity.DRDW_Request__r.Project__c)){
                mRequestActivityListTemp = mProjectRequestActivityDetails.get(oActivity.DRDW_Request__r.Project__c);
                if(mRequestActivityListTemp.containsKey(oActivity.DRDW_Request__c)){
                    lActivityTemp = mRequestActivityListTemp.get(oActivity.DRDW_Request__c);
                    lActivityTemp.add(oActivity);
                    mRequestActivityListTemp.put(oActivity.DRDW_Request__c,lActivityTemp);
                    mProjectRequestActivityDetails.put(oActivity.DRDW_Request__r.Project__c,mRequestActivityListTemp);
                }
                else{
                    lActivityTemp = new list<DRDW_Capability__c>();
                    lActivityTemp.add(oActivity);
                    mRequestActivityListTemp.put(oActivity.DRDW_Request__c,lActivityTemp);
                    mProjectRequestActivityDetails.put(oActivity.DRDW_Request__r.Project__c,mRequestActivityListTemp);
                }           
            }
            else{
                mRequestActivityListTemp = new Map<Id,List<DRDW_Capability__c>>();
                lActivityTemp = new list<DRDW_Capability__c>();
                lActivityTemp.add(oActivity);
                mRequestActivityListTemp.put(oActivity.DRDW_Request__c,lActivityTemp);
                mProjectRequestActivityDetails.Put(oActivity.DRDW_Request__r.Project__c,mRequestActivityListTemp);          
            }
        }
        //if(PSAssigned.contains(DRDW Functional Head) || PSAssigned.contains(DRDW Senior Leadership User) || PSAssigned.contains(DRDW Business Admin)
        //  || PSAssigned.contains(DRDW Financial User)) 
        if(PSAssigned.contains('DRDW_ERL_Head') || PSAssigned.contains('DRDW_Functional_Head') || PSAssigned.contains('DRDW_Senior_Leadership_User') || PSAssigned.contains('DRDW_Business_Admin')
                || PSAssigned.contains('DRDW_Financial_User')) {
            lEventDays = [Select Id,Name,Date__c,DRDW_Event__c,DRDW_Event__r.DRDW_Activity__c,Allocation_Percentage__c,DRDW_Resource__c,Allocated_Hours__c,DRDW_Resource__r.Name__r.Name,
            Weekend__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c,DRDW_Resource__r.Name__c from DRDW_Event_Days__c where (Type__c =:'ERL') and (DRDW_Event__r.DRDW_Activity__c != null)
            and (DRDW_Event__r.DRDW_Activity__c in: actId) and (DRDW_Resource__c != null) and (DRDW_Resource__r.Name__c != null) order by createddate desc limit 50000];
        }
        else{
            if(PSAssigned.contains('DRDW_Scientist') || PSAssigned.contains('DRDW_Project_Manager') || PSAssigned.contains('DRDW_Study_Managers') ) {
                lEventDays = [Select Id,Name,Date__c,DRDW_Event__c,DRDW_Event__r.DRDW_Activity__c,Allocation_Percentage__c,DRDW_Resource__c,Allocated_Hours__c,DRDW_Resource__r.Name__r.Name,
                Weekend__c,DRDW_Event__r.DRDW_Activity__r.DRDW_Request__r.Project__c,DRDW_Resource__r.Name__c from DRDW_Event_Days__c where (Type__c =:'ERL') and (DRDW_Event__r.DRDW_Activity__c != null)
                and (DRDW_Event__r.DRDW_Activity__c in: actId) and (DRDW_Resource__c != null) and (DRDW_Resource__r.Name__c =: UserInfo.getUserId()) order by createddate desc limit 50000];
            }
        }
        for(DRDW_Event_Days__c oeventDays : lEventDays){
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
        if(activitStatus == 'All'){
            List<DRDW_Cap_Request__c> lrequest = [Select Id,Name,Status__c,RecordType.DeveloperName,Project__c,Project__r.Name__c from DRDW_Cap_Request__c where (Project__c != null) and (RecordType.DeveloperName = 'ERL')
            order by createddate desc limit 50000];
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
                        if(mProjectRequestActivityDetails.containsKey(projIdTemp)){
                            mRequestActivityListTemp = mProjectRequestActivityDetails.get(projIdTemp);
                            if(!mRequestActivityListTemp.containsKey(oReqTemp)){
                                reqId.add(oReqTemp);
                                lActivityTemp = new list<DRDW_Capability__c>();
                                mRequestActivityListTemp.put(oReqTemp,lActivityTemp);
                                mProjectRequestActivityDetails.Put(projIdTemp,mRequestActivityListTemp);
                            }             
                        }
                        else{
                            reqId.add(oReqTemp);
                            mRequestActivityListTemp = new Map<Id,List<DRDW_Capability__c>>();
                            lActivityTemp = new list<DRDW_Capability__c>();
                            mRequestActivityListTemp.put(oReqTemp,lActivityTemp);
                            mProjectRequestActivityDetails.Put(projIdTemp,mRequestActivityListTemp);
                        }
                    }   
                }   
            }
        }
        //query all the related Request   
        mRequest = new Map<Id,DRDW_Cap_Request__c>([Select Id,Name,Project__c,Status__c from DRDW_Cap_Request__c where Id in: reqId]);         
        //query all the related projects
        mProject = new Map<Id,DRDW_Project__c>([Select Id,Name__c,Simplified_Project_Name__c,Species__c,recordtype.name from DRDW_Project__c where Id in: mProjectRequestActivityDetails.keyset()]);
    }
    
    //json generator
    public void jsonGenerator(){
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();
        for(Id proj : mProjectRequestActivityDetails.keySet()){
		    if(mProject.containsKey(proj)){
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
				Map<Id,list<DRDW_Capability__c>> mapOfActivity = mProjectRequestActivityDetails.get(proj);
				for(Id reqId : mapOfActivity.keySet()){
					gen.writeStartObject();
					gen.writeStringField('title', mRequest.get(reqId).Name);
					String reqLink = '/apex/DRDW_CreateERLRequest?id='+reqId+'&isEdit=false';
					gen.writeStringField('link', reqLink);                
					//gen.writeStringField('folder', 'false');
					gen.writeFieldName('columnFields');
					gen.writeStartArray();
					gen.writeStartObject();
					gen.writeStringField('key', 'date');
					gen.writeStringField('fieldType', 'text');
					gen.writeStringField('value', '');
					gen.writeEndObject();
					gen.writeStartObject();
					gen.writeStringField('key', 'status');
					gen.writeStringField('fieldType', 'text');
					gen.writeStringField('value', string.valueOf(mRequest.get(reqId).Status__c));
					gen.writeEndObject();
					gen.writeEndArray();
					gen.writeFieldName('children');
					gen.writeStartArray();
					for(DRDW_Capability__c activity : mapOfActivity.get(reqId)){
						gen.writeStartObject();
						If(activity.Title__c != null){
							gen.writeStringField('title', activity.Title__c);
						}
						else{
							gen.writeStringField('title', '');
						}
						String actvityLink = '/apex/DRDW_ViewActivity?id='+activity.Id+'&isEdit=false';
						gen.writeStringField('link', actvityLink);
						//start 
						gen.writeFieldName('children');
						gen.writeStartArray();
						if(mActIdEventDays.containsKey(activity.Id)){
							for(DRDW_Event_Days__c oevent : mActIdEventDays.get(activity.Id)){
								gen.writeStartObject();
								If(oevent.DRDW_Resource__r.Name__c != null){
									gen.writeStringField('title', oevent.DRDW_Resource__r.Name__r.Name);
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
								gen.writeStringField('value', StartDateEvent);
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
						String StartDate;
						if(activity.Actual_Start_Date__c != null){
							StartDate = string.valueOf(activity.Actual_Start_Date__c.format());
						}
						else{
							if(activity.Planned_Start_Date__c != null){
								StartDate = string.valueOf(activity.Planned_Start_Date__c.format());
							}
							else{
								StartDate ='';                    
							}
						} 
						String EndDate;
						if(activity.Actual_End_Date__c != null){
							EndDate = string.valueOf(activity.Actual_End_Date__c.format());
						}
						else{
							if(activity.Planned_End_Date__c != null){
								EndDate = string.valueOf(activity.Planned_End_Date__c.format());
							}
							else{
								EndDate ='';                    
							} 
						} 
						String status;
						if(activity.Status__c != null){
							status = string.valueOf(activity.Status__c);
						}
						else{
							status ='';                     
						} 
						gen.writeStringField('value', StartDate+' - '+EndDate);
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
        PageReference exportPage = new PageReference('/apex/DRDW_ERLProjectViewExport');       
        exportPage.setredirect(false);
        return exportPage;
    }
    
    Public void permissionSetAssigned(){
        showGOButton =  true;         
        PSAssigned = new set<String>();
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserInfo.getUserId()]); 
        for(PermissionSetAssignment opermission : lPermission){             
            PSAssigned.add(opermission.PermissionSet.Name);         
        } 
        if(PSAssigned.contains('DRDW_ERL_Head') || PSAssigned.contains('DRDW_Functional_Head') || PSAssigned.contains('DRDW_Senior_Leadership_User') || PSAssigned.contains('DRDW_Business_Admin')
                || PSAssigned.contains('DRDW_Financial_User') || PSAssigned.contains('DRDW_Scientist') || PSAssigned.contains('DRDW_Project_Manager') || PSAssigned.contains('DRDW_Study_Managers') ) {
            showERLTab =  true;
        } 
        if(PSAssigned.contains('DRDW_ERL_Head') || PSAssigned.contains('DRDW_Functional_Head') || PSAssigned.contains('DRDW_Business_Admin') || PSAssigned.contains('DRDW_Financial_User') ) {
            showActivityButton =  true;
        } 
        if(PSAssigned.contains('DRDW_ERL_Head') || PSAssigned.contains('DRDW_Functional_Head') || PSAssigned.contains('DRDW_Leadership_User') ) {
            showGOButton =  false;
        } 
    }
    
    Public void saveActivity(){
        try{
            DRDW_Cap_Request__c oRequest = new DRDW_Cap_Request__c();
            iserrored = false;
            if(oActivity.DRDW_Request__c == null){
                addError('Please enter mandatory values.');
                iserrored = true;
            }
            else{
                system.debug('oActivity.DRDW_Request__c'+oActivity.DRDW_Request__c);
                oRequest = [Select Id,Name,Project__c,Planned_End_Date__c,Planned_Start_Date__c,Actual_Start_Date__c,Actual_End_Date__c from DRDW_Cap_Request__c where Id =: oActivity.DRDW_Request__c limit 1];
            }
            if(oActivity.Capability__c == null || oActivity.Capability_Area__c == null|| oActivity.Planned_Start_Date__c == null || oActivity.Planned_End_Date__c == null || 
                    oActivity.Title__c == null ){
                addError('Please enter mandatory values.');
                iserrored = true;
            }               
            if(oActivity.Planned_Start_Date__c > oActivity.Planned_End_Date__c){
                addError('Planned End Date cannot be before the Planned Start Date');
                iserrored = true;
            }
            if(oActivity.Actual_Start_Date__c > oActivity.Actual_End_Date__c){
                addError('Actual End Date cannot be before Actual Start Date');
                iserrored = true;
            }
            if((oActivity.Planned_Start_Date__c < oRequest.Planned_Start_Date__c) || (oActivity.Actual_Start_Date__c < oRequest.Actual_Start_Date__c)){
                addError('Planned Start Date and Actual Start Date cannot be before dates of Request');
                iserrored = true;
            }   
            if((oActivity.Planned_End_Date__c > oRequest.Planned_End_Date__c ) || (oActivity.Actual_End_Date__c > oRequest.Actual_End_Date__c)){
                addError('Planned End Date and Actual End Date cannot be after dates of Request');
                iserrored = true;
            }  
            if(!iserrored){
                Id caprectypeid = Schema.SObjectType.DRDW_Capability__c.getRecordTypeInfosByName().get('Request Activity').getRecordTypeId();
                oActivity.RecordTypeId = caprectypeid;
                oActivity.Related_Project__c = oRequest.Project__c;
                oActivity.Status__c = 'Unassigned';
                oActivity.Type__c = 'ERL';
                insert oActivity;
            }    
        }catch(exception e){
            iserrored = true;
            if(e.getmessage().contains('DUPLICATE_VALUE')){
                addError('The activity with this title already exist.');
            }
            else{
                addError(e.getmessage());
            }
        }                   
    }
    
    public void addError(string s) {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, s);
        ApexPages.addMessage(myMsg);
    }  
    
    public Pagereference initilizeActivity() {
        lAreaPicklist = new List<SelectOption>();
        mAreaPicklist = new Map<String,List<SelectOption>>();
        for(GLBL_Global_List_of_Values__c oglbl : [Select Name,RecordType.developerName from GLBL_Global_List_of_Values__c where Active__c = True AND RecordType.DeveloperName = 'DRDW_Elanco_Capability_Area' order by name ASC]){
            lAreaPicklist.add(new SelectOption(oglbl.Name,oglbl.Name));                
        }
        lAreaPicklist.add(new SelectOption('Other','Other'));
        for(GLBL_Global_List_of_Values__c oglbl : [Select Name,RecordType.developerName,Parent__r.Name from GLBL_Global_List_of_Values__c where Active__c = True AND RecordType.DeveloperName = 'DRDW_Elanco_Capability' order by name ASC]){
            if(mAreaPicklist.containsKey(oglbl.Parent__r.Name)){
                mAreaPicklist.get(oglbl.Parent__r.Name).add(new SelectOption(oglbl.Name,oglbl.Name));
            }else{
                mAreaPicklist.put(oglbl.Parent__r.Name,New List<SelectOption>{new SelectOption(oglbl.Name,oglbl.Name)});  
            }
        }
        oactivity = new DRDW_Capability__c();
        return null;
    } 
    
    public void initilizeAssignResource(){
        selectedResource = null;
        iserroredNext = false;
        iserroredAssign = false;
        oAssignResource = new DRDW_Assign_Resource__c();
        selectedActivity = new DRDW_Capability__c();
        firstPage = true;
    }
    
    Public void validateActivityArea(){
        selectedActivity = new DRDW_Capability__c();
        DRDW_Event__c selectedEvent = new DRDW_Event__c();
        if(oAssignResource.DRDW_Activity__c == null){
            iserroredNext = true;
            addError('Please enter manadtory values.');
        }
        else{
            try{
                selectedActivity = [Select Id,Name,Title__c,Capability_Area__c,Actual_Start_Date__c,Planned_Start_Date__c,Actual_End_Date__c,Planned_End_Date__c,Proposed_Start_Date__c,Related_Project__c from DRDW_Capability__c where Id=:oAssignResource.DRDW_Activity__c limit 1];  
                selectedEvent = [Select Id,Name,DRDW_Activity__c from DRDW_Event__c where DRDW_Activity__c=:oAssignResource.DRDW_Activity__c limit 1]; 
                oAssignResource.Activity_Area__c = selectedActivity.Capability_Area__c;   
                if(selectedEvent != null){
                    oAssignResource.DRDW_Event__c = selectedEvent.Id;  
                }
                if(PSAssigned.contains('DRDW_Functional_Head')) {
                    system.debug('groupAssigned'+groupAssigned);
                    system.debug('selectedActivity.Capability_Area__c'+selectedActivity.Capability_Area__c);
                    //if(selectedActivity.Capability_Area__c
                    if(!groupAssigned.contains(selectedActivity.Capability_Area__c)){
                        iserroredNext = true;
                        addError('This activity does not belong to your department. Please verify the activity.');
                    }
                }
            } 
            catch(Exception e){
                system.debug(e.getmessage());
                addError('This activity is not valid.Please select new activity');
            }  
        }    
    }
    
    Public void next(){
        try{
            if (Apexpages.currentPage().getParameters().containsKey('resourceId')){
                resourceId = Apexpages.currentPage().getParameters().get('resourceId');
            }
            system.debug('selectedActivity******'+selectedActivity);
            iserroredNext = false;
             validateActivityArea();
             
             Date newUpdatedDate = selectedActivity.Proposed_Start_Date__c;
             newUpdatedDate = newUpdatedDate.addDays(selectedActivity.Planned_Start_Date__c.daysBetween(selectedActivity.Planned_End_Date__c));
             system.debug('****'+newUpdatedDate);
            if(oAssignResource.DRDW_Activity__c == null || oAssignResource.Allocation_Start_Date__c == null || oAssignResource.Allocation_End_Date__c == null || 
                    oAssignResource.Hours_Per_Day__c == null ){
                addError('Please enter manadtory values.');
                iserroredNext = true;
            }
            /*if(oAssignResource.Allocation_Start_Date__c > oAssignResource.Allocation_End_Date__c){
                addError('Allocation end date cannot be before the start date');
                iserroredNext = true;
            }  */             
            if(oAssignResource.Allocation_Start_Date__c < selectedActivity.Proposed_Start_Date__c && selectedActivity.Proposed_Start_Date__c != null){
                addError('Allocation start date cannot be before the activity Preferred Start Date');
                iserroredNext = true;
            }
            if(oAssignResource.Allocation_End_Date__c > newUpdatedDate){
                addError('Allocation end date cannot be After the activity Preferred Start Date plus Difference between Planned Start Date and Planned End Date');
                iserroredNext = true;
            }
            if(oAssignResource.Hours_Per_Day__c < 0 || oAssignResource.Hours_Per_Day__c > 24){
                addError('Hours should be between 0 - 24');
                iserroredNext = true;
            }
            if(!iserroredNext){
                if(oAssignResource.Allocation_Start_Date__c == oAssignResource.Allocation_End_Date__c){
                    Datetime dt = DateTime.newInstance(oAssignResource.Allocation_Start_Date__c, Time.newInstance(0, 0, 0, 0));
                    string day = dt.format('EEEE');
                    if(day == 'Saturday' || day == 'Sunday'){
                        addError('Allocated day comes on weekend');
                        iserroredNext = true;
                    }                   
                }
                if(oAssignResource.Allocation_Start_Date__c.addDays(1) == oAssignResource.Allocation_End_Date__c){
                    Datetime dt1 = DateTime.newInstance(oAssignResource.Allocation_Start_Date__c, Time.newInstance(0, 0, 0, 0));
                    Datetime dt2 = DateTime.newInstance(oAssignResource.Allocation_End_Date__c, Time.newInstance(0, 0, 0, 0));
                    string secondday = dt2.format('EEEE');
                    string firstday = dt1.format('EEEE');
                    if((firstday == 'Saturday' || firstday == 'Sunday') && (secondday == 'Saturday' || secondday == 'Sunday')){
                        addError('Allocated days comes on weekend');
                        iserroredNext = true;
                    }                   
                }  
            }     
            if(!iserroredNext){
                firstPage = false;
                lResourceWrapper = new List<resourceWrapper>();
                Map<Date,DRDW_Calender_Per_Roaster__c> tempMapCalenderPerYear;
                Map<Id,Map<Date,DRDW_Calender_Per_Roaster__c>> mapResourceCPR = new Map<Id,Map<Date,DRDW_Calender_Per_Roaster__c>>();
                Map<Id,DRDW_Resource__c> mResources;
                if(oAssignResource.Activity_Area__c != 'Other'){                    
                    if(resourceId!='' && !String.isBlank(resourceId)){
                        mResources = new Map<Id,DRDW_Resource__c>([select id,Name__r.Name,Hours_Available_Per_Day__c from DRDW_Resource__c where Department__c =:oAssignResource.Activity_Area__c and Hours_Available_Per_Day__c != null and Hours_Available_Per_Day__c != 0 AND Id=:resourceId]);
                    }
                    else{
                        mResources = new Map<Id,DRDW_Resource__c>([select id,Name__r.Name,Hours_Available_Per_Day__c from DRDW_Resource__c where Department__c =:oAssignResource.Activity_Area__c and Hours_Available_Per_Day__c != null and Hours_Available_Per_Day__c != 0]);
                    }
                }
                else{
                    if(resourceId!='' && !String.isBlank(resourceId)){
                        mResources = new Map<Id,DRDW_Resource__c>([select id,Name__r.Name,Hours_Available_Per_Day__c from DRDW_Resource__c where Hours_Available_Per_Day__c != null and Hours_Available_Per_Day__c != 0 AND Id=:resourceId]);
                    }
                    else{                       
                        mResources = new Map<Id,DRDW_Resource__c>([select id,Name__r.Name,Hours_Available_Per_Day__c from DRDW_Resource__c where Hours_Available_Per_Day__c != null and Hours_Available_Per_Day__c != 0]);                   
                    }
                }
                List<DRDW_Calender_Per_Roaster__c> lcalenderRoaster = [Select id,Over_Allocated__c,Allocated_Date__c,Allocated_Hours__c,DRDW_Roaster__c from DRDW_Calender_Per_Roaster__c where DRDW_Roaster__c in:mResources.keyset() and Allocated_Date__c != null and Allocated_Hours__c != null];
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
                Integer flagCount = 0;
                //Boolean flagset = true;
                for(Id oresId : mResources.keyset()){
                    /*if(flagCount > 0){
                        flagset = false;
                        }
                        flagCount = flagCount +1;*/
                    DRDW_Resource__c ores = mResources.get(oresId);
                    Decimal TotalHours = getTotalAllocatedHours(oAssignResource.Allocation_Start_Date__c,oAssignResource.Allocation_End_Date__c,ores.Hours_Available_Per_Day__c);
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
                    for(Date sDate = oAssignResource.Allocation_Start_Date__c ;sDate<=oAssignResource.Allocation_End_Date__c;){  
                        Datetime dt = DateTime.newInstance(sDate, Time.newInstance(0, 0, 0, 0));
                        string sday = dt.format('EEEE');
                        if(sday != 'Saturday' && sday != 'Sunday'){
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
                            oeventDaysInsert.Type__c = 'ERL';
                            leventDaysInsert.add(oeventDaysInsert);
                        }
                        sDate = sDate.addDays(1);             
                    } 
                    if(TotalHours!=0){
                        alloc = math.round((i/TotalHours)*100);
                    }
                    resourceWrapper r = new resourceWrapper(ores.id,ores.Name__r.Name,conflicts,alloc,false,lcalenderPerRoasterInsert,leventDaysInsert,selectedActivity.Related_Project__c);
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
        }                   
    }
    
    Public void assignResource(){
        iserroredAssign = false;
        List<DRDW_Calender_Per_Roaster__c> lcalenderPerRoasterInsertFinal;
        List<DRDW_Event_Days__c> leventDaysInsertFinal;
        List<Id> projIdList = new List<Id>();
        selectedResource = apexpages.currentpage().getparameters().get('selectedResource');
        system.debug('selectedResource**'+selectedResource);
        if(selectedResource == null || selectedResource == ''){
            addError('Please select resource');
            iserroredAssign = true;
        }
        else{
            try{ 
                for(resourceWrapper resWrap : lResourceWrapper) {
                    if(resWrap.ResId == selectedResource){
                        oAssignResource.DRDW_Resources__c = resWrap.ResId;
                        lcalenderPerRoasterInsertFinal = resWrap.lcalenderPerRoasterInsert;
                        leventDaysInsertFinal = resWrap.leventDaysInsert;
                        projIdList.add(resWrap.projectId);
                    } 
                }
                
                // added to check if assigned resource is already assigned to Activity on the selected days.                              
               List<DRDW_Event_Days__c> lEventDays = new List<DRDW_Event_Days__c>();                     
               lEventDays = [select id from DRDW_Event_Days__c where DRDW_Resource__c =:oAssignResource.DRDW_Resources__c and (Date__c>=:oAssignResource.Allocation_Start_Date__c and Date__c<=:oAssignResource.Allocation_End_Date__c) and DRDW_Event__r.DRDW_Activity__c =: oAssignResource.DRDW_Activity__c]; 
               system.debug('EventDays++++++++++'+lEventDays);
               if(lEventDays!=null && lEventDays.size()>0){
                         addError('This resource is already allocated to this same activity on the same day');
                         iserroredAssign = true;
                 }                  
                system.debug('*****!@# oAssignResource '+oAssignResource);
                system.debug('*****!@# lcalenderPerRoasterInsertFinal'+lcalenderPerRoasterInsertFinal);
                system.debug('*****!@# leventDaysInsertFinal '+leventDaysInsertFinal);
                system.debug('*****!@# lprojIdList '+projIdList);
                if(!iserroredAssign){
                    insert oAssignResource;  
                    upsert lcalenderPerRoasterInsertFinal;
                    insert leventDaysInsertFinal;     
                    DRDW_RecordSharing.getRecordIdShare(projIdList,true,true,oAssignResource.DRDW_Resources__c);   
                }        
            }catch(exception e){
                addError(e.getmessage());
                iserroredAssign = true;
            }
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
    
    Public Decimal getTotalAllocatedHours(Date StartDate,Date EndDate,Decimal hours){
        Integer Count = 0;        
        for(Date sDate = StartDate;sDate<=EndDate;){  
            Datetime dt = DateTime.newInstance(sDate, Time.newInstance(0, 0, 0, 0));
            string sday = dt.format('EEEE');
            if(sday != 'Saturday' && sday != 'Sunday'){
                Count++;
            }
            sDate = sDate.addDays(1);            
        }     
        return Count * hours;        
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
}