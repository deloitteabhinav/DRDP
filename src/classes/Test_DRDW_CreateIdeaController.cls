@isTest(seeAllData=false)
private class Test_DRDW_CreateIdeaController {
    /* 
    * @Method Name                    :  testPositive
    * @Description                    :  Method to test Create assessment page 
    * @Return Type                    :  void
    * @Parameters                     :  None
    */      
    static testMethod void testPositive() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {            
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Idea Project');         
            insert lprojects;
            List<DRDW_Project__c> lIdea = DRDW_TestDataFactory.returnProjects(1,'Idea');
            insert lIdea;
            lprojects[0].Related_Idea__c=lIdea[0].Id;
            lprojects[0].CSF_Decision_to_Generate_DTG_Planned__c = system.today().addDays(2);
            lprojects[0].Decision_to_Evaluate_DTE__c = system.today();
            lprojects[0].EPCTM_DTG_DTE_for_Biopharma__c = 23;
            lprojects[0].Molecule_Classification__c = 'Small Molecule';
            update lprojects[0];
           
            System.assertNotEquals(null,lprojects,'error'); 

            List<DRDW_Risk__c> lRisks = DRDW_TestDataFactory.returnRisks(1,lprojects[0].id);      
            insert lRisks;      
            Test.startTest();

            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Idea Capability',lprojects[0].id);
            insert lCapab;

            DRDW_Cycle_Time_Standard__c oCycleStandard = new DRDW_Cycle_Time_Standard__c(Assessment_Cycle_Time_Standard_for_Small__c=1
                ,Assessment_Cycle_Time_Standard_for_Bioph__c=1,
                Assessment_Cycle_Time_Standard_for_Vacci__c=1);
            insert oCycleStandard;
            Id requestTypeId = Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('ERL').getRecordTypeId();
            DRDW_Cap_Request__c oRequest = new DRDW_Cap_Request__c();
            oRequest.recordtypeid = requestTypeid;
            oRequest.Project__c=lprojects[0].id;
            insert oRequest;
            System.assertNotEquals(null,oRequest,'error'); 
            DRDW_Capability__c oCap = new DRDW_Capability__c();
            oCap.DRDW_Request__c = oRequest.id;
            insert oCap;
            
            Id requestTypeId1 = Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('GO').getRecordTypeId();
            DRDW_Cap_Request__c oRequest1 = new DRDW_Cap_Request__c();
            oRequest1.recordtypeid = requestTypeid1;
            oRequest1.Project__c=lprojects[0].id;
            insert oRequest1;
            
            DRDW_Capability__c oCap1 = new DRDW_Capability__c();
            oCap1.DRDW_Request__c = oRequest1.id;
            insert oCap1;

            DRDW_Budget_Master__c oBudget = new DRDW_Budget_Master__c(Scientist_Owner__c=busAdm.id
                ,Title__c='test1'
                ,Activity_Name__c='test'
                ,Related_To__c =lprojects[0].Id);
            insert oBudget;

            PageReference pageRef = new pageReference('/apex/DRDW_CreateIdea?Id='+lprojects[0].id);         
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(lprojects[0]);
            DRDW_CreateIdeaController controller = new DRDW_CreateIdeaController(sc);            
            controller.getObjectRecordTypeId(DRDW_Project__c.SObjectType,'Idea Project');
            controller.EditRecord();
            controller.oIdea.Molecule_Classification__c = 'Biopharma';
            controller.cycleTimeStandard();
            controller.cancel();
            controller.capabilityLink();
            controller.GenLink();
            controller.BudgetLink();
            controller.AddRisks();
            controller.SaveIdea();
            controller.addBudget();
            controller.addCap();
            controller.budgetLink();
            controller.addError('test');
            Test.stopTest();
            controller.oIdea.Molecule_Classification__c = 'Vaccine';
            controller.cycleTimeStandard();
            controller.oIdea.Molecule_Classification__c = 'Small Molecule';
            controller.cycleTimeStandard();
            controller.genericID=oBudget.Id;
            controller.removeBudget();
            controller.genericID=lCapab[0].Id;
            controller.removeCap();             
            controller.genericID=lRisks[0].Id;
            controller.removeRisk();
            controller.copyFieldsfromEvaluation();
            controller.checkAccess();
            controller.deleteRecord();
            controller.AddERLRequest();
            controller.AddGORequest();
        }
    }

    static testMethod void testPermissions() {        
        User financeUser = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(financeUser.id,'DRDW_Financial_User');
        User leadUser = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(leadUser.id,'DRDW_Leadership_User');
        System.runAs(financeUser) {            
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');
            insert lprojects;
            lprojects[0].CSF_Decision_to_Generate_DTG_Planned__c = system.today().addDays(40);
            lprojects[0].Decision_to_Evaluate_DTE__c = system.today();
            lprojects[0].EPCTM_DTG_DTE_for_Small_Molecule__c= 23;
            lprojects[0].Molecule_Classification__c = 'Small Molecule';
            lprojects[0].EPCTM_DTG_DTE_for_Vaccine__c=20;
            update lprojects[0];
            
            System.assertNotEquals(null,lprojects,'error'); 
            PageReference pageRef = new pageReference('/apex/DRDW_CreateIdea?Id='+lprojects[0].id);         
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(lprojects[0]);
            DRDW_CreateIdeaController controller = new DRDW_CreateIdeaController(sc);  
        }
        System.runAs(leadUser) {            
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');
            insert lprojects;            
            PageReference pageRef = new pageReference('/apex/DRDW_CreateIdea?Id='+lprojects[0].id);         
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(lprojects[0]);
            DRDW_CreateIdeaController controller = new DRDW_CreateIdeaController(sc);  
            controller.RemoveRisk();
            controller.RemoveCap();
            controller.RemoveBudget();
            controller.SaveIdea();
        }
            
    }
}