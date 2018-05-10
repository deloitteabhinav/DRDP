@isTest
private class Test_DRDW_StudyScheduleBuilder {
     static testMethod void testPositive() {   
          User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');  
            lprojects[0].Project_Name__c='Test';
            lprojects[1].Idea_Name__c='Test';       
            insert lprojects;

            DRDW_Cap_Request__c ocapReq = new DRDW_Cap_Request__c(Lab_Testing_Required__c='Lab Challenge Preparation;Lab Vaccination Preparation',samples_to_collect_new__c='[Tissue Sample,Oral Swabs]',Project__c=lprojects[0].Id,Actual_Start_Date__c=System.today(),Actual_End_Date__c=System.today()+5,RecordTypeId=Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('GO').getRecordTypeId());
            insert ocapReq;
            
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Request Activity',lprojects[0].id);
            lCapab[0].Title__c='Test';   
            lCapab[0].Planned_End_Date__c=System.today()+1;
            lCapab[0].Type__c='GO';    
            lCapab[0].DRDW_Request__c = ocapReq.id;            
            insert lCapab;
            
            DRDW_Event__c oEve= new DRDW_Event__c();
            oEve.Type__c ='GO';
            oEve.DRDW_Activity__c = lCapab[0].id;
            oEve.Status__c = 'Unassigned';
            oEve.Event_Type__c = 'Test';
            oEve.Frequency_UI__c = '1';
            oEve.Go_Sub_Activities__c ='[Animal Care - Misc.]';
            insert oEve;
            
            
            test.startTest();
            PageReference pageRef = new pageReference('/apex/DRDW_ScheduleBuilder?reqId='+ocapReq.id);
            Test.setCurrentPage(pageRef);
            DRDW_StudyScheduleBuilder controller = new DRDW_StudyScheduleBuilder();            
            controller.index = 1;
            controller.editSubAct();
            controller.saveEvent();
            controller.subEventRow();
            controller.AddEventRow();            
            Test.stopTest();
        }
        System.assertNotEquals(null,busAdm.Id,'error');
     }
}