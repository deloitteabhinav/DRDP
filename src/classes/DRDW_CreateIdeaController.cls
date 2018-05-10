public without sharing class DRDW_CreateIdeaController {

    public DRDW_Project__c  oIdea {get; set;}
    public Id currentRecordID {get; set;}
   /* public DRDW_Idea_Experiment__c oiexp {get; set;}
    public List<DRDW_Idea_Experiment__c> liexps {get; set;} */
    public List<DRDW_Capability__c> lcaps {get; set;}
    public DRDW_Risk__c oirisk {get; set;}
    public List<DRDW_Risk__c> lirisks {get; set;}
    public List<DRDW_Budget_Master__c> lbudgets {get; set;}
    public List<DRDW_Project__c> lgens {get; set;}
    Public DRDW_Project__c orelIdea {get;set;}
    public boolean isExpError {get; set;}
    public boolean isbError {get; set;}
    public boolean isRiskError {get; set;}
    Public Boolean isAdmin{get;set;} 
    Public Boolean isFin{get;set;} 
    Public Boolean isAccess {get;set;} 
    Public boolean isRedFlag{get;set;}   
    Public String CapabilityArea{get;set;} 
    Public id IdeaId{get;set;}
    public id genericID {get; set;}
    public id LinkID {get; set;}
    public id LinkID1 {get; set;}
    public id LinkID2 {get; set;}
    Public Boolean isLeader {get;set;}
       public Integer ErlCount{get;set;}
       public Integer goCount{get;set;}
       Public Boolean isSrLeader {get; set;}
       Public boolean hasGOaccess {get; set;}
       Public boolean isInBuGroup {get; set;}
       Public Set<String> groupBUAssigned{get;set;}
       Public boolean hasERLaccess {get; set;}
       Public boolean isSM {get; set;}
       
    
    Public List<requestwrapper> lRequestWrapper{get;set;}
    Public List<requestwrapper> lRequestWrapperGO{get;set;}

    //Loading the Constructor
    public DRDW_CreateIdeaController(ApexPages.StandardController controller) {
        hasGOaccess =false;
        isInBuGroup = false;
        hasERLaccess = false;
        isSM = false;
        
        oIdea = (DRDW_Project__c)controller.getRecord();
        
        currentRecordID = ApexPages.currentPage().getParameters().get('id');
        
        if(currentRecordID != null){
            
            //Quering the Idea
            isRedFlag = false;
            String SobjectApiName = 'DRDW_Project__c';
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
            oIdea = Database.query(query);
            
            /*if(oIdea.Cycle_Time_eval__c != NULL && oIdea.Cycle_Time_Standard__c != NULL){
            if((oIdea.Cycle_Time_eval__c - oIdea.Cycle_Time_Standard__c)>=30){
                isRedFlag = true;
            }else{
                isRedFlag = false;
            }
        }else{
            isRedFlag = false;
        } */

            //Setting Red flags

            if(oIdea.Cycle_Time_eval__c != NULL && oIdea.EPCTM_DTG_DTE_for_Biopharma__c!= null && oIdea.Molecule_classification__c != null){
                if(oIdea.EPCTM_DTG_DTE_for_Biopharma__c != 0 ){
                    if((oIdea.Cycle_Time_eval__c - oIdea.EPCTM_DTG_DTE_for_Biopharma__c)>=30){
                        isRedFlag = true;
                    }
                }
            }else if(oIdea.Cycle_Time_eval__c != NULL && oIdea.Molecule_classification__c == null) {
                if((oIdea.Cycle_Time_eval__c - oIdea.EPCTM_DTG_DTE_for_Biopharma__c)>=30){
                    isRedFlag = true;
                }
            }

            if(oIdea.Cycle_Time_eval__c != NULL && oIdea.EPCTM_DTG_DTE_for_Small_Molecule__c!= null && oIdea.Molecule_classification__c != null){
                if(oIdea.EPCTM_DTG_DTE_for_Small_Molecule__c != 0 ){
                    if((oIdea.Cycle_Time_eval__c - oIdea.EPCTM_DTG_DTE_for_Small_Molecule__c)>=30){
                        isRedFlag = true;
                    }
                }
            }else if(oIdea.Cycle_Time_eval__c != NULL && oIdea.Molecule_classification__c == null) {
                if((oIdea.Cycle_Time_eval__c - oIdea.EPCTM_DTG_DTE_for_Biopharma__c)>=30){
                    isRedFlag = true;
                }
            }

            if(oIdea.Cycle_Time_eval__c != NULL && oIdea.EPCTM_DTG_DTE_for_Vaccine__c!= null && oIdea.Molecule_classification__c != null){
                if(oIdea.EPCTM_DTG_DTE_for_Vaccine__c != 0 ){
                    if((oIdea.Cycle_Time_eval__c - oIdea.EPCTM_DTG_DTE_for_Vaccine__c)>=30){
                        isRedFlag = true;
                    }
                }
            }else if(oIdea.Cycle_Time_eval__c != NULL && oIdea.Molecule_classification__c == null) {
                if((oIdea.Cycle_Time_eval__c - oIdea.EPCTM_DTG_DTE_for_Biopharma__c)>=30){
                    isRedFlag = true;
                }
            }

            /*if(oIdea.Cycle_Time_eval__c != NULL && oIdea.EPCTM_DTG_DTE_for_Small_Molecule__c != NULL && oIdea.EPCTM_DTG_DTE_for_Small_Molecule__c != 0  && (oIdea.Cycle_Time_eval__c - oIdea.EPCTM_DTG_DTE_for_Small_Molecule__c)>=30){
                isRedFlag = true;
            }

            if(oIdea.Cycle_Time_eval__c != NULL && oIdea.EPCTM_DTG_DTE_for_Vaccine__c != NULL && oIdea.EPCTM_DTG_DTE_for_Vaccine__c != 0  && (oIdea.Cycle_Time_eval__c - oIdea.EPCTM_DTG_DTE_for_Vaccine__c)>=30){
                isRedFlag = true;
            } */

            
            //Creating a record for the junction object
          //  oiexp = new DRDW_Idea_Experiment__c();
            oirisk = new DRDW_Risk__c();
          //  liexps = new List<DRDW_Idea_Experiment__c>();
            lirisks = new List<DRDW_Risk__c>();
            
         /*   liexps = [Select Idea__c, Capability__c,Experiment__c,Idea__r.name,Capability__r.name from DRDW_Idea_Experiment__c where Idea__c = :currentRecordID]; */
            lirisks = [Select Name,Description__c from DRDW_Risk__c where Related_To__c =: currentRecordID];
            lcaps = [Select id,Title__c,Title_ex__c,Related_Project__c,ERL_Primary_Contact__c,Research_Project_Lead__r.Name,Name,Capability_Area__c,Planned_Start_Date__c,Assigned_Resource__r.Name,Capability__c from DRDW_Capability__c where Related_Project__c = :currentRecordID and recordtype.developername = 'External_Activity'];
            lgens = [Select Id, Name, Project_Name__c, Business_Unit__c from DRDW_Project__c where Related_Idea_Project__c = :currentRecordID];
            lbudgets = [Select id,Name ,Titletab__c,Scientist_Owner__c,Title__c,PO__c,Activity_Name__c,Vendorr__c,Total_Contract_Value__c,Total_Actuals__c,Cost_Center__r.Name from DRDW_Budget_Master__c where Related_To__c =: currentRecordID];
            
            If(oIdea.Related_Idea__c != null){
                orelIdea = [Select Name,New_Idea_Name__c,ERL_Primary_Contact__c,Date_Initiated__c,Business_Unit__c,New_Status__c from DRDW_Project__c where id =: oIdea.Related_Idea__c limit 1];
            }
            
            //Logic for the Total Rolling forecast field on Project records
            
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
                    oIdea.Total_Rolling_Forecast__c = TotalRF.round(System.RoundingMode.HALF_EVEN);
                }else if(lstsummaries.size() == 1){
                    oIdea.Total_Rolling_Forecast__c = lstsummaries[0].F_X_Forecast__c.round(System.RoundingMode.HALF_EVEN);
                }
                System.debug('Total Rolling foreeeeecast'+oIdea.Total_Rolling_Forecast__c);
                
        // adding for functionalrequest table   
        
        lRequestWrapper = new List<requestwrapper>();
        lRequestWrapperGO = new List<requestwrapper>();
        groupBUAssigned();
        
        AggregateResult i = [select count(id) from DRDW_Cap_Request__c where recordtype.developername='ERL' and Project__c=:oIdea.id];
        system.debug('I'+i.get('expr0'));  
        if(i!=null){    
        erlcount =  (Integer)i.get('expr0');     
        }else{
         erlcount = 0;
        }

        AggregateResult i1 = [select count(id) from DRDW_Cap_Request__c where recordtype.developername='GO' and Project__c=:oIdea.id];
        system.debug('I'+i1.get('expr0'));  
        if(i1!=null){    
        gocount =  (Integer)i1.get('expr0');     
        }else{
         gocount = 0;
        }
        
        for(DRDW_Cap_Request__c r:[select id,Name,recordtype.developername,(select id,Status__c,Title__c,Capability__c,Capability_Area__c,Actual_End_Date__c,Actual_Start_Date__c,Planned_End_Date__c,Planned_Start_Date__c from DRDW_Activities__r) from DRDW_Cap_Request__c where recordtype.developername='ERL' AND Project__c=:oIdea.id]){
            Boolean flag = false;
            for(DRDW_Capability__c c:r.DRDW_Activities__r){
                requestwrapper newWrap = new requestwrapper(r,c);
                lRequestWrapper.add(newWrap);
                 flag = true;
            }
              if(!flag){
                requestwrapper newWrap = new requestwrapper(r,new DRDW_Capability__c());
                lRequestWrapper.add(newWrap);
            }

        }

        for(DRDW_Cap_Request__c r:[select id,Name,recordtype.developername,Request_status__c,(select id,Status__c,Title__c,Capability__c,Capability_Area__c,Actual_End_Date__c,Actual_Start_Date__c,Planned_End_Date__c,Planned_Start_Date__c from DRDW_Activities__r) from DRDW_Cap_Request__c where recordtype.developername='GO' AND Project__c=:oIdea.id]){
            Boolean flag = false;
            for(DRDW_Capability__c c:r.DRDW_Activities__r){
                requestwrapper newWrap = new requestwrapper(r,c);
                lRequestWrapperGO.add(newWrap);
                 flag = true;
            }
              if(!flag){
                requestwrapper newWrap = new requestwrapper(r,new DRDW_Capability__c());
                lRequestWrapperGO.add(newWrap);
            }

        }

        
            
        }else{
            oIdea.recordtypeid =  getObjectRecordTypeId(DRDW_Project__c.SObjectType,'Idea Project');
            oIdea.Phase__c = 'Evaluation';
        }
        
        isAdmin = getUserPermission(UserInfo.getUserId());
        isFin = getUserPermissionFin(UserInfo.getUserId());
        isAccess = HasAccess(UserInfo.getUserId(), oIdea.Id);
        isLeader = getUserPermissionLeader(UserInfo.getUserId());
        isSrLeader = getUserPermissionSrLeader(UserInfo.getUserId());
        hasGOaccess = getGOUseraccess(UserInfo.getUserId());
        hasERLaccess = getERLUseraccess(UserInfo.getUserId());
        isSM = getUserPermissionsSM(UserInfo.getUserId());
        
        
        
    }
    /*
    * @Method Name                    :  SaveIdea
    * @Description                    :  Method to Save the Idea record
    * @Return Type                    :  None
    * @Parameters                     :  None
    */  
    public PageReference SaveIdea(){

        try{    
            
            /*  if(currentRecordID != null){
            
                List<DRDW_Project__Share> pshare = [SELECT AccessLevel,Id,RowCause,UserOrGroupId FROM DRDW_Project__Share WHERE ParentId =:oidea.id and RowCause !='Owner'];
                database.delete(pshare);
            
            }
            
            */
            //Rounding off the currency fields
            if(oIdea.Estimated_Budget__c != null){
                oIdea.Estimated_Budget__c = oIdea.Estimated_Budget__c.round(System.RoundingMode.HALF_EVEN);
            }
            if(oIdea.Total_budget__c != null){
                oIdea.Total_budget__c = oIdea.Total_budget__c.round(System.RoundingMode.HALF_EVEN);
            }
            Upsert oIdea;
            
            /*
        
        if(oIdea.ERL_Primary_Contact__c != null || oIdea.ERL_Primary_Contact__c != ''){
        If(oIdea.ERL_Primary_Contact__c != oIdea.ownerId){
            DRDW_Project__Share oShare = new DRDW_Project__Share();
            oShare.UserOrGroupId = oIdea.ERL_Primary_Contact__c;
            oShare.ParentId = oIdea.Id;
            oShare.AccessLevel = 'Edit';
            oShare.RowCause = Schema.DRDW_Project__Share.RowCause.DRDW_Research_Share__c;
            insert oShare;
        } 
        
        //Sharing child records with the User lookup's user given they aren't null
        if(lgens != null){
            for(DRDW_Project__c prj : lgens){
                DRDW_Project__Share oShare = new DRDW_Project__Share();
                    oShare.UserOrGroupId = oIdea.ERL_Primary_Contact__c;
                    oShare.ParentId = prj.Id;
                    oShare.AccessLevel = 'Edit';
                    oShare.RowCause = Schema.DRDW_Project__Share.RowCause.DRDW_Research_Share__c;
                    insert oShare;
            }
            } 
        }
        
        
        
            
        
            List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:Userinfo.getUserId()]);
            
        if(currentRecordID != null && isAdmin==false  && lPermission[0].PermissionSet.Name!='DRDW_Leadership_User'){
            if(oIdea.ERL_Primary_Contact__c != userinfo.getUserId() && userinfo.getUserId()!=oIdea.OwnerId ){
                PageReference pageref = new PageReference('/apex/DRDW_NoAccess');
                pageref.setredirect(true);
                return pageref;
            }  
            } 
            
            */
            
            if(!Hasaccess(UserInfo.getUserId(), oIdea.Id)){
                
                PageReference pageref = new PageReference('/apex/DRDW_NoAccess');
                pageref.setredirect(true);
                return pageref;
                
            }
            
            //PageReference pageref = new PageReference(null);
            PageReference pageref = new PageReference('/apex/DRDW_CreateIdea?id='+oIdea.Id+'&isEdit=false');
            pageref.setredirect(true);
            return pageref;

        }catch (Exception e){
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an error creating an idea. Please try again');
            ApexPages.addMessage(myMsg1);
            return null;
        } 
        
    }

    /*
    * @Method Name                    :  EditRecord
    * @Description                    :  Method for editing and existing BP record
    * @Return Type                    :  PageReference
    * @Parameters                     :  None
    */
    public PageReference EditRecord() {
        pagereference pageref = new pagereference('/apex/DRDW_CreateIdea?id=' + currentRecordID + '&isEdit=true');
        pageref.setredirect(true);
        return pageref;
    }
    
    /*
    * @Method Name                    :  AddExperiment
    * @Description                    :  Method to add a new Capability (Of Idea type)
    * @Return Type                    :  void
    * @Parameters                     :  None
    */
    Public void AddExperiment() {
        /*pagereference pageref = new pagereference('/apex/DRDW_CreateIdeaCapability?ideaid=' + currentRecordID);
        pageref.setredirect(true);
        return pageref; 
    
    boolean isUnique = true;
        if (currentRecordID != NULL) {
            try {
                system.debug('Inside Add method');
                oiexp.Idea__c = currentRecordID;
                for(DRDW_Idea_Experiment__c var1 : liexps){
                    if(var1.Capability__c == oiexp.Capability__c){
                        ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'This Experiment has already been added. Please check and try again');
                        ApexPages.addMessage(myMsg1);
                        isExpError = true;
                        isUnique = false;
                    }
                }
                if(isUnique){
                insert oiexp;
                }
                system.debug('Inserted Experiment'+oiexp);                
                liexps = [Select Idea__c, Capability__c,Idea__r.name,Capability__r.name from DRDW_Idea_Experiment__c where Idea__c = :currentRecordID];
                oiexp = new DRDW_Idea_Experiment__c();
            system.debug('List+++++++++++++++++'+liexps);
            } catch (exception e) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an error Adding experiments. Please try again');
                ApexPages.addMessage(myMsg);
                isExpError = true;
            }
        } */
    }    


    /*
    * @Method Name                    :  RemoveExp
    * @Description                    :  Method to remove an Exp
    * @Return Type                    :  void
    * @Parameters                     :  None
    */

    Public void RemoveExp() {
        /*  try {
            liexps = [Select Idea__c, Capability__c,Idea__r.name, Capability__r.name from DRDW_Idea_Experiment__c where Idea__c = :currentRecordID];
            DRDW_Idea_Experiment__c oExp = [Select id from DRDW_Idea_Experiment__c where Idea__c = :currentRecordID AND Capability__c = : genericID];
            delete oExp;
            liexps = [Select Idea__c, Capability__c,Idea__r.name,Capability__r.name from DRDW_Idea_Experiment__c where Idea__c = :currentRecordID];
        } catch (exception e) {
            addError(e.getmessage());
            isExpError = true;
        }*/
        
    } 
    
    
    /*
    * @Method Name                    :  RemoveCap
    * @Description                    :  Method to remove Capabilities
    * @Return Type                    :  void
    * @Parameters                     :  None
    */
    public void RemoveCap(){
        try{
            lcaps = [Select id,Related_Project__c,ERL_Primary_Contact__c,Research_Project_Lead__r.Name,Name,Capability_Area__c,Planned_Start_Date__c,Assigned_Resource__r.Name,Capability__c from DRDW_Capability__c where Related_Idea__c = :currentRecordID];
            DRDW_Capability__c ocap = [Select Id, Name from DRDW_Capability__c where Related_Idea__c = :currentRecordID and Id = :genericID];
            delete ocap;
            lcaps = [Select id,Related_Project__c,ERL_Primary_Contact__c,Research_Project_Lead__r.Name,Name,Capability_Area__c,Planned_Start_Date__c,Assigned_Resource__r.Name,Capability__c from DRDW_Capability__c where Related_Idea__c = :currentRecordID];
        }catch (exception e) {
            addError(e.getmessage());
            isExpError = true;
        }

    }
    
    
    /*
    * @Method Name                    :  AddRisks
    * @Description                    :  Method to add a new Risk
    * @Return Type                    :  PageReference
    * @Parameters                     :  None
    */
    
    Public PageReference AddRisks() {
        
        PageReference pageref = new PageReference('/apex/DRDW_CreateRisk?projectid='+currentRecordID);
        pageref.setredirect(true);
        return pageref;
        /* boolean isUnique = true;
        if (currentRecordID != NULL) {
            try {
                system.debug('Inside Add method');
                oirisk.Idea__c = currentRecordID;
                for(DRDW_Idea_Risk__c var1 : lirisks){
                    if(var1.Risk__c == oirisk.Risk__c){
                        ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'This Risk has already been added. Please check and try again');
                        ApexPages.addMessage(myMsg1);
                        isRiskError = true;
                        isUnique = false;
                    }
                }
                if(isUnique){
                insert oirisk;
                }
                system.debug('Inserted Experiment'+oiexp);                
                lirisks = [Select Idea__c, Risk__c,Idea__r.name,Risk__r.name from DRDW_Idea_Risk__c where Idea__c = :currentRecordID];
                oirisk = new DRDW_Idea_Risk__c();
            system.debug('List+++++++++++++++++'+lirisks);
            } catch (exception e) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an error Adding a Risk. Please try again');
                ApexPages.addMessage(myMsg);
                isRiskError = true;
            }
        } */
    }     


    /*
    * @Method Name                    :  RemoveRisk
    * @Description                    :  Method to remove a Risk
    * @Return Type                    :  void
    * @Parameters                     :  None
    */

    Public void RemoveRisk() {
        try {
            lirisks = [Select Name,Description__c from DRDW_Risk__c where Related_To__c =: currentRecordID];
            DRDW_Risk__c oExp = [Select id from DRDW_Risk__c where Related_To__c = :currentRecordID AND id = : genericID];
            delete oExp;
            lirisks = [Select Name,Description__c from DRDW_Risk__c where Related_To__c =: currentRecordID];
        } catch (exception e) {
            addError(e.getmessage());
            isRiskError = true;
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
            lbudgets = [Select id,Name ,Titletab__c,Scientist_Owner__c,Title__c,PO__c,Activity_Name__c,Vendorr__c,Total_Contract_Value__c,Total_Actuals__c,Cost_Center__r.Name from DRDW_Budget_Master__c where Related_To__c =: currentRecordID];
            DRDW_Budget_Master__c oExp = [Select id from DRDW_Budget_Master__c where Related_To__c = :currentRecordID AND id = : genericID];
            delete oExp;
            lbudgets = [Select id,Name ,Titletab__c,Scientist_Owner__c,Title__c,PO__c,Activity_Name__c,Vendorr__c,Total_Contract_Value__c,Total_Actuals__c,Cost_Center__r.Name from DRDW_Budget_Master__c where Related_To__c =: currentRecordID];
        } catch (exception e) {
            addError(e.getmessage());
            isbError = true;
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
    * @Method Name                    :  EditCreateExpRecord
    * @Description                    :  Method for creating a new Experiment
    * @Return Type                    :  PageReference
    * @Parameters                     :  None
    */
    
    public PageReference AddCap(){
        pagereference pageref = new pagereference('/apex/DRDW_CreateIdeaCapability?ideaid='+ currentRecordID);
        pageref.setredirect(true);
        return pageref;
    }
    
    /*
    * @Method Name                    :  EditCreateExpRecord
    * @Description                    :  Method for creating a new Experiment
    * @Return Type                    :  PageReference
    * @Parameters                     :  None
    */
    
    public PageReference AddBudget(){
        pagereference pageref = new pagereference('/apex/DRDW_CreateBudgetMaster?isIdea=true&parentID='+ currentRecordID);
        pageref.setredirect(true);
        return pageref;
    }
    
    
    /*
    * @Method Name                    :  AddERLRequest
    * @Description                    :  Method for creating a new ERL request
    * @Return Type                    :  PageReference
    * @Parameters                     :  None
    */
    
    public PageReference AddERLRequest(){
        pagereference pageref = new pagereference('/apex/DRDW_CreateERLRequest?projid='+ currentRecordID);
        pageref.setredirect(true);
        return pageref;
    }

    /*
    * @Method Name                    :  AddGORequest
    * @Description                    :  Method for creating a new GO request
    * @Return Type                    :  PageReference
    * @Parameters                     :  None
    */
    
    public PageReference AddGORequest(){
        pagereference pageref = new pagereference('/apex/DRDW_CreateGORequest?projid='+ currentRecordID);
        pageref.setredirect(true);
        return pageref;
    }
    
    
    /*
    * @Method Name                    :  CapabilityLink
    * @Description                    :  Method to redirect user to capabitlity record
    * @Return Type                    :  PageReference
    * @Parameters                     :  None
    */
    
    public PageReference CapabilityLink(){
        pagereference pageref = new pagereference('/apex/DRDW_CreateExternalActivity?id='+LinkID+'&isEdit=false');
        pageref.setredirect(true);
        return pageref;
    }
    
    /*
    * @Method Name                    :  GenLink
    * @Description                    :  Method to redirect user to Generation record
    * @Return Type                    :  PageReference
    * @Parameters                     :  None
    */
    
    public PageReference GenLink(){
        pagereference pageref = new pagereference('/apex/DRDW_CreateGeneration?id='+LinkID1+'&isEdit=false');
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
    
    /*
    * @Method Name                    :  Cancel
    * @Description                    :  This method redirects the user back to the previous page
    * @Return Type                    :  PageReference
    * @Parameters                     :  None
    */
    
    Public PageReference cancel(){
        if(currentRecordID != NULL){
            PageReference pageref = new PageReference('/apex/DRDW_CreateIdea?id='+currentRecordID+'&isEdit=false');
            pageref.setredirect(true);
            return pageref;
        }  else{
            PageReference pageref = new PageReference('/apex/DRDW_PlanResearch');
            pageref.setredirect(true);
            return pageref;
        }
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
    
    Public PageReference DeleteRecord(){
        
        delete oIdea;
        
        PageReference pageref = new PageReference('/apex/DRDW_DeletedProjRecord');
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
    
    Public Boolean getUserPermissionLeader(Id UserID){
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserID AND (PermissionSet.Name = 'DRDW_Leadership_User' OR PermissionSet.Name = 'DRDW_Senior_Leadership_User') ]);
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
    
    Public PageReference copyFieldsfromEvaluation(){
        
        IdeaId = oIdea.Related_Idea__c;
        DRDW_Project__c oIdeanew = [Select New_Idea_Name__c, Hypothesis__c,Decision_to_Evaluate_DTE__c, ERL_Primary_Contact__c, Business_Unit__c from DRDW_Project__c where id =: IdeaId LIMIT 1];
        //DRDW_Project__c oIdea = new DRDW_Project__c();
        oIdea.recordtypeid = getObjectRecordTypeId(DRDW_Project__c.SObjectType,'Idea Project');
        oIdea.Idea_Name__c = oIdeanew.New_Idea_Name__c;
        oIdea.Hypothesis__c = oIdeanew.Hypothesis__c;
        oIdea.Decision_to_Evaluate_DTE__c = oIdeanew.Decision_to_Evaluate_DTE__c;
        oIdea.ERL_Primary_Contact__c = oIdeanew.ERL_Primary_Contact__c;
        oIdea.Business_Unit__c = oIdeanew.Business_Unit__c;
        
        PageReference pageref = new PageReference('/apex/DRDW_CreateIdea');
        pageref.setredirect(false);
        return pageref;
    }   

    Public PageReference checkAccess(){

        PageReference pageref = null;

        String recid = ApexPages.currentPage().getParameters().get('id');  

        List<UserRecordAccess> lst = new List<UserRecordAccess>(); 

        lst = [SELECT RecordId FROM UserRecordAccess WHERE UserId = :UserInfo.getUserId() AND RecordId = :recid AND HasEditAccess = true];

        if(lst.isEmpty()){
            
            pageref = new PageReference('/apex/DRDW_DFHomePage');
            pageref.setredirect(true);
            return pageref;  
            
        }
        
        return pageref;


    }

    /*
    * @Method Name                    :  cycleTimeStandard
    * @Description                    :  Method for getting cycle Time Standard
    * @Return Type                    :  void
    * @Parameters                     :  None
    */
    public void cycleTimeStandard() {
        Boolean isUpdate = false;
        DRDW_Cycle_Time_Standard__c oCycleStandard = new DRDW_Cycle_Time_Standard__c();
        oCycleStandard = [Select Evaluation_Cycle_Time_Standard_for_Small__c,Evaluation_Cycle_Time_Standard_for_Vacci__c,Evaluation_Cycle_Time_Standard_for_Bioph__c from DRDW_Cycle_Time_Standard__c limit 1];
        
        /*if(oIdea.Molecule_Classification__c == 'Small Molecule'){
            if(oIdea.Cycle_Time_Standard__c != oCycleStandard.Evaluation_Cycle_Time_Standard_for_Small__c){
                isUpdate = true;
            }
            oIdea.Cycle_Time_Standard__c = oCycleStandard.Evaluation_Cycle_Time_Standard_for_Small__c;
        }else if(oIdea.Molecule_Classification__c == 'Biopharma'){
            if(oIdea.Cycle_Time_Standard__c != oCycleStandard.Evaluation_Cycle_Time_Standard_for_Bioph__c){
                isUpdate = true;
            }
            oIdea.Cycle_Time_Standard__c = oCycleStandard.Evaluation_Cycle_Time_Standard_for_Bioph__c;
        }else if(oIdea.Molecule_Classification__c == 'Vaccine'){
            if(oIdea.Cycle_Time_Standard__c != oCycleStandard.Evaluation_Cycle_Time_Standard_for_Vacci__c){
                isUpdate = true;
            }
            oIdea.Cycle_Time_Standard__c = oCycleStandard.Evaluation_Cycle_Time_Standard_for_Vacci__c;
        }  */
        
        if(oIdea.Molecule_Classification__c == null){
            oIdea.EPCTM_DTG_DTE_for_Biopharma__c = 0;
            oIdea.EPCTM_DTG_DTE_for_Small_Molecule__c = 0;
            oIdea.EPCTM_DTG_DTE_for_Vaccine__c = 0;
        }else if(oIdea.Molecule_Classification__c == 'Small Molecule'){
            if(oIdea.EPCTM_DTG_DTE_for_Small_Molecule__c != oCycleStandard.Evaluation_Cycle_Time_Standard_for_Small__c){
                isUpdate = true;
            }
            oIdea.EPCTM_DTG_DTE_for_Small_Molecule__c = oCycleStandard.Evaluation_Cycle_Time_Standard_for_Small__c;
            oIdea.EPCTM_DTG_DTE_for_Biopharma__c = 0;
            oIdea.EPCTM_DTG_DTE_for_Vaccine__c = 0;
        }else if(oIdea.Molecule_Classification__c == 'Biopharma'){
            if(oIdea.EPCTM_DTG_DTE_for_Biopharma__c != oCycleStandard.Evaluation_Cycle_Time_Standard_for_Bioph__c){
                isUpdate = true;
            }
            oIdea.EPCTM_DTG_DTE_for_Biopharma__c = oCycleStandard.Evaluation_Cycle_Time_Standard_for_Bioph__c;
            oIdea.EPCTM_DTG_DTE_for_Small_Molecule__c = 0;
            oIdea.EPCTM_DTG_DTE_for_Vaccine__c = 0;
        }else if(oIdea.Molecule_Classification__c == 'Vaccine'){
            if(oIdea.EPCTM_DTG_DTE_for_Vaccine__c != oCycleStandard.Evaluation_Cycle_Time_Standard_for_Vacci__c){
                isUpdate = true;
            }
            oIdea.EPCTM_DTG_DTE_for_Vaccine__c = oCycleStandard.Evaluation_Cycle_Time_Standard_for_Vacci__c;
            oIdea.EPCTM_DTG_DTE_for_Small_Molecule__c = 0;
            oIdea.EPCTM_DTG_DTE_for_Biopharma__c = 0;
        }
        
        if(isUpdate  && oIdea.Id != NULL){
            update oIdea;
        }   
    }
    
    public class requestwrapper{

        Public DRDW_Cap_Request__c oRequest{get;set;}
        Public DRDW_Capability__c oActivity{get;set;}

        public requestwrapper(DRDW_Cap_Request__c oRequest,DRDW_Capability__c oActivity){

            this.oRequest = oRequest;
            this.oActivity = oActivity;

        }

    } 
    
    Public Boolean getUserPermissionSrLeader(Id UserID){
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserID AND PermissionSet.Name = 'DRDW_Senior_Leadership_User']);
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

    Public Boolean getUserPermissionsSM(Id UserID){
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
    
    Public Boolean getGOUseraccess(Id UserID){
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserID AND PermissionSet.Name IN ('DRDW_ERL_Head','DRDW_Functional_Head','DRDW_Leadership_User')]);
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

    Public Boolean getERLUseraccess(Id UserID){
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserID AND PermissionSet.Name IN ('DRDW_Leadership_User','DRDW_GO_User')]);
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
    
    Public void groupBUAssigned(){
        groupBUAssigned = new set<String>();
        List<String> allGroupIDs = new List<String>();
        for (GroupMember gm : [SELECT Id, group.id, group.DeveloperName, group.type FROM GroupMember where (UserOrGroupId = :UserInfo.getUserId())]){
            if(DRDW_Constants.groupBUMapping.containsKey(gm.group.DeveloperName)){
                groupBUAssigned.add(DRDW_Constants.groupBUMapping.get(gm.group.DeveloperName));
            }
        }
      
        if(oIdea.Business_Unit__c != null && groupBUAssigned != null){
            if(groupBUAssigned.contains(oIdea.Business_Unit__c)){
                isInBuGroup = true;
            }
        }
        
    }

}