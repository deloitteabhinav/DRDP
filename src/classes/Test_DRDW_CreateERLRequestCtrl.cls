@isTest
private class Test_DRDW_CreateERLRequestCtrl {
    static testMethod void testPositive() {        
        User finUsr = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(finUsr.id,'DRDW_Financial_User');
        DRDW_TestDataFactory.assignGroup(finUsr.id,'DRDW_FG_Bacteriology');
        DRDW_TestDataFactory.assignGroup(finUsr.id,'DRDW_BU_CA_Parasitology');
        System.runAs(finUsr) {
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(1,'Generation Project');                   
            insert lprojects;
            System.assert(lprojects.size()==1);

            DRDW_Cap_Request__c ocapReq = new DRDW_Cap_Request__c(Do_you_know_your_Activities__c='Yes',GO_Preferred_Start_Date__c=System.today()+2,Lab_Testing_Required__c='Lab Challenge Preparation;Lab Vaccination Preparation',samples_to_collect_new__c='[Tissue Sample,Oral Swabs]',Project__c=lprojects[0].Id,Actual_Start_Date__c=System.today(),Actual_End_Date__c=System.today()+15,RecordTypeId=Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('GO').getRecordTypeId());
            insert ocapReq;
          
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(2, 'Request Activity',lprojects[0].id);
            lCapab[0].DRDW_Request__c=ocapReq.id; 
            lCapab[0].Proposed_Start_Date__c=System.today();
            lCapab[0].Planned_End_Date__c=System.today() +10;
            lCapab[1].Planned_End_Date__c=System.today() +13;
            lCapab[0].Title__c='Test';
            lCapab[1].Title__c='Test Idea';
            lCapab[1].DRDW_Request__c=ocapReq.id; 
            insert lCapab;

            GLBL_Global_List_of_Values__c oglov = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Capability').getRecordTypeId());
            GLBL_Global_List_of_Values__c oglov1 = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Capability').getRecordTypeId());
            GLBL_Global_List_of_Values__c oglov2 = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Capability Area').getRecordTypeId());
            GLBL_Global_List_of_Values__c oglov3 = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Capability Area').getRecordTypeId());
            insert new List<sObject>{oglov,oglov1,oglov2,oglov3};

            PageReference pageRef = new pageReference('/apex/DRDW_CreateERLRequest?Id='+ocapReq.Id+'&projid='+lprojects[0].id);
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(ocapReq);
            DRDW_CreateERLRequestCtrl controller = new DRDW_CreateERLRequestCtrl(sc);
            test.startTest();
            controller.copyField();
            controller.ActivityLink();
            controller.showActivity();
            controller.index=1;
            controller.saveActivities();
            controller.save();
            controller.cancelRecord();
            controller.showActivityOrSubmit();
            controller.oRequest.Do_you_know_your_Activities__c = 'No';
            controller.showActivityOrSubmit();
            controller.EditActivities();
            controller.addActivityRow();
            controller.oRequest.Do_you_know_your_Activities__c = 'Yes';
            controller.SendEmailNotifications();
            controller.oRequest.Do_you_know_your_Activities__c = 'No';
            controller.SendEmailNotifications();
            test.stopTest();
            controller.Edit();
            controller.oRequest.Do_you_know_your_Activities__c='Yes';
            controller.cancelRecord();
            controller.index=1;
            controller.subActivityRow();
            controller.DeleteRecord();
            controller.oRequest = null;
            controller.cancelRecord();
        }
    }

    static testMethod void testNegative() {        
        User studMgr = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(studMgr.id,'DRDW_Study_Managers');
        DRDW_TestDataFactory.assignGroup(studMgr.id,'DRDW_FG_Bacteriology');
        DRDW_TestDataFactory.assignGroup(studMgr.id,'DRDW_BU_CA_Parasitology');
        System.runAs(studMgr) {
            List<DRDW_Project__c> lprojInsert = new List<DRDW_Project__c>();
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(1,'Assessment Project');
            lprojects[0].Decision_To_Assess_DTA__c=System.today();
            lprojects[0].DP1_Planned_Date__c=System.today()+8;
            lprojInsert.addAll(lprojects); 
            List<DRDW_Project__c> lprojects1 = DRDW_TestDataFactory.returnProjects(1,'Idea Project');   
            lprojects1[0].Decision_to_Evaluate_DTE__c=System.today();
            lprojects1[0].CSF_Decision_to_Generate_DTG_Planned__c=System.today()+8;
            lprojInsert.addAll(lprojects1);              
            insert lprojInsert;
            System.assert(lprojInsert.size()==2);

            DRDW_Cap_Request__c ocapReq = new DRDW_Cap_Request__c(Do_you_know_your_Activities__c='Yes',GO_Preferred_Start_Date__c=System.today()+2,Lab_Testing_Required__c='Lab Challenge Preparation;Lab Vaccination Preparation',samples_to_collect_new__c='[Tissue Sample,Oral Swabs]',Project__c=lprojects[0].Id,Actual_Start_Date__c=System.today()+16,Actual_End_Date__c=System.today()+15,RecordTypeId=Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('GO').getRecordTypeId(),Planned_End_Date__c=System.today()+10,Planned_Start_Date__c=System.today()+15);
            insert ocapReq;
          
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(2, 'Request Activity',lprojects[0].id);
            lCapab[0].DRDW_Request__c=ocapReq.id; 
            lCapab[0].Proposed_Start_Date__c=System.today();
            lCapab[0].Planned_End_Date__c=System.today() +16;
            lCapab[1].Planned_End_Date__c=System.today() +13;
            lCapab[0].Actual_Start_Date__c=System.today()+17;
            lCapab[0].Actual_End_Date__c=System.today()+2;
            lCapab[0].Title__c='Test';
            lCapab[1].Title__c='Test Idea';
            lCapab[1].DRDW_Request__c=ocapReq.id;             

            GLBL_Global_List_of_Values__c oglov = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Capability').getRecordTypeId());
            GLBL_Global_List_of_Values__c oglov1 = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Capability').getRecordTypeId());
            GLBL_Global_List_of_Values__c oglov2 = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Capability Area').getRecordTypeId());
            GLBL_Global_List_of_Values__c oglov3 = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Capability Area').getRecordTypeId());
            insert new List<sObject>{oglov,oglov1,oglov2,oglov3};

            PageReference pageRef = new pageReference('/apex/DRDW_CreateERLRequest?projid='+lprojects[0].id);
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(ocapReq);
            DRDW_CreateERLRequestCtrl controller = new DRDW_CreateERLRequestCtrl(sc);  
            DRDW_CreateERLRequestCtrl.ActivityWrapper oActivity = new DRDW_CreateERLRequestCtrl.ActivityWrapper(0,true,true,true,lCapab[0]);
            DRDW_CreateERLRequestCtrl.ActivityWrapper oActivity1 = new DRDW_CreateERLRequestCtrl.ActivityWrapper(0,true,true,true,lCapab[1]);
            controller.lactivityWrapper = new List<DRDW_CreateERLRequestCtrl.ActivityWrapper>();
            controller.lactivityWrapper.add(oActivity);
            controller.lactivityWrapper.add(oActivity1);
            controller.index=0;
            controller.saveActivities();
            controller.oRequest.Planned_Start_Date__c=System.today()-10;  
            controller.save();   

            PageReference pageRef1 = new pageReference('/apex/DRDW_CreateERLRequest?projid='+lprojects1[0].id);
            Test.setCurrentPage(pageRef1);
            ApexPages.StandardController sc1 = new ApexPages.StandardController(ocapReq);
            DRDW_CreateERLRequestCtrl controller1 = new DRDW_CreateERLRequestCtrl(sc1);            
        }
    }
    
    static testMethod void testPositive2() {        
        User finUsr = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(finUsr.id,'DRDW_Financial_User');
        DRDW_TestDataFactory.assignGroup(finUsr.id,'DRDW_FG_Bacteriology');
        DRDW_TestDataFactory.assignGroup(finUsr.id,'DRDW_BU_CA_Parasitology');
        System.runAs(finUsr) {
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(1,'Idea Project');                   
            insert lprojects;
            System.assert(lprojects.size()==1);

            DRDW_Cap_Request__c ocapReq = new DRDW_Cap_Request__c(Do_you_know_your_Activities__c='Yes',GO_Preferred_Start_Date__c=System.today()+2,Lab_Testing_Required__c='Lab Challenge Preparation;Lab Vaccination Preparation',samples_to_collect_new__c='[Tissue Sample,Oral Swabs]',Project__c=lprojects[0].Id,Actual_Start_Date__c=System.today(),Actual_End_Date__c=System.today()+15,RecordTypeId=Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('GO').getRecordTypeId());
            insert ocapReq;
          
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(2, 'Request Activity',lprojects[0].id);
            lCapab[0].DRDW_Request__c=ocapReq.id; 
            lCapab[0].Proposed_Start_Date__c=System.today();
            lCapab[0].Planned_End_Date__c=System.today() +10;
            lCapab[1].Planned_End_Date__c=System.today() +13;
            lCapab[0].Title__c='Test';
            lCapab[1].Title__c='Test Idea';
            lCapab[1].DRDW_Request__c=ocapReq.id; 
            insert lCapab;

            GLBL_Global_List_of_Values__c oglov = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Capability').getRecordTypeId());
            GLBL_Global_List_of_Values__c oglov1 = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Capability').getRecordTypeId());
            GLBL_Global_List_of_Values__c oglov2 = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Capability Area').getRecordTypeId());
            GLBL_Global_List_of_Values__c oglov3 = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Capability Area').getRecordTypeId());
            insert new List<sObject>{oglov,oglov1,oglov2,oglov3};

            PageReference pageRef = new pageReference('/apex/DRDW_CreateERLRequest?Id='+ocapReq.Id+'&projid='+lprojects[0].id);
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(ocapReq);
            DRDW_CreateERLRequestCtrl controller = new DRDW_CreateERLRequestCtrl(sc);
            test.startTest();
            controller.copyField();
            controller.ActivityLink();
            controller.showActivity();
            controller.index=1;
            controller.saveActivities();
            controller.save();
            controller.cancelRecord();
            controller.showActivityOrSubmit();
            controller.oRequest.Do_you_know_your_Activities__c = 'No';
            controller.showActivityOrSubmit();
            controller.EditActivities();
            controller.addActivityRow();
            controller.oRequest.Do_you_know_your_Activities__c = 'Yes';
            controller.SendEmailNotifications();
            controller.oRequest.Do_you_know_your_Activities__c = 'No';
            controller.SendEmailNotifications();
            test.stopTest();
            controller.Edit();
            controller.oRequest.Do_you_know_your_Activities__c='Yes';
            controller.cancelRecord();
            controller.index=1;
            controller.subActivityRow();
            controller.DeleteRecord();
            controller.oRequest = null;
            controller.cancelRecord();
        }
    }
    
    static testMethod void testPositive3() {        
        User finUsr = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(finUsr.id,'DRDW_Financial_User');
        DRDW_TestDataFactory.assignGroup(finUsr.id,'DRDW_FG_Bacteriology');
        DRDW_TestDataFactory.assignGroup(finUsr.id,'DRDW_BU_CA_Parasitology');
        System.runAs(finUsr) {
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(1,'Assessment Project');                   
            insert lprojects;
            System.assert(lprojects.size()==1);

            DRDW_Cap_Request__c ocapReq = new DRDW_Cap_Request__c(Do_you_know_your_Activities__c='Yes',GO_Preferred_Start_Date__c=System.today()+2,Lab_Testing_Required__c='Lab Challenge Preparation;Lab Vaccination Preparation',samples_to_collect_new__c='[Tissue Sample,Oral Swabs]',Project__c=lprojects[0].Id,Actual_Start_Date__c=System.today(),Actual_End_Date__c=System.today()+15,RecordTypeId=Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('GO').getRecordTypeId());
            insert ocapReq;
          
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(2, 'Request Activity',lprojects[0].id);
            lCapab[0].DRDW_Request__c=ocapReq.id; 
            lCapab[0].Proposed_Start_Date__c=System.today();
            lCapab[0].Planned_End_Date__c=System.today() +10;
            lCapab[1].Planned_End_Date__c=System.today() +13;
            lCapab[0].Title__c='Test';
            lCapab[1].Title__c='Test Idea';
            lCapab[1].DRDW_Request__c=ocapReq.id; 
            insert lCapab;

            GLBL_Global_List_of_Values__c oglov = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Capability').getRecordTypeId());
            GLBL_Global_List_of_Values__c oglov1 = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Capability').getRecordTypeId());
            GLBL_Global_List_of_Values__c oglov2 = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Capability Area').getRecordTypeId());
            GLBL_Global_List_of_Values__c oglov3 = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Capability Area').getRecordTypeId());
            insert new List<sObject>{oglov,oglov1,oglov2,oglov3};

            PageReference pageRef = new pageReference('/apex/DRDW_CreateERLRequest?Id='+ocapReq.Id+'&projid='+lprojects[0].id);
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(ocapReq);
            DRDW_CreateERLRequestCtrl controller = new DRDW_CreateERLRequestCtrl(sc);
            test.startTest();
            controller.copyField();
            controller.ActivityLink();
            controller.showActivity();
            controller.index=1;
            controller.saveActivities();
            controller.save();
            controller.cancelRecord();
            controller.showActivityOrSubmit();
            controller.oRequest.Do_you_know_your_Activities__c = 'No';
            controller.showActivityOrSubmit();
            controller.EditActivities();
            controller.addActivityRow();
            controller.oRequest.Do_you_know_your_Activities__c = 'Yes';
            controller.SendEmailNotifications();
            controller.oRequest.Do_you_know_your_Activities__c = 'No';
            controller.SendEmailNotifications();
            test.stopTest();
            controller.Edit();
            controller.oRequest.Do_you_know_your_Activities__c='Yes';
            controller.cancelRecord();
            controller.index=1;
            controller.subActivityRow();
            controller.DeleteRecord();
            controller.showActivityOrSubmit();
            controller.oRequest = null;
            controller.cancelRecord();
            
            
        }
    }
    
     static testMethod void testPositive4() {        
        User finUsr = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(finUsr.id,'DRDW_Financial_User');
        DRDW_TestDataFactory.assignGroup(finUsr.id,'DRDW_FG_Bacteriology');
        DRDW_TestDataFactory.assignGroup(finUsr.id,'DRDW_BU_CA_Parasitology');
        System.runAs(finUsr) {
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(1,'Assessment Project');                   
            insert lprojects;
            System.assert(lprojects.size()==1);

            DRDW_Cap_Request__c ocapReq = new DRDW_Cap_Request__c(Do_you_know_your_Activities__c='Yes',GO_Preferred_Start_Date__c=System.today()+2,Lab_Testing_Required__c='Lab Challenge Preparation;Lab Vaccination Preparation',samples_to_collect_new__c='[Tissue Sample,Oral Swabs]',Project__c=lprojects[0].Id,Actual_Start_Date__c=System.today(),Actual_End_Date__c=System.today()+15,RecordTypeId=Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('GO').getRecordTypeId());
            insert ocapReq;
          
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(2, 'Request Activity',lprojects[0].id);
            lCapab[0].DRDW_Request__c=ocapReq.id; 
            lCapab[0].Proposed_Start_Date__c=System.today();
            lCapab[0].Planned_End_Date__c=System.today() +10;
            lCapab[1].Planned_End_Date__c=System.today() +13;
            lCapab[0].Title__c='Test';
            lCapab[1].Title__c='Test Idea';
            lCapab[1].DRDW_Request__c=ocapReq.id; 
            insert lCapab;

            GLBL_Global_List_of_Values__c oglov = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Capability').getRecordTypeId());
            GLBL_Global_List_of_Values__c oglov1 = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Capability').getRecordTypeId());
            GLBL_Global_List_of_Values__c oglov2 = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Capability Area').getRecordTypeId());
            GLBL_Global_List_of_Values__c oglov3 = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Capability Area').getRecordTypeId());
            insert new List<sObject>{oglov,oglov1,oglov2,oglov3};

            PageReference pageRef = new pageReference('/apex/DRDW_CreateERLRequest?Id='+ocapReq.Id+'&projid='+lprojects[0].id);
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(ocapReq);
            DRDW_CreateERLRequestCtrl controller = new DRDW_CreateERLRequestCtrl(sc);
            test.startTest();
            PageReference pageRef2 = new pageReference('/apex/DRDW_CreateERLRequest?Id='+ocapReq.Id);
            Test.setCurrentPage(pageRef2);
            DRDW_CreateERLRequestCtrl controller1 = new DRDW_CreateERLRequestCtrl(sc);
            PageReference pageRef3 = new pageReference('/apex/DRDW_CreateERLRequest');
            Test.setCurrentPage(pageRef3);
            DRDW_CreateERLRequestCtrl controller2 = new DRDW_CreateERLRequestCtrl(sc);
            test.stopTest();
            
        }
    }
}