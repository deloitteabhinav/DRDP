@isTest(seeAllData=False)
Private class Test_DRDW_GOProjectViewCtrl {
    
    static testMethod void testwithBudgetNew() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_GO_USER');
        System.runAs(busAdm) {
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');  
            lprojects[0].Project_Name__c='Test';
            lprojects[1].Idea_Name__c='Test';       
            insert lprojects;
            System.debug([Select name from DRDW_Project__c where id =:lprojects[1].Id]);
            
            Id reqRecType = DRDW_TestDataFactory.getObjectRecordTypeId(DRDW_Cap_Request__c.SObjectType, 'GO');
            
            DRDW_Cap_Request__c oCapReq = new DRDW_Cap_Request__c(Project__c=lprojects[1].Id,Study_Manager__c=busAdm.Id,recordtypeid=reqRecType,GO_Preferred_Start_Date__c = system.today());
            insert oCapReq;
            
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilitieswithreq(1, 'Idea Capability',lprojects[0].id,oCapReq.Id);
            insert lCapab;
            
            DRDW_Event__c oEvent = new DRDW_Event__c(DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='2',Event_Dates_7_Day_Res__c='2018-03-01',Go_Sub_Activities__c='Bacterial Isolation');
            insert oEvent;
            
            DRDW_Event__c oEvent1 = new DRDW_Event__c(DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='',Event_Dates_7_Day_Res__c='2018-03-01',Go_Sub_Activities__c='Bacterial Isolation');
            insert oEvent1;

            DRDW_Resource__c oResource = new DRDW_Resource__c(Name__c=busAdm.Id,Department__c='Animal Care',Type__c='GO',Role__c='Study Manager',Hours_Available_Per_Day__c=10.00,Hours_per_Week__c=50.00,Status__c='Active',Days_Per_Week__c='7');
            insert oResource;

            DRDW_Event_Days__c oEvDay = new DRDW_Event_Days__c(Allocated_Hours__c=10.00,Date__c=System.today(),DRDW_Event__c=oEvent.Id,DRDW_Resource__c=oResource.Id,Type__c='GO');
            insert oEvDay;
            
            DRDW_Assign_Resource__c oAssignRes = new DRDW_Assign_Resource__c(DRDW_Event__c=oEvent.Id,Go_Sub_Activities__c='Bacterial Isolation',Frequency_UI__c = '1',DRDW_Resources__c = oResource.id,Group__c='Animal Care',Hours_Per_Day__c = 6);
            insert oAssignRes;
            Set<String> sRes = new Set<String>();
            sRes.add(busAdm.Name);
            
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
            
             GLBL_Global_List_of_Values__c oglov1 = new GLBL_Global_List_of_Values__c(name='Animal Care',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Group').getRecordTypeId());
            insert oglov1;
            GLBL_Global_List_of_Values__c oglov = new GLBL_Global_List_of_Values__c(name='Bacterial Isolation',Active__c=true,Parent__c=oglov1.id,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Go-sub Activity').getRecordTypeId());
            insert oglov;
            
            DRDW_GOProjectViewCtrl controller = new DRDW_GOProjectViewCtrl();
            controller.ModelReqId = oCapReq.id;
            controller.resEventId = oEvent.id;
            controller.requestStatus ='All';
            controller.executeWrapperGeneratorGO();
            controller.getStatusList() ;
            controller.getGroupList();
            controller.export();
            controller.addError('sst');
            controller.addInfo('sst');
            controller.calculateDates('2018-03-01');            
            controller.ShowReqEvent();           
            controller.getEventResources();
            controller.ssbAssignError();
            DRDW_GOProjectViewCtrl.reqResWrapper oreqResWrapper = new DRDW_GOProjectViewCtrl.reqResWrapper(oEvent,false,false,sRes,'Bacterial Isolation');
            controller.lreqResWrapper = new List<DRDW_GOProjectViewCtrl.reqResWrapper>();
            controller.lreqResWrapper.add(oreqResWrapper);
            controller.SaveEventRes();
            controller.addEventRes();
            controller.editSubAct();
            controller.SaveEditSubAct();
            //controller.updateEventDetails();
            List<Date> listDate = new List<Date>();
            listDate.add(System.today());
            controller.calculateFrequency(System.today(),listDate);
            controller.getTotalAllocatedHours(System.today(), System.today(), 10, '5');
            //controller.initilizeAssignResource();
            Test.setCurrentPageReference(new PageReference('DRDW_GOView'));
            System.currentPageReference().getParameters().put('resourceId', oResource.Id);
            controller.updateGroup();
            controller.oAssignResource.Allocation_End_Date__c = system.today();
            controller.oAssignResource.Allocation_Start_Date__c = system.today().adddays(1);
            //controller.next();
            controller.oAssignResource.DRDW_Resources__c = oResource.id;
            controller.oAssignResource.Allocation_End_Date__c =system.today().adddays(1);
            controller.oAssignResource.Allocation_Start_Date__c = system.today();
            controller.oAssignResource.DRDW_Event__c = oEvent.id;
            controller.oAssignResource.Group__c = 'Animal Care';
            controller.oAssignResource.Task__c = 'PCR';
            controller.oAssignResource.Hours_Per_Day__c = 6;
            controller.updateGroup();
            //controller.next();
            //controller.assignResource();
            System.currentPageReference().getParameters().put('selectedResource', oResource.Id);
            controller.requestStatus ='Assigned';
            controller.executeWrapperGeneratorGO();
            DRDW_GOProjectViewCtrl.convertFrequency('1-9');
            Set<String> sDate = new Set<String>();
            sDate.add('2018-03-01');
            controller.calculateDatesNew(sDate);
            controller.ssbSaveResource();
            controller.ssbAssignResource();
            controller.deleteEvent();
            controller.getchangeshowResEvent();
            controller.DeleteAssignId = oAssignRes.Id;
            controller.DeleteReqEvent();
            /*controller.executeWrapperGeneratorOnLoad();
            controller.executeWrapperGeneratorExport();
            controller.gogroup='Animal Care';
            controller.exportResource();
            controller.executeWrapperGenerator();*/
            System.assertNotEquals(null, oEvDay.id, 'error');
        }
    }
    
    static testMethod void testwithBudgetNew1() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_GO_USER');
        System.runAs(busAdm) {
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');  
            lprojects[0].Project_Name__c='Test';
            lprojects[1].Idea_Name__c='Test';       
            insert lprojects;
            System.debug([Select name from DRDW_Project__c where id =:lprojects[1].Id]);
            
            Id reqRecType = DRDW_TestDataFactory.getObjectRecordTypeId(DRDW_Cap_Request__c.SObjectType, 'GO');
            
            DRDW_Cap_Request__c oCapReq = new DRDW_Cap_Request__c(Project__c=lprojects[1].Id,Study_Manager__c=busAdm.Id,recordtypeid=reqRecType,GO_Preferred_Start_Date__c = system.today());
            insert oCapReq;
            
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilitieswithreq(1, 'Idea Capability',lprojects[0].id,oCapReq.Id);
            insert lCapab;
            
            DRDW_Event__c oEvent = new DRDW_Event__c(DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='2',Event_Dates_7_Day_Res__c='2018-03-01',Go_Sub_Activities__c='Bacterial Isolation');
            insert oEvent;
            
            DRDW_Event__c oEvent1 = new DRDW_Event__c(DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='',Event_Dates_7_Day_Res__c='2018-03-01',Go_Sub_Activities__c='Bacterial Isolation');
            insert oEvent1;
            
            DRDW_Resource__c oResource = new DRDW_Resource__c(Name__c=busAdm.Id,Department__c='Animal Care',Type__c='GO',Role__c='Study Manager',Hours_Available_Per_Day__c=10.00,Hours_per_Week__c=50.00,Status__c='Active',Days_Per_Week__c='7');
            insert oResource;

            DRDW_Event_Days__c oEvDay = new DRDW_Event_Days__c(Allocated_Hours__c=10.00,Date__c=System.today(),DRDW_Event__c=oEvent.Id,DRDW_Resource__c=oResource.Id,Type__c='GO');
            insert oEvDay;
            
            DRDW_Assign_Resource__c oAssignRes = new DRDW_Assign_Resource__c(DRDW_Event__c=oEvent.Id,Go_Sub_Activities__c='Bacterial Isolation',Frequency_UI__c = '1',DRDW_Resources__c = oResource.id,Group__c='Animal Care',Hours_Per_Day__c = 6);
            insert oAssignRes;
            
            Set<String> sRes = new Set<String>();
            sRes.add(busAdm.Name);
            
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

            DRDW_GOProjectViewCtrl controller = new DRDW_GOProjectViewCtrl();
            controller.ModelReqId = oCapReq.id;
            controller.resEventId = oEvent.id;
            controller.requestStatus ='All';
            controller.executeWrapperGeneratorGO();
            controller.getStatusList() ;
            controller.getGroupList();
            controller.export();
            controller.addError('sst');
            controller.addInfo('sst');
            controller.calculateDates('2018-03-01');
            controller.mapofsubgroup.put('Bacterial Isolation','Animal Care');
            controller.ShowReqEvent();
            controller.getEventResources();
            //controller.SaveEditSubAct();
            controller.ssbAssignError();
            DRDW_GOProjectViewCtrl.reqResWrapper oreqResWrapper = new DRDW_GOProjectViewCtrl.reqResWrapper(oEvent,true,true,sRes,'Bacterial Isolation');
            controller.lreqResWrapper = new List<DRDW_GOProjectViewCtrl.reqResWrapper>();
            controller.lreqResWrapper.add(oreqResWrapper);
            controller.editSubAct();
            controller.SaveEventRes();
           // controller.addEventRes();
            //controller.SaveEventRes();
            //controller.editSubAct();
            //controller.updateEventDetails();
            List<Date> listDate = new List<Date>();
            listDate.add(System.today());
            controller.calculateFrequency(System.today(),listDate);
            controller.getTotalAllocatedHours(System.today(), System.today(), 10, '5');
            //controller.initilizeAssignResource();
            Test.setCurrentPageReference(new PageReference('DRDW_GOView'));
            System.currentPageReference().getParameters().put('resourceId', oResource.Id);
            controller.updateGroup();
            controller.oAssignResource.Allocation_End_Date__c = system.today();
            controller.oAssignResource.Allocation_Start_Date__c = system.today().adddays(1);
            //controller.next();
            controller.oAssignResource.DRDW_Resources__c = oResource.id;
            controller.oAssignResource.Allocation_End_Date__c =system.today().adddays(1);
            controller.oAssignResource.Allocation_Start_Date__c = system.today();
            controller.oAssignResource.DRDW_Event__c = oEvent.id;
            controller.oAssignResource.Group__c = 'Animal Care';
            controller.oAssignResource.Task__c = 'PCR';
            controller.oAssignResource.Hours_Per_Day__c = 6;
            //controller.next();
            //controller.assignResource();
            System.currentPageReference().getParameters().put('selectedResource', oResource.Id);
            controller.deleteEvent();
            controller.getchangeshowResEvent();
            //controller.assignResource();
            /*controller.executeWrapperGeneratorOnLoad();
            controller.executeWrapperGeneratorExport();
            controller.gogroup='Animal Care';
            controller.exportResource();
            controller.executeWrapperGenerator();*/
            System.assertNotEquals(null, calPerRoaster1.id, 'error');
        }
    }
    
    static testMethod void testwithBudgetNew2() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Scientist');
        System.runAs(busAdm) {
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');  
            lprojects[0].Project_Name__c='Test';
            lprojects[1].Idea_Name__c='Test';       
            insert lprojects;
            System.debug([Select name from DRDW_Project__c where id =:lprojects[1].Id]);
            
            Id reqRecType = DRDW_TestDataFactory.getObjectRecordTypeId(DRDW_Cap_Request__c.SObjectType, 'GO');
            
            DRDW_Cap_Request__c oCapReq = new DRDW_Cap_Request__c(Project__c=lprojects[1].Id,Study_Manager__c=busAdm.Id,recordtypeid=reqRecType,GO_Preferred_Start_Date__c = system.today());
            insert oCapReq;
            
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilitieswithreq(1, 'Idea Capability',lprojects[0].id,oCapReq.Id);
            insert lCapab;
            
            DRDW_Event__c oEvent = new DRDW_Event__c(DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='2',Event_Dates_7_Day_Res__c='2018-03-01',Go_Sub_Activities__c='Bacterial Isolation');
            insert oEvent;
            
            DRDW_Event__c oEvent1 = new DRDW_Event__c(DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='',Event_Dates_7_Day_Res__c='2018-03-01',Go_Sub_Activities__c='Bacterial Isolation');
            insert oEvent1;

            DRDW_Resource__c oResource = new DRDW_Resource__c(Name__c=busAdm.Id,Department__c='Animal Care',Type__c='GO',Role__c='Study Manager',Hours_Available_Per_Day__c=10.00,Hours_per_Week__c=50.00,Status__c='Active',Days_Per_Week__c='5');
            insert oResource;

            DRDW_Event_Days__c oEvDay = new DRDW_Event_Days__c(Allocated_Hours__c=10.00,Date__c=System.today(),DRDW_Event__c=oEvent.Id,DRDW_Resource__c=oResource.Id,Type__c='GO');
            insert oEvDay;
            
            DRDW_Event_Days__c oEvDay1 = new DRDW_Event_Days__c(Allocated_Hours__c=10.00,Date__c=System.today(),DRDW_Event__c=oEvent1.Id,DRDW_Resource__c=oResource.Id,Type__c='GO');
            insert oEvDay1;
            
            DRDW_Assign_Resource__c oAssignRes = new DRDW_Assign_Resource__c(DRDW_Event__c=oEvent.Id,Go_Sub_Activities__c='Bacterial Isolation',Frequency_UI__c = '1',DRDW_Resources__c = oResource.id,Group__c='Animal Care',Hours_Per_Day__c = 6);
            insert oAssignRes;
            
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

            DRDW_GOProjectViewCtrl controller = new DRDW_GOProjectViewCtrl();
            controller.ModelReqId = oCapReq.id;
            controller.resEventId = oEvent.id;
            controller.requestStatus ='All';
            controller.executeWrapperGeneratorGO();
            controller.getStatusList() ;
            controller.getGroupList();
            controller.export();
            controller.addError('sst');
            controller.addInfo('sst');
            controller.calculateDates('2018-03-01');
            controller.mapofsubgroup.put('Bacterial Isolation','Animal Care');
            controller.ShowReqEvent();
            controller.getEventResources();
            //controller.SaveEditSubAct();
            controller.ssbAssignError();
            
           // controller.addEventRes();
           // controller.SaveEventRes();
            //controller.editSubAct();
            //controller.updateEventDetails();
            List<Date> listDate = new List<Date>();
            listDate.add(System.today());
            controller.calculateFrequency(System.today(),listDate);
            controller.getTotalAllocatedHours(System.today(), System.today(), 10, '5');
            //controller.initilizeAssignResource();
            Test.setCurrentPageReference(new PageReference('DRDW_GOView'));
            System.currentPageReference().getParameters().put('resourceId', oResource.Id);
            controller.updateGroup();
            controller.oAssignResource.Allocation_End_Date__c = system.today();
            controller.oAssignResource.Allocation_Start_Date__c = system.today().adddays(1);
            //controller.next();
            controller.oAssignResource.DRDW_Resources__c = oResource.id;
            controller.oAssignResource.Allocation_End_Date__c =system.today().adddays(1);
            controller.oAssignResource.Allocation_Start_Date__c = system.today();
            controller.oAssignResource.DRDW_Event__c = oEvent.id;
            controller.oAssignResource.Group__c = 'Animal Care';
            controller.oAssignResource.Task__c = 'PCR';
            controller.oAssignResource.Hours_Per_Day__c = 6;
            //controller.next();
            //controller.assignResource();
            System.currentPageReference().getParameters().put('selectedResource', oResource.Id);
            controller.deleteEvent();
            controller.getchangeshowResEvent();
            //controller.assignResource();
            /*controller.executeWrapperGeneratorOnLoad();
            controller.executeWrapperGeneratorExport();
            controller.gogroup='Animal Care';
            controller.exportResource();
            controller.executeWrapperGenerator();*/
            System.assertNotEquals(null, calPerRoaster1.id, 'error');
        }
    }
    
   static testMethod void testwithBudgetNew3() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_GO_USER');
        System.runAs(busAdm) {
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');  
            lprojects[0].Project_Name__c='Test';
            lprojects[1].Idea_Name__c='Test';       
            insert lprojects;
            System.debug([Select name from DRDW_Project__c where id =:lprojects[1].Id]);
            
            Id reqRecType = DRDW_TestDataFactory.getObjectRecordTypeId(DRDW_Cap_Request__c.SObjectType, 'GO');
            
            DRDW_Cap_Request__c oCapReq = new DRDW_Cap_Request__c(Project__c=lprojects[1].Id,Study_Manager__c=busAdm.Id,recordtypeid=reqRecType,GO_Preferred_Start_Date__c = system.today());
            insert oCapReq;
            
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilitieswithreq(1, 'Idea Capability',lprojects[0].id,oCapReq.Id);
            insert lCapab;
            
            DRDW_Event__c oEvent = new DRDW_Event__c(DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='2',Event_Dates_7_Day_Res__c='2018-03-01',Go_Sub_Activities__c='Bacterial Isolation');
            insert oEvent;
            
            DRDW_Event__c oEvent1 = new DRDW_Event__c(DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='',Event_Dates_7_Day_Res__c='2018-03-01',Go_Sub_Activities__c='Bacterial Isolation');
            insert oEvent1;

            DRDW_Resource__c oResource = new DRDW_Resource__c(Name__c=busAdm.Id,Department__c='Animal Care',Type__c='GO',Role__c='Study Manager',Hours_Available_Per_Day__c=10.00,Hours_per_Week__c=50.00,Status__c='Active',Days_Per_Week__c='5');
            insert oResource;

            DRDW_Event_Days__c oEvDay = new DRDW_Event_Days__c(Allocated_Hours__c=10.00,Date__c=System.today(),DRDW_Event__c=oEvent.Id,DRDW_Resource__c=oResource.Id,Type__c='GO');
            insert oEvDay;
            
            DRDW_Assign_Resource__c oAssignRes = new DRDW_Assign_Resource__c(DRDW_Event__c=oEvent.Id,Go_Sub_Activities__c='Bacterial Isolation',Frequency_UI__c = '1',DRDW_Resources__c = oResource.id,Group__c='Animal Care',Hours_Per_Day__c = 6);
            insert oAssignRes;
            
            /*DRDW_Calender_Per_Roaster__c calPerRoaster = new DRDW_Calender_Per_Roaster__c();
            calPerRoaster.Allocated_Date__c = System.today();
            calPerRoaster.Allocated_Hours__c = 8;
            calPerRoaster.DRDW_Roaster__c = oResource.id;
            insert calPerRoaster;
            DRDW_Calender_Per_Roaster__c calPerRoaster1 = new DRDW_Calender_Per_Roaster__c();
            calPerRoaster1.Allocated_Date__c = System.today().addDays(1);
            calPerRoaster1.Allocated_Hours__c = 8;
            calPerRoaster1.DRDW_Roaster__c = oResource.id;
            insert calPerRoaster1;*/

            DRDW_GOProjectViewCtrl controller = new DRDW_GOProjectViewCtrl();
            controller.ModelReqId = oCapReq.id;
            controller.resEventId = oEvent.id;
            controller.requestStatus ='All';
            controller.executeWrapperGeneratorGO();
            controller.getStatusList() ;
            controller.getGroupList();
            controller.export();
            controller.addError('sst');
            controller.addInfo('sst');
            controller.calculateDates('2018-03-01');
            controller.mapofsubgroup.put('Bacterial Isolation','Animal Care');
            controller.ShowReqEvent();
            controller.getEventResources();
            //controller.SaveEditSubAct();
            controller.ssbAssignError();
           // controller.addEventRes();
            //controller.SaveEventRes();
            //controller.editSubAct();
            //controller.updateEventDetails();
            List<Date> listDate = new List<Date>();
            listDate.add(System.today());
            controller.calculateFrequency(System.today(),listDate);
            controller.getTotalAllocatedHours(System.today(), System.today(), 10, '5');
            //controller.initilizeAssignResource();
            Test.setCurrentPageReference(new PageReference('DRDW_GOView'));
            System.currentPageReference().getParameters().put('resourceId', oResource.Id);
            controller.updateGroup();
            controller.oAssignResource.Allocation_End_Date__c = system.today();
            controller.oAssignResource.Allocation_Start_Date__c = system.today().adddays(1);
            //controller.next();
            controller.oAssignResource.DRDW_Resources__c = oResource.id;
            controller.oAssignResource.Allocation_End_Date__c =system.today().adddays(1);
            controller.oAssignResource.Allocation_Start_Date__c = system.today();
            controller.oAssignResource.DRDW_Event__c = oEvent.id;
            controller.oAssignResource.Group__c = 'Animal Care';
            controller.oAssignResource.Task__c = 'PCR';
            controller.oAssignResource.Hours_Per_Day__c = 6;
            //controller.next();
            //controller.assignResource();
            System.currentPageReference().getParameters().put('selectedResource', oResource.Id);
            controller.deleteEvent();
            controller.getchangeshowResEvent();
            //controller.assignResource();
            /*controller.executeWrapperGeneratorOnLoad();
            controller.executeWrapperGeneratorExport();
            controller.gogroup='Animal Care';
            controller.exportResource();
            controller.executeWrapperGenerator();*/
            System.assertNotEquals(null, oEvDay.id, 'error');
        }
    }
    
       static testMethod void testwithBudgetNew4() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_GO_USER');
        System.runAs(busAdm) {
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');  
            lprojects[0].Project_Name__c='Test';
            lprojects[1].Idea_Name__c='Test';       
            insert lprojects;
            System.debug([Select name from DRDW_Project__c where id =:lprojects[1].Id]);
            
            Id reqRecType = DRDW_TestDataFactory.getObjectRecordTypeId(DRDW_Cap_Request__c.SObjectType, 'GO');
            
            DRDW_Cap_Request__c oCapReq = new DRDW_Cap_Request__c(Project__c=lprojects[1].Id,Study_Manager__c=busAdm.Id,recordtypeid=reqRecType,GO_Preferred_Start_Date__c = system.today());
            insert oCapReq;
            
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilitieswithreq(1, 'Idea Capability',lprojects[0].id,oCapReq.Id);
            insert lCapab;
            
            DRDW_Event__c oEvent = new DRDW_Event__c(DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency_UI__c='2,3-4',Event_Dates_7_Day_Res__c='2018-03-01',Go_Sub_Activities__c='Bacterial Isolation');
            insert oEvent;
            
            DRDW_Event__c oEvent1 = new DRDW_Event__c(DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='',Event_Dates_7_Day_Res__c='2018-03-01',Go_Sub_Activities__c='Bacterial Isolation');
            insert oEvent1;

            DRDW_Resource__c oResource = new DRDW_Resource__c(Name__c=busAdm.Id,Department__c='Animal Care',Type__c='GO',Role__c='Study Manager',Hours_Available_Per_Day__c=10.00,Hours_per_Week__c=50.00,Status__c='Active',Days_Per_Week__c='5');
            insert oResource;                       

            DRDW_Event_Days__c oEvDay = new DRDW_Event_Days__c(Allocated_Hours__c=10.00,Date__c=System.today(),DRDW_Event__c=oEvent.Id,DRDW_Resource__c=oResource.Id,Type__c='GO');
            insert oEvDay;
            
            DRDW_Assign_Resource__c oAssignRes = new DRDW_Assign_Resource__c(DRDW_Event__c=oEvent.Id,Go_Sub_Activities__c='Bacterial Isolation',Frequency_UI__c = '1,2-3',DRDW_Resources__c = oResource.id,Group__c='Animal Care',Hours_Per_Day__c = 6);
            insert oAssignRes;
            
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
            
           
            GLBL_Global_List_of_Values__c oglov1 = new GLBL_Global_List_of_Values__c(name='Animal Care',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Group').getRecordTypeId());
            insert oglov1;
            GLBL_Global_List_of_Values__c oglov = new GLBL_Global_List_of_Values__c(name='Bacterial Isolation',Active__c=true,Parent__c=oglov1.id,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Go-sub Activity').getRecordTypeId());
            insert oglov;
            DRDW_GOProjectViewCtrl controller = new DRDW_GOProjectViewCtrl();
          
            controller.ModelReqId = oCapReq.id;
            controller.resEventId = oEvent.id;
            controller.requestStatus ='All';
            controller.executeWrapperGeneratorGO();
            controller.getStatusList() ;
            controller.getGroupList();
            controller.export();
            controller.addError('sst');
            controller.addInfo('sst');
            controller.calculateDates('2018-03-01');
            controller.ShowReqEvent();
             controller.index=1;
             controller.isValid = true;
            controller.ssbAssignResource();
            controller.getEventResources();
            //controller.SaveEditSubAct();
            controller.ssbAssignError();
           // controller.addEventRes();
            //controller.SaveEventRes();
            //controller.editSubAct();
            //controller.updateEventDetails();
            List<Date> listDate = new List<Date>();
            listDate.add(System.today());
            controller.calculateFrequency(System.today(),listDate);
            controller.getTotalAllocatedHours(System.today(), System.today(), 10, '5');
            //controller.initilizeAssignResource();
            Test.setCurrentPageReference(new PageReference('DRDW_GOView'));                      
            System.assertNotEquals(null, oEvDay.id, 'error');
        }
    }
    
     static testMethod void testwithBudgetNew5() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_GO_USER');
        System.runAs(busAdm) {
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');  
            lprojects[0].Project_Name__c='Test';
            lprojects[1].Idea_Name__c='Test';       
            insert lprojects;
            System.debug([Select name from DRDW_Project__c where id =:lprojects[1].Id]);
            
            Id reqRecType = DRDW_TestDataFactory.getObjectRecordTypeId(DRDW_Cap_Request__c.SObjectType, 'GO');
            
            DRDW_Cap_Request__c oCapReq = new DRDW_Cap_Request__c(Project__c=lprojects[1].Id,Study_Manager__c=busAdm.Id,recordtypeid=reqRecType,GO_Preferred_Start_Date__c = system.today());
            insert oCapReq;
            
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilitieswithreq(1, 'Idea Capability',lprojects[0].id,oCapReq.Id);
            insert lCapab;
            
            DRDW_Event__c oEvent = new DRDW_Event__c(DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency_UI__c='2,3-4',Event_Dates_7_Day_Res__c='2018-03-01',Go_Sub_Activities__c='Bacterial Isolation');
            insert oEvent;
            
            DRDW_Event__c oEvent1 = new DRDW_Event__c(DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='',Event_Dates_7_Day_Res__c='2018-03-01',Go_Sub_Activities__c='Bacterial Isolation');
            insert oEvent1;

            DRDW_Resource__c oResource = new DRDW_Resource__c(Name__c=busAdm.Id,Department__c='Animal Care',Type__c='GO',Role__c='Study Manager',Hours_Available_Per_Day__c=10.00,Hours_per_Week__c=50.00,Status__c='Active',Days_Per_Week__c='7');
            insert oResource;                       

            DRDW_Event_Days__c oEvDay = new DRDW_Event_Days__c(Allocated_Hours__c=10.00,Date__c=System.today(),DRDW_Event__c=oEvent.Id,DRDW_Resource__c=oResource.Id,Type__c='GO');
            insert oEvDay;
            
            DRDW_Assign_Resource__c oAssignRes = new DRDW_Assign_Resource__c(DRDW_Event__c=oEvent.Id,Go_Sub_Activities__c='Bacterial Isolation',Frequency_UI__c = '1,2-3',DRDW_Resources__c = oResource.id,Group__c='Animal Care',Hours_Per_Day__c = 6);
            insert oAssignRes;
            
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
            
           
            GLBL_Global_List_of_Values__c oglov1 = new GLBL_Global_List_of_Values__c(name='Animal Care',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Group').getRecordTypeId());
            insert oglov1;
            GLBL_Global_List_of_Values__c oglov = new GLBL_Global_List_of_Values__c(name='Bacterial Isolation',Active__c=true,Parent__c=oglov1.id,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Go-sub Activity').getRecordTypeId());
            insert oglov;
            DRDW_GOProjectViewCtrl controller = new DRDW_GOProjectViewCtrl();
          
            controller.ModelReqId = oCapReq.id;
            controller.resEventId = oEvent.id;
            controller.requestStatus ='All';
            controller.executeWrapperGeneratorGO();
            controller.getStatusList() ;
            controller.getGroupList();
            controller.export();
            controller.addError('sst');
            controller.addInfo('sst');
            controller.calculateDates('2018-03-01');
            controller.ShowReqEvent();
             controller.index=1;
             controller.isValid = true;
            controller.ssbAssignResource();
            controller.getEventResources();
            //controller.SaveEditSubAct();
            controller.ssbAssignError();
           // controller.addEventRes();
            //controller.SaveEventRes();
            //controller.editSubAct();
            //controller.updateEventDetails();
            List<Date> listDate = new List<Date>();
            listDate.add(System.today());
            controller.calculateFrequency(System.today(),listDate);
            controller.getTotalAllocatedHours(System.today(), System.today(), 10, '5');
            //controller.initilizeAssignResource();
            Test.setCurrentPageReference(new PageReference('DRDW_GOView'));                      
            System.assertNotEquals(null, oEvDay.id, 'error');
        }
    }
}