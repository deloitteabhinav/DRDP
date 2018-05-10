/* Class Name  : Test_DRDW_CreateBudgetMaster
* Description  : Test Class for DRDW_CreateBudgetMaster
* Created By   : Deloitte
* Created Date : 1st March 2018
* Modification Log:  
* -----------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* -----------------------------------------------------------------------------------------------------
*/
@isTest(seeAllData=false)
private class Test_DRDW_CreateBudgetMaster {
    
    static testMethod void testwithBudget_CurrentID() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {     
            test.startTest();                 
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');         
            insert lprojects;
            System.assert(lprojects.size()==2);
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Idea Capability',lprojects[0].id);
            insert lCapab;

            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 

            DRDW_Budget_Master__c oBudgetMaster = new DRDW_Budget_Master__c(CurrencyIsoCode='EUR',Total_F_X_Forecast__c=100.00,Total_Business_Plan__c=500.00,Cost_Center__c=oCostCen.Id,Planned_Amount_for_Milestone_1__c=1000.00,Title__c='Test',
                Planned_Amount_for_Milestone_2__c=1000.00,Planned_Amount_for_Milestone_3__c=1000.00,Planned_Amount_for_Milestone_4__c=1000.00,
                Payment_Milestone_1__c='Initiation of contract',Related_To__c=lprojects[0].Id,Payment_Milestone_2__c='Start of live phase',Payment_Milestone_3__c='End of live phase',Payment_Milestone_4__c='Upon receipt of results',PO__c='12121');
            insert oBudgetMaster;

            DRDW_Budget_Line_Item__c oLineItem = new DRDW_Budget_Line_Item__c(Related_To__c=oBudgetMaster.Id,Scientist_Owner__c=busAdm.Id,Vendor__c='TBD',Actual_Amount__c=123,PO__c='12121',Posting_Date__c=System.today());
            insert oLineItem;

            PageReference pageRef = new pageReference('/apex/DRDW_CreateBudgetMaster?Id='+oBudgetMaster.id+'&isEdit=false&isReport=true&capid='+lCapab[0].Id);         
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(oBudgetMaster);
            DRDW_CreateBudgetMaster controller = new DRDW_CreateBudgetMaster(sc);  
            controller.UpdateActivity();
            controller.save();
            test.stoptest();
            DRDW_Budget_Summary__c oBudSum = new DRDW_Budget_Summary__c(CurrencyIsoCode='EUR',F_X_Forecast__c=12.30,Year__c='2023',Quarter__c='2',Business_Plan__c=122.00,DRDW_Budget_Master__c=oBudgetMaster.Id,PO__c='TBD');
            insert oBudSum;
            controller.genericID=oBudSum.Id;
            controller.RemoveBudgetSummary();
            controller.genericID=oLineItem.Id;
            controller.getRefresh();
            controller.cancel();
            controller.edit();
        }
    }   

    static testMethod void testWithoutBudget() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {            
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Assessment Project');         
            insert lprojects;
            System.assert(lprojects.size()==2);
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
             System.assertNotEquals(null,lCapab,'error'); 
            DRDW_Cycle_Time_Standard__c oCycleStandard = new DRDW_Cycle_Time_Standard__c(Assessment_Cycle_Time_Standard_for_Small__c=1
                ,Assessment_Cycle_Time_Standard_for_Bioph__c=1,
                Assessment_Cycle_Time_Standard_for_Vacci__c=1);
            insert oCycleStandard;

            DRDW_Budget_Master__c oBudget = new DRDW_Budget_Master__c(Scientist_Owner__c=busAdm.id
                ,Title__c='test1'
                ,Activity_Name__c='test'
                ,Related_To__c =lprojects[0].Id);
            insert oBudget;

            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen;

            DRDW_Budget_Master__c oBudgetMaster = new DRDW_Budget_Master__c(Cost_Center__c=oCostCen.Id,Planned_Amount_for_Milestone_1__c=1000.00,
                Planned_Amount_for_Milestone_2__c=1000.00,Planned_Amount_for_Milestone_3__c=1000.00,Planned_Amount_for_Milestone_4__c=1000.00,
                Payment_Milestone_1__c='Initiation of contract',Related_To__c=lprojects[0].Id,Payment_Milestone_2__c='Start of live phase',Payment_Milestone_3__c='End of live phase',Payment_Milestone_4__c='Upon receipt of results');
            insert oBudgetMaster;

            PageReference pageRef = new pageReference('/apex/DRDW_CreateBudgetMaster?parentID='+lprojects[0].id+'&capid='+lCapab[0].Id);         
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(oBudgetMaster);
            DRDW_CreateBudgetMaster controller = new DRDW_CreateBudgetMaster(sc);            
            controller.UpdateActivity();
            test.stoptest();
            controller.save();
            controller.cancel();
            controller.edit();
            controller.RemoveBudgetSummary();
            controller.RemoveBudgetLine();
        }
    }   

    static testMethod void testwithBudget2() {        
        User finUsr = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(finUsr.id,'DRDW_Financial_User');
        System.runAs(finUsr) {     
            test.startTest();                 
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(1,'Idea Project');         
            insert lprojects;
            System.assert(lprojects.size()==1);

            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'External Activity',lprojects[0].id);
            insert lCapab;

            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 

            DRDW_Budget_Master__c oBudgetMaster = new DRDW_Budget_Master__c(CurrencyIsoCode='EUR',Total_F_X_Forecast__c=100.00,Total_Business_Plan__c=500.00,Cost_Center__c=oCostCen.Id,Planned_Amount_for_Milestone_1__c=1000.00,Title__c='Test',
                Planned_Amount_for_Milestone_2__c=1000.00,Planned_Amount_for_Milestone_3__c=1000.00,Planned_Amount_for_Milestone_4__c=1000.00,
                Payment_Milestone_1__c='Initiation of contract',Related_To__c=lprojects[0].Id,Payment_Milestone_2__c='Start of live phase',Payment_Milestone_3__c='End of live phase',Payment_Milestone_4__c='Upon receipt of results');
            insert oBudgetMaster;

            DRDW_Budget_Line_Item__c oLineItem = new DRDW_Budget_Line_Item__c(Related_To__c=oBudgetMaster.Id,Scientist_Owner__c=finUsr.Id,Vendor__c='TBD',Actual_Amount__c=123,PO__c='12121',Posting_Date__c=System.today());
            insert oLineItem;
            System.assertNotEquals(null,oLineItem,'error'); 
            PageReference pageRef = new pageReference('/apex/DRDW_CreateBudgetMaster?isEdit=false&isReport=true&parentID='+lprojects[0].Id+'&capid='+lCapab[0].Id+'&Id='+oBudgetMaster.id);         
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(oBudgetMaster);
            DRDW_CreateBudgetMaster controller = new DRDW_CreateBudgetMaster(sc); 
            test.stoptest();
            DRDW_Budget_Summary__c oBudSum = new DRDW_Budget_Summary__c(CurrencyIsoCode='EUR',F_X_Forecast__c=12.30,Year__c='2023',Quarter__c='2',Business_Plan__c=122.00,DRDW_Budget_Master__c=oBudgetMaster.Id,PO__c='TBD');
            insert oBudSum;
            controller.DeleteRecord();
            controller.getPicklist(lCapab);
            controller.AddBudgetLineItem();
            controller.genericID=oLineItem.Id;
            controller.RemoveBudgetLine();
            controller.addError('test error');
            controller.cancel();
        }
    }

    static testMethod void testwithBudget3() {        
        User finUsr = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(finUsr.id,'DRDW_Financial_User');
        System.runAs(finUsr) {     
            test.startTest();                 
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(1,'Idea Project');         
            insert lprojects;
            System.assert(lprojects.size()==1);

            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'External Activity',lprojects[0].id);
            insert lCapab;

            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 

            DRDW_Budget_Master__c oBudgetMaster = new DRDW_Budget_Master__c(CurrencyIsoCode='EUR',Total_F_X_Forecast__c=100.00,Total_Business_Plan__c=500.00,Cost_Center__c=oCostCen.Id,Planned_Amount_for_Milestone_1__c=1000.00,Title__c='Test',
                Planned_Amount_for_Milestone_2__c=1000.00,Planned_Amount_for_Milestone_3__c=1000.00,Planned_Amount_for_Milestone_4__c=1000.00,
                Payment_Milestone_1__c='Initiation of contract',Related_To__c=lprojects[0].Id,Payment_Milestone_2__c='Start of live phase',Payment_Milestone_3__c='End of live phase',Payment_Milestone_4__c='Upon receipt of results');
            insert oBudgetMaster;

            oBudgetMaster.PO__c='12312';
            update oBudgetMaster;

            DRDW_Budget_Line_Item__c oLineItem = new DRDW_Budget_Line_Item__c(Related_To__c=oBudgetMaster.Id,Scientist_Owner__c=finUsr.Id,Vendor__c='TBD',Actual_Amount__c=123,PO__c='12121',Posting_Date__c=System.today());
            insert oLineItem;

            PageReference pageRef = new pageReference('/apex/DRDW_CreateBudgetMaster?isEdit=false&isReport=true&parentID='+lprojects[0].Id+'&capid='+lCapab[0].Id);         
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(oBudgetMaster);
            DRDW_CreateBudgetMaster controller = new DRDW_CreateBudgetMaster(sc); 
            test.stoptest();
            DRDW_Budget_Summary__c oBudSum = new DRDW_Budget_Summary__c(CurrencyIsoCode='EUR',F_X_Forecast__c=12.30,Year__c='2023',Quarter__c='2',Business_Plan__c=122.00,DRDW_Budget_Master__c=oBudgetMaster.Id,PO__c='TBD');
            insert oBudSum;
            System.assertNotEquals(null,oBudSum,'error'); 
            DRDW_BudgetMasterTriggerHandler triggerHandler = new DRDW_BudgetMasterTriggerHandler();
            triggerHandler.getObjectRecordTypeId(DRDW_Capability__c.SObjectType,'External Activity');

            controller.rectype='assess';
            controller.DeleteRecord();
            controller.getPicklist(lCapab);
            controller.AddBudgetLineItem();
            controller.genericID=oLineItem.Id;
            controller.RemoveBudgetLine();
        }
    }
}