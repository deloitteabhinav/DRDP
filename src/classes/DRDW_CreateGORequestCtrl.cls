Public without sharing Class DRDW_CreateGORequestCtrl{ 
    Public DRDW_Cap_Request__c oRequest{get;set;}
    Public Id currentRecordID {get; set;}
    Public Id projectRecordID {get; set;}
    Public String projectName {get; set;}
    Public Boolean isAdmin{get;set;}
    public id LinkID {get; set;}
    Public Integer index{get;set;}
    Public DRDW_Project__c oProject{get;set;}
    Public boolean isIdea {get; set;}
    Public boolean isGen {get; set;}
    Public boolean isAssess {get; set;}
    Public boolean isSubmitted {get; set;} /* Set to true when submitted and if Admin */
    Public boolean isSubSumitted {get; set;} /* Set to true when submitted */
    Public boolean isGoUser {get; set;}
    Public boolean isOnlyGoUser {get; set;}
    Public boolean showSubmitbutton {get; set;}
    Public List<DRDW_Event__c> RelEvents {get; set;}
    Public boolean  isAccess {get; set;}
    Public boolean isEdit{get;set;}
    Public id EventId{get;set;}
    Public List<eventWrapper> leventWrapper{get;set;}
    Public boolean isInBuGroup{get; set;}
    Public Set<String> groupBUAssigned{get;set;}
    Public boolean isStudyManager {get; set;}
    Public boolean isScientist {get; set;}
    Public boolean Showedit {get; set;}
    public boolean isProjectaccess {get; set;}
    public boolean isERLPM {get; set;}
    Public Date PreferredDate{get;set;}
    Public List<SelectOption> lSamplestocollect{get;set;}
    Public List<String> sSamplestocollect{get;set;}
    Public String SamplestoCollect{get;set;}
    Public List<SelectOption> optionsToReturn{get; set;}
    Public boolean ShowChallengeOther {get; set;}
    Public boolean ShowVaccinationOther {get; set;}
    Public boolean ShowSwabsOther {get; set;}
    Public boolean ShowBloodOther {get; set;}
    Public boolean ShowNecropsyOther {get; set;}
    Public boolean ShowFecalOther {get; set;}
    Public boolean showBulkEdit{get;set;}
    Public boolean editSave{get;set;}
    Public String Showsamplesother {get; set;}
    Public boolean subShowEdit{get;set;}
    
    Public DRDW_CreateGORequestCtrl(ApexPages.StandardController controller){
        oRequest = (DRDW_Cap_Request__c)controller.getRecord();
        isIdea = false;
        isGen = false;          
        isGoUser = false;
        isSubSumitted = false;
        isAssess = false;
        isSubmitted = true;
        isAdmin = false;
        showSubmitbutton = false;
        isEdit = false;
        isStudyManager = false;
        isScientist = false;
        Showedit = false;
        isInBuGroup = false;
        isProjectaccess = false;
        isERLPM = false;
        ShowChallengeOther = false;
        ShowVaccinationOther = false;
        ShowSwabsOther = false;
        ShowBloodOther = false;
        ShowNecropsyOther = false;
        ShowFecalOther = false;
        showBulkEdit = false;
        editSave = true;
        
        Showsamplesother = 'false';
        leventWrapper = new List<eventWrapper>();
        lSamplestocollect = new List<SelectOption>();
        currentRecordID = ApexPages.currentPage().getParameters().get('id');
        projectRecordID = ApexPages.currentPage().getParameters().get('projid');
        if(currentRecordID != null){
            String SobjectApiName = 'DRDW_Cap_Request__c';
            sSamplestocollect = new List<String>();
            Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
            Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
            String commaSeparatedFields = '';
            for (String fieldName : fieldMap.keyset()) {
                if (commaSeparatedFields == null || commaSeparatedFields == '') {
                    commaSeparatedFields = fieldName;
                } else {
                    commaSeparatedFields = commaSeparatedFields + ', ' + fieldName;
                }
            }
            string query = 'select ' + commaSeparatedFields + ', Project__r.Business_Unit__c'  +' from ' + SobjectApiName + ' where id =\'' + currentRecordID + '\' limit 1';
            oRequest = Database.query(query);
            if(oRequest.Samples_to_Collect_new__c != NULL && oRequest.Samples_to_Collect_new__c !=''){
                    SamplestoCollect = oRequest.Samples_to_Collect_new__c;
                    SamplestoCollect = SamplestoCollect.substring(1, SamplestoCollect.length()-1);
                    For(String s : SamplestoCollect.split(',')){
                        sSamplestocollect.add(s.trim());
                    }
            }
            PreferredDate = oRequest.GO_Preferred_Start_Date__c;
            projectRecordID = oRequest.Project__c;
            groupBUAssigned();
            if(oRequest.Request_Status__c == 'Re-Submit: Change Request' || oRequest.Request_Status__c == 'Re-Submit: Data Request'){
                isSubmitted = true;
            }else if(oRequest.Request_Status__c == 'Submitted' || oRequest.Request_Status__c == 'In Queue' || oRequest.Request_Status__c == 'Triage' || oRequest.Request_Status__c == 'Approved-Locked' || oRequest.Request_Status__c == 'Rejected'){
                isSubSumitted = true;
            }
            if(oRequest.Request_Status__c == 'Re-Submit: Change Request' || oRequest.Request_Status__c == 'Re-Submit: Data Request' || oRequest.Request_Status__c == 'Draft'){
                showSubmitbutton = true;
            }
            DRDW_Capability__c relcap = [Select Id, Name from DRDW_Capability__c where DRDW_Request__c =: currentRecordID limit 1];
            System.debug('List of Activities associated'+relcap);
            RelEvents = [Select Id, Name, Event_Category__c, Event_Type__c, Frequency__c,Frequency_UI__c,Go_Sub_Activities__c from DRDW_Event__c where Type__c = 'GO' AND DRDW_Activity__c = :relcap.Id order by Order__c ASC NULLS LAST];   
            System.debug('List of events associated'+RelEvents);
            for(DRDW_Event__c e : RelEvents){
                eventWrapper eW = new eventWrapper(false,e);
                leventWrapper.add(eW);
                if(e.Frequency__c == null){
                    showBulkEdit = true;
                }
            }   

            sSamplestocollect = new List<String>();
            if(oRequest.Samples_to_collect_new__c != NULL && oRequest.Samples_to_collect_new__c !=''){
                //if(SamplestoCollect.length() != NULL){
                    System.debug('inside not null'+SamplestoCollect);
                    SamplestoCollect = oRequest.Samples_to_collect_new__c;
                    System.debug('inside not null2'+SamplestoCollect);
                    SamplestoCollect = SamplestoCollect.substring(1, SamplestoCollect.length()-1);
                    System.debug('inside not null1'+SamplestoCollect);
                    For(String s : SamplestoCollect.split(',')){
                        sSamplestocollect.add(s.trim());
                    }
                //}
            }

        }
        For(GLBL_Global_List_of_Values__c oglbl : [Select Name,RecordType.developerName from GLBL_Global_List_of_Values__c where Active__c = True AND RecordType.DeveloperName = 'DRDW_Samples_To_Collect' order by name ASC]){
            System.debug('GLBL values'+oglbl.Name);
            lSamplestocollect.add(new SelectOption(oglbl.Name,oglbl.Name));
        }
        Schema.DescribeFieldResult describeResult = DRDW_Cap_Request__c.Lab_Testing_required__c.getDescribe();
        // get the picklist values from this describe result
        List<Schema.PicklistEntry> entries = describeResult.getPicklistValues();
        // list of options to be returned to the VF page
        optionsToReturn = new List<SelectOption>();
        for (Schema.PicklistEntry pEntry : entries) {
            if (pEntry.isActive()) {
                optionsToReturn.add(new SelectOption(pEntry.getValue(), pEntry.getLabel()));
            }
        }
        oRequest.Project__c = projectRecordID;
        oRequest.RecordTypeId = Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('GO').getRecordTypeId();
        isAdmin = getUserPermission(UserInfo.getUserId());
        isGoUser = getGOuser(UserInfo.getUserId());
        isOnlyGoUser = getOnlyGOuser(UserInfo.getUserId());
        isAccess = HasAccess(UserInfo.getUserId(), oRequest.Id);
        isStudyManager = getStudyManagers(UserInfo.getUserId());
        isScientist = getScientist(UserInfo.getUserId());
        isProjectaccess = HasAccess(UserInfo.getUserId(),oRequest.Project__c);
        isERLPM = getERLPM(UserInfo.getUserId());
        if(isSubSumitted && isAdmin){
            isSubmitted = true;
        }else if(isSubSumitted && !isAdmin){
            isSubmitted= false;
        }
        //Checking for the Edit access.
        if(isERLPM && (isProjectaccess || isInBuGroup )){
            Showedit = true;
        }
        if(isScientist){
            if(isProjectaccess){
                Showedit = true;
            }else if(isInBuGroup){
                Showedit = false;
            }
        }
        if(isAdmin || isOnlyGoUser || isStudyManager){
            Showedit = true;
        }
        System.debug('***projectRecordID '+projectRecordID);
        if(projectRecordID != null){
            oProject = [select id,Idea_Name__c,Project_Name__c,recordtype.developername,Decision_to_Evaluate_DTE__c,
            CSF_Decision_to_Generate_DTG_Planned__c,CSF_Decision_to_Generate_DTG_Actual__c,Decision_to_Assess_DTA_Planned_Date__c,Decision_to_Assess_DTA_Actual_Date__c,Decision_to_Generate_DTG__c,Decision_To_Assess_DTA__c,DP1_Planned_Date__c,DP1_Actual_Date__c from DRDW_Project__c where id=:projectRecordID];
            if(oProject.recordtype.developername == 'Idea_Project'){
                projectName  =  oProject.Idea_Name__c;   
                isIdea = true ;   
                //rectype = 'idea';     
            }
            else if(oProject.recordtype.developername == 'Generation_Project'){
                projectName =  oProject.Project_Name__c;
                isGen = true;
                //rectype = 'gen';
            }else if(oProject.recordtype.developername == 'Assessment_Project'){
                projectName =  oProject.Project_Name__c; 
                isAssess = true;
                //rectype = 'assess';              
            }
        }
    }
    
    Public void Editable(){        
        For(eventWrapper e : leventWrapper){
            if(e.EventObject.id == EventId){
                e.isAccessable = true;
            }
        }
    }
    
    Public void AllEditable(){
        For(eventWrapper e : leventWrapper){
            if(e.EventObject.Frequency__c == null){ 
                e.isAccessable = true;           
            }     
        }
        editSave = false;
    }
    
    Public void SaveEditable(){
        RelEvents.clear();
        For(eventWrapper e : leventWrapper){
            RelEvents.add(e.EventObject);                
            if(e.EventObject.id == EventId){
                e.isAccessable = false;
            }
        }
        Update RelEvents;
    }
    
    Public void allSave(){
        subShowEdit = false;
        RelEvents.clear();
        For(eventWrapper e : leventWrapper){
            RelEvents.add(e.EventObject); 
            e.isAccessable = false;
            if(e.EventObject.Frequency__c == null){ 
                subShowEdit = true;
            }              
        }
        if(subShowEdit){
            showBulkEdit = true;
        }else{
            showBulkEdit = false;
        }
        Update RelEvents;
        editSave = true;
    }
    
    Public class eventWrapper{
        Public Boolean isAccessable{get;set;}
        Public DRDW_Event__c EventObject{get;set;}
        Public eventWrapper(Boolean isAccessable,DRDW_Event__c EventObject){ 
            this.isAccessable = isAccessable;
            this.EventObject = EventObject;
        }    
    } 
    
    Public PageReference save(){
        try{
            boolean iserrored = false;
            boolean isinserted =false;
            if((oRequest.Planned_Study_Start_Date__c > oRequest.Planned_Study_End_Date__c) || (oRequest.Planned_Study_End_Date__c < oRequest.Planned_Study_Start_Date__c)){
                addError('Planned Study Start Date cannot be after the Planned Study End Date');
                iserrored = true;
            }
            if( (oRequest.Actual_Study_Start_Date__c > oRequest.Actual_Study_End_Date__c) || (oRequest.Actual_Study_End_Date__c < oRequest.Actual_Study_Start_Date__c) ){
                addError('Actual Study Start Date cannot be after the Actual Study End Date');
                iserrored = true;
            }
            //Checking the planned/Actual dates wrt to the project dates
            if(isIdea){
                if( oRequest.Planned_Study_Start_Date__c < oProject.Decision_to_Evaluate_DTE__c || oRequest.Actual_Study_Start_Date__c < oProject.Decision_to_Evaluate_DTE__c){
                    addError('Planned Study Start Date and Actual Study start date cannot be before DTE date of Project');
                    iserrored = true;
                }   
                if(oProject.CSF_Decision_to_Generate_DTG_Actual__c != null){
                    if(oRequest.Planned_Study_End_Date__c > oProject.CSF_Decision_to_Generate_DTG_Actual__c || oRequest.Actual_Study_End_Date__c > oProject.CSF_Decision_to_Generate_DTG_Actual__c){
                        addError('Planned Study End Date and Actual Study End date cannot be after Actual DTG date of Project');
                        iserrored = true;
                    }  
                }else {
                    if(oRequest.Planned_Study_End_Date__c > oProject.CSF_Decision_to_Generate_DTG_Planned__c || oRequest.Actual_Study_End_Date__c > oProject.CSF_Decision_to_Generate_DTG_Planned__c){
                        addError('Planned Study End Date and Actual Study End date cannot be after Planned DTG date of Project');
                        iserrored = true;
                    }  
                }
            }
            else if(isGen){
                if(oRequest.Planned_Start_Date__c < oProject.Decision_to_Generate_DTG__c || oRequest.Actual_Study_Start_Date__c < oProject.Decision_to_Generate_DTG__c){
                    addError('Planned Study Start Date and Actual Study start date cannot be before DTG date of Project');
                    iserrored = true;
                } 
                if(oProject.Decision_to_Assess_DTA_Actual_Date__c != null){
                    if( oRequest.Planned_Study_End_Date__c > oProject.Decision_to_Assess_DTA_Actual_Date__c || oRequest.Actual_Study_End_Date__c > oProject.Decision_to_Assess_DTA_Actual_Date__c){
                        addError('Planned Study End Date and Actual Study End date cannot be after Actual DTA date of Project');
                        iserrored = true;
                    }
                }else {
                    if( oRequest.Planned_Study_End_Date__c > oProject.Decision_to_Assess_DTA_Planned_Date__c || oRequest.Actual_Study_End_Date__c > oProject.Decision_to_Assess_DTA_Planned_Date__c){
                        addError('Planned Study End Date and Actual Study End date cannot be after Planned DTA date of Project');
                        iserrored = true;
                    }
                }
            }else if(isAssess){
                if(oRequest.Planned_Start_Date__c < oProject.Decision_To_Assess_DTA__c || oRequest.Actual_Study_Start_Date__c < oProject.Decision_To_Assess_DTA__c){
                    addError('Planned Study Start Date and Actual Study start date cannot be before DTA date of Project');
                    iserrored = true;
                }
                if(oProject.DP1_Actual_Date__c != null){
                    if(oRequest.Planned_Study_End_Date__c > oProject.DP1_Actual_Date__c || oRequest.Actual_Study_End_Date__c > oProject.DP1_Actual_Date__c){
                        addError('Planned Study End Date and Actual End start date cannot be after Actual DP1 date of Project');
                        iserrored = true;
                    }   
                }else {
                    if(oRequest.Planned_Study_End_Date__c > oProject.DP1_Planned_Date__c || oRequest.Actual_Study_End_Date__c > oProject.DP1_Planned_Date__c){
                        addError('Planned Study End Date and Actual Study End date cannot be after Planned DP1 date of Project');
                        iserrored = true;
                    } 
                }            
            }
            if(iserrored == false){
                if(currentRecordID == NULL){
                    oRequest.Request_Status__c = 'Draft';
                    if(oRequest.GO_Preferred_Start_Date__c == null){
                        oRequest.GO_Preferred_Start_Date__c = oRequest.Planned_Study_Start_Date__c;
                    }
                    isinserted = true;     
                }

                //saving samples to collect in a text field
                if(currentRecordID != NULL){ 
                    if(sSamplestocollect != null){
                        String picklist = '['; 
                        for(String s:sSamplestocollect){
                            picklist = picklist + s +',' ;
                        }   
                        if(picklist.length()>1)
                        picklist = picklist.substring(0, picklist.length()-1);
                        picklist = picklist +']';
                        oRequest.Samples_to_collect_new__c = picklist;
                        System.debug('inside save'+oRequest.Samples_to_collect_new__c);
                    }
                }


                if(oRequest.Request_Status__c == 'Approved-Locked'){
                    oRequest.Study_Approval_Date__c = system.today();
                }
                CheckifFormNotComplete();
                System.debug('before inserting 1st time on save');
                upsert oRequest;
                if(isinserted){
                    addActivity();
                }
                PageReference pageref = new PageReference('/apex/DRDW_CreateGORequest?id='+oRequest.Id+'&isEdit=false');
                pageref.setredirect(true);
                return pageref;
            }else{
                return null;
            }
        }catch(Exception e){
            return null;
        }
    }
    
    Public PageReference Submit(){
        try{
            System.debug('In Submit');
            isSubSumitted = true;
            if(oRequest.Request_Status__c == 'Draft' ){ 
                System.debug('In Draft');
                if(isOnlyGoUser){
                    System.debug('Inside only GO User');
                    oRequest.Request_Status__c = 'Triage';
                }else if(!isOnlyGoUser){
                    System.debug('Inside other than GO User');
                    oRequest.Request_Status__c = 'Submitted';
                }
                oRequest.Date_of_Request__c = System.today();
            }else if(oRequest.Request_Status__c == 'Re-Submit: Change Request' || oRequest.Request_Status__c == 'Re-Submit: Data Request' ){
                oRequest.Request_Status__c = 'In Queue';
            }
            //oRequest.RecordTypeId = Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('GO').getRecordTypeId();

            //saving samples to collect in a text field
            if(sSamplestocollect != null){
                    String picklist = '['; 
                    for(String s:sSamplestocollect){
                        picklist = picklist + s +',' ;
                    }   
                    if(picklist.length()>1)
                    picklist = picklist.substring(0, picklist.length()-1);
                    picklist = picklist +']';
                    oRequest.Samples_to_collect_new__c = picklist;
                }

            System.debug('Before updating in Submit');
            CheckifFormNotComplete();
            update oRequest;
            PageReference pageref = new PageReference('/apex/DRDW_CreateGORequest?id='+oRequest.Id+'&isEdit=false');
            pageref.setredirect(true);
            return pageref;
        }catch(Exception e){
            return null;
        }
    }
    
    Public PageReference edit(){
        PageReference pageref = new PageReference('/apex/DRDW_CreateGORequest?id='+currentRecordID+'&isEdit=true');
        pageref.setredirect(true);
        return pageref;
    }
    
    Public PageReference DeleteRecord(){
        delete oRequest;
        PageReference pageref = new PageReference('/apex/Plan_Research');
        pageref.setredirect(true);
        return pageref;
    }
    
    Public Boolean getUserPermission(Id UserID){
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserID AND PermissionSet.Name IN ('DRDW_Business_Admin','DRDW_Financial_User')]);
        Set<Id> lUserId = new Set<Id>();
        If(!lPermission.isEmpty()){
            For(PermissionSetAssignment p : lPermission){
                lUserId.add(p.Assignee.Id);
            }
        }
        If(lUserId.Contains(UserID)){
            return true;
        }
        return false;
    }   
    
    Public Boolean getGOuser(Id UserID){
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserID AND PermissionSet.Name IN ('DRDW_GO_User','DRDW_Business_Admin','DRDW_Financial_User')]);
        Set<Id> lUserId = new Set<Id>();
        If(!lPermission.isEmpty()){
            For(PermissionSetAssignment p : lPermission){
                lUserId.add(p.Assignee.Id);
            }
        }
        If(lUserId.Contains(UserID)){
            return true;
        }
        return false;
    } 
    
    Public Boolean getOnlyGOuser(Id UserID){
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserID AND PermissionSet.Name = 'DRDW_GO_User']);
        Set<Id> lUserId = new Set<Id>();
        If(!lPermission.isEmpty()){
            For(PermissionSetAssignment p : lPermission){
                lUserId.add(p.Assignee.Id);
            }
        }
        If(lUserId.Contains(UserID)){
            return true;
        }
        return false;
    }
    
    Public Boolean getStudyManagers(Id UserID){
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserID AND PermissionSet.Name = 'DRDW_Study_Managers']);
        Set<Id> lUserId = new Set<Id>();
        If(!lPermission.isEmpty()){
            For(PermissionSetAssignment p : lPermission){
                lUserId.add(p.Assignee.Id);
            }
        }
        If(lUserId.Contains(UserID)){
            return true;
        }
        return false;
    } 
    
    Public Boolean getScientist(Id UserID){
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserID AND PermissionSet.Name = 'DRDW_Scientist']);
        Set<Id> lUserId = new Set<Id>();
        If(!lPermission.isEmpty()){
            For(PermissionSetAssignment p : lPermission){
                lUserId.add(p.Assignee.Id);
            }
        }
        If(lUserId.Contains(UserID)){
            return true;
        }
        return false;
    }   
    
    Public Boolean getERLPM(Id UserID){
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserID AND PermissionSet.Name IN ('DRDW_ERL','DRDW_Project_Manager')]);
        Set<Id> lUserId = new Set<Id>();
        If(!lPermission.isEmpty()){
            For(PermissionSetAssignment p : lPermission){
                lUserId.add(p.Assignee.Id);
            }
        }
        If(lUserId.Contains(UserID)){
            return true;
        }
        return false;
    }  
    
    Public void deleteEvent(){
        DRDW_Event__c oEvent = new DRDW_Event__c();
        oEvent = [select id from DRDW_Event__c where id =: EventId];
        delete oEvent;
        Integer count = leventWrapper.Size();
        if(count > 0){
        leventWrapper.clear();
        DRDW_Capability__c relcap = [Select Id, Name from DRDW_Capability__c where DRDW_Request__c =: currentRecordID limit 1];
        RelEvents = [Select Id, Name, Event_Category__c, Event_Type__c, Frequency__c,Frequency_UI__c,Go_Sub_Activities__c,Display_Order__c from DRDW_Event__c where Type__c = 'GO' AND DRDW_Activity__c = :relcap.Id order by Order__c ASC NULLS LAST];   
            //System.debug('List of events associated'+RelEvents);
            for(DRDW_Event__c e : RelEvents){
                eventWrapper eW = new eventWrapper(false,e);
                leventWrapper.add(eW);
            } 
        }else{
            leventWrapper.clear();
        }    
    }
    
    public void addError(string s) {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, s);
        ApexPages.addMessage(myMsg);
    }  
    
    Public void addActivity(){
        DRDW_Project__c proj = new DRDW_Project__c();          
        proj = [select id,Name,Name__c,Idea_Name__c,Project_Name__c, New_Idea_Name__c ,Recordtype.Name from Drdw_Project__c where id=:projectRecordID];          
        DRDW_Capability__c oActivity = new DRDW_Capability__c();
        oActivity.Title__c = oRequest.Study_Title__c;
        oActivity.RecordTypeId = Schema.SObjectType.DRDW_Capability__c.getRecordTypeInfosByName().get('Study Activity').getRecordTypeId();
        oActivity.Related_Project__c = proj.id;
        oActivity.DRDW_Request__c = oRequest.id;
        oActivity.Capability__c = oRequest.Study_Type__c;
        oActivity.Capability_Area__c = 'Study';
        oActivity.Actual_End_Date__c = oRequest.Actual_Study_End_Date__c;
        oActivity.Actual_Start_Date__c = oRequest.Actual_Study_Start_Date__c;
        oActivity.Planned_End_Date__c = oRequest.Planned_Study_End_Date__c;
        oActivity.Planned_Start_Date__c = oRequest.Planned_Study_Start_Date__c;  
        oActivity.Proposed_Start_Date__c = oRequest.GO_Preferred_Start_Date__c;
        insert oActivity;      
    }
    
    Public void CheckifFormNotComplete(){

        for(Schema.FieldSetMember fsm:Schema.SObjectType.DRDW_Cap_Request__c.fieldSets.getMap().get('AllRequiredFields').getFields()){
            if(oRequest.get(fsm.getFieldPath()) == null || oRequest.get(fsm.getFieldPath()) == ''){
                System.debug('Atleast one field is blank'+ oRequest.get(fsm.getFieldPath()));
                oRequest.isFormNotComplete_TF__c = true;
                break;
            }else {
                if(oRequest.Dependants_Complete_TF__c){
                    System.debug('Any of Dependants field is blank');
                    oRequest.isFormNotComplete_TF__c = true;
                    break;
                }else {
                    oRequest.isFormNotComplete_TF__c = false;
                }
            }
        }

        if(!oRequest.isFormNotComplete_TF__c){
            if(oRequest.Samples_to_collect_new__c != null ){
                if( oRequest.Samples_to_collect_new__c.contains('Other') && (oRequest.Other_Samples__c == null || oRequest.Other_Samples__c == '')){
                    oRequest.isFormNotComplete_TF__c = true;
                }else {
                oRequest.isFormNotComplete_TF__c = false;
                }
            }
        }

    }
    
    Public PageReference CheckIfGoUserandFirsttime(){
        try {
            if(isOnlyGoUser && oRequest.Request_Status__c == 'Submitted'){
                oRequest.Request_Status__c = 'Triage';
                update oRequest;
                PageReference pageref = new PageReference('/apex/DRDW_CreateGORequest?id='+oRequest.Id+'&isEdit=false');
                pageref.setredirect(true);
                return pageref;
            }else {
                return null;
            }
        }catch (Exception e){
            addError(e.getMessage());
            return null;
        }
    }
    
    /*
    * @Method Name                    :  HasAccess
    * @Description                    :  Method to check if the logged in user has access to the record
    * @Return Type                    :  Boolean
    * @Parameters                     :  User ID, Record ID
    */
    public boolean HasAccess(Id UserID, Id RecID){
        List<UserRecordAccess> lst = [SELECT RecordId FROM UserRecordAccess WHERE UserId = :UserID AND RecordId = :RecID AND HasEditAccess = true];
        if(!lst.isEmpty() && lst != null){
            system.debug('inside list'+lst);
            return true;
        }else {return false;}
    }
    
    Public void groupBUAssigned(){
        groupBUAssigned = new set<String>();
        List<String> allGroupIDs = new List<String>();
        for (GroupMember gm : [SELECT Id, group.id, group.DeveloperName, group.type FROM GroupMember where (UserOrGroupId = :UserInfo.getUserId())]){
            if(DRDW_Constants.groupBUMapping.containsKey(gm.group.DeveloperName)){
                groupBUAssigned.add(DRDW_Constants.groupBUMapping.get(gm.group.DeveloperName));
            }
        }
        if(groupBUAssigned.contains(oRequest.Project__r.Business_Unit__c)){
            isInBuGroup = true;
        }
    }
    
    public void SettingDate(){
        PreferredDate = oRequest.GO_Preferred_Start_Date__c;
        system.debug('*******' +PreferredDate +'********'+oRequest.GO_Preferred_Start_Date__c);
    }
    
    public void setOthersamples(){
        System.debug('Inside controller function');
        if (Apexpages.currentPage().getParameters().containsKey('samplesvalue')){
                Showsamplesother = Apexpages.currentPage().getParameters().get('samplesvalue');
            }
            System.debug('Inside controller functionfsada'+Showsamplesother);
        //Showsamplesother = true;
    }
}