@isTest
private class Test_DRDW_AssignResourceTriggerHandler {
    static testMethod void testwithResource() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');  
            lprojects[0].Project_Name__c='Test';
            lprojects[1].Idea_Name__c='Test';       
            insert lprojects;

            System.assert(lprojects.size()==2);
            DRDW_Cap_Request__c ocapReq = new DRDW_Cap_Request__c(GO_Preferred_Start_Date__c=System.today()+2,Lab_Testing_Required__c='Lab Challenge Preparation;Lab Vaccination Preparation',samples_to_collect_new__c='[Tissue Sample,Oral Swabs]',Project__c=lprojects[0].Id,Actual_Start_Date__c=System.today(),Actual_End_Date__c=System.today()+5,RecordTypeId=Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('ERL').getRecordTypeId());
            insert ocapReq;

            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Request Activity',lprojects[0].id);
            lCapab[0].DRDW_Request__c = ocapReq.Id;
            insert lCapab;

            DRDW_Event__c oEvent = new DRDW_Event__c(/*Event_Dates__c='04/26/2017,05/26,2017',*/Type__c='GO',Status__c='Partially Assigned',DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Go_Sub_Activities__c='[Animal Care - Misc.]',Event_Type__c='Lab Work Required',Frequency__c='-27,-28,3,4');
            insert oEvent;

            DRDW_Resource__c oResource = new DRDW_Resource__c(Name__c=busAdm.Id,Department__c='DDS',Type__c='ERL',Role__c='Functional Head',Hours_Available_Per_Day__c=10.00,Hours_per_Week__c=50.00,Status__c='Active');
            insert oResource;

            DRDW_Event_Days__c oEvDay = new DRDW_Event_Days__c(Allocated_Hours__c=10.00,Date__c=System.today(),DRDW_Event__c=oEvent.Id,DRDW_Resource__c=oResource.Id,Type__c='ERL');
            DRDW_Event_Days__c oEvDay1 = new DRDW_Event_Days__c(Allocated_Hours__c=10.00,Date__c=System.today(),DRDW_Event__c=oEvent.Id,DRDW_Resource__c=oResource.Id,Type__c='ERL');
            insert new List<sObject>{oEvDay,oEvDay1};
            Test.startTest();
            System.assertNotEquals(null,oResource); 
            DRDW_Assign_Resource__c oAssignResource =new DRDW_Assign_Resource__c(Activity_Area__c='test',Activity_Title__c='test',Allocation_Start_Date__c=System.today(),Allocation_End_Date__c=System.today()+5,DRDW_Activity__c=lCapab[0].Id,DRDW_Event__c=oEvent.id,DRDW_Resources__c=oResource.Id,Hours_Per_Day__c=5);
            insert oAssignResource;
            delete oAssignResource;
            
            Test.stopTest();
        }
    }
}