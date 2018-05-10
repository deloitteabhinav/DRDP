Public with Sharing Class DRDW_Budget_Report{
    Public transient List<DRDW_Project__c> lProject{get;set;}
    Public transient Map<Id,List<DRDW_Budget_Summary_Detail__c>> mSummarySummaryDetails{get;set;}
    Public transient Map<Id, List<DRDW_Budget_Summary__c>> mMasterBudgetSummary{get;set;}
    Public transient Map<Id, List<DRDW_Budget_Master__c>> mrelatedBudMaster{get;set;}
    Public transient List<budgetProjWrapper> lbudgetProjWrapper{get;set;}
    Public transient Map<string,list<budgetProjWrapper>> mProjListProjBudgetWrapper{get;set;}
    Public transient List<Map<string,list<budgetProjWrapper>>> lProjListPOProjBudgetWrapper{get;set;}
    Public String jsonString{get;set;}
    Public transient DRDW_Cost_Center__c costcenterObj{get;set;}
    Public String selectedyear{get;set;}
    Public DRDW_Budget_Master__c bmObject{get;set;}
    Public Id costcenterid{get;set;}
    Public list<budgetSummaryWrapper> lBudSummaryWrapperEdit{get;set;}
    Public Boolean isAdmin{get;set;}
    Public Boolean isFin{get;set;}
    Public Boolean errorMsg{get;set;}
    //final Map : Key = Species,Value = List<Map< ProjectId, List<budgetdetails> > >
    Public Map<string,List<Map<string,list<budgetProjWrapper>>>> mSpeciesProjectBudgetWrapper{get;set;}
    
    Public void executeWrapperGenerator(){
        isAdmin = getUserPermission(UserInfo.getUserId());
        isFin = getUserPermissionFin(UserInfo.getUserId());
        costcenterid = ApexPages.currentPage().getParameters().get('costcenterid');
        costcenterObj = new DRDW_Cost_Center__c();
        costcenterObj = [Select Id,Name,Functional_Area__c,Status__c from DRDW_Cost_Center__c where id=:costcenterid limit 1];
        if(selectedyear == null){
            selectedyear = ApexPages.currentPage().getParameters().get('year');
        }
        queryDetails(selectedyear,costcenterid);
        WrapperGenerator(lProject, mSummarySummaryDetails, mMasterBudgetSummary, mrelatedBudMaster);
        jsonGenerator();
    }
    
    Public void WrapperGenerator(List<DRDW_Project__c> lProject,Map<Id,List<DRDW_Budget_Summary_Detail__c>> mSummarySummaryDetails,Map <Id, List<DRDW_Budget_Summary__c>> mMasterBudgetSummary,Map <Id, List<DRDW_Budget_Master__c>> mrelatedBudMaster){
        lProjListPOProjBudgetWrapper = new List<Map<string,list<budgetProjWrapper>>>();
        mSpeciesProjectBudgetWrapper = new Map<string,List<Map<string,list<budgetProjWrapper>>>>();
        for(DRDW_Project__c oProject : lProject){
            mProjListProjBudgetWrapper = new Map<string,list<budgetProjWrapper>>();            
            lbudgetProjWrapper = new list<budgetProjWrapper>(); 
            if(mrelatedBudMaster.containsKey(oProject.Id)){ 
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
                for(DRDW_Budget_Master__c oBudMaster: mrelatedBudMaster.get(oProject.Id)){
                    String activity;
                    string activityLink;
                    if(oBudMaster.Activity__c != null){
                        if(oBudMaster.Activity__r.recordtypeId == Schema.SObjectType.DRDW_Capability__c.getRecordTypeInfosByName().get('Request Activity').getRecordTypeId()){
                            activityLink = '/apex/DRDW_ViewActivity?id='+oBudMaster.Activity__c+'&isEdit=false';
                            activity = oBudMaster.Activity__r.Title__c;
                        }
                        else{
                            activityLink = '/apex/DRDW_CreateExternalActivity?id='+oBudMaster.Activity__c+'&isEdit=false';
                            activity = oBudMaster.Activity__r.Title_ex__c;                        
                        }
                    }
                    budgetMasterWrapper budgetMasterRecord = new budgetMasterWrapper(0,0,0,0,null);
                    budgetMasterWrapper Q1Record = new budgetMasterWrapper(0,0,0,0,new Map<String,Decimal>{'Jan' => 0,'Feb' => 0,'March' => 0});
                    budgetMasterWrapper Q2Record = new budgetMasterWrapper(0,0,0,0,new Map<String,Decimal>{'April' => 0,'May' => 0,'June' => 0});
                    budgetMasterWrapper Q3Record = new budgetMasterWrapper(0,0,0,0,new Map<String,Decimal>{'July' => 0,'Aug' => 0,'Sept' => 0});
                    budgetMasterWrapper Q4Record = new budgetMasterWrapper(0,0,0,0,new Map<String,Decimal>{'Oct' => 0,'Nov' => 0,'Dec' => 0});
                    budgetProjWrapper budgetProjRecord = new budgetProjWrapper(oProject.Id,projectLink,oProject.Name__c,oProject.Simplified_Project_Name__c,
                    oBudMaster.PO__C,oBudMaster.id,activity,activityLink,oBudMaster.Vendorr__c,oBudMaster.Scientist_Owner__r.Name,budgetMasterRecord, Q1Record, Q2Record, Q3Record, Q4Record);
                    Decimal actual = 0;                                       
                    if(mMasterBudgetSummary.containsKey(oBudMaster.Id)){
                        for(DRDW_Budget_Summary__c oBudSummary: mMasterBudgetSummary.get(oBudMaster.Id) ){
                            if(oBudSummary.Q_Total_Actuals__c != null){
                                budgetMasterRecord.totalActuals = budgetMasterRecord.totalActuals + oBudSummary.Q_Total_Actuals__c;
                            }
                            if(oBudSummary.Rolling_Forecast__c != null){
                                budgetMasterRecord.totalRollingForcast = budgetMasterRecord.totalRollingForcast + oBudSummary.Rolling_Forecast__c;
                            }
                            if(oBudSummary.F_X_Forecast__c != null){
                                budgetMasterRecord.totalFXForcast = budgetMasterRecord.totalFXForcast + oBudSummary.F_X_Forecast__c;
                            }
                            if(oBudSummary.Business_Plan__c != null){
                                budgetMasterRecord.totalBusinessPlan = budgetMasterRecord.totalBusinessPlan + oBudSummary.Business_Plan__c;
                            }
                            if(oBudSummary.Quarter__c == '1'){
                                if(oBudSummary.Q_Total_Actuals__c != null){
                                    Q1Record.totalActuals = Q1Record.totalActuals + oBudSummary.Q_Total_Actuals__c;
                                }
                                if(oBudSummary.Rolling_Forecast__c!= null){
                                    Q1Record.totalRollingForcast = Q1Record.totalRollingForcast + oBudSummary.Rolling_Forecast__c;
                                }
                                if(oBudSummary.F_X_Forecast__c != null){
                                    Q1Record.totalFXForcast = Q1Record.totalFXForcast + oBudSummary.F_X_Forecast__c;
                                }
                                if(oBudSummary.Business_Plan__c != null){
                                    Q1Record.totalBusinessPlan = Q1Record.totalBusinessPlan + oBudSummary.Business_Plan__c; 
                                }
                            }
                            if(oBudSummary.Quarter__c == '2'){
                                if(oBudSummary.Q_Total_Actuals__c != null){
                                    Q2Record.totalActuals = Q2Record.totalActuals + oBudSummary.Q_Total_Actuals__c;
                                }
                                if(oBudSummary.Rolling_Forecast__c!= null){
                                    Q2Record.totalRollingForcast = Q2Record.totalRollingForcast + oBudSummary.Rolling_Forecast__c;
                                }
                                if(oBudSummary.F_X_Forecast__c != null){
                                    Q2Record.totalFXForcast = Q2Record.totalFXForcast + oBudSummary.F_X_Forecast__c;
                                }
                                if(oBudSummary.Business_Plan__c != null){
                                    Q2Record.totalBusinessPlan = Q2Record.totalBusinessPlan + oBudSummary.Business_Plan__c; 
                                }
                            }
                            if(oBudSummary.Quarter__c == '3'){
                                if(oBudSummary.Q_Total_Actuals__c != null){
                                    Q3Record.totalActuals = Q3Record.totalActuals + oBudSummary.Q_Total_Actuals__c;
                                }
                                if(oBudSummary.Rolling_Forecast__c!= null){
                                    Q3Record.totalRollingForcast = Q3Record.totalRollingForcast + oBudSummary.Rolling_Forecast__c;
                                }
                                if(oBudSummary.F_X_Forecast__c != null){
                                    Q3Record.totalFXForcast = Q3Record.totalFXForcast + oBudSummary.F_X_Forecast__c;
                                }
                                if(oBudSummary.Business_Plan__c != null){
                                    Q3Record.totalBusinessPlan = Q3Record.totalBusinessPlan + oBudSummary.Business_Plan__c; 
                                }
                            }
                            if(oBudSummary.Quarter__c == '4'){
                                if(oBudSummary.Q_Total_Actuals__c != null){
                                    Q4Record.totalActuals = Q4Record.totalActuals + oBudSummary.Q_Total_Actuals__c;
                                }
                                if(oBudSummary.Rolling_Forecast__c!= null){
                                    Q4Record.totalRollingForcast = Q4Record.totalRollingForcast + oBudSummary.Rolling_Forecast__c;
                                }
                                if(oBudSummary.F_X_Forecast__c != null){
                                    Q4Record.totalFXForcast = Q4Record.totalFXForcast + oBudSummary.F_X_Forecast__c;
                                }
                                if(oBudSummary.Business_Plan__c != null){
                                    Q4Record.totalBusinessPlan = Q4Record.totalBusinessPlan + oBudSummary.Business_Plan__c; 
                                }
                            }
                            if(mSummarySummaryDetails.containsKey(oBudSummary.Id)){
                                for(DRDW_Budget_Summary_Detail__c oBudSummaryDetails: mSummarySummaryDetails.get(oBudSummary.Id) ){
                                    if(oBudSummaryDetails.M_Actual__c != null){
                                        if(oBudSummaryDetails.Quarter__c == '1'){
                                            if(oBudSummaryDetails.Month__c == 'Jan'){                                  
                                                actual = Q1Record.monthActualMap.get('Jan');
                                                Q1Record.monthActualMap.put('Jan',actual+oBudSummaryDetails.M_Actual__c);
                                            }
                                            if(oBudSummaryDetails.Month__c == 'Feb'){
                                                actual = Q1Record.monthActualMap.get('Feb');
                                                Q1Record.monthActualMap.put('Feb',actual+oBudSummaryDetails.M_Actual__c);
                                            }
                                            if(oBudSummaryDetails.Month__c == 'March'){
                                                actual = Q1Record.monthActualMap.get('March');
                                                Q1Record.monthActualMap.put('March',actual+oBudSummaryDetails.M_Actual__c); 
                                            }
                                        }
                                        if(oBudSummaryDetails.Quarter__c == '2'){  
                                            if(oBudSummaryDetails.Month__c == 'April'){
                                                actual = Q2Record.monthActualMap.get('April');
                                                Q2Record.monthActualMap.put('April',actual+oBudSummaryDetails.M_Actual__c);
                                            }
                                            if(oBudSummaryDetails.Month__c == 'May'){
                                                actual = Q2Record.monthActualMap.get('May');
                                                Q2Record.monthActualMap.put('May',actual+oBudSummaryDetails.M_Actual__c);
                                            }
                                            if(oBudSummaryDetails.Month__c == 'June'){
                                                actual = Q2Record.monthActualMap.get('June');
                                                Q2Record.monthActualMap.put('June',actual+oBudSummaryDetails.M_Actual__c);
                                            }
                                        }
                                        if(oBudSummaryDetails.Quarter__c == '3'){  
                                            if(oBudSummaryDetails.Month__c == 'July'){
                                                actual = Q3Record.monthActualMap.get('July');
                                                Q3Record.monthActualMap.put('July',actual+oBudSummaryDetails.M_Actual__c);
                                            }
                                            if(oBudSummaryDetails.Month__c == 'Aug'){
                                                actual = Q3Record.monthActualMap.get('Aug');
                                                Q3Record.monthActualMap.put('Aug',actual+oBudSummaryDetails.M_Actual__c);
                                            }
                                            if(oBudSummaryDetails.Month__c == 'Sept'){
                                                actual = Q3Record.monthActualMap.get('Sept');
                                                Q3Record.monthActualMap.put('Sept',actual+oBudSummaryDetails.M_Actual__c); 
                                            }
                                        }
                                        if(oBudSummaryDetails.Quarter__c == '4'){ 
                                            if(oBudSummaryDetails.Month__c == 'Oct'){                                   
                                                actual = Q4Record.monthActualMap.get('Oct');
                                                Q4Record.monthActualMap.put('Oct',actual+oBudSummaryDetails.M_Actual__c);
                                            }
                                            if(oBudSummaryDetails.Month__c == 'Nov'){
                                                actual = Q4Record.monthActualMap.get('Nov');
                                                Q4Record.monthActualMap.put('Nov',actual+oBudSummaryDetails.M_Actual__c);
                                            }
                                            if(oBudSummaryDetails.Month__c == 'Dec'){
                                                actual = Q4Record.monthActualMap.get('Dec');
                                                Q4Record.monthActualMap.put('Dec',actual+oBudSummaryDetails.M_Actual__c); 
                                            }
                                        }
                                    }
                                } 
                            }                       
                        }  
                    }
                    lbudgetProjWrapper.add(budgetProjRecord);                       
                }
            }
            mProjListProjBudgetWrapper.put(oProject.Id,lbudgetProjWrapper);
            if(oProject.Species__c != null && mSpeciesProjectBudgetWrapper.containsKey(oProject.Species__c)){
                lProjListPOProjBudgetWrapper = mSpeciesProjectBudgetWrapper.get(oProject.Species__c);
                lProjListPOProjBudgetWrapper.add(mProjListProjBudgetWrapper);
                mSpeciesProjectBudgetWrapper.put(oProject.Species__c,lProjListPOProjBudgetWrapper);
            }
            else{
                if(oProject.Species__c == null){
                    oProject.Species__c = 'Non-species';
                }
                //if(oProject.Species__c != null){
                lProjListPOProjBudgetWrapper = new List<Map<string,list<budgetProjWrapper>>>();
                lProjListPOProjBudgetWrapper.add(mProjListProjBudgetWrapper);
                mSpeciesProjectBudgetWrapper.put(oProject.Species__c,lProjListPOProjBudgetWrapper);
                //}
            }
        }
    }
    
    //Wrapper Structure for Project Table
    Public class budgetProjWrapper{
        Public ID researchId{get;set;}
        Public String projectLink{get;set;}
        Public String researchName{get;set;}
        Public String simplifiedProjectName{get;set;}
        Public String PO{get;set;}
        Public ID budgetMasterId{get;set;}
        Public String activityNameTittle{get;set;}
        Public String activityLink{get;set;}
        Public String vendor{get;set;}
        Public String scientistOwner{get;set;}
        Public budgetMasterWrapper BMRecord{get;set;}
        Public budgetMasterWrapper Q1{get;set;}
        Public budgetMasterWrapper Q2{get;set;}
        Public budgetMasterWrapper Q3{get;set;}
        Public budgetMasterWrapper Q4{get;set;}
        Public budgetProjWrapper(ID researchId,String projectLink,String researchName,String simplifiedProjectName,String PO,ID budgetMasterId,String activityNameTittle, string activityLink,
        String vendor,String scientistOwner,budgetMasterWrapper BMRecord,budgetMasterWrapper Q1,budgetMasterWrapper Q2,budgetMasterWrapper Q3,budgetMasterWrapper Q4){
            this.projectLink = projectLink;
            this.researchId = researchId ;
            this.researchName = researchName ;
            this.simplifiedProjectName = simplifiedProjectName ;
            this.PO = PO;
            this.budgetMasterId = budgetMasterId;
            this.activityNameTittle = activityNameTittle ;
            this.activityLink = activityLink;
            this.vendor = vendor ;
            this.scientistOwner = scientistOwner;
            this.BMRecord = BMRecord ;
            this.Q1 = Q1 ;
            this.Q2 = Q2 ;
            this.Q3 = Q3 ;
            this.Q4 = Q4 ;
        }
    }  
    
    //Wrapper Structure for BM Table
    Public class budgetMasterWrapper{
        Public Decimal totalActuals{get;set;}
        Public Decimal totalRollingForcast{get;set;}
        Public Decimal totalFXForcast{get;set;}
        Public Decimal totalBusinessPlan{get;set;}
        Public Map<String,Decimal> monthActualMap{get;set;}
        Public budgetMasterWrapper(Decimal totalActuals,Decimal totalRollingForcast,
        Decimal totalFXForcast,Decimal totalBusinessPlan,Map<String,Decimal> monthActualMap){            
            this.totalActuals = totalActuals ;
            this.totalRollingForcast = totalRollingForcast ;
            this.totalFXForcast = totalFXForcast ;
            this.totalBusinessPlan = totalBusinessPlan ;
            this.monthActualMap = monthActualMap ;
        }    
    }
    
    public List<SelectOption> getYearList() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = DRDW_Budget_Summary__c.Year__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            options.add(new SelectOption(pickListVal.getLabel(),pickListVal.getLabel()));
        }
        return options; 
    }
    
    //query all the records required for the report
    Public void queryDetails(String year, Id costcenterId){
        lProject = new List<DRDW_Project__c>();
        mSummarySummaryDetails = new Map<Id,List<DRDW_Budget_Summary_Detail__c>>();
        mMasterBudgetSummary = new Map<Id, List<DRDW_Budget_Summary__c>>();
        mrelatedBudMaster = new Map<Id, List<DRDW_Budget_Master__c>>();
        set<Id> projIds = new set<Id>();
        set<Id> budgetMasterIds = new set<Id>();
        set<Id> summaryIds = new set<Id>();
        //query all the related budgetsummary and for a current year
        list<DRDW_Budget_Summary__c> lBudSummary = [Select Id,Name,DRDW_Budget_Master__c,Q_Total_Actuals__c,Rolling_Forecast__c,F_X_Forecast__c,
        Business_Plan__c,Quarter__c from DRDW_Budget_Summary__c where DRDW_Budget_Master__r.Cost_Center__c =: costcenterId and Year__c =: year];
        //to create map of (masterid, lsit of summary), set of summary's
        for(DRDW_Budget_Summary__c oBudSummary : lBudSummary){
            List<DRDW_Budget_Summary__c> lBudgetSummary;
            summaryIds.add(oBudSummary.Id);
            budgetMasterIds.add(oBudSummary.DRDW_Budget_Master__c);
            if(mMasterBudgetSummary.containsKey(oBudSummary.DRDW_Budget_Master__c)){
                lBudgetSummary = mMasterBudgetSummary.get(oBudSummary.DRDW_Budget_Master__c);
                lBudgetSummary.add(oBudSummary);
                mMasterBudgetSummary.put(oBudSummary.DRDW_Budget_Master__c,lBudgetSummary);
            }
            else{
                lBudgetSummary = new List<DRDW_Budget_Summary__c>();
                lBudgetSummary.add(oBudSummary);
                mMasterBudgetSummary.put(oBudSummary.DRDW_Budget_Master__c,lBudgetSummary);                
            }
        }
        //query all the related budget summary details and current year
        list<DRDW_Budget_Summary_Detail__c> lBudSummaryDetails = [Select Id,Name,DRDW_Budget_Summary__c,M_Actual__c,Month__c,Quarter__c
        from DRDW_Budget_Summary_Detail__c where DRDW_Budget_Summary__c in: summaryIds and Year__c =: year];
        //to create map of summary id and list of summary details
        for(DRDW_Budget_Summary_Detail__c oBudSummaryDetails : lBudSummaryDetails){
            List<DRDW_Budget_Summary_Detail__c> lBudgetSummaryDetails;
            if(mSummarySummaryDetails.containsKey(oBudSummaryDetails.DRDW_Budget_Summary__c)){
                lBudgetSummaryDetails = mSummarySummaryDetails.get(oBudSummaryDetails.DRDW_Budget_Summary__c);
                lBudgetSummaryDetails.add(oBudSummaryDetails);
                mSummarySummaryDetails.put(oBudSummaryDetails.DRDW_Budget_Summary__c,lBudgetSummaryDetails);
            }
            else{
                lBudgetSummaryDetails = new List<DRDW_Budget_Summary_Detail__c>();
                lBudgetSummaryDetails.add(oBudSummaryDetails);
                mSummarySummaryDetails.put(oBudSummaryDetails.DRDW_Budget_Summary__c,lBudgetSummaryDetails);                
            }
        }
        //query budget master records related to a particular costcenter
        list<DRDW_Budget_Master__c> lBudMaster = [Select Id,Name,Related_To__c,Activity__c,Activity__r.RecordtypeId,Activity__r.Title_ex__c,Activity__r.Title__c,PO__C,Vendorr__c,Scientist_Owner__r.Name from DRDW_Budget_Master__c where Cost_Center__c =: costcenterId and Id in : budgetMasterIds];
        //to create set of associated projects,budgetmasters and Map of (projId,budgetmasterlist)
        for(DRDW_Budget_Master__c oBudMaster : lBudMaster){
            List<DRDW_Budget_Master__c> lBudgetMaster;
            projIds.add(oBudMaster.Related_To__c);
            if(mrelatedBudMaster.containsKey(oBudMaster.Related_To__c)){
                lBudgetMaster = mrelatedBudMaster.get(oBudMaster.Related_To__c);
                lBudgetMaster.add(oBudMaster);
                mrelatedBudMaster.put(oBudMaster.Related_To__c,lBudgetMaster);
            }
            else{
                lBudgetMaster = new List<DRDW_Budget_Master__c>();
                lBudgetMaster.add(oBudMaster);
                mrelatedBudMaster.put(oBudMaster.Related_To__c,lBudgetMaster);                
            }
        }
        //query all the related projects
        lProject = [Select Id,Name__c,Simplified_Project_Name__c,Species__c,recordtype.name from DRDW_Project__c where Id in: projIds];
    }
    
    //json generator
    public void jsonGenerator(){
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();
        for(String specie : mSpeciesProjectBudgetWrapper.keySet()){
            gen.writeStartObject();
            if(specie == null){            
                gen.writeStringField('Species', 'Non-species');
            }
            else{
                gen.writeStringField('Species', specie);
            }
            gen.writeFieldName('List Of projects');
            gen.writeStartArray();
            for(Map<string,list<budgetProjWrapper>> mapOfProject  : mSpeciesProjectBudgetWrapper.get(specie)){
                //gen.writeStartObject();
                for(Id projId : mapOfProject.keySet()){
                    gen.writeStartObject();
                    gen.writeFieldName('PO');
                    gen.writeStartArray();
                    for(budgetProjWrapper budgetWrapper : mapOfProject.get(projId)){
                        gen.writeStartObject();
                        gen.writeFieldName('budgetWrapper');
                        gen.writeObject(budgetWrapper);
                        gen.writeEndObject();
                    }
                    gen.writeEndArray();
                    gen.writeEndObject();
                }                
                //gen.writeEndObject();
            }
            gen.writeEndArray();
            gen.writeEndObject();
        }
        gen.writeEndArray();
        // Get the JSON string.
        jsonString = gen.getAsString();
        jsonString = jsonString.replace('null','""');
    }
    
    //edit report summary query 
    Public void queryDetailsForEdit(){
        string BMId = Apexpages.currentPage().getParameters().get('BMId');//'aIG6E0000004CMRWA2';
        String yearEdit = Apexpages.currentPage().getParameters().get('yearEdit');
        system.debug('BMId'+BMId);
        system.debug('yearEdit'+yearEdit);
        set<Id> budgetMasterIds = new set<Id>();
        //query budget master records related to a particular costcenter
        list<DRDW_Budget_Master__c> lBudMaster = [Select Id,Name,Related_To__c,Activity__c,Cost_Center__c,Activity__r.Name,PO__C,Vendorr__c,Scientist_Owner__r.Name from DRDW_Budget_Master__c where id =: BMId limit 1];
        if(lBudMaster != null && lBudMaster.size() >0){
            bmObject = lBudMaster[0];
        }
        //query all the related budgetsummary and for a current year
        list<DRDW_Budget_Summary__c> lBudSummaryEdit = new list<DRDW_Budget_Summary__c>();
        lBudSummaryEdit = [Select Id,Name,DRDW_Budget_Master__c,Q_Total_Actuals__c,Rolling_Forecast__c,F_X_Forecast__c,
        Business_Plan__c,Quarter__c,Year__c,DRDW_Budget_Master__r.Cost_Center__c from DRDW_Budget_Summary__c where DRDW_Budget_Master__c =: BMId and Year__c =: yearEdit limit 10];    
        system.debug('lBudSummaryEdit'+lBudSummaryEdit);
        lBudSummaryWrapperEdit = new List<budgetSummaryWrapper>();
        budgetSummaryWrapper budSummaryObjWrapper;
        for(DRDW_Budget_Summary__c obudgSummary : lBudSummaryEdit ){ 
            budSummaryObjWrapper = new budgetSummaryWrapper(updateForcastEdit(obudgSummary),obudgSummary);  
            lBudSummaryWrapperEdit.add(budSummaryObjWrapper);          
        }
    }
    
    Public PageReference save(){
        try{
            List<DRDW_Budget_Summary__c> lbudSummary = new List<DRDW_Budget_Summary__c>();
            //Rounding currency values
            for(budgetSummaryWrapper oSummaryWrapper : lBudSummaryWrapperEdit){
                if (oSummaryWrapper.budgetSummaryObject.Rolling_Forecast__c != null) oSummaryWrapper.budgetSummaryObject.Rolling_Forecast__c = oSummaryWrapper.budgetSummaryObject.Rolling_Forecast__c.round(System.RoundingMode.HALF_EVEN);
                if (oSummaryWrapper.budgetSummaryObject.Business_Plan__c != null)oSummaryWrapper.budgetSummaryObject.Business_Plan__c = oSummaryWrapper.budgetSummaryObject.Business_Plan__c.round(System.RoundingMode.HALF_EVEN);
                if (oSummaryWrapper.budgetSummaryObject.F_X_Forecast__c != null)oSummaryWrapper.budgetSummaryObject.F_X_Forecast__c = oSummaryWrapper.budgetSummaryObject.F_X_Forecast__c.round(System.RoundingMode.HALF_EVEN);
                if (oSummaryWrapper.budgetSummaryObject.Q_Rolling_Forecast__c != null)oSummaryWrapper.budgetSummaryObject.Q_Rolling_Forecast__c = oSummaryWrapper.budgetSummaryObject.Q_Rolling_Forecast__c.round(System.RoundingMode.HALF_EVEN);
                lbudSummary.add(oSummaryWrapper.budgetSummaryObject);
            }
            update lbudSummary;
            update bmObject;
            PageReference pageref = null;
            pageref = new PageReference('/apex/DRDW_BudgetCostCenterReport?costcenterid='+costcenterid+'&year='+selectedyear);
            pageref.setredirect(true);
            return pageref;
        }
        catch(Exception e){
            errorMsg = true;
            system.debug('errorMsg'+e.getmessage());
            addError(e.getmessage());
            return null;
        }
    }
    
    public void addError(string s) {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, s);
        ApexPages.addMessage(myMsg);
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
            system.debug('inside admin');
            return true;
        }
        return false;
    }   
    
    Public Boolean getUserPermissionFin(Id UserID){
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserID AND PermissionSet.Name = 'DRDW_Financial_User']);
        Set<Id> lUserId = new Set<Id>();
        If(!lPermission.isEmpty()){
            For(PermissionSetAssignment p : lPermission){
                system.debug('inside fin');
                lUserId.add(p.Assignee.Id);
            }
        }
        If(lUserId.Contains(UserID)){
            return true;
        }
        return false;
    } 
    
    Public boolean updateForcastEdit(DRDW_Budget_Summary__c oSummary){
        Boolean forecateEdit = false;
        if(oSummary.Quarter__c != null && oSummary.year__c != null){
            Integer Month = 1;
            if(oSummary.Quarter__c == '1'){
                Month = 1;
            }
            else if(oSummary.Quarter__c == '2'){
                Month = 4;
            }
            else if(oSummary.Quarter__c == '3'){
                Month = 7;
            }
            else if(oSummary.Quarter__c == '4'){
                Month = 10;
            }
            Date currentDate = Date.newInstance(system.today().year(), system.today().month(), 01);
            Date objectDate = Date.newInstance(integer.ValueOf(oSummary.year__c), Month, 01);
            system.debug('currentDate'+currentDate);
            system.debug('objectDate'+objectDate);
            if(currentDate < objectDate){
                forecateEdit = true;
                system.debug('in loop');
            }
        }
        return forecateEdit;
    }  
    
    //Wrapper Structure for Summary Modal Popup Table
    Public class budgetSummaryWrapper{
        Public Boolean forecateEdit{get;set;}
        Public DRDW_Budget_Summary__c budgetSummaryObject{get;set;}
        Public budgetSummaryWrapper(Boolean forecateEdit,DRDW_Budget_Summary__c budgetSummaryObject){            
            this.forecateEdit = forecateEdit ;
            this.budgetSummaryObject = budgetSummaryObject;
        }    
    }
}