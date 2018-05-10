Public without sharing Class DRDW_createAssessment{ 
    Public DRDW_Project__c oStudy{get;set;}
    Public Id currentRecordID {get; set;}
    Public Boolean isError{get;set;}
    Public DRDW_Risk__c oAssRisk{get;set;}
    Public List<DRDW_Risk__c> lAssRisk{get;set;}
    Public DRDW_Capability__c oAssCap{get;set;}
    Public List<DRDW_Capability__c> lAssCap{get;set;}
    public id genericID {get; set;}
    Public id capabilityID{get;set;}
    Public id LinkID{get;set;}
    public id LinkID2 {get; set;}
    public boolean isbError {get; set;}
    public List<DRDW_Budget_Master__c> lbudgets {get; set;}
    Public DRDW_Project__c oGenerationProject{get;set;}
    Public Boolean isAdmin{get;set;}
    Public Boolean isFin{get;set;}
    public Boolean isAccess {get;set;}
    Public boolean isRedFlag{get;set;}
    Public id GenerationId{get;set;}
    Public List<SelectOption> lSimplifiedPicklist{get;set;}
    Public List<SelectOption> lTerminationPicklist{get;set;}
    Public Boolean isLeader {get;set;}
    Public List<requestwrapper> lRequestWrapper{get;set;}
    public Integer ErlCount{get;set;}
    Public List<requestwrapper> lRequestWrapperGO{get;set;}
    public Integer goCount{get;set;}
    Public Boolean isSrLeader {get; set;}
    Public boolean hasGOaccess {get; set;}
    Public boolean isInBuGroup{get; set;}
    Public Set<String> groupBUAssigned{get;set;}
    Public boolean hasERLaccess{get; set;}
    Public boolean isSM {get; set;}
    Public DRDW_createAssessment(ApexPages.StandardController controller){
        isInBuGroup = false;
        hasERLaccess =false;
        isSM = false;
        //oStudy = new DRDW_Project__c();
        oStudy = (DRDW_Project__c)controller.getRecord();
        oStudy.Phase__c = 'Assessment';
        oStudy.Organizational_Unit__c = 'Research';
        oStudy.Current_As_Of__c = System.today();
        currentRecordID = ApexPages.currentPage().getParameters().get('id');
        lSimplifiedPicklist = new List<SelectOption>();
        lTerminationPicklist = new List<SelectOption>();
        hasGOaccess =false;
        For(GLBL_Global_List_of_Values__c oglbl : [Select Name,RecordType.developerName from GLBL_Global_List_of_Values__c where Active__c = True AND RecordType.DeveloperName = 'DRDW_Elanco_Simplified_Project_Name' order by name ASC]){
            lSimplifiedPicklist.add(new SelectOption(oglbl.Name,oglbl.Name));
        }
        For(GLBL_Global_List_of_Values__c oglbl : [Select Name,RecordType.developerName from GLBL_Global_List_of_Values__c where Active__c = True AND RecordType.DeveloperName = 'DRDW_Elanco_Termination_Reason' order by name ASC]){
            lTerminationPicklist.add(new SelectOption(oglbl.Name,oglbl.Name));
        }
        if(currentRecordID != null){
            String SobjectApiName = 'DRDW_Project__c';
            isRedFlag = false;
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
            oStudy = Database.query(query);
            /*if(oStudy.Cycle_Time_Assess__c != NULL && oStudy.Cycle_Time_Standard__c != NULL){
            if((oStudy.Cycle_Time_Assess__c - oStudy.Cycle_Time_Standard__c)>=30){
            isRedFlag = true;
            }else{
            isRedFlag = false;
            }
            }else{
            isRedFlag = false;
            }
            oStudy.EPCTM_DP1_DTA_for_Small_Molecule__c = oCycleStandard.Generation_Cycle_Time_Standard_for_Small__c;
            oStudy.EPCTM_DP1_DTA_for_Biopharma__c = 0;
            oStudy.EPCTM_DP1_DTA_for_Vaccine__c = 0; 
            */
            if(oStudy.Cycle_Time_Assess__c != NULL && oStudy.EPCTM_DP1_DTA_for_Biopharma__c!= null && oStudy.EPCTM_DP1_DTA_for_Biopharma__c != 0 && (oStudy.Cycle_Time_Assess__c - oStudy.EPCTM_DP1_DTA_for_Biopharma__c)>=30){
                isRedFlag = true;
            }
            if(oStudy.Cycle_Time_Assess__c != NULL && oStudy.EPCTM_DP1_DTA_for_Small_Molecule__c != NULL && oStudy.EPCTM_DP1_DTA_for_Small_Molecule__c != 0  && (oStudy.Cycle_Time_Assess__c - oStudy.EPCTM_DP1_DTA_for_Small_Molecule__c)>=30){
                isRedFlag = true;
            }
            if(oStudy.Cycle_Time_Assess__c != NULL && oStudy.EPCTM_DP1_DTA_for_Vaccine__c != NULL && oStudy.EPCTM_DP1_DTA_for_Vaccine__c != 0  && (oStudy.Cycle_Time_Assess__c - oStudy.EPCTM_DP1_DTA_for_Vaccine__c)>=30){
                isRedFlag = true;
            }
            if(oStudy.Related_Generation_Project__c != null){
                oGenerationProject = [Select Name,Project_Name__c,Business_Unit__c from DRDW_Project__c where id =: oStudy.Related_Generation_Project__c Limit 1];
            }
            oAssCap = new DRDW_Capability__c();
            lAssCap = new List<DRDW_Capability__c>();
            lAssCap =  [Select id,Name,Title__c,Title_ex__c,Related_Project__c,Planned_Start_Date__c,ERL_Primary_Contact__c,Research_Project_Lead__r.Name,Capability_Area__c,Capability__c from DRDW_Capability__c where Related_Project__c = : currentRecordID and recordtype.developername = 'External_Activity'];
            //Creating a record for the junction object
            oAssRisk = new DRDW_Risk__c();
            lAssRisk = new List<DRDW_Risk__c>();
            lAssRisk =[Select id,Name,Risk_Details__c,Risk_Status__c,Description__c,Probability_of_Occurring__c,Milestone_Risk_Impacts__c from DRDW_Risk__c where Related_To__c = : currentRecordID];
            lbudgets = [Select id,Name,Titletab__c,Scientist_Owner__c,Title__c,PO__c,Activity_Name__c,Vendorr__c,Total_Contract_Value__c,Total_Actuals__c,Cost_Center__r.Name from DRDW_Budget_Master__c where Related_To__c =: currentRecordID];
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
            //if(oStudy.Total_Rolling_Forecast__c != null){
            if(lstsummaries!=null && !lstsummaries.isEmpty() && lstsummaries.size()>1){
                for(DRDW_Budget_Summary__c tmpsmmry : lstsummaries){
                    TotalRF = TotalRF + tmpsmmry.F_X_Forecast__c;
                }
                oStudy.Total_Rolling_Forecast__c = TotalRF.round(System.RoundingMode.HALF_EVEN);
            }else if(lstsummaries.size() == 1){
                oStudy.Total_Rolling_Forecast__c = lstsummaries[0].F_X_Forecast__c.round(System.RoundingMode.HALF_EVEN);
            }
            System.debug('Total Rolling foreeeeecast'+oStudy.Total_Rolling_Forecast__c);
            //}
            lRequestWrapper = new List<requestwrapper>();
            lRequestWrapperGO = new List<requestwrapper>();
            AggregateResult i = [select count(id) from DRDW_Cap_Request__c where recordtype.developername='ERL' and Project__c=:oStudy.id];
            system.debug('I'+i.get('expr0'));  
            if(i!=null){    
                erlcount =  (Integer)i.get('expr0');     
            }else{
                erlcount = 0;
            }
            AggregateResult i1 = [select count(id) from DRDW_Cap_Request__c where recordtype.developername='GO' and Project__c=:oStudy.id];
            system.debug('I'+i1.get('expr0'));  
            if(i1!=null){    
                goCount =  (Integer)i1.get('expr0');     
            }else{
                goCount = 0;
            }
            if(erlcount!=0){
                for(DRDW_Cap_Request__c r:[select id,Name,recordtype.developername,(select id,Status__c,Title__c,Capability__c,Capability_Area__c,Actual_End_Date__c,Actual_Start_Date__c,Planned_End_Date__c,Planned_Start_Date__c from DRDW_Activities__r) from DRDW_Cap_Request__c where Project__c=:oStudy.id and recordtype.developername='ERL']){
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
            }
            if(goCount!=0){
                for(DRDW_Cap_Request__c r:[select id,Name,recordtype.developername,Request_Status__c,(select id,Status__c,Title__c,Capability__c,Capability_Area__c,Actual_End_Date__c,Actual_Start_Date__c,Planned_End_Date__c,Planned_Start_Date__c from DRDW_Activities__r) from DRDW_Cap_Request__c where Project__c=:oStudy.id and recordtype.developername='GO']){
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
            }
        }
        groupBUAssigned();
        isAdmin = getUserPermission(UserInfo.getUserId());
        isFin = getUserPermissionFin(UserInfo.getUserId());
        isAccess = Hasaccess(UserInfo.getUserId(), oStudy.Id);
        isLeader = getUserPermissionLeader(UserInfo.getUserId());
        isSrLeader = getUserPermissionSrLeader(UserInfo.getUserId());
        hasGOaccess = getGOUseraccess(UserInfo.getUserId());
        hasERLaccess = getERLUseraccess(UserInfo.getUserId());
        isSM = getUserPermissionSM(UserInfo.getUserId());
    }
    /*
    * @Method Name                    :  Save
    * @Description                    :  Method to Save the record
    * @Return Type                    :  None
    * @Parameters                     :  None
    */  
    Public PageReference save(){
        try{
            List<DRDW_Project__Share> sProjectShare = new List<DRDW_Project__Share>();
            Set<id> sUserShareId = new Set<id>();
            Set<id> BUgrpId = new Set<id>();
            Map<String, Id> BUgrpMap = new Map<String, Id>();
            if(currentRecordID == NULL){
                oStudy.recordtypeid = getObjectRecordTypeId(DRDW_Project__c.SObjectType,'Assessment Project');
                List<User> lUser = new List<User>([Select id,Name from User Where Id =:oStudy.Director__c OR Id = :oStudy.Research_Project_Lead__c OR Id =:oStudy.ERL_Primary_Contact__c]);
                for(User u : lUser){
                    if(u.id == oStudy.Director__c){                      
                        oStudy.Director_Name__c = u.Name;
                    }else if(u.id == oStudy.ERL_Primary_Contact__c){
                        oStudy.ERL_Primary_Contact_Name__c = u.Name;
                    }else{
                        oStudy.Research_Project_Lead_Name__c = u.Name;
                    }
                }
            }else{
                oStudy.Current_As_Of__c = System.today();
                List<User> lUser = new List<User>([Select id,Name from User Where Id =:oStudy.Director__c OR Id = :oStudy.Research_Project_Lead__c OR Id =:oStudy.ERL_Primary_Contact__c]);
                for(User u : lUser){
                    if(u.id == oStudy.Director__c){                      
                        oStudy.Director_Name__c = u.Name;
                    }else if(u.id == oStudy.ERL_Primary_Contact__c){
                        oStudy.ERL_Primary_Contact_Name__c = u.Name;
                    }else{
                        oStudy.Research_Project_Lead_Name__c = u.Name;
                    }
                }
            }
            /*      
                if(currentRecordID != null){
                List<DRDW_Project__Share> pshare = [SELECT AccessLevel,Id,RowCause,UserOrGroupId FROM DRDW_Project__Share WHERE ParentId =:oStudy.id and RowCause !='Owner'];
                database.delete(pshare);
                }
                */
            //Rounding off the currency fields
            if(oStudy.Total_budget__c != null){
                oStudy.Total_budget__c = oStudy.Total_budget__c.round(System.RoundingMode.HALF_EVEN);
            }
            if(oStudy.IMA__c != null){
                oStudy.IMA__c = oStudy.IMA__c.round(System.RoundingMode.HALF_EVEN);
            }
            if(oStudy.PK_Sales_M__c != null){
                oStudy.PK_Sales_M__c = oStudy.PK_Sales_M__c.round(System.RoundingMode.HALF_EVEN);
            }
            Upsert oStudy;
            /*
            if(oStudy.Director__c != null && oStudy.Director__c != oStudy.OwnerId){
            sUserShareId.add(oStudy.Director__c);
            }
            if(oStudy.Launch_Leader__c != null && oStudy.Launch_Leader__c != oStudy.OwnerId){
            sUserShareId.add(oStudy.Launch_Leader__c);
            }
            if(oStudy.Global_Marketer__c != null && oStudy.Global_Marketer__c != oStudy.OwnerId){
            sUserShareId.add(oStudy.Global_Marketer__c);
            }
            if(oStudy.Regulatory_Rep__c != null && oStudy.Regulatory_Rep__c != oStudy.OwnerId){
            sUserShareId.add(oStudy.Regulatory_Rep__c);
            }
            if(oStudy.RP_Project_Manager__c != null && oStudy.RP_Project_Manager__c != oStudy.OwnerId){
            sUserShareId.add(oStudy.RP_Project_Manager__c);
            }
            if(oStudy.Legal_REP__c != null && oStudy.Legal_REP__c != oStudy.OwnerId){
            sUserShareId.add(oStudy.Legal_REP__c);
            }
            if(oStudy.Research_Project_Lead__c != null && oStudy.Research_Project_Lead__c != oStudy.OwnerId){
            sUserShareId.add(oStudy.Research_Project_Lead__c);
            }
            if(oStudy.Lead_Finder__c != null && oStudy.Lead_Finder__c != oStudy.OwnerId){
            sUserShareId.add(oStudy.Lead_Finder__c);
            }
            if(oStudy.Development_Team_Director__c!= null && oStudy.Development_Team_Director__c!= oStudy.OwnerId){
            sUserShareId.add(oStudy.Development_Team_Director__c);
            }
            if(oStudy.Internal_Development_Partner__c != null && oStudy.Internal_Development_Partner__c != oStudy.OwnerId){
            sUserShareId.add(oStudy.Internal_Development_Partner__c);
            }
            if(oStudy.ERL_Primary_Contact__c != null && oStudy.ERL_Primary_Contact__c != oStudy.OwnerId){
            sUserShareId.add(oStudy.ERL_Primary_Contact__c);
            }
            for(Id Userid : sUserShareId){
            DRDW_Project__Share oShare = new DRDW_Project__Share();
            oShare.UserOrGroupId = Userid;
            oShare.ParentId = oStudy.id;
            oShare.AccessLevel = 'Edit';
            oShare.RowCause = Schema.DRDW_Project__Share.RowCause.DRDW_Research_Share__c;
            sProjectShare.add(oShare);
            //adding the related generation's access to the users as well (if Related generation is not blank)
            if(oStudy.Related_Generation_Project__c != null){
            DRDW_Project__Share oRShare = new DRDW_Project__Share();
            oRShare.UserOrGroupId = Userid;
            oRShare.ParentId = oStudy.Related_Generation_Project__c;
            oRShare.AccessLevel = 'Edit';
            oRShare.RowCause = Schema.DRDW_Project__Share.RowCause.DRDW_Research_Share__c;
            sProjectShare.add(oRShare);
            //adding the related generation's related idea's access to the users as well (if Related idea on related gen is not blank)
            if(oStudy.Related_Generation_Project__c != null){
            if(oStudy.Related_Generation_Project__r.Related_Idea_Project__c != null){
            DRDW_Project__Share oRrShare = new DRDW_Project__Share();
            oRrShare.UserOrGroupId = Userid;
            oRrShare.ParentId = oStudy.Related_Generation_Project__r.Related_Idea_Project__c;
            oRrShare.AccessLevel = 'Edit';
            oRrShare.RowCause = Schema.DRDW_Project__Share.RowCause.DRDW_Research_Share__c;
            sProjectShare.add(oRrShare);
            }
            }
            }
            }
            if(oStudy.Business_Unit__c != '' || oStudy.Business_Unit__c != null){
            // Sharing with Public groups based on the assigned Business Unit
            for(Group grp : [Select Id, Name from Group where Name like 'DRDW_BU%']){
            BUgrpMap.put(grp.Name, grp.Id);
            }
            system.debug('&&&&&&&&Laxmi'+BUgrpMap);
            DRDW_Project__Share oPShare = new DRDW_Project__Share();
            //Checking for the records Business unit and assigning public groups
            if(oStudy.Business_Unit__c == 'Business Development'){
            oPShare.UserOrGroupId = BUgrpMap.get('DRDW BU Business Development');
            }else if(oStudy.Business_Unit__c == 'Companion Animal - Parasitology'){
            oPShare.UserOrGroupId = BUgrpMap.get('DRDW BU CA Parasitology');
            }else if(oStudy.Business_Unit__c == 'Companion Animal - Therapeutics'){
            oPShare.UserOrGroupId = BUgrpMap.get('DRDW BU CA Therapeutics');
            }else if(oStudy.Business_Unit__c == 'Companion Animal - Vaccines'){
            oPShare.UserOrGroupId = BUgrpMap.get('DRDW BU CA Vaccines');
            }else if(oStudy.Business_Unit__c == 'External Innovation'){
            oPShare.UserOrGroupId = BUgrpMap.get('DRDW BU External Innovation');
            }else if(oStudy.Business_Unit__c == 'Food Animal - Parasitology'){
            oPShare.UserOrGroupId = BUgrpMap.get('DRDW BU FA Parasitology');
            }else if(oStudy.Business_Unit__c == 'Food Animal - Therapeutics'){
            oPShare.UserOrGroupId = BUgrpMap.get('DRDW BU FA Therapeutics');
            }else if(oStudy.Business_Unit__c == 'Food Animal - Vaccines'){
            oPShare.UserOrGroupId = BUgrpMap.get('DRDW BU FA Vaccines');
            }else 
            oPShare.UserOrGroupId = BUgrpMap.get('DRDW BU Nutritionals');
            oPShare.ParentId = oStudy.id;
            oPShare.AccessLevel = 'Edit';
            oPShare.RowCause = Schema.DRDW_Project__Share.RowCause.DRDW_Research_Share__c;
            sProjectShare.add(oPShare);
            }
            if(!sProjectShare.isEmpty()){
            insert sProjectShare;
            }
            List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:Userinfo.getUserId()]);   
            if(currentRecordID != null && isAdmin==false  && lPermission[0].PermissionSet.Name!='DRDW_Leadership_User' ){        
            if(!sUserShareId.contains(userinfo.getUserId()) && userinfo.getUserId()!=oStudy.OwnerId ){
            PageReference pageref = new PageReference('/apex/DRDW_NoAccess');
            pageref.setredirect(true);
            return pageref;
            }  
            }
            */
            if(!Hasaccess(UserInfo.getUserId(), oStudy.Id)){
                PageReference pageref = new PageReference('/apex/DRDW_NoAccess');
                pageref.setredirect(true);
                return pageref;
            }
            PageReference pageref = new PageReference('/apex/DRDW_CreateAssessment?id='+oStudy.Id+'&isEdit=false');
            pageref.setredirect(true);
            return pageref;
        }
        catch(Exception ex){
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an error creating an idea. Please try again');
            ApexPages.addMessage(myMsg1);
            return null;
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
    /*
    * @Method Name                    :  Edit
    * @Description                    :  Method to Edit the record
    * @Return Type                    :  None
    * @Parameters                     :  None
    */  
    Public PageReference edit(){
        PageReference pageref = new PageReference('/apex/DRDW_CreateAssessment?id='+currentRecordID+'&isEdit=true');
        pageref.setredirect(true);
        return pageref;
    }
    
    Public PageReference AddCapability(){
        PageReference pageref = new PageReference('/apex/DRDW_CreateprojectCapability?projectId='+currentRecordID+'&Name='+oStudy.Name+'&isGen=false');
        pageref.setredirect(true);
        return pageref;
    }
    
    Public PageReference cancel(){
        if(currentRecordID != NULL){
            PageReference pageref = new PageReference('/apex/DRDW_CreateAssessment?id='+currentRecordID+'&isEdit=false');
            pageref.setredirect(true);
            return pageref;
        }  else{
            PageReference pageref = new PageReference('/apex/DRDW_PlanResearch');
            pageref.setredirect(true);
            return pageref;
        }
    }
    
    /*
    * @Method Name                    :  AddCap
    * @Description                    :  Method to add a new Capabilities
    * @Return Type                    :  void
    * @Parameters                     :  None
    Public void AddCap() {
        boolean isUnique = true;
        if (currentRecordID != NULL) {
        try {
        oAssCap.Assessment_Project__c = currentRecordID;
        for(DRDW_Assessment_Capability__c var1 : lAssCap){
        if(var1.Assessment_Project__c == oAssCap.Assessment_Project__c ){
        ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'This Capability has already been added. Please check and try again');
        ApexPages.addMessage(myMsg1);
        isError = true;
        isUnique = false;
        }
        }
        if(isUnique){
        insert oAssCap;
        }             
        lAssCap = [Select Assessment_Project__c,Capability__c,Capability__r.Name from DRDW_Assessment_Capability__c where Assessment_Project__c = : currentRecordID];
        oAssCap = new DRDW_Assessment_Capability__c();
        } catch (exception e) {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'There was an error Adding Capability. Please try again');
        ApexPages.addMessage(myMsg);
        isError = true;
        }
        }
    }
    /*
    * @Method Name                    :  RemoveCap
    * @Description                    :  Method to remove an Capability
    * @Return Type                    :  void
    * @Parameters                     :  None
    */
    Public void RemoveCap() {
        try {
            lAssCap =  [Select id,Name,Related_Project__c,Planned_Start_Date__c,ERL_Primary_Contact__c,Research_Project_Lead__r.Name,Capability_Area__c,Capability__c from DRDW_Capability__c where Related_Project__c = : currentRecordID];
            DRDW_Capability__c oCapability = [Select id from DRDW_Capability__c where Related_Project__c = :currentRecordID AND id = : capabilityID];
            delete oCapability;
            lAssCap =  [Select id,Name,Related_Project__c,Planned_Start_Date__c,ERL_Primary_Contact__c,Research_Project_Lead__r.Name,Capability_Area__c,Capability__c from DRDW_Capability__c where Related_Project__c = : currentRecordID];
        } catch (exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e+ 'There was an error Removing Risk. Please try again');
            ApexPages.addMessage(myMsg);
            isError = true;
        }
    }    
    /*
    * @Method Name                    :  CapabilityLink
    * @Description                    :  Method to redirect user to capabitlity record
    * @Return Type                    :  PageReference
    * @Parameters                     :  None
    */
    public PageReference CapabilityLink(){
        pagereference pageref = new pagereference('/apex/DRDW_CreateExternalActivity?id='+LinkID+'&isEdit=false&Name='+oStudy.Name+'&isGen=true');
        pageref.setredirect(true);
        return pageref;
    }
    
    Public PageReference AddNewRisk(){
        PageReference pageref = new PageReference('/apex/DRDW_CreateRisk?projectid='+currentRecordID);
        pageref.setredirect(true);
        return pageref;
    }
    
    /*
    * @Method Name                    :  AddRisk
    * @Description                    :  Method to add a new Risk
    * @Return Type                    :  void
    * @Parameters                     :  None
    */
    Public void AddRisk() {
        /* boolean isUnique = true;
        if (currentRecordID != NULL) {
            try {
                oAssRisk.Related_Assessment_Project__c = currentRecordID;
                for(DRDW_Assessment_Risk__c var1 : lAssRisk){
                    if(var1.Related_Assessment_Project__c == oAssRisk.Related_Assessment_Project__c){
                        ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'This Risk has already been added. Please check and try again');
                        ApexPages.addMessage(myMsg1);
                        isError = true;
                        isUnique = false;
                    }
                }
                if(isUnique){
                    insert oAssRisk;
                }             
                lAssRisk = [Select Related_Risk__c,Related_Risk__r.Name,Related_Assessment_Project__r.id,Related_Assessment_Project__r.Project_Name__c from DRDW_Assessment_Risk__c where Related_Assessment_Project__c = : currentRecordID];
                oAssRisk= new DRDW_Assessment_Risk__c();
                } 
                catch (exception e) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e + 'There was an error Adding Risk. Please try again');
                ApexPages.addMessage(myMsg);
                isError = true;
            }
        }*/
    }
    /*
    * @Method Name                    :  RemoveRisk
    * @Description                    :  Method to remove an Risk
    * @Return Type                    :  void
    * @Parameters                     :  None
    */
    Public void RemoveRisk() {
        try {
            lAssRisk =[Select id,Name,Risk_Details__c,Risk_Status__c,Description__c,Probability_of_Occurring__c,Milestone_Risk_Impacts__c from DRDW_Risk__c where Related_To__c = : currentRecordID];
            DRDW_Risk__c orisk = [Select id from DRDW_Risk__c where Related_To__c = :currentRecordID AND id = : genericID];
            delete orisk;
            lAssRisk =[Select id,Name,Risk_Details__c,Risk_Status__c,Description__c,Probability_of_Occurring__c,Milestone_Risk_Impacts__c from DRDW_Risk__c where Related_To__c = : currentRecordID];
        } catch (exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e+ 'There was an error Removing Risk. Please try again');
            ApexPages.addMessage(myMsg);
            isError = true;
        }
    } 
    
    Public PageReference DeleteRecord(){
        delete oStudy;
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
    * @Method Name                    :  cycleTimeStandard
    * @Description                    :  Method for getting cycle Time Standard
    * @Return Type                    :  void
    * @Parameters                     :  None
    */
    public void cycleTimeStandard() {
        Boolean isUpdate = false;
        DRDW_Cycle_Time_Standard__c oCycleStandard = new DRDW_Cycle_Time_Standard__c();
        oCycleStandard = [Select Assessment_Cycle_Time_Standard_for_Small__c,Assessment_Cycle_Time_Standard_for_Bioph__c,Assessment_Cycle_Time_Standard_for_Vacci__c from DRDW_Cycle_Time_Standard__c limit 1];
        /*if(oStudy.Molecule_Classification__c == 'Small Molecule'){
            if(oStudy.Cycle_Time_Standard__c != oCycleStandard.Assessment_Cycle_Time_Standard_for_Small__c){
            isUpdate = true;
            }
            oStudy.Cycle_Time_Standard__c = oCycleStandard.Assessment_Cycle_Time_Standard_for_Small__c;
            }else if(oStudy.Molecule_Classification__c == 'Biopharma'){
            if(oStudy.Cycle_Time_Standard__c != oCycleStandard.Assessment_Cycle_Time_Standard_for_Bioph__c){
            isUpdate = true;
            }
            oStudy.Cycle_Time_Standard__c = oCycleStandard.Assessment_Cycle_Time_Standard_for_Bioph__c;
            }else if(oStudy.Molecule_Classification__c == 'Vaccine'){
            if(oStudy.Cycle_Time_Standard__c != oCycleStandard.Assessment_Cycle_Time_Standard_for_Vacci__c){
            isUpdate = true;
            }
            oStudy.Cycle_Time_Standard__c = oCycleStandard.Assessment_Cycle_Time_Standard_for_Vacci__c;
        }  */
        System.debug('oStudy.Molecule_Classification__c ' +oStudy.Molecule_Classification__c);
        if(oStudy.Molecule_Classification__c == 'Small Molecule'){
            if(oStudy.EPCTM_DP1_DTA_for_Small_Molecule__c != oCycleStandard.Assessment_Cycle_Time_Standard_for_Small__c){
                isUpdate = true;
            }
            oStudy.EPCTM_DP1_DTA_for_Small_Molecule__c = oCycleStandard.Assessment_Cycle_Time_Standard_for_Small__c;
            oStudy.EPCTM_DP1_DTA_for_Biopharma__c = 0;
            oStudy.EPCTM_DP1_DTA_for_Vaccine__c = 0;
        }
        else if(oStudy.Molecule_Classification__c == 'Biopharma'){
            if(oStudy.EPCTM_DP1_DTA_for_Biopharma__c != oCycleStandard.Assessment_Cycle_Time_Standard_for_Bioph__c){
                isUpdate = true;
            }
            oStudy.EPCTM_DP1_DTA_for_Biopharma__c = oCycleStandard.Assessment_Cycle_Time_Standard_for_Bioph__c;
            oStudy.EPCTM_DP1_DTA_for_Small_Molecule__c = 0;
            oStudy.EPCTM_DP1_DTA_for_Vaccine__c = 0;
        }
        else if(oStudy.Molecule_Classification__c == 'Vaccine'){
            if(oStudy.EPCTM_DP1_DTA_for_Vaccine__c != oCycleStandard.Assessment_Cycle_Time_Standard_for_Vacci__c){
                isUpdate = true;
            }
            oStudy.EPCTM_DP1_DTA_for_Vaccine__c = oCycleStandard.Assessment_Cycle_Time_Standard_for_Vacci__c;
            oStudy.EPCTM_DP1_DTA_for_Small_Molecule__c = 0;
            oStudy.EPCTM_DP1_DTA_for_Biopharma__c = 0;
        }
        if(isUpdate && oStudy.Id != NULL){
            update oStudy;
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
    
    Public PageReference copyField(){
        GenerationId = oStudy.Related_Generation_Project__c;
        DRDW_Project__c oGeneration = [Select Organizational_Unit__c,Project_Name__c,Molecule_Classification__c,Business_Unit__c,Functional_Area__c,Project_Health_new__c,Development_Team_Director__c,Simplified_Project_Name__c,Therapeutic_Area__c,Project_Type__c,Project_Source__c,Priority__c,Strategic_Alignment__c,Budget_Status__c,CMC_Strategy__c,Product_Type__c,Active_Ingredients__c,Indication__c,Route_of_Administration__c,Research_Project_Lead__c,Project_Description__c,Other_Simplified_Project_Name__c,Scientific_Hypothesis_Product_Concept__c,Lead_Finder__c,Project_Health__c,Decision_to_Assess_DTA_Actual_Date__c from DRDW_Project__c where id =: GenerationId LIMIT 1];
        //DRDW_Project__c oStudy = new DRDW_Project__c();
        oStudy.recordtypeid = getObjectRecordTypeId(DRDW_Project__c.SObjectType,'Assessment Project');
        oStudy.Organizational_Unit__c = oGeneration.Organizational_Unit__c;
        oStudy.Project_Name__c = oGeneration.Project_Name__c;
        oStudy.Molecule_Classification__c = oGeneration.Molecule_Classification__c;
        oStudy.Simplified_Project_Name__c = oGeneration.Simplified_Project_Name__c;
        oStudy.Therapeutic_Area__c = oGeneration.Therapeutic_Area__c;
        oStudy.Project_Type__c = oGeneration.Project_Type__c;
        oStudy.Project_Source__c = oGeneration.Project_Source__c;
        oStudy.Priority__c = oGeneration.Priority__c;
        oStudy.Strategic_Alignment__c = oGeneration.Strategic_Alignment__c;
        oStudy.Budget_Status__c = oGeneration.Budget_Status__c;
        oStudy.CMC_Strategy__c = oGeneration.CMC_Strategy__c;
        oStudy.Product_Type__c = oGeneration.Product_Type__c;
        oStudy.Active_Ingredients__c = oGeneration.Active_Ingredients__c;
        oStudy.Indication__c = oGeneration.Indication__c;
        oStudy.Route_of_Administration__c = oGeneration.Route_of_Administration__c;
        oStudy.Research_Project_Lead__c = oGeneration.Research_Project_Lead__c;
        oStudy.Lead_Finder__c = oGeneration.Lead_Finder__c;
        oStudy.Project_Health_new__c = oGeneration.Project_Health_new__c;
        oStudy.Related_Generation_Project__c = oGeneration.id;
        oStudy.Business_Unit__c = oGeneration.Business_Unit__c;
        oStudy.Functional_Area__c = oGeneration.Functional_Area__c;
        oStudy.Development_Team_Director__c = oGeneration.Development_Team_Director__c;
        oStudy.Project_Health_new__c = oGeneration.Project_Health_new__c;
        oStudy.Phase__c = 'Assessment';
        oStudy.Current_As_Of__c = System.today();
        oStudy.Decision_To_Assess_DTA__c = oGeneration.Decision_to_Assess_DTA_Actual_Date__c;
        oStudy.Project_Description__c = oGeneration.Project_Description__c;
        oStudy.Other_Simplified_Project_Name__c = oGeneration.Other_Simplified_Project_Name__c;
        oStudy.Scientific_Hypothesis_Product_Concept__c = oGeneration.Scientific_Hypothesis_Product_Concept__c;
        //insert oAssessment;
        PageReference pageref = new PageReference('/apex/DRDW_CreateAssessment');
        pageref.setredirect(false);
        return pageref;
    }   
    
    /*
    * @Method Name                    :  checkBudgstatus
    * @Description                    :  Method for checking budget status and setting the value accordingly
    * @Return Type                    :  void
    * @Parameters                     :  None
    */
    
    public void checkBudgstatus(){
        if(oStudy.Budget_Status__c != null && oStudy.Budget_Status__c == 'Not Funded'){
            oStudy.Business_Project_Status__c = 'Not Funded';
        }else if(oStudy.Budget_Status__c != null && oStudy.Budget_Status__c == 'Buy-Up'){
            oStudy.Business_Project_Status__c = 'Buy-Up';
        }
    }
    
    /*
    * @Method Name                    :  EditCreateExpRecord
    * @Description                    :  Method for creating a new Experiment
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

    Public Boolean getUserPermissionSM(Id UserID){
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
        if(oStudy.Business_Unit__c != null && groupBUAssigned != null){
            if(groupBUAssigned.contains(oStudy.Business_Unit__c)){
                isInBuGroup = true;
            }
        }
    }
}