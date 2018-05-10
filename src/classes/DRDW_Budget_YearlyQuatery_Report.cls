Public with Sharing Class DRDW_Budget_YearlyQuatery_Report{

    Public transient Map<id,yearlyBudgetWrapper> mCCYearlyBudget{get;set;}
    Public transient Map<id,quaterlyBudgetWrapper> mCCQuater1Budget{get;set;}
    Public transient Map<id,quaterlyBudgetWrapper> mCCQuater2Budget{get;set;}
    Public transient Map<id,quaterlyBudgetWrapper> mCCQuater3Budget{get;set;}
    Public transient Map<id,quaterlyBudgetWrapper> mCCQuater4Budget{get;set;}
    Public transient List<DRDW_Budget_Master__c> lbudMaster{get;set;}
    Public transient Map<Id,List<DRDW_Budget_Summary_Detail__c>> mSummarySummaryDetails{get;set;}
    Public transient Map <Id, List<DRDW_Budget_Summary__c>> mCostCenterSummary{get;set;}
    Public transient List<DRDW_Cost_Center__c> lCostCenter{get;set;}
    Public transient List<DRDW_NDBD_Category__c> lNDBDCatagory{get;set;}  
    Public transient List<DRDW_NDBM_Category__c> lNDBMCatagory{get;set;}  
    Public String jsonString{get;set;}
    Public Boolean isAdmin{get;set;}
    Public Boolean isFin{get;set;} 
    Public transient String selectedyear{get;set;}
    
    Public DRDW_Budget_YearlyQuatery_Report(){
     isAdmin = getUserPermission(UserInfo.getUserId());
     isFin = getUserPermissionFin(UserInfo.getUserId());
    }
    
     Public void executeWrapperGenerator(){
         if(selectedyear == null){
            selectedyear = string.valueOf(system.today().year());
        }
        queryDetails(selectedyear);
        //queryDetails('2018');
        WrapperGenerator(lbudMaster,mSummarySummaryDetails,mCostCenterSummary);
        jsonGenerator();
    }
    
    
    Public void WrapperGenerator(List<DRDW_Budget_Master__c> lbudMaster,Map<Id,List<DRDW_Budget_Summary_Detail__c>> mSummarySummaryDetails,Map <Id, List<DRDW_Budget_Summary__c>> mCostCenterSummary){      
            
        mCCYearlyBudget = new Map<id,yearlyBudgetWrapper>();
        mCCQuater1Budget = new Map<id,quaterlyBudgetWrapper>();
        mCCQuater2Budget = new Map<id,quaterlyBudgetWrapper>();
        mCCQuater3Budget = new Map<id,quaterlyBudgetWrapper>();
        mCCQuater4Budget = new Map<id,quaterlyBudgetWrapper>();
        yearlyBudgetWrapper yearlyBudgetRecord;
        quaterlyBudgetWrapper quaterlyBudgetRecord1;
        quaterlyBudgetWrapper quaterlyBudgetRecord2;
        quaterlyBudgetWrapper quaterlyBudgetRecord3;
        quaterlyBudgetWrapper quaterlyBudgetRecord4;
        decimal actual = 0;
        decimal nonDesActual = 0;
        Map<string,DRDW_NDBM_Category__c> masterCategoryMap = new Map<string,DRDW_NDBM_Category__c>();
        
        for(DRDW_NDBM_Category__c oNDBMCatagory : lNDBMCatagory){ 
            
            masterCategoryMap.put(oNDBMCatagory.Category__c,oNDBMCatagory);
        
        }
        
        //initializing maps
        for(DRDW_Cost_Center__c oCostCenter : lCostCenter){                           
                    
            yearlyBudgetRecord = new yearlyBudgetWrapper(oCostCenter.Id,oCostCenter.Name,oCostCenter.Functional_Area__c,0,0,0,0,0,0,0,0,0,0,0,getCatogeryMap(),0,getCatogeryMasterMap(masterCategoryMap,'Yearly')); 
            
            quaterlyBudgetRecord1 = new quaterlyBudgetWrapper(oCostCenter.Id,oCostCenter.Name,oCostCenter.Functional_Area__c,0,0,0,0,0,new Map<String,Decimal>{'Jan' => 0,'Feb' => 0,'March' => 0},0,0,getCatogeryMap(),0,getCatogeryMasterMap(masterCategoryMap,'Q1')); 
            
            quaterlyBudgetRecord2 = new quaterlyBudgetWrapper(oCostCenter.Id,oCostCenter.Name,oCostCenter.Functional_Area__c,0,0,0,0,0,new Map<String,Decimal>{'April' => 0,'May' => 0,'June' => 0},0,0,getCatogeryMap(),0,getCatogeryMasterMap(masterCategoryMap,'Q2')); 
            
            quaterlyBudgetRecord3 = new quaterlyBudgetWrapper(oCostCenter.Id,oCostCenter.Name,oCostCenter.Functional_Area__c,0,0,0,0,0,new Map<String,Decimal>{'July' => 0,'Aug' => 0,'Sept' => 0},0,0,getCatogeryMap(),0,getCatogeryMasterMap(masterCategoryMap,'Q3')); 
            
            quaterlyBudgetRecord4 = new quaterlyBudgetWrapper(oCostCenter.Id,oCostCenter.Name,oCostCenter.Functional_Area__c,0,0,0,0,0,new Map<String,Decimal>{'Oct' => 0,'Nov' => 0,'Dec' => 0},0,0,getCatogeryMap(),0,getCatogeryMasterMap(masterCategoryMap,'Q4'));   


            mCCYearlyBudget.put(oCostCenter.Id,yearlyBudgetRecord);
            mCCQuater1Budget.put(oCostCenter.Id,quaterlyBudgetRecord1);
            mCCQuater2Budget.put(oCostCenter.Id,quaterlyBudgetRecord2);
            mCCQuater3Budget.put(oCostCenter.Id,quaterlyBudgetRecord3);
            mCCQuater4Budget.put(oCostCenter.Id,quaterlyBudgetRecord4);         
                
        /*}
        
        for(DRDW_Budget_Master__c obudMaster : lbudMaster){  */                         

            if(mCostCenterSummary.containsKey(oCostCenter.Id)){
                    
                if(mCCYearlyBudget.containsKey(oCostCenter.Id)){
                    yearlyBudgetRecord = mCCYearlyBudget.get(oCostCenter.Id);
                }
                if(mCCQuater1Budget.containsKey(oCostCenter.Id)){
                    quaterlyBudgetRecord1 = mCCQuater1Budget.get(oCostCenter.Id);
                }

                if(mCCQuater2Budget.containsKey(oCostCenter.Id)){
                    quaterlyBudgetRecord2 = mCCQuater2Budget.get(oCostCenter.Id);
                }
                if(mCCQuater3Budget.containsKey(oCostCenter.Id)){
                    quaterlyBudgetRecord3 = mCCQuater3Budget.get(oCostCenter.Id);
                }
                if(mCCQuater4Budget.containsKey(oCostCenter.Id)){
                    quaterlyBudgetRecord4 = mCCQuater4Budget.get(oCostCenter.Id);
                }
                
                                                               
               for(DRDW_Budget_Summary__c oBudSummary: mCostCenterSummary.get(oCostCenter.Id)){

                  if(oBudSummary.Rolling_Forecast__c!= null){
                    yearlyBudgetRecord.YTDRollingForecast = yearlyBudgetRecord.YTDRollingForecast + oBudSummary.Rolling_Forecast__c;
                  }
                  if(oBudSummary.F_X_Forecast__c != null){
                    yearlyBudgetRecord.YTDFXForecast = yearlyBudgetRecord.YTDFXForecast + oBudSummary.F_X_Forecast__c; 
                  }
                  if(oBudSummary.Business_Plan__c != null){
                    yearlyBudgetRecord.YTDBusinessPlan = yearlyBudgetRecord.YTDBusinessPlan + oBudSummary.Business_Plan__c; 
                  } 
                  if(oBudSummary.Q_Total_Actuals__c != null){
                    yearlyBudgetRecord.YTDTotalActuals = yearlyBudgetRecord.YTDTotalActuals + oBudSummary.Q_Total_Actuals__c; 
                    yearlyBudgetRecord.teamTotal =  yearlyBudgetRecord.teamTotal + oBudSummary.Q_Total_Actuals__c ;
                  }
                  if(yearlyBudgetRecord.YTDBusinessPlan != 0){
                    yearlyBudgetRecord.planVsActual = (yearlyBudgetRecord.YTDTotalActuals/yearlyBudgetRecord.YTDBusinessPlan)*100; 
                  }
                  
                  yearlyBudgetRecord.YTDTotalActualVsYTDRollingForecast = yearlyBudgetRecord.YTDTotalActuals - yearlyBudgetRecord.YTDRollingForecast;

                  if(oBudSummary.Quarter__c == '1'){
                        
                      if(oBudSummary.Q_Total_Actuals__c != null){
                        yearlyBudgetRecord.Q1 = yearlyBudgetRecord.Q1 + oBudSummary.Q_Total_Actuals__c;
                        quaterlyBudgetRecord1.totalActuals = quaterlyBudgetRecord1.totalActuals + oBudSummary.Q_Total_Actuals__c;
                        quaterlyBudgetRecord1.teamTotal =  quaterlyBudgetRecord1.teamTotal + oBudSummary.Q_Total_Actuals__c ;
                      }
                      if(oBudSummary.Rolling_Forecast__c!= null){
                        quaterlyBudgetRecord1.rollingForecast = quaterlyBudgetRecord1.rollingForecast + oBudSummary.Rolling_Forecast__c;
                      }
                      if(oBudSummary.F_X_Forecast__c != null){
                        quaterlyBudgetRecord1.fxForecast = quaterlyBudgetRecord1.fxForecast + oBudSummary.F_X_Forecast__c;
                      }
                      if(oBudSummary.Business_Plan__c != null){
                        quaterlyBudgetRecord1.businessPlan = quaterlyBudgetRecord1.businessPlan + oBudSummary.Business_Plan__c; 
                      }
                      if(quaterlyBudgetRecord1.businessPlan != 0){
                        quaterlyBudgetRecord1.planVsActual = (quaterlyBudgetRecord1.totalActuals/quaterlyBudgetRecord1.businessPlan)*100; 
                      }
                      quaterlyBudgetRecord1.totalActualVsYTDRollingForecast = quaterlyBudgetRecord1.totalActuals - quaterlyBudgetRecord1.rollingForecast;
                  }
                  if(oBudSummary.Quarter__c == '2'){
                                        
                      if(oBudSummary.Q_Total_Actuals__c != null){
                        yearlyBudgetRecord.Q2 = yearlyBudgetRecord.Q2 + oBudSummary.Q_Total_Actuals__c;
                        quaterlyBudgetRecord2.totalActuals = quaterlyBudgetRecord2.totalActuals + oBudSummary.Q_Total_Actuals__c;
                        quaterlyBudgetRecord2.teamTotal =  quaterlyBudgetRecord2.teamTotal + oBudSummary.Q_Total_Actuals__c ;
                      }
                      if(oBudSummary.Rolling_Forecast__c!= null){
                        quaterlyBudgetRecord2.rollingForecast = quaterlyBudgetRecord2.rollingForecast + oBudSummary.Rolling_Forecast__c;
                      }
                      if(oBudSummary.F_X_Forecast__c != null){
                        quaterlyBudgetRecord2.fxForecast = quaterlyBudgetRecord2.fxForecast + oBudSummary.F_X_Forecast__c;
                      }
                      if(oBudSummary.Business_Plan__c != null){
                        quaterlyBudgetRecord2.businessPlan = quaterlyBudgetRecord2.businessPlan + oBudSummary.Business_Plan__c; 
                      }
                      if(quaterlyBudgetRecord2.businessPlan != 0){
                        quaterlyBudgetRecord2.planVsActual = (quaterlyBudgetRecord2.totalActuals/quaterlyBudgetRecord2.businessPlan)*100; 
                      }
                      quaterlyBudgetRecord2.totalActualVsYTDRollingForecast = quaterlyBudgetRecord2.totalActuals - quaterlyBudgetRecord2.rollingForecast;
                  }
                  if(oBudSummary.Quarter__c == '3'){
                     
                      if(oBudSummary.Q_Total_Actuals__c != null){
                        yearlyBudgetRecord.Q3 = yearlyBudgetRecord.Q3 + oBudSummary.Q_Total_Actuals__c;
                        quaterlyBudgetRecord3.totalActuals = quaterlyBudgetRecord3.totalActuals + oBudSummary.Q_Total_Actuals__c;
                        quaterlyBudgetRecord3.teamTotal =  quaterlyBudgetRecord3.teamTotal + oBudSummary.Q_Total_Actuals__c ;
                      }
                      if(oBudSummary.Rolling_Forecast__c!= null){
                        quaterlyBudgetRecord3.rollingForecast = quaterlyBudgetRecord3.rollingForecast + oBudSummary.Rolling_Forecast__c;
                      }
                      if(oBudSummary.F_X_Forecast__c != null){
                        quaterlyBudgetRecord3.fxForecast = quaterlyBudgetRecord3.fxForecast + oBudSummary.F_X_Forecast__c;
                      }
                      if(oBudSummary.Business_Plan__c != null){
                        quaterlyBudgetRecord3.businessPlan = quaterlyBudgetRecord3.businessPlan + oBudSummary.Business_Plan__c; 
                      }
                      if(quaterlyBudgetRecord3.businessPlan != 0){
                        quaterlyBudgetRecord3.planVsActual = (quaterlyBudgetRecord3.totalActuals/quaterlyBudgetRecord3.businessPlan)*100; 
                      }
                      quaterlyBudgetRecord3.totalActualVsYTDRollingForecast = quaterlyBudgetRecord3.totalActuals - quaterlyBudgetRecord3.rollingForecast;
                  }
                  if(oBudSummary.Quarter__c == '4'){
                      
                      if(oBudSummary.Q_Total_Actuals__c != null){
                        yearlyBudgetRecord.Q4 = yearlyBudgetRecord.Q4 + oBudSummary.Q_Total_Actuals__c;
                        quaterlyBudgetRecord4.totalActuals = quaterlyBudgetRecord4.totalActuals + oBudSummary.Q_Total_Actuals__c;
                        quaterlyBudgetRecord4.teamTotal =  quaterlyBudgetRecord4.teamTotal + oBudSummary.Q_Total_Actuals__c ;
                      }
                      if(oBudSummary.Rolling_Forecast__c!= null){
                        quaterlyBudgetRecord4.rollingForecast = quaterlyBudgetRecord4.rollingForecast + oBudSummary.Rolling_Forecast__c;
                      }
                      if(oBudSummary.F_X_Forecast__c != null){
                        quaterlyBudgetRecord4.fxForecast = quaterlyBudgetRecord4.fxForecast + oBudSummary.F_X_Forecast__c;
                      }
                      if(oBudSummary.Business_Plan__c != null){
                        quaterlyBudgetRecord4.businessPlan = quaterlyBudgetRecord4.businessPlan + oBudSummary.Business_Plan__c; 
                      }
                      if(quaterlyBudgetRecord4.businessPlan != 0){
                        quaterlyBudgetRecord4.planVsActual = (quaterlyBudgetRecord4.totalActuals/quaterlyBudgetRecord4.businessPlan)*100; 
                      }
                      quaterlyBudgetRecord4.totalActualVsYTDRollingForecast = quaterlyBudgetRecord4.totalActuals - quaterlyBudgetRecord4.rollingForecast;
                  }
                  
                  if(mSummarySummaryDetails.containsKey(oBudSummary.Id)){
                      
                      for(DRDW_Budget_Summary_Detail__c oBudSummaryDetails: mSummarySummaryDetails.get(oBudSummary.Id) ){
                          if(oBudSummaryDetails.M_Actual__c != null){
                              if(oBudSummaryDetails.Quarter__c == '1'){
                                 if(oBudSummaryDetails.Month__c == 'Jan'){                                  
                                      actual = quaterlyBudgetRecord1.monthActualMap.get('Jan');
                                      quaterlyBudgetRecord1.monthActualMap.put('Jan',actual+oBudSummaryDetails.M_Actual__c);
                                 }
                                 if(oBudSummaryDetails.Month__c == 'Feb'){
                                      actual = quaterlyBudgetRecord1.monthActualMap.get('Feb');
                                      quaterlyBudgetRecord1.monthActualMap.put('Feb',actual+oBudSummaryDetails.M_Actual__c);
                                 }
                                 if(oBudSummaryDetails.Month__c == 'March'){
                                      actual = quaterlyBudgetRecord1.monthActualMap.get('March');
                                      quaterlyBudgetRecord1.monthActualMap.put('March',actual+oBudSummaryDetails.M_Actual__c); 
                                 }
                              }
                              if(oBudSummaryDetails.Quarter__c == '2'){  
                                 if(oBudSummaryDetails.Month__c == 'April'){
                                      actual = quaterlyBudgetRecord2.monthActualMap.get('April');
                                      quaterlyBudgetRecord2.monthActualMap.put('April',actual+oBudSummaryDetails.M_Actual__c);
                                 }
                                 if(oBudSummaryDetails.Month__c == 'May'){
                                      actual = quaterlyBudgetRecord2.monthActualMap.get('May');
                                      quaterlyBudgetRecord2.monthActualMap.put('May',actual+oBudSummaryDetails.M_Actual__c);
                                 }
                                 if(oBudSummaryDetails.Month__c == 'June'){
                                      actual = quaterlyBudgetRecord2.monthActualMap.get('June');
                                      quaterlyBudgetRecord2.monthActualMap.put('June',actual+oBudSummaryDetails.M_Actual__c);
                                 }
                              }
                              if(oBudSummaryDetails.Quarter__c == '3'){  
                                 if(oBudSummaryDetails.Month__c == 'July'){
                                      actual = quaterlyBudgetRecord3.monthActualMap.get('July');
                                      quaterlyBudgetRecord3.monthActualMap.put('July',actual+oBudSummaryDetails.M_Actual__c);
                                 }
                                 if(oBudSummaryDetails.Month__c == 'Aug'){
                                      actual = quaterlyBudgetRecord3.monthActualMap.get('Aug');
                                      quaterlyBudgetRecord3.monthActualMap.put('Aug',actual+oBudSummaryDetails.M_Actual__c);
                                 }
                                 if(oBudSummaryDetails.Month__c == 'Sept'){
                                      actual = quaterlyBudgetRecord3.monthActualMap.get('Sept');
                                      quaterlyBudgetRecord3.monthActualMap.put('Sept',actual+oBudSummaryDetails.M_Actual__c); 
                                 }
                              }
                              if(oBudSummaryDetails.Quarter__c == '4'){ 
                                 if(oBudSummaryDetails.Month__c == 'Oct'){                                   
                                      actual = quaterlyBudgetRecord4.monthActualMap.get('Oct');
                                      quaterlyBudgetRecord4.monthActualMap.put('Oct',actual+oBudSummaryDetails.M_Actual__c);
                                 }
                                 if(oBudSummaryDetails.Month__c == 'Nov'){
                                      actual = quaterlyBudgetRecord4.monthActualMap.get('Nov');
                                      quaterlyBudgetRecord4.monthActualMap.put('Nov',actual+oBudSummaryDetails.M_Actual__c);
                                 }
                                 if(oBudSummaryDetails.Month__c == 'Dec'){
                                      actual = quaterlyBudgetRecord4.monthActualMap.get('Dec');
                                      quaterlyBudgetRecord4.monthActualMap.put('Dec',actual+oBudSummaryDetails.M_Actual__c); 
                                 }
                              }
                          }
                      }                                     
                  }                      
               }  
            }
            
            if(mCostCenterSummary.containsKey(oCostCenter.Id)){
                mCCYearlyBudget.put(oCostCenter.Id,yearlyBudgetRecord);
                mCCQuater1Budget.put(oCostCenter.Id,quaterlyBudgetRecord1);
                mCCQuater2Budget.put(oCostCenter.Id,quaterlyBudgetRecord2);
                mCCQuater3Budget.put(oCostCenter.Id,quaterlyBudgetRecord3);
                mCCQuater4Budget.put(oCostCenter.Id,quaterlyBudgetRecord4);
            }         
            
        }   
        
        //Non-Discretionary Loop     
        for(DRDW_NDBD_Category__c oNDBDCatagory : lNDBDCatagory){                           
                                           
                    
            if(mCCYearlyBudget.containsKey(oNDBDCatagory.DRDW_ND_Budget_Detail__r.DRDW_Cost_Center__c)){
                yearlyBudgetRecord = mCCYearlyBudget.get(oNDBDCatagory.DRDW_ND_Budget_Detail__r.DRDW_Cost_Center__c);
            }
            if(mCCQuater1Budget.containsKey(oNDBDCatagory.DRDW_ND_Budget_Detail__r.DRDW_Cost_Center__c)){
                quaterlyBudgetRecord1 = mCCQuater1Budget.get(oNDBDCatagory.DRDW_ND_Budget_Detail__r.DRDW_Cost_Center__c);
            }

            if(mCCQuater2Budget.containsKey(oNDBDCatagory.DRDW_ND_Budget_Detail__r.DRDW_Cost_Center__c)){
                quaterlyBudgetRecord2 = mCCQuater2Budget.get(oNDBDCatagory.DRDW_ND_Budget_Detail__r.DRDW_Cost_Center__c);
            }
            if(mCCQuater3Budget.containsKey(oNDBDCatagory.DRDW_ND_Budget_Detail__r.DRDW_Cost_Center__c)){
                quaterlyBudgetRecord3 = mCCQuater3Budget.get(oNDBDCatagory.DRDW_ND_Budget_Detail__r.DRDW_Cost_Center__c);
            }
            if(mCCQuater4Budget.containsKey(oNDBDCatagory.DRDW_ND_Budget_Detail__r.DRDW_Cost_Center__c)){
                quaterlyBudgetRecord4 = mCCQuater4Budget.get(oNDBDCatagory.DRDW_ND_Budget_Detail__r.DRDW_Cost_Center__c);
            }
            
            nonDesActual = yearlyBudgetRecord.nonDesMonthActualMap.get(oNDBDCatagory.Category__c);
            yearlyBudgetRecord.nonDesMonthActualMap.put(oNDBDCatagory.Category__c,nonDesActual+oNDBDCatagory.Non_Discretionary_Year_Total__c);
            yearlyBudgetRecord.nonDescTotalActuals = yearlyBudgetRecord.nonDescTotalActuals + oNDBDCatagory.Non_Discretionary_Year_Total__c;
            yearlyBudgetRecord.teamTotal =  yearlyBudgetRecord.teamTotal + oNDBDCatagory.Non_Discretionary_Year_Total__c ;
                        
            nonDesActual = quaterlyBudgetRecord1.nonDesMonthActualMap.get(oNDBDCatagory.Category__c);
            if(oNDBDCatagory.Q1__c != null){
                quaterlyBudgetRecord1.nonDesMonthActualMap.put(oNDBDCatagory.Category__c,nonDesActual+oNDBDCatagory.Q1__c);
                quaterlyBudgetRecord1.nonDescTotalActuals = quaterlyBudgetRecord1.nonDescTotalActuals + oNDBDCatagory.Q1__c;
                quaterlyBudgetRecord1.teamTotal =  quaterlyBudgetRecord1.teamTotal + oNDBDCatagory.Q1__c ;
            }
            
            nonDesActual = quaterlyBudgetRecord2.nonDesMonthActualMap.get(oNDBDCatagory.Category__c);
            if(oNDBDCatagory.Q2__c != null){
                quaterlyBudgetRecord2.nonDesMonthActualMap.put(oNDBDCatagory.Category__c,nonDesActual+oNDBDCatagory.Q2__c);
                quaterlyBudgetRecord2.nonDescTotalActuals = quaterlyBudgetRecord2.nonDescTotalActuals + oNDBDCatagory.Q2__c;
                quaterlyBudgetRecord2.teamTotal =  quaterlyBudgetRecord2.teamTotal + oNDBDCatagory.Q2__c ;
            }
            
            nonDesActual = quaterlyBudgetRecord3.nonDesMonthActualMap.get(oNDBDCatagory.Category__c);
            if(oNDBDCatagory.Q3__c != null){
                quaterlyBudgetRecord3.nonDesMonthActualMap.put(oNDBDCatagory.Category__c,nonDesActual+oNDBDCatagory.Q3__c);
                quaterlyBudgetRecord3.nonDescTotalActuals = quaterlyBudgetRecord3.nonDescTotalActuals + oNDBDCatagory.Q3__c;
                quaterlyBudgetRecord3.teamTotal =  quaterlyBudgetRecord3.teamTotal + oNDBDCatagory.Q3__c ;
            }
            
            nonDesActual = quaterlyBudgetRecord4.nonDesMonthActualMap.get(oNDBDCatagory.Category__c);
            if(oNDBDCatagory.Q4__c != null){
                quaterlyBudgetRecord4.nonDesMonthActualMap.put(oNDBDCatagory.Category__c,nonDesActual+oNDBDCatagory.Q4__c);
                quaterlyBudgetRecord4.nonDescTotalActuals = quaterlyBudgetRecord4.nonDescTotalActuals + oNDBDCatagory.Q4__c;            
                quaterlyBudgetRecord4.teamTotal =  quaterlyBudgetRecord4.teamTotal + oNDBDCatagory.Q4__c ;
            }
             
            if(mCCYearlyBudget.containsKey(oNDBDCatagory.DRDW_ND_Budget_Detail__r.DRDW_Cost_Center__c)){
                mCCYearlyBudget.put(oNDBDCatagory.DRDW_ND_Budget_Detail__r.DRDW_Cost_Center__c,yearlyBudgetRecord);
            }
            if(mCCQuater1Budget.containsKey(oNDBDCatagory.DRDW_ND_Budget_Detail__r.DRDW_Cost_Center__c)){
                mCCQuater1Budget.put(oNDBDCatagory.DRDW_ND_Budget_Detail__r.DRDW_Cost_Center__c,quaterlyBudgetRecord1);
            }
            if(mCCQuater2Budget.containsKey(oNDBDCatagory.DRDW_ND_Budget_Detail__r.DRDW_Cost_Center__c)){
                mCCQuater2Budget.put(oNDBDCatagory.DRDW_ND_Budget_Detail__r.DRDW_Cost_Center__c,quaterlyBudgetRecord2);
            }
            if(mCCQuater3Budget.containsKey(oNDBDCatagory.DRDW_ND_Budget_Detail__r.DRDW_Cost_Center__c)){
                mCCQuater3Budget.put(oNDBDCatagory.DRDW_ND_Budget_Detail__r.DRDW_Cost_Center__c,quaterlyBudgetRecord3);
            }
            if(mCCQuater4Budget.containsKey(oNDBDCatagory.DRDW_ND_Budget_Detail__r.DRDW_Cost_Center__c)){
                mCCQuater4Budget.put(oNDBDCatagory.DRDW_ND_Budget_Detail__r.DRDW_Cost_Center__c,quaterlyBudgetRecord4);
            }
            
            
        }
        
        
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
     Public Boolean getUserPermissionFin(Id UserID){
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserID AND PermissionSet.Name = 'DRDW_Financial_User']);
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
    
    //Wrapper Structure for Yearly Table
    Public class yearlyBudgetWrapper{
    
        Public string costCenter{get;set;}
        Public string costCenterName{get;set;}
        Public string functionalArea{get;set;}
        Public decimal planVsActual{get;set;}                 
        Public decimal YTDBusinessPlan{get;set;}                        
        Public decimal YTDFXForecast{get;set;}                        
        Public decimal YTDRollingForecast{get;set;}                   
        Public decimal YTDTotalActualVsYTDRollingForecast{get;set;}
        Public decimal Q1{get;set;}                           
        Public decimal Q2{get;set;}                                    
        Public decimal Q3{get;set;}                                     
        Public decimal Q4{get;set;}                               
        Public decimal YTDTotalActuals{get;set;} 
        Public decimal nonDescTotalActuals{get;set;} 
        Public Map<String,Decimal> nonDesMonthActualMap{get;set;} 
        Public decimal teamTotal{get;set;}  
        Public Map<String,Decimal> nonDesTotalActualMap{get;set;}                      
        
        Public yearlyBudgetWrapper(string costCenter,string costCenterName,string functionalArea,decimal planVsActual,decimal YTDBusinessPlan,decimal YTDFXForecast,decimal YTDRollingForecast,
            decimal YTDTotalActualVsYTDRollingForecast,decimal Q1,decimal Q2,decimal Q3,decimal Q4,decimal YTDTotalActuals,decimal nonDescTotalActuals,Map<String,Decimal> nonDesMonthActualMap,decimal teamTotal,Map<String,Decimal> nonDesTotalActualMap){               
                        
            this.costCenter = costCenter;
            this.costCenterName = costCenterName;
            this.functionalArea = functionalArea;
            this.planVsActual = planVsActual;           
            this.YTDBusinessPlan = YTDBusinessPlan;                 
            this.YTDFXForecast = YTDFXForecast;                    
            this.YTDRollingForecast = YTDRollingForecast;         
            this.YTDTotalActualVsYTDRollingForecast = YTDTotalActualVsYTDRollingForecast;
            this.Q1 = Q1;                        
            this.Q2 = Q2;                                
            this.Q3 = Q3;                                
            this.Q4 = Q4;                            
            this.YTDTotalActuals = YTDTotalActuals; 
            this.nonDescTotalActuals = nonDescTotalActuals; 
            this.nonDesMonthActualMap = nonDesMonthActualMap;   
            this.teamTotal = teamTotal; 
            this.nonDesTotalActualMap = nonDesTotalActualMap;                
        }
    }  
     
     //Wrapper Structure for Quarterly Table
     Public class quaterlyBudgetWrapper{

        Public string costCenter{get;set;}
        Public string costCenterName{get;set;}
        Public string functionalArea{get;set;}
        Public decimal planVsActual{get;set;}                 
        Public decimal businessPlan{get;set;}                        
        Public decimal fxForecast{get;set;}                        
        Public decimal rollingForecast{get;set;}                   
        Public decimal totalActualVsYTDRollingForecast{get;set;}
        Public Map<String,Decimal> monthActualMap{get;set;}                                                         
        Public decimal totalActuals{get;set;} 
        Public decimal nonDescTotalActuals{get;set;} 
        Public Map<String,Decimal> nonDesMonthActualMap{get;set;}   
        Public decimal teamTotal{get;set;}  
        Public Map<String,Decimal> nonDesTotalActualMap{get;set;}                   
        
        Public quaterlyBudgetWrapper(string costCenter,string costCenterName,string functionalArea,decimal planVsActual,decimal businessPlan,decimal fxForecast,
        decimal rollingForecast,decimal totalActualVsYTDRollingForecast,Map<String,Decimal> monthActualMap,decimal totalActuals,decimal nonDescTotalActuals,Map<String,Decimal> nonDesMonthActualMap,decimal teamTotal,Map<String,Decimal> nonDesTotalActualMap){              
                        
            this.costCenter = costCenter;
            this.costCenterName = costCenterName;
            this.functionalArea = functionalArea;
            this.planVsActual = planVsActual;           
            this.businessPlan = businessPlan;                 
            this.fxForecast = fxForecast;                    
            this.rollingForecast = rollingForecast;         
            this.totalActualVsYTDRollingForecast = totalActualVsYTDRollingForecast;
            this.monthActualMap = monthActualMap;                                                    
            this.totalActuals = totalActuals;  
            this.nonDescTotalActuals = nonDescTotalActuals;
            this.nonDesMonthActualMap = nonDesMonthActualMap; 
            this.teamTotal = teamTotal;   
            this.nonDesTotalActualMap = nonDesTotalActualMap;                  
        }   
    
     }
     
     public List<SelectOption> getYearList() {

        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = DRDW_Budget_Summary__c.Year__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            options.add(new SelectOption(pickListVal.getLabel(),pickListVal.getLabel()));
        }
        return options; 
     }
     
     //query all the records required for the report
     Public void queryDetails(String year){
     
         mSummarySummaryDetails = new Map<Id,List<DRDW_Budget_Summary_Detail__c>>();
         mCostCenterSummary = new Map<Id, List<DRDW_Budget_Summary__c>>();
         set<Id> budgetMasterIds = new set<Id>();
         set<Id> summaryIds = new set<Id>();
         
         //query budget master records related to a particular costcenter
         lBudMaster = [Select Id,Name,Related_To__c,Cost_Center__c,Cost_Center__r.Name,Cost_Center__r.Functional_Area__c from DRDW_Budget_Master__c limit 50000];
         
         for(DRDW_Budget_Master__c oBudMaster : lBudMaster){
            List<DRDW_Budget_Master__c> lBudgetMaster;
            budgetMasterIds.add(oBudMaster.Id);
         }
         
         //query all the related budgetsummary and for a current year
         list<DRDW_Budget_Summary__c> lBudSummary = [Select Id,Name,DRDW_Budget_Master__c,DRDW_Budget_Master__r.Cost_Center__c,Rolling_Forecast__c,
                  F_X_Forecast__c,Business_Plan__c,Q_Total_Actuals__c,Quarter__c from DRDW_Budget_Summary__c where DRDW_Budget_Master__c in: budgetMasterIds and Year__c =: year];
         
         //to create map of (costcenterId, list of summary), set of summary's
         for(DRDW_Budget_Summary__c oBudSummary : lBudSummary){
            List<DRDW_Budget_Summary__c> lBudgetSummary;
            summaryIds.add(oBudSummary.Id);
            if(mCostCenterSummary.containsKey(oBudSummary.DRDW_Budget_Master__r.Cost_Center__c)){
                lBudgetSummary = mCostCenterSummary.get(oBudSummary.DRDW_Budget_Master__r.Cost_Center__c);
                lBudgetSummary.add(oBudSummary);
                mCostCenterSummary.put(oBudSummary.DRDW_Budget_Master__r.Cost_Center__c,lBudgetSummary);
            }
            else{
                lBudgetSummary = new List<DRDW_Budget_Summary__c>();
                lBudgetSummary.add(oBudSummary);
                mCostCenterSummary.put(oBudSummary.DRDW_Budget_Master__r.Cost_Center__c,lBudgetSummary);                
            }
         }
         
         //query all the related budget summary details and current year
         list<DRDW_Budget_Summary_Detail__c> lBudSummaryDetails = [Select Id,Name,DRDW_Budget_Summary__c,Month__c,Quarter__c,M_Actual__c from DRDW_Budget_Summary_Detail__c where DRDW_Budget_Summary__c in: summaryIds and Year__c =: year];
         
         //to create map of summary id and list of summary details
         for(DRDW_Budget_Summary_Detail__c oBudSummaryDetails : lBudSummaryDetails){
            List<DRDW_Budget_Summary_Detail__c> lBudgetSummaryDetails;
            if(mSummarySummaryDetails.containsKey(oBudSummaryDetails.DRDW_Budget_Summary__c)){
                lBudgetSummaryDetails = mSummarySummaryDetails.get(oBudSummaryDetails.DRDW_Budget_Summary__c);
                lBudgetSummaryDetails.add(oBudSummaryDetails);
                mSummarySummaryDetails.put(oBudSummaryDetails.DRDW_Budget_Summary__c,lBudgetSummaryDetails);
            }
            else{
                lBudgetSummaryDetails = new List<DRDW_Budget_Summary_Detail__c>();
                lBudgetSummaryDetails.add(oBudSummaryDetails);
                mSummarySummaryDetails.put(oBudSummaryDetails.DRDW_Budget_Summary__c,lBudgetSummaryDetails);                
            }
         }

        // fetching all the cost center
        lCostCenter = [Select Id,Name,Functional_Area__c,Status__c from DRDW_Cost_Center__c];
        
        //fetching Non-Discretionary  Detail Category
        lNDBDCatagory = [Select Id,Name,Category__c,DRDW_ND_Budget_Detail__c,Non_Discretionary_Year_Total__c,Q1__c,Q2__c,Q3__c,Q4__c,DRDW_ND_Budget_Detail__r.DRDW_Cost_Center__c,
                        Year__c,DRDW_ND_Budget_Detail__r.DRDW_Cost_Center__r.Name,DRDW_ND_Budget_Detail__r.DRDW_Cost_Center__r.Status__c from DRDW_NDBD_Category__c where Year__c =: year and Category__c != null];
      
        lNDBMCatagory = [Select Id,Name,Category__c,Non_Discretionary_Year_Total__c,Q1__c,Q2__c,Q3__c,Q4__c,Year__c from DRDW_NDBM_Category__c where Year__c =: year and Category__c != null];
       
         
     }
     
     public Map<String,Decimal> getCatogeryMap(){
         
        Map<String,Decimal> nonDesMonthActualMap = new Map<String,Decimal>();
        Schema.DescribeFieldResult fieldResult = DRDW_NDBD_Category__c.Category__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            nonDesMonthActualMap.put(pickListVal.getLabel(),0);
        }     
        return nonDesMonthActualMap;
    }
    
    public Map<String,Decimal> getCatogeryMasterMap(Map<string,DRDW_NDBM_Category__c> masterCategoryMap,String section){
         
        Map<String,Decimal> nonDesTotalActualMap = new Map<String,Decimal>();
        Schema.DescribeFieldResult fieldResult = DRDW_NDBD_Category__c.Category__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        Decimal actuals;
        DRDW_NDBM_Category__c oNDBM = new DRDW_NDBM_Category__c();
        for( Schema.PicklistEntry pickListVal : ple){
            actuals = 0;
            if(masterCategoryMap != null && masterCategoryMap.containsKey(pickListVal.getLabel())){
              oNDBM = masterCategoryMap.get(pickListVal.getLabel());
            }
            if(oNDBM != null && oNDBM.Non_Discretionary_Year_Total__c != null && section == 'Yearly'){
                actuals = oNDBM.Non_Discretionary_Year_Total__c;
            }
            if(oNDBM != null && oNDBM.Q1__c != null && section == 'Q1'){
                actuals = oNDBM.Q1__c;
            }
            if(oNDBM != null && oNDBM.Q2__c != null && section == 'Q2'){
                actuals = oNDBM.Q2__c;
            }
            if(oNDBM != null && oNDBM.Q3__c != null && section == 'Q3'){
                actuals = oNDBM.Q3__c;
            }
            if(oNDBM != null && oNDBM.Q4__c != null && section == 'Q4'){
                actuals = oNDBM.Q4__c;
            }
            nonDesTotalActualMap.put(pickListVal.getLabel(),actuals);
        }     
        return nonDesTotalActualMap;
    }
     
     //json generator
     public void jsonGenerator(){
        
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartArray();   
        //Year report
        gen.writeStartObject();
        gen.writeFieldName('YearlyBudget');
        gen.writeStartArray();
        for(Id costcenterId : mCCYearlyBudget.keySet()){
            gen.writeStartObject();
            gen.writeFieldName('costCenterInstance');
            gen.writeObject(mCCYearlyBudget.get(costcenterId));
            gen.writeEndObject();
        }        
        gen.writeEndArray();
        gen.writeEndObject();                
        
        //Quarter1 report
        gen.writeStartObject();
        gen.writeFieldName('Q1Budget');
        gen.writeStartArray();
        for(Id costcenterId : mCCQuater1Budget.keySet()){
            gen.writeStartObject();
            gen.writeFieldName('costCenterInstance');
            gen.writeObject(mCCQuater1Budget.get(costcenterId));
            gen.writeEndObject();
        }
        gen.writeEndArray(); 
        gen.writeEndObject();  
        
        //Quarter2 report
        gen.writeStartObject();
        gen.writeFieldName('Q2Budget');
        gen.writeStartArray();
        for(Id costcenterId : mCCQuater2Budget.keySet()){
            gen.writeStartObject();
            gen.writeFieldName('costCenterInstance');
            gen.writeObject(mCCQuater2Budget.get(costcenterId));
            gen.writeEndObject();
        }
        gen.writeEndArray(); 
        gen.writeEndObject();  
        
        //Quarter3 report
        gen.writeStartObject();
        gen.writeFieldName('Q3Budget');
        gen.writeStartArray();
        for(Id costcenterId : mCCQuater3Budget.keySet()){
            gen.writeStartObject();
            gen.writeFieldName('costCenterInstance');
            gen.writeObject(mCCQuater3Budget.get(costcenterId));
            gen.writeEndObject();
        }
        gen.writeEndArray(); 
        gen.writeEndObject();  
        
        //Quarter4 report
        gen.writeStartObject();
        gen.writeFieldName('Q4Budget');
        gen.writeStartArray();
        for(Id costcenterId : mCCQuater4Budget.keySet()){
            gen.writeStartObject();
            gen.writeFieldName('costCenterInstance');
            gen.writeObject(mCCQuater4Budget.get(costcenterId));
            gen.writeEndObject();
        }
        gen.writeEndArray(); 
        gen.writeEndObject(); 
        
        gen.writeEndArray(); 
        
        // Get the JSON string.
        jsonString = gen.getAsString();
        jsonString = jsonString.replace('null','""');
     
     }
     


}