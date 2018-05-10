Public without sharing Class DRDW_CreateNDBudgetDetail{ 
    
    Public DRDW_ND_Budget_Detail__c obmCat {get;set;}
    Public List<DRDW_NDBD_Category__c> ldCategory{get;set;}
    Public Id currentRecordID {get; set;}
    Public Boolean isAdmin{get;set;}
    Public Boolean isAccess{get;set;}
    Public Boolean isLeader{get;set;}
    Public Boolean isFin{get;set;}
    public id LinkID1 {get; set;}
    public String costcentername{get;set;}

    
    Public DRDW_CreateNDBudgetDetail(ApexPages.StandardController controller){
        obmCat = (DRDW_ND_Budget_Detail__c)controller.getRecord();
        currentRecordID = ApexPages.currentPage().getParameters().get('id');
      
        
      if(currentRecordID != null){
      
            String SobjectApiName = 'DRDW_ND_Budget_Detail__c';
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
           
           DRDW_Cost_Center__c c = [select id,name from DRDW_Cost_Center__C where id=:obmCat.DRDW_Cost_Center__c];
           
           costcentername = c.name;

            ldCategory = [select id,Name,Category__c,Non_Discretionary_Year_Total__c,Q1__c,Q2__c,Q3__c,Q4__c from DRDW_NDBD_Category__c where Year__c =: obmCat.Year__c and DRDW_ND_Budget_Detail__c =: obmCat.id];
           
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
    
       
        
        upsert obmCat;
            
            
        
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
    
    public PageReference CategoryLink(){
        pagereference pageref = new pagereference('/apex/DRDW_CreateNDBudgetDetailCategory?id='+ldCategory[0].Id+'&isEdit=false');
        pageref.setredirect(true);
        return pageref;
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
    
    public Void updateDCategory(){
    
        update ldCategory;
          ldCategory = [select id,Name,Category__c,Non_Discretionary_Year_Total__c,Q1__c,Q2__c,Q3__c,Q4__c from DRDW_NDBD_Category__c where Year__c =: obmCat.Year__c and DRDW_ND_Budget_Detail__c =: obmCat.id];
        
    }
    
     public Void ResetDCategory(){
    
        
         ldCategory = [select id,Name,Category__c,Non_Discretionary_Year_Total__c,Q1__c,Q2__c,Q3__c,Q4__c from DRDW_NDBD_Category__c where Year__c =: obmCat.Year__c and DRDW_ND_Budget_Detail__c =: obmCat.id];
        
    }
    
}