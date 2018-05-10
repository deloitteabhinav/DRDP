@isTest(seeAllData=False)
private class Test_DRDW_CreateExternalActivity {
	static testmethod void testwithRecord(){
        User busAdm = DRDW_TestDataFactory.getTestingUser();
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin'); 
        System.runAs(busAdm) {
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');
            insert lprojects;
            system.assertEquals(2,lprojects.size());
            List<DRDW_Capability__c> lcaps = DRDW_TestDataFactory.returnCapabilities(2,'External Activity',lprojects[0].id);
            insert lcaps;
            system.assertEquals(2,lcaps.size());

            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 

            DRDW_Budget_Master__c oBudgetMaster = new DRDW_Budget_Master__c(CurrencyIsoCode='EUR',Total_F_X_Forecast__c=100.00,Total_Business_Plan__c=500.00,Cost_Center__c=oCostCen.Id,Planned_Amount_for_Milestone_1__c=1000.00,
            	Planned_Amount_for_Milestone_2__c=1000.00,Planned_Amount_for_Milestone_3__c=1000.00,Planned_Amount_for_Milestone_4__c=1000.00,
            	Payment_Milestone_1__c='Initiation of contract',Related_To__c=lprojects[0].Id,Activity__c=lcaps[0].Id,Payment_Milestone_2__c='Start of live phase',Payment_Milestone_3__c='End of live phase',Payment_Milestone_4__c='Upon receipt of results');
            insert oBudgetMaster;

			DRDW_Budget_Summary__c oBudSum = new DRDW_Budget_Summary__c(CurrencyIsoCode='EUR',F_X_Forecast__c=12.30,Year__c='2019',Quarter__c='1',Business_Plan__c=122.00,DRDW_Budget_Master__c=oBudgetMaster.Id,PO__c='TBD');
            DRDW_Budget_Summary__c oBudSum1 = new DRDW_Budget_Summary__c(CurrencyIsoCode='EUR',F_X_Forecast__c=12.30,Year__c='2019',Quarter__c='2',Business_Plan__c=122.00,DRDW_Budget_Master__c=oBudgetMaster.Id,PO__c='TBD');
            insert new List<sObject>{oBudSum,oBudSum1};

            GLBL_Global_List_of_Values__c oglov = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Capability').getRecordTypeId());
            insert oglov;

            PageReference pageRef = new pageReference('/apex/DRDW_CreateExternalActivity?Id='+lcaps[0].id);
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(lcaps[0]);
            test.startTest();
            DRDW_CreateExternalActivity controller = new DRDW_CreateExternalActivity(sc);  
            controller.save();
            controller.editRecord();
            controller.CancelRecord();
            controller.addError('test');
            controller.RemoveBudget();
            controller.lCapabilityPicklist=new List<SelectOption>();
            controller.UpdateArea();
            controller.AddBudget();
            controller.AddBudgetCap();
            controller.BudgetLink();
            controller.genericId=oBudgetMaster.Id;
            controller.RemoveBudget();
            controller.DeleteRecord();
            test.stopTest();
        }
    }

    static testmethod void testWithoutRecord(){
        User finUsr = DRDW_TestDataFactory.getTestingUser();
        DRDW_TestDataFactory.givePermissions(finUsr.id,'DRDW_Financial_User');       
        System.runAs(finUsr) {
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Idea Project');
            insert lprojects;
            system.assertEquals(2,lprojects.size());
            List<DRDW_Capability__c> lcaps = DRDW_TestDataFactory.returnCapabilities(2,'External Activity',lprojects[0].id);
            insert lcaps;
            system.assertEquals(2,lcaps.size());

            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 

            DRDW_Budget_Master__c oBudgetMaster = new DRDW_Budget_Master__c(CurrencyIsoCode='EUR',Total_F_X_Forecast__c=100.00,Total_Business_Plan__c=500.00,Cost_Center__c=oCostCen.Id,Planned_Amount_for_Milestone_1__c=1000.00,
            	Planned_Amount_for_Milestone_2__c=1000.00,Planned_Amount_for_Milestone_3__c=1000.00,Planned_Amount_for_Milestone_4__c=1000.00,
            	Payment_Milestone_1__c='Initiation of contract',Related_To__c=lprojects[0].Id,Activity__c=lcaps[0].Id,Payment_Milestone_2__c='Start of live phase',Payment_Milestone_3__c='End of live phase',Payment_Milestone_4__c='Upon receipt of results');
            insert oBudgetMaster;

			DRDW_Budget_Summary__c oBudSum = new DRDW_Budget_Summary__c(CurrencyIsoCode='EUR',F_X_Forecast__c=12.30,Year__c='2019',Quarter__c='2',Business_Plan__c=122.00,DRDW_Budget_Master__c=oBudgetMaster.Id,PO__c='TBD');
			DRDW_Budget_Summary__c oBudSum1 = new DRDW_Budget_Summary__c(CurrencyIsoCode='EUR',F_X_Forecast__c=12.30,Year__c='2019',Quarter__c='3',Business_Plan__c=122.00,DRDW_Budget_Master__c=oBudgetMaster.Id,PO__c='TBD');
            insert new List<sObject>{oBudSum,oBudSum1};

            GLBL_Global_List_of_Values__c oglov = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Capability').getRecordTypeId());
            insert oglov;

            PageReference pageRef = new pageReference('/apex/DRDW_CreateExternalActivity');
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(lcaps[0]);
            test.startTest();            
            DRDW_CreateExternalActivity controller = new DRDW_CreateExternalActivity(sc);  
            controller.save();
            List<DRDW_Capability__c> lCapability = DRDW_TestDataFactory.returnCapabilities(1,'External Activity',lprojects[0].id);
            ApexPages.StandardController sc1 = new ApexPages.StandardController(lCapability[0]);
            DRDW_CreateExternalActivity cont1 = new DRDW_CreateExternalActivity(sc1);  
            cont1.save();
            test.stopTest();
        }
    }

    static testmethod void testwithRecord2(){
        User busAdm = DRDW_TestDataFactory.getTestingUser();
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin'); 
        System.runAs(busAdm) {
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Assessment Project');
            insert lprojects;
            system.assertEquals(2,lprojects.size());
            List<DRDW_Capability__c> lcaps = DRDW_TestDataFactory.returnCapabilities(2,'External Activity',lprojects[0].id);
            insert lcaps;
            system.assertEquals(2,lcaps.size());

            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 

            DRDW_Budget_Master__c oBudgetMaster = new DRDW_Budget_Master__c(CurrencyIsoCode='EUR',Total_F_X_Forecast__c=100.00,Total_Business_Plan__c=500.00,Cost_Center__c=oCostCen.Id,Planned_Amount_for_Milestone_1__c=1000.00,
                Planned_Amount_for_Milestone_2__c=1000.00,Planned_Amount_for_Milestone_3__c=1000.00,Planned_Amount_for_Milestone_4__c=1000.00,
                Payment_Milestone_1__c='Initiation of contract',Related_To__c=lprojects[0].Id,Activity__c=lcaps[0].Id,Payment_Milestone_2__c='Start of live phase',Payment_Milestone_3__c='End of live phase',Payment_Milestone_4__c='Upon receipt of results');
            insert oBudgetMaster;

            DRDW_Budget_Summary__c oBudSum = new DRDW_Budget_Summary__c(CurrencyIsoCode='EUR',F_X_Forecast__c=12.30,Year__c='2019',Quarter__c='1',Business_Plan__c=122.00,DRDW_Budget_Master__c=oBudgetMaster.Id,PO__c='TBD');
            insert oBudSum;

            GLBL_Global_List_of_Values__c oglov = new GLBL_Global_List_of_Values__c(name='Test',Active__c=true,RecordTypeId=Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Capability').getRecordTypeId());
            insert oglov;

            PageReference pageRef = new pageReference('/apex/DRDW_CreateExternalActivity?Id='+lcaps[0].id);
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(lcaps[0]);
            test.startTest();
            DRDW_CreateExternalActivity controller = new DRDW_CreateExternalActivity(sc); 
            test.stopTest();
        }
    }
}