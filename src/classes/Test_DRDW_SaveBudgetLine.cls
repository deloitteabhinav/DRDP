@isTest
private class Test_DRDW_SaveBudgetLine {
    static testmethod void createBudget(){
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) { 
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');         
            insert lprojects;

            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 

            DRDW_Budget_Master__c oBudgetMaster = new DRDW_Budget_Master__c(CurrencyIsoCode='EUR',Total_F_X_Forecast__c=100.00,Total_Business_Plan__c=500.00,Cost_Center__c=oCostCen.Id,Planned_Amount_for_Milestone_1__c=1000.00,
                Planned_Amount_for_Milestone_2__c=1000.00,Planned_Amount_for_Milestone_3__c=1000.00,Planned_Amount_for_Milestone_4__c=1000.00,
                Payment_Milestone_1__c='Initiation of contract',Related_To__c=lprojects[0].Id,Payment_Milestone_2__c='Start of live phase',Payment_Milestone_3__c='End of live phase',Payment_Milestone_4__c='Upon receipt of results',PO__c='41004376612',Vendor__c='TBD');
            insert oBudgetMaster;

            DRDW_Budget_Line_Item__c oLineItem = new DRDW_Budget_Line_Item__c(Save_And_Lock__c=false,Related_To__c=oBudgetMaster.Id,Scientist_Owner__c=busAdm.Id,Vendor__c='TBD',Actual_Amount__c=123,PO__c='4100437669',Posting_Date__c=System.today(),sapid__c='51082926053');
            DRDW_Budget_Line_Item__c oLineItem1 = new DRDW_Budget_Line_Item__c(Save_And_Lock__c=false,Related_To__c=oBudgetMaster.Id,Scientist_Owner__c=busAdm.Id,Vendor__c='TBD',Actual_Amount__c=123,PO__c='4100520312',Posting_Date__c=System.today(),sapid__c='51082932533');
            insert new List<sObject>{oLineItem1,oLineItem};

            DRDW_Bdg_LI_Data_load__c oDataLoad = new DRDW_Bdg_LI_Data_load__c(Related_To__c=oBudgetMaster.id,DRDW_Cost_Center__c = '8600075',PO__c='4100437669',Actual_Amount__c=2000.00,Posting_Date__c=System.today().addMonths(-1),PO_Description__c='Review of AHC2224920 reports',Vendor__c='RYC GMBH',sapid__c='5108292605',Posting_row__c='3',Project_Idea__c='test');
            DRDW_Bdg_LI_Data_load__c oDataLoad1  = new DRDW_Bdg_LI_Data_load__c(Related_To__c=oBudgetMaster.id,DRDW_Cost_Center__c = '8600075',PO__c='4100520312',Actual_Amount__c=9600.00,Posting_Date__c=System.today().addMonths(1),PO_Description__c='EK_MPI_Expert Statement Cardiologist',Vendor__c='MPI RESEARCH INC',sapid__c='5108293253',Posting_row__c='3',Project_Idea__c='test');
            DRDW_Bdg_LI_Data_load__c oDataLoad2  = new DRDW_Bdg_LI_Data_load__c(Related_To__c=oBudgetMaster.id,DRDW_Cost_Center__c = '860075',PO__c='41005202',Actual_Amount__c=9600.00,Posting_Date__c=System.today().addMonths(1),PO_Description__c='EK_MPI_Expert Statement Cardiologist',Vendor__c='MPI RESEARCH INC',sapid__c='5108122123',Posting_row__c='3',Project_Idea__c='test');
            insert new List<sObject>{oDataLoad1,oDataLoad,oDataLoad2};

            DRDW_SaveBudgetLine controller = new DRDW_SaveBudgetLine();
            test.startTest();
            controller.showData();
            controller.RecId=oDataLoad2.id;
            controller.savebdg();
            controller.RecId=oDataLoad2.id;
            controller.updateLists();
            controller.RecId=oDataLoad1.id;
            controller.updateLists();
            System.assertNotEquals(null, oDataLoad1.Id, 'error');
            test.stopTest();
        }
    }   

    static testmethod void createBudget2(){
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) { 
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');         
            insert lprojects;

            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 

            DRDW_Budget_Master__c oBudgetMaster = new DRDW_Budget_Master__c(CurrencyIsoCode='EUR',Total_F_X_Forecast__c=100.00,Total_Business_Plan__c=500.00,Cost_Center__c=oCostCen.Id,Planned_Amount_for_Milestone_1__c=1000.00,
                Planned_Amount_for_Milestone_2__c=1000.00,Planned_Amount_for_Milestone_3__c=1000.00,Planned_Amount_for_Milestone_4__c=1000.00,
                Payment_Milestone_1__c='Initiation of contract',Related_To__c=lprojects[0].Id,Payment_Milestone_2__c='Start of live phase',Payment_Milestone_3__c='End of live phase',Payment_Milestone_4__c='Upon receipt of results',PO__c='41004376612',Vendor__c='TBD');
            insert oBudgetMaster;

            DRDW_Budget_Line_Item__c oLineItem = new DRDW_Budget_Line_Item__c(Save_And_Lock__c=false,Related_To__c=oBudgetMaster.Id,Scientist_Owner__c=busAdm.Id,Vendor__c='TBD',Actual_Amount__c=123,PO__c='4100437669',Posting_Date__c=System.today(),sapid__c='51082926053');
            DRDW_Budget_Line_Item__c oLineItem1 = new DRDW_Budget_Line_Item__c(Save_And_Lock__c=false,Related_To__c=oBudgetMaster.Id,Scientist_Owner__c=busAdm.Id,Vendor__c='TBD',Actual_Amount__c=123,PO__c='4100520312',Posting_Date__c=System.today(),sapid__c='51082932533');
            insert new List<sObject>{oLineItem1,oLineItem};

            DRDW_Bdg_LI_Data_load__c oDataLoad = new DRDW_Bdg_LI_Data_load__c(Related_To__c=oBudgetMaster.id,DRDW_Cost_Center__c = '8600075',PO__c='4100437669',Actual_Amount__c=2000.00,Posting_Date__c=System.today().addMonths(-1),PO_Description__c='Review of AHC2224920 reports',Vendor__c='RYC GMBH',sapid__c='5108292605',Posting_row__c='3',Project_Idea__c='test');
            DRDW_Bdg_LI_Data_load__c oDataLoad1  = new DRDW_Bdg_LI_Data_load__c(Related_To__c=oBudgetMaster.id,DRDW_Cost_Center__c = '8600075',PO__c='4100520312',Actual_Amount__c=9600.00,Posting_Date__c=System.today().addMonths(1),PO_Description__c='EK_MPI_Expert Statement Cardiologist',Vendor__c='MPI RESEARCH INC',sapid__c='5108293253',Posting_row__c='3',Project_Idea__c='test');
            DRDW_Bdg_LI_Data_load__c oDataLoad2  = new DRDW_Bdg_LI_Data_load__c(Related_To__c=oBudgetMaster.id,DRDW_Cost_Center__c = '860075',PO__c='41005202',Actual_Amount__c=9600.00,Posting_Date__c=System.today().addMonths(1),PO_Description__c='EK_MPI_Expert Statement Cardiologist',Vendor__c='MPI RESEARCH INC',sapid__c='5108122123',Posting_row__c='3',Project_Idea__c='test');
            insert new List<sObject>{oDataLoad1,oDataLoad,oDataLoad2};

            DRDW_SaveBudgetLine controller = new DRDW_SaveBudgetLine();
            test.startTest();
            controller.showData();
            controller.RecId=oDataLoad2.id;
            controller.saveandLockNew();
            controller.RecId=oDataLoad1.id;
            controller.SaveUpdatebdg();
            controller.recId=oDataLoad.Id;
            controller.DeleteoldBdg();
            System.assertNotEquals(null, oDataLoad1.Id, 'error');
            test.stopTest();
        }
    }   

    static testmethod void createBudget3(){
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) { 
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');         
            insert lprojects;

            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 

            DRDW_Budget_Master__c oBudgetMaster = new DRDW_Budget_Master__c(CurrencyIsoCode='EUR',Total_F_X_Forecast__c=100.00,Total_Business_Plan__c=500.00,Cost_Center__c=oCostCen.Id,Planned_Amount_for_Milestone_1__c=1000.00,
                Planned_Amount_for_Milestone_2__c=1000.00,Planned_Amount_for_Milestone_3__c=1000.00,Planned_Amount_for_Milestone_4__c=1000.00,
                Payment_Milestone_1__c='Initiation of contract',Related_To__c=lprojects[0].Id,Payment_Milestone_2__c='Start of live phase',Payment_Milestone_3__c='End of live phase',Payment_Milestone_4__c='Upon receipt of results',PO__c='41004376612',Vendor__c='TBD');
            insert oBudgetMaster;

            DRDW_Budget_Line_Item__c oLineItem = new DRDW_Budget_Line_Item__c(Save_And_Lock__c=false,Related_To__c=oBudgetMaster.Id,Scientist_Owner__c=busAdm.Id,Vendor__c='TBD',Actual_Amount__c=123,PO__c='4100437669',Posting_Date__c=System.today(),sapid__c='51082926053');
            DRDW_Budget_Line_Item__c oLineItem1 = new DRDW_Budget_Line_Item__c(Save_And_Lock__c=false,Related_To__c=oBudgetMaster.Id,Scientist_Owner__c=busAdm.Id,Vendor__c='TBD',Actual_Amount__c=123,PO__c='4100520312',Posting_Date__c=System.today(),sapid__c='51082932533');
            insert new List<sObject>{oLineItem1,oLineItem};

            DRDW_Bdg_LI_Data_load__c oDataLoad = new DRDW_Bdg_LI_Data_load__c(Related_To__c=oBudgetMaster.id,DRDW_Cost_Center__c = '8600075',PO__c='4100437669',Actual_Amount__c=2000.00,Posting_Date__c=System.today().addMonths(-1),PO_Description__c='Review of AHC2224920 reports',Vendor__c='RYC GMBH',sapid__c='5108292605',Posting_row__c='3',Project_Idea__c='test');
            DRDW_Bdg_LI_Data_load__c oDataLoad1  = new DRDW_Bdg_LI_Data_load__c(Related_To__c=oBudgetMaster.id,DRDW_Cost_Center__c = '8600075',PO__c='4100520312',Actual_Amount__c=9600.00,Posting_Date__c=System.today().addMonths(1),PO_Description__c='EK_MPI_Expert Statement Cardiologist',Vendor__c='MPI RESEARCH INC',sapid__c='5108293253',Posting_row__c='3',Project_Idea__c='test');
            DRDW_Bdg_LI_Data_load__c oDataLoad2  = new DRDW_Bdg_LI_Data_load__c(Related_To__c=oBudgetMaster.id,DRDW_Cost_Center__c = '860075',PO__c='41005202',Actual_Amount__c=9600.00,Posting_Date__c=System.today().addMonths(1),PO_Description__c='EK_MPI_Expert Statement Cardiologist',Vendor__c='MPI RESEARCH INC',sapid__c='5108122123',Posting_row__c='3',Project_Idea__c='test');
            insert new List<sObject>{oDataLoad1,oDataLoad,oDataLoad2};

            DRDW_SaveBudgetLine controller = new DRDW_SaveBudgetLine();
            test.startTest();
            controller.showData();
            controller.RecId=oDataLoad2.id;
            controller.updateLists();
            controller.showData();
            controller.RecId=oDataLoad1.id;
            controller.SaveUpdatebdg();
            controller.RecId=oDataLoad.id;
            controller.oldsaveNlock();
            controller.recId=oDataLoad2.id;
            controller.DeleteBdgNew();
            System.assertNotEquals(null, oDataLoad1.Id, 'error');
            test.stopTest();
        }
    }   
}