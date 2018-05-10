Public without sharing Class DRDW_CreateBudgetLineItem{ 
    Public Id currentRecordID {get; set;}
    Public Id BudgetMasterId {get;set;}
    Public Boolean isAdmin{get;set;}
    Public Boolean isFin{get;set;}
    Public DRDW_Budget_Line_Item__c oLineItem{get;set;}
    Public string ParentName {get; set;}
    public Id PrjId {get; set;}
    public boolean isGen {get; set;}
    public boolean isEval {get; set;}
    public boolean isAssess {get; set;}
    Public DRDW_CreateBudgetLineItem(ApexPages.StandardController controller){
        currentRecordID = ApexPages.currentPage().getParameters().get('id');
        BudgetMasterId = ApexPages.currentPage().getParameters().get('BudgetId');
        oLineItem = (DRDW_Budget_Line_Item__c)controller.getRecord();
        DRDW_Budget_Master__c oBudget = new DRDW_Budget_Master__c();
        if(currentRecordID != null){   
            String SobjectApiName = 'DRDW_Budget_Line_Item__c';
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
            string query = 'select ' + commaSeparatedFields + ', Related_To__r.Title__c, Related_To__r.Related_To__r.Project_Name__c, Related_To__r.Related_To__r.Idea_Name__c' + ' from ' + SobjectApiName + ' where id =\'' + currentRecordID + '\' limit 1';
            oLineItem = Database.query(query);

            BudgetMasterId = oLineItem.Related_To__c;
            oBudget = [select id,PO__c,Activity_Name__c,Title__c,Activity__c,Vendorr__c,Related_To__r.RecordType.Name,Related_To__c from DRDW_Budget_Master__c where id =: BudgetMasterId Limit 1];
            if(oBudget.Related_To__r.RecordType.Name == 'Idea Project'){
                isEval = true;
            }else if(oBudget.Related_To__r.RecordType.Name == 'Generation Project'){
                isGen = true;
            }else if(oBudget.Related_To__r.RecordType.Name == 'Assessment Project'){
                isAssess = true;
            }
        }
        else{
            oBudget = [select id,PO__c,Activity_Name__c,Title__c,Activity__c,Vendorr__c,Related_To__r.RecordType.Name,Related_To__c from DRDW_Budget_Master__c where id =: BudgetMasterId Limit 1];
            if(oBudget.Related_To__r.RecordType.Name == 'Idea Project'){
                isEval = true;
            }
            else if(oBudget.Related_To__r.RecordType.Name == 'Generation Project'){
                isGen = true;
            }
            else if(oBudget.Related_To__r.RecordType.Name == 'Assessment Project'){
                isAssess = true;
            }

            ParentName = oBudget.Title__c;
            PrjId = oBudget.Related_To__c;
            oLineItem.PO__c = oBudget.PO__c;       
            if(oBudget.Activity__c != NULL){
                oLineItem.Activity__c = oBudget.Title__c;
            }
            oLineItem.Vendor__c = oBudget.Vendorr__c;
            oLineItem.Related_To__c = BudgetMasterId;
        }
        isAdmin = getUserPermission(UserInfo.getUserId());
        isFin = getUserPermissionFin(UserInfo.getUserId());
    }


    /*
    * @Method Name                    :  Save
    * @Description                    :  Method to Save the record
    * @Return Type                    :  None
    * @Parameters                     :  None
    */  

    Public PageReference save(){
        try{
            upsert oLineItem;
            PageReference pageref = new PageReference('/apex/DRDW_CreateBudgetMaster?id='+BudgetMasterId+'&isEdit=false&section=#Budget_Line');
            pageref.setredirect(true);
            return pageref;
        }
        catch(Exception e){
            if(e.getmessage().contains('FIELD_FILTER_VALIDATION_EXCEPTION')){
                ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot Create BudgetLineItem for Inactive CostCenter');
                ApexPages.addMessage(myMsg1);
                return null;
            }else {
                ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please check the posting date year, cannot be greater than current year and less than previous year');
                ApexPages.addMessage(myMsg1);
                return null;
            }
        }
    }

    /*
    * @Method Name                    :  Edit
    * @Description                    :  Method to Edit the record
    * @Return Type                    :  None
    * @Parameters                     :  None
    */  

    Public PageReference edit(){
        PageReference pageref = new PageReference('/apex/DRDW_CreateBudgetLineItem?id='+currentRecordID+'&isEdit=true');
        pageref.setredirect(true);
        return pageref;
    }

    Public PageReference DeleteRecord(){
        delete oLineItem;
        PageReference pageref = new PageReference('/apex/DRDW_CreateBudgetMaster?id='+budgetMasterId+'&isEdit=false');
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
}