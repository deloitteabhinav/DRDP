Public without sharing Class DRDW_CostCenter{ 

    Public DRDW_Cost_Center__c oCost{get;set;}
    Public Id currentRecordID {get; set;}
    Public List<DRDW_Cost_Center__c> costcntrlist {get; set;}
    public List<DRDW_ND_Budget_Master__c> lMasters{get;set;}
    Public Boolean isAdmin{get;set;}
    public id LinkID {get; set;}
    public String selectedCostcntr {get; set;}

    Public DRDW_CostCenter(ApexPages.StandardController controller){
        oCost = (DRDW_Cost_Center__c)controller.getRecord();
        costcntrlist = [select Id, Name from DRDW_Cost_Center__c Where Status__c = 'Active'];
        system.debug('List of cost centers&&&&&&&'+costcntrlist);
        currentRecordID = ApexPages.currentPage().getParameters().get('id');
        if(currentRecordID != null){
            String SobjectApiName = 'DRDW_Cost_Center__c';
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
            oCost = Database.query(query);
            lMasters = [select id,Name,Year__c from DRDW_ND_Budget_Master__c];
        }
        isAdmin = getUserPermission(UserInfo.getUserId());
    }

    /*
    * @Method Name                    :  getCostcenters
    * @Description                    :  Method to retrieve all the costcenters and display them in a picklist
    * @Return Type                    :  List<SelectOption>
    * @Parameters                     :  void
    */   
    public List<SelectOption> getCostcenters() {
        List<SelectOption> options = new List<SelectOption>();
        Options.add(new SelectOption('','Select Cost Center'));
        for (DRDW_Cost_center__c tempcst : costcntrlist) {
            options.add(new SelectOption(tempcst.Id, tempcst.Name));
        }
        return options;
    }
    /*
    * @Method Name                    :  RedirectCostcenter
    * @Description                    :  Redirect
    * @Return Type                    :  List<SelectOption>
    * @Parameters                     :  void
    */  

    Public PageReference RedirectCostcenter(){
        System.debug('Selected cost center &&&&&'+selectedCostcntr);
        PageReference pageref = new PageReference('/apex/DRDW_CostCenter?id='+selectedCostcntr+'&isEdit=false');
        pageref.setredirect(true);
        return pageref;
    }
    
    Public PageReference save(){
        if(currentRecordID != null){
            Update oCost;
        }
        else{
            insert oCost;
            List<DRDW_ND_Budget_Master__c> lNDMasters = new List<DRDW_ND_Budget_Master__c>();
            lNDMasters = [select id from DRDW_ND_Budget_Master__c];
            List<DRDW_ND_Budget_Detail__c> lDetails = new List<DRDW_ND_Budget_Detail__c>();
            if(!lNDMasters.isEmpty()){
                for(DRDW_ND_Budget_Master__c b:lNDMasters){
                    DRDW_ND_Budget_Detail__c detail = new DRDW_ND_Budget_Detail__c();
                    detail.DRDW_Cost_Center__c = oCost.id;
                    detail.DRDW_ND_Budget_Master__c = b.id;
                    detail.CurrencyIsoCode = Label.DRDW_Currency_Label;
                    lDetails.add(detail);
                }
                if(!lDetails.isEmpty()){
                    insert lDetails;
                }
            }
            lDetails = [select id,Year__c from DRDW_ND_Budget_Detail__c where DRDW_Cost_Center__c =:oCost.id];
            Schema.DescribeFieldResult fieldResult = DRDW_NDBM_Category__c.Category__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            List<DRDW_NDBD_Category__c> lDcategory = new List<DRDW_NDBD_Category__c>();
            for(DRDW_ND_Budget_Detail__c detail:lDetails){
                for(Schema.PicklistEntry f:ple){
                    DRDW_NDBD_Category__c c = new DRDW_NDBD_Category__c();
                    c.Category__c = f.getValue();
                    c.Year__c = detail.Year__c;
                    c.DRDW_ND_Budget_Detail__c = detail.id;
                    c.CurrencyIsoCode = Label.DRDW_Currency_Label;
                    lDcategory.add(c);
                }
            }
            if(!lDcategory.isEmpty()){
                insert lDcategory;
                system.debug('*****DCategory*****'+lDcategory);
            }
        }
        PageReference pageref = new PageReference('/apex/DRDW_CostCenter?id='+oCost.Id+'&isEdit=false');
        pageref.setredirect(true);
        return pageref;
    }

    Public PageReference edit(){
        PageReference pageref = new PageReference('/apex/DRDW_CostCenter?id='+currentRecordID+'&isEdit=true');
        pageref.setredirect(true);
        return pageref;
    }
    
    Public PageReference DeleteRecord(){
        delete oCost;
        PageReference pageref = new PageReference('/apex/DRDW_CostCenterinfo');
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

    Public PageReference copyField(){
        String costId = oCost.Cost_Center__c;
        system.debug('costid'+costId);
        PageReference pageref = new PageReference('/apex/DRDW_CostCenter?id='+costId);
        pageref.setredirect(true);
        return pageref;
    }

    public PageReference BudgetLink(){
        pagereference pageref = new pagereference('/apex/DRDW_CreateNDBudgetMaster?id='+LinkID+'&isEdit=false');
        pageref.setredirect(true);
        return pageref;
    }
}