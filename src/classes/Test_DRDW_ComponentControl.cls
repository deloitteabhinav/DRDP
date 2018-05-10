@isTest(SeeAllData = false)
public class Test_DRDW_ComponentControl {

/* 
* @Method Name                    :  test_ComponentControl
* @Description                    :  Tesing ComponentControl 
* @Return Type                    :  void
* @Parameters                     :  None
*/ 
    static testMethod void test_ComponentControl() {

        User u = DRDW_TestDataFactory.getTestingUser();
       

        System.runAs(u) {

            test.startTest();
                    
                    DRDW_ComponentControl controller = new DRDW_ComponentControl();
                    controller.SaveFeedback();
                    system.assertNotEquals(controller.oFeedback,NULL);
                    
            test.stopTest();

        }
    }
}