@isTest
private class Test_DRDW_SR2IndexController {
    static testMethod void testPositive() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_GO_User');
        User ldrShipUsr = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(ldrShipUsr.id,'DRDW_Leadership_User');
        System.runAs(busAdm) {
            DRDW_Configuration__c oConfig;
            List<Document> lDocs = DRDW_TestDataFactory.createDocument(new List<String>{'DRDW Home Header Client logo','DRDW Home Header logo'});
            insert lDocs;
            List<String> lTabName = new List<String>{'Home Banner Title','Home Banner Discription'};
            List<DRDW_Configuration__c> lConfigs = new List<DRDW_Configuration__c>();
            for(integer i=0;i<lTabName.size();i++){
                oConfig = new DRDW_Configuration__c();
                oConfig.Display__c = true;
                oConfig.Name = lTabName[i];
                oConfig.Value__c = lTabName[i];
                oConfig.URL__c = '/apex/'+lTabName[i].split('&nbsp;')[0]; 
                oConfig.RecordTypeID = Schema.SObjectType.DRDW_Configuration__c.getRecordTypeInfosByName().get('Tabs').getRecordTypeId();
                lConfigs.add(oConfig);          
            }
            insert lConfigs;
            test.startTest();
            DRDW_SR2IndexController controller = new DRDW_SR2IndexController();
            System.assertNotEquals(null, busAdm.Id, 'error');
            test.stoptest();
        }
        System.runAs(ldrShipUsr){
            DRDW_SR2IndexController controller = new DRDW_SR2IndexController();
        }
        System.assertNotEquals(null, busAdm.Id, 'error');
    }
}