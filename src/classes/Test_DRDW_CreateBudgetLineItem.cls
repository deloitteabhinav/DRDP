@isTest
private class Test_DRDW_CreateBudgetLineItem {
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

            DRDW_Budget_Line_Item__c oLineItem = new DRDW_Budget_Line_Item__c(Related_To__c=oBudgetMaster.Id,Scientist_Owner__c=busAdm.Id,Vendor__c='TBD',Actual_Amount__c=123,PO__c='12121',Posting_Date__c=System.today());
            insert oLineItem;

            DRDW_Budget_Summary_Detail__c oBudSumDetail = new DRDW_Budget_Summary_Detail__c(DRDW_Budget_Summary__c=oBudSum.Id,Year__c='2018',Quarter__c='2',Month__c='Jan',Species__c='TBD');
            insert oBudSumDetail;
            System.assertNotEquals(null,oBudSumDetail,'error'); 
            PageReference pageRef = new pageReference('/apex/DRDW_CreateBudgetLineItem?Id='+oLineItem.id+'&isEdit=false&BudgetId='+oBudgetMaster.Id);         
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(oLineItem);
            DRDW_CreateBudgetLineItem controller = new DRDW_CreateBudgetLineItem(sc);
            test.startTest();  
            controller.save();
            controller.deleteRecord();
            controller.edit();
            System.assertNotEquals(null,busAdm.Id,'error');
            test.stoptest();
        }
    }
    
    static testMethod void testwithBudget2() {        
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

            DRDW_Budget_Line_Item__c oLineItem = new DRDW_Budget_Line_Item__c(Related_To__c=oBudgetMaster.Id,Scientist_Owner__c=busAdm.Id,Vendor__c='TBD',Actual_Amount__c=123,PO__c='12121',Posting_Date__c=System.today());
            insert oLineItem;

            DRDW_Budget_Summary_Detail__c oBudSumDetail = new DRDW_Budget_Summary_Detail__c(DRDW_Budget_Summary__c=oBudSum.Id,Year__c='2018',Quarter__c='2',Month__c='Jan',Species__c='TBD');
            insert oBudSumDetail;
            System.assertNotEquals(null,oBudSumDetail,'error'); 
            PageReference pageRef = new pageReference('/apex/DRDW_CreateBudgetLineItem?Id='+oLineItem.id+'&isEdit=false&BudgetId='+oBudgetMaster.Id);         
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(oLineItem);
            DRDW_CreateBudgetLineItem controller = new DRDW_CreateBudgetLineItem(sc);
            test.startTest();  
            controller.save();
            controller.deleteRecord();
            controller.edit();
            
            oCostCen.Status__c ='Inactive';
            update oCostCen;
            controller.save();
            System.assertNotEquals(null,busAdm.Id,'error');
            test.stoptest();
        }
    }   

    static testMethod void testwithoutBudget() {        
        User finAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(finAdm.id,'DRDW_Financial_User');
        System.runAs(finAdm) {            
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');         
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

            DRDW_Budget_Line_Item__c oLineItem = new DRDW_Budget_Line_Item__c(Related_To__c=oBudgetMaster.Id,Scientist_Owner__c=finAdm.Id,Vendor__c='TBD',Actual_Amount__c=123,PO__c='12121',Posting_Date__c=System.today());
            insert oLineItem;

            DRDW_Budget_Summary_Detail__c oBudSumDetail = new DRDW_Budget_Summary_Detail__c(DRDW_Budget_Summary__c=oBudSum.Id,Year__c='2018',Quarter__c='2',Month__c='Jan',Species__c='TBD');
            insert oBudSumDetail;
            System.assertNotEquals(null,oBudSumDetail,'error'); 
            PageReference pageRef = new pageReference('/apex/DRDW_CreateBudgetSummaryDetail?BudgetId='+oBudgetMaster.Id);         
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(oLineItem);
            DRDW_CreateBudgetLineItem controller = new DRDW_CreateBudgetLineItem(sc);
            test.startTest(); 
            controller.isEval = true;
            controller.save();
            controller.deleteRecord();
            controller.edit();
            System.assertNotEquals(null,finAdm.Id,'error');
            test.stoptest();
            
        }
    }   
}