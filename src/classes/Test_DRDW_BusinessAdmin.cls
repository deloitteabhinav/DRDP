@isTest
private class Test_DRDW_BusinessAdmin {
    static testMethod void testBusinessUser() {        
        User funHead = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(funHead.id,'DRDW_Functional_Head');
        User finUser = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(finUser.id,'DRDW_Financial_User');
        System.runAs(funHead) {
            DRDW_BusinessAdmin controller = new DRDW_BusinessAdmin();
            System.assertEquals(controller.isAdmin,true);
        }
        System.runAs(finUser) {
            Test.startTest();
            DRDW_BusinessAdmin controller = new DRDW_BusinessAdmin();
            System.assertEquals(controller.isFinancialAdmin,true);
            Test.stopTest();
        }
    }
}