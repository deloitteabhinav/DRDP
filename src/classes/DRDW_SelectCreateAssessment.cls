Public without sharing class DRDW_SelectCreateAssessment{
	Public DRDW_Project__c oStudy{get;set;}
	Public id GenerationId{get;set;}
	public string s{get;set;}
	Public DRDW_SelectCreateAssessment(ApexPages.StandardController controller){
		oStudy = new DRDW_Project__c();
	}
	Public void copyField(){
		/*GenerationId = oStudy.Related_Generation_Project__c;
		DRDW_Project__c oGeneration = [Select Group__c,Project_Name__c,Project_Health_new__c,Development_Team_Director__c,Simplified_Project_Name__c,Therapeutic_Area__c,Project_Type__c,Project_Source__c,Priority__c,Strategic_Alignment__c,Budget_Status__c,CMC_Strategy__c,Product_Type__c,Active_Ingredients__c,Indication__c,Route_of_Administration__c,Research_Project_Lead__c,Lead_Finder__c,Project_Health__c from DRDW_Project__c where id =: GenerationId LIMIT 1];
		DRDW_Project__c oAssessment = new DRDW_Project__c();
		oAssessment.recordtypeid = getObjectRecordTypeId(DRDW_Project__c.SObjectType,'Assessment Project');
		oAssessment.Group__c = oGeneration.Group__c;
		oAssessment.Project_Name__c = oGeneration.Project_Name__c;
		oAssessment.Simplified_Project_Name__c = oGeneration.Simplified_Project_Name__c;
		oAssessment.Therapeutic_Area__c = oGeneration.Therapeutic_Area__c;
		oAssessment.Project_Type__c = oGeneration.Project_Type__c;
		oAssessment.Project_Source__c = oGeneration.Project_Source__c;
		oAssessment.Priority__c = oGeneration.Priority__c;
		oAssessment.Strategic_Alignment__c = oGeneration.Strategic_Alignment__c;
		oAssessment.Budget_Status__c = oGeneration.Budget_Status__c;
		oAssessment.CMC_Strategy__c = oGeneration.CMC_Strategy__c;
		oAssessment.Product_Type__c = oGeneration.Product_Type__c;
		oAssessment.Active_Ingredients__c = oGeneration.Active_Ingredients__c;
		oAssessment.Indication__c = oGeneration.Indication__c;
		oAssessment.Route_of_Administration__c = oGeneration.Route_of_Administration__c;
		oAssessment.Research_Project_Lead__c = oGeneration.Research_Project_Lead__c;
		oAssessment.Lead_Finder__c = oGeneration.Lead_Finder__c;
		oAssessment.Project_Health_new__c = oGeneration.Project_Health_new__c;
		oAssessment.Related_Generation_Project__c = oGeneration.id;
		oAssessment.Development_Team_Director__c = oGeneration.Development_Team_Director__c;
		oAssessment.Phase__c = '3-Assessment';
		oAssessment.Current_As_Of__c = System.today();
		//insert oAssessment;
		/* List<DRDW_Project__Share> sProjectShare = new List<DRDW_Project__Share>();
		Set<id> sUserShareId = new Set<id>();
		if(oAssessment.Research_Project_Lead__c != null && oAssessment.Research_Project_Lead__c != oAssessment.OwnerId){
			sUserShareId.add(oAssessment.Research_Project_Lead__c);
		}
		else if(oAssessment.Development_Team_Director__c!= null && oAssessment.Development_Team_Director__c!= oAssessment.OwnerId){
			sUserShareId.add(oAssessment.Development_Team_Director__c);
		} 
		for(Id Userid : sUserShareId){
			DRDW_Project__Share oShare = new DRDW_Project__Share();
			oShare.UserOrGroupId = Userid;
			oShare.ParentId = oAssessment.id;
			oShare.AccessLevel = 'Edit';
			oShare.RowCause = Schema.DRDW_Project__Share.RowCause.DRDW_Research_Share__c;
			sProjectShare.add(oShare);
		}
		if(!sProjectShare.isEmpty()){
		insert sProjectShare;
		}*/
		ApexPages.StandardController sc = new ApexPages.StandardController(oStudy);
		DRDW_createAssessment ca = new DRDW_createAssessment(sc);
		ca.GenerationId = oStudy.Related_Generation_Project__c;
		ca.copyField();
		//PageReference pageref = new PageReference('/apex/DRDW_CreateAssessment?lookup=true');
		//pageref.setredirect(false);
		//return pageref;
	}
	/*
	* @Method Name                    :  getObjectRecordTypeId
	* @Description                    :  Method to retrieve recordtypeid
	* @Return Type                    :  String
	* @Parameters                     :  string,SObjectType
	*/
	public String getObjectRecordTypeId(SObjectType sObjectType, String recordTypeName)
	{
		//Generate a map of tokens for all the Record Types for the desired object
		Map<String,Schema.RecordTypeInfo> recordTypeInfo = sObjectType.getDescribe().getRecordTypeInfosByName();        
		//Retrieve the record type id by name
		return recordTypeInfo.get(recordTypeName).getRecordTypeId();
	}
}