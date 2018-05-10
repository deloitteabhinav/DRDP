@isTest(seeAllData=False)
Private class Test_DRDW_RequestTrigger {
    Private Static testmethod void testPositive(){        
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
                    oReq.Lab_Testing_Required__c = 'Lab Challenge Preparation;Lab Blood: ELISA';
                    oReq.Samples_to_collect_new__c = '[Fecal Swabs,Challenge]';
                    oReq.Planned_Study_Start_Date__c = System.today();
                    oReq.Planned_Study_End_Date__c = System.today();
                    oReq.RecordTypeId = Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('GO').getRecordTypeId();
                    lstReq.add(oReq);
                insert lstReq;  
                    List<DRDW_Capability__c > lstActivity = new List<DRDW_Capability__c >();
                        DRDW_Capability__c oActivity = new DRDW_Capability__c();
                        oActivity.DRDW_Request__c = lstReq[0].id;
                        lstActivity.add(oActivity);
                        insert lstActivity;
                     oReq.Study_Title__c = 'TestTitle';
                update oReq;
                
                DRDW_Cap_Request__c oReq1 = new DRDW_Cap_Request__c();
                    oReq1.Study_Title__c = 'Test Title';
                    oReq1.Study_Type__c = 'RTV';
                    oReq1.Project__c = lprojects[0].id;
                    oReq1.Lab_Testing_Required__c = 'Lab Challenge Preparation;Lab Blood: PCR';
                    oReq1.Samples_to_collect_new__c = '[Fecal Swabs]';
                    oReq1.Planned_Study_Start_Date__c = System.today();
                    oReq1.Planned_Study_End_Date__c = System.today();
                    
                    oReq1.RecordTypeId = Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('GO').getRecordTypeId();
                    //lstReq.add(oReq);
                 DRDW_RequestTriggerHandler ReqTriggerHandler = new DRDW_RequestTriggerHandler();
                ReqTriggerHandler.UpdateReqActivity(lstReq);
                ReqTriggerHandler.leventInsertFinal = new List<DRDW_Event__c>();
                ReqTriggerHandler.mReqActivityId = new Map<Id,Id>{oReq.Id=>oReq.Id};
                ReqTriggerHandler.generateEvents(oReq,oReq1);
                delete oReq;
            }
            System.assertNotEquals(null,busAdm.Id,'error');
    }
}