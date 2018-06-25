/******************************************************************************************************************************************
* Class Name   : CreateStudyController
* Description  : controller class for create study page
* Created By   : Deloitte Consulting
*
*****************************************************************************************************************************************/
Public with sharing class CreateStudyController {
    
    public boolean isStudyCountryError {get; set;}
    public boolean isBenefitCountryError {get; set;}
    public boolean isRelatedDataAssetError {get; set;}
    public boolean isLandscapeError{get; set;}
    public List<Study_Team_Members__c> lStudyTeam {set;get;}
    public boolean isMoleculeError {get; set;}
    public boolean isStudyTeamError {get; set;}
    public boolean isError {get; set;}
    public string sFireWallMessage {get; private set;}
    public boolean bIsFirewall  {get; set;}
    public boolean IsMember {get; set;}
    Public attachment oAttachment {get; set;}
    Public boolean IsLink {get; set;}
    Public boolean IsAdmin {get; set;}
    Public List < DRDP_Study_Molecule__c > lMoleculeOnEdit {get; set;}
    Public DRDP_Study_Molecule__c oMoleculeOnEdit {get; set;}
    public ID osTeamMember {get; set;}
    public id teamMember {get; set;}
    public Project__c oStudy {get; set;}
    public Study_Country__c oStudyConductingCountry {get; set;}
    public list < Study_Country__c > lStudyConductingCountries {get; set;}
    public DRDP_Study_Molecule__c oMolecule {get; set;}
    public list < DRDP_Study_Molecule__c > lStudyMolecules {get; set;}
    public Related_Country__c oBenifitingCountry {get; set;}
    public list < Related_Country__c > lBenifitingCountries {get; set;}
    public Study_Information_Landscape__c oRelatedLandscape{get; set;}
    public list < Study_Information_Landscape__c > lLandscape{get; set;}
    public list < Request__c > lRequests {get; set;}
    public Project__share oProjectShare {get; set;}
    public Study_Team_Members__c ostMember {set;get;}
    public list < user > lStudyTeamMembers {get; set;}
    public Map<Id , String> mOverAllocated {set;get;}
    Public string IsStartStudy{get;set;}
    Public string IsResearch {get;set;}
    Public String RecordType {get;set;}
    public List<Research_team_Member__c> lResearchMember {get;set;}
    
    public id currentRecordID;
    
    public void getOverAllocated() {
      List<AggregateResult> mAllo =   [SELECT Study_Team_Members__r.Team_Member__c tm, sum(Hours_per_Week__c), Name FROM Study_Team_Allocation_Per_Week__c where Study_Team_Members__r.Study__c = :ApexPages.currentPage().getParameters().get('id') group by Study_Team_Members__r.Team_Member__c , Name];
        
    }
    
    //Loading the Constructor
    public CreateStudyController(ApexPages.StandardController controller) {
        mOverAllocated = new Map<Id , String>();
        mUserIdToName = new Map<Id , User>([Select Id , FirstName , LastName from User]);
        isStudyCountryError = false;
        isBenefitCountryError = false;
        isRelatedDataAssetError = false;
        isLandscapeError = false;
        isMoleculeError = false;
        isStudyTeamError = false;
        IsMember = False;
        IsLink = False;
        currentRecordID = ApexPages.currentPage().getParameters().get('id');
        IsStartStudy = ApexPages.currentPage().getParameters().get('startStudy');
        IsResearch = ApexPages.currentPage().getParameters().get('BPType');
        lStudyTeam = new List<Study_Team_Members__c>();
        onload();
        showRequests();
        
        //Fetching Project Ids for the current users in which he has edit access
        Set<id> sProjectIds = new Set<id>();
        for (Project__Share oShare : [Select ParentId, AccessLevel, UserOrGroupId from Project__Share where UserOrGroupId = : userinfo.getuserid() AND AccessLevel = 'Edit']) {
            sProjectIds.add(oShare.ParentId);
        }
        if (currentRecordID == NULL) {
            lMoleculeOnEdit = new List < DRDP_Study_Molecule__c >();
            oMoleculeOnEdit = new DRDP_Study_Molecule__c();
            lStudyTeamMembers = new list < user > ();
            oProjectShare = new Project__share();
            oStudy = new Project__c();
            
        } else {
            
            oProjectShare = new Project__share();
            Set < ID > lUsers = new Set < id > ();        
            lStudyTeam = [Select Id, Name, Actual_Weekly_Hours__c,Forecast_Weekly_Hours__c, Role__c,Role__r.Name, Study__c,Start_Date__c, End_Date__c,  Team_Member__r.Name from Study_Team_Members__c where Study__c = :currentRecordID];
            
            for (Project__Share oShare : [Select ParentId, AccessLevel, UserOrGroupId from Project__Share where ParentId = : currentRecordID AND AccessLevel = 'Edit']) {
                lUsers.add(oShare.UserOrGroupId);
            }
            lStudyTeamMembers = [SELECT id, Name from USER where id IN: lUsers];
            
            //Querying molecules, benifitng countries and study conducting countries for the current study
            lStudyMolecules = new list < DRDP_Study_Molecule__c > ();
            lStudyConductingCountries = new list < Study_Country__c > ();
            oMolecule = new DRDP_Study_Molecule__c();
            oStudyConductingCountry = new Study_Country__c();
            lBenifitingCountries = new list < Related_Country__c > ();
            oBenifitingCountry = new Related_Country__c();
            lLandscape = new list < Study_Information_Landscape__c > ();
            oRelatedLandscape = new Study_Information_Landscape__c();
            
            lStudyConductingCountries = [select id, Country__c, Country__r.name from Study_Country__c Where Study__c = : currentRecordID];
            lBenifitingCountries = [select id, Country__c, Country__r.name from Related_Country__c Where Project__c = : currentRecordID];
            lStudyMolecules = [select id, Molecule__c, Molecule__r.name from DRDP_Study_Molecule__c Where Project__c = : currentRecordID];
            lLandscape = [select id, Information_Landscape__c, Information_Landscape__r.name from Study_Information_Landscape__c Where Study__c = : currentRecordID];
            
            String SobjectApiName = 'Project__c';
            Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
            Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
            
            String commaSepratedFields = '';
            for (String fieldName : fieldMap.keyset()) {
                if (commaSepratedFields == null || commaSepratedFields == '') {
                    commaSepratedFields = fieldName;
                } else {
                    commaSepratedFields = commaSepratedFields + ', ' + fieldName;
                }
            }
            
            string query = 'select ' + commaSepratedFields + ' from ' + SobjectApiName + ' where id =\'' + currentRecordID + '\' limit 1';
            oStudy = Database.query(query);
            if(IsStartStudy != NULL && oStudy.Project_Status__c == 'Approved'){
                oStudy.Project_Status__c = 'Active';
            }
            
            if(oStudy.Research_Type__c == 'Research Topic'){
                RecordType = 'Research Topic';
            }
            
            If(lUsers.contains(UserInfo.getuserid()) || oStudy.OwnerId == UserInfo.getuserid()) {
                IsMember = True;
            }
            
            For(UserRecordAccess oAccess : [Select RecordId, HasReadAccess, HasEditAccess, HasDeleteAccess FROM  UserRecordAccess WHERE UserId = :UserInfo.getUserId() AND RecordId = : currentRecordID]) {
                If(oAccess.HasEditAccess == TRUE) {
                    IsMember = True;
                }
            }
            
            Boolean IsQuestionnairePresent = False;
            If([Select Id,Study_Type__c from Questionaire__c where Active__c = TRUE AND Study_Type__c =: oStudy.Study_Description__c].size() > 0){
                IsQuestionnairePresent = True;
            }
            
            If((IsMember) && (IsQuestionnairePresent) && (oStudy.Project_Status__c == 'Active' || oStudy.Project_Status__c == 'Completed' || oStudy.Project_Status__c == 'Closed')) {
                IsLink = True;
            }
        }
        
        
    }
    
    Public void UpdateStudyOnBpChange(){
        if(oStudy.Related_Business_Planning__c != null || oStudy.Related_Business_Planning__c !=''){
            Business_Planning__c obp = new Business_Planning__c();
            obp = [select id,Classification__c,Study_Description__c,Secondary_Study_Type__c,Estimated_Start_Date__c,Actual_Start_Date__c,PM__c,Therapeutic_Area_Primary__c,Executing_Function__c,Target_Audience__c,Approver_Table__c,Primary_Purpose__c,Business_Unit_Primary__c,Title__c,Study_Type__c,Study_Sub_Type__c,Description__c,Study_Region__c,Estimated_End_Date__c,How_will_the_Study_be_executed__c,BPType__c,Will_HCPs_be_paid_for_participation__c from Business_Planning__c where id =: oStudy.Related_Business_Planning__c LIMIT 1];
            oStudy.Anticipated_Start_Date__c = obp.Estimated_Start_Date__c;
            oStudy.Actual_Start_Date__c = obp.Actual_Start_Date__c;
            oStudy.Project_Manager__c = obp.PM__c;
            oStudy.Therapeutic_Area_Primary__c = obp.Therapeutic_Area_Primary__c;
            oStudy.Execution_Function__c = obp.Executing_Function__c;
            oStudy.Target_Audience__c = obp.Target_Audience__c;
            oStudy.Approver_Table__c = obp.Approver_Table__c;
            oStudy.Classification__c = obp.Classification__c;
            oStudy.Study_Description__c = obp.Study_Description__c;
            oStudy.Secondary_Study_Type__c = obp.Secondary_Study_Type__c;
            oStudy.Primary_Purpose__c= obp.Primary_Purpose__c;
            oStudy.Business_Unit_Primary__c = obp.Business_Unit_Primary__c;
            If(obp.Title__c.length() > 80) {
                oStudy.Name = obp.Title__c.substring(0, 80);
            }
            Else {
                oStudy.Name = obp.Title__c;
            }
            oStudy.Study_Description__c = obp.Study_Type__c;
            oStudy.Description__c = obp.Description__c;
            oStudy.Secondary_Study_Type__c = obp.Study_Sub_Type__c;
            oStudy.Description__c = obp.Description__c;
            oStudy.Study_Region__c = obp.Study_Region__c;
            oStudy.Anticipated_End_Date__c = obp.Estimated_End_Date__c;
            oStudy.Execution_Resource__c = obp.How_will_the_Study_be_executed__c;
            oStudy.Project_Status__c = 'Approved';
            //oStudy.Classification__c = 'Basic Research';
            //oStudy.OwnerId = obp.OwnerId;
            oStudy.Related_Business_Planning__c = obp.Id;
            oStudy.Will_HCPs_be_paid_for_participation__c = obp.Will_HCPs_be_paid_for_participation__c;
        }
        
        
    }
    
    public void delTeamMember() {
        try {
            Study_Team_Members__c memObj = new Study_Team_Members__c(ID = osTeamMember);
            delete memObj;
        } catch(Exception e) { System.debug('***line 152'+e.getStackTraceString()+'osTeamMember => '+osTeamMember);  }
    lStudyTeam = [Select Id, Name, Forecast_Weekly_Hours__c,Actual_Weekly_Hours__c, Role__c,Role__r.Name, Study__c,Start_Date__c, End_Date__c,  Team_Member__r.Name from Study_Team_Members__c where Study__c = :currentRecordID];
    }
    
    /*
* @Method Name                    :  save
* @Description                    :  Method to Save the Study record
* @Return Type                    :  PageReference
* @Parameters                     :  None
*/
    public PageReference save() {
        //try {
            list<DRDP_Study_Molecule__c> lMoles = New list<DRDP_Study_Molecule__c>();
            list <Study_Country__c> lcntrs = new list <Study_Country__c>();
            list <Related_Country__c> lBnftcntrs = new list <Related_Country__c>();
            
            
            If(currentRecordID != NULL && (RecordType != 'Research Topic' || RecordType == NULL)) {
                
                lMoles = [select id, Molecule__c, Molecule__r.name from DRDP_Study_Molecule__c Where Project__c = : currentRecordID];
                lcntrs = [select id, Country__c, Country__r.name from Study_Country__c Where Study__c = : currentRecordID];
                If(oStudy.Is_Molecule__c == 'LY Yes' && lMoles.size() == 0 && oStudy.DataLoaded_TF__c == FALSE && oStudy.Study_Description__c != 'Modeling' && oStudy.Study_Description__c != 'Systematic Literature Review') {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please add molecules to your Study');
                    ApexPages.addMessage(myMsg);
                    isError = TRUE;
                    return Null;
                }
                If(lcntrs.size() == 0 && (oStudy.Project_Status__c == 'Active' || oStudy.Project_Status__c == 'Completed' || oStudy.Project_Status__c == 'Closed') && oStudy.DataLoaded_TF__c == FALSE && oStudy.Classification__c == 'Study') {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please add study conducting countries to your Study');
                    ApexPages.addMessage(myMsg);
                    isError = TRUE;
                    return Null;
                }
                
                if (oStudy.Project_Manager__c != NULL) {
                    boolean b = false;
                    for (Project__Share oShare : [Select ParentId, AccessLevel, UserOrGroupId from Project__Share where ParentId = : currentRecordID AND AccessLevel = 'Edit']) {
                        if (oShare.UserOrGroupId == oStudy.Project_Manager__c) {
                            b = true;
                            break;
                        }
                    }
                    if (b == false && oStudy.OwnerId == UserInfo.getUserId()) {
                        Project__Share oProjectShare = new Project__Share();
                        oProjectShare.UserOrGroupId = oStudy.Project_Manager__c;
                        oProjectShare.ParentId = currentRecordID;
                        oProjectShare.AccessLevel = 'Edit';
                        insert oProjectShare;
                    }
                }
                
            }else if(currentRecordID == NULL && IsResearch == 'Research_Study'){
                oStudy.Research_Type__c = 'Research Topic';
                oStudy.Project_Status__c = 'In Progress';
            }else if(currentRecordID == NULL && IsResearch != 'Research_Study'){
                oStudy.Research_Type__c = 'Research Study';
            }
            
            
            upsert oStudy;
            if(isStudyUnderApproval(oStudy.Id) ) {
                // Create an approval request for the Study
                If((oStudy.Project_Status__c != 'Approved' || oStudy.Project_Status__c != 'Pending Approval') && (currentRecordID != null && RecordType != 'Research Topic')){
                    Approval.ProcessSubmitRequest req1 = 
                        new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for approval.');
                    req1.setObjectId(oStudy.id);
                    
                    // Submit the approval request for the Study
                    Approval.ProcessResult result = Approval.process(req1);
                }
            }
            
                       
            pagereference pageref;
            if (currentRecordID == NULL && IsResearch != 'Research_Study') {
                pageref = new pagereference('/apex/CreateStudy?id=' + oStudy.id + '&isEdit=true');
            } else if(currentRecordID != NULL && (RecordType != 'Research Topic' || RecordType == NULL)){
                //InsertTask();
                pageref = new pagereference('/apex/CreateStudy?id=' + oStudy.id + '&isEdit=false');
            }else if(currentRecordID == NULL && IsResearch == 'Research_Study'){
                pageref = new pagereference('/apex/Research_Topics?id=' + oStudy.id + '&isEdit=true');
            }else{
                pageref = new pagereference('/apex/Research_Topics?id=' + oStudy.id + '&isEdit=false');
            }
            pageref.setredirect(true);
            return pageref;
        /*} catch (exception e) {
            String error = e.getdmlMessage(0);
            if(error.contains('insufficient access rights on cross-reference id')){
                addError('Lead/Owner and Project Manager cannot be the same user');
            }else{
                addError(error);
            }
            isError = TRUE;
            return null;
        }*/
    }
    
    Public void InsertTask(){
        // Added for checklist functionality
        // Commented Checklist Functionality for Deploying to DRDP Full Edition
         /*   system.debug('##########'+oStudy.Research_Type__c+'ooooooo'+oStudy.Secondary_Study_Type__c);
            List<DRDW_Checklist_Master__c> lChecklistMaster = [Select ID from DRDW_Checklist_Master__c where Study_Type__c=: oStudy.Research_Type__c and Study_Sub_Type__c =: oStudy.Secondary_Study_Type__c limit 1];
            List<DRDW_Study_Checklist__c> lStudyChecklist = new List<DRDW_Study_Checklist__c>();
            for(DRDW_Checklist_Item__c oChecklistItem : [Select id from DRDW_Checklist_Item__c where DRDW_Checklist_Master__c = : lChecklistMaster[0].ID]){
            
                DRDW_Study_Checklist__c oStudyChecklist = new DRDW_Study_Checklist__c();
                oStudyChecklist.Assigned_User__c = oChecklistItem.Assigned_User__c;
                oStudyChecklist.Research__c = oStudy.Id;
                oStudyChecklist.Status__c = 'Not started';
                
                lStudyChecklist.add(oStudyChecklist);
            }        
            
            Insert lStudyChecklist; */
    }
    
    public Boolean isStudyUnderApproval(ID studyId) {
        list<ProcessInstance> existingApprovals = [SELECT Id, TargetObjectId
                                                   FROM ProcessInstance 
                                                   WHERE TargetObjectId = :studyId
                                                  ];
        if(existingApprovals.size() > 0) {
            return false;
        } else return true;
    }
    
    
    /*
* @Method Name                    :  AddStudyTeamMember
* @Description                    :  Method to add a new study team member
* @Return Type                    :  void
* @Parameters                     :  None
*/
    /*
Public void AddStudyTeamMember() {
if (currentRecordID != NULL) {
try {

for (Project__Share oShare : [Select ParentId, AccessLevel, UserOrGroupId from Project__Share where ParentId = : currentRecordID AND AccessLevel = 'Edit']) {
if (oShare.UserOrGroupId == oProjectShare.UserOrGroupId) {
ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an error adding Team Member. Please Contact your Administrator ');
ApexPages.addMessage(myMsg);
isStudyTeamError = true;
return ;

}
}

oProjectShare.ParentId = currentRecordID;
oProjectShare.AccessLevel = 'Edit';
insert oProjectShare;
lStudyTeamMembers.add([SELECT id, name from user where id = : oProjectShare.UserOrGroupId limit 1]);
oProjectShare = new Project__Share();
} catch (exception e) {
addError(e.getmessage());
}
}
} */
    
    public void SaveTeamMember() {
        try {
            upsert lStudyTeam;
        } catch(Exception e) { }
    }
    
    public List<SelectOption> getMemberRoles() {
        List<SelectOption> lMemberRoles = new List<SelectOption>();
        for(DRDP_Member_Roles__c orole : [Select ID, Name from DRDP_Member_Roles__c]) {
            lMemberRoles.add(new SelectOption(orole.Id, orole.Name));
        }
        return lMemberRoles;
    }
    Public Map<Id , User> mUserIdToName {set;get;}
    public Set<Id> sUserId {set;get;}
    Public void AddStudyTeamMember() {
        if(lStudyTeam == NULL) {
            lStudyTeam = new List<Study_Team_Members__c>();
        }
        if(sUserId == NULL) {
         sUserId = new Set<Id>();
        }
        oSTMember = new Study_Team_Members__c();
        List<User> lUserName = [Select Name , Id from User where Id = :oProjectShare.UserOrGroupId];
        if (currentRecordID != NULL) {
            try {
                for (Study_Team_Members__c ostMember : [SELECT Id, Name, Study__c,Team_Member__c,Team_Member__r.Name, Role__c,Role__r.Name, Hours__c FROM Study_Team_Members__c where Study__c = :currentRecordID]) {
                    sUserId.add(ostMember.Team_Member__c);
                }
                ostMember.Study__c = currentRecordID;
                oSTMember.Team_Member__c = oProjectShare.UserOrGroupId;
                if(oSTMember.Hours__c == NULL) {
                oSTMember.Hours__c = 0;
                }
                if(oProjectShare.UserOrGroupId != NULL && !sUserId.contains(oProjectShare.UserOrGroupId)) {
                sUserId.add(oProjectShare.UserOrGroupId);
                lStudyTeam.add(ostMember);
                }
                System.debug(lStudyTeam);
                ostMember = new Study_Team_Members__c();
                oProjectShare = new Project__Share();
            } catch (exception e) {
                addError(e.getmessage()+e.getLineNumber());
            }
        }
    }
    
    /*
* @Method Name                    :  RemoveStudyTeamMember
* @Description                    :  Method to remove a study team member
* @Return Type                    :  void
* @Parameters                     :  None
*/
    
    
    Public void RemoveStudyTeamMember() {
        try{
            Project__Share oShare = [Select ParentId, AccessLevel, UserOrGroupId from Project__Share where ParentId = : currentRecordID AND UserOrGroupId = : teamMember];
            delete oShare;
            Set < ID > lUsers = new Set < id > ();
            for (Project__Share oShared : [Select ParentId, AccessLevel, UserOrGroupId from Project__Share where ParentId = : currentRecordID AND AccessLevel = 'Edit']) {
                lUsers.add(oShared.UserOrGroupId);
            }
            lStudyTeamMembers = [SELECT id, Name from USER where id IN: lUsers];
        }
        catch (exception e){
            addError(e.getmessage());
        }
    }
    
    /*
* @Method Name                    :  AddStudyConductingCountry
* @Description                    :  Method to add a new study team member
* @Return Type                    :  void
* @Parameters                     :  None
*/
    Public void AddStudyConductingCountry() {
        if (currentRecordID != NULL) {
            try {
                oStudyConductingCountry.Study__c = currentRecordID;
                
                insert oStudyConductingCountry;
                
                lStudyConductingCountries = [select id, Country__c, Country__r.name from Study_Country__c Where Study__c = : currentRecordID];
                
                oStudyConductingCountry = new Study_Country__c();
            } catch (exception e) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an error adding Country. Please Contact your Administrator ');
                ApexPages.addMessage(myMsg);
                isStudyCountryError = true;
                
            }
            
        }
    }
    
    /*
* @Method Name                    :  RemoveStudyConductingCountry
* @Description                    :  Method to remove a Study Conducting Country
* @Return Type                    :  void
* @Parameters                     :  None
*/
    
    Public void RemoveStudyConductingCountry() {
        try {
            lStudyConductingCountries = [select id, Country__c, Country__r.name from Study_Country__c Where Study__c = : currentRecordID];
            If((oStudy.Project_Status__c == 'Active' || oStudy.Project_Status__c == 'Completed' || oStudy.Project_Status__c == 'Closed') && lStudyConductingCountries.size() == 1) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Study should have atleast one Study Conducting Country');
                ApexPages.addMessage(myMsg);
            } else {
                Study_Country__c oStudyConductingCountry = [Select id from Study_Country__c where Study__c = : currentRecordID AND Country__c = : teamMember];
                delete oStudyConductingCountry;
                lStudyConductingCountries = [select id, Country__c, Country__r.name from Study_Country__c Where Study__c = : currentRecordID];
            }
            
        } catch (exception e) {
            addError(e.getmessage());
            isStudyCountryError = true;
        }
    }
    /*
* @Method Name                    :  AddMolecule
* @Description                    :  Method to add a new study team member
* @Return Type                    :  void
* @Parameters                     :  None
*/
    Public void AddMolecule() {
        if (currentRecordID != NULL) {
            try {
                oMolecule.Project__c = currentRecordID;
                
                
                insert oMolecule;
                
                lStudyMolecules = [select id, Molecule__c, Molecule__r.name from DRDP_Study_Molecule__c Where Project__c = : currentRecordID];
                oMolecule = new DRDP_Study_Molecule__c();
            } catch (exception e) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an error adding Molecule. Please Contact your Administrator ');
                ApexPages.addMessage(myMsg);
                isMoleculeError = true;
            }
        }
    }
    /*
* @Method Name                    :  RemoveMolecule
* @Description                    :  Method to remove a Study Conducting Country
* @Return Type                    :  void
* @Parameters                     :  None
*/
    
    Public void RemoveMolecule() {
        try {
            lStudyMolecules = [select id, Molecule__c, Molecule__r.name from DRDP_Study_Molecule__c Where Project__c = : currentRecordID];
            If(oStudy.Is_Molecule__c == 'LY Yes' && lStudyMolecules.size() == 1 ) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Study should have atleast one Molecule');
                ApexPages.addMessage(myMsg);
            } else {
                DRDP_Study_Molecule__c oMol = [Select id from DRDP_Study_Molecule__c where Project__c = : currentRecordID AND Molecule__c = : teamMember];
                delete oMol;
                
                lStudyMolecules = [select id, Molecule__c, Molecule__r.name from DRDP_Study_Molecule__c Where Project__c = : currentRecordID];
            }
        } catch (exception e) {
            addError(e.getmessage());
            isMoleculeError = true;
        }
        
    }
    /*
* @Method Name                    :  AddBenifitingCountry
* @Description                    :  Method to add a new study team member
* @Return Type                    :  void
* @Parameters                     :  None
*/
    Public void AddBenifitingCountry() {
        if (currentRecordID != NULL) {
            try {
                oBenifitingCountry.Project__c = currentRecordID;
                
                insert oBenifitingCountry;
                
                lBenifitingCountries = [select id, Country__c, Country__r.name from Related_Country__c Where Project__c = : currentRecordID];
                
                
                oBenifitingCountry = new Related_Country__c();
            } catch (exception e) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an error adding Country. Please Contact your Administrator ');
                ApexPages.addMessage(myMsg);
                isBenefitCountryError = true;
            }
        }
    }
    /*
* @Method Name                    :  RemoveBenifitingCountry
* @Description                    :  Method to remove a Study Conducting Country
* @Return Type                    :  void
* @Parameters                     :  None
*/
    
    Public void RemoveBenifitingCountry() {
        try {
            
            lBenifitingCountries = [select id, Country__c, Country__r.name from Related_Country__c Where Project__c = : currentRecordID];
            
            Related_Country__c oCntry = [Select id from Related_Country__c where Project__c = : currentRecordID AND Country__c = : teamMember];
            delete oCntry;
            
            lBenifitingCountries = [select id, Country__c, Country__r.name from Related_Country__c Where Project__c = : currentRecordID];
            
        } catch (exception e) {
            addError(e.getmessage());
            isBenefitCountryError = true;
        }
        
    }
    
    
    /*
* @Method Name                    :  showRequests
* @Description                    :  Method to show a list of Requests.
* @Return Type                    :  void
* @Parameters                     :  None
*/
    
    Public void showRequests() {
        
        lRequests = [select id, name, Request_Status__c, RecordType.Name from Request__c Where Related_Project__c = : currentRecordID];
    }
    
    
    /*
* @Method Name                    :  goToRequests
* @Description                    :  Method to select Request for creating a New Request.
* @Return Type                    :  void
* @Parameters                     :  None
*/
    
    Public PageReference goToRequests() {
        
        PageReference pRequest = new PageReference('/apex/SelectRequest?id=' + currentRecordID);
        pRequest.setredirect(true);
        return pRequest;
        
    }
    
    
    /*
* @Method Name                    :  EditRecord
* @Description                    :  Method for editing and existing record
* @Return Type                    :  PageReference
* @Parameters                     :  None
*/
    public PageReference EditRecord() {
        pagereference pageref = new pagereference('/apex/CreateStudy?id=' + currentRecordID + '&isEdit=true');
        pageref.setredirect(true);
        return pageref;
    }
    
    /*
* @Method Name                    :  EditRecord
* @Description                    :  Method for editing and existing record
* @Return Type                    :  PageReference
* @Parameters                     :  None
*/
    public PageReference EditRecordResearch() {
        pagereference pageref = new pagereference('/apex/Research_Topics?id=' + currentRecordID + '&isEdit=true');
        pageref.setredirect(true);
        return pageref;
    }
    
    
    
    /*
* @Method Name                    :  addError
* @Description                    :  Method for adding apex error
* @Return Type                    :  void
* @Parameters                     :  string
*/
    public void addError(string s) {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, s);
        ApexPages.addMessage(myMsg);
    }
    /*
* @Method Name                    :  copyCountries
* @Description                    :  Method for Copying countries from Benifiting to conducted.
* @Return Type                    :  void
* @Parameters                     :  none.
*/
    public void copyCountries() {
        try{
            lBenifitingCountries = [select id, Country__c , Country__r.name from Related_Country__c Where Project__c = : currentRecordID];
            lStudyConductingCountries = [select id, Country__c, Country__r.name from Study_Country__c Where Study__c = : currentRecordID];
            List<Study_Country__c> lStudyCountriesToBeAdded = new List<Study_Country__c>();
            
            Map<id,id> mCountriesToBeAdded = new Map<id,id>();
            for(Study_Country__c country : lStudyConductingCountries)
            {
                mCountriesToBeAdded.put(country.Country__c, country.id);
            }
            for(Related_Country__c country : lBenifitingCountries)
            {
                if(!mCountriesToBeAdded.containsKey(country.Country__c))
                {
                    Study_Country__c OStudyCountry = new Study_Country__c();
                    OStudyCountry.Country__c = country.Country__c;
                    OStudyCountry.Study__c = currentRecordID;
                    lStudyCountriesToBeAdded.add(OStudyCountry);
                }
            }
            insert lStudyCountriesToBeAdded;
            lStudyConductingCountries = [select id, Country__c, Country__r.name from Study_Country__c Where Study__c = : currentRecordID];
        }
        catch (exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an error adding Countries. Please Contact your Administrator ');
            ApexPages.addMessage(myMsg);
            isStudyCountryError = true;
        }
    }
    
    
    /*
* @Method Name                    :  onload
* @Description                    :  Method for checking firewall
* @Return Type                    :  pagereference
* @Parameters                     :  none
*/
    
    public void onload() {
        bIsFirewall = false;
        Set < ID > lUsers = new Set < id > ();
        for (Project__Share oShare : [Select ParentId, AccessLevel, UserOrGroupId from Project__Share where ParentId = : currentRecordID]) {
            lUsers.add(oShare.UserOrGroupId);
        }
        for (DRDP_Study_Molecule__c oMolecule : [Select id, Molecule__c, Molecule__r.Firewall_Message__c, Molecule__r.Firewalled__c from DRDP_Study_Molecule__c where Project__c = :currentRecordID]) {
            if (oMolecule.Molecule__r.Firewalled__c && (!lUsers.contains(UserInfo.getUserId()) && ApexPages.currentPage().getParameters().get('isEdit') == NULL  )) {
                bIsFirewall = true;
                sFireWallMessage = oMolecule.Molecule__r.Firewall_Message__c;
                break;
            }
        }
        
    }
    
    /*
* @Method Name                    :  AddLandscape
* @Description                    :  Method to add a new Related Landscape
* @Return Type                    :  void
* @Parameters                     :  None
*/
    Public void AddLandscape() {
        if (currentRecordID != NULL) {
            try {
                oRelatedLandscape.Study__c = currentRecordID;
                
                insert oRelatedLandscape;
                
                lLandscape = [select id, Information_Landscape__c, Information_Landscape__r.name from Study_Information_Landscape__c Where Study__c = : currentRecordID];
                
                oRelatedLandscape = new Study_Information_Landscape__c();
            } catch (exception e) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an error adding Information Landscape. Please Contact your Administrator ');
                ApexPages.addMessage(myMsg);
                isLandscapeError = true;
            }
        }
    }
    /*
* @Method Name                    :  RemoveLandscape
* @Description                    :  Method to remove a Related Landscape
* @Return Type                    :  void
* @Parameters                     :  None
*/
    
    Public void RemoveLandscape() {
        try {
            
            lLandscape = [select id, Information_Landscape__c, Information_Landscape__r.name from Study_Information_Landscape__c Where Study__c = : currentRecordID];
            
            Study_Information_Landscape__c oRelLandscape = [Select id from Study_Information_Landscape__c where Study__c = : currentRecordID AND Information_Landscape__c = : teamMember];
            delete oRelLandscape;
            
            lLandscape = [select id, Information_Landscape__c, Information_Landscape__r.name from Study_Information_Landscape__c Where Study__c = : currentRecordID];
            
        } catch (exception e) {
            addError(e.getmessage());
            isLandscapeError = true;
        }
        
    }
    
    
    /*
* @Method Name                    :  UpdateRecordResearchStatus
* @Description                    :  Method for Activate reseach button
* @Return Type                    :  void
* @Parameters                     :  none
*/
    
    public void UpdateRecordResearchStatus() {
        oStudy.Project_Status__c = 'Approved';
        update oStudy;
    }
    
    
    /*
* @Method Name                    :  acknowledge
* @Description                    :  Method for acknowledge button
* @Return Type                    :  pagereference
* @Parameters                     :  none
*/
    
    public pagereference acknowledge() {
        bIsFirewall = false;
        PageReference pRedirectObjectPageReference = new PageReference('/apex/CreateStudy?Id=' + currentRecordID);
        Map<String, String> mPageParameters = pRedirectObjectPageReference.getParameters();
        mPageParameters.put('nooverride', '1');
        mPageParameters.put('IsEdit', 'false');
        mPageParameters.putall(ApexPages.currentPage().getParameters());
        return pRedirectObjectPageReference;
    }
    
    /*
* @Method Name                    :  back
* @Description                    :  Method for back button
* @Return Type                    :  pagereference
* @Parameters                     :  none
*/
    
    public pagereference back() {
        PageReference pRedirectObjectPageReference = new PageReference('/apex/StudyList');
        Map<String, String> mPageParameters = pRedirectObjectPageReference.getParameters();
        mPageParameters.put('nooverride', '1');
        return pRedirectObjectPageReference;
    }
    
    
    Public void createTaskonStudyCreation(){
        
    
    }
    
    
}