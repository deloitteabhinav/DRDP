@isTest(seeAllData=false)
private class Test_DRDW_CheckLeaderShip {
    static testMethod void testLeadershipUser() {        
        User leadUser = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(leadUser.id,'DRDW_Leadership_User');
        User finUser = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(finUser.id,'DRDW_Financial_User');
        System.runAs(leadUser) {
            DRDW_CheckLeaderShip controller = new DRDW_CheckLeaderShip();
            System.assertEquals(controller.isLeader,true);
        }
        System.runAs(finUser) {
            Test.startTest();
            DRDW_CheckLeaderShip controller = new DRDW_CheckLeaderShip();
            System.assertEquals(controller.isPMorScientist,true);
            Test.stopTest();
        }
    }
}