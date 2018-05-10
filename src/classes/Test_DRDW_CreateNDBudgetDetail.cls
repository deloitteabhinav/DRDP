@isTest
private class Test_DRDW_CreateNDBudgetDetail {  
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

            DRDW_NDBD_Category__c ncateg = new DRDW_NDBD_Category__c(Category__c = 'Alloc',DRDW_ND_Budget_Detail__c=nBudDetail.Id,Year__c='2018',Q1__c=100,Q2__c=110,Q3__c=101,Q4__c=201);
            insert ncateg;
            System.assertNotEquals(null,ncateg,'error'); 
            PageReference pageRef = new pageReference('/apex/DRDW_CreateNDBudgetDetail?Id='+nBudDetail.id);         
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(nBudDetail);
            DRDW_CreateNDBudgetDetail controller = new DRDW_CreateNDBudgetDetail(sc);
            test.startTest();  
            controller.save();
            controller.edit();
            controller.updateDCategory();
            controller.CategoryLink();
            controller.ResetDCategory();
            test.stoptest();
        }
    }   
}