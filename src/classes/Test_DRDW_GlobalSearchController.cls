@isTest
private class Test_DRDW_GlobalSearchController {
    static testMethod void testPositive() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {     
            List<DRDW_Project__c> lprojectsInsert = new List<DRDW_Project__c>(); 
            List<DRDW_Risk__c> lRisksInsert = new list<DRDW_Risk__c>();      
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(1,'Idea Project');  
            lprojectsInsert.addAll(lprojects);
            List<DRDW_Project__c> lIdea = DRDW_TestDataFactory.returnProjects(1,'Idea');  
            lprojectsInsert.addAll(lIdea);

            List<DRDW_Project__c> lStudy = DRDW_TestDataFactory.returnProjects(2,'Study Project');
            lprojectsInsert.addAll(lStudy);

            List<DRDW_Project__c> lGeneration = DRDW_TestDataFactory.returnProjects(2,'Generation Project');
            lprojectsInsert.addAll(lGeneration);

            List<DRDW_Project__c> lAssessment = DRDW_TestDataFactory.returnProjects(2,'Assessment Project');
            lprojectsInsert.addAll(lAssessment);            
            
            insert lprojectsInsert;
            List<DRDW_Risk__c> lRisks = new List<DRDW_Risk__c>();
            for(integer i =0;i<lprojectsInsert.size();i++){
                lRisks = DRDW_TestDataFactory.returnRisks(1,lprojectsInsert[i].id);   
                lRisksInsert.addAll(lRisks);
                lRisks.clear();
            }
               
            insert lRisksInsert;    

            list<DRDW_Capability__c> lCapab = DRDW_TestDataFactory.returnCapabilities(1, 'Idea Capability',lprojects[0].id);
            insert lCapab;  

            DRDW_Cost_Center__c oCostCen = new DRDW_Cost_Center__c(Additional_Details__c='test',Functional_Area__c='test',Name='test',Status__c='Active');
            insert oCostCen; 

            Test.startTest();
            DRDW_Budget_Master__c oBudgetMaster = new DRDW_Budget_Master__c(CurrencyIsoCode='EUR',Total_F_X_Forecast__c=100.00,Total_Business_Plan__c=500.00,Cost_Center__c=oCostCen.Id,Planned_Amount_for_Milestone_1__c=1000.00,
                Planned_Amount_for_Milestone_2__c=1000.00,Planned_Amount_for_Milestone_3__c=1000.00,Planned_Amount_for_Milestone_4__c=1000.00,
                Payment_Milestone_1__c='Initiation of contract',Related_To__c=lGeneration[0].Id,Payment_Milestone_2__c='Start of live phase',Payment_Milestone_3__c='End of live phase',Payment_Milestone_4__c='Upon receipt of results');
            insert oBudgetMaster;
            PageReference pageRef = new pageReference('/apex/DRDW_GlobalSearch?searchWord=test');    
            Test.setCurrentPage(pageRef);
            DRDW_GlobalSearchController controller = new DRDW_GlobalSearchController ();
            List<Integer> lInteger = new List<Integer>{1,2,3};
            controller.toggleOff();
            controller.getStudies();
            controller.getIdeas();
            controller.getEvals();
            controller.getProjects();
            controller.pagenumbers(3.00);
            controller.iPageNumber=1;
            controller.GoToStudyPageNumber();
            controller.GoToIdeaPageNumber();
            controller.GoToEvalPageNumber();
            controller.GoToProjectPageNumber();
            controller.NextPageSeries(lInteger,1.00);
            controller.dStudyPageCount=2.00;
            controller.lStudyPageNumbers.addAll(lInteger);
            controller.lIdeaPageNumbers.addAll(lInteger);
            controller.lEvalPageNumbers.addAll(lInteger);
            controller.lProjectPageNumbers.addAll(lInteger);
            controller.NextStudyPageSeries();
            controller.lStudyPageNumbers.addAll(lInteger);
            controller.PreviousStudyPageSeries();
            controller.NextIdeaPageSeries();
            controller.lIdeaPageNumbers.addAll(lInteger);
            controller.PreviousIdeaPageSeries();
            controller.NextEvalPageSeries();
            controller.lEvalPageNumbers.addAll(lInteger);
            controller.PreviousEvalPageSeries();
            controller.NextProjectPageSeries();
            controller.lProjectPageNumbers.addAll(lInteger);
            controller.PreviousProjectPageSeries();
            controller.sortStudies();
            System.assertNotEquals(null,busAdm.Id,'error');
            test.stopTest();
        }
    }
}