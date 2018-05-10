@isTest
private class Test_DRDW_CycleTime {
	static testmethod void testCycleTimewithRecord(){
		User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) { 
        	DRDW_Cycle_Time_Standard__c oCycleStandard = new DRDW_Cycle_Time_Standard__c(Assessment_Cycle_Time_Standard_for_Small__c=1
            	,Assessment_Cycle_Time_Standard_for_Bioph__c=1,
            	Assessment_Cycle_Time_Standard_for_Vacci__c=1);
            insert oCycleStandard;

            PageReference pageRef = new pageReference('/apex/DRDW_CycleTime?Id='+oCycleStandard.id);         
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(oCycleStandard);
            DRDW_CycleTime controller = new DRDW_CycleTime(sc);
            controller.edit();
            controller.save();
            List<DRDW_Cycle_Time_Standard__c> lCycle =[Select id from DRDW_Cycle_Time_Standard__c];
            System.assertNotEquals(lCycle.size(),0);
            controller.redirect();     
            controller.DeleteRecord();
        }
	}	

	static testmethod void testCycleTimewithoutRecord(){
		User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) { 
        	DRDW_Cycle_Time_Standard__c oCycleStandard = new DRDW_Cycle_Time_Standard__c(Assessment_Cycle_Time_Standard_for_Small__c=1
            	,Assessment_Cycle_Time_Standard_for_Bioph__c=1,
            	Assessment_Cycle_Time_Standard_for_Vacci__c=1);

            PageReference pageRef = new pageReference('/apex/DRDW_CycleTime');         
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(oCycleStandard);
            DRDW_CycleTime controller = new DRDW_CycleTime(sc);
            controller.edit();
            controller.save();
            List<DRDW_Cycle_Time_Standard__c> lCycle =[Select id from DRDW_Cycle_Time_Standard__c];
            System.assertNotEquals(lCycle.size(),0);
            controller.redirect();     
            controller.DeleteRecord();
            controller.save();
        }
	}	
}