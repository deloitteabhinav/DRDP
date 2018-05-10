@isTest
private class Test_DRDW_ResourceList {
    static testmethod void testPostive(){
        User busAdm = DRDW_TestDataFactory.getTestingUser();
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');    
        User finUsr = DRDW_TestDataFactory.getTestingUser();
        DRDW_TestDataFactory.givePermissions(finUsr.id,'DRDW_Financial_User');    
        System.runAs(finUsr) {
            DRDW_Resource__c oResource = new DRDW_Resource__c(Name__c=busAdm.Id,Department__c='DDS',Type__c='ERL',Role__c='Functional Head',Hours_Available_Per_Day__c=10.00,Hours_per_Week__c=50.00,Status__c='Active');
            DRDW_Resource__c oResource1 = new DRDW_Resource__c(Name__c=finUsr.Id,Department__c='DDS',Type__c='ERL',Role__c='Functional Head',Hours_Available_Per_Day__c=10.00,Hours_per_Week__c=50.00,Status__c='Active');
            insert new List<sObject>{oResource1,oResource};
            test.startTest();
            DRDW_ResourceList controller = new DRDW_ResourceList();             
            System.assert(controller.getlResourceRecordWrap().size()>0);
            controller.FetchDataForCriteria();
            controller.pagenumbers(2.00);
            controller.dResourcePageCount=2.00;
            controller.NextResourcePageSeries();
            controller.PreviousResourcePageSeries();
            controller.iPageNumber=1;
            controller.GoToResourcePageNumber();
            controller.sort();
            controller.sSearchWord='lastname';
            controller.query(string.escapeSingleQuotes('Name') + ' ' + string.escapeSingleQuotes('ASC NULLS FIRST'));
            System.assertNotEquals(null,finUsr.Id,'error'); 
            test.stoptest();
        }            
    }   
}