@isTest(seeAllData=false)
public class Test_DRDW_CreateNewIdeaController {
	
    private static testmethod void test_SaveIdea(){
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
            DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Financial_User');
            System.runAs(busAdm) { 
            List<DRDW_Project__c> lIdea = DRDW_TestDataFactory.returnProjects(1,'Idea');
            insert lIdea;
            System.assert(lIdea[0].id!=Null);
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Idea Project');         
            lprojects[0].Related_Idea__c=lIdea[0].Id;
            insert lprojects;
                System.assert(lprojects[0].Related_Idea__c == lIdea[0].Id);
            List<DRDW_Risk__c> lRisks = DRDW_TestDataFactory.returnRisks(1,lIdea[0].Id); 
                lRisks[0].Related_To__c = lIdea[0].Id;
            insert lRisks;
                System.assert(lRisks[0].id!=Null);
            Test.startTest();
                PageReference pageRef = new pageReference('/apex/DRDW_CreateNewIdea?Id='+lIdea[0].id);         
                Test.setCurrentPage(pageRef);
                ApexPages.StandardController sc = new ApexPages.StandardController(lIdea[0]);
                DRDW_CreateNewIdeaController controller = new DRDW_CreateNewIdeaController(sc);
                controller.saveIdea();
                controller.getObjectRecordTypeId(DRDW_Project__c.sobjectType,'Assessment Project');
                controller.EditRecord();
                controller.AddRisk();
                controller.EvalLink();
                controller.RemoveRisk();
                controller.addError('error');
            Test.stopTest();
        }
    }
    
    private static testmethod void test_deleteRec(){
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
            DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
            System.runAs(busAdm) { 
                List<DRDW_Project__c> lIdea = DRDW_TestDataFactory.returnProjects(1,'Idea');
                insert lIdea;
                System.assert(lIdea[0].id!=Null);
                List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Idea Project');         
                lprojects[0].Related_Idea__c=lIdea[0].Id;
                insert lprojects;
                System.assert(lprojects[0].id!=Null);
                Test.startTest();
                    PageReference pageRef = new pageReference('/apex/DRDW_CreateNewIdea?Id='+lIdea[0].id);         
                    Test.setCurrentPage(pageRef);
                    ApexPages.StandardController sc = new ApexPages.StandardController(lIdea[0]);
                    DRDW_CreateNewIdeaController controller = new DRDW_CreateNewIdeaController(sc);
                    controller.DeleteRecord();
                	controller.isEvalError = False;
                	controller.LinkID = lIdea[0].id;
                	controller.LinkID2 = lIdea[0].id;
                	controller.isLeader = False;
                Test.stopTest();
            }
    }
}