@isTest
private class Test_DRDW_CreateGORequestCtrl {
    static testMethod void testPositive() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Study_Managers');
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Scientist');
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_GO_User');
        DRDW_TestDataFactory.assignGroup(busAdm.id,'DRDW_FG_Bacteriology');
        DRDW_TestDataFactory.assignGroup(busAdm.id,'DRDW_BU_Business_Development');
        System.runAs(busAdm) {   
            List<DRDW_Project__c> lAssessments = DRDW_TestDataFactory.returnProjects(1,'Assessment Project');
            insert lAssessments;

            System.assert(lAssessments.size()==1);

            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 

            DRDW_Cap_Request__c ocapReq = new DRDW_Cap_Request__c(GO_Preferred_Start_Date__c=System.today()+2,Lab_Testing_Required__c='Lab Challenge Preparation;Lab Vaccination Preparation',samples_to_collect_new__c='[Tissue Sample,Oral Swabs]',Project__c=lAssessments[0].Id,Actual_Start_Date__c=System.today(),Actual_End_Date__c=System.today()+5,RecordTypeId=Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('ERL').getRecordTypeId(),Request_Status__c = 'Re-Submit: Change Request' );
            insert ocapReq;
            
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Request Activity',lAssessments[0].id);
            lCapab[0].DRDW_Request__c=ocapReq.Id;
            insert lCapab;

            GLBL_Global_List_of_Values__c oglov = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('DRDW Samples To Collect').getRecordTypeId());
            insert oglov;

            DRDW_Event__c oEvent = new DRDW_Event__c(/*Event_Dates__c='04/26/2018,05/26/2018',*/Type__c='GO',Status__c='Partially Assigned',DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='-27,-3,2,3');
            insert oEvent;

            PageReference pagRef = new PageReference('/apex/DRDW_CreateGORequest?id='+ocapReq.Id);
            Test.setCurrentPage(pagRef);
            test.StartTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(ocapReq);
            DRDW_CreateGORequestCtrl controller = new DRDW_CreateGORequestCtrl(sc);
            controller.EventId=oEvent.Id;
            controller.Editable();
            controller.AllEditable();
            controller.deleteEvent();
            controller.Submit();
            controller.oRequest.Request_Status__c ='Draft';
            controller.Submit();
            controller.edit();
            controller.addActivity();
            controller.SaveEditable();
            controller.allSave();
            controller.addError('Test');
            controller.save();
            controller.isOnlyGoUser=true;
            controller.oRequest.Request_Status__c = 'Submitted';
            controller.CheckIfGoUserandFirsttime();
            test.stopTest();
            controller.SettingDate();
            controller.deleteRecord();
            
        }
    }   

    static testMethod void testPositiveWithoutCurrent() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        DRDW_TestDataFactory.assignGroup(busAdm.id,'DRDW_FG_Bacteriology');
        DRDW_TestDataFactory.assignGroup(busAdm.id,'DRDW_BU_Business_Development');
        System.runAs(busAdm) {   
            List<DRDW_Project__c> lAssessments = DRDW_TestDataFactory.returnProjects(1,'Generation Project');
            lAssessments[0].Decision_to_Generate_DTG__c=System.today();
            lAssessments[0].Decision_to_Assess_DTA_Planned_Date__c= System.today()+15;
            insert lAssessments;

            System.assert(lAssessments.size()==1);

            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 

            DRDW_Cap_Request__c ocapReq = new DRDW_Cap_Request__c(GO_Preferred_Start_Date__c=System.today()+2,Lab_Testing_Required__c='Lab Challenge Preparation;Lab Vaccination Preparation',samples_to_collect_new__c='[Tissue Sample,Oral Swabs]',Project__c=lAssessments[0].Id,Actual_Start_Date__c=System.today(),Actual_End_Date__c=System.today()+5,RecordTypeId=Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('ERL').getRecordTypeId(),Request_Status__c = 'Re-Submit: Change Request',Planned_Start_Date__c=System.today()-5,Planned_Study_End_Date__c=System.today()+17);
            insert ocapReq;
            
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Request Activity',lAssessments[0].id);
            lCapab[0].DRDW_Request__c=ocapReq.Id;
            insert lCapab;

            GLBL_Global_List_of_Values__c oglov = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('DRDW Samples To Collect').getRecordTypeId());
            insert oglov;

            DRDW_Event__c oEvent = new DRDW_Event__c(/*Event_Dates__c='04/26/2018,05/26/2018',*/Type__c='GO',Status__c='Partially Assigned',DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='-27,-3,2,3');
            insert oEvent;

            PageReference pagRef = new PageReference('/apex/DRDW_CreateGORequest');
            Test.setCurrentPage(pagRef);
            test.StartTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(ocapReq);
            DRDW_CreateGORequestCtrl controller = new DRDW_CreateGORequestCtrl(sc);
            controller.oRequest.Request_Status__c ='Draft';
            controller.save();
            test.stopTest();

            PageReference pagRef1 = new PageReference('/apex/DRDW_CreateGORequest?id='+ocapReq.Id+'&projid='+lAssessments[0].Id);
            Test.setCurrentPage(pagRef1);
            ApexPages.StandardController sc1 = new ApexPages.StandardController(ocapReq);
            DRDW_CreateGORequestCtrl controller1 = new DRDW_CreateGORequestCtrl(sc1);
            controller1.isGen=true;
            controller1.save();
            controller1.isIdea=true;
            controller1.save();
        }
    }   
    static testMethod void testPositive3() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Project_Manager');
        DRDW_TestDataFactory.assignGroup(busAdm.id,'DRDW_FG_Bacteriology');
        DRDW_TestDataFactory.assignGroup(busAdm.id,'DRDW_BU_Business_Development');
        System.runAs(busAdm) {   
            List<DRDW_Project__c> lAssessments = DRDW_TestDataFactory.returnProjects(1,'Generation Project');
            insert lAssessments;

            System.assert(lAssessments.size()==1);

            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 

            DRDW_Cap_Request__c ocapReq = new DRDW_Cap_Request__c(GO_Preferred_Start_Date__c=System.today()+2,Lab_Testing_Required__c='Lab Challenge Preparation;Lab Vaccination Preparation',samples_to_collect_new__c='Tissue Sample;Oral Swabs',Project__c=lAssessments[0].Id,Actual_Start_Date__c=System.today(),Actual_End_Date__c=System.today()+5,RecordTypeId=Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('ERL').getRecordTypeId(),Request_Status__c = 'Submitted',Planned_Study_Start_Date__c=System.today()+5,Planned_Study_End_Date__c=System.today()+1);
            insert ocapReq;
            
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Request Activity',lAssessments[0].id);
            lCapab[0].DRDW_Request__c=ocapReq.Id;
            insert lCapab;

            GLBL_Global_List_of_Values__c oglov = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('DRDW Samples To Collect').getRecordTypeId());
            insert oglov;

            DRDW_Event__c oEvent = new DRDW_Event__c(/*Event_Dates__c='04/26/2018,05/26/2018',*/Type__c='GO',Status__c='Partially Assigned',DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='-27,-3,2,3');
            insert oEvent;

            PageReference pagRef = new PageReference('/apex/DRDW_CreateGORequest?id='+ocapReq.Id+'&projid='+lAssessments[0].Id);
            Test.setCurrentPage(pagRef);
            test.StartTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(ocapReq);
            DRDW_CreateGORequestCtrl controller = new DRDW_CreateGORequestCtrl(sc);
            controller.CheckIfGoUserandFirsttime();
            controller.save();
            test.stopTest();
        }
    }   
}