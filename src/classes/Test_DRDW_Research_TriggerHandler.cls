@isTest
private class Test_DRDW_Research_TriggerHandler{
  static testMethod void testwithResource() {  
        DRDW_Project__c oProject = new DRDW_Project__c();
                      
         User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Financial_User');
        System.runAs(busAdm) {            
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Idea Project');     
             lProjects[0].Business_Unit__c = 'Business Development';      
            insert lprojects;
            List<DRDW_Project__c> lIdea = DRDW_TestDataFactory.returnProjects(1,'Idea');
            insert lIdea;
            lprojects[0].Related_Idea__c=lIdea[0].Id;
            lprojects[0].CSF_Decision_to_Generate_DTG_Planned__c = system.today().addDays(2);
            lprojects[0].Decision_to_Evaluate_DTE__c = system.today();
            lprojects[0].EPCTM_DTG_DTE_for_Biopharma__c = 23;
            lprojects[0].Molecule_Classification__c = 'Small Molecule';
            lProjects[0].Business_Unit__c = 'Nutritionals';                                  
            List<DRDW_Risk__c> lRisks = DRDW_TestDataFactory.returnRisks(1,lprojects[0].id);      
            insert lRisks;      
            Test.startTest();
            system.assertNotEquals(lProjects,null); 
            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Idea Capability',lprojects[0].id);
            insert lCapab;
            update lprojects[0];
            delete lProjects[0];
            DRDW_Research_TriggerHandler.getObjectRecordTypeId(DRDW_Project__c.SObjectType,'Generation Project');
            Test.stopTest();
        }
        
        
    }
}