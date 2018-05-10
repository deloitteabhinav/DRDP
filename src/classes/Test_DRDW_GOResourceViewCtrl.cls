@isTest
private class Test_DRDW_GOResourceViewCtrl {
    static testMethod void testwithBudget() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');  
            lprojects[0].Project_Name__c='Test';
            lprojects[1].Idea_Name__c='Test';       
            insert lprojects;
            System.debug([Select name from DRDW_Project__c where id =:lprojects[1].Id]);
            
             Id reqRecType = DRDW_TestDataFactory.getObjectRecordTypeId(DRDW_Cap_Request__c.SObjectType, 'GO');
            
            DRDW_Cap_Request__c oCapReq = new DRDW_Cap_Request__c(Project__c=lprojects[1].Id,Study_Manager__c=busAdm.Id,recordtypeid=reqRecType );
            insert oCapReq;
            
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilitieswithreq(1, 'Idea Capability',lprojects[0].id,oCapReq.Id);
            insert lCapab;
            
            DRDW_Event__c oEvent = new DRDW_Event__c(DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='',Event_Dates_7_Day_Res__c='2018-03-01');
            insert oEvent;

            DRDW_Resource__c oResource = new DRDW_Resource__c(Name__c=busAdm.Id,Department__c='DDS',Type__c='ERL',Role__c='Functional Head',Hours_Available_Per_Day__c=10.00,Hours_per_Week__c=50.00,Status__c='Active',Days_Per_Week__c='7');
            insert oResource;

            DRDW_Event_Days__c oEvDay = new DRDW_Event_Days__c(Allocated_Hours__c=10.00,Date__c=System.today(),DRDW_Event__c=oEvent.Id,DRDW_Resource__c=oResource.Id,Type__c='GO');
            insert oEvDay;
            
            DRDW_Calender_Per_Roaster__c calPerRoaster = new DRDW_Calender_Per_Roaster__c();
            calPerRoaster.Allocated_Date__c = System.today();
            calPerRoaster.Allocated_Hours__c = 8;
            calPerRoaster.DRDW_Roaster__c = oResource.id;
            insert calPerRoaster;
            DRDW_Calender_Per_Roaster__c calPerRoaster1 = new DRDW_Calender_Per_Roaster__c();
            calPerRoaster1.Allocated_Date__c = System.today().addDays(1);
            calPerRoaster1.Allocated_Hours__c = 8;
            calPerRoaster1.DRDW_Roaster__c = oResource.id;
            insert calPerRoaster1;

            DRDW_GOResourceViewCtrl controller = new DRDW_GOResourceViewCtrl();
            controller.gogroup ='All';
            controller.executeWrapperGenerator();
            controller.executeWrapperGeneratorOnLoad();
            controller.executeWrapperGeneratorExport();
            controller.gogroup='Animal Care';
            controller.exportResource();
            controller.executeWrapperGenerator();
            
            System.assertNotEquals(null, calPerRoaster1.id, 'error');
        }
    }
}