@isTest
private class Test_DRDW_Date_Utility {
    private static testmethod void testPositive(){
        
        DRDW_Date_Utility oController = new DRDW_Date_Utility();
        DRDW_Date_Utility.getWorkingDays(Null,Null);
        DRDW_Date_Utility.getWorkingDays(System.today(), System.Today());
        System.assertNotEquals(DRDW_Date_Utility.getWorkingDays(System.today(), System.Today()), 0);
        DRDW_Date_Utility.getWorkingDays(System.today(), System.Today().addDays(6));
        DRDW_Date_Utility.getWorkingDays(System.today(), System.Today().addDays(7));
        System.assertEquals(DRDW_Date_Utility.getWorkingDays(System.today(), System.Today().addDays(7)), 5);
    }
}