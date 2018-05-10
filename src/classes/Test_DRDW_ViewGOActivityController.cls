@istest
private class Test_DRDW_ViewGOActivityController{
    static testMethod void testPositive() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        DRDW_TestDataFactory.assignGroup(busAdm.id,'DRDW_FG_Bacteriology');
        DRDW_TestDataFactory.assignGroup(busAdm.id,'DRDW_BU_Business_Development');
        System.runAs(busAdm) {   
            List<DRDW_Project__c> lAssessments = DRDW_TestDataFactory.returnProjects(2,'Assessment Project');
            insert lAssessments;

            System.assert(lAssessments.size()==2);

            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 

            DRDW_Cap_Request__c ocapReq = new DRDW_Cap_Request__c(GO_Preferred_Start_Date__c=System.today()+2,Lab_Testing_Required__c='Lab Challenge Preparation;Lab Vaccination Preparation',samples_to_collect_new__c='[Tissue Sample,Oral Swabs]',Project__c=lAssessments[0].Id,Actual_Start_Date__c=System.today(),Actual_End_Date__c=System.today()+5,RecordTypeId=Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('GO').getRecordTypeId());
            insert ocapReq;
            
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Request Activity',lAssessments[0].id);
            lCapab[0].DRDW_Request__c=ocapReq.Id;
            insert lCapab;
            test.startTest();
            PageReference pagRef = new PageReference('/apex/DRDW_ViewGOActivity?id='+lCapab[0].Id+'&projId='+lAssessments[0].Id+'&reqId='+ocapReq.Id);
            Test.setCurrentPage(pagRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(lCapab[0]);
            DRDW_ViewGOActivityController controller = new DRDW_ViewGOActivityController(sc);
            controller.addError('Test');
            controller.genericID =lCapab[0].Id;
            controller.isbError = false;
            controller.isAdmin = false;
            controller.isFin = false;
            controller.isIdea = false;
            controller.isGeneration = false;
            System.assertNotEquals(null, ocapReq.Id, 'error');
            test.stopTest();
            
        }
    }

    static testMethod void testNegative() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        DRDW_TestDataFactory.assignGroup(busAdm.id,'DRDW_FG_Bacteriology');
        DRDW_TestDataFactory.assignGroup(busAdm.id,'DRDW_BU_Business_Development');
        System.runAs(busAdm) {   
            List<DRDW_Project__c> lAssessments = DRDW_TestDataFactory.returnProjects(2,'Assessment Project');
            insert lAssessments;

            System.assert(lAssessments.size()==2);

            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 

            DRDW_Cap_Request__c ocapReq = new DRDW_Cap_Request__c(Study_Title__c='test',GO_Preferred_Start_Date__c=System.today()+2,Lab_Testing_Required__c='Lab Challenge Preparation;Lab Vaccination Preparation',samples_to_collect_new__c='[Tissue Sample,Oral Swabs]',Project__c=lAssessments[0].Id,Actual_Start_Date__c=System.today(),Actual_End_Date__c=System.today()+5,RecordTypeId=Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('GO').getRecordTypeId());
            insert ocapReq;
            
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Request Activity',lAssessments[0].id);
            lCapab[0].DRDW_Request__c=ocapReq.Id;
            insert lCapab;
            test.startTest();
            PageReference pagRef = new PageReference('/apex/DRDW_ViewGOActivity?&projId='+lAssessments[0].Id+'&reqId='+ocapReq.Id);
            Test.setCurrentPage(pagRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(lCapab[0]);
            DRDW_ViewGOActivityController controller = new DRDW_ViewGOActivityController(sc);
            controller.addError('Test');
            System.assertNotEquals(null, ocapReq.Id, 'error');
            test.stopTest();
        }
    }
}