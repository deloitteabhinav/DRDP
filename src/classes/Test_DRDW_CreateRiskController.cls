/* Class Name  : Test_DRDW_CreateRiskController
* Description  : Test Class for DRDW_CreateRiskController
* Created By   : Deloitte
* Created Date : 22nd December 2017
* Modification Log:  
* -----------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* -----------------------------------------------------------------------------------------------------
*/
@isTest(SeeAllData = false)
public class Test_DRDW_CreateRiskController{
    /* 
    * @Method Name                    :  testRiskController
    * @Description                    :  Method to test Risk page 
    * @Return Type                    :  void
    * @Parameters                     :  None
    */      
    static testMethod void testRiskController() {
        User u = DRDW_TestDataFactory.getTestingUser();
        DRDW_TestDataFactory.givePermissions(u.id,'DRDW_Business_Admin');       
        System.runAs(u) {
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');
            insert lprojects;
            List<DRDW_Project__c> lAssessments = DRDW_TestDataFactory.returnProjects(2,'Assessment Project');
            insert lAssessments;
            List<DRDW_Risk__c> lRisks = DRDW_TestDataFactory.returnRisks(2,lprojects[0].id);
            System.assertNotEquals(null,lRisks,'error');
            lRisks[0].Impacted_Project_Timeline_Activity__c='CSF: Determination of Efficacy Actual,CSF: Determination of Efficacy Planned,CSF: MR1 Review,';
            Test.startTest();
            PageReference pageRef = new pageReference('/apex/DRDW_CreateRisk?projectid='+lprojects[0].id);
            Test.setCurrentPage(pageRef);
            // risk id is null
            ApexPages.StandardController stdController = new ApexPages.StandardController(lRisks[0]);
            DRDW_CreateRiskController oRiskController = new DRDW_CreateRiskController(stdController);
            oRiskController.saveRisk();
            oRiskController.EditRecord();           
            oRiskController.CancelRecord();
            // after risk is created.
            PageReference pageRef1 = new pageReference('/apex/DRDW_CreateRisk?id='+lRisks[0].id+'&isEdit=true');
            Test.setCurrentPage(pageRef1);
            ApexPages.StandardController stdController1 = new ApexPages.StandardController(lRisks[0]);
            DRDW_CreateRiskController oRiskController1 = new DRDW_CreateRiskController(stdController1);
            oRiskController1.saveRisk();
            oRiskController1.DeleteRecord();
            PageReference pageRef2 = new pageReference('/apex/DRDW_CreateRisk?projectid='+lAssessments[0].id);
            Test.setCurrentPage(pageRef2);
            // risk id is null and 
            ApexPages.StandardController stdController2 = new ApexPages.StandardController(lRisks[0]);
            DRDW_CreateRiskController oRiskController2 = new DRDW_CreateRiskController(stdController2);
            oRiskController2.saveRisk();
            Test.stopTest();
        }
    }
    /* 
    * @Method Name                    :  testRiskController
    * @Description                    :  Method to test Risk page 
    * @Return Type                    :  void
    * @Parameters                     :  None
    */      
    static testMethod void testRiskController1() {
        User u = DRDW_TestDataFactory.getTestingUser();
        DRDW_TestDataFactory.givePermissions(u.id,'DRDW_Business_Admin');       
        System.runAs(u) {
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Idea');            
            insert lprojects;
            List<DRDW_Risk__c> lRisks = DRDW_TestDataFactory.returnRisks(2,lprojects[0].id);
            Test.startTest();
            PageReference pageRef = new pageReference('/apex/DRDW_CreateRisk?projectid='+lprojects[0].id);
            Test.setCurrentPage(pageRef);
            // risk id is null
            System.assertNotEquals(null,lRisks,'error');
            ApexPages.StandardController stdController = new ApexPages.StandardController(lRisks[0]);
            DRDW_CreateRiskController oRiskController = new DRDW_CreateRiskController(stdController);
            oRiskController.saveRisk();
            oRiskController.EditRecord();           
            oRiskController.CancelRecord();
            oRiskController.addError('Test');
            // after risk is created.
            PageReference pageRef1 = new pageReference('/apex/DRDW_CreateRisk?id='+lRisks[0].id+'&isEdit=true');
            Test.setCurrentPage(pageRef1);
            ApexPages.StandardController stdController1 = new ApexPages.StandardController(lRisks[0]);
            DRDW_CreateRiskController oRiskController1 = new DRDW_CreateRiskController(stdController1);
            oRiskController1.saveRisk();
            Test.stopTest();
        }
    }
    /* 
    * @Method Name                    :  testRiskController
    * @Description                    :  Method to test Risk page 
    * @Return Type                    :  void
    * @Parameters                     :  None
    */      
    static testMethod void testRiskController2() {
        User u = DRDW_TestDataFactory.getTestingUser();
        DRDW_TestDataFactory.givePermissions(u.id,'DRDW_Business_Admin');       
        System.runAs(u) {
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnIdeas(2);            
            insert lprojects;
            List<DRDW_Risk__c> lRisks = DRDW_TestDataFactory.returnRisks(2,lprojects[0].id);
            Test.startTest();
            PageReference pageRef = new pageReference('/apex/DRDW_CreateRisk?projectid='+lprojects[0].id);
            Test.setCurrentPage(pageRef);
            // risk id is null
            ApexPages.StandardController stdController = new ApexPages.StandardController(lRisks[0]);
            DRDW_CreateRiskController oRiskController = new DRDW_CreateRiskController(stdController);
            oRiskController.saveRisk();
            oRiskController.EditRecord();           
            oRiskController.CancelRecord();
            System.assertNotEquals(null,lRisks,'error');
            // after risk is created.
            PageReference pageRef1 = new pageReference('/apex/DRDW_CreateRisk?id='+lRisks[0].id+'&isEdit=true');
            Test.setCurrentPage(pageRef1);
            ApexPages.StandardController stdController1 = new ApexPages.StandardController(lRisks[0]);
            DRDW_CreateRiskController oRiskController1 = new DRDW_CreateRiskController(stdController1);
            oRiskController1.saveRisk();
            Test.stopTest();
        }
    }
}