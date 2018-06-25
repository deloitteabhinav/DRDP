/****************************************************************************************************************************************** 
 * Class Name   : BPCreateOperationalForecasts
 * Description  : Class for Creating Operational Forecasts Records from Estimates
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
Public with Sharing Class BPCreateOperationalForecasts {
    Public Id BusinessPlanningId;
    Public Boolean IsError{get;set;}
    //Loading the Constructor
    Public BPCreateOperationalForecasts() {
        BusinessPlanningId = ApexPages.currentPage().getParameters().get('id');
        IsError = FALSE;
    }

    /* 
     * @Method Name                    :  CreateOperationalForecast
     * @Description                    :  Method to call the PassOperationalForecast method and return back to orginal record
     * @Return Type                    :  PageReference
     * @Parameters                     :  None
     */

    Public PageReference CreateOperationalForecast() {
        PassOperationalForecast(BusinessPlanningId);
        PageReference BpUrl = new PageReference('/' +BusinessPlanningId);
        If(IsError == FALSE){
            return BpUrl;
        }
        Else{
            return null;
        }
    }


    /* 
     * @Method Name                    :  PassOperationalForecast
     * @Description                    :  Method to Copy Estimates to Operational Forecast
     * @Return Type                    :  Business_Planning__c 
     * @Parameters                     :  None
     */

    Public void PassOperationalForecast(Id oBp) {
        Try{
            List < Business_Planning_Estimate__c > lPlanningEstimates = new List < Business_Planning_Estimate__c > ();
            lPlanningEstimates = [Select Id, Estimate_Amount__c, Estimate_Date__c, Business_Planning_ID__c from Business_Planning_Estimate__c where Business_Planning_ID__c = : oBp];
    
            List < Operational_Tracking__c > lTracking = new List < Operational_Tracking__c > ();
            lTracking = [Select Id, Business_Planning_ID__c from Operational_Tracking__c where Business_Planning_ID__c = : oBp];
            Delete lTracking;
            lTracking = new List < Operational_Tracking__c > ();
    
            For(Business_Planning_Estimate__c oEstimate: lPlanningEstimates) {
                Operational_Tracking__c oTracking = new Operational_Tracking__c();
                oTracking.Estimated_Date_of_payment__c = oEstimate.Estimate_Date__c;
                oTracking.Estimate_amount__c = oEstimate.Estimate_Amount__c;
                oTracking.Business_Planning_ID__c  = oBp;
                lTracking.add(oTracking);
            }
    
            Insert lTracking;
        }
        
        Catch (exception e) {
            GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(Error_Datetime__c = DateTime.Now(), Error_Message__c = e.getMessage(), Running_User__c = UserInfo.getUserId(), Stack_Trace__c = e.getStackTraceString());
            insert errlog;
            IsError = TRUE;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'There was an error Inserting Operational Forecast Records. Please contact your Administrator'));
        }

    }
}