Public without sharing Class DRDW_CreateERLRequestCtrl{ 
    Public DRDW_Cap_Request__c oRequest{get;set;}
    Public Id currentRecordID {get; set;}
    Public Id projectRecordID {get; set;}
    Public String projectName {get; set;}
    Public Boolean isAdmin{get;set;}
    public id LinkID {get; set;}
    public list<activityWrapper> lactivityWrapper{get; set;}
    public list<DRDW_Capability__c> lactivityInsert{get; set;}
    Public Boolean showActivity{get;set;}
    Public Boolean showSubmit{get;set;}
    public activityWrapper currentWrapperObject{get; set;}
    Public Integer index{get;set;}
    Public DRDW_Project__c oProject{get;set;}
    Public List<SelectOption> lAreaPicklist{get;set;}
    Public List<SelectOption> lActivityPicklist{get;set;}
    Public Map<String,List<SelectOption>> mAreaPicklist{get;set;}
    Public List<DRDW_Capability__c> lRelatedActivity{get;set;}
    Public boolean isIdea {get; set;}
    Public Set<String> groupAssigned{get;set;}
    Public Set<String> groupBUAssigned{get;set;}
    Public boolean isGen {get; set;}
    Public boolean isAssess {get; set;}
    Public boolean isFin{get;set;}
    Public boolean isFuncHead{get;set;}
    Public boolean showCancel{get;set;}
    Public boolean isInBuGroup{get;set;}
    Public boolean isAccessable{get;set;}
    Public boolean isParentaccess{get; set;}
    Public boolean isPmErl{get;set;}
    Public boolean isSc{get;set;}
    Public boolean isShowEditButton{get; set;}
    Public List<String> Functional_GroupName = new List<String>();
    Public Map<id,boolean> mActivity = new Map<id,boolean>();
    Public DRDW_CreateERLRequestCtrl(ApexPages.StandardController controller){
        oRequest = (DRDW_Cap_Request__c)controller.getRecord();
        isIdea = false;
        isGen = false;
        isAssess = false;
        showCancel = true;
        isInBuGroup = false;
        isAccessable = false;
        isShowEditButton = false;
        isParentaccess = false;
        currentRecordID = ApexPages.currentPage().getParameters().get('id');
        projectRecordID = ApexPages.currentPage().getParameters().get('projid');
        if(projectRecordID != null){
            oProject = [select id,Idea_Name__c,Project_Name__c,Business_Unit__c,recordtype.developername,Decision_to_Evaluate_DTE__c,
            CSF_Decision_to_Generate_DTG_Planned__c,Decision_to_Assess_DTA_Planned_Date__c,Decision_to_Generate_DTG__c,Decision_To_Assess_DTA__c,DP1_Planned_Date__c from DRDW_Project__c where id=:projectRecordID];
        }
        lAreaPicklist = new List<SelectOption>();
        lRelatedActivity = new List<DRDW_Capability__c>([Select Id,DRDW_Request__c,Title__c,Capability_Area__c,Capability__c,Planned_Start_Date__c,Planned_End_Date__c,Actual_Start_Date__c,Actual_End_Date__c from DRDW_Capability__c where DRDW_Request__c =: currentRecordID ]);
        mAreaPicklist = new Map<String,List<SelectOption>>();
        For(GLBL_Global_List_of_Values__c oglbl : [Select Name,RecordType.developerName from GLBL_Global_List_of_Values__c where Active__c = True AND RecordType.DeveloperName = 'DRDW_Elanco_Capability_Area' order by name ASC]){
            lAreaPicklist.add(new SelectOption(oglbl.Name,oglbl.Name));               
        }
        lAreaPicklist.add(new SelectOption('Other','Other'));
        For(GLBL_Global_List_of_Values__c oglbl : [Select Name,RecordType.developerName,Parent__r.Name from GLBL_Global_List_of_Values__c where Active__c = True AND RecordType.DeveloperName = 'DRDW_Elanco_Capability' order by name ASC]){
            if(mAreaPicklist.containsKey(oglbl.Parent__r.Name)){
                mAreaPicklist.get(oglbl.Parent__r.Name).add(new SelectOption(oglbl.Name,oglbl.Name));
            }else{
                mAreaPicklist.put(oglbl.Parent__r.Name,New List<SelectOption>{new SelectOption(oglbl.Name,oglbl.Name)});  
            }
        }
        if(currentRecordID != null){
            String SobjectApiName = 'DRDW_Cap_Request__c';
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
            string query = 'select ' + commaSeparatedFields+ ',Project__r.Name__c' + ' from ' + SobjectApiName + ' where id =\'' + currentRecordID + '\' limit 1';
            oRequest = Database.query(query);
            if(projectRecordID == null){
                projectRecordID = oRequest.Project__c;
                oProject = [select id,Idea_Name__c,Project_Name__c,Business_Unit__c,recordtype.developername,Decision_to_Evaluate_DTE__c,
                CSF_Decision_to_Generate_DTG_Planned__c,Decision_to_Assess_DTA_Planned_Date__c,Decision_to_Generate_DTG__c,Decision_To_Assess_DTA__c,DP1_Planned_Date__c from DRDW_Project__c where id=:projectRecordID];
            }
            List<DRDW_Capability__c> lactivities = new List<DRDW_Capability__c>();
            Set<id> sActivitiesId = new Set<id>();
            lactivities = [select id,Name,Capability__c,Capability_Area__c,Planned_Start_Date__c,Planned_End_Date__c,Title__c,Actual_End_Date__c,Actual_Start_Date__c from DRDW_Capability__c where DRDW_Request__c =:oRequest.id];
            if(!lactivities.isEmpty()){
                for(DRDW_Capability__c c : lactivities){
                    sActivitiesId.add(c.id);
                }
                List<UserRecordAccess> lAccess = new List<UserRecordAccess>([SELECT RecordId,HasEditAccess FROM UserRecordAccess WHERE UserId =:UserInfo.getUserId() AND RecordId IN: sActivitiesId]);
                if(!lAccess.isEmpty()){
                    for(UserRecordAccess u : lAccess){
                        mActivity.put(u.RecordId,u.HasEditAccess);
                    }
                }
            }
            lactivityWrapper = new list<activityWrapper>();
            activityWrapper oactivityWrapper;
            integer i = 0;
            groupAssigned();
            groupBUAssigned();
            for(DRDW_Capability__c oactivities : lactivities){
                Boolean isFuncInGroup = false;
                Boolean isAccess = false;
                if(mActivity.containsKey(oactivities.id)){                   
                    isAccess = mActivity.get(oactivities.id);
                }
                if(groupAssigned.contains(oactivities.Capability_Area__c)){
                    isFuncInGroup = true;
                }
                oactivityWrapper = new activityWrapper(i,true,isFuncInGroup,isAccess,oactivities);
                lactivityWrapper.add(oactivityWrapper);
                i++;
            }
            system.debug('***'+lactivityWrapper);
            hasRecordAccess(); 
            hasParentAcess();
        }
        else{
            oRequest.Status__c = 'Unassigned';
            Id recordtype = Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('ERL').getRecordTypeId();
            oRequest.recordtypeid = recordtype;
            oRequest.Project__c = projectRecordID;
        }
        isAdmin = getUserPermission(UserInfo.getUserId());
        isFin = getUserPermissionFin(UserInfo.getUserId());
        isFuncHead = getUserPermissionFuncHead(UserInfo.getUserId());
        isPmErl = getUserPermissionLoggedinUser(UserInfo.getUserId());
        isSc = getUserPermissionSc(UserInfo.getUserId());
        isShowEditButton = ShowEditButton(UserInfo.getUserId());

        if(projectRecordID != null){
            if(oProject.recordtype.developername == 'Idea_Project'){
                projectName  =  oProject.Idea_Name__c;  
                if(currentRecordID == NULL){
                    oRequest.Planned_Start_Date__c = oProject.Decision_to_Evaluate_DTE__c;
                    oRequest.Planned_End_Date__c = oProject.CSF_Decision_to_Generate_DTG_Planned__c; 
                }
                isIdea = true ;   
                //rectype = 'idea';     
            }
            else if(oProject.recordtype.developername == 'Generation_Project'){
                projectName =  oProject.Project_Name__c;
                if(currentRecordID == NULL){
                    oRequest.Planned_Start_Date__c = oProject.Decision_to_Generate_DTG__c;
                    oRequest.Planned_End_Date__c = oProject.Decision_to_Assess_DTA_Planned_Date__c;
                }
                isGen = true;
                //rectype = 'gen';
            }else if(oProject.recordtype.developername == 'Assessment_Project'){
                projectName =  oProject.Project_Name__c;
                if(currentRecordID == NULL){ 
                    oRequest.Planned_Start_Date__c = oProject.Decision_To_Assess_DTA__c;
                    oRequest.Planned_End_Date__c = oProject.DP1_Planned_Date__c;
                }
                isAssess = true;
                //rectype = 'assess';              
            }
        }
        if(oRequest.Do_you_know_your_Activities__c == 'Yes'){
            showActivity = true;
            showSubmit = true;
        }
    }
    
    Public PageReference save(){
        try{
            boolean iserrored = false;
            if(oRequest.Planned_Start_Date__c != Null && oRequest.Planned_Start_Date__c > oRequest.Planned_End_Date__c){
                addError('Planned Start Date cannot be after Planned End Date');
                iserrored = true;
            }  
            if(oRequest.Actual_Start_Date__c != Null && oRequest.Actual_End_Date__c < oRequest.Actual_Start_Date__c){
                addError('Actual Start Date cannot be after Actual End Date');
                iserrored = true;
            }  
            if(oProject.recordtype.developername == 'Idea_Project'){
                if((oRequest.Planned_Start_Date__c < oProject.Decision_to_Evaluate_DTE__c) || (oRequest.Actual_Start_Date__c < oProject.Decision_to_Evaluate_DTE__c)){
                    addError('Planned Start Date and Actual Start Date cannot be before DTE date of Project');
                    iserrored = true;
                }   
                if((oRequest.Planned_End_Date__c > oProject.CSF_Decision_to_Generate_DTG_Planned__c) || (oRequest.Actual_End_Date__c > oProject.CSF_Decision_to_Generate_DTG_Planned__c)){
                    addError('Planned End Date and Actual End Date cannot be after Planned DTG date of Project');
                    iserrored = true;
                }  
            }
            else if(oProject.recordtype.developername == 'Generation_Project'){
                if((oRequest.Planned_Start_Date__c < oProject.Decision_to_Generate_DTG__c) || (oRequest.Actual_Start_Date__c < oProject.Decision_to_Generate_DTG__c)){
                    addError('Planned Start Date and Actual Start Date cannot be before DTG date of Project');
                    iserrored = true;
                } 
                if((oRequest.Planned_End_Date__c > oProject.Decision_to_Assess_DTA_Planned_Date__c) || (oRequest.Actual_End_Date__c > oProject.Decision_to_Assess_DTA_Planned_Date__c)){
                    addError('Planned End Date and Actual End Date cannot be after Planned DTA date of Project');
                    iserrored = true;
                }
            }else if(oProject.recordtype.developername == 'Assessment_Project'){
                if((oRequest.Planned_Start_Date__c < oProject.Decision_To_Assess_DTA__c) || (oRequest.Actual_Start_Date__c < oProject.Decision_To_Assess_DTA__c)){
                    addError('Planned Start Date and Actual Start Date cannot be before DTA date of Project');
                    iserrored = true;
                }
                if((oRequest.Planned_End_Date__c > oProject.DP1_Planned_Date__c) || (oRequest.Actual_End_Date__c > oProject.DP1_Planned_Date__c)){
                    addError('Planned End Date and Actual End Date cannot be after Planned DP1 date of Project');
                    iserrored = true;
                }               
            }
            if(oRequest.Do_you_know_your_Activities__c == 'Yes'){  
                Integer count = 0; 
                for(activityWrapper oactivityWrapper : lactivityWrapper){
                    if(oactivityWrapper.issaved){
                        count = count + 1;
                    }
                }
                if(lactivityWrapper.size()-count != 0){
                    iserrored = true;
                    addError('Please save existing activity');
                }
            }
            if(iserrored == false){
                String a = oRequest.name;
                upsert oRequest;
                if(oRequest.Do_you_know_your_Activities__c == 'Yes'){
                    List<DRDW_Capability__c> lcaps = new List<DRDW_Capability__c>();
                    for(activityWrapper oactivityWrapper : lactivityWrapper){
                        DRDW_Capability__c  tempCapObject = oactivityWrapper.activityObject;
                        tempCapObject.DRDW_Request__c = oRequest.id;
                        System.debug('Capability area'+tempCapObject.Capability_Area__c);
                        if(DRDW_Constants.PublicGroupmapping.containsKey(tempCapObject.Capability_Area__c)){
                            Functional_GroupName.add(DRDW_Constants.PublicGroupmapping.get(tempCapObject.Capability_Area__c));
                        }
                        lcaps.add(tempCapObject);
                    }
                    system.debug('the groups which are linked to the request'+Functional_GroupName);
                    update lcaps;
                }
                if(currentRecordID == null) {
                    oRequest = [Select Id, Name,Status__c, Planned_Start_Date__c, Planned_End_Date__c,Actual_Start_Date__c,Actual_End_Date__c,Do_you_know_your_Activities__c from DRDW_Cap_Request__c where Id = :oRequest.Id Limit 1];
                    SendEmailNotifications();
                }
                PageReference pageref = new PageReference('/apex/DRDW_CreateERLRequest?id='+oRequest.Id+'&isEdit=false&projid='+projectRecordID);
                pageref.setredirect(true);
                return pageref;
            }else{
                return null;
            }
        }catch(Exception e){
            return null;
        }
    }
    
    Public PageReference Edit(){
        PageReference pageref = new PageReference('/apex/DRDW_CreateERLRequest?id='+currentRecordID+'&isEdit=true&projid='+oRequest.Project__c);
        pageref.setredirect(true);
        return pageref;
    }
    
    Public PageReference DeleteRecord(){
        PageReference pageref;
        delete oRequest;
        if(isIdea){
            pageref = new PageReference('/apex/DRDW_CreateIdea?id='+oRequest.Project__c+'&isEdit=false&section=#Project_Requests');
        }else if(isGen){
            pageref = new PageReference('/apex/DRDW_CreateGeneration?id='+oRequest.Project__c+'&isEdit=false&section=#Project_Requests');
        }else{
            pageref = new PageReference('/apex/DRDW_CreateAssessment?id='+oRequest.Project__c+'&isEdit=false&section=#Project_Requests');              
        }
        pageref.setredirect(true);
        return pageref;
    }
    
    Public Boolean getUserPermission(Id UserID){
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserID AND PermissionSet.Name = 'DRDW_Business_Admin']);
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
    
    Public void groupBUAssigned(){
        groupBUAssigned = new set<String>();
        List<String> allGroupIDs = new List<String>();
        for (GroupMember gm : [SELECT Id, group.id, group.DeveloperName, group.type FROM GroupMember where (UserOrGroupId = :UserInfo.getUserId())]){
            if(DRDW_Constants.groupBUMapping.containsKey(gm.group.DeveloperName)){
                groupBUAssigned.add(DRDW_Constants.groupBUMapping.get(gm.group.DeveloperName));
            }
        }
        if(groupBUAssigned.contains(oProject.Business_Unit__c)){
            isInBuGroup = true;
        }
    }
    
    Public Boolean getUserPermissionFin(Id UserID){
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserID AND PermissionSet.Name = 'DRDW_Financial_User']);
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
    
    Public Boolean getUserPermissionSc(Id UserID){
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
    
    Public Boolean getUserPermissionLoggedinUser(Id UserID){
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserID AND PermissionSet.Name IN('DRDW_Project_Manager','DRDW_ERL')]);
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
    
    public void hasRecordAccess(){
        if([SELECT RecordId,HasEditAccess FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId() AND RecordId =: oRequest.id].HasEditAccess){
            isAccessable = true;
        }
        /*if([SELECT RecordId,HasEditAccess FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId() AND RecordId =: projectRecordID].HasEditAccess){
            isAccessable = true;
        }       */ 
    }

    public void hasParentAcess(){

        if([SELECT RecordId,HasEditAccess FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId() AND RecordId =: projectRecordID].HasEditAccess){
            isParentaccess = true;
        }  
    }
    
    Public Boolean getUserPermissionFuncHead(Id UserID){
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserID AND PermissionSet.Name = 'DRDW_Functional_Head']);
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
    
    Public PageReference copyField(){                
        String costId ;
        system.debug('costid'+costId);
        PageReference pageref = new PageReference('/apex/DRDW_CostCenter?id='+costId);
        pageref.setredirect(true);
        return pageref;           
    }
    
    public PageReference ActivityLink(){
        pagereference pageref = new pagereference('/apex/DRDW_ViewActivity?id='+LinkID+'&isEdit=false');
        pageref.setredirect(true);
        return pageref;
    }
    
    //Wrapper Structure for Summary Modal Popup Table
    Public class activityWrapper{
        Public Integer index{get;set;}
        Public Boolean issaved{get;set;}
        Public Boolean isInGroup{get;set;}
        Public Boolean isAccessable{get;set;}
        Public DRDW_Capability__c activityObject{get;set;}
        Public activityWrapper(Integer index,Boolean issaved,Boolean isInGroup,Boolean isAccessable,DRDW_Capability__c activityObject){            
            this.index = index;
            this.issaved = issaved;
            this.isInGroup = isInGroup;
            this.isAccessable = isAccessable;
            this.activityObject = activityObject;
        }    
    }
    
    Public void showActivity(){
        showActivity = true;
    }  
    
    Public void showActivityOrSubmit(){
        if(oRequest.Do_you_know_your_Activities__c == 'Yes'){
            showActivity = true;
            showSubmit = true;
            activityWrapper oactivityWrapper = new activityWrapper(1,false,false,false,new DRDW_Capability__c());
            lactivityWrapper = new list<activityWrapper>(); 
            lactivityWrapper.add(oactivityWrapper);
        } 
        else if(oRequest.Do_you_know_your_Activities__c == 'No'){
            showSubmit = true;
            showActivity = false;
            if(lactivityWrapper!=null && lactivityWrapper.size()>0){
                List<DRDW_Capability__c> lAct = new List<DRDW_Capability__c>();
                for(activityWrapper oactivityWrapper : lactivityWrapper){
                    if(oactivityWrapper.issaved){
                        lAct.add(oactivityWrapper.activityObject);
                    }
                }
                if(lAct.size()>0){
                    delete lAct;
                }
            }
        }  
        else{
            showSubmit = false;
            showActivity = false;
        }  
    } 
    
    Public void EditActivities(){
        for(activityWrapper oactivityWrapper : lactivityWrapper){
            if(oactivityWrapper.index == index){
                oactivityWrapper.issaved = false;
            }
        }
    }
    
    Public void saveActivities(){
        for(activityWrapper oactivityWrapper : lactivityWrapper){
            DRDW_Capability__c  tempCapObject = oactivityWrapper.activityObject;
            system.debug('****tempCapObject '+tempCapObject);
            if(oactivityWrapper.index == index){
                boolean iserrored = false;
                if(tempCapObject.Capability__c == null || tempCapObject.Capability_Area__c == null|| tempCapObject.Planned_Start_Date__c == null|| tempCapObject.Planned_End_Date__c == null || 
                        tempCapObject.Title__c == null ){
                    addError('Please enter manadtory values.');
                    iserrored = true;
                }               
                if(tempCapObject.Planned_Start_Date__c > tempCapObject.Planned_End_Date__c){
                    addError('Planned End Date cannot be before the Planned Start Date');
                    iserrored = true;
                }
                if(tempCapObject.Actual_Start_Date__c > tempCapObject.Actual_End_Date__c){
                    addError('Actual End Date cannot be before Actual Start Date');
                    iserrored = true;
                }
                if(oRequest.Actual_Start_Date__c == Null && tempCapObject.Planned_Start_Date__c < oRequest.Planned_Start_Date__c){
                    addError('Planned Start Date cannot be before Request Planned Start Date');
                    iserrored = true;
                }
                if(oRequest.Actual_Start_Date__c != Null && tempCapObject.Planned_Start_Date__c < oRequest.Actual_Start_Date__c){
                    addError('Planned Start Date cannot be before Request Actual Start Date');
                    iserrored = true;
                }
                if(oRequest.Actual_End_Date__c == Null && tempCapObject.Planned_End_Date__c > oRequest.Planned_End_Date__c){
                    addError('Planned End Date cannot be After Request Planned End Date');
                    iserrored = true;
                }
                if(oRequest.Actual_End_Date__c != Null && tempCapObject.Planned_End_Date__c > oRequest.Actual_End_Date__c){
                    addError('Planned End Date cannot be After Request Actual End Date');
                    iserrored = true;
                }
                if(iserrored){
                    break;
                }
                try{
                    Id caprectypeid = Schema.SObjectType.DRDW_Capability__c.getRecordTypeInfosByName().get('Request Activity').getRecordTypeId();
                    oactivityWrapper.activityObject.RecordTypeId = caprectypeid;
                    oactivityWrapper.activityObject.Related_Project__c = oProject.id;
                    oactivityWrapper.activityObject.Status__c = 'Unassigned';
                    oactivityWrapper.activityObject.Type__c = 'ERL';
                    upsert oactivityWrapper.activityObject;
                    system.debug('oactivityWrapper.activityObject');
                    oactivityWrapper.issaved = true;
                }
                catch(exception e){
                    if(e.getmessage().contains('DUPLICATE_VALUE')){
                        addError('The activity with this title already exist.');
                    }
                    else{
                        addError(e.getmessage());
                    }
                }
                break;
            }
        }
    }   
    
    Public void addActivityRow(){
        Integer count = 0; 
        for(activityWrapper oactivityWrapper : lactivityWrapper){
            if(oactivityWrapper.issaved){
                count = count + 1;
            }
        }
        if(lactivityWrapper.size()-count == 0){
            activityWrapper oactivityWrapper = new activityWrapper(lactivityWrapper.size()+1,false,false,false,new DRDW_Capability__c());
            lactivityWrapper.add(oactivityWrapper);
        }   
        else{
            boolean iserrored = false;
            addError('Please save existing activity');
        } 
    }
    
    Public void subActivityRow(){
        for(activityWrapper oactivityWrapper : lactivityWrapper){
            if(oactivityWrapper.index == index){
                try{
                    if(oactivityWrapper.issaved){
                        delete oactivityWrapper.activityObject;
                        lactivityWrapper.remove(lactivityWrapper.indexOf(oactivityWrapper));
                    }
                    else{
                        lactivityWrapper.remove(lactivityWrapper.indexOf(oactivityWrapper));
                    }
                }catch(exception e){
                    addError(e.getmessage());
                }
                break;
            }        
        }
    }
    
    public void addError(string s) {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, s);
        ApexPages.addMessage(myMsg);
    }  
    
    public void SendEmailNotifications(){
        String body;
        String ReqLink = '';
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'gso_noreply@lilly.com'];
        /*if(isIdea){
        ReqLink = 'https://gso--elancodev--c.cs85.visual.force.com/apex/DRDW_CreateIdea?id='+projectRecordID+'isEdit=false';
        }else if(isGen){
        ReqLink = 'https://gso--elancodev--c.cs85.visual.force.com/apex/DRDW_CreateGeneration?id='+projectRecordID;
        }else if (isAssess) {
        ReqLink = 'https://gso--elancodev--c.cs85.visual.force.com/apex/DRDW_CreateAssessment?id='+projectRecordID;
        }else ReqLink = '';
        */
        //ReqLink = 'https://gso--elancodev--c.cs85.visual.force.com/apex/DRDW_CreateERLRequest?id='+ oRequest.Id +'&isEdit=false' ;
        ReqLink = URL.getSalesforceBaseUrl().toExternalForm()+'/apex/DRDW_CreateERLRequest?id='+ oRequest.Id +'&isEdit=false' ;
        System.debug('Request Nameeeeeee'+oRequest.Name+'::::'+ReqLink);
        if(oRequest.Do_you_know_your_Activities__c == 'No'){
            body = 'Hi, '+
            '<br><br>'+'An ERL Request has been created for '+ projectName +' and there are no Activities assigned to it.'+
            '<br>'+'Click here to review the request: '+
            '<a href="'+ReqLink+'">'+oRequest.Name+'</a>'+
            '<br><br>'+'Thank you,'+
            '<br>'+'Elanco R&D';
        }else if(oRequest.Do_you_know_your_Activities__c == 'Yes'){
            body = 'Hi, '+
            '<br><br>'+'An ERL Request has been created for '+ projectName +' with Activities that need resources allocations.'+
            '<br>'+'Click here to review the request: '+
            '<a href="'+ReqLink+'">'+ oRequest.Name+'</a>'+
            '<br><br>'+'Thank you,'+
            '<br>'+'Elanco R&D';
        }else body ='';
        String subject = 'A new ERL Request has been created';
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if ( owea.size() > 0 ) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        mail.setToAddresses(getEmailAddresses());
        mail.setSubject(subject);
        mail.setHtmlBody(body);
        if(!(test.isrunningtest())){
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    
    private List<String> getEmailAddresses() {
        List<Id> idList = new List<Id>();
        List<String> mailToAddresses = new List<String>();
        Functional_GroupName.add('DRDW_Project_Managers');
        //Adding PM Group members  
        /*Group g = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE name = 'DRDW Project Managers'];
        for (GroupMember gm : g.groupMembers) {
            idList.add(gm.userOrGroupId);
        } */
        List<Group> g = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE DeveloperName IN :Functional_GroupName];
        System.debug('Groups fetcheddddd'+g);
        for(group grp : g){
            for (GroupMember gm : grp.groupMembers) {
                idList.add(gm.userOrGroupId);
            }
        }
        //Adding ERL Heads
        List<PermissionSetAssignment> Psetlist  =[SELECT Id, AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId IN (SELECT Id FROM PermissionSet WHERE Name = 'DRDW_ERL_Head')];
        for (PermissionSetAssignment pma : Psetlist) {
            idList.add(pma.AssigneeId);
        }
        User[] usr = [SELECT email FROM user WHERE id IN :idList];
        for(User u : usr) {
            mailToAddresses.add(u.email);
        }
        return mailToAddresses;
    }
    
    public PageReference cancelRecord(){
        if(oRequest == null){
            if(lactivityWrapper!=null && lactivityWrapper.size()>0){
                List<DRDW_Capability__c> lAct = new List<DRDW_Capability__c>();
                for(activityWrapper oactivityWrapper : lactivityWrapper){
                    if(oactivityWrapper.issaved){
                        lAct.add(oactivityWrapper.activityObject);
                    }
                }
                system.debug('*********Actiity'+lAct);  
                if(lAct.size()>0){
                    delete lAct;
                }
            }
        }else{
            if(oRequest.Do_you_know_your_Activities__c == 'Yes') {     
                List<DRDW_Capability__c> lcaps = new List<DRDW_Capability__c>();
                if(lactivityWrapper!=null && lactivityWrapper.size()>0){
                    for(activityWrapper oactivityWrapper : lactivityWrapper){
                        if(oactivityWrapper.issaved){
                            DRDW_Capability__c  tempCapObject = oactivityWrapper.activityObject;
                            tempCapObject.DRDW_Request__c = oRequest.id;
                            System.debug('Capability area'+tempCapObject.Capability_Area__c);                                 
                            lcaps.add(tempCapObject);
                        }
                    }
                    update lcaps;
                } 
                if(lcaps.size()==0){
                    addError('ERL Request should have atleast one activity when (Do you know your Activities is set to Yes)');
                    return null;
                }   
            }
        }
        PageReference pageref = null;
        if(isIdea==true){
            pageref =  new PageReference('/apex/DRDW_CreateIdea?id='+projectRecordID+'&isEdit=false&section=#Project_Requests');                
        }
        if(isGen==true){
            pageref =  new PageReference('/apex/DRDW_CreateGeneration?id='+projectRecordID+'&isEdit=false&section=#Project_Requests');                  
        }
        if(isAssess==true){
            pageref =  new PageReference('/apex/DRDW_CreateAssessment?id='+projectRecordID+'&isEdit=false&section=#Project_Requests');                      
        }
        pageref.setredirect(true);
        return pageref;
    }


    Public Boolean ShowEditButton(Id UserID){
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserID AND PermissionSet.Name  = 'DRDW_Study_Managers']);
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
}