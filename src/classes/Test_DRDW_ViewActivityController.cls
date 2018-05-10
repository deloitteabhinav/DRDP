@isTest
private class Test_DRDW_ViewActivityController {
     static testMethod void testPositive() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        DRDW_TestDataFactory.assignGroup(busAdm.id,'DRDW_FG_Bacteriology');
        DRDW_TestDataFactory.assignGroup(busAdm.id,'DRDW_BU_Business_Development');
        System.runAs(busAdm) {   
            List<DRDW_Project__c> lAssessments = DRDW_TestDataFactory.returnProjects(2,'Assessment Project');
            insert lAssessments;

            System.assert(lAssessments.size()==2);

            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 

            DRDW_Cap_Request__c ocapReq = new DRDW_Cap_Request__c(GO_Preferred_Start_Date__c=System.today()+2,Lab_Testing_Required__c='Lab Challenge Preparation;Lab Vaccination Preparation',samples_to_collect_new__c='[Tissue Sample,Oral Swabs]',Project__c=lAssessments[0].Id,Actual_Start_Date__c=System.today(),Actual_End_Date__c=System.today()+5,RecordTypeId=Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('ERL').getRecordTypeId());
            insert ocapReq;
            
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Request Activity',lAssessments[0].id);
            lCapab[0].DRDW_Request__c=ocapReq.Id;
            insert lCapab;

            DRDW_Budget_Master__c oBudgetMaster = new DRDW_Budget_Master__c(CurrencyIsoCode='EUR',Total_F_X_Forecast__c=100.00,Total_Business_Plan__c=500.00,Cost_Center__c=oCostCen.Id,Planned_Amount_for_Milestone_1__c=1000.00,
                Planned_Amount_for_Milestone_2__c=1000.00,Planned_Amount_for_Milestone_3__c=1000.00,Planned_Amount_for_Milestone_4__c=1000.00,
                Payment_Milestone_1__c='Initiation of contract',Related_To__c=lAssessments[0].Id,Activity__c=lCapab[0].Id,Payment_Milestone_2__c='Start of live phase',Payment_Milestone_3__c='End of live phase',Payment_Milestone_4__c='Upon receipt of results');
            insert oBudgetMaster;

            DRDW_Budget_Summary__c oBudSum = new DRDW_Budget_Summary__c(CurrencyIsoCode='EUR',F_X_Forecast__c=12.30,Year__c='2019',Quarter__c='1',Business_Plan__c=122.00,DRDW_Budget_Master__c=oBudgetMaster.Id,PO__c='TBD');            
            insert oBudSum;

            GLBL_Global_List_of_Values__c oglov = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Capability Area').getRecordTypeId());
            insert oglov;

            test.StartTest();
            DRDW_Event__c oEvent = new DRDW_Event__c(Event_Dates__c='04/26/2018,05/26/2018',Type__c='GO',Status__c='Partially Assigned',DRDW_Activity__c=lCapab[0].Id,Event_Category__c='Lab',Event_Type__c='Lab Work Required',Frequency__c='-27,-3,2,3');
            insert oEvent;

            DRDW_Resource__c oResource = new DRDW_Resource__c(Name__c=busAdm.Id,Department__c='DDS',Type__c='ERL',Role__c='Functional Head',Hours_Available_Per_Day__c=10.00,Hours_per_Week__c=50.00,Status__c='Active');
            insert oResource;

            DRDW_Assign_Resource__c oAssignResource =new DRDW_Assign_Resource__c(Activity_Area__c='test',Activity_Title__c='test',Allocation_Start_Date__c=System.today(),Allocation_End_Date__c=System.today()+5,DRDW_Activity__c=lCapab[0].Id,DRDW_Event__c=oEvent.id,DRDW_Resources__c=oResource.Id,Hours_Per_Day__c=5);
            insert oAssignResource;

            PageReference pagRef = new PageReference('/apex/DRDW_ViewActivity?id='+lCapab[0].Id);
            Test.setCurrentPage(pagRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(lCapab[0]);
            DRDW_ViewActivityController controller = new DRDW_ViewActivityController(sc);
            controller.RemoveBudget();
            controller.AddBudget();
            controller.AddBudgetCap();
            controller.BudgetLink();
            controller.addError('Test');
            controller.genericID=oBudgetMaster.Id;
            controller.RemoveBudget();
            test.StopTest();
            controller.resourseId=oAssignResource.Id;
            controller.deleteRes();
            controller.groupBuAssigned();
            controller.edit();
            controller.save();
            System.assertNotEquals(null, oAssignResource.Id, 'error');  
        }
    }

    static testMethod void testPermissions() {        
        User funcHead = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(funcHead.id,'DRDW_Functional_Head');
        User projMgr = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(projMgr.id,'DRDW_Project_Manager');
        System.runAs(funcHead) {   
            List<DRDW_Project__c> lAssessments = DRDW_TestDataFactory.returnProjects(1,'Generation Project');
            insert lAssessments;

            System.assert(lAssessments.size()==1);

            DRDW_Cap_Request__c ocapReq = new DRDW_Cap_Request__c(GO_Preferred_Start_Date__c=System.today()+2,Lab_Testing_Required__c='Lab Challenge Preparation;Lab Vaccination Preparation',samples_to_collect_new__c='[Tissue Sample,Oral Swabs]',Project__c=lAssessments[0].Id,Actual_Start_Date__c=System.today(),Actual_End_Date__c=System.today()+5,RecordTypeId=Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('ERL').getRecordTypeId());
            insert ocapReq;          

            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Request Activity',lAssessments[0].id);            
            lCapab[0].DRDW_Request__c=ocapReq.Id;
            insert lCapab;

            PageReference pagRef = new PageReference('/apex/DRDW_ViewActivity?id='+lCapab[0].Id);
            Test.setCurrentPage(pagRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(lCapab[0]);
            DRDW_ViewActivityController controller = new DRDW_ViewActivityController(sc);            
        }
        System.runAs(projMgr) {   
            test.startTest();
            List<DRDW_Project__c> lAssessments = DRDW_TestDataFactory.returnProjects(1,'Idea Project');
            insert lAssessments;

            System.assert(lAssessments.size()==1);

            DRDW_Cap_Request__c ocapReq = new DRDW_Cap_Request__c(GO_Preferred_Start_Date__c=System.today()+2,Lab_Testing_Required__c='Lab Challenge Preparation;Lab Vaccination Preparation',samples_to_collect_new__c='[Tissue Sample,Oral Swabs]',Project__c=lAssessments[0].Id,Actual_Start_Date__c=System.today(),Actual_End_Date__c=System.today()+5,RecordTypeId=Schema.SObjectType.DRDW_Cap_Request__c.getRecordTypeInfosByName().get('ERL').getRecordTypeId());
            insert ocapReq;          

            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Request Activity',lAssessments[0].id);            
            lCapab[0].DRDW_Request__c=ocapReq.Id;
            insert lCapab;
            
            PageReference pagRef = new PageReference('/apex/DRDW_ViewActivity?id='+lCapab[0].Id);
            Test.setCurrentPage(pagRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(lCapab[0]);
            DRDW_ViewActivityController controller = new DRDW_ViewActivityController(sc); 
            System.assertNotEquals(null, ocapReq.Id, 'error');    
            test.StopTest();       
        }        
    }
}