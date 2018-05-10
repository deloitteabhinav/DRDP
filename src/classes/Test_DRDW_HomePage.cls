@isTest
private class Test_DRDW_HomePage {
    static testMethod void testPositive() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {
            DRDW_Configuration__c oConfig;
            List<Document> lDocs = DRDW_TestDataFactory.createDocument(new List<String>{'DRDW Home Banner Image','DRDW Home Card1 image','DRDW Home Card2 image','DRDW Home Card3 image','DRDW Home Header Client logo','DRDW Home Header logo'});
            insert lDocs;
            List<String> lTabName = new List<String>{'Home Banner Title','Home Banner Discription','Home Card1 Text','Home Card2 Text','Home Card3 Text','Research','Admin'};
            List<DRDW_Configuration__c> lConfigs = new List<DRDW_Configuration__c>();
            for(integer i=0;i<lTabName.size();i++){
                oConfig = new DRDW_Configuration__c();
                oConfig.Display__c = true;
                oConfig.Name = lTabName[i];
                oConfig.Value__c = lTabName[i];
                oConfig.URL__c = '/apex/'+lTabName[i].split('&nbsp;')[0];  
                lConfigs.add(oConfig);          
            }
            insert lConfigs;

            test.startTest();
            PageReference pageRef = new pageReference('/apex/DRDW_HomePage?sfdcIFrameHost=true');    
            pageRef.getHeaders().put('USER-AGENT', 'Chrome');     
            Test.setCurrentPage(pageRef);
            DRDW_HomePage controller = new DRDW_HomePage();
            controller.SaveFeedback();
            DRDW_HomePage.isSF1();
            controller.searchWord='test';
            controller.populateGlobalURL();
            System.assertNotEquals(null,busAdm.Id,'error');
            test.stoptest();

        }
    }
}