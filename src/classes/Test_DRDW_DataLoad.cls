@isTest(seeAllData=False)
private class Test_DRDW_DataLoad {
	static testMethod void testBusinessUser() {        
        User funHead = DRDW_TestDataFactory.getTestingUser();        
        DRDW_TestDataFactory.givePermissions(funHead.id,'DRDW_Business_Admin');
        System.runAs(funHead) {
        	String csvFile = 'DRDW_Cost_Center__c,PO__c,Posting_Date__c,Actual_Amount__c,PO_Description__c,Vendor__c,SAPID__c,Posting_Row__c\n';
			csvFile += '8600075,4100437669,1/1/2018,"2,000.00",Review of AHC2224920 reports,RYC GMBH,5108292605,3\n';
			csvFile += '8600075,4100497086,1/2/2018,"-9,897.51",COVANCE LABORATORIES LTD,Inv to be Recd-MoEnd,180000003,69\n';
			csvFile += '8600075,4100520312,1/3/2018,"9,600.00",EK_MPI_Expert Statement Cardiologist,MPI RESEARCH INC,5108293253,3\n';
			csvFile += '8600075,4100520312,1/4/2018,"-9,526.51",MPI RESEARCH INC,Inv to be Recd-MoEnd,180000003,64\n';
			csvFile += '8600075,4100531090,1/5/2018,"-28,638.88",PANELIS,Inv to be Recd-MoEnd,180000003,67\n';
			csvFile += '8600075,4100531093,1/6/2018,"-19,107.89",UFAG LABORATORIEN AG,Inv to be Recd-MoEnd,180000003,81\n';
			csvFile += '706AV72,4501147217,1/7/2018,"24,409.95",BERKELEY STRAIN HW DC PIVOTAL STUDY,TRS LABS INC,5108293562,3\n';
			csvFile += '706AV72,4501147217,1/8/2018,"71,818.60",PO Increase - Repeat of failed HW DC stu Repeat of,TRS LABS INC,5108293562,5\n';	
			csvFile += '706AV72,4501151733,1/9/2018,"53,050.66",Work Completed. Work Completed October 2017 to Dec,COVANCE LABORATORIES INC,5108277148,3';
			DRDW_DataLoad controller = new DRDW_DataLoad();
			controller.csvFileBody=Blob.valueOf(csvFile);
			controller.readCsv();
			System.assertEquals(controller.readData[0].containsAny('DRDW_Cost_Center__c'),true);
			csvFile +='\n';
			csvFile += '706AV72,4501151733,1/9/2018,"53,050.66",Work Completed. Work Completed October 2017 to Dec,COVANCE LABORATORIES INC,5108277148,3';
			controller.csvFileBody=Blob.valueOf(csvFile);
			controller.redirect();
			controller.readCsv();
			csvFile +='\n';
			csvFile += '706AV72,4501151733,111/19/2018,"53,050.66",Work Completed. Work Completed October 2017 to Dec,COVANCE LABORATORIES INC,5108277148,3';
			controller.csvFileBody=Blob.valueOf(csvFile);
			controller.readCsv();
        }
	}
}