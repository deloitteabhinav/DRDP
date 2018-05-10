/******************************************************************************************************************************************
* Class Name   : DRDW_TestFactory
* Description  : Utility Class for Creating Test Data for DRDW
* Created By   : Deloitte Consulting
*
*****************************************************************************************************************************************/
@isTest
public with sharing class DRDW_TestDataFactory {


 /*
    * @Method Name                    :  getTestingUser
    * @Description                    :  Creates a Test User
    * @Return Type                    :  User
    * @Parameters                     :  None
    */
    public static User getTestingUser() {

        String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
        Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
        String uniqueName = dateString + randomInt;

        User u;
        String pId = [select Id from Profile where Name = 'GSO Basic User_Salesforce'].Id;
        
        u = new User(profileId = pId,email = uniqueName + '@lilly.com',
                     Username = uniqueName + '@lilly.com',
                     alias = 'utusr', lastname = 'lastname', emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                     languagelocalekey = 'en_US', timezonesidkey = 'GMT');

        insert u;
        system.assertNotEquals(NULL, u);
        return u;
    }
    
    
    /*
    * @Method Name                    :  givePermissions
    * @Description                    :  Assigning Permission Set to a User
    * @Return Type                    :  void
    * @Parameters                     :  UserID,PSetName
    */
    public static void givePermissions(id UserID, string PSetName) {
        PermissionSet ps = [Select id From PermissionSet WHERE Name = :PSetName];
        PermissionSetAssignment psAssignments = new PermissionSetAssignment(AssigneeId = UserID, PermissionSetId = ps.id);
        insert psAssignments;

        system.assertNotEquals(NULL, psAssignments);
    }

    /*
    * @Method Name                    :  assignGroup
    * @Description                    :  Assigning Group to a User
    * @Return Type                    :  void
    * @Parameters                     :  UserID,Group Name
    */
    public static void assignGroup(id UserID, string groupName) {
        Group ogroup = [Select id From Group WHERE DeveloperName = :groupName];
        GroupMember ogrpMem = new GroupMember(UserOrGroupId = UserID, GroupId = ogroup.id);
        insert ogrpMem;

        system.assertNotEquals(NULL, ogrpMem);
    }

    
      /*
    * @Method Name                    :  returnIdeas
    * @Description                    :  returns a list of Ideas
    * @Return Type                    :  List of Ideas
    * @Parameters                     :  count
    */
    public static list<DRDW_Project__c> returnIdeas(integer count) {
        list<DRDW_Project__c> lIdeas = new list<DRDW_Project__c>();
        for (integer i = 0; i < count; i++) {
            DRDW_Project__c oIdea = new DRDW_Project__c();
            oIdea.recordtypeid=getObjectRecordTypeId(DRDW_Project__c.SObjectType,'Idea Project');
            oIdea.Idea_Name__c = 'test Idea'+i;
            oIdea.Hypothesis__c = 'random text';
            oIdea.Decision_to_Evaluate_DTE__c = system.today();
            oIdea.Duration__c = '3 months';
            oIdea.ERL_Primary_Contact__c = userinfo.getUserId();
            oIdea.Estimated_Budget__c = 23;
            lIdeas.add(oIdea);
        }

        system.assertNotEquals(NULL, lIdeas);
        return lIdeas;
    }
    
        /*
    * @Method Name                    :  returnProjects
    * @Description                    :  returns a list of Projects
    * @Return Type                    :  List of Projects
    * @Parameters                     :  count,recordtype
    */
    public static list<DRDW_Project__c> returnProjects(integer count,String recordtype) {
        list<DRDW_Project__c> lProjects = new list<DRDW_Project__c>();
        for (integer i = 0; i < count; i++) {
            DRDW_Project__c oProject = new DRDW_Project__c();
            oProject.recordtypeid=getObjectRecordTypeId(DRDW_Project__c.SObjectType,recordtype);
            oProject.Organizational_Unit__c = 'Research';
            oProject.Business_Unit__c = 'Business Development';
            oProject.Functional_Area__c = 'RPL';
            oProject.Project_Name__c = 'Test Project'+i;
            oProject.Simplified_Project_Name__c = 'HW';
            oProject.Therapeutic_Area__c = 'Others';
            oProject.Disease_Area__c = 'CKD';
            oProject.Species__c = 'Fish';
            oProject.Project_Description__c = 'Random Text';
            oProject.Scientific_Hypothesis_Product_Concept__c = 'Random Text';
            oProject.Project_Type__c = 'New Molecule Entity';
            oProject.Project_Source__c = 'LRL Asset';
            oProject.Budget_Status__c = 'Funded';
            oProject.Product_Type__c = 'Biotech';
            oProject.Active_Ingredients__c = 'Random Text';
            oProject.Route_of_Administration__c = 'Oral';
            oProject.Research_Project_Lead__c = Userinfo.getuserId();
            oProject.Development_Team_Director__c = Userinfo.getuserId();
            oProject.Idea_Name__c='Test';
            oProject.Project_Name__c='Test';
            oProject.New_Idea_Name__c='Test';
            lProjects.add(oProject);
        }

        system.assertNotEquals(NULL, lProjects);
        return lProjects;
    }
    
    
    
    
    /*
    * @Method Name                    :  returnCapabilities
    * @Description                    :  returns a list of Capabilities
    * @Return Type                    :  List of Capabilities
    * @Parameters                     :  count
    */
    public static list<DRDW_Capability__c> returnCapabilities(integer count,String recordtype,Id projectid) {
        list<DRDW_Capability__c> lCapabilities = new list<DRDW_Capability__c>();
        for (integer i = 0; i < count; i++) {
            DRDW_Capability__c oCapability = new DRDW_Capability__c();
            oCapability.recordtypeid=getObjectRecordTypeId(DRDW_Capability__c.SObjectType,recordtype);
            oCapability.Capability_Area__c = 'Parasitology';
            oCapability.Capability__c = 'Consulting (scientific expertise) and academic collaborations';
            oCapability.Planned_Start_Date__c = system.today();
            oCapability.Duration__c = '3 months';
            oCapability.Related_Idea__c = projectid;
            oCapability.Related_Project__c = projectid;          
            lCapabilities.add(oCapability);
        }

        system.assertNotEquals(NULL, lCapabilities);
        return lCapabilities;
    }
    
      /*
    * @Method Name                    :  returnRisks
    * @Description                    :  returns a list of Risks
    * @Return Type                    :  List of Risks
    * @Parameters                     :  count
    */
    public static list<DRDW_Risk__c> returnRisks(integer count,Id projectid) {
        list<DRDW_Risk__c> lRisks = new list<DRDW_Risk__c>();
        for (integer i = 0; i < count; i++) {
            DRDW_Risk__c oRisk = new DRDW_Risk__c();           
            oRisk.Related_To__c = projectid;
            oRisk.Description__c = 'random text';
            oRisk.Risk_Status__c = 'Open';
           
            lRisks.add(oRisk);
        }

        system.assertNotEquals(NULL, lRisks);
        return lRisks;
    }
    
    /*
    * @Method Name                    :  returnRequests
    * @Description                    :  returns a list of cap requests
    * @Return Type                    :  List of requests
    * @Parameters                     :  count
    */
    public static list<DRDW_Cap_Request__c> returnRequests(integer count,string recordtype,Id projectid) {
        list<DRDW_Cap_Request__c> lcaprequests = new list<DRDW_Cap_Request__c>();
        for (integer i = 0; i < count; i++) {
            DRDW_Cap_Request__c ocap = new DRDW_Cap_Request__c();           
            ocap.recordtypeid = getObjectRecordTypeId(DRDW_Cap_Request__c.SObjectType,recordtype); 
            ocap.Request_status__c = 'Draft';
            ocap.Project__c=projectid;
           
            lcaprequests.add(ocap);
        }

        system.assertNotEquals(NULL, lcaprequests);
        return lcaprequests;
    }

    
     /*
     * @Method Name                    :  getObjectRecordTypeId
     * @Description                    :  Method to retrieve recordtypeid
     * @Return Type                    :  String
     * @Parameters                     :  string,SObjectType
     */
    
     public Static String getObjectRecordTypeId(SObjectType sObjectType, String recordTypeName)
    {
        //Generate a map of tokens for all the Record Types for the desired object
        Map<String,Schema.RecordTypeInfo> recordTypeInfo = sObjectType.getDescribe().getRecordTypeInfosByName();        
        
        //Retrieve the record type id by name
        return recordTypeInfo.get(recordTypeName).getRecordTypeId();
    }

    public static List<Document> createDocument(List<String> lDocName){
        Document oDocument = new Document();
        String folderId = [select id from folder where name = 'DRDW Image Configuration' LIMIT 1].id;
        List<Document> lDocuments = new List<Document>();
        for(integer i=0;i<lDocName.size();i++){
            oDocument = new Document();
            oDocument.Body = Blob.valueOf('Some Text'+i);
            oDocument.DeveloperName = 'Developer_Name'+i;
            oDocument.IsPublic = true;
            oDocument.Name = lDocName[i]; 
            oDocument.folderId=folderId;
            lDocuments.add(oDocument);          
        }
        return lDocuments;
    }
    
    
    /*
    * @Method Name                    :  returnCapabilities
    * @Description                    :  returns a list of Capabilities
    * @Return Type                    :  List of Capabilities
    * @Parameters                     :  count
    */
    public static list<DRDW_Capability__c> returnCapabilitieswithreq(integer count,String recordtype,Id projectid,Id reqId) {
        list<DRDW_Capability__c> lCapabilities = new list<DRDW_Capability__c>();
        for (integer i = 0; i < count; i++) {
            DRDW_Capability__c oCapability = new DRDW_Capability__c();
            oCapability.recordtypeid=getObjectRecordTypeId(DRDW_Capability__c.SObjectType,recordtype);
            oCapability.Capability_Area__c = 'Parasitology';
            oCapability.Capability__c = 'Consulting (scientific expertise) and academic collaborations';
            oCapability.Planned_Start_Date__c = system.today();
            oCapability.Duration__c = '3 months';
            oCapability.Related_Idea__c = projectid;
            oCapability.Related_Project__c = projectid;   
            oCapability.DRDW_Request__c = reqId; 
            oCapability.Planned_End_Date__c = system.today();     
            lCapabilities.add(oCapability);
        }

        system.assertNotEquals(NULL, lCapabilities);
        return lCapabilities;
    }
    
    /*
    * @Method Name                    :  returnBudgetmasters
    * @Description                    :  returns a list of budget masters
    * @Return Type                    :  List of budget masters
    * @Parameters                     :  count
    */
    public static list<DRDW_Budget_Master__c> returnBudgetmasters(integer count,Id projectid) {
        list<DRDW_Budget_Master__c> lbudgetmasters = new list<DRDW_Budget_Master__c>();
        for (integer i = 0; i < count; i++) {
            DRDW_Budget_Master__c obudgetMaster = new DRDW_Budget_Master__c();
            obudgetMaster.Title__c = 'Test Title'+i; 
            obudgetMaster.Related_To__c = projectid;    
            lbudgetmasters.add(obudgetMaster);
        }

        system.assertNotEquals(NULL, lbudgetmasters);
        return lbudgetmasters;
    }

    /*
    * @Method Name                    :  returnBudgetSummary
    * @Description                    :  returns a list of budget masters
    * @Return Type                    :  List of budget masters
    * @Parameters                     :  count
    */
    public static list<DRDW_Budget_summary__c> returnBudgetSummary(integer count,Id BudgetMasterId,String quarter, String year) {
        list<DRDW_Budget_summary__c> lbudgetsummary = new list<DRDW_Budget_summary__c>();
        for (integer i = 0; i < count; i++) {
            DRDW_Budget_summary__c obudgetSummary = new DRDW_Budget_summary__c();
            obudgetSummary.DRDW_Budget_Master__c = BudgetMasterId;  
            obudgetSummary.F_X_Forecast__c = 34;  
            obudgetSummary.Quarter__C = quarter;
            obudgetSummary.Year__c = year;
            lbudgetsummary.add(obudgetSummary);
        }

        system.assertNotEquals(NULL, lbudgetsummary);
        return lbudgetsummary;
    }

}