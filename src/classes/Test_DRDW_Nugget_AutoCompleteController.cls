@isTest
private class Test_DRDW_Nugget_AutoCompleteController {

     /*
       * Method Name : getAutoCompleteUser
       * Description : Test method to find auto complete user
       * Return type : nil
       * Paramater   : nil
     */
    static testMethod void getAutoCompleteUser() {
        //Create User
        User u = DRDW_TestDataFactory.getTestingUser();
        
        
        
        //Run Test class as System Administrator user
        system.runAs(u){
        Test.startTest();
        //Calling the method of controller
        DRDW_Nugget_AutoCompleteController.searchObject('User','User1','10','true');
        //Assert to check if User is part of queue
        Test.stopTest();
        }
    }
}