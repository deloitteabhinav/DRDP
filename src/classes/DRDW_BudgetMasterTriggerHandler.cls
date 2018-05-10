public class DRDW_BudgetMasterTriggerHandler {
	public void OnAfterInsert(List<DRDW_Budget_Master__c> newMasters){
		List<DRDW_Budget_Summary__c> lBSummary = new List<DRDW_Budget_Summary__c>();
		Set<ID> bIds = new Set<ID>();
		Set<ID> activityIds = new Set<ID>();
		//   List<DRDW_Capability__c> lActivity = new List<DRDW_Capability__c>();
		for(DRDW_Budget_Master__c oMaster:newMasters){
			//      DRDW_Capability__c newActivity = new DRDW_Capability__c();
			//      newActivity.RecordTypeId = getObjectRecordTypeId(DRDW_Capability__c.SObjectType,'External Activity');
			//      newActivity.Related_Project__c = oMaster.Related_To__c;
			//      newActivity.Capability_Area__c = 'External';
			//      newActivity.Capability__c = 'External';
			//      lActivity.add(newActivity);
			for(Integer i=1;i<5;i++){
				DRDW_Budget_Summary__c oSummary = new DRDW_Budget_Summary__c();
				oSummary.DRDW_Budget_Master__c = oMaster.Id;
				oSummary.Quarter__c=i+'';
				lBSummary.add(oSummary);
			}
			bIds.add(oMaster.Related_To__c);
			if(oMaster.Activity__c != null){
				activityIds.add(oMaster.Activity__c);
			}
		}
		calculateTotalActuals(bIds,activityIds,newMasters,false,null);
		insert lBSummary;
		//   insert lActivity;
	}
	public void OnAfterUpdate(List<DRDW_Budget_Master__c> newMasters,Map<Id,DRDW_Budget_Master__c> oldMap){
		Set<ID> bIds = new Set<ID>();
		Set<ID> activityIds = new Set<ID>();
		Map<DRDW_Budget_Master__c,String> masterIDs = new Map<DRDW_Budget_Master__c,String>();
		boolean POchange = false;
		for(DRDW_Budget_Master__c oMaster:newMasters){
			bIds.add(oMaster.Related_To__c);
			if(oMaster.Activity__c != null){
				activityIds.add(oMaster.Activity__c);
			}
			//Adding code to update Budget Line Item's PO if the Master's PO is updated
			DRDW_Budget_Master__c Oldmaster = oldMap.get(oMaster.Id);
			if(Oldmaster.PO__c != oMaster.PO__c){
				system.debug('Inside compare and not equal'+OldMaster.PO__c+':'+oMaster.PO__c);
				masterIDs.put(oMaster, oMaster.PO__c);
			}
		}
		calculateTotalActuals(bIds,activityIds,newMasters,false,oldMap);
		//quering budgetline items for that master and updating them. 
		List<DRDW_Budget_Line_Item__c> lstoflineitems = [Select Id, Name, PO__c, Related_To__c from DRDW_Budget_Line_Item__c where Related_To__c IN :masterIDs.keyset()]; 
		try{
			if(lstoflineitems != null && lstoflineitems.size() != 0){
				system.debug('Inside List not null'+lstoflineitems);
				for(DRDW_Budget_Master__c tempbm : masterIDs.keyset()){
					for(DRDW_Budget_Line_Item__c bdli : lstoflineitems){
						if(tempbm.Id == bdli.Related_To__c){
							system.debug('Inside PO changed before'+tempbm.PO__c+':::'+bdli.PO__c);
							bdli.PO__c = tempbm.PO__c;
							system.debug('Inside PO changed after'+tempbm.PO__c+':::'+bdli.PO__c);
						}
					}
				}
				update lstoflineitems;
			}
		}catch(Exception e){
			system.debug('error'+e.getMessage());
		}
	}
	public void OnBeforeDelete(List<DRDW_Budget_Master__c> oldMasters,Map<Id,DRDW_Budget_Master__c> oldMap){
		Set<ID> bIds = new Set<ID>();
		Set<ID> activityIds = new Set<ID>();
		for(DRDW_Budget_Master__c oMaster:oldMasters){
			bIds.add(oMaster.Related_To__c);
			if(oMaster.Activity__c != null){
				activityIds.add(oMaster.Activity__c);
			}
		}
		//  calculateTotalActuals(bIds,activityIds,oldMasters,true,null);
		List<DRDW_Budget_Line_Item__c> lBLine = new List<DRDW_Budget_Line_Item__c>();
		List<DRDW_Budget_Summary__c> lBSummary = new List<DRDW_Budget_Summary__c>();        
		lBLine = [select id from DRDW_Budget_Line_Item__c where Related_To__c in:oldMap.keyset()];
		lBSummary = [Select id from DRDW_Budget_Summary__c where DRDW_Budget_Master__c in:oldMap.keyset()];
		try{
			delete lBLine;
			delete lBSummary;
		}catch(Exception e){
			system.debug('error'+e.getMessage());
		}
	}
	public void onBeforeInsert(List<DRDW_Budget_Master__c> NewMasterList){
		List<DRDW_Budget_Master__c> lMasters = new List<DRDW_Budget_Master__c>();  
		//Changing the currency ISO for all Budget Master records getting inserted  
		for(DRDW_Budget_Master__c oMaster : NewMasterList){
			oMaster.CurrencyIsoCode = Label.DRDW_Currency_Label;
			lMasters.add(oMaster);
		}
		/* updating the records if not null
        if(!lMasters.isEmpty() && lMasters != null){
            update lMasters;
        }  */      
	}
	public void calculateTotalActuals(Set<ID> bIds, Set<ID> activityIds, List<DRDW_Budget_Master__c> newMasters, Boolean isDelete,Map<Id,DRDW_Budget_Master__c> oldmap){
		Map<id,DRDW_Project__c> mapOfProjects = new Map<id,DRDW_Project__c>([select id,Total_budget__c from DRDW_Project__c where id in:bIds]);
		Map<id,DRDW_Capability__c> mapOfActivities = new Map<id,DRDW_Capability__c>([select id,Total_budget__c from DRDW_Capability__c where id in:activityIds]);
		if(!mapOfProjects.isEmpty() || !mapOfActivities.isEmpty() ){
			List<DRDW_Project__c> lProjects = new List<DRDW_Project__c>();
			List<DRDW_Capability__c> lActivities = new List<DRDW_Capability__c>();
			for(DRDW_Budget_Master__c oMaster : newMasters){
				if(!mapOfProjects.isEmpty() && mapOfProjects.containsKey(oMaster.Related_To__c)){
					DRDW_Project__c oProject = mapOfProjects.get(oMaster.Related_To__c);
					if(oProject.Total_budget__c==Null)
					oProject.Total_budget__c=0;          
					if(oldMap!=null){
						oProject.Total_budget__c-=oldMap.get(oMaster.id).Total_Actuals__c;
					}                
					if(!isDelete){   
						oProject.Total_budget__c+=oMaster.Total_Actuals__c;
					}
					else{
						oProject.Total_budget__c-=oMaster.Total_Actuals__c;
					}
					oProject.Total_budget__c = oProject.Total_budget__c.round(System.RoundingMode.HALF_EVEN);
					lProjects.add(oProject);
				}
				if(!mapOfActivities.isEmpty() && mapOfActivities.containsKey(oMaster.Activity__c)){
					DRDW_Capability__c oActivity = mapOfActivities.get(oMaster.Activity__c);
					if(oActivity.Total_budget__c==Null)
					oActivity.Total_budget__c=0;
					if(oldMap!=null){
						oActivity.Total_budget__c-=oldMap.get(oMaster.id).Total_Actuals__c;
					}       
					if(!isDelete){   
						oActivity.Total_budget__c+=oMaster.Total_Actuals__c;
					}
					else{
						oActivity.Total_budget__c-=oMaster.Total_Actuals__c;
					}
					oActivity.Total_budget__c = oActivity.Total_budget__c.round(System.RoundingMode.HALF_EVEN);
					lActivities.add(oActivity);
				}
			}
			if(lProjects.size() > 0){ 
				update lProjects;
			}
			if(lActivities.size() > 0){ 
				update lActivities;
			}
		}
	}
	/*
    * @Method Name                    :  getObjectRecordTypeId
    * @Description                    :  Method to retrieve recordtypeid
    * @Return Type                    :  String
    * @Parameters                     :  string,SObjectType
    */
	public String getObjectRecordTypeId(SObjectType sObjectType, String recordTypeName){
		//Generate a map of tokens for all the Record Types for the desired object
		Map<String,Schema.RecordTypeInfo> recordTypeInfo = sObjectType.getDescribe().getRecordTypeInfosByName();        
		//Retrieve the record type id by name
		return recordTypeInfo.get(recordTypeName).getRecordTypeId();
	}
}