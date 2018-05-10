@isTest
private class Test_DRDW_ActivityTriggerHandler {
    static testMethod void testPositive() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');  
            lprojects[0].Project_Name__c='Test';
            lprojects[1].Idea_Name__c='Test';       
            insert lprojects;

            DRDW_Cap_Request__c ocapReq = new DRDW_Cap_Request__c(Lab_Testing_Required__c='Lab Challenge Preparation;Lab Vaccination Preparation',Samples_to_Collect_new__c='[Tissue Sample,Oral Swabs]',Project__c=lprojects[0].Id,Actual_Start_Date__c=System.today(),Actual_End_Date__c=System.today()+5,RecordTypeId=Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('GO').getRecordTypeId());
            insert ocapReq;
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(2, 'Request Activity',lprojects[0].id);
            lCapab[0].Title__c='Test';           
            list<DRDW_Capability__c> lCapabStudy = DRDW_TestDataFactory.returnCapabilities(1, 'Study Activity',lprojects[0].id);
            lCapabStudy[0].Title__c='Test';
            lCapabStudy[0].DRDW_Request__c=ocapReq.id; 
            lcapabstudy[0].Proposed_Start_Date__c = system.today();
            lCapab.addAll(lCapabStudy);
            test.startTest();
            insert lCapab;

            lCapab[1].DRDW_Request__c=ocapReq.id; 
            lCapab[0].DRDW_Request__c=ocapReq.id;
            lcapabstudy[0].Proposed_Start_Date__c = system.today()-2;
            update lCapab;
            
            System.assert(lCapab.size()>0);
            DRDW_Event__c oEvent = new DRDW_Event__c(/*Event_Dates__c='04/26/2017,05/26,2017',*/Type__c='GO',Status__c='Partially Assigned',DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='');
            insert oEvent;
            DRDW_Resource__c oResource = new DRDW_Resource__c(Name__c=busAdm.Id,Department__c='DDS',Type__c='ERL',Role__c='Functional Head',Hours_Available_Per_Day__c=10.00,Hours_per_Week__c=50.00,Status__c='Active',Days_Per_Week__c='7');
            insert oResource;
            
            DRDW_Event_Days__c oEvDay = new DRDW_Event_Days__c(Allocated_Hours__c=10.00,Date__c=System.today(),DRDW_Event__c=oEvent.Id,DRDW_Resource__c=oResource.Id,Type__c='GO');
            insert oEvDay;
            
            delete lCapab[0];
            test.stopTest();
        }
    } 

    static testMethod void testPositive1() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');  
            lprojects[0].Project_Name__c='Test';
            lprojects[1].Idea_Name__c='Test';       
            insert lprojects;

            DRDW_Cap_Request__c ocapReq = new DRDW_Cap_Request__c(Lab_Testing_Required__c='Lab Challenge Preparation;Lab Vaccination Preparation',Samples_to_Collect_new__c='[Tissue Sample,Oral Swabs]',Project__c=lprojects[0].Id,Actual_Start_Date__c=System.today(),Actual_End_Date__c=System.today()+5,RecordTypeId=Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('GO').getRecordTypeId(), GO_Preferred_Start_Date__c=system.today());
            insert ocapReq;
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(2, 'Request Activity',lprojects[0].id);
            lCapab[0].Title__c='Test';           
            list<DRDW_Capability__c> lCapabStudy = DRDW_TestDataFactory.returnCapabilities(1, 'Study Activity',lprojects[0].id);
            lCapabStudy[0].Title__c='Test';
            lCapabStudy[0].DRDW_Request__c=ocapReq.id; 
            lcapabstudy[0].Proposed_Start_Date__c = system.today();
            //lCapab.addAll(lCapabStudy);
            test.startTest();
            insert lcapabstudy;
            
            DRDW_Event__c oEvent = new DRDW_Event__c(/*Event_Dates__c='04/26/2017,05/26,2017',*/Type__c='GO',Status__c='Partially Assigned',DRDW_Activity__c=lCapabStudy[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='');
            insert oEvent;
            DRDW_Resource__c oResource = new DRDW_Resource__c(Name__c=busAdm.Id,Department__c='Animal Care',Type__c='GO',Role__c='Study Manager',Hours_Available_Per_Day__c=10.00,Hours_per_Week__c=50.00,Status__c='Active',Days_Per_Week__c='5');
            insert oResource;
            
            DRDW_Assign_resource__c oAssignResource = new DRDW_Assign_resource__c();
            oAssignResource.DRDW_Resources__c = oResource.id;
            oAssignResource.Allocation_End_Date__c =system.today().adddays(1);
            oAssignResource.Allocation_Start_Date__c = system.today();
            oAssignResource.DRDW_Event__c = oEvent.id;
            oAssignResource.Group__c = 'Animal Care';
            oAssignResource.Task__c = 'Other';
            oAssignResource.DRDW_Activity__c = lCapabStudy[0].Id;
            oAssignResource.Hours_Per_Day__c = 6;
            
            DRDW_Event_Days__c oEvDay = new DRDW_Event_Days__c(Allocated_Hours__c=10.00,Date__c=System.today(),DRDW_Event__c=oEvent.Id,DRDW_Resource__c=oResource.Id,Type__c='GO');
            insert oEvDay;
            
            List<BusinessHours> lstBusHour = [Select id from BusinessHours where name = 'DRDW_ERL_Business_Hours' limit 1];
            System.debug('Business hours in test'+lstBusHour);
            
            DRDW_Capability__c lCapabStudyNew = [select Id,Proposed_Start_Date__c from DRDW_Capability__c limit 1];
            
            system.debug('lCapabStudy '+lCapabStudy );

            lCapabStudyNew.Proposed_Start_Date__c = system.today()+2;
            update lCapabStudyNew;
            
            System.assert(lCapab.size()>0);
            
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

            DRDW_Cap_Request__c ocapReq = new DRDW_Cap_Request__c(Lab_Testing_Required__c='Lab Challenge Preparation;Lab Vaccination Preparation',Samples_to_Collect_new__c='[Tissue Sample,Oral Swabs]',Project__c=lprojects[0].Id,Actual_Start_Date__c=System.today(),Actual_End_Date__c=System.today()+5,RecordTypeId=Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('GO').getRecordTypeId(), GO_Preferred_Start_Date__c=system.today());
            insert ocapReq;
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(2, 'Request Activity',lprojects[0].id);
            lCapab[0].Title__c='Test';           
            list<DRDW_Capability__c> lCapabStudy = DRDW_TestDataFactory.returnCapabilities(1, 'Study Activity',lprojects[0].id);
            lCapabStudy[0].Title__c='Test';
            lCapabStudy[0].DRDW_Request__c=ocapReq.id; 
            lcapabstudy[0].Proposed_Start_Date__c = system.today();
            //lCapab.addAll(lCapabStudy);
            test.startTest();
            insert lcapabstudy;
            
            DRDW_Event__c oEvent = new DRDW_Event__c(/*Event_Dates__c='04/26/2017,05/26,2017',*/Type__c='GO',Go_Sub_Activities__c='[Animal Care - Misc.]',Status__c='Partially Assigned',DRDW_Activity__c=lCapabStudy[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='2');
            insert oEvent;
            DRDW_Resource__c oResource = new DRDW_Resource__c(Name__c=busAdm.Id,Department__c='Animal Care',Type__c='GO',Role__c='Study Manager',Hours_Available_Per_Day__c=10.00,Hours_per_Week__c=50.00,Status__c='Active',Days_Per_Week__c='7');
            insert oResource;
            
            DRDW_Assign_resource__c oAssignResource = new DRDW_Assign_resource__c();
            oAssignResource.DRDW_Resources__c = oResource.id;
            oAssignResource.Allocation_End_Date__c =system.today().adddays(1);
            oAssignResource.Allocation_Start_Date__c = system.today();
            oAssignResource.DRDW_Event__c = oEvent.id;
            oAssignResource.Group__c = 'Animal Care';
            oAssignResource.Task__c = 'Other';
            oAssignResource.DRDW_Activity__c = lCapabStudy[0].Id;
            oAssignResource.Hours_Per_Day__c = 6;
            
            insert oAssignResource;
            
            DRDW_Event_Days__c oEvDay = new DRDW_Event_Days__c(Allocated_Hours__c=10.00,Date__c=System.today(),DRDW_Event__c=oEvent.Id,DRDW_Resource__c=oResource.Id,Type__c='GO');
            insert oEvDay;
            
            List<BusinessHours> lstBusHour = [Select id from BusinessHours where name = 'DRDW_ERL_Business_Hours' limit 1];
            System.debug('Business hours in test'+lstBusHour);
            
            DRDW_Capability__c lCapabStudyNew = [select Id,Proposed_Start_Date__c from DRDW_Capability__c limit 1];
            
            system.debug('lCapabStudy '+lCapabStudy );

            lCapabStudyNew.Proposed_Start_Date__c = system.today()+2;
            update lCapabStudyNew;
            
            System.assert(lCapab.size()>0);
            
            test.stopTest();
        }
    } 



}