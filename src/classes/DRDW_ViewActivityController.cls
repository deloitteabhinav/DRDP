public without sharing class DRDW_ViewActivityController {
    public DRDW_Capability__c  oActivity {get; set;}
    public Id currentRecordID {get; set;}
    public List<DRDW_Budget_Master__c> lbudgets {get; set;}
    public Decimal totalforecast{get;set;}
    public id genericID {get; set;}
    public boolean isbError {get; set;}
    public id LinkID2 {get; set;}
    Public Boolean isAdmin{get;set;}
    Public Boolean isFin{get;set;} 
    public boolean isIdea{get;set;}
    public boolean isGeneration{get;set;}
    public boolean isAssessment{get;set;}
    public String projectName{get;set;} 
    Public id resourseId{get;set;}
    Public List<SelectOption> lAreaPicklist{get;set;}
    Public List<SelectOption> lCapabilityPicklist{get;set;}
    Public set<String> PSAssigned{get;set;}
    Public set<String> groupAssigned{get;set;}
    Public set<String> groupBUAssigned{get;set;}
    Public boolean isFunctionalHead{get;set;}
    Public boolean isGroupUser{get;set;}
    Public boolean isPmErl{get;set;}
    Public boolean isSc{get;set;}
    Public boolean isAccessable{get;set;}
    Public boolean isBUGroupUser{get;set;}
    Public Drdw_Project__c oProject;
    Public DRDW_Cap_Request__c oRequest;
    Public list<DRDW_Assign_Resource__c> lAssignedResources{get;set;}
    //Loading the Constructor
    public DRDW_ViewActivityController (ApexPages.StandardController controller) {
        oActivity = (DRDW_Capability__c)controller.getRecord();  
        permissionSetAssigned();
        currentRecordID = ApexPages.currentPage().getParameters().get('id');
        if(PSAssigned.contains('DRDW_Business_Admin')){
            isAdmin = true;
        }
        if(PSAssigned.contains('DRDW_Financial_User')){
            isFin = true;
        }
        if(PSAssigned.contains('DRDW_Functional_Head')){
            isFunctionalHead = true;
        }
        if(PSAssigned.contains('DRDW_Project_Manager')||PSAssigned.contains('DRDW_ERL')){
            isPmErl = true;
        }
        if(PSAssigned.contains('DRDW_Scientist')){
            isSc = true;
        }
        lAreaPicklist = new List<SelectOption>();
        lCapabilityPicklist = new List<SelectOption>();
        For(GLBL_Global_List_of_Values__c oglbl : [Select Name,RecordType.developerName from GLBL_Global_List_of_Values__c where Active__c = True AND RecordType.DeveloperName = 'DRDW_Elanco_Capability_Area' order by name ASC]){
            lAreaPicklist.add(new SelectOption(oglbl.Name,oglbl.Name));               
        }
        lAreaPicklist.add(new SelectOption('Other','Other'));
        if(currentRecordID != null){
            //Quering the Activity
            String SobjectApiName = 'DRDW_Capability__c';
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
            commaSeparatedFields = commaSeparatedFields + ',DRDW_Request__r.Name';
            string query = 'select ' + commaSeparatedFields + ' from ' + SobjectApiName + ' where id =\'' + currentRecordID + '\' limit 1';
            oActivity = Database.query(query);
            oRequest = [Select id,Planned_Start_Date__c,Actual_Start_Date__c,Planned_End_Date__c,Actual_End_Date__c from DRDW_Cap_Request__c where id=:oActivity.DRDW_Request__c];
            UpdateArea();
            //levals = [Select Id, Name, Idea_Name__c, Business_Unit__c, Decision_to_Evaluate_DTE__c, ERL_Primary_Contact__c,Duration__c from DRDW_Project__c where Related_Idea__c = :currentRecordID];
            //lrisks = [Select Id, Name,Title__c, Description_gap__c from DRDW_Risk__c where Related_To__c =:currentRecordID ]; 
            lbudgets = [Select id,Name ,Titletab__c,Scientist_Owner__c,Title__c,PO__c,Activity_Name__c,Vendorr__c,Total_Contract_Value__c,Total_Actuals__c,Cost_Center__r.Name from DRDW_Budget_Master__c where Activity__c =: currentRecordID];
            groupAssigned();  
            fetchResourceList();
            //Logic for the Total Rolling forecast field on Project records
            totalforecast = 0;
            Integer tempqrtr = System.today().month();
            String quarter;
            Decimal TotalRF = 0;
            System.debug('Quarttttteerrrrr'+tempqrtr);
            if(tempqrtr > 0 && tempqrtr < 4){
                quarter = '1';
            }else if(tempqrtr > 3 && tempqrtr < 7){
                quarter = '2';
            }else if(tempqrtr > 6 && tempqrtr < 10){
                quarter = '3';
            }else if(tempqrtr > 9 && tempqrtr < 13){
                quarter = '4';
            }
            List<DRDW_Budget_Summary__c> lstsummaries = [Select Id, Quarter__c, F_X_Forecast__c from DRDW_Budget_Summary__c where DRDW_Budget_Master__c IN :lbudgets and Quarter__c = :quarter];
            System.debug('List of summary recordssssssssss'+lstsummaries);
            if(lstsummaries!=null && !lstsummaries.isEmpty() && lstsummaries.size()>1){
                for(DRDW_Budget_Summary__c tmpsmmry : lstsummaries){
                    TotalRF = TotalRF + tmpsmmry.F_X_Forecast__c;
                }
                totalforecast = TotalRF.round(System.RoundingMode.HALF_EVEN);
            }
            else if(lstsummaries.size() == 1){
                totalforecast = lstsummaries[0].F_X_Forecast__c.round(System.RoundingMode.HALF_EVEN);
            }
            if(oActivity.Related_Project__c != null){
                oProject = [select id,Name,Name__c,Business_Unit__c,Idea_Name__c,Project_Name__c, New_Idea_Name__c ,Recordtype.Name from Drdw_Project__c where id=:oActivity.Related_Project__c ];
                if(oProject.Recordtype.Name == 'Idea Project')
                {
                    isIdea = true;
                    projectName = oProject.Name__c;
                }
                else if(oProject.Recordtype.Name == 'Generation Project'){
                    isGeneration = true;
                    projectName = oProject.Name__c;
                }
                else if(oProject.Recordtype.Name == 'Assessment Project'){
                    isAssessment = true;
                    projectName = oProject.Name__c;
                }
            }
            hasRecordAccess();
        }
        else{          
        }
        /*isAdmin = getUserPermission(UserInfo.getUserId());
        isFin = getUserPermissionFin(UserInfo.getUserId());
        isAccess = HasAccess(UserInfo.getUserId(), oIdea.Id);*/
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
    
    Public void UpdateArea(){
        lCapabilityPicklist.clear();
        For(GLBL_Global_List_of_Values__c oglbl : [Select Name,RecordType.developerName,Parent__r.Name from GLBL_Global_List_of_Values__c where Active__c = True AND Parent__r.Name =: oActivity.Capability_Area__c AND RecordType.DeveloperName = 'DRDW_Elanco_Capability' order by name ASC]){
            lCapabilityPicklist.add(new SelectOption(oglbl.Name,oglbl.Name));
        }
    }    
    /*
    * @Method Name                    :  RemoveRisk
    * @Description                    :  Method to remove a Risk
    * @Return Type                    :  void
    * @Parameters                     :  None
    */
    Public void RemoveBudget() {
        try {
            lbudgets = [Select id,Name ,Titletab__c,Scientist_Owner__c,Title__c,PO__c,Activity_Name__c,Vendorr__c,Total_Contract_Value__c,Total_Actuals__c,Cost_Center__r.Name from DRDW_Budget_Master__c where Activity__c=: currentRecordID];
            DRDW_Budget_Master__c oExp = [Select id from DRDW_Budget_Master__c where Activity__c = :currentRecordID AND id = : genericID];
            delete oExp;
            lbudgets = [Select id,Name ,Titletab__c,Scientist_Owner__c,Title__c,PO__c,Activity_Name__c,Vendorr__c,Total_Contract_Value__c,Total_Actuals__c,Cost_Center__r.Name from DRDW_Budget_Master__c where Activity__c=: currentRecordID];
        } 
        catch (exception e) {
            addError(e.getmessage());
            isbError = true;
        } 
    } 
    
    /*
    * @Method Name                    :  EditCreateExpRecord
    * @Description                    :  Method for creating a new Experiment
    * @Return Type                    :  PageReference
    * @Parameters                     :  None
    */
    public PageReference AddBudget(){
        pagereference pageref = new pagereference('/apex/DRDW_CreateBudgetMaster?parentID='+ currentRecordID);
        pageref.setredirect(true);
        return pageref;
    }
    
    public PageReference AddBudgetCap(){
        pagereference pageref = new pagereference('/apex/DRDW_CreateBudgetMaster?capid='+ currentRecordID+'&parentid='+oActivity.Related_Project__c);
        pageref.setredirect(true);
        return pageref;
    }
    /*
    * @Method Name                    :  GenLink
    * @Description                    :  Method to redirect user to Generation record
    * @Return Type                    :  PageReference
    * @Parameters                     :  None
    */
    public PageReference BudgetLink(){
        pagereference pageref = new pagereference('/apex/DRDW_CreateBudgetMaster?id='+LinkID2+'&isEdit=false');
        pageref.setredirect(true);
        return pageref;
    }
    
    Public void permissionSetAssigned(){
        PSAssigned = new set<String>();
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserInfo.getUserId()]); 
        for(PermissionSetAssignment opermission : lPermission){             
            PSAssigned.add(opermission.PermissionSet.Name);         
        }
    } 
    
    Public void groupAssigned(){
        groupAssigned = new set<String>();
        List<String> allGroupIDs = new List<String>();//AND group.type='Regular'
        for (GroupMember gm : [SELECT Id, group.id, group.DeveloperName, group.type FROM GroupMember where (UserOrGroupId = :UserInfo.getUserId() )]){
            if(DRDW_Constants.groupCapAreaMapping.containsKey(gm.group.DeveloperName)){
                groupAssigned.add(DRDW_Constants.groupCapAreaMapping.get(gm.group.DeveloperName));
            }
        }
        groupAssigned.add('Other');
        if(groupAssigned.contains(oActivity.Capability_Area__c)){
            isGroupUser = true;
        }      
    }
    
    Public void groupBuAssigned(){
        groupBUAssigned = new set<String>();
        List<String> allGroupIDs = new List<String>();
        for (GroupMember gm : [SELECT Id, group.id, group.DeveloperName, group.type FROM GroupMember where (UserOrGroupId = :UserInfo.getUserId())]){
            if(DRDW_Constants.groupBUMapping.containsKey(gm.group.DeveloperName)){
                groupBUAssigned.add(DRDW_Constants.groupBUMapping.get(gm.group.DeveloperName));
            }
        }
        if(groupBUAssigned.contains(oProject.Business_Unit__c)){
            isBUGroupUser = true;
        }      
    } 
    
    public void hasRecordAccess(){
        /*if([SELECT RecordId,HasEditAccess FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId() AND RecordId =: oActivity.DRDW_Request__c].HasEditAccess){
            isAccessable = true;
        } */
        if([SELECT RecordId,HasEditAccess FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId() AND RecordId =: oProject.id].HasEditAccess){
            isAccessable = true;
        }
        /*
        if([SELECT RecordId,HasEditAccess FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId() AND RecordId =: currentRecordID].HasEditAccess){
            isAccessable = true;
        }    */   
    }
    
    Public Void deleteRes(){
        DRDW_Assign_Resource__c odelAssRes = new DRDW_Assign_Resource__c();
        odelAssRes = [Select id From DRDW_Assign_Resource__c where id=:resourseId];
        if(odelAssRes != null){
            delete odelAssRes;
        }
        fetchResourceList();
    }
    
    Public PageReference edit(){
        PageReference pageref = new PageReference('/apex/DRDW_ViewActivity?id='+currentRecordID+'&isEdit=true');
        pageref.setredirect(true);
        return pageref;
    }
    
    Public PageReference Save(){
         boolean iserrored = false;
         if(oActivity.Planned_Start_Date__c > oActivity.Planned_End_Date__c){
                    addError('Planned End Date cannot be before the Planned Start Date');
                    iserrored = true;
                }
                if(oActivity.Actual_Start_Date__c > oActivity.Actual_End_Date__c){
                    addError('Actual End Date cannot be before Actual Start Date');
                    iserrored = true;
                }
                if(oRequest.Actual_Start_Date__c == Null && oActivity.Planned_Start_Date__c < oRequest.Planned_Start_Date__c){
                    addError('Planned Start Date cannot be before Request Planned Start Date');
                    iserrored = true;
                }
                if(oRequest.Actual_Start_Date__c != Null && oActivity.Planned_Start_Date__c < oRequest.Actual_Start_Date__c){
                    addError('Planned Start Date cannot be before Request Actual Start Date');
                    iserrored = true;
                }
                if(oRequest.Actual_End_Date__c == Null && oActivity.Planned_End_Date__c > oRequest.Planned_End_Date__c){
                    addError('Planned End Date cannot be After Request Planned End Date');
                    iserrored = true;
                }
                if(oRequest.Actual_End_Date__c != Null && oActivity.Planned_End_Date__c > oRequest.Actual_End_Date__c){
                    addError('Planned End Date cannot be After Request Actual End Date');
                    iserrored = true;
                }
          if(!iserrored){      
        update oActivity;
        
        PageReference pageref = new PageReference('/apex/DRDW_ViewActivity?id='+currentRecordID+'&isEdit=false');
        pageref.setredirect(true);
        return pageref;
        }
        return null;
    }
    
    Public void fetchResourceList(){    
        if(PSAssigned.contains('DRDW_Business_Admin') || PSAssigned.contains('DRDW_Financial_User') || PSAssigned.contains('DRDW_Senior_Leadership_User')  ) {
            lAssignedResources = [Select Id,Name,Allocation_End_Date__c,Allocation_Start_Date__c,DRDW_Activity__c,DRDW_Resources__c,Hours_Per_Day__c,DRDW_Resources__r.Name__c,DRDW_Resources__r.Name__r.Name from DRDW_Assign_Resource__c
            where (DRDW_Activity__c =: currentRecordID) and (DRDW_Resources__c != null) and (DRDW_Resources__r.Name__c != null) order by createddate desc limit 50000];
        } 
        else if(PSAssigned.contains('DRDW_Functional_Head')) {      
            lAssignedResources = [Select Id,Name,Allocation_End_Date__c,Allocation_Start_Date__c,DRDW_Activity__c,DRDW_Resources__c,Hours_Per_Day__c,DRDW_Resources__r.Name__c,DRDW_Resources__r.Name__r.Name from DRDW_Assign_Resource__c
            where (DRDW_Activity__c =: currentRecordID) and (DRDW_Resources__c != null) and (DRDW_Resources__r.Name__c != null) and (DRDW_Activity__c != null) and ((DRDW_Activity__r.Capability_Area__c in: groupAssigned) or (DRDW_Resources__r.Name__c =: UserInfo.getUserId())) order by createddate desc limit 50000];
        }
        else{
            lAssignedResources = [Select Id,Name,Allocation_End_Date__c,Allocation_Start_Date__c,DRDW_Activity__c,DRDW_Resources__c,Hours_Per_Day__c,DRDW_Resources__r.Name__c,DRDW_Resources__r.Name__r.Name from DRDW_Assign_Resource__c
            where (DRDW_Activity__c =: currentRecordID) and (DRDW_Resources__c != null) and (DRDW_Resources__r.Name__c =: UserInfo.getUserId()) order by createddate desc limit 50000];
        } 
    }
}