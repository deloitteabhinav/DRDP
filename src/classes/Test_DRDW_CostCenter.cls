@isTest
private class Test_DRDW_CostCenter {
    static testMethod void testwithRecord() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {            
            DRDW_ND_Budget_Master__c nbudMaster = new DRDW_ND_Budget_Master__c(Year__c='2018');
            insert nbudMaster;
            System.assert(nbudMaster.id!=null);

            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 
            System.assert(oCostCen.id!=null);

            /*DRDW_ND_Budget_Detail__c nBudDetail = new DRDW_ND_Budget_Detail__c(DRDW_Cost_Center__c=oCostCen.Id,DRDW_ND_Budget_Master__c=nbudMaster.Id);
            insert nBudDetail;*/

            /*DRDW_NDBD_Category__c ncategD = new DRDW_NDBD_Category__c(Category__c = 'Alloc',DRDW_ND_Budget_Detail__c=nBudDetail.Id,Year__c='2018',Q1__c=100,Q2__c=110,Q3__c=101,Q4__c=201);
            insert ncategD;*/

            /*DRDW_NDBM_Category__c ncategM = new DRDW_NDBM_Category__c(DRDW_ND_Budget_Master__c=nbudMaster.Id,Year__c='2018',Q1__c=100,Q2__c=110,Q3__c=101,Q4__c=201);  
            insert ncategM;*/

            PageReference pageRef = new pageReference('/apex/DRDW_CostCenter?Id='+oCostCen.id);         
            Test.setCurrentPage(pageRef);

            ApexPages.StandardController sc = new ApexPages.StandardController(oCostCen);
            DRDW_CostCenter controller = new DRDW_CostCenter(sc);
            test.startTest();  
            controller.save();
            controller.getCostcenters();
            controller.selectedCostcntr=String.valueOf(oCostCen.Id);
            controller.RedirectCostcenter();
            controller.edit();
            controller.DeleteRecord();
            controller.copyField();
            controller.BudgetLink();
            test.stoptest();
        }
    }       

    static testMethod void testwithoutRecord() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {            
            DRDW_ND_Budget_Master__c nbudMaster = new DRDW_ND_Budget_Master__c(Year__c='2018');
            insert nbudMaster;
            System.assert(nbudMaster.id!=null);

            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');            

            /*DRDW_ND_Budget_Detail__c nBudDetail = new DRDW_ND_Budget_Detail__c(DRDW_Cost_Center__c=oCostCen.Id,DRDW_ND_Budget_Master__c=nbudMaster.Id);
            insert nBudDetail;*/

            /*DRDW_NDBD_Category__c ncategD = new DRDW_NDBD_Category__c(Category__c = 'Alloc',DRDW_ND_Budget_Detail__c=nBudDetail.Id,Year__c='2018',Q1__c=100,Q2__c=110,Q3__c=101,Q4__c=201);
            insert ncategD;*/

            /*DRDW_NDBM_Category__c ncategM = new DRDW_NDBM_Category__c(DRDW_ND_Budget_Master__c=nbudMaster.Id,Year__c='2018',Q1__c=100,Q2__c=110,Q3__c=101,Q4__c=201);  
            insert ncategM;*/

            PageReference pageRef = new pageReference('/apex/DRDW_CostCenter?');         
            Test.setCurrentPage(pageRef);

            ApexPages.StandardController sc = new ApexPages.StandardController(oCostCen);
            DRDW_CostCenter controller = new DRDW_CostCenter(sc);
            test.startTest();  
            controller.save();
            controller.getCostcenters();
            controller.selectedCostcntr=String.valueOf(oCostCen.Id);
            controller.RedirectCostcenter();
            controller.edit();
            controller.DeleteRecord();
            controller.copyField();
            controller.BudgetLink();
             System.assertNotEquals(null,busAdm.Id,'error');
            test.stoptest();
        }
    }       
}