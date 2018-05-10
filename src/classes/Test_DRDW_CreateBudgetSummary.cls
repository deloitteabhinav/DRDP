/* Class Name  : Test_DRDW_CreateBudgetSummary
* Description  : Test Class for DRDW_CreateBudgetSummary
* Created By   : Deloitte
* Created Date : 1st March 2018
* Modification Log:  
* -----------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* -----------------------------------------------------------------------------------------------------
*/
@isTest(seeAllData=false)
private class Test_DRDW_CreateBudgetSummary {   
    static testMethod void testwithBudget() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {            
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Assessment Project');         
            insert lprojects;

            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Idea Capability',lprojects[0].id);
            insert lCapab;

            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 

            DRDW_Budget_Master__c oBudgetMaster = new DRDW_Budget_Master__c(CurrencyIsoCode='EUR',Total_F_X_Forecast__c=100.00,Total_Business_Plan__c=500.00,Cost_Center__c=oCostCen.Id,Planned_Amount_for_Milestone_1__c=1000.00,
                Planned_Amount_for_Milestone_2__c=1000.00,Planned_Amount_for_Milestone_3__c=1000.00,Planned_Amount_for_Milestone_4__c=1000.00,
                Payment_Milestone_1__c='Initiation of contract',Related_To__c=lprojects[0].Id,Payment_Milestone_2__c='Start of live phase',Payment_Milestone_3__c='End of live phase',Payment_Milestone_4__c='Upon receipt of results');
            insert oBudgetMaster;

            DRDW_Budget_Summary__c oBudSum = new DRDW_Budget_Summary__c(CurrencyIsoCode='EUR',F_X_Forecast__c=12.30,Year__c='2023',Quarter__c='2',Business_Plan__c=122.00,DRDW_Budget_Master__c=oBudgetMaster.Id,PO__c='TBD');
            insert oBudSum;
            test.startTest();

            DRDW_Budget_Line_Item__c oLineItem = new DRDW_Budget_Line_Item__c(Related_To__c=oBudgetMaster.Id,Scientist_Owner__c=busAdm.Id,Vendor__c='TBD',Actual_Amount__c=123,PO__c='12121',Posting_Date__c=System.today());
            insert oLineItem;
            System.assertNotEquals(null,oLineItem,'error');
            DRDW_Budget_Summary_Detail__c oBudSumDetail = new DRDW_Budget_Summary_Detail__c(DRDW_Budget_Summary__c=oBudSum.Id,Year__c='2018',Quarter__c='2',Month__c='Jan',Species__c='TBD');
            insert oBudSumDetail;
            
            PageReference pageRef = new pageReference('/apex/DRDW_CreateBudgetSummaryInfo?Id='+oBudSum.id+'&isEdit=false&budgetId='+oBudgetMaster.Id);         
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(oBudSum);
            DRDW_CreateBudgetSummary controller = new DRDW_CreateBudgetSummary(sc);  
            controller.save();
            controller.genericID=oBudSumDetail.Id;
            controller.RemoveBudgetDetail();
            controller.getRefresh();
            test.stoptest();
            controller.cancel();
            controller.edit();
            controller.DeleteRecord();
            controller.addError('test error');
        }
    }   

    static testMethod void testwithoutBudget() {        
        User finADm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(finADm.id,'DRDW_Financial_User');
        System.runAs(finADm) {            
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Assessment Project');         
            insert lprojects;

            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Idea Capability',lprojects[0].id);
            insert lCapab;

            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 

            DRDW_Budget_Master__c oBudgetMaster = new DRDW_Budget_Master__c(CurrencyIsoCode='EUR',Total_F_X_Forecast__c=100.00,Total_Business_Plan__c=500.00,Cost_Center__c=oCostCen.Id,Planned_Amount_for_Milestone_1__c=1000.00,
                Planned_Amount_for_Milestone_2__c=1000.00,Planned_Amount_for_Milestone_3__c=1000.00,Planned_Amount_for_Milestone_4__c=1000.00,
                Payment_Milestone_1__c='Initiation of contract',Related_To__c=lprojects[0].Id,Payment_Milestone_2__c='Start of live phase',Payment_Milestone_3__c='End of live phase',Payment_Milestone_4__c='Upon receipt of results');
            insert oBudgetMaster;

            DRDW_Budget_Summary__c oBudSum = new DRDW_Budget_Summary__c(CurrencyIsoCode='EUR',F_X_Forecast__c=12.30,Year__c='2023',Quarter__c='2',Business_Plan__c=122.00,DRDW_Budget_Master__c=oBudgetMaster.Id,PO__c='TBD');
            insert oBudSum;
            
            test.startTest();
            DRDW_Budget_Line_Item__c oLineItem = new DRDW_Budget_Line_Item__c(Related_To__c=oBudgetMaster.Id,Scientist_Owner__c=finADm.Id,Vendor__c='TBD',Actual_Amount__c=123,PO__c='12121',Posting_Date__c=System.today());
            insert oLineItem;
            System.assertNotEquals(null,oLineItem,'error'); 
            PageReference pageRef = new pageReference('/apex/DRDW_CreateBudgetSummaryInfo?budgetId='+oBudgetMaster.Id);         
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(oBudSum);
            DRDW_CreateBudgetSummary controller = new DRDW_CreateBudgetSummary(sc);  
            controller.save();
            controller.cancel();
            test.stoptest();
            controller.edit();
            controller.DeleteRecord();
            controller.addError('test error');
        }
    }   
}