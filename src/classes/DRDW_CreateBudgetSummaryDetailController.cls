public with sharing class DRDW_CreateBudgetSummaryDetailController {

	public DRDW_Budget_Summary_Detail__c oBudgetSummaryDetail{get;set;}    
	public id currentRecordID{get;set;}
	public id budgetSummaryID{get;set;}    
	public string recType{get;set;}
	Public Boolean isAdmin{get;set;}
	public List<SelectOption> lImpactedPicklist{get;set;}
	Public List<SelectOption> lDetailPicklist{get;set;}
	Public Boolean isFinancial{get;set;}
	Public string ParentName {get; set;}
	Public Id BMid {get;set;}
	public Id PrjId {get; set;}
	public boolean isGen {get; set;}
	public boolean isEval {get; set;}
	public boolean isAssess {get; set;}

	public DRDW_CreateBudgetSummaryDetailController(ApexPages.StandardController controller) {

		oBudgetSummaryDetail = (DRDW_Budget_Summary_Detail__c)controller.getRecord();
		currentRecordID = ApexPages.currentPage().getParameters().get('id');
		budgetSummaryID = ApexPages.currentPage().getParameters().get('budgetSummaryID');
		isAdmin = getUserPermission(UserInfo.getUserId()); 
		isFinancial = getFinUserPermission(UserInfo.getUserId());
		//  oBudgetSummaryDetail.Year__c = String.valueOf(system.today().year());
		if(currentRecordID != null){
			String SobjectApiName = 'DRDW_Budget_Summary_Detail__c';
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
			string query = 'select ' + commaSeparatedFields + ',DRDW_Budget_Summary__r.DRDW_Budget_Master__c,DRDW_Budget_Summary__r.DRDW_Budget_Master__r.Title__c,DRDW_Budget_Summary__r.DRDW_Budget_Master__r.Related_To__r.RecordType.Name,DRDW_Budget_Summary__r.DRDW_Budget_Master__r.Related_To__c' +' from ' + SobjectApiName + ' where id =\'' + currentRecordID + '\' limit 1';
			oBudgetSummaryDetail = Database.query(query);
			if(oBudgetSummaryDetail.DRDW_Budget_Summary__r.DRDW_Budget_Master__r.Related_To__r.RecordType.Name == 'Idea Project'){
				isEval = true;
			}
			else if(oBudgetSummaryDetail.DRDW_Budget_Summary__r.DRDW_Budget_Master__r.Related_To__r.RecordType.Name  == 'Generation Project'){
				isGen = true;
			}
			else if(oBudgetSummaryDetail.DRDW_Budget_Summary__r.DRDW_Budget_Master__r.Related_To__r.RecordType.Name  == 'Assessment Project'){
				isAssess = true;
			}
			System.debug('Fetch record types'+isGen+isAssess+isEval);
			budgetSummaryID = oBudgetSummaryDetail.DRDW_Budget_Summary__c;
		}
		else {
			oBudgetSummaryDetail.DRDW_Budget_Summary__c = budgetSummaryID; 
			DRDW_Budget_Summary__c parentRec = [select id, DRDW_Budget_Master__c,DRDW_Budget_Master__r.Title__c,DRDW_Budget_Master__r.Related_To__r.RecordType.Name,DRDW_Budget_Master__r.Related_To__c from DRDW_Budget_Summary__c where Id=: budgetSummaryID limit 1];
			if(parentRec.DRDW_Budget_Master__r.Related_To__r.RecordType.Name == 'Idea Project'){
				isEval = true;
			}
			else if(parentRec.DRDW_Budget_Master__r.Related_To__r.RecordType.Name  == 'Generation Project'){
				isGen = true;
			}
			else if(parentRec.DRDW_Budget_Master__r.Related_To__r.RecordType.Name  == 'Assessment Project'){
				isAssess = true;
			}
			System.debug('Fetch record types'+isGen+isAssess+isEval);
			PrjId = parentRec.DRDW_Budget_Master__r.Related_To__c;
			ParentName = parentRec.DRDW_Budget_Master__r.Title__c;
			BMid = parentRec.DRDW_Budget_Master__c;
		}
	}

	/*
    * @Method Name                    :  saveExperiment
    * @Description                    :  Method to save Existing Experiment
    * @Return Type                    :  void
    * @Parameters                     :  None
    */
	public PageReference saveBudgetSummary(){
		pagereference pageref;
		try{
			/*if(oRisk.Name == ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please enter a value for the mandatory fields'));    
            }*/
			oBudgetSummaryDetail.DRDW_Budget_Summary__c = budgetSummaryID;
			upsert oBudgetSummaryDetail;                
			pageref = new pagereference('/apex/DRDW_CreateBudgetSummaryinfo?id=' + budgetSummaryID +'&isEdit=false&section=#Budget_summary_detail_child');
			pageref.setredirect(true); 
			return pageref;
		}
		catch(Exception e){
			if(e.getmessage().contains('DUPLICATE_VALUE')){
				addError('The Summary detail record for this quarter already exists. Please check and try again');
				return null;
			}
			else {
				addError(e.getmessage());
				return null;
			}
		}
	}

	/*
    * @Method Name                    :  EditRecord
    * @Description                    :  Method for editing and existing record
    * @Return Type                    :  PageReference
    * @Parameters                     :  None
    */
	public PageReference EditRecord() {
		pagereference pageref;
		pageref = new pagereference('/apex/DRDW_CreateBudgetSummaryDetail?id=' + currentRecordID + '&isEdit=true');
		pageref.setredirect(true);        
		return pageref; 
	} 

	public void addError(string s) {
		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, s);
		ApexPages.addMessage(myMsg);
	}

	/*
    * @Method Name                    :  Cancel Record
    * @Description                    :  Method for editing and existing record
    * @Return Type                    :  PageReference
    * @Parameters                     :  None
    */
	public PageReference CancelRecord() {
		pagereference pageref;
		pageref = new pagereference('/apex/DRDW_CreateBudgetSummaryinfo?id=' + budgetSummaryID + '&isEdit=false');
		pageref.setredirect(true);
		return pageref; 
	} 

	Public PageReference DeleteRecord(){
		Map<String,Integer> months = new Map<String,Integer>();   
		months.put('Jan',1);
		months.put('Feb',2);
		months.put('March',3);
		months.put('April',4);
		months.put('May',5);
		months.put('June',6);
		months.put('July',7);
		months.put('Aug',8);
		months.put('Sept',9);
		months.put('Oct',10);
		months.put('Nov',11);
		months.put('Dec',12);
		DRDW_Budget_Summary_Detail__c detail = [select id,DRDW_Budget_Summary__r.DRDW_Budget_Master__c,DRDW_Budget_Summary__c,M_Actual__c from DRDW_Budget_Summary_Detail__c where id =:oBudgetSummaryDetail.id];    

		Id masterid = detail.DRDW_Budget_Summary__r.DRDW_Budget_Master__c;

		List<DRDW_Budget_Line_Item__c> bLineitems = [select id from DRDW_Budget_Line_Item__c where Related_To__c =:masterid and Quarter__c =:oBudgetSummaryDetail.Quarter__c and CALENDAR_MONTH(Posting_Date__c) =: months.get(oBudgetSummaryDetail.Month__c) ];

		system.debug('bline-----'+bLineitems);

		DRDW_Budget_Summary__c oSummary = [Select id,Q_Total_Actuals__c,Q_Actual__c from DRDW_Budget_Summary__c where id=:detail.DRDW_Budget_Summary__c limit 1];

		oSummary.Q_Total_Actuals__c= oSummary.Q_Total_Actuals__c- detail.M_Actual__c;   

		delete oBudgetSummaryDetail;
		delete bLineitems;
		update oSummary;
		pagereference pageref;
		pageref = new pagereference('/apex/DRDW_CreateBudgetSummaryinfo?id=' + budgetSummaryID);
		pageref.setredirect(true);
		return pageref;
	}

	Public Boolean getUserPermission(Id UserID){
		List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserID AND PermissionSet.Name = 'DRDW_Business_Admin']);
		Set<Id> lUserId = new Set<Id>();
		If(!lPermission.isEmpty()){
			For(PermissionSetAssignment p : lPermission){
				lUserId.add(p.Assignee.Id);
			}
		}
		If(lUserId.Contains(UserID)){
			return true;
		}

		return false;
	} 

	Public Boolean getFinUserPermission(Id UserID){
		List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserID AND PermissionSet.Name ='DRDW_Financial_User']);
		Set<Id> lUserId = new Set<Id>();
		If(!lPermission.isEmpty()){
			For(PermissionSetAssignment p : lPermission){
				lUserId.add(p.Assignee.Id);
			}
		}
		If(lUserId.Contains(UserID)){
			return true;
		}

		return false;
	}   


}