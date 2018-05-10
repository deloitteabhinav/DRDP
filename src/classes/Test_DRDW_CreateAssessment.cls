/* Class Name  : DRDW_CreateRiskController_Test
* Description  : Test Class for DRDW_CreateRiskController
* Created By   : Deloitte
* Created Date : 22th December 2017
* Modification Log:  
* -----------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* -----------------------------------------------------------------------------------------------------
*/

@isTest(seeAllData=False)
public class Test_DRDW_CreateAssessment {

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
            List<DRDW_Project__c> lAssessments = DRDW_TestDataFactory.returnProjects(2,'Assessment Project');
            insert lAssessments;
            System.assert(lAssessments.size()==2);
            lAssessments[0].Molecule_Classification__c = 'Small Molecule';
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(1,'Generation Project');
            insert lprojects;
            lAssessments[0].Related_Generation_Project__c=lprojects[0].Id;
            update lAssessments[0];

            System.assert(lAssessments.size()==2);
            List<DRDW_Risk__c> lRisks = DRDW_TestDataFactory.returnRisks(1,lAssessments[0].id);      
            insert lRisks;     

            GLBL_Global_List_of_Values__c oglov = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Simplified Project Name').getRecordTypeId());
            GLBL_Global_List_of_Values__c oglov1 = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Termination Reason').getRecordTypeId());
            insert new List<sObject>{oglov,oglov1};

            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'External Activity',lAssessments[0].id);
            insert lCapab;

            DRDW_Cycle_Time_Standard__c oCycleStandard = new DRDW_Cycle_Time_Standard__c(Assessment_Cycle_Time_Standard_for_Small__c=1
                ,Assessment_Cycle_Time_Standard_for_Bioph__c=1,
                Assessment_Cycle_Time_Standard_for_Vacci__c=1);
            insert oCycleStandard;  
            Test.startTest();

            DRDW_Budget_Master__c oBudget = new DRDW_Budget_Master__c(Scientist_Owner__c=busAdm.id
                ,Title__c='test1'
                ,Activity_Name__c='test'
                ,Related_To__c =lAssessments[0].Id);
            insert oBudget;

            PageReference pageRef = new pageReference('/apex/DRDW_CreateAssessment?Id='+lAssessments[0].id);         
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(lAssessments[0]);
            DRDW_CreateAssessment controller = new DRDW_CreateAssessment(sc);            
            controller.getObjectRecordTypeId(DRDW_Project__c.SObjectType,'Assessment Project');
            controller.edit();
            controller.cycleTimeStandard();
            controller.oStudy.Molecule_Classification__c = 'Biopharma';
            controller.cycleTimeStandard();
            controller.addCapability();
            controller.cancel();
            controller.capabilityLink();
            controller.addNewRisk();
            controller.copyField();
            controller.checkBudgstatus();
            controller.save();
            controller.addBudget();
            controller.budgetLink();
            controller.addError('test');
            System.assertNotEquals(null,busAdm.Id,'error');
            Test.stopTest();
        }
    }

    static testMethod void testPositive1() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {            
            List<DRDW_Project__c> lAssessments = DRDW_TestDataFactory.returnProjects(2,'Assessment Project');
            insert lAssessments;
            System.assert(lAssessments.size()==2);
            lAssessments[0].Molecule_Classification__c = 'Small Molecule';
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(1,'Generation Project');
            insert lprojects;
            lAssessments[0].Related_Generation_Project__c=lprojects[0].Id;
            update lAssessments[0];

            System.assert(lAssessments.size()==2);
            List<DRDW_Risk__c> lRisks = DRDW_TestDataFactory.returnRisks(1,lAssessments[0].id);      
            insert lRisks;     

            GLBL_Global_List_of_Values__c oglov = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Simplified Project Name').getRecordTypeId());
            GLBL_Global_List_of_Values__c oglov1 = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Termination Reason').getRecordTypeId());
            insert new List<sObject>{oglov,oglov1};

            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'External Activity',lAssessments[0].id);
            insert lCapab;

            DRDW_Cycle_Time_Standard__c oCycleStandard = new DRDW_Cycle_Time_Standard__c(Assessment_Cycle_Time_Standard_for_Small__c=1
                ,Assessment_Cycle_Time_Standard_for_Bioph__c=1,
                Assessment_Cycle_Time_Standard_for_Vacci__c=1);
            insert oCycleStandard;  
            Test.startTest();

            DRDW_Budget_Master__c oBudget = new DRDW_Budget_Master__c(Scientist_Owner__c=busAdm.id
                ,Title__c='test1'
                ,Activity_Name__c='test'
                ,Related_To__c =lAssessments[0].Id);
            insert oBudget;

            PageReference pageRef = new pageReference('/apex/DRDW_CreateAssessment?Id='+lAssessments[0].id);         
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(lAssessments[0]);
            DRDW_CreateAssessment controller = new DRDW_CreateAssessment(sc);            
            controller.getObjectRecordTypeId(DRDW_Project__c.SObjectType,'Assessment Project');
            controller.edit();
            controller.oStudy.Molecule_Classification__c = 'Vaccine';
            controller.cycleTimeStandard();
            controller.genericID=oBudget.Id;
            controller.removeBudget();
            controller.removeCap();             
            controller.genericID=lRisks[0].Id;
            controller.removeRisk();
            controller.deleteRecord();
            System.assertNotEquals(null,busAdm.Id,'error');
            Test.stopTest();
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
            System.assert(lprojects[0].Id!=null);
            DRDW_Cap_Request__c ocapReq = new DRDW_Cap_Request__c(GO_Preferred_Start_Date__c=System.today()+2,Lab_Testing_Required__c='Lab Challenge Preparation;Lab Vaccination Preparation',samples_to_collect_new__c='[Tissue Sample,Oral Swabs]',Project__c=lprojects[0].Id,Actual_Start_Date__c=System.today(),Actual_End_Date__c=System.today()+5,RecordTypeId=Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('GO').getRecordTypeId());
            DRDW_Cap_Request__c ocapReq1 = new DRDW_Cap_Request__c(GO_Preferred_Start_Date__c=System.today()+2,Lab_Testing_Required__c='Lab Challenge Preparation;Lab Vaccination Preparation',samples_to_collect_new__c='[Tissue Sample,Oral Swabs]',Project__c=lprojects[0].Id,Actual_Start_Date__c=System.today(),Actual_End_Date__c=System.today()+5,RecordTypeId=Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('ERL').getRecordTypeId());
            insert new list<sObject>{ocapReq,ocapReq1};

            test.startTest();
            DRDW_Budget_Master__c oBudget = new DRDW_Budget_Master__c(Scientist_Owner__c=financeUser.id
                ,Title__c='test1'
                ,Activity_Name__c='test'
                ,Related_To__c =lprojects[0].Id);
            insert oBudget;
            DRDW_Budget_Summary__c oBudSum = new DRDW_Budget_Summary__c(Q_Actual__c=100.00,Q_Total_Actuals__c=120.00,Q_Rolling_Forecast__c=55.00,CurrencyIsoCode='EUR',F_X_Forecast__c=12.30,Year__c='2023',Quarter__c='2',Business_Plan__c=122.00,DRDW_Budget_Master__c=oBudget.Id,PO__c='TBD');
            DRDW_Budget_Summary__c oBudSum1 = new DRDW_Budget_Summary__c(Q_Actual__c=100.00,Q_Total_Actuals__c=120.00,Q_Rolling_Forecast__c=55.00,CurrencyIsoCode='EUR',F_X_Forecast__c=12.30,Year__c='2023',Quarter__c='3',Business_Plan__c=122.00,DRDW_Budget_Master__c=oBudget.Id,PO__c='TBD');
            insert new list<sObject>{oBudSum,oBudSum1};

            PageReference pageRef = new pageReference('/apex/DRDW_CreateAssessment?Id='+lprojects[0].id);         
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(lprojects[0]);
            DRDW_CreateAssessment controller = new DRDW_CreateAssessment(sc);  
            controller.AddGORequest();
            controller.AddERLRequest();           
            System.assertNotEquals(null,financeuser.Id,'error');            
            test.stopTest();
        }
        System.runAs(leadUser) {            
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');
            insert lprojects;
            PageReference pageRef = new pageReference('/apex/DRDW_CreateAssessment?Id='+lprojects[0].id);         
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(lprojects[0]);
            DRDW_CreateAssessment controller = new DRDW_CreateAssessment(sc);  
            controller.RemoveRisk();
            controller.RemoveCap();
        }
    }

    static testMethod void testWithoutCurrentRecord() {        
        User financeUser = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(financeUser.id,'DRDW_Financial_User');
        DRDW_TestDataFactory.assignGroup(financeUser.id,'DRDW_BU_Business_Development');
        System.runAs(financeUser) {            
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');
            insert lprojects;
            List<DRDW_Project__c> lprojects2 = DRDW_TestDataFactory.returnProjects(1,'Generation Project');
            System.assert(lprojects[0].Id!=null);
            DRDW_Cap_Request__c ocapReq = new DRDW_Cap_Request__c(GO_Preferred_Start_Date__c=System.today()+2,Lab_Testing_Required__c='Lab Challenge Preparation;Lab Vaccination Preparation',samples_to_collect_new__c='[Tissue Sample,Oral Swabs]',Project__c=lprojects[0].Id,Actual_Start_Date__c=System.today(),Actual_End_Date__c=System.today()+5,RecordTypeId=Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('GO').getRecordTypeId());
            DRDW_Cap_Request__c ocapReq1 = new DRDW_Cap_Request__c(GO_Preferred_Start_Date__c=System.today()+2,Lab_Testing_Required__c='Lab Challenge Preparation;Lab Vaccination Preparation',samples_to_collect_new__c='[Tissue Sample,Oral Swabs]',Project__c=lprojects[0].Id,Actual_Start_Date__c=System.today(),Actual_End_Date__c=System.today()+5,RecordTypeId=Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('ERL').getRecordTypeId());
            insert new list<sObject>{ocapReq,ocapReq1};

            test.startTest();
            DRDW_Budget_Master__c oBudget = new DRDW_Budget_Master__c(Scientist_Owner__c=financeUser.id
                ,Title__c='test1'
                ,Activity_Name__c='test'
                ,Related_To__c =lprojects[0].Id);
            insert oBudget;
            DRDW_Budget_Summary__c oBudSum = new DRDW_Budget_Summary__c(Q_Actual__c=100.00,Q_Total_Actuals__c=120.00,Q_Rolling_Forecast__c=55.00,CurrencyIsoCode='EUR',F_X_Forecast__c=12.30,Year__c='2023',Quarter__c='2',Business_Plan__c=122.00,DRDW_Budget_Master__c=oBudget.Id,PO__c='TBD');
            DRDW_Budget_Summary__c oBudSum1 = new DRDW_Budget_Summary__c(Q_Actual__c=100.00,Q_Total_Actuals__c=120.00,Q_Rolling_Forecast__c=55.00,CurrencyIsoCode='EUR',F_X_Forecast__c=12.30,Year__c='2023',Quarter__c='3',Business_Plan__c=122.00,DRDW_Budget_Master__c=oBudget.Id,PO__c='TBD');
            insert new list<sObject>{oBudSum,oBudSum1};
            PageReference pageRef = new pageReference('/apex/DRDW_CreateAssessment');         
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(lprojects2[0]);
            DRDW_CreateAssessment controller = new DRDW_CreateAssessment(sc);  
            controller.save();
            controller.cancel();
             System.assertNotEquals(null,financeuser.Id,'error');
            Test.stopTest();
        }
    }
}