/****************************************************************************************************************************************** 
 * Class Name   : BPAutoDistribute 
 * Description  : Class for Auto Distributing the Budget on BP
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
Public with Sharing Class BPAutoDistribute {
    Public Business_Planning__c oBusinessPlanning ;
        
    //Loading the Constructor
    Public BPAutoDistribute(ApexPages.StandardController controller) {
        oBusinessPlanning = [Select Estimated_Start_Date__c , Estimated_End_Date__c,Initial_budget_estimate_for_each_item__c from Business_Planning__c where Id =:controller.getId()];
    }
    
    /* 
     * @Method Name                    :  CreateBusinessEstimates
     * @Description                    :  Method to call the PassBusinessEstimates method and return back to orginal record
     * @Return Type                    :  PageReference
     * @Parameters                     :  None
     */
    
    Public PageReference CreateBusinessEstimates(){
            PassBusinessEstimates(oBusinessPlanning);
            PageReference BpUrl = new PageReference('/'+oBusinessPlanning.Id);
            return BpUrl; 
    }
    
    
     /* 
     * @Method Name                    :  PassBusinessEstimates
     * @Description                    :  Method to calculate budget estimates by quarter based on divisions provided in custom settings
     * @Return Type                    :  Business_Planning__c 
     * @Parameters                     :  None
     */
     
    Public static void PassBusinessEstimates(Business_Planning__c oBp) {
        List < Business_Planning_Estimate__c > lBusinessPlanningEstimate = new List < Business_Planning_Estimate__c > ();
        Set < id > sCurrentEstimateRecords = new Set < Id > ();

        Try{
        //Loop through the years and create records for quaters
            If(oBP != NULL) {
                Decimal StartDate = (oBP.Estimated_Start_Date__c.month() / 3.00).round(System.RoundingMode.Up);
                Integer iYearsBetween = oBP.Estimated_End_Date__c.year() - oBP.Estimated_Start_Date__c.year();
                Decimal EndDate = ((oBP.Estimated_End_Date__c.month() + (12 * iYearsBetween)) / 3.00).round(System.RoundingMode.Up);
                String sQuarter = 'Q' + String.valueof(EndDate - StartDate + 1);
                Map < Decimal, Decimal > mFormula = new Map < Decimal, Decimal > ();
                If((EndDate - StartDate + 1) < 10) {
                    BPFormulas__c oFormula = BPFormulas__c.getInstance(sQuarter);
                    mFormula.put(0, oFormula.Q1__c);
                    mFormula.put(1, oFormula.Q2__c);
                    mFormula.put(2, oFormula.Q3__c);
                    mFormula.put(3, oFormula.Q4__c);
                    mFormula.put(4, oFormula.Q5__c);
                    mFormula.put(5, oFormula.Q6__c);
                    mFormula.put(6, oFormula.Q7__c);
                    mFormula.put(7, oFormula.Q8__c);
                    mFormula.put(8, oFormula.Q9__c);
                }
                for (integer i = 0; i <= (EndDate - StartDate); i++) {
                    Business_Planning_Estimate__c oEstimate = new Business_Planning_Estimate__c();
                    oEstimate.Business_Planning_ID__c = oBP.Id;
                    Date dEstimateDate;
                    Decimal dEstimateAmount;
                    if (i == 0) {
                        dEstimateDate = oBP.Estimated_Start_Date__c;
                    } else if (i == (EndDate - StartDate)) {
                        dEstimateDate = oBP.Estimated_End_Date__c;
                    } else {
                        dEstimateDate = date.newinstance(oBP.Estimated_Start_Date__c.year(), ((Integer.valueof(StartDate) + i) * 3) - 2, 1);
                    }
                    oEstimate.Estimate_Date__c = dEstimateDate;
                    If((EndDate - StartDate + 1) < 10 && oBP.Initial_budget_estimate_for_each_item__c != NULL) {
                        oEstimate.Estimate_Amount__c = (oBP.Initial_budget_estimate_for_each_item__c * mFormula.get(i)) / 100;
                    }
                    Else {
                        oEstimate.Estimate_Amount__c = 0;
                    }
                    lBusinessPlanningEstimate.add(oEstimate);
                }
                sCurrentEstimateRecords.add(oBP.Id);
            }
    
            //Delete existing records 
            If(!sCurrentEstimateRecords.IsEmpty()) {
                Delete[Select id from Business_Planning_Estimate__c where Business_Planning_ID__c in : sCurrentEstimateRecords];
            }
    
            If(!lBusinessPlanningEstimate.IsEmpty()) {
                Database.insert(lBusinessPlanningEstimate, true);
            }
        }
            Catch(Exception e){
                GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(Error_Datetime__c = DateTime.Now(), Error_Message__c = e.getMessage(), Running_User__c = UserInfo.getUserId(), Stack_Trace__c = e.getStackTraceString());
                insert errlog;
            }
        }
    }