@isTest
private class Test_DRDW_ResearchReportCntlr{
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
                  PageReference pageRef = new pageReference('/apex/DRDW_ResearchReport');
                  Test.setCurrentPage(pageRef);
                  DRDW_ResearchReportCntlr controller = new DRDW_ResearchReportCntlr();
                  controller.iPageNumber = 3;
                  controller.sQuery ='test';
                  
                  controller.bShowMoreFlag =false;
                  controller.mLabel = new map <String,String>{'str'=>'str'};
                  DRDW_ResearchReportCntlr.wFieldSelected fd = new DRDW_ResearchReportCntlr.wFieldSelected('Name','Name', false, 'sec');
                  controller.lFieldWrapper = new List<DRDW_ResearchReportCntlr.wFieldSelected>();
                  controller.ResearchExpList = new List<DRDW_Project__c>{lstudy[0]};
                  controller.DescribeObjectWithDetails();
                  controller.getlResearchRecordWrap();
                  controller.getResearchExpList();
                  controller.FetchDataForCriteria();
                  controller.sort();
                  controller.GoToPageNumber();
                  controller.toggleOff();
                  controller.toggleOff2();
                  controller.NextPageSeries();
                  controller.ExportToExcel();
                  controller.ShowTable();
                  controller.sSearchWord = 'test';
                  controller.QueryMaker();                  
                  controller.FieldList = new List<DRDW_ResearchReportCntlr.wFieldSelected>{fd};
                  DRDW_ResearchReportCntlr.wResearchRecordWrap r= new DRDW_ResearchReportCntlr.wResearchRecordWrap(lGeneration[0]); 
                  System.assertNotEquals(null,busAdm.Id,'error');
                  test.stoptest();
                  controller.sOrder='DESC NULLS FIRST';
                  controller.sField = 'Name';
                  controller.previousSField = 'Name';
                  controller.sort();
                  controller.previousSField = 'Phase__c';
                  controller.sort();

                  controller.sSearchWord='Evaluation';
                  controller.FetchDataForCriteria();
            }
      }
}