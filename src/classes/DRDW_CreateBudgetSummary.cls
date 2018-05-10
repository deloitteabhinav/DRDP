Public without sharing Class DRDW_CreateBudgetSummary{ 

	Public Id currentRecordID {get; set;}
	Public Id parentID {get; set;}
	Public Boolean isAdmin{get;set;}
	Public Boolean isFinancial{get;set;}
	public DRDW_Budget_Summary__c oMaster{get;set;}
	Public boolean forecateEdit{get;set;}
	Public List<DRDW_Budget_Summary_Detail__c> oItems{get;set;}
	Public id budgetMasterId{get;set;}
	public id genericID {get; set;}
	public string ParentName {get; set;}
	public Id PrjId {get; set;}
	public boolean isGen {get; set;}
	public boolean isEval {get; set;}
	public boolean isAssess {get; set;}

	Public DRDW_CreateBudgetSummary(ApexPages.StandardController controller){

		currentRecordID = ApexPages.currentPage().getParameters().get('id');
		oMaster = (DRDW_Budget_Summary__c)controller.getRecord();
		parentID = ApexPages.currentPage().getParameters().get('budgetId'); 
		isGen = false;
		isAssess = false;
		isEval = false;

		if(currentRecordID != null){
			String SobjectApiName = 'DRDW_Budget_Summary__c';
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
			string query = 'select ' + commaSeparatedFields + ', DRDW_Budget_Master__r.Title__c , DRDW_Budget_Master__r.Related_To__r.Project_Name__c,DRDW_Budget_Master__r.Related_To__r.Idea_Name__c,DRDW_Budget_Master__r.Related_To__r.Id,DRDW_Budget_Master__r.Related_To__r.RecordType.Name' +' from ' + SobjectApiName + ' where id =\'' + currentRecordID + '\' limit 1';
			oMaster = Database.query(query);
			if(oMaster.DRDW_Budget_Master__r.Related_To__r.RecordType.Name == 'Idea Project'){
				isEval = true;
			}else if(oMaster.DRDW_Budget_Master__r.Related_To__r.RecordType.Name == 'Generation Project'){
				isGen = true;
			}else if(oMaster.DRDW_Budget_Master__r.Related_To__r.RecordType.Name == 'Assessment Project'){
				isAssess = true;
			}
			System.debug('Fetch record types'+isGen+isAssess+isEval);
			budgetMasterId = oMaster.DRDW_Budget_Master__c;
			//parentID = oMaster.Related_To__c;
			oItems = new List<DRDW_Budget_Summary_Detail__c>([select id,Name,Year__c,Month__c,M_Actual__c from DRDW_Budget_Summary_Detail__c where DRDW_Budget_Summary__c =: currentRecordID]);

		}
		else{
			oMaster.DRDW_Budget_Master__c = parentID; 
			DRDW_Budget_Master__c parentRec = [select id, Title__c, Related_To__r.Project_Name__c,Related_To__r.Idea_Name__c,Related_To__r.Id,Related_To__r.RecordType.Name from DRDW_Budget_Master__c where Id=: parentID limit 1];
			if(parentRec.Related_To__r.Project_Name__c != null){
				ParentName = parentRec.Related_To__r.Project_Name__c;
			}
			else if(parentRec.Related_To__r.Idea_Name__c != null){
				ParentName = parentRec.Related_To__r.Idea_Name__c;
			}

			if(parentRec.Related_To__r.RecordType.Name == 'Idea Project'){
				isEval = true;
			}
			else if(parentRec.Related_To__r.RecordType.Name == 'Generation Project'){
				isGen = true;
			}
			else if(parentRec.Related_To__r.RecordType.Name == 'Assessment Project'){
				isAssess = true;
			}
			System.debug('Fetch record types'+isGen+isAssess+isEval);
			PrjId = parentRec.Related_To__r.Id;

			Date d = System.today();
			oMaster.Year__c = String.valueOf(d.Year());
			//lOptions = getPicklist(oCaps);
			budgetMasterId = oMaster.DRDW_Budget_Master__c;

		}
		isAdmin = getUserPermission(UserInfo.getUserId());
		isFinancial = getFinUserPermission(UserInfo.getUserId());
		updateForcastEdit();
	}


	/*
	* @Method Name                    :  Save
	* @Description                    :  Method to Save the record
	* @Return Type                    :  None
	* @Parameters                     :  None
	*/  

	Public PageReference save(){
		try{
			//Rounding currency values
			if (oMaster.Rolling_Forecast__c != null) oMaster.Rolling_Forecast__c = oMaster.Rolling_Forecast__c.round(System.RoundingMode.HALF_EVEN);
			if (oMaster.Business_Plan__c != null)oMaster.Business_Plan__c = oMaster.Business_Plan__c.round(System.RoundingMode.HALF_EVEN);
			if (oMaster.F_X_Forecast__c != null)oMaster.F_X_Forecast__c = oMaster.F_X_Forecast__c.round(System.RoundingMode.HALF_EVEN);
			if (oMaster.Q_Actual__c != null)oMaster.Q_Actual__c = oMaster.Q_Actual__c.round(System.RoundingMode.HALF_EVEN);
			if (oMaster.Q_Rolling_Forecast__c != null)oMaster.Q_Rolling_Forecast__c = oMaster.Q_Rolling_Forecast__c.round(System.RoundingMode.HALF_EVEN);
			if (oMaster.Q_Total_Actuals__c != null)oMaster.Q_Total_Actuals__c = oMaster.Q_Total_Actuals__c.round(System.RoundingMode.HALF_EVEN);

			upsert oMaster;
			PageReference pageref = null;
			pageref = new PageReference('/apex/DRDW_CreateBudgetMaster?id='+oMaster.DRDW_Budget_Master__c+'&isEdit=false&section=#Budget_Summary');
			pageref.setredirect(true);
			return pageref;
		}
		catch(Exception e){
			if(e.getmessage().contains('DUPLICATE_VALUE')){
				addError('The Summary record for this quarter already exists. Please check and try again');
				return null;
			}
			else {
				addError(e.getmessage());
				return null;
			}
		}
	}

	/*
	* @Method Name                    :  Save
	* @Description                    :  Method to Save the record
	* @Return Type                    :  None
	* @Parameters                     :  None
	*/  

	Public PageReference cancel(){
		PageReference pageref = null;
		pageref = new PageReference('/apex/DRDW_CreateBudgetMaster?id='+oMaster.DRDW_Budget_Master__c+'&isEdit=false');
		pageref.setredirect(true);
		return pageref;
	}




	/*
	* @Method Name                    :  Edit
	* @Description                    :  Method to Edit the record
	* @Return Type                    :  None
	* @Parameters                     :  None
	*/  

	Public PageReference edit(){
		PageReference pageref = new PageReference('/apex/DRDW_CreateBudgetSummaryInfo?id='+currentRecordID+'&isEdit=true');
		pageref.setredirect(true);
		return pageref;
	}

	Public PageReference DeleteRecord(){
		delete oMaster;
		PageReference pageref = new PageReference('/apex/DRDW_CreateBudgetMaster?id='+budgetMasterId+'&isEdit=false');
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


	/*Public void getQuater(){
	date currentDate = system.today();
	//System.debug('month ' + c.month());
	If(oMaster.Quarter__c == '1' && currentDate.month()>4){
	forecateEdit = true;
	}else if(oMaster.Quarter__c == '2' && (currentDate.month()<3 && currentDate.month()>7)){
	forecateEdit = true;
	}else if(oMaster.Quarter__c == '3' && (currentDate.month()<6 && currentDate.month()>10)){
	forecateEdit = true;
	}else if(oMaster.Quarter__c == '4' && (currentDate.month()<9 && currentDate.month()>=12)){
	forecateEdit = true;
	}else{
	forecateEdit = false;
	}

	}*/

	Public void updateForcastEdit(){
		forecateEdit = false;
		if(oMaster.Quarter__c != null && oMaster.year__c != null){

			Integer Month = 1;
			if(oMaster.Quarter__c == '1'){
				Month = 1;
			}
			else if(oMaster.Quarter__c == '2'){
				Month = 4;
			}
			else if(oMaster.Quarter__c == '3'){
				Month = 7;
			}
			else if(oMaster.Quarter__c == '4'){
				Month = 10;
			}

			Date currentDate = Date.newInstance(system.today().year(), system.today().month(), 01);
			Date objectDate = Date.newInstance(integer.ValueOf(oMaster.year__c), Month, 01);
			system.debug('currentDate'+currentDate);
			system.debug('objectDate'+objectDate);
			if(currentDate < objectDate){
				forecateEdit = true;
				system.debug('in loop');
			}
		}            
	}


	Public void RemoveBudgetDetail() {
		try {
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
			DRDW_Budget_Summary_Detail__c oExp = [Select id,DRDW_Budget_Summary__r.DRDW_Budget_Master__c,Quarter__c,Month__c,DRDW_Budget_Summary__c,M_Actual__c from DRDW_Budget_Summary_Detail__c where DRDW_Budget_Summary__c = :currentRecordID AND id = : genericID];

			Id masterid = oExp.DRDW_Budget_Summary__r.DRDW_Budget_Master__c;

			List<DRDW_Budget_Line_Item__c> bLineitems = [select id from DRDW_Budget_Line_Item__c where Related_To__c =:masterid and Quarter__c =:oExp.Quarter__c and CALENDAR_MONTH(Posting_Date__c) =: months.get(oExp.Month__c)];
			DRDW_Budget_Summary__c oSummary = [Select id,Q_Total_Actuals__c,Q_Actual__c from DRDW_Budget_Summary__c where id=:oExp.DRDW_Budget_Summary__c limit 1];

			oSummary.Q_Total_Actuals__c= oSummary.Q_Total_Actuals__c- oExp.M_Actual__c;    
			delete oExp;
			delete bLineitems;
			update oSummary;

			oItems = [select id,Name,Year__c,Month__c,M_Actual__c from DRDW_Budget_Summary_Detail__c where DRDW_Budget_Summary__c =: currentRecordID];
			getRefresh();

		} 
		catch (exception e) {
			addError(e.getmessage());
			//  isbError = true;
		} 
	} 

	public void addError(string s) {
		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, s);
		ApexPages.addMessage(myMsg);
	}

	public void getRefresh(){
		String SobjectApiName = 'DRDW_Budget_Summary__c';
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
		string query = 'select ' + commaSeparatedFields + ' from ' + SobjectApiName + ' where id =\'' + currentRecordID + '\' limit 1';
		oMaster = Database.query(query);
	}
}