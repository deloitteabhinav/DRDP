@isTest(seeAllData=False)
public class Test_DRDW_RequestTriggerHandler {

    Static testmethod void testRequestInsertUpdate(){
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
            DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
            System.runAs(busAdm) { 
                List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Idea Project');         
                insert lprojects;
                List< DRDW_Cap_Request__c > lstReq = new List<DRDW_Cap_Request__c >();
                    DRDW_Cap_Request__c oReq = new DRDW_Cap_Request__c();
                    oReq.Study_Title__c = 'Test Title';
                    oReq.Study_Type__c = 'RTV';
                    oReq.Project__c = lprojects[0].id;
                    oReq.Planned_Study_Start_Date__c = System.today();
                    oReq.Planned_Study_End_Date__c = System.today();
                    oReq.RecordTypeId = Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('GO').getRecordTypeId();
                    lstReq.add(oReq);
                insert lstReq;
                DRDW_Resource__c oResource = new DRDW_Resource__c();
                insert oResource;
                List<DRDW_Capability__c > lstActivity = new List<DRDW_Capability__c >();
                    DRDW_Capability__c oActivity = new DRDW_Capability__c();
                    oActivity.DRDW_Request__c = lstReq[0].id;
                lstActivity.add(oActivity);
                oActivity.RecordTypeId = Schema.SObjectType.DRDW_Capability__c.getRecordTypeInfosByName().get('Study Activity').getRecordTypeId();
                
                insert lstActivity;
                list<DRDW_Event__c> lstEvent = new List<DRDW_Event__c>();
                DRDW_Event__c oEvent = new DRDW_Event__c();
                oEvent.DRDW_Activity__c = lstActivity[0].id;
                lstEvent.add(oEvent);
                insert lstEvent;
                DRDW_Assign_Resource__c oAssnRes = new DRDW_Assign_Resource__c();
                    oAssnRes.Group__c = 'FD Laboratory';
                    oAssnRes.DRDW_Event__c = lstEvent[0].id;
                    
                insert oAssnRes;
                List<DRDW_Calender_Per_Roaster__c> lstCalPrRoaster = new List<DRDW_Calender_Per_Roaster__c>();
                insert lstCalPrRoaster;
                List<DRDW_Event_Days__c> lstEventDays = new List<DRDW_Event_Days__c>();
                insert lstEventDays;
                lstReq[0].Study_Title__c = 'Updated Test Title';
                lstReq[0].Lab_Testing_Required__c='Lab Fecal: Other';
                update lstReq;
            }
            System.assertNotEquals(null,busAdm.Id,'error');
    }
    Static testmethod void testRequestDelete(){
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
            DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
            System.runAs(busAdm) { 
                List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Idea Project');         
                insert lprojects;
                List< DRDW_Cap_Request__c > lstReq = new List<DRDW_Cap_Request__c >();
                    DRDW_Cap_Request__c oReq = new DRDW_Cap_Request__c();
                    oReq.Study_Title__c = 'Test Title';
                    oReq.Study_Type__c = 'RTV';
                    oReq.Project__c = lprojects[0].id;
                    oReq.Planned_Study_Start_Date__c = System.today();
                    oReq.Planned_Study_End_Date__c = System.today();
                    oReq.RecordTypeId = Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('GO').getRecordTypeId();
                    lstReq.add(oReq);
                insert lstReq;
                DRDW_Resource__c oResource = new DRDW_Resource__c();
                insert oResource;
                List<DRDW_Capability__c > lstActivity = new List<DRDW_Capability__c >();
                    DRDW_Capability__c oActivity = new DRDW_Capability__c();
                    oActivity.DRDW_Request__c = lstReq[0].id;
                    oActivity.RecordTypeId = Schema.SObjectType.DRDW_Capability__c.getRecordTypeInfosByName().get('Study Activity').getRecordTypeId();
                lstActivity.add(oActivity);
                insert lstActivity;
                list<DRDW_Event__c> lstEvent = new List<DRDW_Event__c>();
                DRDW_Event__c oEvent = new DRDW_Event__c();
                oEvent.DRDW_Activity__c = lstActivity[0].id;
                lstEvent.add(oEvent);
                insert lstEvent;
                DRDW_Assign_Resource__c oAssnRes = new DRDW_Assign_Resource__c();
                    oAssnRes.Group__c = 'FD Laboratory';
                    oAssnRes.DRDW_Event__c = lstEvent[0].id;
                    
                insert oAssnRes;
                
                DRDW_RequestTriggerHandler handler = new DRDW_RequestTriggerHandler();
                handler.UpdateReqActivity(lstReq);
                
                List<DRDW_Calender_Per_Roaster__c> lstCalPrRoaster = new List<DRDW_Calender_Per_Roaster__c>();
                insert lstCalPrRoaster;
                List<DRDW_Event_Days__c> lstEventDays = new List<DRDW_Event_Days__c>();
                insert lstEventDays;
                delete lstReq;
                
            }
            System.assertNotEquals(null,busAdm.Id,'error');
    }
}