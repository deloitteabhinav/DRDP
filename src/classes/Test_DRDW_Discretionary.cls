@isTest
private class Test_DRDW_Discretionary {
    
    static testMethod void testwithBudget() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {            
            DRDW_ND_Budget_Master__c nbudMaster = new DRDW_ND_Budget_Master__c(Year__c='2018');
            insert nbudMaster;

            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 

            DRDW_ND_Budget_Detail__c nBudDetail = new DRDW_ND_Budget_Detail__c(DRDW_Cost_Center__c=oCostCen.Id,DRDW_ND_Budget_Master__c=nbudMaster.Id);
            insert nBudDetail;

            DRDW_NDBD_Category__c ncategD = new DRDW_NDBD_Category__c(Category__c = 'Alloc',DRDW_ND_Budget_Detail__c=nBudDetail.Id,Year__c='2018',Q1__c=100,Q2__c=110,Q3__c=101,Q4__c=201);
            insert ncategD;

            DRDW_NDBM_Category__c ncategM = new DRDW_NDBM_Category__c(DRDW_ND_Budget_Master__c=nbudMaster.Id,Year__c='2018',Q1__c=100,Q2__c=110,Q3__c=101,Q4__c=201);  
            insert ncategM;
            System.assertNotEquals(null,ncategM,'error');
            DRDW_Discretionary controller = new DRDW_Discretionary();
            test.startTest();  
            controller.selectedCost=String.valueOf(oCostCen.Id);
            controller.displayMCategory();
            controller.updateMCategory();
            controller.updateDCategory();
            controller.ResetMCategory();
            controller.ResetDCategory();
            test.stoptest();
        }
    }   
    
}