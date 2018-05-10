@isTest
private class Test_DRDW_createGenerationController {
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
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');         
            insert lprojects;
            List<DRDW_Project__c> lIdea = DRDW_TestDataFactory.returnProjects(1,'Idea Project');
            insert lIdea;
            lprojects[0].Related_Idea_Project__c=lIdea[0].Id;
            update lprojects[0];
            lIdea[0].Molecule_Classification__c = 'Small Molecule';

            List<DRDW_Risk__c> lRisks = DRDW_TestDataFactory.returnRisks(1,lprojects[0].id);      
            insert lRisks;      
            Test.startTest();

            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Idea Capability',lprojects[0].id);
            insert lCapab;
            System.assert(lCapab != null);

            DRDW_Cycle_Time_Standard__c oCycleStandard = new DRDW_Cycle_Time_Standard__c(Assessment_Cycle_Time_Standard_for_Small__c=1
                ,Assessment_Cycle_Time_Standard_for_Bioph__c=1,
                Assessment_Cycle_Time_Standard_for_Vacci__c=1);
            insert oCycleStandard;

            DRDW_Budget_Master__c oBudget = new DRDW_Budget_Master__c(Scientist_Owner__c=busAdm.id
                ,Title__c='test1'
                ,Activity_Name__c='test'
                ,Related_To__c =lprojects[0].Id);
            insert oBudget;

            PageReference pageRef = new pageReference('/apex/DRDW_createGeneration?Id='+lprojects[0].id);         
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(lprojects[0]);
            DRDW_createGenerationController controller = new DRDW_createGenerationController(sc);            
            controller.getObjectRecordTypeId(DRDW_Project__c.SObjectType,'Assessment Project');
            controller.edit();
            controller.cycleTimeStandard();
            controller.oStudy.Molecule_Classification__c = 'Biopharma';
            controller.cycleTimeStandard();
            controller.cancel();
            controller.capabilityLink();
            controller.addNewRisk();
            controller.AddNewCapability();
            controller.checkBudgstatus();
            controller.save();
            controller.addBudget();
            controller.budgetLink();
            controller.addError('test');
            Test.stopTest();
            controller.oStudy.Molecule_Classification__c = 'Vaccine';
            controller.cycleTimeStandard();
            controller.genericID=oBudget.Id;
            controller.removeBudget();
            controller.capabilityID=lCapab[0].Id;
            controller.removeCap();             
            controller.genericID=lRisks[0].Id;
            controller.removeRisk();
            controller.copyFieldsfromEvaluation();
            controller.deleteRecord();
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
            PageReference pageRef = new pageReference('/apex/DRDW_createGeneration?Id='+lprojects[0].id);         
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(lprojects[0]);
            DRDW_createGenerationController controller = new DRDW_createGenerationController(sc);  
        }
        System.runAs(leadUser) {            
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');
            insert lprojects;
            System.assert(lprojects != null);
            PageReference pageRef = new pageReference('/apex/DRDW_createGeneration?Id='+lprojects[0].id);         
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(lprojects[0]);
            DRDW_createGenerationController controller = new DRDW_createGenerationController(sc);  
            controller.RemoveRisk();
            controller.RemoveCap();
            controller.RemoveBudget();
            controller.save();
        }
    }
    
    static testMethod void testNegative() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {            
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');  
            lprojects[0].IMA__c = 34; 
            lprojects[0].PK_Sales_M__c = 34.45;    
            lprojects[0].Budget_Status__c = 'Not Funded';
            lprojects[0].Molecule_Classification__c = 'Small Molecule';
            lprojects[0].Director__c = busAdm.Id;
            insert lprojects;
            System.assert(lprojects != null);

            List<DRDW_Project__c> lIdea = DRDW_TestDataFactory.returnProjects(1,'Idea Project');
            insert lIdea;
            lprojects[0].Related_Idea_Project__c=lIdea[0].Id;
            update lprojects[0];
            lIdea[0].Molecule_Classification__c = 'Small Molecule';

            List<DRDW_Risk__c> lRisks = DRDW_TestDataFactory.returnRisks(1,lprojects[0].id);      
            insert lRisks;      
            Test.startTest();

            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Idea Capability',lprojects[0].id);
            insert lCapab;
            
            List<DRDW_Cap_Request__c> lcaprequests = DRDW_TestDataFactory.returnRequests(1, 'GO',lprojects[0].id);
            insert lcaprequests;

            List<DRDW_Cap_Request__c> lcaprequestsERL = DRDW_TestDataFactory.returnRequests(1, 'ERL',lprojects[0].id);
            insert lcaprequestsERL;
            
            lCapab[0].DRDW_Request__c = lcaprequests[0].Id;
            update lcapab;

            List<DRDW_Budget_Master__c> oBudget = DRDW_TestDataFactory.returnBudgetmasters(1, lprojects[0].id);
            insert oBudget;

            DRDW_Cycle_Time_Standard__c oCycleStandard = new DRDW_Cycle_Time_Standard__c(Assessment_Cycle_Time_Standard_for_Small__c=1
                ,Assessment_Cycle_Time_Standard_for_Bioph__c=1,
                Assessment_Cycle_Time_Standard_for_Vacci__c=1);
            insert oCycleStandard;

            List<DRDW_Budget_Summary__c> lstsummaries = [Select F_X_Forecast__c, Name, Id from DRDW_Budget_Summary__c where DRDW_Budget_Master__c IN :oBudget Limit 1];
            lstsummaries[0].F_X_Forecast__c = 34;
            update lstsummaries;

            
            PageReference pageRef = new pageReference('/apex/DRDW_createGeneration?Id='+lprojects[0].id);         
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(lprojects[0]);
            DRDW_createGenerationController controller = new DRDW_createGenerationController(sc);            
            controller.edit();
            controller.AddERLRequest();
            controller.AddGORequest();
            controller.save();
            controller.checkBudgstatus();
            Test.stopTest();
        }
   }

   static testMethod void testNegative1() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {    
            DRDW_Cycle_Time_Standard__c oCycleStandard = new DRDW_Cycle_Time_Standard__c(Generation_Cycle_Time_Standard_for_Bioph__c=1
                ,Generation_Cycle_Time_Standard_for_Small__c=1,
                Generation_Cycle_Time_Standard_for_Vacci__c=1);
            insert oCycleStandard;  

            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(1,'Generation Project');  
            lprojects[0].Decision_to_Assess_DTA_Planned_Date__c = System.today();
            lprojects[0].Decision_to_Generate_DTG__c = System.today();
            lprojects[0].Decision_to_Assess_DTA_Actual_Date__c = System.today();
            lprojects[0].Molecule_Classification__c = 'Small Molecule';
            lprojects[0].EPCTM_DTA_DTG_for_Biopharma__c = 1;
            insert lprojects;
            List<DRDW_Project__c> lIdea = DRDW_TestDataFactory.returnProjects(1,'Idea Project');
            insert lIdea;
            System.assert(lIdea != null);
            lprojects[0].Related_Idea_Project__c=lIdea[0].Id;
            update lprojects[0];
            lIdea[0].Molecule_Classification__c = 'Small Molecule';
    
            Test.startTest();

            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Idea Capability',lprojects[0].id);
            insert lCapab;
            
            List<DRDW_Cap_Request__c> lcaprequests = DRDW_TestDataFactory.returnRequests(1, 'GO',lprojects[0].id);
            insert lcaprequests;

            List<DRDW_Cap_Request__c> lcaprequestsERL = DRDW_TestDataFactory.returnRequests(1, 'ERL',lprojects[0].id);
            insert lcaprequestsERL;
            
            lCapab[0].DRDW_Request__c = lcaprequests[0].Id;
            update lcapab;
            
            PageReference pageRef = new pageReference('/apex/DRDW_createGeneration?Id='+lprojects[0].id);         
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(lprojects[0]);
            DRDW_createGenerationController controller = new DRDW_createGenerationController(sc);            
            controller.edit();
            controller.save();
            controller.checkBudgstatus();
            Test.stopTest();
        }
   }

   static testMethod void testNegative2() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {    
            DRDW_Cycle_Time_Standard__c oCycleStandard = new DRDW_Cycle_Time_Standard__c(Generation_Cycle_Time_Standard_for_Bioph__c=1
                ,Generation_Cycle_Time_Standard_for_Small__c=1,
                Generation_Cycle_Time_Standard_for_Vacci__c=1);
            insert oCycleStandard;  
            System.assert(oCycleStandard != null);

            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(1,'Generation Project');  
            lprojects[0].Decision_to_Assess_DTA_Planned_Date__c = System.today();
            lprojects[0].Decision_to_Generate_DTG__c = System.today();
            lprojects[0].Decision_to_Assess_DTA_Actual_Date__c = System.today();
            lprojects[0].Molecule_Classification__c = 'Small Molecule';
            lprojects[0].EPCTM_DTA_DTG_for_Small_Molecule__c = 2;
            insert lprojects;

            Test.startTest();
            
            PageReference pageRef = new pageReference('/apex/DRDW_createGeneration?Id='+lprojects[0].id);         
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(lprojects[0]);
            DRDW_createGenerationController controller = new DRDW_createGenerationController(sc);            
            Test.stopTest();
        }
   }

    static testMethod void testWithoutCurrentRecord() {        
        User financeUser = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(financeUser.id,'DRDW_Financial_User');
        DRDW_TestDataFactory.assignGroup(financeUser.id,'DRDW_BU_Business_Development');
        System.runAs(financeUser) {            
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(1,'Generation Project');
            insert lprojects;
            System.assert(lprojects[0].Id!=null);

            test.startTest();

            PageReference pageRef = new pageReference('/apex/DRDW_CreateGeneration');         
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(lprojects[0]);
            DRDW_createGenerationController controller = new DRDW_createGenerationController(sc);  
            controller.save();
            controller.cancel();
        }
    }


}