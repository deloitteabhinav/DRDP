@isTest
private class Test_DRDW_ERLProjectViewCtrl {
  static testMethod void testwithBudget() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {
          List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');  
          lprojects[0].Project_Name__c='Test';
          lprojects[1].Idea_Name__c='Test';       
            insert lprojects;
            System.debug([Select name from DRDW_Project__c where id =:lprojects[1].Id]);
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Idea Capability',lprojects[0].id);
            insert lCapab;
            
          DRDW_Cap_Request__c oCapReq = new DRDW_Cap_Request__c(Project__c=lprojects[1].Id,Study_Manager__c=busAdm.Id);
          insert oCapReq;
          
           Id requestTypeId = Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('ERL').getRecordTypeId();
            DRDW_Cap_Request__c oRequest = new DRDW_Cap_Request__c();
            oRequest.recordtypeid = requestTypeid;
            oRequest.Project__c=lprojects[0].id;
            insert oRequest;
            System.assertNotEquals(null,oRequest,'error');
            DRDW_Capability__c oCap = new DRDW_Capability__c();
            oCap.Planned_Start_Date__c = system.today();
            oCap.Planned_End_Date__c = system.today().addDays(3);
            oCap.Proposed_Start_Date__c= system.today();
            oCap.DRDW_Request__c = oRequest.id;
            insert oCap;                    
            
            DRDW_Capability__c oCap1 = new DRDW_Capability__c();
            oCap1.DRDW_Request__c = oRequest.id;
            insert oCap1;
            
             DRDW_Event__c oEvent = new DRDW_Event__c(DRDW_Activity__c=oCap.Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='');
          insert oEvent;

          DRDW_Resource__c oResource = new DRDW_Resource__c(Name__c=busAdm.Id,Department__c='DDS',Type__c='ERL',Role__c='Functional Head',Hours_Available_Per_Day__c=10.00,Hours_per_Week__c=50.00,Status__c='Active');
          insert oResource;

          DRDW_Event_Days__c oEvDay = new DRDW_Event_Days__c(Allocated_Hours__c=10.00,Date__c=System.today(),DRDW_Event__c=oEvent.Id,DRDW_Resource__c=oResource.Id,Type__c='ERL');
          insert oEvDay;

          DRDW_ERLProjectViewCtrl controller = new DRDW_ERLProjectViewCtrl();
          controller.getStatusList();
          controller.executeWrapperGeneratorERL();
          controller.getActivityAreaList();
          controller.validateActivityArea();
          controller.initilizeAssignResource();
          controller.oAssignResource.DRDW_Activity__c = oCap.Id;
          controller.oAssignResource.Allocation_Start_Date__c=system.today();
          controller.oAssignResource.Allocation_End_Date__c = system.today().addDays(4);
          controller.oAssignResource.Hours_Per_Day__c = 9;          
          controller.next();
          controller.assignResource();
          controller.getTotalAllocatedHours(system.today(),system.today().addDays(2),3.0);
          controller.initilizeActivity();
          controller.oActivity.DRDW_Request__c = oRequest.id;
          controller.oActivity.Capability__c = 'test';
          controller.oActivity.Capability_Area__c = 'test';
          controller.oActivity.Planned_Start_Date__c =system.today();
          controller.oActivity.Planned_End_Date__c = system.today().addDays(2);
          controller.oActivity.Title__c ='test';
          controller.saveActivity();
          controller.oActivity.Capability__c = null;
          controller.oActivity.Planned_Start_Date__c =system.today();
          controller.oActivity.Planned_End_Date__c = system.today().addDays(2);
          controller.oActivity.Title__c ='test';
          controller.saveActivity();
          controller.oActivity.Capability__c = 'test';
          controller.oActivity.Planned_Start_Date__c =system.today().addDays(2);
          controller.oActivity.Planned_End_Date__c = system.today();
          controller.oActivity.Title__c ='test';
          controller.saveActivity();          
          controller.export();
          
          controller.oAssignResource.DRDW_Activity__c = oCap.Id;
          controller.oAssignResource.Allocation_Start_Date__c=system.today();
          controller.oAssignResource.Allocation_End_Date__c = system.today();
          controller.oAssignResource.Hours_Per_Day__c = 9;          
          controller.next();
          
          controller.selectedResource = oResource.id;
          controller.assignResource();
        }
    }
    
     static testMethod void testwithBudget1() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {
          List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');  
          lprojects[0].Project_Name__c='Test';
          lprojects[1].Idea_Name__c='Test';       
            insert lprojects;
            System.debug([Select name from DRDW_Project__c where id =:lprojects[1].Id]);
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Idea Capability',lprojects[0].id);
            insert lCapab;

         


          DRDW_Cap_Request__c oCapReq = new DRDW_Cap_Request__c(Project__c=lprojects[1].Id,Study_Manager__c=busAdm.Id);
          insert oCapReq;
          
           Id requestTypeId = Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('ERL').getRecordTypeId();
            DRDW_Cap_Request__c oRequest = new DRDW_Cap_Request__c();
            oRequest.recordtypeid = requestTypeid;
            oRequest.Project__c=lprojects[0].id;
            insert oRequest;
            System.assertNotEquals(null,oRequest,'error');
            DRDW_Capability__c oCap = new DRDW_Capability__c();
            oCap.Planned_Start_Date__c = system.today();
            oCap.Planned_End_Date__c = system.today().addDays(3);
            oCap.Proposed_Start_Date__c= system.today();
            oCap.Capability__c = 'API Characterization';
            oCap.Capability_Area__c = 'DDS';
            oCap.DRDW_Request__c = oRequest.id;
            insert oCap;                    
            
            DRDW_Capability__c oCap1 = new DRDW_Capability__c();
            oCap1.DRDW_Request__c = oRequest.id;
            insert oCap1;
            
          DRDW_Event__c oEvent = new DRDW_Event__c(DRDW_Activity__c=oCap.Id);
          insert oEvent;

          DRDW_Resource__c oResource = new DRDW_Resource__c(Name__c=busAdm.Id,Department__c='DDS',Type__c='ERL',Role__c='Functional Head',Hours_Available_Per_Day__c=10.00,Hours_per_Week__c=50.00,Status__c='Active');
          insert oResource;

          DRDW_Event_Days__c oEvDay = new DRDW_Event_Days__c(Allocated_Hours__c=10.00,Date__c=System.today(),DRDW_Event__c=oEvent.Id,DRDW_Resource__c=oResource.Id,Type__c='ERL');
          insert oEvDay;
          
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

          DRDW_ERLProjectViewCtrl controller = new DRDW_ERLProjectViewCtrl();
          controller.getStatusList();
          controller.activitStatus = 'Assigned';
          controller.executeWrapperGeneratorERL();
          controller.getActivityAreaList();
          controller.validateActivityArea();
          controller.initilizeAssignResource();
          controller.oAssignResource.DRDW_Activity__c = oCap.Id;
          controller.oAssignResource.Allocation_Start_Date__c=system.today();
          controller.oAssignResource.Allocation_End_Date__c = system.today().addDays(4);
          controller.oAssignResource.Hours_Per_Day__c = 9;          
          controller.next();
          controller.assignResource();
          controller.getTotalAllocatedHours(system.today(),system.today().addDays(2),3.0);
          controller.initilizeActivity();
          controller.oActivity.DRDW_Request__c = oRequest.id;
          controller.oActivity.Capability__c = 'test';
          controller.oActivity.Capability_Area__c = 'test';
          controller.oActivity.Planned_Start_Date__c =system.today();
          controller.oActivity.Planned_End_Date__c = system.today().addDays(2);
          controller.oActivity.Title__c ='test';
          controller.saveActivity();          
          controller.export();
          
          controller.oAssignResource.DRDW_Activity__c = oCap.Id;
          controller.oAssignResource.Allocation_Start_Date__c=system.today();
          controller.oAssignResource.Allocation_End_Date__c = system.today();
          controller.oAssignResource.Hours_Per_Day__c = 9;          
          controller.next();
          
          controller.selectedResource = oResource.id;
          controller.assignResource();
        }
    }
      static testMethod void testwithBudget2() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {
          List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');  
          lprojects[0].Project_Name__c='Test';
          lprojects[1].Idea_Name__c='Test';       
            insert lprojects;
            System.debug([Select name from DRDW_Project__c where id =:lprojects[1].Id]);
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Idea Capability',lprojects[0].id);
            insert lCapab;

         


          DRDW_Cap_Request__c oCapReq = new DRDW_Cap_Request__c(Project__c=lprojects[1].Id,Study_Manager__c=busAdm.Id);
          insert oCapReq;
          
           Id requestTypeId = Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('ERL').getRecordTypeId();
            DRDW_Cap_Request__c oRequest = new DRDW_Cap_Request__c();
            oRequest.recordtypeid = requestTypeid;
            oRequest.Project__c=lprojects[0].id;
            insert oRequest;
            System.assertNotEquals(null,oRequest,'error');
            DRDW_Capability__c oCap = new DRDW_Capability__c();
            oCap.Planned_Start_Date__c = system.today();
            oCap.Planned_End_Date__c = system.today().addDays(3);
            oCap.Proposed_Start_Date__c= system.today();
            oCap.Capability__c = 'API Characterization';
            oCap.Capability_Area__c = 'DDS';
            oCap.DRDW_Request__c = oRequest.id;
            insert oCap;                    
            
            DRDW_Capability__c oCap1 = new DRDW_Capability__c();
            oCap1.DRDW_Request__c = oRequest.id;
            insert oCap1;
            
          DRDW_Event__c oEvent = new DRDW_Event__c(DRDW_Activity__c=oCap.Id);
          insert oEvent;

          DRDW_Resource__c oResource = new DRDW_Resource__c(Name__c=busAdm.Id,Department__c='DDS',Type__c='ERL',Role__c='Functional Head',Hours_Available_Per_Day__c=10.00,Hours_per_Week__c=50.00,Status__c='Active');
          insert oResource;

          DRDW_Event_Days__c oEvDay = new DRDW_Event_Days__c(Allocated_Hours__c=10.00,Date__c=System.today(),DRDW_Event__c=oEvent.Id,DRDW_Resource__c=oResource.Id,Type__c='ERL');
          insert oEvDay;
          
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

          DRDW_ERLProjectViewCtrl controller = new DRDW_ERLProjectViewCtrl();
          Test.setCurrentPageReference(new PageReference('DRDW_ERLView'));
          System.currentPageReference().getParameters().put('resourceId', oResource.Id);
          controller.getStatusList();
          controller.activitStatus = 'Assigned';
          controller.executeWrapperGeneratorERL();
          controller.getActivityAreaList();
          controller.validateActivityArea();
          controller.initilizeAssignResource();
         
          
          controller.oAssignResource.DRDW_Activity__c = oCap.Id;
          controller.oAssignResource.Allocation_Start_Date__c=system.today();
          controller.oAssignResource.Allocation_End_Date__c = system.today();
          controller.oAssignResource.Hours_Per_Day__c = 9;          
          controller.next();
          
          System.currentPageReference().getParameters().put('selectedResource', oResource.Id);
          controller.assignResource();
        }
    }
    
    static testMethod void testwithBudget3() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {
          List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');  
          lprojects[0].Project_Name__c='Test';
          lprojects[1].Idea_Name__c='Test';       
            insert lprojects;
            System.debug([Select name from DRDW_Project__c where id =:lprojects[1].Id]);
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Idea Capability',lprojects[0].id);
            insert lCapab;

          DRDW_Cap_Request__c oCapReq = new DRDW_Cap_Request__c(Project__c=lprojects[1].Id,Study_Manager__c=busAdm.Id);
          insert oCapReq;
          
           Id requestTypeId = Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('ERL').getRecordTypeId();
            DRDW_Cap_Request__c oRequest = new DRDW_Cap_Request__c();
            oRequest.recordtypeid = requestTypeid;
            oRequest.Project__c=lprojects[0].id;
            insert oRequest;
            System.assertNotEquals(null,oRequest,'error');
            DRDW_Capability__c oCap = new DRDW_Capability__c();
            oCap.Planned_Start_Date__c = system.today();
            oCap.Planned_End_Date__c = system.today().addDays(3);
            oCap.Proposed_Start_Date__c= system.today();
            oCap.Capability__c = 'API Characterization';
            oCap.Capability_Area__c = 'DDS';
            oCap.DRDW_Request__c = oRequest.id;
            insert oCap;                    
            
            DRDW_Capability__c oCap1 = new DRDW_Capability__c();
            oCap1.DRDW_Request__c = oRequest.id;
            insert oCap1;
            
          DRDW_Event__c oEvent = new DRDW_Event__c(DRDW_Activity__c=oCap.Id);
          insert oEvent;

          DRDW_Resource__c oResource = new DRDW_Resource__c(Name__c=busAdm.Id,Department__c='DDS',Type__c='ERL',Role__c='Functional Head',Hours_Available_Per_Day__c=10.00,Hours_per_Week__c=50.00,Status__c='Active');
          insert oResource;
                   
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

          DRDW_ERLProjectViewCtrl controller = new DRDW_ERLProjectViewCtrl();
          Test.setCurrentPageReference(new PageReference('DRDW_ERLView'));
          System.currentPageReference().getParameters().put('resourceId', oResource.Id);
          controller.getStatusList();
          controller.activitStatus = 'Assigned';
          controller.executeWrapperGeneratorERL();
          controller.getActivityAreaList();
          controller.validateActivityArea();
          controller.initilizeAssignResource();        
          controller.oAssignResource.DRDW_Activity__c = oCap.Id;
          controller.oAssignResource.Allocation_Start_Date__c= system.today();
          controller.oAssignResource.Allocation_End_Date__c = system.today();
          controller.oAssignResource.Hours_Per_Day__c = 9;          
          controller.next();
          
          System.currentPageReference().getParameters().put('selectedResource', oResource.Id);
          controller.assignResource();
          
           controller.initilizeAssignResource();        
          controller.oAssignResource.DRDW_Activity__c = oCap.Id;
          controller.oAssignResource.Allocation_Start_Date__c=system.today().addDays(2);
          controller.oAssignResource.Allocation_End_Date__c = system.today().addDays(2);
          controller.oAssignResource.Hours_Per_Day__c = 9;          
          controller.next();
          
          System.currentPageReference().getParameters().put('selectedResource', oResource.Id);
          controller.assignResource();
          
        }
    }
    
        static testMethod void testwithBudget4() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Project_Manager');
        System.runAs(busAdm) {
          List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');  
          lprojects[0].Project_Name__c='Test';
          lprojects[1].Idea_Name__c='Test';       
            insert lprojects;
            System.debug([Select name from DRDW_Project__c where id =:lprojects[1].Id]);
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Idea Capability',lprojects[0].id);
            insert lCapab;

          DRDW_Cap_Request__c oCapReq = new DRDW_Cap_Request__c(Project__c=lprojects[1].Id,Study_Manager__c=busAdm.Id);
          insert oCapReq;
          
           Id requestTypeId = Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('ERL').getRecordTypeId();
            DRDW_Cap_Request__c oRequest = new DRDW_Cap_Request__c();
            oRequest.recordtypeid = requestTypeid;
            oRequest.Project__c=lprojects[0].id;
            insert oRequest;
            System.assertNotEquals(null,oRequest,'error');
            DRDW_Capability__c oCap = new DRDW_Capability__c();
            oCap.Planned_Start_Date__c = system.today();
            oCap.Planned_End_Date__c = system.today().addDays(3);
            oCap.Proposed_Start_Date__c= system.today();
            oCap.Capability__c = 'API Characterization';
            oCap.Capability_Area__c = 'DDS';
            oCap.DRDW_Request__c = oRequest.id;
            insert oCap;                    
            
            DRDW_Capability__c oCap1 = new DRDW_Capability__c();
            oCap1.DRDW_Request__c = oRequest.id;
            insert oCap1;
            
          DRDW_Event__c oEvent = new DRDW_Event__c(DRDW_Activity__c=oCap.Id);
          insert oEvent;

          DRDW_Resource__c oResource = new DRDW_Resource__c(Name__c=busAdm.Id,Department__c='DDS',Type__c='ERL',Role__c='Functional Head',Hours_Available_Per_Day__c=10.00,Hours_per_Week__c=50.00,Status__c='Active');
          insert oResource;
                   
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

          DRDW_ERLProjectViewCtrl controller = new DRDW_ERLProjectViewCtrl();
          Test.setCurrentPageReference(new PageReference('DRDW_ERLView'));
          System.currentPageReference().getParameters().put('resourceId', oResource.Id);
          controller.getStatusList();
          controller.activitStatus = 'Assigned';
          controller.executeWrapperGeneratorERL();
          controller.getActivityAreaList();
          controller.validateActivityArea();
          controller.initilizeAssignResource();        
          controller.oAssignResource.DRDW_Activity__c = oCap.Id;
          controller.oAssignResource.Allocation_Start_Date__c= system.today();
          controller.oAssignResource.Allocation_End_Date__c = system.today();
          controller.oAssignResource.Hours_Per_Day__c = 9;          
          controller.next();
          
          System.currentPageReference().getParameters().put('selectedResource', oResource.Id);
          controller.assignResource();
          
           controller.initilizeAssignResource();        
          controller.oAssignResource.DRDW_Activity__c = oCap.Id;
          controller.oAssignResource.Allocation_Start_Date__c=system.today().addDays(2);
          controller.oAssignResource.Allocation_End_Date__c = system.today().addDays(3);
          controller.oAssignResource.Hours_Per_Day__c = 9;          
          controller.next();
          
          System.currentPageReference().getParameters().put('selectedResource', oResource.Id);
          controller.assignResource();
          
          controller.initilizeAssignResource();        
          controller.oAssignResource.DRDW_Activity__c = oCap.Id;         
          controller.oAssignResource.Allocation_End_Date__c = system.today().addDays(3);
          controller.oAssignResource.Hours_Per_Day__c = 9;          
          controller.next();
          
          controller.initilizeAssignResource();        
          controller.oAssignResource.DRDW_Activity__c = oCap.Id;
          controller.oAssignResource.Allocation_Start_Date__c=system.today().addDays(2);
          controller.oAssignResource.Allocation_End_Date__c = system.today().addDays(3);
          controller.oAssignResource.Hours_Per_Day__c = -1;          
          controller.next();
          
        }
    }
}