public without sharing class DRDW_ViewGOActivityController {
	public DRDW_Capability__c oActivity {get; set;}
	public Id currentRecordID {get; set;}
	public id genericID {get; set;}
	public boolean isbError {get; set;}
	Public Boolean isAdmin{get;set;}
	Public Boolean isFin{get;set;} 
	public boolean isIdea{get;set;}
	public boolean isGeneration{get;set;}
	public boolean isAssessment{get;set;}
	public String projectName{get;set;}
	Public id projId{get;set;}
	Public id ReqID{get;set;}
	//Loading the Constructor
	public DRDW_ViewGOActivityController (ApexPages.StandardController controller) {
		oActivity = (DRDW_Capability__c)controller.getRecord();
		currentRecordID = ApexPages.currentPage().getParameters().get('id');
		projId = ApexPages.currentPage().getParameters().get('projid');
		ReqID = ApexPages.currentPage().getParameters().get('reqid');
		if(currentRecordID != null){
			//Quering the Activity
			String SobjectApiName = 'DRDW_Capability__c';
			Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
			Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
			String commaSeparatedFields = '';
			for (String fieldName : fieldMap.keyset()) {
				if (commaSeparatedFields == null || commaSeparatedFields == '') {
					commaSeparatedFields = fieldName;
				} else {
					commaSeparatedFields = commaSeparatedFields + ', ' + fieldName;
				}
			}
			commaSeparatedFields = commaSeparatedFields + ',DRDW_Request__r.Name';
			string query = 'select ' + commaSeparatedFields + ' from ' + SobjectApiName + ' where id =\'' + currentRecordID + '\' limit 1';
			oActivity = Database.query(query); 
			DRDW_Project__c proj = new DRDW_Project__c();
			//DRDW_Cap_Request__c req = new DRDW_Cap_Request__c();
			proj = [select id,Name,Name__c,Idea_Name__c,Project_Name__c, New_Idea_Name__c ,Recordtype.Name from Drdw_Project__c where id=:oActivity.Related_Project__c];        
			projectName = proj.Name;
			if(proj.Recordtype.Name == 'Idea Project')
			{
				isIdea = true;
			}
			else if(proj.Recordtype.Name == 'Generation Project'){
				isGeneration = true;
			}
			else if(proj.Recordtype.Name == 'Assessment Project'){
				isAssessment = true;
			}
		}else{
			DRDW_Project__c proj = new DRDW_Project__c();
			DRDW_Cap_Request__c req = new DRDW_Cap_Request__c();
			proj = [select id,Name,Name__c,Idea_Name__c,Project_Name__c, New_Idea_Name__c ,Recordtype.Name from Drdw_Project__c where id=:projId];
			req = [Select id,Actual_End_Date__c,Actual_Start_Date__c,Study_Type__c,Planned_End_Date__c,Planned_Start_Date__c,Study_Title__c from DRDW_Cap_Request__c where id=:ReqID];
			oActivity.Title__c = req.Study_Title__c;
			oActivity.Related_Project__c = proj.id;
			oActivity.DRDW_Request__c = req.id;
			oActivity.Capability__c = req.Study_Type__c;
			oActivity.Capability_Area__c = 'Study';
			oActivity.Actual_End_Date__c = req.Actual_End_Date__c;
			oActivity.Actual_Start_Date__c = req.Actual_Start_Date__c;
			oActivity.Planned_End_Date__c = req.Planned_End_Date__c;
			oActivity.Planned_Start_Date__c = req.Planned_Start_Date__c;
		}
	}
	
	/*
    * @Method Name                    :  addError
    * @Description                    :  Method for adding apex error
    * @Return Type                    :  void
    * @Parameters                     :  string
    */
	public void addError(string s) {
		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, s);
		ApexPages.addMessage(myMsg);
	}
}