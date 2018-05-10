public class DRDW_CreateRiskController {
    public DRDW_Risk__c oRisk{get;set;}
    public id currentRecordID{get;set;}
    public string recType{get;set;}
    public id genericID {get; set;}
    public id projectId{get;set;}
    public String projectName{get;set;}
    Public Boolean isAdmin{get;set;}
    Public Boolean isAccess{get;set;}
    Public boolean isSeven {get; set;}
    public boolean isIdea{get;set;}
    public boolean isGeneration{get;set;}
    public boolean isAssessment{get;set;}
    public boolean isnewIdea{get;set;}
    Public String ImpactedPicklist{get;set;}
    Public List<SelectOption> lImpactedPicklist{get;set;}
    Public List<SelectOption> lDetailPicklist{get;set;}
    Public List<String> sImpactedPicklist{get;set;}
    public DRDW_CreateRiskController(ApexPages.StandardController controller) {
        isIdea = false;
        isGeneration = false;
        isAssessment = false;
        isnewIdea = false;
        isSeven = false;
        oRisk = (DRDW_Risk__c)controller.getRecord();
        currentRecordID = ApexPages.currentPage().getParameters().get('id');
        projectId = ApexPages.currentPage().getParameters().get('projectId'); 
        isAdmin = getUserPermission(UserInfo.getUserId()); 
        lImpactedPicklist= new List<SelectOption>();
        lDetailPicklist= new List<SelectOption>();
        isAccess = HasAccess(UserInfo.getUserId(), oRisk.Id);
        For(GLBL_Global_List_of_Values__c oglbl : [Select Name,RecordType.developerName from GLBL_Global_List_of_Values__c where Active__c = True AND RecordType.DeveloperName = 'DRDW_Elanco_Impacted_Project_Timeline_Activity' order by name ASC]){
            lImpactedPicklist.add(new SelectOption(oglbl.Name,oglbl.Name));
        }
        For(GLBL_Global_List_of_Values__c oglbl : [Select Name,RecordType.developerName from GLBL_Global_List_of_Values__c where Active__c = True AND RecordType.DeveloperName = 'DRDW_Elanco_Risk_Details' order by name ASC]){
            lDetailPicklist.add(new SelectOption(oglbl.Name,oglbl.Name));
        }
        if(currentRecordID != null){
            sImpactedPicklist = new List<String>();
            String SobjectApiName = 'DRDW_Risk__c';
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
            string query = 'select ' + commaSeparatedFields + ' from ' + SobjectApiName + ' where id =\'' + currentRecordID + '\' limit 1';
            oRisk = Database.query(query);
            if(oRisk.Impacted_Project_Timeline_Activity__c != NULL && oRisk.Impacted_Project_Timeline_Activity__c !=''){
                ImpactedPicklist = oRisk.Impacted_Project_Timeline_Activity__c;
                ImpactedPicklist = ImpactedPicklist.substring(1, ImpactedPicklist.length()-1);
                For(String s : ImpactedPicklist.split(',')){
                    sImpactedPicklist.add(s.trim());
                }
            }
            //sImpactedPicklist.addAll(ImpactedPicklist.split(','));
            Drdw_Project__c oProject = [select id,Name,Idea_Name__c,Project_Name__c, New_Idea_Name__c ,Recordtype.Name from Drdw_Project__c where id=:oRisk.Related_To__c ];
            if(oProject.Recordtype.Name == 'Idea Project')
            {
                isIdea = true;
                projectName = oProject.Idea_Name__c;
            }
            else if(oProject.Recordtype.Name == 'Generation Project'){
                isGeneration = true;
                projectName = oProject.Project_Name__c;
            }
            else if(oProject.Recordtype.Name == 'Assessment Project'){
                isAssessment = true;
                projectName = oProject.Project_Name__c;
            }
            else if (oProject.Recordtype.Name == 'Idea'){
                isnewIdea = true;
                projectName = oProject.New_Idea_Name__c;
            }
        }else{
            oRisk.Related_To__c = projectId; 
            Drdw_Project__c oProject = [select id,Name,Idea_Name__c,Project_Name__c,Business_Unit__c,New_Idea_Name__c,Recordtype.Name from Drdw_Project__c where id=:projectId ];
            oRisk.Project_Business_Unit__c = oProject.Business_Unit__c;
            if(oProject.Recordtype.Name == 'Idea Project')
            {
                isIdea = true;
                projectName = oProject.Idea_Name__c;
            }
            else if(oProject.Recordtype.Name == 'Generation Project'){
                isGeneration = true;
                projectName = oProject.Project_Name__c;
            }
            else if(oProject.Recordtype.Name == 'Assessment Project'){
                isAssessment = true;
                projectName = oProject.Project_Name__c;
            }
            else if (oProject.Recordtype.Name == 'Idea') {
                isnewIdea = true;
                projectName = oProject.New_Idea_Name__c;
            }
        }
    }
    /*
    * @Method Name                    :  saveExperiment
    * @Description                    :  Method to save Existing Experiment
    * @Return Type                    :  void
    * @Parameters                     :  None
    */
    public PageReference saveRisk(){
        pagereference pageref;
        try{
            if(oRisk.Name == ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please enter a value for the mandatory fields'));
            }else{
                if(currentRecordID == NULL){
                    insert oRisk;
                    List<Id> parentIds = new List<Id>();
                    parentIds.add(oRisk.Related_To__c );
                    DRDW_RecordSharing.getRecordIdShare(parentIds,true,true);
                    if(!Hasaccess(UserInfo.getUserId(), oRisk.Id)){
                        pageref = new PageReference('/apex/DRDW_NoAccess');
                        pageref.setredirect(true);
                        return pageref;
                    } 
                    if(isIdea){
                        pageref = new pagereference('/apex/DRDW_CreateIdea?id=' + oRisk.Related_To__c+'&isEdit=false&section=#Project_Risks');
                    }
                    else if(isGeneration){
                        pageref = new pagereference('/apex/DRDW_CreateGeneration?id=' + oRisk.Related_To__c+'&section=#Project_Risks');
                    }
                    else if(isAssessment){
                        pageref = new pagereference('/apex/DRDW_CreateAssessment?id=' + oRisk.Related_To__c+'&section=#Project_Risks');
                    }
                    else {
                        pageref = new pagereference('/apex/DRDW_CreateNewIdea?id=' + oRisk.Related_To__c+'&isEdit=false&section=#Project_Risks');
                    }                
                    pageref.setredirect(true);
                }
                else{
                    List<Id> parentIds = new List<Id>();
                    parentIds.add(oRisk.Related_To__c );
                    DRDW_RecordSharing.getRecordIdShare(parentIds,false,false);
                    String picklist = '[';   
                    for(String s:sImpactedPicklist){
                        picklist = picklist + s +',' ;
                    }   
                    if(picklist.length()>1)
                    picklist = picklist.substring(0, picklist.length()-1);
                    picklist = picklist +']';
                    oRisk.Impacted_Project_Timeline_Activity__c = picklist;
                    update oRisk;
                    DRDW_RecordSharing.getRecordIdShare(parentIds,true,false);
                    if(!Hasaccess(UserInfo.getUserId(), oRisk.Id)){
                        pageref = new PageReference('/apex/DRDW_NoAccess');
                        pageref.setredirect(true);
                        return pageref;
                    }
                    if(isIdea){
                        pageref = new pagereference('/apex/DRDW_CreateIdea?id=' + oRisk.Related_To__c+'&isEdit=false&section=#Project_Risks');
                    }
                    else if(isGeneration){
                        pageref = new pagereference('/apex/DRDW_CreateGeneration?id=' + oRisk.Related_To__c+'&section=#Project_Risks');
                    }
                    else if(isAssessment){
                        pageref = new pagereference('/apex/DRDW_CreateAssessment?id=' + oRisk.Related_To__c+'&section=#Project_Risks');
                    }
                    else {
                        pageref = new pagereference('/apex/DRDW_CreateNewIdea?id=' + oRisk.Related_To__c+'&isEdit=false&section=#Project_Risks');
                    }    
                    pageref.setredirect(true);
                }
            }
            return pageref;
        }
        catch(Exception e){
            return null;
        }
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
    * @Method Name                    :  EditRecord
    * @Description                    :  Method for editing and existing record
    * @Return Type                    :  PageReference
    * @Parameters                     :  None
    */
    public PageReference EditRecord() {
        pagereference pageref;
        pageref = new pagereference('/apex/DRDW_CreateRisk?id=' + currentRecordID + '&isEdit=true');
        pageref.setredirect(true);
        return pageref; 
    } 
    /*
    * @Method Name                    :  Cancel Record
    * @Description                    :  Method for editing and existing record
    * @Return Type                    :  PageReference
    * @Parameters                     :  None
    */
    public PageReference CancelRecord() {
        pagereference pageref;
        pageref = new pagereference('/apex/DRDW_CreateRisk?id=' + currentRecordID + '&isEdit=false');
        pageref.setredirect(true);
        return pageref; 
    } 
    
    Public PageReference DeleteRecord(){
        delete oRisk;
        pagereference pageref;
        if(isIdea){
            pageref = new pagereference('/apex/DRDW_CreateIdea?id=' + oRisk.Related_To__c+'&isEdit=false&section=#Project_Risks');
        }
        else if(isGeneration){
            pageref = new pagereference('/apex/DRDW_CreateGeneration?id=' + oRisk.Related_To__c+'&section=#Project_Risks');
        }
        else if(isAssessment){
            pageref = new pagereference('/apex/DRDW_CreateAssessment?id=' + oRisk.Related_To__c+'&section=#Project_Risks');
        }
        else{
            pageref = new pagereference('/apex/DRDW_CreateNewIdea?id=' + oRisk.Related_To__c+'&section=#Project_Risks');
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
}