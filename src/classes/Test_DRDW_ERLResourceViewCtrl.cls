@isTest(seealldata=false)
private class Test_DRDW_ERLResourceViewCtrl {
    static testMethod void testwithBudget() {   
        Profile p = [SELECT id, Name FROM Profile where name = 'System Administrator'].get(0);     
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        busAdm.profileId= p.id;
        update busAdm;
        System.runAs(busAdm) {
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');  
            lprojects[0].Project_Name__c='Test';
            lprojects[1].Idea_Name__c='Test';       
            insert lprojects;
            
            System.assert(lprojects.size()==2);            
            
            DRDW_Cap_Request__c oCapReq = new DRDW_Cap_Request__c(Project__c=lprojects[1].Id,Study_Manager__c=busAdm.Id);
            insert oCapReq;
            
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilitieswithreq(1, 'Idea Capability',lprojects[0].id,oCapReq.Id);
            insert lCapab;

            DRDW_Event__c oEvent = new DRDW_Event__c(DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='');
            insert oEvent;

            DRDW_Resource__c oResource = new DRDW_Resource__c(Name__c=busAdm.Id,Department__c='DDS',Type__c='ERL',Role__c='Functional Head',Hours_Available_Per_Day__c=10.00,Hours_per_Week__c=50.00,Status__c='Active');
            insert oResource;

            DRDW_Event_Days__c oEvDay = new DRDW_Event_Days__c(Allocated_Hours__c=10.00,Date__c=System.today(),DRDW_Event__c=oEvent.Id,DRDW_Resource__c=oResource.Id,Type__c='ERL');
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

            DRDW_ERLResourceViewCtrl controller = new DRDW_ERLResourceViewCtrl();
            controller.activitArea='All';
            controller.executeWrapperGenerator();
            controller.executeWrapperGeneratorOnLoad();
            controller.executeWrapperGeneratorExport();
            controller.activitArea='DDS';
            controller.exportResource();
            controller.executeWrapperGenerator();
            controller.mActivity = new Map<Id,DRDW_Capability__c>();
            controller.mActivity.put(lCapab[0].id,lCapab[0]);
            controller.jsonGenerator();
            System.assertNotEquals(null, calPerRoaster1.id, 'error');
        }
    }
}