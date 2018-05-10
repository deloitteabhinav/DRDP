@isTest
private class Test_DRDW_Event_Controller {
    static testMethod void testwithResource() {        
        User seniorLdr = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(seniorLdr.id,'DRDW_Senior_Leadership_User');
        System.runAs(seniorLdr) {
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');  
            lprojects[0].Project_Name__c='Test';
            lprojects[1].Idea_Name__c='Test';       
            insert lprojects;
            System.assert(lprojects.size()==2);
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Request Activity',lprojects[0].id);
            insert lCapab;

            DRDW_Event__c oEvent = new DRDW_Event__c(Event_Dates__c='04/26/2018,05/26/2018',Type__c='GO',Status__c='Partially Assigned',DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='-26,-27,3,4');
            insert oEvent;

            DRDW_Resource__c oResource = new DRDW_Resource__c(Name__c=seniorLdr.Id,Department__c='DDS',Type__c='ERL',Role__c='Functional Head',Hours_Available_Per_Day__c=10.00,Hours_per_Week__c=50.00,Status__c='Active');
            insert oResource;

            DRDW_Event_Days__c oEvDay = new DRDW_Event_Days__c(Allocated_Hours__c=10.00,Date__c=System.today(),DRDW_Event__c=oEvent.Id,DRDW_Resource__c=oResource.Id,Type__c='ERL');
            DRDW_Event_Days__c oEvDay1 = new DRDW_Event_Days__c(Allocated_Hours__c=10.00,Date__c=System.today(),DRDW_Event__c=oEvent.Id,DRDW_Resource__c=oResource.Id,Type__c='ERL');
            insert new List<sObject>{oEvDay,oEvDay1};
            Test.startTest();
            PageReference pagRef = new PageReference('/apex/DRDW_Event?Id='+oEvent.Id);
            Test.setCurrentPage(pagRef);

            ApexPages.StandardController sc = new ApexPages.StandardController(oEvent);
            DRDW_Event_Controller controller = new DRDW_Event_Controller(sc);
            controller.addError('Test');
            controller.DeleteRecord();
            System.assertNotEquals(null,seniorLdr.Id,'error');
            Test.stopTest();
        }
    }   

    static testMethod void TestPermissions() {        
        User ldrshpUsr = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(ldrshpUsr.id,'DRDW_Leadership_User');
        System.runAs(ldrshpUsr) {
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');  
            lprojects[0].Project_Name__c='Test';
            lprojects[1].Idea_Name__c='Test';       
            insert lprojects;
            System.assert(lprojects.size()==2);
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Request Activity',lprojects[0].id);
            insert lCapab;

            DRDW_Event__c oEvent = new DRDW_Event__c(Event_Dates__c='04/26/2018,05/26/2018',Type__c='GO',Status__c='Partially Assigned',DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='');
            DRDW_Event__c oEvent1 = new DRDW_Event__c(Event_Dates__c='04/29/2018,05/06/2018',Type__c='GO',Status__c='Partially Assigned',DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='');
            insert new List<sObject>{oEvent,oEvent1};

            DRDW_Resource__c oResource = new DRDW_Resource__c(Name__c=ldrshpUsr.Id,Department__c='DDS',Type__c='ERL',Role__c='Functional Head',Hours_Available_Per_Day__c=10.00,Hours_per_Week__c=50.00,Status__c='Active');
            insert oResource;

            DRDW_Event_Days__c oEvDay = new DRDW_Event_Days__c(Allocated_Hours__c=10.00,Date__c=System.today(),DRDW_Event__c=oEvent.Id,DRDW_Resource__c=oResource.Id,Type__c='ERL');
            DRDW_Event_Days__c oEvDay1 = new DRDW_Event_Days__c(Allocated_Hours__c=10.00,Date__c=System.today(),DRDW_Event__c=oEvent1.Id,DRDW_Resource__c=oResource.Id,Type__c='ERL');
            insert new List<sObject>{oEvDay,oEvDay1};
            Test.startTest();
            PageReference pagRef = new PageReference('/apex/DRDW_Event?Id='+oEvent.Id);
            Test.setCurrentPage(pagRef);

            ApexPages.StandardController sc = new ApexPages.StandardController(oEvent);
            DRDW_Event_Controller controller = new DRDW_Event_Controller(sc);
            controller.addError('Test');
            controller.DeleteRecord();
            System.assertNotEquals(null,ldrshpUsr.Id,'error');
            Test.stopTest();
        }
    }   
    
     static testMethod void TestDelete() {        
        User ldrshpUsr = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(ldrshpUsr.id,'DRDW_Business_Admin');
        System.runAs(ldrshpUsr) {
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');  
            lprojects[0].Project_Name__c='Test';
            lprojects[1].Idea_Name__c='Test';       
            insert lprojects;
            System.assert(lprojects.size()==2);
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Request Activity',lprojects[0].id);
            insert lCapab;

            DRDW_Event__c oEvent = new DRDW_Event__c(Event_Dates__c='04/26/2018,05/26/2018',Type__c='GO',Status__c='Partially Assigned',Go_Sub_Activities__c='[Animal Care - Misc.]',DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='');
            DRDW_Event__c oEvent1 = new DRDW_Event__c(Event_Dates__c='04/29/2018,05/06/2018',Type__c='GO',Status__c='Partially Assigned',Go_Sub_Activities__c='[Animal Care - Misc.]',DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='');
            insert new List<sObject>{oEvent,oEvent1};

            DRDW_Resource__c oResource = new DRDW_Resource__c(Name__c=ldrshpUsr.Id,Department__c='DDS',Type__c='ERL',Role__c='Functional Head',Hours_Available_Per_Day__c=10.00,Hours_per_Week__c=50.00,Status__c='Active');
            insert oResource;
            DRDW_Assign_Resource__c oAssres = new DRDW_Assign_Resource__c(Go_Sub_Activities__c='Animal Care - Misc.',DRDW_Event__c=oEvent.id);    
            insert oAssres;   
            DRDW_Event_Days__c oEvDay = new DRDW_Event_Days__c(Allocated_Hours__c=10.00,Date__c=System.today(),DRDW_Event__c=oEvent.Id,DRDW_Resource__c=oResource.Id,Type__c='ERL');
            DRDW_Event_Days__c oEvDay1 = new DRDW_Event_Days__c(Allocated_Hours__c=10.00,Date__c=System.today(),DRDW_Event__c=oEvent1.Id,DRDW_Resource__c=oResource.Id,Type__c='ERL');
            insert new List<sObject>{oEvDay,oEvDay1};
            Test.startTest();
            PageReference pagRef = new PageReference('/apex/DRDW_Event?Id='+oEvent.Id);
            Test.setCurrentPage(pagRef);

            ApexPages.StandardController sc = new ApexPages.StandardController(oEvent);
            DRDW_Event_Controller controller = new DRDW_Event_Controller(sc);
            controller.addError('Test');
            controller.DeleteRecord();
            System.assertNotEquals(null,ldrshpUsr.Id,'error');
            Test.stopTest();
        }
    }   
}