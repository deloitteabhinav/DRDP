Public without sharing Class DRDW_CreateNDBudgetMaster{ 
    
    Public DRDW_ND_Budget_Master__c obmCat {get;set;}
    Public Id currentRecordID {get; set;}
    Public Boolean isAdmin{get;set;}
    Public Boolean isAccess{get;set;}
    Public Boolean isLeader{get;set;}
    Public Boolean isFin{get;set;}
    public List<DRDW_ND_Budget_Detail__c> lDetails{get;set;}
    Public List<DRDW_NDBM_Category__c> lCategory{get;set;}
     public id LinkID {get; set;}
      public id LinkID1 {get; set;}
    
    Public DRDW_CreateNDBudgetMaster(ApexPages.StandardController controller){
        obmCat = (DRDW_ND_Budget_Master__c)controller.getRecord();
        currentRecordID = ApexPages.currentPage().getParameters().get('id');
      
        
      if(currentRecordID != null){
      
            String SobjectApiName = 'DRDW_ND_Budget_Master__c';
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
           obmCat = Database.query(query);
            
           lDetails = [select id,Name,Year__c,DRDW_Cost_Center__r.Name,DRDW_Cost_Center__c from DRDW_ND_Budget_Detail__c where year__c =: obmCat.Year__c and DRDW_ND_Budget_Master__c =:obmCat.id];
           lCategory = [select id,Name,Category__c,Non_Discretionary_Year_Total__c,Q1__c,Q2__c,Q3__c,Q4__c from DRDW_NDBM_Category__c where Year__c =: obmCat.Year__c and DRDW_ND_Budget_Master__c =: obmCat.id];
        
           
           }
           else{
                obmCat.Year__c = String.valueOf(system.today().Year()); 
           }
           
        system.debug('&&&&&&&'+UserInfo.getUserId());   
       isAdmin = getUserPermission(UserInfo.getUserId());
       isFin = getUserPermissionFin(UserInfo.getUserId());
       SObjectType sObjectType = Schema.getGlobalDescribe().get('DRDW_NDBM_Category__c');
       isAccess = HasAccess(UserInfo.getUserId(), obmCat.Id);
       isLeader = getUserPermissionLeader(UserInfo.getUserId()); 
        
    }
    
    /*
     * @Method Name                    :  Save
     * @Description                    :  Method to Save the record
     * @Return Type                    :  None
     * @Parameters                     :  None
     */  
    
    Public PageReference save(){
    
        List<DRDW_ND_Budget_Master__c> lNDBMaster = new List<DRDW_ND_Budget_Master__c>();
        lNDBMaster = [select id,Year__c from DRDW_ND_Budget_Master__c];
        
        Set<String> SetCategory = new Set<String>();
        for(DRDW_ND_Budget_Master__c c:lNDBMaster){
        
            SetCategory.add(c.Year__c);
        }       
        
             if(SetCategory.contains(obmCat.Year__c)){
        
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'A record for the selected Year already exists.');
            ApexPages.addMessage(myMsg1);
            return null;
        } 
        
        obmCat.CurrencyIsoCode = Label.DRDW_Currency_Label;
        
        insert obmCat;
            
        List<DRDW_Cost_Center__c> lCostCenters = new List<DRDW_Cost_Center__c>();
        lCostCenters = [select id from DRDW_Cost_Center__c];
        
        List<DRDW_ND_Budget_Detail__c> lDetails = new List<DRDW_ND_Budget_Detail__c>();
        
        
        if(!lCostCenters.isEmpty()){
            
            for(DRDW_Cost_Center__c c:lCostCenters){
                DRDW_ND_Budget_Detail__c detail = new DRDW_ND_Budget_Detail__c();
                detail.DRDW_Cost_Center__c = c.id;
                detail.DRDW_ND_Budget_Master__c = obmCat.id;
                detail.CurrencyIsoCode = Label.DRDW_Currency_Label;
                lDetails.add(detail);
                
            }
            
            if(!lDetails.isEmpty()){
                insert lDetails;
            }
        }
        
        Schema.DescribeFieldResult fieldResult = DRDW_NDBM_Category__c.Category__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        List<DRDW_NDBM_Category__c> lMcategory = new List<DRDW_NDBM_Category__c>();
        List<DRDW_NDBD_Category__c> lDcategory = new List<DRDW_NDBD_Category__c>();
        
        for(Schema.PicklistEntry f:ple){
        DRDW_NDBM_Category__c c = new DRDW_NDBM_Category__c();
        c.Category__c = f.getValue();
        c.Year__c = obmCat.Year__c;
        c.DRDW_ND_Budget_Master__c = obmCat.id;
        c.CurrencyIsoCode = Label.DRDW_Currency_Label;
        lMcategory.add(c);
        
        }
        
         if(!lMcategory.isEmpty()){
                insert lMcategory;
        }
        
        for(DRDW_ND_Budget_Detail__c detail:lDetails){
        for(Schema.PicklistEntry f:ple){
        DRDW_NDBD_Category__c c = new DRDW_NDBD_Category__c();
        c.Category__c = f.getValue();
        c.Year__c = obmCat.Year__c;
      
        c.DRDW_ND_Budget_Detail__c = detail.id;
        c.CurrencyIsoCode = Label.DRDW_Currency_Label;
        lDcategory.add(c);
        
        }
        }
        
        if(!lDcategory.isEmpty()){
                insert lDcategory;
        }
        
        PageReference pageref = new PageReference('/apex/DRDW_CreateNDBudgetMaster?id='+obmCat.Id+'&isEdit=false');
          pageref.setredirect(true);
          return pageref;
    }
    
    /*
     * @Method Name                    :  Edit
     * @Description                    :  Method to Edit the record
     * @Return Type                    :  None
     * @Parameters                     :  None
     */  
    
    Public PageReference edit(){
        PageReference pageref = new PageReference('/apex/DRDW_CreateNDBudgetMaster?id='+currentRecordID+'&isEdit=true');
          pageref.setredirect(true);
          return pageref;
    }
    
    public void DeleteRecord(){
    
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
    
        public PageReference DetailLink(){
        pagereference pageref = new pagereference('/apex/DRDW_CreateNDBudgetDetail?id='+LinkID+'&isEdit=false');
        pageref.setredirect(true);
        return pageref;
    }
    
        public PageReference CategoryLink(){
        pagereference pageref = new pagereference('/apex/DRDW_CreateNDBudgetCategory?id='+LinkID1+'&isEdit=false');
        pageref.setredirect(true);
        return pageref;
    }
    
     Public PageReference AddCategory() {
        
        PageReference pageref = new PageReference('/apex/DRDW_CreateNDBudgetCategory?parentid='+currentRecordID);
        pageref.setredirect(true);
        return pageref;
        
    }   
    
    public Void updateMCategory(){
    
        update lCategory;
        lCategory = [select id,Name,Category__c,Non_Discretionary_Year_Total__c,Q1__c,Q2__c,Q3__c,Q4__c from DRDW_NDBM_Category__c where Year__c =: obmCat.Year__c and DRDW_ND_Budget_Master__c =: obmCat.id];
        
    }
    
     public Void ResetMCategory(){
    
        
        lCategory = [select id,Name,Category__c,Non_Discretionary_Year_Total__c,Q1__c,Q2__c,Q3__c,Q4__c from DRDW_NDBM_Category__c where Year__c =: obmCat.Year__c and DRDW_ND_Budget_Master__c =: obmCat.id];
        
    }
    
}