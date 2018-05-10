@isTest(seeAllData=false)
private class Test_DRDW_CreateNDBudgetMaster{   
    static testMethod void testwithBudget() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {            
            DRDW_ND_Budget_Master__c nbudMaster = new DRDW_ND_Budget_Master__c(Year__c='2018');
            insert nbudMaster;

            DRDW_NDBM_Category__c ncateg = new DRDW_NDBM_Category__c(Category__c = 'Alloc',DRDW_ND_Budget_Master__c=nbudMaster.Id,Year__c='2018',Q1__c=100,Q2__c=110,Q3__c=101,Q4__c=201);
            insert ncateg;

            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 

            DRDW_ND_Budget_Detail__c nBudDetail = new DRDW_ND_Budget_Detail__c(DRDW_Cost_Center__c=oCostCen.Id,DRDW_ND_Budget_Master__c=nbudMaster.Id);
            insert nBudDetail;
            System.assertNotEquals(null,nBudDetail,'error');
            PageReference pageRef = new pageReference('/apex/DRDW_CreateNDBudgetMaster?Id='+nbudMaster.id);         
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(nbudMaster);
            DRDW_CreateNDBudgetMaster controller = new DRDW_CreateNDBudgetMaster(sc);
            test.startTest();  
            controller.save();
            controller.edit();
            controller.DetailLink();
            controller.CategoryLink();
            controller.AddCategory();
            controller.updateMCategory();
            controller.ResetMCategory();
            test.stoptest();
        }
    }   

    static testMethod void testwithoutBudget() {        
         User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {            
            DRDW_ND_Budget_Master__c nbudMaster = new DRDW_ND_Budget_Master__c(Year__c='2018');         

            DRDW_NDBM_Category__c ncateg = new DRDW_NDBM_Category__c(DRDW_ND_Budget_Master__c=nbudMaster.Id,Year__c='2018',Q1__c=100,Q2__c=110,Q3__c=101,Q4__c=201);  
            insert ncateg;

            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 

            DRDW_ND_Budget_Detail__c nBudDetail = new DRDW_ND_Budget_Detail__c(DRDW_Cost_Center__c=oCostCen.Id,DRDW_ND_Budget_Master__c=nbudMaster.Id);
            insert nBudDetail;
            System.assertNotEquals(null,nBudDetail,'error');
            PageReference pageRef = new pageReference('/apex/DRDW_CreateNDBudgetMaster');         
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(nbudMaster);
            DRDW_CreateNDBudgetMaster controller = new DRDW_CreateNDBudgetMaster(sc);
            test.startTest();  
            controller.save();
            controller.edit();
            test.stoptest();
        }
    }   
}