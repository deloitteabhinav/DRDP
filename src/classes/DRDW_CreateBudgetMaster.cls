Public without sharing Class DRDW_CreateBudgetMaster{ 

    Public Id currentRecordID {get; set;}
    Public Id parentID {get; set;}
     Public String isReport {get; set;}
    Public Boolean isAdmin{get;set;}
    Public Boolean isFin{get;set;}
    public DRDW_Budget_Master__c oMaster{get;set;}
    public List<DRDW_Budget_Line_Item__c> oItems{get;set;}
    public List<DRDW_Budget_Summary__c> oSummaries{get;set;}
    public List<DRDW_Capability__c> oCaps{get;set;}
    public List<SelectOption> lOptions{get;set;}
    public String capName{get;set;}
    public String capid{get;set;}
    Public String CostCenterName{get;set;}
    public Id capabilityId{get;set;}
    public List<SummaryWrapper> lWrapper{get;set;}
    public String rectype{get;set;}
    public id genericID {get; set;}
    public Boolean isEval{get;set;}
    public Boolean isGen{get;set;}
    public Boolean isAssess{get;set;}
    public Boolean isideaCap{get;set;}
    public Boolean isprojCap{get;set;}
    Public Id PrjId {get; set;}
    Public String ProjLink {get;set;}
    Public String ProjName {get;set;}

    Public DRDW_CreateBudgetMaster(ApexPages.StandardController controller){
        currentRecordID = ApexPages.currentPage().getParameters().get('id');
        oMaster = (DRDW_Budget_Master__c)controller.getRecord();
        parentID = ApexPages.currentPage().getParameters().get('parentid'); 
        capabilityId = ApexPages.currentPage().getParameters().get('capid'); 
        isReport = ApexPages.currentPage().getParameters().get('isReport'); 
        // oCaps = new List<DRDW_Capability__c>();
        //oCaps.addAll([select id,Name,Title__c from DRDW_Capability__c where Related_Project__c =: parentID or Related_Idea__c =: parentID]);

        if(currentRecordID != null){

            String SobjectApiName = 'DRDW_Budget_Master__c';
            Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
            Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();

            String commaSeparatedFields = '';
            for (String fieldName : fieldMap.keyset()) {
                if (commaSeparatedFields == null || commaSeparatedFields == '') {
                    commaSeparatedFields = fieldName;
                } 
                else {
                    commaSeparatedFields = commaSeparatedFields + ', ' + fieldName;
                }
            }

            string query = 'select ' + commaSeparatedFields + ' from ' + SobjectApiName + ' where id =\'' + currentRecordID + '\' limit 1';
            oMaster = Database.query(query);
            parentID = oMaster.Related_To__c;
           // capabilityId = oMaster.Activity__c;

            // oCaps = [select id,Name,Title__c  from DRDW_Capability__c where Related_Project__c =: parentID or Related_Idea__c =: parentID];
            //  capName = oMaster.Activity_Name__c;

            //    lOptions = getPicklist(oCaps);
            oItems = new List<DRDW_Budget_Line_Item__c>();
            oItems = [select id,Name,Posting_Date__c,Activity__c,Actual_Amount__c,Scientist_Owner__c,US__c,Cost_Element_Description__c,Manual_Adjustment__c,Accrual__c,PO_Description__c from DRDW_Budget_Line_Item__c where Related_To__c =:currentRecordID ];

            oSummaries = new List<DRDW_Budget_Summary__c>();
            oSummaries = [select id,Name,Quarter__c,Year__c,Business_Plan__c,F_X_Forecast__c,Rolling_Forecast__c,Q_Total_Actuals__c,Q_Actual_vs_Rolling_Forecast__c,Q_Locked_In_Forecast__c,Q_Locked_In_Forecast_Updated__c,Q_Rolling_Forecast__c,Q_Actual__c from DRDW_Budget_Summary__c where DRDW_Budget_Master__c =:currentRecordID];

            lWrapper = getChildActual(oSummaries);

            if(parentID!=null){

                DRDW_Project__c oProject = [select id,name,Idea_Name__c,Project_Name__c,recordtype.developername from DRDW_Project__c where id=:parentID];

                if(oProject.recordtype.developername == 'Idea_Project'){
                 //   oMaster.Title__c =  oProject.Idea_Name__c;             
                    rectype = 'idea'; 
                    ProjLink = '/apex/DRDW_CreateIdea?id='+oProject.id+'&isEdit=false';
                    ProjName = oProject.name;         
                        
                }else if(oProject.recordtype.developername == 'Generation_Project'){
                 //   oMaster.Title__c =  oProject.Project_Name__c;  
                    rectype = 'gen';
                    ProjLink = '/apex/DRDW_CreateGeneration?id='+oProject.id;
                    ProjName = oProject.name;  
                }
                else if(oProject.recordtype.developername == 'Assessment_Project'){
                  //  oMaster.Title__c =  oProject.Project_Name__c; 
                    rectype = 'assess';  
                    ProjLink = '/apex/DRDW_CreateAssessment?id='+oProject.id;
                    ProjName = oProject.name;              
                }
            }

          /*  if(capabilityId!=null){

                DRDW_Capability__c oCap = [select id,title__c,recordtype.developername from DRDW_Capability__c where id=:CapabilityID];

                oMaster.Title__c = oCap.Title__c;

                if(oCap.recordtype.developername == 'Idea_Capability'){
                    rectype = 'ideaCap';   
                }
                else if(oCap.recordtype.developername == 'Project_Capability'){
                    rectype = 'projectCap'; 
                }else if(oCap.recordtype.developername == 'External_Activity'){
                    rectype = 'extcap';
                }
            } */

            if(oMaster.Cost_Center__c!=null)  
            CostCenterName = [Select Name from DRDW_Cost_Center__c where Id =: oMaster.Cost_Center__c LIMIT 1].Name;
        }
        else{
        
           
          

            // lOptions = getPicklist(oCaps);

            if(parentID!=null){
                 oMaster.Related_To__c = parentID;     
                DRDW_Project__c oProject = [select id,name,Idea_Name__c,Project_Name__c,recordtype.developername from DRDW_Project__c where id=:parentID];
                PrjId = oProject.Id;
                if(oProject.recordtype.developername == 'Idea_Project'){
                    oMaster.Title__c =  oProject.Idea_Name__c;             
                    rectype = 'idea';  
                     ProjLink = '/apex/DRDW_CreateIdea?id='+oProject.id+'&isEdit=false';
                    ProjName = oProject.name;     
                }
                else if(oProject.recordtype.developername == 'Generation_Project'){
                    oMaster.Title__c =  oProject.Project_Name__c;  
                    rectype = 'gen';
                     ProjLink = '/apex/DRDW_CreateGeneration?id='+oProject.id;
                    ProjName = oProject.name;  
                }
                else if(oProject.recordtype.developername == 'Assessment_Project'){
                    oMaster.Title__c =  oProject.Project_Name__c; 
                    rectype = 'assess'; 
                    ProjLink = '/apex/DRDW_CreateAssessment?id='+oProject.id;
                    ProjName = oProject.name;              
                }
            }

            if(capabilityId!=null){
                
                 oMaster.Activity__c = capabilityId;
                 
                
                DRDW_Capability__c oCap = [select id,title__c,Title_ex__c, Related_Project__c, Related_Idea__c ,Related_Project__r.Name__c,recordtype.developername from DRDW_Capability__c where id=:CapabilityID];

              //   ProjName = oCap.Related_Project__r.Name__c;  

                if(oCap.Related_Idea__c!= null){
                oMaster.Related_to__c = oCap.Related_Idea__c;
                
                }
                if(oCap.Related_Project__c != null)
                oMaster.Related_to__c = oCap.Related_Project__c;

                if(oCap.recordtype.developername == 'Idea_Capability'){
                    rectype = 'ideaCap';   
                }
                else if(oCap.recordtype.developername == 'Project_Capability'){
                    rectype = 'projectCap'; 
                }else if(oCap.recordtype.developername == 'External_Activity'){
                    oMaster.Title__c = oCap.Title_ex__c;
                    rectype = 'extcap';
                }else if(oCap.recordtype.developername == 'Request_Activity'){
                    oMaster.Title__c = oCap.Title__c;
                    rectype = 'reqcap';
                }
                
                 parentID = oMaster.Related_To__c;
                
                 DRDW_Project__c oProject = [select id,name,Idea_Name__c,Project_Name__c,recordtype.developername from DRDW_Project__c where id=:parentID];
                PrjId = oProject.Id;
                if(oProject.recordtype.developername == 'Idea_Project'){
                  //  oMaster.Title__c =  oProject.Idea_Name__c;             
                    rectype = 'idea';  
                     ProjLink = '/apex/DRDW_CreateIdea?id='+oProject.id+'&isEdit=false';
                    ProjName = oProject.name;     
                }
                else if(oProject.recordtype.developername == 'Generation_Project'){
                  //  oMaster.Title__c =  oProject.Project_Name__c;  
                    rectype = 'gen';
                     ProjLink = '/apex/DRDW_CreateGeneration?id='+oProject.id;
                    ProjName = oProject.name;  
                }
                else if(oProject.recordtype.developername == 'Assessment_Project'){
                  //  oMaster.Title__c =  oProject.Project_Name__c; 
                    rectype = 'assess'; 
                    ProjLink = '/apex/DRDW_CreateAssessment?id='+oProject.id;
                    ProjName = oProject.name;              
                }
                
            }
            
            

        }
        isAdmin = getUserPermission(UserInfo.getUserId());
        isFin = getUserPermissionFin(UserInfo.getUserId());
    }

    public void UpdateActivity(){
        List<DRDW_Capability__c> lcaps = new List<DRDW_Capability__c>();
        // capid = oMaster.Activity__c;

        lcaps   = [Select id,title__c from DRDW_Capability__c where id=:capid];
        if(!lcaps.isEmpty())
        oMaster.Activity_Name__c = lcaps[0].title__c;

        system.debug('Activityname'+ oMaster.Activity_Name__c);
    }
    /*
    * @Method Name                    :  Save
    * @Description                    :  Method to Save the record
    * @Return Type                    :  None
    * @Parameters                     :  None
    */  
    Public PageReference save(){
        try{
             PageReference pageref = null;
            // oMaster.Activity_Name__c = capName;
            //Rounding off the budget fields
            if(oMaster.Planned_Amount_for_Milestone_1__c != null) oMaster.Planned_Amount_for_Milestone_1__c = oMaster.Planned_Amount_for_Milestone_1__c.round(System.RoundingMode.HALF_EVEN);
            if(oMaster.Planned_Amount_for_Milestone_2__c != null) oMaster.Planned_Amount_for_Milestone_2__c = oMaster.Planned_Amount_for_Milestone_2__c.round(System.RoundingMode.HALF_EVEN);
            if(oMaster.Planned_Amount_for_Milestone_3__c != null) oMaster.Planned_Amount_for_Milestone_3__c = oMaster.Planned_Amount_for_Milestone_3__c.round(System.RoundingMode.HALF_EVEN);
            if(oMaster.Planned_Amount_for_Milestone_4__c != null) oMaster.Planned_Amount_for_Milestone_4__c = oMaster.Planned_Amount_for_Milestone_4__c.round(System.RoundingMode.HALF_EVEN);
            if(oMaster.Total_Contract_Value__c != null)oMaster.Total_Contract_Value__c = oMaster.Total_Contract_Value__c.round(System.RoundingMode.HALF_EVEN);
            if(oMaster.Total_Actuals__c != null)oMaster.Total_Actuals__c = oMaster.Total_Actuals__c.round(System.RoundingMode.HALF_EVEN);
            if(oMaster.Total_F_X_Forecast__c != null)oMaster.Total_F_X_Forecast__c = oMaster.Total_F_X_Forecast__c.round(System.RoundingMode.HALF_EVEN);
            if(oMaster.Total_Business_Plan__c != null)oMaster.Total_Business_Plan__c = oMaster.Total_Business_Plan__c.round(System.RoundingMode.HALF_EVEN);
            if(oMaster.Total_Rolling_Forecast__c != null)oMaster.Total_Rolling_Forecast__c = oMaster.Total_Rolling_Forecast__c.round(System.RoundingMode.HALF_EVEN);
            
            if(isReport == 'true' && (( oMaster.Title__c != NULL))){
            system.debug('Title_____'+oMaster.Title__c);
              Id actid = getObjectRecordTypeId(DRDW_Capability__c.SObjectType,'External Activity');  
              List<DRDW_Capability__c> lActivities = [select id,Title_ex__c from DRDW_Capability__c where Title_ex__c =:oMaster.Title__c and recordtypeid =:actid and Related_Project__c =:oMaster.Related_To__c ];  
              
              if(lActivities ==null || lActivities.size()==0){
                
              DRDW_Capability__c newActivity = new DRDW_Capability__c();
              newActivity.RecordTypeId = getObjectRecordTypeId(DRDW_Capability__c.SObjectType,'External Activity');
              newActivity.Related_Project__c = oMaster.Related_To__c;
              newActivity.Capability_Area__c = 'External';
              newActivity.Capability__c = 'External';
              newActivity.Title_ex__c = oMaster.Title__c;
              insert newActivity;
              oMaster.Activity__c = newActivity.id; 
              pageref = new PageReference('/apex/DRDW_CreateExternalActivity?id='+newActivity.id+'&isEdit=false&section=#Project_Budgets');
              }else{
                ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Title should be Unique.');
                ApexPages.addMessage(myMsg1);
                return null;
              }  
            }
             oMaster.Cost_Center_txt__c = [Select Name from DRDW_Cost_Center__c where id=:oMaster.Cost_Center__c].Name;
            upsert oMaster;
           
            parentID = oMaster.Related_To__c;
            capabilityId = oMaster.Activity__c;
          
            
            if(parentID!=null){
                DRDW_Project__c oProject = [select id,recordtype.developername from DRDW_Project__c where id=:parentID];

                if(oProject.recordtype.developername == 'Idea_Project'){
                    pageref = new PageReference('/apex/DRDW_CreateIdea?id='+parentID+'&isEdit=false&section=#Project_Budgets');                              
                }
                else if(oProject.recordtype.developername == 'Generation_Project'){
                    pageref = new PageReference('/apex/DRDW_CreateGeneration?id='+parentID+'&isEdit=false&section=#Project_Budgets');
                }
                else if(oProject.recordtype.developername == 'Assessment_Project'){
                    pageref = new PageReference('/apex/DRDW_CreateAssessment?id='+parentID+'&isEdit=false&section=#Project_Budgets');
                }
            }

            if(capabilityId!=null){
                DRDW_Capability__c oCap = [select id,title__c,recordtype.developername from DRDW_Capability__c where id=:CapabilityID];

                if(oCap.recordtype.developername == 'Idea_Capability'){
                    pageref = new PageReference('/apex/DRDW_CreateIdeaCapability?id='+capabilityId+'&isEdit=false&section=#Project_Budgets');                              
                }else if(oCap.recordtype.developername == 'Project_Capability'){
                    pageref = new PageReference('/apex/DRDW_CreateProjectCapability?id='+capabilityId+'&isEdit=false&section=#Project_Budgets');
                }else if(oCap.recordtype.developername == 'External_Activity'){
                    pageref = new PageReference('/apex/DRDW_CreateExternalActivity?id='+capabilityId+'&isEdit=false&section=#Project_Budgets');
                }else if(oCap.recordtype.developername == 'Request_Activity'){
                    pageref = new PageReference('/apex/DRDW_ViewActivity?id='+capabilityId+'&isEdit=false&section=#Project_Budgets');
                }
                
            }

              
            
            pageref.setredirect(true);
            return pageref;

        }
        catch(Exception e){
          /*  if(e.getmessage().contains('DUPLICATE')){
                ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'PO should be Unique.');
                ApexPages.addMessage(myMsg1);
                return null;
            } */
            return null;
        }
    }
    /*
* @Method Name                    :  Save
* @Description                    :  Method to Save the record
* @Return Type                    :  None
* @Parameters                     :  None
*/  
    Public PageReference cancel(){
        PageReference pageref = null;
        if(parentID!=null){
            DRDW_Project__c oProject = [select id,recordtype.developername from DRDW_Project__c where id=:parentID];

            if(oProject.recordtype.developername == 'Idea_Project'){
                pageref = new PageReference('/apex/DRDW_CreateIdea?id='+parentID+'&isEdit=false');                              
            }
            else if(oProject.recordtype.developername == 'Generation_Project'){
                pageref = new PageReference('/apex/DRDW_CreateGeneration?id='+parentID+'&isEdit=false');
            }
            else if(oProject.recordtype.developername == 'Assessment_Project'){
                pageref = new PageReference('/apex/DRDW_CreateAssessment?id='+parentID+'&isEdit=false');
            }
        }

        if(capabilityId!=null){
            DRDW_Capability__c oCap = [select id,title__c,recordtype.developername from DRDW_Capability__c where id=:CapabilityID];

            if(oCap.recordtype.developername == 'Idea_Capability'){
                pageref = new PageReference('/apex/DRDW_CreateIdeaCapability?id='+capabilityId+'&isEdit=false');                              
            }
            else if(oCap.recordtype.developername == 'Project_Capability'){
                pageref = new PageReference('/apex/DRDW_CreateProjectCapability?id='+capabilityId+'&isEdit=false');
            }else if(oCap.recordtype.developername == 'External_Activity'){
                    pageref = new PageReference('/apex/DRDW_CreateExternalActivity?id='+capabilityId+'&isEdit=false&section=#Project_Budgets');
                }else if(oCap.recordtype.developername == 'Request_Activity'){
                    pageref = new PageReference('/apex/DRDW_ViewActivity?id='+capabilityId+'&isEdit=false&section=#Project_Budgets');
                }
        }   

        pageref.setredirect(true);
        return pageref;

    }

    /*
    * @Method Name                    :  Edit
    * @Description                    :  Method to Edit the record
    * @Return Type                    :  None
    * @Parameters                     :  None
    */  
    public PageReference edit(){
        PageReference pageref = new PageReference('/apex/DRDW_CreateBudgetMaster?id='+currentRecordID+'&isEdit=true');
        pageref.setredirect(true);
        return pageref;
    }

    public PageReference DeleteRecord(){
        delete oMaster;
        PageReference pageref = null;
        if(rectype == 'idea'){
            pageref = new PageReference('/apex/DRDW_CreateIdea?isEdit=false&id='+parentID);
        }
        else if(rectype == 'gen'){
            pageref = new PageReference('/apex/DRDW_CreateGeneration?isEdit=false&id='+parentID);
        }
        else if(rectype == 'assess'){
            pageref = new PageReference('/apex/DRDW_CreateAssessment?isEdit=false&id='+parentID);
        }
        else if(rectype == 'ideaCap'){
            pageref = new PageReference('/apex/DRDW_CreateIdeaCapability?isEdit=false&id='+capabilityID);
        }
        else if(rectype == 'extcap'){
            pageref = new PageReference('/apex/DRDW_CreateExternalActivity?isEdit=false&id='+capabilityID);
        }
        pageref.setredirect(true);
        return pageref;
    }

    public Boolean getUserPermission(Id UserID){
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserID AND PermissionSet.Name = 'DRDW_Business_Admin']);
        Set<Id> lUserId = new Set<Id>();
        If(!lPermission.isEmpty()){
            For(PermissionSetAssignment p : lPermission){
                lUserId.add(p.Assignee.Id);
            }}
        If(lUserId.Contains(UserID)){
            return true;
        }
        return false;
    }   

    public Boolean getUserPermissionFin(Id UserID){
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

    public List<SelectOption> getPicklist(List<DRDW_Capability__c> caps){
        List<SelectOption> lOpt = new List<SelectOption>();
        lOpt.add(new SelectOption('--None--','--None--'));
        for(DRDW_Capability__c cap:caps){
            if(cap.Title__c != NULL && cap.Title__c != ''){
                lOpt.add(new SelectOption(cap.Title__c,cap.Title__c));
            }}
        return lOpt;
    }

    public PageReference AddBudgetLineItem(){
        PageReference pageref = new PageReference('/apex/DRDW_CreateBudgetLineItem?budgetId='+currentRecordID);
        pageref.setredirect(true);
        return pageref;
    }

    public List<SummaryWrapper> getChildActual(List<DRDW_Budget_Summary__c> oSummaries){

        List<SummaryWrapper> lwrapper = new List<SummaryWrapper>();
        Map<String,Map<String,Decimal>> finalmap = new Map<String,Map<String,Decimal>>();

        Set<Id> sIds = new Set<Id>();

        for(DRDW_Budget_Summary__c oSum :oSummaries){
            sIds.add(oSum.id);
        }system.debug('final map'+sIds);

        List<DRDW_Budget_Summary_Detail__c> sDetails= [select id,DRDW_Budget_Summary__r.Name,M_Actual__c,Month__c from DRDW_Budget_Summary_Detail__c where DRDW_Budget_Summary__c in:sIds ];

        system.debug('final map'+sDetails);

        for(DRDW_Budget_Summary_Detail__c sd:sDetails){

            if(!finalmap.containsKey(sd.DRDW_Budget_Summary__r.Name)){
                finalmap.put(sd.DRDW_Budget_Summary__r.Name,new Map<String,Decimal>());
            }finalmap.get(sd.DRDW_Budget_Summary__r.Name).put(sd.Month__c,sd.M_Actual__c);

        }
        system.debug('final map'+finalmap);

        for(DRDW_Budget_Summary__c oSum :oSummaries){
            SummaryWrapper oWrap = new SummaryWrapper();
            oWrap.oSummary = oSum;
            Map<String,Decimal> lActual = finalmap.get(oSum.Name);
            if(lActual!=null){ 
                if(lActual.containsKey('Jan')){         
                    oWrap.month_actual_1 = lActual.get('Jan');
                }
                if(lActual.containsKey('Feb')){
                    oWrap.month_actual_2 = lActual.get('Feb');
                }
                if(lActual.containsKey('March')){
                    oWrap.month_actual_3 = lActual.get('March');
                }
                if(lActual.containsKey('April')){        
                    oWrap.month_actual_1 = lActual.get('April');
                }
                if(lActual.containsKey('May')){
                    oWrap.month_actual_2 = lActual.get('May');
                }
                if(lActual.containsKey('June')){
                    oWrap.month_actual_3 = lActual.get('June');
                }
                if(lActual.containsKey('July')){         
                    oWrap.month_actual_1 = lActual.get('July');
                }
                if(lActual.containsKey('Aug')){
                    oWrap.month_actual_2 = lActual.get('Aug');
                }
                if(lActual.containsKey('Sept')){
                    oWrap.month_actual_3 = lActual.get('Sept');
                }
                if(lActual.containsKey('Oct')){          
                    oWrap.month_actual_1 = lActual.get('Oct');
                }
                if(lActual.containsKey('Nov')){
                    oWrap.month_actual_2 = lActual.get('Nov');
                }
                if(lActual.containsKey('Dec')){
                    oWrap.month_actual_3 = lActual.get('Dec');
                }
            }

            lwrapper.add(oWrap);
        }
        return lwrapper;
    }

    public void RemoveBudgetSummary() {
        try {

            DRDW_Budget_Summary__c oExp = [Select id from DRDW_Budget_Summary__c where DRDW_Budget_Master__c = :currentRecordID AND id = : genericID];
            delete oExp;
            oSummaries = [select id,Name,Quarter__c,Year__c,Business_Plan__c,F_X_Forecast__c,Rolling_Forecast__c,Q_Total_Actuals__c,Q_Actual_vs_Rolling_Forecast__c,Q_Locked_In_Forecast__c,Q_Locked_In_Forecast_Updated__c,Q_Rolling_Forecast__c,Q_Actual__c from DRDW_Budget_Summary__c where DRDW_Budget_Master__c =:currentRecordID];
            lWrapper = getChildActual(oSummaries);
            oItems = [select id,Name,Posting_Date__c,Activity__c,Actual_Amount__c,Scientist_Owner__c,US__c,Cost_Element_Description__c,Manual_Adjustment__c,Accrual__c,PO_Description__c from DRDW_Budget_Line_Item__c where Related_To__c =:currentRecordID ];
            getRefresh();
        } catch (exception e) {
            addError(e.getmessage());
            //  isbError = true;
        } 
    } 

    public void RemoveBudgetLine() {
        try {

            oItems = [select id,Name,Posting_Date__c,Activity__c,Actual_Amount__c,Scientist_Owner__c,US__c,Cost_Element_Description__c,Manual_Adjustment__c,Accrual__c,PO_Description__c from DRDW_Budget_Line_Item__c where Related_To__c =:currentRecordID ];

            DRDW_Budget_Line_Item__c oExp = [Select id from DRDW_Budget_Line_Item__c where Related_To__c = :currentRecordID AND id = : genericID];
            delete oExp;
            oItems = [select id,Name,Posting_Date__c,Activity__c,Actual_Amount__c,Scientist_Owner__c,US__c,Cost_Element_Description__c,Manual_Adjustment__c,Accrual__c,PO_Description__c from DRDW_Budget_Line_Item__c where Related_To__c =:currentRecordID ];
            oSummaries = [select id,Name,Quarter__c,Year__c,Business_Plan__c,F_X_Forecast__c,Rolling_Forecast__c,Q_Total_Actuals__c,Q_Actual_vs_Rolling_Forecast__c,Q_Locked_In_Forecast__c,Q_Locked_In_Forecast_Updated__c,Q_Rolling_Forecast__c,Q_Actual__c from DRDW_Budget_Summary__c where DRDW_Budget_Master__c =:currentRecordID];
            lWrapper = getChildActual(oSummaries);
            getRefresh();

        } catch (exception e) {
            addError(e.getmessage());
            // isbError = true;
        } 
    } 

    public void addError(string s) {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, s);
        ApexPages.addMessage(myMsg);
    }

    public void getRefresh(){
        String SobjectApiName = 'DRDW_Budget_Master__c';
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
        oMaster = Database.query(query);
    }

    public Class SummaryWrapper{        
        public DRDW_Budget_Summary__c oSummary{get;set;}
        public Decimal month_actual_1{get;set;}
        public Decimal month_actual_2{get;set;}
        public Decimal month_actual_3{get;set;}        
    }        
    
     /*
     * @Method Name                    :  getObjectRecordTypeId
     * @Description                    :  Method to retrieve recordtypeid
     * @Return Type                    :  String
     * @Parameters                     :  string,SObjectType
     */
    
     public String getObjectRecordTypeId(SObjectType sObjectType, String recordTypeName)
    {
        //Generate a map of tokens for all the Record Types for the desired object
        Map<String,Schema.RecordTypeInfo> recordTypeInfo = sObjectType.getDescribe().getRecordTypeInfosByName();        
        
        //Retrieve the record type id by name
        return recordTypeInfo.get(recordTypeName).getRecordTypeId();
    }
    
}