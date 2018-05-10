@isTest
private class Test_DRDW_CompareShare {
  static testMethod void testwithResource() {  
        Test.startTest();  
        DRDW_CompareShare c = new DRDW_CompareShare();        
        DRDW_CompareShare.oValue = 'test';
        system.assertEquals(DRDW_CompareShare.oValue,'test');
        Test.stopTest();
    }
}