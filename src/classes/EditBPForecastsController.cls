/******************************************************************************************************************************************
 * Class Name   : EditBPForecastsController
 * Description  : Class to Edit Business Planning Forecasts & Operational Forecasts of a BP.
 * Created By   : Deloitte Consulting
 *
 *****************************************************************************************************************************************/
Public with sharing class EditBPForecastsController {


    Public Business_Planning__c oBusinessPlanning {get; set;}
    Public List <Business_Planning_Estimate__c> lBPForecasts {get; set;}
    Public List <Operational_Tracking__c> lOperationalForecasts {get; set;}
    Public Decimal dConversionRate {get; set;}
    Public string sISOCode {get; set;}
    Public List < SelectOption > lChoice {get; set;}
    Public string sChoice {get; set;}
    Public decimal sumBPFEstimate {get; set;}
    Public decimal sumOPFActual {get; set;}
    Public decimal sumOPFEstimate {get; set;}
    Public decimal sumOPFContracted {get; set;}
    Public Boolean IsError {get; set;}


    //Initialising the Controller
    Public EditBPForecastsController () {
        /* List<CurrencyType> lCurrency = new List<CurrencyType>([SELECT IsoCode, ConversionRate FROM CurrencyType where IsoCode = : userinfo.getDefaultCurrency()]);
        sISOCode = lCurrency[0].IsoCode;
        dConversionRate = lCurrency[0].ConversionRate; */
        IsError = FALSE;
        ID currentBPID = Apexpages.currentpage().getparameters().get('id');
        lChoice = new List < SelectOption > { new SelectOption( 'BPF', 'Business Plan Forecasts'), new Selectoption('OPF', 'Operational Forecasts')};
        if (Apexpages.currentpage().getparameters().get('type') != NULL) {
            schoice = Apexpages.currentpage().getparameters().get('type');
        } else {
            schoice = 'OPF';
        }
        if (currentBPID != null) {
            oBusinessPlanning = new Business_Planning__c();
            oBusinessPlanning = [Select id, /*CurrencyIsoCode,*/ Name, Actual_Contracted_Budget__c, Initial_budget_estimate_for_each_item__c from Business_Planning__c where Id = :currentBPID];
            DisplayForecasts();
        } else {
            IsError = TRUE;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Business Planning record ID not mentioned in the URL.'));
        }

    }

    /*
     * @Method Name                    :  DisplayForecasts
     * @Description                    :  This Method Queries the Child Related list records of the BP to display
     * @Return Type                    :  void
     * @Parameters                     :  None
     */
    public void DisplayForecasts() {
    lBPForecasts = new List <Business_Planning_Estimate__c>();
    lOperationalForecasts = new List <Operational_Tracking__c>();
        if (sChoice == 'BPF') {
           
                lBPForecasts = [select id, Name, /*CurrencyIsoCode,*/ Business_Planning_ID__c, /*Business_Planning_ID__r.CurrencyIsoCode, */Business_Planning_ID__r.Initial_budget_estimate_for_each_item__c, Estimate_Amount__c, Estimate_Date__c,
                                Quarter__c from Business_Planning_Estimate__c where Business_Planning_ID__c = :oBusinessPlanning.id order by Quarter__c];

                List<Business_Planning_Estimate__c> lBPForecastsConverted = new List<Business_Planning_Estimate__c>();
                lBPForecastsConverted = [Select convertCurrency(Estimate_Amount__c) from Business_Planning_Estimate__c where Business_Planning_ID__c = :oBusinessPlanning.id order by Quarter__c];
                sumBPFEstimate = 0;
                For(Business_Planning_Estimate__c oForecasts : lBPForecastsConverted){
                    If(oForecasts.Estimate_Amount__c != NULL){
                        sumBPFEstimate = sumBPFEstimate + oForecasts.Estimate_Amount__c;
                    }   
                }
            
            
        } else if (sChoice == 'OPF') {
            lOperationalForecasts = [select id, Milestone_Category__c, Title__c, HCP_ID__c, /*CurrencyIsoCode,*/ Name, Actual_amount__c, Acutal_Date_of_payment__c, Business_Planning_ID__c, /*Business_Planning_ID__r.CurrencyIsoCode, */Business_Planning_ID__r.Initial_budget_estimate_for_each_item__c,
                                     Business_Planning_ID__r.Actual_Contracted_Budget__c, Contracted_Amount__c, Contracted_Date_of_Payment__c, Estimate_amount__c, Estimated_Date_of_payment__c,
                                     Quarter_Actuals__c, Quarter_Contracted__c, Quarter_Estimate__c, Variance__c, Variance_Comments__c, Variance_Reason__c
                                     from Operational_Tracking__c where Business_Planning_ID__c = :oBusinessPlanning.id order by Quarter_Estimate__c ];
    
            List<Operational_Tracking__c> lOperationalForecastsConverted = new List<Operational_Tracking__c>();
            lOperationalForecastsConverted = [select convertCurrency(Actual_amount__c),convertCurrency(Contracted_Amount__c),convertCurrency(Estimate_amount__c)
                                     from Operational_Tracking__c where Business_Planning_ID__c = :oBusinessPlanning.id order by Quarter_Estimate__c ];

            sumOPFEstimate = 0;
            For(Operational_Tracking__c oTracking : lOperationalForecastsConverted){
                If(oTracking.Estimate_amount__c != NULL){
                    sumOPFEstimate = sumOPFEstimate + oTracking.Estimate_amount__c;
                }   
            }
            
            sumOPFActual = 0;
            For(Operational_Tracking__c oTracking : lOperationalForecastsConverted){
                If(oTracking.Actual_amount__c!= NULL){
                    sumOPFActual = sumOPFActual + oTracking.Actual_amount__c;
                }   
            }
            
            sumOPFContracted = 0;
            For(Operational_Tracking__c oTracking : lOperationalForecastsConverted){
                If(oTracking.Contracted_Amount__c!= NULL){
                    sumOPFContracted = sumOPFContracted + oTracking.Contracted_Amount__c;
                }   
            }
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
    

    /*
     * @Method Name                    :  UpdateForecasts
     * @Description                    :  This Method Updates the respective Child Related list records of BP
     * @Return Type                    :  void
     * @Parameters                     :  None
     */
    public void UpdateForecasts() {
        try{
        if (sChoice == 'BPF') {
            if (lBPForecasts != null) {
                update lBPForecasts;
            }
        } else if (sChoice == 'OPF') {
            if (lOperationalForecasts != null) {
                update lOperationalForecasts;
            }
        }
        DisplayForecasts();
        } catch (exception e) {
            String error = e.getdmlMessage(0);
            addError(error);
            isError = TRUE;
        }
    }
}