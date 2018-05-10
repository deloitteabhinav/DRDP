@isTest
private class Test_DRDW_AddPicklists {
    static testmethod void testPicklist(){
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {      
            DRDW_AddPicklists controller = new DRDW_AddPicklists();
            controller.NewPicklist='Test';
            controller.values='Activity';
            controller.savePicklist();
            test.startTest();
            GLBL_Global_List_of_Values__c oglov = [Select id,name from GLBL_Global_List_of_Values__c where RecordTypeId =:Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('Elanco Capability').getRecordTypeId()];
            System.assertEquals(oglov.Name,'Test');
            controller.vPicklists.clear();
            controller.values='Impacted Project Timeline Activity';
            controller.savePicklist();
            controller.vPicklists.clear();
            controller.values='Risk Details';
            controller.savePicklist();
            controller.vPicklists.clear();
            controller.values='Termination Reason';
            controller.savePicklist();
            test.stopTest();
            controller.vPicklists.clear();
            controller.values='Simplified Project Name';
            controller.savePicklist();
            controller.values='Activity';
            controller.savePicklist();
             controller.vPicklists.clear();
            controller.values='Samples To Collect';
            controller.savePicklist();
            controller.values='Activity';
            controller.savePicklist();
             controller.vPicklists.clear();
            controller.values='Go-Sub Activities';
           // controller.savePicklist();
            controller.getPicklistValues();
            controller.ShowGroupBased();
           // controller.getGroupRecId('Animal Care');
            /* controller.savePicklist(); */
        
        }
    }
}