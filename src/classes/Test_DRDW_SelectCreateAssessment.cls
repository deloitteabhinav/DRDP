@isTest
private class Test_DRDW_SelectCreateAssessment {
	static testMethod void testPositive() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {            
            List<DRDW_Project__c> lAssessments = DRDW_TestDataFactory.returnProjects(2,'Assessment Project');
            lAssessments[0].Molecule_Classification__c = 'Small Molecule';
            insert lAssessments;            
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(1,'Generation Project');
            insert lprojects;
            lAssessments[0].Related_Generation_Project__c=lprojects[0].Id;
            update lAssessments[0];	

            System.assert(lAssessments[0].Id!=null);
            ApexPages.StandardController sc = new ApexPages.StandardController(lAssessments[0]);
            DRDW_SelectCreateAssessment controller = new DRDW_SelectCreateAssessment(sc);
            controller.oStudy = lAssessments[0];
            controller.copyField();
            controller.GenerationId=lprojects[0].Id;
            controller.s='Test';
            controller.getObjectRecordTypeId(DRDW_Project__c.sobjectType,'Generation Project');
        }
    }
}