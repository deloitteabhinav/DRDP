@isTest
private class Test_DRDW_BudgetLineItemTriggerHandler {
    public static Date Jan = Date.newInstance(System.today().Year(), 1, 17);
    public static Date Feb = Date.newInstance(System.today().Year(), 2, 17);
    public static Date March =  Date.newInstance(System.today().Year(), 3, 17);
    public static Date April =  Date.newInstance(System.today().Year(), 4, 17);
    public static Date May =  Date.newInstance(System.today().Year(), 5, 17);
    public static Date June =  Date.newInstance(System.today().Year(), 6, 17);
    public static Date July =  Date.newInstance(System.today().Year(), 7, 17);
    public static Date August =  Date.newInstance(System.today().Year(), 8, 17);
    public static Date September =  Date.newInstance(System.today().Year(), 9, 17);
    public static Date October =  Date.newInstance(System.today().Year(), 10, 17);
    public static Date November = Date.newInstance(System.today().Year(), 11, 17);
    public static Date December =  Date.newInstance(System.today().Year(), 12, 17);
    static testMethod void testwithBudget() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {            
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Assessment Project');         
            insert lprojects;
            System.assert(lprojects.size()==2);
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Idea Capability',lprojects[0].id);
            insert lCapab;

            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 

            DRDW_Budget_Master__c oBudgetMaster = new DRDW_Budget_Master__c(CurrencyIsoCode='EUR',Total_F_X_Forecast__c=100.00,Total_Business_Plan__c=500.00,Cost_Center__c=oCostCen.Id,Planned_Amount_for_Milestone_1__c=1000.00,
            Planned_Amount_for_Milestone_2__c=1000.00,Planned_Amount_for_Milestone_3__c=1000.00,Planned_Amount_for_Milestone_4__c=1000.00,
            Payment_Milestone_1__c='Initiation of contract',Related_To__c=lprojects[0].Id,Payment_Milestone_2__c='Start of live phase',Payment_Milestone_3__c='End of live phase',Payment_Milestone_4__c='Upon receipt of results',PO__c='41004376612',Vendor__c='TBD');
            insert oBudgetMaster;

            Test.setCreatedDate(oBudgetMaster.Id, DateTime.newInstance(2012,12,12));  
            test.startTest();

            Integer tempqrtr = Jan.month();
            String quarter;
            if(tempqrtr > 0 && tempqrtr < 4){
                quarter = '1';
            }else if(tempqrtr > 3 && tempqrtr < 7){
                quarter = '2';
            }else if(tempqrtr > 6 && tempqrtr < 10){
                quarter = '3';
            }else if(tempqrtr > 9 && tempqrtr < 13){
                quarter = '4';
            }

            Database.delete([Select Id,Name,Quarter__c,Year__c from DRDW_Budget_Summary__c where Quarter__c=:quarter]);

            DRDW_Budget_Line_Item__c oLineItem = new DRDW_Budget_Line_Item__c(Save_And_Lock__c=false,Related_To__c=oBudgetMaster.Id,Scientist_Owner__c=busAdm.Id,Vendor__c='TBD',Actual_Amount__c=123,PO__c='4100437669',Posting_Date__c=Jan,sapid__c='51082926053');
            insert oLineItem;
            System.assertNotEquals(null,busAdm.Id,'error'); 
            test.stopTest();

            DRDW_budgetLineItemTriggerHandler.getCurrentMonths('1');
            DRDW_budgetLineItemTriggerHandler.getCurrentMonths('2');
            DRDW_budgetLineItemTriggerHandler.getCurrentMonths('3');
            DRDW_budgetLineItemTriggerHandler.getCurrentMonths('4');

            delete oLineItem;
        }
    }       

    static testMethod void testwithBudget2() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {            
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Assessment Project');         
            insert lprojects;
            System.assert(lprojects.size()==2);
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Idea Capability',lprojects[0].id);
            insert lCapab;

            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 

            DRDW_Budget_Master__c oBudgetMaster = new DRDW_Budget_Master__c(CurrencyIsoCode='EUR',Total_F_X_Forecast__c=100.00,Total_Business_Plan__c=500.00,Cost_Center__c=oCostCen.Id,Planned_Amount_for_Milestone_1__c=1000.00,
            Planned_Amount_for_Milestone_2__c=1000.00,Planned_Amount_for_Milestone_3__c=1000.00,Planned_Amount_for_Milestone_4__c=1000.00,
            Payment_Milestone_1__c='Initiation of contract',Related_To__c=lprojects[0].Id,Payment_Milestone_2__c='Start of live phase',Payment_Milestone_3__c='End of live phase',Payment_Milestone_4__c='Upon receipt of results',PO__c='41004376612',Vendor__c='TBD');
            insert oBudgetMaster;

            Test.setCreatedDate(oBudgetMaster.Id, DateTime.newInstance(2012,12,12));  
            test.startTest();

            Integer tempqrtr = Feb.month();
            String quarter;
            if(tempqrtr > 0 && tempqrtr < 4){
                quarter = '1';
            }else if(tempqrtr > 3 && tempqrtr < 7){
                quarter = '2';
            }else if(tempqrtr > 6 && tempqrtr < 10){
                quarter = '3';
            }else if(tempqrtr > 9 && tempqrtr < 13){
                quarter = '4';
            }

            

            Database.delete([Select Id,Name,Quarter__c,Year__c from DRDW_Budget_Summary__c where Quarter__c=:quarter]);

            DRDW_Budget_Line_Item__c oLineItem = new DRDW_Budget_Line_Item__c(Save_And_Lock__c=false,Related_To__c=oBudgetMaster.Id,Scientist_Owner__c=busAdm.Id,Vendor__c='TBD',Actual_Amount__c=123,PO__c='4100437669',Posting_Date__c=Feb,sapid__c='51082926053');
            insert oLineItem;
            System.assertNotEquals(null,busAdm.Id,'error'); 
            test.stopTest();
            delete oLineItem;            
        }
    }   
    static testMethod void testwithBudget3() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {            
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Assessment Project');         
            insert lprojects;
            System.assert(lprojects.size()==2);
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Idea Capability',lprojects[0].id);
            insert lCapab;
            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 
            DRDW_Budget_Master__c oBudgetMaster = new DRDW_Budget_Master__c(CurrencyIsoCode='EUR',Total_F_X_Forecast__c=100.00,Total_Business_Plan__c=500.00,Cost_Center__c=oCostCen.Id,Planned_Amount_for_Milestone_1__c=1000.00,
            Planned_Amount_for_Milestone_2__c=1000.00,Planned_Amount_for_Milestone_3__c=1000.00,Planned_Amount_for_Milestone_4__c=1000.00,
            Payment_Milestone_1__c='Initiation of contract',Related_To__c=lprojects[0].Id,Payment_Milestone_2__c='Start of live phase',Payment_Milestone_3__c='End of live phase',Payment_Milestone_4__c='Upon receipt of results',PO__c='41004376612',Vendor__c='TBD');
            insert oBudgetMaster;
            test.startTest();
            Integer tempqrtr = March.month();
            String quarter;
            if(tempqrtr > 0 && tempqrtr < 4){
                quarter = '1';
            }else if(tempqrtr > 3 && tempqrtr < 7){
                quarter = '2';
            }else if(tempqrtr > 6 && tempqrtr < 10){
                quarter = '3';
            }else if(tempqrtr > 9 && tempqrtr < 13){
                quarter = '4';
            }
            
            Database.delete([Select Id,Name,Quarter__c,Year__c from DRDW_Budget_Summary__c where Quarter__c=:quarter]);
            DRDW_Budget_Line_Item__c oLineItem = new DRDW_Budget_Line_Item__c(Save_And_Lock__c=false,Related_To__c=oBudgetMaster.Id,Scientist_Owner__c=busAdm.Id,Vendor__c='TBD',Actual_Amount__c=123,PO__c='4100437669',Posting_Date__c=March,sapid__c='51082926053');
            insert oLineItem;
            System.assertNotEquals(null,busAdm.Id,'error'); 
            test.stopTest();
            delete oLineItem;            
        }
    }  

    static testMethod void testwithBudget4() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {            
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Assessment Project');         
            insert lprojects;
            System.assert(lprojects.size()==2);
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Idea Capability',lprojects[0].id);
            insert lCapab;
            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 
            DRDW_Budget_Master__c oBudgetMaster = new DRDW_Budget_Master__c(CurrencyIsoCode='EUR',Total_F_X_Forecast__c=100.00,Total_Business_Plan__c=500.00,Cost_Center__c=oCostCen.Id,Planned_Amount_for_Milestone_1__c=1000.00,
            Planned_Amount_for_Milestone_2__c=1000.00,Planned_Amount_for_Milestone_3__c=1000.00,Planned_Amount_for_Milestone_4__c=1000.00,
            Payment_Milestone_1__c='Initiation of contract',Related_To__c=lprojects[0].Id,Payment_Milestone_2__c='Start of live phase',Payment_Milestone_3__c='End of live phase',Payment_Milestone_4__c='Upon receipt of results',PO__c='41004376612',Vendor__c='TBD');
            insert oBudgetMaster;
            test.startTest();
            Integer tempqrtr = April.month();
            String quarter;
            if(tempqrtr > 0 && tempqrtr < 4){
                quarter = '1';
            }else if(tempqrtr > 3 && tempqrtr < 7){
                quarter = '2';
            }else if(tempqrtr > 6 && tempqrtr < 10){
                quarter = '3';
            }else if(tempqrtr > 9 && tempqrtr < 13){
                quarter = '4';
            }
            
            Database.delete([Select Id,Name,Quarter__c,Year__c from DRDW_Budget_Summary__c where Quarter__c=:quarter]);
            DRDW_Budget_Line_Item__c oLineItem = new DRDW_Budget_Line_Item__c(Save_And_Lock__c=false,Related_To__c=oBudgetMaster.Id,Scientist_Owner__c=busAdm.Id,Vendor__c='TBD',Actual_Amount__c=123,PO__c='4100437669',Posting_Date__c=April,sapid__c='51082926053');
            insert oLineItem;
            System.assertNotEquals(null,busAdm.Id,'error'); 
            test.stopTest();
            delete oLineItem;            
        }
    }       

    static testMethod void testwithBudget5() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {            
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Assessment Project');         
            insert lprojects;        
            System.assert(lprojects.size()==2);
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Idea Capability',lprojects[0].id);
            insert lCapab;
            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 
            DRDW_Budget_Master__c oBudgetMaster = new DRDW_Budget_Master__c(CurrencyIsoCode='EUR',Total_F_X_Forecast__c=100.00,Total_Business_Plan__c=500.00,Cost_Center__c=oCostCen.Id,Planned_Amount_for_Milestone_1__c=1000.00,
            Planned_Amount_for_Milestone_2__c=1000.00,Planned_Amount_for_Milestone_3__c=1000.00,Planned_Amount_for_Milestone_4__c=1000.00,
            Payment_Milestone_1__c='Initiation of contract',Related_To__c=lprojects[0].Id,Payment_Milestone_2__c='Start of live phase',Payment_Milestone_3__c='End of live phase',Payment_Milestone_4__c='Upon receipt of results',PO__c='41004376612',Vendor__c='TBD');
            insert oBudgetMaster;
            test.startTest();
            Integer tempqrtr = May.month();
            String quarter;
            if(tempqrtr > 0 && tempqrtr < 4){
                quarter = '1';
            }else if(tempqrtr > 3 && tempqrtr < 7){
                quarter = '2';
            }else if(tempqrtr > 6 && tempqrtr < 10){
                quarter = '3';
            }else if(tempqrtr > 9 && tempqrtr < 13){
                quarter = '4';
            }
            
            Database.delete([Select Id,Name,Quarter__c,Year__c from DRDW_Budget_Summary__c where Quarter__c=:quarter]);
            DRDW_Budget_Line_Item__c oLineItem = new DRDW_Budget_Line_Item__c(Save_And_Lock__c=false,Related_To__c=oBudgetMaster.Id,Scientist_Owner__c=busAdm.Id,Vendor__c='TBD',Actual_Amount__c=123,PO__c='4100437669',Posting_Date__c=May,sapid__c='51082926053');
            insert oLineItem;
            System.assertNotEquals(null,busAdm.Id,'error'); 
            test.stopTest();
            delete oLineItem;            
        }
    }       

    static testMethod void testwithBudget6() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {            
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Assessment Project');         
            insert lprojects;

            System.assert(lprojects.size()==2);
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Idea Capability',lprojects[0].id);
            insert lCapab;
            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 
            DRDW_Budget_Master__c oBudgetMaster = new DRDW_Budget_Master__c(CurrencyIsoCode='EUR',Total_F_X_Forecast__c=100.00,Total_Business_Plan__c=500.00,Cost_Center__c=oCostCen.Id,Planned_Amount_for_Milestone_1__c=1000.00,
            Planned_Amount_for_Milestone_2__c=1000.00,Planned_Amount_for_Milestone_3__c=1000.00,Planned_Amount_for_Milestone_4__c=1000.00,
            Payment_Milestone_1__c='Initiation of contract',Related_To__c=lprojects[0].Id,Payment_Milestone_2__c='Start of live phase',Payment_Milestone_3__c='End of live phase',Payment_Milestone_4__c='Upon receipt of results',PO__c='41004376612',Vendor__c='TBD');
            insert oBudgetMaster;
            test.startTest();
            Integer tempqrtr = June.month();
            String quarter;
            if(tempqrtr > 0 && tempqrtr < 4){
                quarter = '1';
            }else if(tempqrtr > 3 && tempqrtr < 7){
                quarter = '2';
            }else if(tempqrtr > 6 && tempqrtr < 10){
                quarter = '3';
            }else if(tempqrtr > 9 && tempqrtr < 13){
                quarter = '4';
            }
            
            Database.delete([Select Id,Name,Quarter__c,Year__c from DRDW_Budget_Summary__c where Quarter__c=:quarter]);
            DRDW_Budget_Line_Item__c oLineItem = new DRDW_Budget_Line_Item__c(Save_And_Lock__c=false,Related_To__c=oBudgetMaster.Id,Scientist_Owner__c=busAdm.Id,Vendor__c='TBD',Actual_Amount__c=123,PO__c='4100437669',Posting_Date__c=June,sapid__c='51082926053');
            insert oLineItem;
           System.assertNotEquals(null,busAdm.Id,'error');
            test.stopTest();
            delete oLineItem;            
        }
    }       
    static testMethod void testwithBudget7() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {            
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Assessment Project');         
            insert lprojects;
            System.assert(lprojects.size()==2);
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Idea Capability',lprojects[0].id);
            insert lCapab;
            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 
            DRDW_Budget_Master__c oBudgetMaster = new DRDW_Budget_Master__c(CurrencyIsoCode='EUR',Total_F_X_Forecast__c=100.00,Total_Business_Plan__c=500.00,Cost_Center__c=oCostCen.Id,Planned_Amount_for_Milestone_1__c=1000.00,
            Planned_Amount_for_Milestone_2__c=1000.00,Planned_Amount_for_Milestone_3__c=1000.00,Planned_Amount_for_Milestone_4__c=1000.00,
            Payment_Milestone_1__c='Initiation of contract',Related_To__c=lprojects[0].Id,Payment_Milestone_2__c='Start of live phase',Payment_Milestone_3__c='End of live phase',Payment_Milestone_4__c='Upon receipt of results',PO__c='41004376612',Vendor__c='TBD');
            insert oBudgetMaster;
            test.startTest();
            Integer tempqrtr = July.month();
            String quarter;
            if(tempqrtr > 0 && tempqrtr < 4){
                quarter = '1';
            }else if(tempqrtr > 3 && tempqrtr < 7){
                quarter = '2';
            }else if(tempqrtr > 6 && tempqrtr < 10){
                quarter = '3';
            }else if(tempqrtr > 9 && tempqrtr < 13){
                quarter = '4';
            }
            
            Database.delete([Select Id,Name,Quarter__c,Year__c from DRDW_Budget_Summary__c where Quarter__c=:quarter]);
            DRDW_Budget_Line_Item__c oLineItem = new DRDW_Budget_Line_Item__c(Save_And_Lock__c=false,Related_To__c=oBudgetMaster.Id,Scientist_Owner__c=busAdm.Id,Vendor__c='TBD',Actual_Amount__c=123,PO__c='4100437669',Posting_Date__c=July,sapid__c='51082926053');
            insert oLineItem;
            System.assertNotEquals(null,busAdm.Id,'error');
            test.stopTest();
            delete oLineItem;            
        }
    }       
    static testMethod void testwithBudget8() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {            
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Assessment Project');         
            insert lprojects;
            System.assert(lprojects.size()==2);
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Idea Capability',lprojects[0].id);
            insert lCapab;
            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 
            DRDW_Budget_Master__c oBudgetMaster = new DRDW_Budget_Master__c(CurrencyIsoCode='EUR',Total_F_X_Forecast__c=100.00,Total_Business_Plan__c=500.00,Cost_Center__c=oCostCen.Id,Planned_Amount_for_Milestone_1__c=1000.00,
            Planned_Amount_for_Milestone_2__c=1000.00,Planned_Amount_for_Milestone_3__c=1000.00,Planned_Amount_for_Milestone_4__c=1000.00,
            Payment_Milestone_1__c='Initiation of contract',Related_To__c=lprojects[0].Id,Payment_Milestone_2__c='Start of live phase',Payment_Milestone_3__c='End of live phase',Payment_Milestone_4__c='Upon receipt of results',PO__c='41004376612',Vendor__c='TBD');
            insert oBudgetMaster;
            test.startTest();
            Integer tempqrtr = August.month();
            String quarter;
            if(tempqrtr > 0 && tempqrtr < 4){
                quarter = '1';
            }else if(tempqrtr > 3 && tempqrtr < 7){
                quarter = '2';
            }else if(tempqrtr > 6 && tempqrtr < 10){
                quarter = '3';
            }else if(tempqrtr > 9 && tempqrtr < 13){
                quarter = '4';
            }
            
            Database.delete([Select Id,Name,Quarter__c,Year__c from DRDW_Budget_Summary__c where Quarter__c=:quarter]);
            DRDW_Budget_Line_Item__c oLineItem = new DRDW_Budget_Line_Item__c(Save_And_Lock__c=false,Related_To__c=oBudgetMaster.Id,Scientist_Owner__c=busAdm.Id,Vendor__c='TBD',Actual_Amount__c=123,PO__c='4100437669',Posting_Date__c=August,sapid__c='51082926053');
            insert oLineItem;
            System.assertNotEquals(null,busAdm.Id,'error');
            test.stopTest();
            delete oLineItem;            
        }
    }       
    static testMethod void testwithBudget9() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {            
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Assessment Project');         
            insert lprojects;
            System.assert(lprojects.size()==2);
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Idea Capability',lprojects[0].id);
            insert lCapab;
            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 
            DRDW_Budget_Master__c oBudgetMaster = new DRDW_Budget_Master__c(CurrencyIsoCode='EUR',Total_F_X_Forecast__c=100.00,Total_Business_Plan__c=500.00,Cost_Center__c=oCostCen.Id,Planned_Amount_for_Milestone_1__c=1000.00,
            Planned_Amount_for_Milestone_2__c=1000.00,Planned_Amount_for_Milestone_3__c=1000.00,Planned_Amount_for_Milestone_4__c=1000.00,
            Payment_Milestone_1__c='Initiation of contract',Related_To__c=lprojects[0].Id,Payment_Milestone_2__c='Start of live phase',Payment_Milestone_3__c='End of live phase',Payment_Milestone_4__c='Upon receipt of results',PO__c='41004376612',Vendor__c='TBD');
            insert oBudgetMaster;
            test.startTest();
            Integer tempqrtr = September.month();
            String quarter;
            if(tempqrtr > 0 && tempqrtr < 4){
                quarter = '1';
            }else if(tempqrtr > 3 && tempqrtr < 7){
                quarter = '2';
            }else if(tempqrtr > 6 && tempqrtr < 10){
                quarter = '3';
            }else if(tempqrtr > 9 && tempqrtr < 13){
                quarter = '4';
            }
            
            Database.delete([Select Id,Name,Quarter__c,Year__c from DRDW_Budget_Summary__c where Quarter__c=:quarter]);
            DRDW_Budget_Line_Item__c oLineItem = new DRDW_Budget_Line_Item__c(Save_And_Lock__c=false,Related_To__c=oBudgetMaster.Id,Scientist_Owner__c=busAdm.Id,Vendor__c='TBD',Actual_Amount__c=123,PO__c='4100437669',Posting_Date__c=September,sapid__c='51082926053');
            insert oLineItem;
            System.assertNotEquals(null,busAdm.Id,'error');
            test.stopTest();
            delete oLineItem;            
        }
    }       
    static testMethod void testwithBudget10() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {            
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Assessment Project');         
            insert lprojects;
            System.assert(lprojects.size()==2);
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Idea Capability',lprojects[0].id);
            insert lCapab;
            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 
            DRDW_Budget_Master__c oBudgetMaster = new DRDW_Budget_Master__c(CurrencyIsoCode='EUR',Total_F_X_Forecast__c=100.00,Total_Business_Plan__c=500.00,Cost_Center__c=oCostCen.Id,Planned_Amount_for_Milestone_1__c=1000.00,
            Planned_Amount_for_Milestone_2__c=1000.00,Planned_Amount_for_Milestone_3__c=1000.00,Planned_Amount_for_Milestone_4__c=1000.00,
            Payment_Milestone_1__c='Initiation of contract',Related_To__c=lprojects[0].Id,Payment_Milestone_2__c='Start of live phase',Payment_Milestone_3__c='End of live phase',Payment_Milestone_4__c='Upon receipt of results',PO__c='41004376612',Vendor__c='TBD');
            insert oBudgetMaster;
            test.startTest();
            Integer tempqrtr = October.month();
            String quarter;
            if(tempqrtr > 0 && tempqrtr < 4){
                quarter = '1';
            }else if(tempqrtr > 3 && tempqrtr < 7){
                quarter = '2';
            }else if(tempqrtr > 6 && tempqrtr < 10){
                quarter = '3';
            }else if(tempqrtr > 9 && tempqrtr < 13){
                quarter = '4';
            }
            
            Database.delete([Select Id,Name,Quarter__c,Year__c from DRDW_Budget_Summary__c where Quarter__c=:quarter]);
            DRDW_Budget_Line_Item__c oLineItem = new DRDW_Budget_Line_Item__c(Save_And_Lock__c=false,Related_To__c=oBudgetMaster.Id,Scientist_Owner__c=busAdm.Id,Vendor__c='TBD',Actual_Amount__c=123,PO__c='4100437669',Posting_Date__c=October,sapid__c='51082926053');
            insert oLineItem;
            System.assertNotEquals(null,busAdm.Id,'error');
            test.stopTest();
            delete oLineItem;            
        }
    }       
    static testMethod void testwithBudget11() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {            
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Assessment Project');         
            insert lprojects;
            System.assert(lprojects.size()==2);
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Idea Capability',lprojects[0].id);
            insert lCapab;
            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 
            DRDW_Budget_Master__c oBudgetMaster = new DRDW_Budget_Master__c(CurrencyIsoCode='EUR',Total_F_X_Forecast__c=100.00,Total_Business_Plan__c=500.00,Cost_Center__c=oCostCen.Id,Planned_Amount_for_Milestone_1__c=1000.00,
            Planned_Amount_for_Milestone_2__c=1000.00,Planned_Amount_for_Milestone_3__c=1000.00,Planned_Amount_for_Milestone_4__c=1000.00,
            Payment_Milestone_1__c='Initiation of contract',Related_To__c=lprojects[0].Id,Payment_Milestone_2__c='Start of live phase',Payment_Milestone_3__c='End of live phase',Payment_Milestone_4__c='Upon receipt of results',PO__c='41004376612',Vendor__c='TBD');
            insert oBudgetMaster;
            test.startTest();
            Integer tempqrtr = November.month();
            String quarter;
            if(tempqrtr > 0 && tempqrtr < 4){
                quarter = '1';
            }else if(tempqrtr > 3 && tempqrtr < 7){
                quarter = '2';
            }else if(tempqrtr > 6 && tempqrtr < 10){
                quarter = '3';
            }else if(tempqrtr > 9 && tempqrtr < 13){
                quarter = '4';
            }
            
            Database.delete([Select Id,Name,Quarter__c,Year__c from DRDW_Budget_Summary__c where Quarter__c=:quarter]);
            DRDW_Budget_Line_Item__c oLineItem = new DRDW_Budget_Line_Item__c(Save_And_Lock__c=false,Related_To__c=oBudgetMaster.Id,Scientist_Owner__c=busAdm.Id,Vendor__c='TBD',Actual_Amount__c=123,PO__c='4100437669',Posting_Date__c=November,sapid__c='51082926053');
            insert oLineItem;
            System.assertNotEquals(null,busAdm.Id,'error');
            test.stopTest();
            delete oLineItem;            
        }
    }       
    static testMethod void testwithBudget12() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {            
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Assessment Project');         
            insert lprojects;
            System.assert(lprojects.size()==2);
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Idea Capability',lprojects[0].id);
            insert lCapab;
            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 
            DRDW_Budget_Master__c oBudgetMaster = new DRDW_Budget_Master__c(CurrencyIsoCode='EUR',Total_F_X_Forecast__c=100.00,Total_Business_Plan__c=500.00,Cost_Center__c=oCostCen.Id,Planned_Amount_for_Milestone_1__c=1000.00,
            Planned_Amount_for_Milestone_2__c=1000.00,Planned_Amount_for_Milestone_3__c=1000.00,Planned_Amount_for_Milestone_4__c=1000.00,
            Payment_Milestone_1__c='Initiation of contract',Related_To__c=lprojects[0].Id,Payment_Milestone_2__c='Start of live phase',Payment_Milestone_3__c='End of live phase',Payment_Milestone_4__c='Upon receipt of results',PO__c='41004376612',Vendor__c='TBD');
            insert oBudgetMaster;
            test.startTest();
            Integer tempqrtr = December.month();
            String quarter;
            if(tempqrtr > 0 && tempqrtr < 4){
                quarter = '1';
            }else if(tempqrtr > 3 && tempqrtr < 7){
                quarter = '2';
            }else if(tempqrtr > 6 && tempqrtr < 10){
                quarter = '3';
            }else if(tempqrtr > 9 && tempqrtr < 13){
                quarter = '4';
            }
            
            Database.delete([Select Id,Name,Quarter__c,Year__c from DRDW_Budget_Summary__c where Quarter__c=:quarter]);
            DRDW_Budget_Line_Item__c oLineItem = new DRDW_Budget_Line_Item__c(Save_And_Lock__c=false,Related_To__c=oBudgetMaster.Id,Scientist_Owner__c=busAdm.Id,Vendor__c='TBD',Actual_Amount__c=123,PO__c='4100437669',Posting_Date__c=December,sapid__c='51082926053');
            insert oLineItem;
            System.assertNotEquals(null,busAdm.Id,'error');
            test.stopTest();
            delete oLineItem;            
        }
    }      
}