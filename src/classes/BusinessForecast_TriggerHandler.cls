/******************************************************************************************************************************************
 * Class Name   : BusinessForecast_TriggerHandler
 * Description  : Handler Class for BP Forecast Object
 * Created By   : Deloitte Consulting
 *
 *****************************************************************************************************************************************/
Public with sharing class BusinessForecast_TriggerHandler {

    /*
     * @Method Name                    :  preventDelete
     * @Description                    :  Method to Preventing deleting of locked forecast records 
     * @Return Type                    :  void
     * @Parameters                     :  List < Business_Planning__c>
     */

    Public static void preventDelete(List < Business_Planning_Estimate__c > lEstimates) {
        Map<Id,Boolean> mBps = new Map<Id,Boolean>();
        Set<Id> sBpIds = new Set<Id>();
        For(Business_Planning_Estimate__c oEstimate: lEstimates){
            sBpIds.add(oEstimate.Business_Planning_ID__c);            
        }
    }
}