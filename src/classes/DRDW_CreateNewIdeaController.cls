public without sharing class DRDW_CreateNewIdeaController {

 public DRDW_Project__c  oIdea {get; set;}
 public Id currentRecordID {get; set;}
 public List<DRDW_Project__c> levals {get; set;}
 public List<DRDW_Risk__c> lrisks {get; set;}
 public boolean isEvalError {get; set;}
 Public Boolean isAdmin{get;set;} 
 Public Boolean isFin{get;set;} 
 Public Boolean isAccess {get;set;}   
 public List<DRDW_Project__c> lgens {get; set;}
 public id genericID {get; set;}
 public id LinkID {get; set;}
 public id LinkID1 {get; set;}
 public id LinkID2 {get; set;}
 Public boolean isRiskError{get; set;}
 Public boolean isLeader{get; set;}
 
 //Loading the Constructor
  public DRDW_CreateNewIdeaController(ApexPages.StandardController controller) {
      
      oIdea = (DRDW_Project__c)controller.getRecord();
      
      currentRecordID = ApexPages.currentPage().getParameters().get('id');
       
      if(currentRecordID != null){
      
           //Quering the Idea
          
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
          levals = [Select Id, Name, Idea_Name__c, Business_Unit__c, Decision_to_Evaluate_DTE__c, ERL_Primary_Contact__c,Duration__c from DRDW_Project__c where Related_Idea__c = :currentRecordID];
           lrisks = [Select Id, Name,Title__c, Description_gap__c from DRDW_Risk__c where Related_To__c =:currentRecordID ]; 
      }else{
          oIdea.recordtypeid =  getObjectRecordTypeId(DRDW_Project__c.SObjectType,'Idea');
          oIdea.Phase__c = 'Idea';
      }
      
      isAdmin = getUserPermission(UserInfo.getUserId());
      isFin = getUserPermissionFin(UserInfo.getUserId());
      isAccess = HasAccess(UserInfo.getUserId(), oIdea.Id);
      
     
  }
    /*
     * @Method Name                    :  SaveIdea
     * @Description                    :  Method to Save the Idea record
     * @Return Type                    :  None
     * @Parameters                     :  None
     */  
  public PageReference SaveIdea(){

      try{  
         
         Upsert oIdea;
         
          if(!Hasaccess(UserInfo.getUserId(), oIdea.Id)){
             
                 PageReference pageref = new PageReference('/apex/DRDW_NoAccess');
                 pageref.setredirect(true);
                 return pageref;
                
             }
         
         PageReference pageref = new PageReference('/apex/DRDW_CreateNewIdea?id='+oIdea.Id+'&isEdit=false');
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
        pagereference pageref = new pagereference('/apex/DRDW_CreateNewIdea?id=' + currentRecordID + '&isEdit=true');
        pageref.setredirect(true);
        return pageref;
    }
    
    /*
     * @Method Name                    :  DeleteRecord
     * @Description                    :  Method for deleting the record
     * @Return Type                    :  PageReference
     * @Parameters                     :  None
     */
    Public PageReference DeleteRecord(){
        
          delete oIdea;
        
          PageReference pageref = new PageReference('/apex/DRDW_DeletedProjRecord');
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
    
    /*
     * @Method Name                    :  AddEval
     * @Description                    :  Method to add a related eval project
     * @Return Type                    :  void
     * @Parameters                     :  None
     */
     
     Public PageReference AddRisk(){
         PageReference pageref = new PageReference('/apex/DRDW_CreateRisk?projectid='+currentRecordID);
         pageref.setredirect(true);
         return pageref;
     }
     
     /*
     * @Method Name                    :  RemoveRisk
     * @Description                    :  Method to remove a related Risk
     * @Return Type                    :  void
     * @Parameters                     :  None
     */
     
     Public void RemoveRisk(){
         try {
            lrisks = [Select Name,Title__c,Description_gap__c from DRDW_Risk__c where Related_To__c =: currentRecordID];
            DRDW_Risk__c oExp = [Select id from DRDW_Risk__c where Related_To__c = :currentRecordID AND id = : genericID];
            delete oExp;
            lrisks = [Select Name,Title__c,Description_gap__c from DRDW_Risk__c where Related_To__c =: currentRecordID];
        } catch (exception e) {
            addError(e.getmessage());
            isRiskError = true;
        } 
     }
     
     /*
     * @Method Name                    :  EvalLink
     * @Description                    :  Method to redirect user to Eval Proj record
     * @Return Type                    :  PageReference
     * @Parameters                     :  None
     */
    
    public PageReference EvalLink(){
        pagereference pageref = new pagereference('/apex/DRDW_CreateIdea?id='+LinkID1+'&isEdit=false');
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
 
 
 }