public class DRDW_CreateExternalActivity {

 public DRDW_Capability__c oActivity{get;set;}

 public id currentRecordID{get;set;}
   public boolean isIdea{get;set;}
  public boolean isGeneration{get;set;}
  public boolean isAssessment{get;set;}
  public String projectName{get;set;}
 
 public id genericID {get; set;}
 public id ideaId{get;set;}
 public String ideaName{get;set;}
 public String dte{get;set;}
  Public Boolean isAdmin{get;set;}
    Public Boolean isFin{get;set;}  
    Public Boolean isAccess{get;set;}  
  Public String CapabilityArea{get;set;}
  Public List<SelectOption> lCapabilityPicklist{get;set;}
 Public List<SelectOption> lAreaPicklist{get;set;}
  public id LinkID2 {get; set;}
    public boolean isbError {get; set;}
    
     public List<DRDW_Budget_Master__c> lbudgets {get; set;}
     public Decimal totalforecast{get;set;}

public DRDW_CreateExternalActivity(ApexPages.StandardController controller) {

     oActivity = (DRDW_Capability__c)controller.getRecord();
    currentRecordID = ApexPages.currentPage().getParameters().get('id');
   
     isAdmin = getUserPermission(UserInfo.getUserId());
     isAccess = HasAccess(UserInfo.getUserId(), oActivity.Id);
     isFin = getUserPermissionFin(UserInfo.getUserId());
     
   
      if(currentRecordID != null){
          
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

            string query = 'select ' + commaSeparatedFields + ',Related_Project__r.Name__c' + ' from ' + SobjectApiName + ' where id =\'' + currentRecordID + '\' limit 1';
            oActivity = Database.query(query);
                       
                       
                lbudgets = [Select id,Name ,Titletab__c,Scientist_Owner__c,Title__c,PO__c,Activity_Name__c,Vendorr__c,Total_Contract_Value__c,Total_Actuals__c,Cost_Center__r.Name from DRDW_Budget_Master__c where Activity__c =: currentRecordID];
            
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
                }else if(lstsummaries.size() == 1){
                    totalforecast = lstsummaries[0].F_X_Forecast__c.round(System.RoundingMode.HALF_EVEN);
                }
              
            Drdw_Project__c oProject = [select id,Name,Name__c,Idea_Name__c,Project_Name__c, New_Idea_Name__c ,Recordtype.Name from Drdw_Project__c where id=:oActivity.Related_Project__c ];
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
          
      }else{
          
          
      }
    
}

 /*
    * @Method Name                    :  saveExperiment
    * @Description                    :  Method to save Existing Experiment
    * @Return Type                    :  void
    * @Parameters                     :  None
    */
  
   public PageReference save(){
      
       pagereference pageref;
       
      
           
           if(currentRecordID == NULL){
               
              
              try{ 
               oActivity.recordtypeid = getObjectRecordTypeId(DRDW_Capability__c.SObjectType,'External Activity');
               insert oActivity;
               
               List<Id> parentIds = new List<Id>();
               parentIds.add(oActivity.Related_Project__c);
               DRDW_RecordSharing.getRecordIdShare(parentIds,true,true);
               
                if(!Hasaccess(UserInfo.getUserId(), oActivity.Id)){
             
                 pageref = new PageReference('/apex/DRDW_NoAccess');
                 pageref.setredirect(true);
                 return pageref;
                
             }
               
                pageref = new pagereference('/apex/DRDW_CreateIdea?id=' +ideaid+'&isEdit=false');
              pageref.setredirect(true);
              }
              catch(Exception e){
                addError(e.getmessage());
              }
           
           }else{
           try{
           
            List<Id> parentIds = new List<Id>();
            parentIds.add(oActivity.Related_Idea__c);
            DRDW_RecordSharing.getRecordIdShare(parentIds,false,false);
           
           update oActivity;
           
            DRDW_RecordSharing.getRecordIdShare(parentIds,true,false);
           
            if(!Hasaccess(UserInfo.getUserId(), oActivity.Id)){
             
                 pageref = new PageReference('/apex/DRDW_NoAccess');
                 pageref.setredirect(true);
                 return pageref;
                
             } 
            
           pageref = new pagereference('/apex/DRDW_CreateIdea?id=' + ideaid+'&isEdit=false');
           pageref.setredirect(true);
           }
           catch(Exception e){
                addError(e.getmessage());
              }
           
           }
           
       
      
      
      return pageref;
  }
  
  
  
  
  
  
         /*
* @Method Name                    :  EditRecord
* @Description                    :  Method for editing and existing record
* @Return Type                    :  PageReference
* @Parameters                     :  None
*/
     public PageReference EditRecord() {
        
        pagereference pageref;
        
        pageref = new pagereference('/apex/DRDW_CreateIdeaCapability?id=' + currentRecordID + '&isEdit=true');
        
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
         
       
        pageref = new pagereference('/apex/DRDW_CreateIdeaCapability?id=' + currentRecordID + '&isEdit=false');
       
        pageref.setredirect(true);
        return pageref; 
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
     * @Method Name                    :  addError
     * @Description                    :  Method for adding apex error
     * @Return Type                    :  void
     * @Parameters                     :  string
     */
    public void addError(string s) {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, s);
        ApexPages.addMessage(myMsg);
    }  
  
    Public PageReference DeleteRecord(){
        
          delete oActivity;
        
          PageReference pageref = new PageReference('/apex/DRDW_CreateIdea?id=' + ideaid+'&isEdit=false');
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
    
    public PageReference AddBudgetCap(){
        pagereference pageref = new pagereference('/apex/DRDW_CreateBudgetMaster?capid='+ currentRecordID);
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