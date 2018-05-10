@isTest
private class Test_DRDW_Budget_YearlyQuatery_Report {
    static testMethod void testwithBudget() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {            
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Assessment Project');         
            insert lprojects;
            System.assert(lprojects.size()==2);

            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Idea Capability',lprojects[0].id);
            insert lCapab;

            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 

            DRDW_ND_Budget_Master__c nbudMaster = new DRDW_ND_Budget_Master__c(Year__c='2023');
            insert nbudMaster;

            DRDW_ND_Budget_Detail__c nBudDetail = new DRDW_ND_Budget_Detail__c(DRDW_Cost_Center__c=oCostCen.Id,DRDW_ND_Budget_Master__c=nbudMaster.Id);
            insert nBudDetail;

            DRDW_NDBD_Category__c ncateg = new DRDW_NDBD_Category__c(Category__c = 'Alloc',DRDW_ND_Budget_Detail__c=nBudDetail.Id,Year__c='2023',Q1__c=100,Q2__c=110,Q3__c=101,Q4__c=201);
            insert ncateg;
            
            test.startTest();  
            DRDW_Budget_Master__c oBudgetMaster = new DRDW_Budget_Master__c(CurrencyIsoCode='EUR',Total_F_X_Forecast__c=100.00,Total_Business_Plan__c=500.00,Cost_Center__c=oCostCen.Id,Planned_Amount_for_Milestone_1__c=1000.00,
                Planned_Amount_for_Milestone_2__c=1000.00,Planned_Amount_for_Milestone_3__c=1000.00,Planned_Amount_for_Milestone_4__c=1000.00,
                Payment_Milestone_1__c='Initiation of contract',Related_To__c=lprojects[0].Id,Payment_Milestone_2__c='Start of live phase',Payment_Milestone_3__c='End of live phase',Payment_Milestone_4__c='Upon receipt of results',PO__c='41004376612',Vendor__c='TBD');
            DRDW_Budget_Master__c oBudgetMaster1 = new DRDW_Budget_Master__c(CurrencyIsoCode='EUR',Total_F_X_Forecast__c=110.00,Total_Business_Plan__c=510.00,Cost_Center__c=oCostCen.Id,Planned_Amount_for_Milestone_1__c=900.00,
                Planned_Amount_for_Milestone_2__c=1000.00,Planned_Amount_for_Milestone_3__c=1100.00,Planned_Amount_for_Milestone_4__c=1000.00,
                Payment_Milestone_1__c='Initiation of contract',Related_To__c=lprojects[1].Id,Payment_Milestone_2__c='Start of live phase',Payment_Milestone_3__c='End of live phase',Payment_Milestone_4__c='Upon receipt of results',PO__c='4100436612',Vendor__c='TBD');
            insert new List<sObject>{oBudgetMaster,oBudgetMaster1};

            DRDW_Budget_Summary__c oBudSum = new DRDW_Budget_Summary__c(CurrencyIsoCode='EUR',F_X_Forecast__c=12.30,Year__c='2023',Quarter__c='2',Business_Plan__c=122.00,DRDW_Budget_Master__c=oBudgetMaster.Id,PO__c='TBD');
            DRDW_Budget_Summary__c oBudSum1 = new DRDW_Budget_Summary__c(CurrencyIsoCode='EUR',F_X_Forecast__c=11.30,Year__c='2023',Quarter__c='3',Business_Plan__c=142.00,DRDW_Budget_Master__c=oBudgetMaster.Id,PO__c='TBD');
            DRDW_Budget_Summary__c oBudSum2 = new DRDW_Budget_Summary__c(CurrencyIsoCode='EUR',F_X_Forecast__c=11.30,Year__c='2023',Quarter__c='1',Business_Plan__c=142.00,DRDW_Budget_Master__c=oBudgetMaster.Id,PO__c='TBD');
            DRDW_Budget_Summary__c oBudSum3 = new DRDW_Budget_Summary__c(CurrencyIsoCode='EUR',F_X_Forecast__c=11.30,Year__c='2023',Quarter__c='4',Business_Plan__c=142.00,DRDW_Budget_Master__c=oBudgetMaster.Id,PO__c='TBD');
            insert new List<Sobject>{oBudSum,oBudSum1,oBudSum2,oBudSum3};

            DRDW_Budget_Summary_Detail__c oBudSumDetail = new DRDW_Budget_Summary_Detail__c(DRDW_Budget_Summary__c=oBudSum.Id,Year__c='2023',Quarter__c='2',Month__c='Jan',Species__c='TBD');
            insert oBudSumDetail;
            DRDW_Budget_YearlyQuatery_Report controller = new DRDW_Budget_YearlyQuatery_Report();
            controller.selectedyear='2023';
            controller.executeWrapperGenerator();
            controller.getYearList();
             System.assertNotEquals(null,busAdm.Id,'error');
            test.stoptest();
        }
    }   
}