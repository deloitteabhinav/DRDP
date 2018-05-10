@isTest
private class Test_DRDW_CreateResource {
	static testmethod void testPostive(){
		User busAdm = DRDW_TestDataFactory.getTestingUser();
		DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');    
		System.runAs(busAdm) {
			DRDW_Resource__c oResource = new DRDW_Resource__c(Name__c=busAdm.Id,Department__c='DDS',Type__c='ERL',Role__c='Functional Head',Hours_Available_Per_Day__c=10.00,Hours_per_Week__c=50.00,Status__c='Active');
			insert oResource;
			System.assert(oResource.Id!=null);
			PageReference pageRef = new pageReference('/apex/DRDW_CreateResource?Id='+oResource.id);
			Test.setCurrentPage(pageRef);
			ApexPages.StandardController sc = new ApexPages.StandardController(oResource);
			test.startTest();
			DRDW_CreateResource controller = new DRDW_CreateResource(sc);  
			controller.save();
			controller.edit();
			controller.DeleteRecord();
		}            
	}

	static testmethod void testNegative(){
		User busAdm = DRDW_TestDataFactory.getTestingUser();
		DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');    
		System.runAs(busAdm) {
			DRDW_Resource__c oResource = new DRDW_Resource__c(Name__c=busAdm.Id,Department__c='DDS',Type__c='ERL',Role__c='Functional Head',Hours_Available_Per_Day__c=10.00,Hours_per_Week__c=50.00,Status__c='Active');
			insert oResource;
			
			System.assert(oResource.Id!=null);
			DRDW_Resource__c oResource1 = new DRDW_Resource__c(Name__c=busAdm.Id,Department__c='DDS',Type__c='ERL',Role__c='Functional Head',Hours_Available_Per_Day__c=10.00,Hours_per_Week__c=50.00,Status__c='Active');
		
			PageReference pageRef = new pageReference('/apex/DRDW_CreateResource');
			Test.setCurrentPage(pageRef);
			ApexPages.StandardController sc = new ApexPages.StandardController(oResource1);
			test.startTest();
			DRDW_CreateResource controller = new DRDW_CreateResource(sc);  
			controller.save();
		}            
	}
}