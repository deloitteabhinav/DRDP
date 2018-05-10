@isTest
private class Test_DRDW_ActivityERLFlow {
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
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(4, 'Request Activity',lprojects[0].id);
            lCapab[0].Title__c='Test';   
            lCapab[0].Type__c='ERL';       
            lCapab[1].Type__c='GO';     
            lCapab[2].Type__c='ERL';       
            lCapab[3].Type__c='GO'; 
            test.startTest();
            insert lCapab;
            System.assert(lCapab.size()>0);

            DRDW_Event__c oEvent = new DRDW_Event__c(Event_Dates__c='04/26/2017,05/26,2017',Type__c='GO',Status__c='Partially Assigned',DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='');
            DRDW_Event__c oEvent1 = new DRDW_Event__c(Event_Dates__c='04/26/2017,05/26,2017',Type__c='ERL',Status__c='Partially Assigned',DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='');
            insert new List<sObject>{oEvent,oEvent1};
            DRDW_ActivityERLFlow.createERLEventDays(lCapab, new List<DRDW_Event__c>{oEvent,oEvent1});
            DRDW_ActivityERLFlow.deleteERLEvent(lCapab);
            test.stopTest();
        }
    }   
    static testMethod void testPositive2() {        
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
            test.startTest();
            insert lCapab;
            System.assert(lCapab.size()>0);

            list<DRDW_Capability__c> lCapab1 = DRDW_TestDataFactory.returnCapabilities(1, 'Request Activity',lprojects[0].id);
            lCapab1[0].Planned_Start_Date__c  = system.today();
            lCapab1[0].Planned_End_Date__c = system.today().addDays(3);
            DRDW_Event__c oEvent = new DRDW_Event__c(Event_Dates__c='04/26/2017,05/26,2017',Type__c='GO',Status__c='Partially Assigned',DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='');
            DRDW_Event__c oEvent1 = new DRDW_Event__c(Event_Dates__c='04/26/2017,05/26,2017',Type__c='ERL',Status__c='Partially Assigned',DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='');
            insert new List<sObject>{oEvent,oEvent1};            
            DRDW_ActivityERLFlow.createERLEventDays(lCapab, new List<DRDW_Event__c>{oEvent});
            DRDW_ActivityERLFlow.deleteERLEvent(lCapab1);
            test.stopTest();
        }
    }   
}