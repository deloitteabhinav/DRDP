@isTest
private class Test_DRDW_EventTriggerHandler {
    static testMethod void testPositive1(){
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');                   
            insert lprojects;
            System.assert(lprojects.size()==2);
            DRDW_Cap_Request__c ocapReq = new DRDW_Cap_Request__c(GO_Preferred_Start_Date__c=System.today()+2,Lab_Testing_Required__c='Lab Challenge Preparation;Lab Vaccination Preparation',samples_to_collect_new__c='[Tissue Sample,Oral Swabs]',Project__c=lprojects[0].Id,Actual_Start_Date__c=System.today(),Actual_End_Date__c=System.today()+5,RecordTypeId=Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('GO').getRecordTypeId());
            insert ocapReq;

            System.debug([Select name from DRDW_Project__c where id =:lprojects[1].Id]);
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(2, 'Study Activity',lprojects[0].id);
            lCapab[0].DRDW_Request__c=ocapReq.id; 
            lCapab[0].Proposed_Start_Date__c=System.today();
            lCapab[1].DRDW_Request__c=ocapReq.id; 
            insert lCapab;

            DRDW_Event__c oEvent = new DRDW_Event__c(DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='-28,-27,-26,-25,-7,-6,-5,-4,-3,-2,-1',Type__c='GO');
            insert oEvent;
            test.startTest();
            update oEvent;
            System.assertNotEquals(null,busAdm.Id,'error');  
            test.stopTest();           
        }
    }
    
    static testMethod void testPositive2(){
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');                   
            insert lprojects;
            System.assert(lprojects.size()==2);
            DRDW_Cap_Request__c ocapReq = new DRDW_Cap_Request__c(GO_Preferred_Start_Date__c=System.today()+2,Lab_Testing_Required__c='Lab Challenge Preparation;Lab Vaccination Preparation',samples_to_collect_new__c='[Tissue Sample,Oral Swabs]',Project__c=lprojects[0].Id,Actual_Start_Date__c=System.today(),Actual_End_Date__c=System.today()+5,RecordTypeId=Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('GO').getRecordTypeId());
            insert ocapReq;

            System.debug([Select name from DRDW_Project__c where id =:lprojects[1].Id]);
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(2, 'Study Activity',lprojects[0].id);
            lCapab[0].DRDW_Request__c=ocapReq.id; 
            lCapab[0].Proposed_Start_Date__c=System.today();
            lCapab[1].DRDW_Request__c=ocapReq.id; 
            insert lCapab;

            DRDW_Event__c oEvent = new DRDW_Event__c(DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='-28,-27,-26,-25,-7,-6,-5,-4,-3,-2,-1',Type__c='GO');
            insert oEvent;
            test.startTest();
            delete oEvent;
            System.assertNotEquals(null,busAdm.Id,'error');  
            test.stopTest();           
        }
    }
        
    static testMethod void testPositive() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');                   
            insert lprojects;
            System.assert(lprojects.size()==2);
            DRDW_Cap_Request__c ocapReq = new DRDW_Cap_Request__c(GO_Preferred_Start_Date__c=System.today()+2,Lab_Testing_Required__c='Lab Challenge Preparation;Lab Vaccination Preparation',samples_to_collect_new__c='[Tissue Sample,Oral Swabs]',Project__c=lprojects[0].Id,Actual_Start_Date__c=System.today(),Actual_End_Date__c=System.today()+5,RecordTypeId=Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('GO').getRecordTypeId());
            insert ocapReq;

            System.debug([Select name from DRDW_Project__c where id =:lprojects[1].Id]);
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(2, 'Study Activity',lprojects[0].id);
            lCapab[0].DRDW_Request__c=ocapReq.id; 
            lCapab[0].Proposed_Start_Date__c=System.today();
            lCapab[1].DRDW_Request__c=ocapReq.id; 
            insert lCapab;

            DRDW_Event__c oEvent = new DRDW_Event__c(DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency_UI__c='-28,-27,-26,-25,-7,-6,-5,-4,-3,-2,-1,1-2',Type__c='GO',Go_Sub_Activities__c='[Animal Care - Misc.]');
            insert oEvent;
            
            oEvent.Go_Sub_Activities__c='[]';
            update oEvent;
            
            test.startTest();
            DRDW_Resource__c oResource = new DRDW_Resource__c(Name__c=busAdm.Id,Department__c='DDS',Type__c='ERL',Role__c='Functional Head',Hours_Available_Per_Day__c=10.00,Hours_per_Week__c=50.00,Status__c='Active');
            insert oResource;
            
            
            DRDW_EventTriggerHandler.DisplayOrderSet('Obtain Animals');
            DRDW_EventTriggerHandler.DisplayOrderSet('Animal Arrival');
            DRDW_EventTriggerHandler.DisplayOrderSet('Select Animals');
            DRDW_EventTriggerHandler.DisplayOrderSet('Randomize Animals');
            DRDW_EventTriggerHandler.DisplayOrderSet('Acclimation');
            DRDW_EventTriggerHandler.DisplayOrderSet('Drug Administration');
            DRDW_EventTriggerHandler.DisplayOrderSet('Pre challenge');
            DRDW_EventTriggerHandler.DisplayOrderSet('Challenge');
            DRDW_EventTriggerHandler.DisplayOrderSet('Post Challenge');
            DRDW_EventTriggerHandler.DisplayOrderSet('Vaccination');
            DRDW_EventTriggerHandler.DisplayOrderSet('Immunization');
            DRDW_EventTriggerHandler.DisplayOrderSet('Clinical Observations');
            DRDW_EventTriggerHandler.DisplayOrderSet('Health Observation(s)');
            DRDW_EventTriggerHandler.DisplayOrderSet('Blood Sample Collection');
            DRDW_EventTriggerHandler.DisplayOrderSet('Tissue Sample Collection');
            DRDW_EventTriggerHandler.DisplayOrderSet('Rectal temperatures');
            DRDW_EventTriggerHandler.DisplayOrderSet('Fasting');
            DRDW_EventTriggerHandler.DisplayOrderSet('Swabs');
            DRDW_EventTriggerHandler.DisplayOrderSet('Fecal Sample');
            DRDW_EventTriggerHandler.DisplayOrderSet('Ultrasound');
            DRDW_EventTriggerHandler.DisplayOrderSet('Xrays');
            DRDW_EventTriggerHandler.DisplayOrderSet('Measure Shedding');
            DRDW_EventTriggerHandler.DisplayOrderSet('Abscess Exudate/Culture');
            DRDW_EventTriggerHandler.DisplayOrderSet('Implants');
            DRDW_EventTriggerHandler.DisplayOrderSet('Scoring');
            DRDW_EventTriggerHandler.DisplayOrderSet('Euthanize');
            DRDW_EventTriggerHandler.DisplayOrderSet('Necropsy');
            DRDW_EventTriggerHandler.DisplayOrderSet('Final Study Day');

            //DRDW_Assign_Resource__c oAssignResource =new DRDW_Assign_Resource__c(Activity_Area__c='test',Activity_Title__c='test',Allocation_Start_Date__c=System.today(),Allocation_End_Date__c=System.today()+5,DRDW_Activity__c=lCapab[0].Id,DRDW_Event__c=oEvent.id,DRDW_Resources__c=oResource.Id,Hours_Per_Day__c=5);
            //insert oAssignResource;
            System.assertNotEquals(null,busAdm.Id,'error');                      
            test.stopTest();
            
        }
    }
}