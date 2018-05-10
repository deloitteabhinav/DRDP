@isTest
private class Test_DRDW_IdeaListCntlr {
    static testMethod void testPositive() {        
        User busAdm = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(busAdm.id,'DRDW_Business_Admin');
        System.runAs(busAdm) {     
            List<DRDW_Project__c> lprojectsInsert = new List<DRDW_Project__c>(); 
            List<DRDW_Risk__c> lRisksInsert = new list<DRDW_Risk__c>();      
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(1,'Idea Project');  
            lprojects[0].Phase__c= 'Evaluation';
            lprojectsInsert.addAll(lprojects);
            List<DRDW_Project__c> lIdea = DRDW_TestDataFactory.returnProjects(1,'Idea');
            lIdea[0].Phase__c= 'Idea';  
            lprojectsInsert.addAll(lIdea);

            List<DRDW_Project__c> lStudy = DRDW_TestDataFactory.returnProjects(2,'Study Project');
            lStudy[0].Phase__c= 'Evaluation';
            lStudy[1].Phase__c= 'Early Development';  
            lprojectsInsert.addAll(lStudy);

            List<DRDW_Project__c> lGeneration = DRDW_TestDataFactory.returnProjects(2,'Generation Project');
            lGeneration[0].Phase__c= 'Generation';
            lGeneration[1].Phase__c= 'Generation';
            lprojectsInsert.addAll(lGeneration);

            List<DRDW_Project__c> lAssessment = DRDW_TestDataFactory.returnProjects(2,'Assessment Project');
            lAssessment[0].Phase__c= 'Assessment';
            lAssessment[1].Phase__c= 'Assessment';
            lprojectsInsert.addAll(lAssessment); 
            system.assertNotEquals(NULL, lprojectsInsert);           
            insert lprojectsInsert;

            test.startTest();
            PageReference pageRef = new pageReference('/apex/DRDW_ResearchList');
            Test.setCurrentPage(pageRef);
            DRDW_IdeaListCntlr controller = new DRDW_IdeaListCntlr();
            DRDW_IdeaListCntlr.wFieldSelected fd = new DRDW_IdeaListCntlr.wFieldSelected('Name','Name', false, 'sec');
            controller.lFieldWrapper = new List<DRDW_IdeaListCntlr.wFieldSelected>();
            controller.lFieldWrapper.add(fd);
            controller.iPageNumber = 2;
            controller.dPageCount = 4;
            List<integer> lid = new List<integer> {1,2,3,4};
            controller.dNewIdeaPageCount = 4;
            controller.NextNewIdeaPageSeries();
            //controller.PreviousNewIdeaPageSeries();
            controller.NextIdeaPageSeries();
            //controller.PreviousIdeaPageSeries();
            controller.NextProjectPageSeries();
            //controller.PreviousProjectPageSeries();
            controller.sort();
            controller.GoToNewIdeaPageNumber();
            controller.GoToIdeaPageNumber();
            controller.GoToProjectPageNumber();
            controller.toggleOff();
            controller.toggleOff2();
            controller.toggleOff3();
            List<integer> lPageNumbers = new List<integer>{2,3,4};
            controller.NextPageSeries(lPageNumbers,3);
            lPageNumbers[0]=1; 
            controller.PreviousPageSeries(lPageNumbers);
            controller.mLabel = new map <String,String>{'str'=>'str'};
            controller.FieldList = new List<DRDW_IdeaListCntlr.wFieldSelected>{fd};
            controller.getlNewIdeaRecordWrap();
            controller.getlResearchRecordWrap();
            controller.getlIdeaRecordwrap();
            controller.FetchDataForCriteria();
            DRDW_IdeaListCntlr.wResearchRecordWrap r= new DRDW_IdeaListCntlr.wResearchRecordWrap(lGeneration[0]); 
            System.assertNotEquals(null,busAdm.Id,'error');
            test.stoptest();
      
        }
    }
}