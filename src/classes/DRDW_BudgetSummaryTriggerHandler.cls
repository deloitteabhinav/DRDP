public class DRDW_BudgetSummaryTriggerHandler {
        
    
    public void OnAfterInsert(List<DRDW_Budget_Summary__c> newSummaries){
        
        List<DRDW_Budget_Summary_Detail__c> lDSummary = new List<DRDW_Budget_Summary_Detail__c>();
        
        Schema.DescribeFieldResult fieldResult = DRDW_Budget_Summary_Detail__c.Month__c.getDescribe();
                List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                List<String> months = new List<String>();
                for( Schema.PicklistEntry f : ple)
                   {
                     months.add(f.getValue());
                   }    
                system.debug('picklist'+months);
                
                
        
        
        for(DRDW_Budget_Summary__c oSummary : newSummaries){
            List<String> qmonths = getCurrentMonths(oSummary.Quarter__c);
            for(String m:qmonths){
            
            DRDW_Budget_Summary_Detail__c oDetail = new DRDW_Budget_Summary_Detail__c();
            oDetail.DRDW_Budget_Summary__c = oSummary.Id;
            oDetail.Month__c=m;
            oDetail.Year__c = oSummary.Year__c;
            oDetail.Quarter__c = oSummary.Quarter__c;
            lDSummary.add(oDetail);
            }
        }
        
        insert lDSummary;
        
    }
    
    
    Public void OnAfterUpdate(List<DRDW_Budget_Summary__c> newSummaries,Map<Id,DRDW_Budget_Summary__c> oldMap){
        
        Set<ID> bIds = new Set<ID>();
        
         for(DRDW_Budget_Summary__c oSummary:newSummaries){                      
            bIds.add(oSummary.DRDW_Budget_Master__c);
        }
        
        Map<id,DRDW_Budget_Master__c> mapOfMasters = new Map<id,DRDW_Budget_Master__c>([select id,Total_Actuals__c,Total_Rolling_Forecast__c,Total_F_X_Forecast__c,Total_Business_Plan__c from DRDW_Budget_Master__c where id in:bIds]);
        
        if(!mapOfMasters.isEmpty()){
            
        List<DRDW_Budget_Master__c> lBudgets = new List<DRDW_Budget_Master__c>();
        
            for(DRDW_Budget_Summary__c oSummary:newSummaries){                      
            DRDW_Budget_Master__c oMaster = mapOfMasters.get(oSummary.DRDW_Budget_Master__c);
            
            if(oMaster.Total_Actuals__c==null){
                oMaster.Total_Actuals__c = 0;
                }
            if(oMaster.Total_Rolling_Forecast__c == null){
                oMaster.Total_Rolling_Forecast__c=0;
                }
                oMaster.Total_Actuals__c = oMaster.Total_Actuals__c - oldMap.get(oSummary.id).Q_Total_Actuals__c;
                oMaster.Total_Actuals__c = oMaster.Total_Actuals__c + oSummary.Q_Total_Actuals__c;
                system.debug('Total Actual'+oSummary.Q_Total_Actuals__c);
                oMaster.Total_Rolling_Forecast__c =  oMaster.Total_Rolling_Forecast__c - oldMap.get(oSummary.id).Rolling_Forecast__c;
                oMaster.Total_Rolling_Forecast__c =oMaster.Total_Rolling_Forecast__c + oSummary.Rolling_Forecast__c;
                
                  oMaster.Total_Business_Plan__c=  oMaster.Total_Business_Plan__c- oldMap.get(oSummary.id).Business_Plan__c;
                oMaster.Total_Business_Plan__c=oMaster.Total_Business_Plan__c+ oSummary.Business_Plan__c;
                
                  oMaster.Total_F_X_Forecast__c=  oMaster.Total_F_X_Forecast__c- oldMap.get(oSummary.id).F_X_Forecast__c;
                oMaster.Total_F_X_Forecast__c=oMaster.Total_F_X_Forecast__c+ oSummary.F_X_Forecast__c;
                
              system.debug('Total Forecast'+oSummary.Rolling_Forecast__c);
              oMaster.Total_Actuals__c = oMaster.Total_Actuals__c.round(System.RoundingMode.HALF_EVEN);
              lBudgets.add(oMaster);
            
        }
        
        Set<DRDW_Budget_Master__c> sBudgets = new Set<DRDW_Budget_Master__c>();
        sBudgets.addAll(lBudgets);
        lBudgets.clear();
        lBudgets.addAll(sBudgets);
        
        update lBudgets;
            
        }        
    }
    
     public void OnBeforeDelete(List<DRDW_Budget_Summary__c> oldMasters,Map<Id,DRDW_Budget_Summary__c> oldMap){
         
           updateBudgetMaster(oldMasters,oldMap);
         
     }
    
    
    public void OnAfterDelete(List<DRDW_Budget_Summary__c> oldMasters,Map<Id,DRDW_Budget_Summary__c> oldMap){
         
         
        Set<Id> bIds = new Set<Id>();
        //map of budget master and budget summary
        Map<Id,Id> summarybudget = new Map<Id,Id>();
        
        for(DRDW_Budget_Summary__c b:oldMasters){
            summarybudget.put(b.id,b.DRDW_Budget_Master__c);
        } 
        
        List<DRDW_Budget_Line_Item__c> blineitems = new List<DRDW_Budget_Line_Item__c>();
        
        blineitems = [select id,Related_To__c,Posting_Date__c,Quarter__c from DRDW_Budget_Line_Item__c where Related_To__c in : summarybudget.Values()];
        
        Map<Id,List<DRDW_Budget_Line_Item__c>> masterLines = new Map<Id,List<DRDW_Budget_Line_Item__c>>();
        
        for(DRDW_Budget_Line_Item__c b:blineitems){
        
            if(!masterLines.containsKey(b.Related_To__c)){
                List<DRDW_Budget_Line_Item__c> blines = new List<DRDW_Budget_Line_Item__c>();
                blines.add(b);
                masterLines.put(b.Related_To__c,blines);
            }else{
            List<DRDW_Budget_Line_Item__c> blines = masterLines.get(b.Related_To__c);
                blines.add(b);
                masterLines.put(b.Related_To__c,blines);
            
            }
        
        }
        
        List<DRDW_Budget_Line_Item__c> dbLines = new List<DRDW_Budget_Line_Item__c>();
        
        
         for(DRDW_Budget_Summary__c b:oldMasters){
            if(masterLines.get(summarybudget.get(b.id))!=null)
            for(DRDW_Budget_Line_Item__c line:masterLines.get(summarybudget.get(b.id))){
                 system.debug('******Year****'+b.Year__c);
                  system.debug('******lineYear****'+line.Posting_Date__c.Year());
                if(line.Quarter__c == b.Quarter__c && line.Posting_Date__c.Year() == Integer.valueOf(b.Year__c)){
                    dbLines.add(line);
                }
                    
            }
            
        } 
        
        
        system.debug(dbLines);
        
        
        
     
        List<DRDW_Budget_Summary_Detail__c> lBDetails = new List<DRDW_Budget_Summary_Detail__c>();      
        
         lBDetails = [select id from DRDW_Budget_Summary_Detail__c where DRDW_Budget_Summary__c in:oldMap.keySet()];
         
         try{
            
          
            
            delete lBDetails;
            delete dbLines;
           
            
          
        
        }catch(Exception e){
        
            system.debug('error'+e.getMessage());
            
        }
        
        
     }
    
    
    
    
    Public List<String> getCurrentMonths(String i){
    
        List<String> months = new List<String>();
        
        if(i=='1'){
        
          months.add('Jan');
               months.add('Feb');
                months.add('March');
        
        }else if(i=='2'){
        
             months.add('April');
               months.add('May');
                months.add('June');
            
        }else if(i=='3'){
        
             months.add('July');
               months.add('Aug');
                months.add('Sept');
         
        
        }else if(i=='4'){
        
             months.add('Oct');
               months.add('Nov');
                months.add('Dec');
            
        }
        
        return months;
        
    }
    
    public void onBeforeInsert(List<DRDW_Budget_Summary__c> NewSummaryList){
     List<DRDW_Budget_Summary__c> lSummary = new List<DRDW_Budget_Summary__c>();  
        //Changing the currency ISO for all Budget Master records getting inserted  
            for(DRDW_Budget_Summary__c oSummary : NewSummaryList){
                oSummary.CurrencyIsoCode = Label.DRDW_Currency_Label;
                lSummary.add(oSummary);
            }
        /* updating the records if not null
        if(!lSummary.isEmpty() && lSummary != null){
            update lSummary;
        }  */      
        
    }
    
    
    public void updateBudgetMaster(List<DRDW_Budget_Summary__c> oldMasters,Map<Id,DRDW_Budget_Summary__c> oldMap){

        Set<ID> bIds = new Set<ID>();
        
         for(DRDW_Budget_Summary__c oSummary:oldMasters){                      
            bIds.add(oSummary.DRDW_Budget_Master__c);
        }
        
        Map<id,DRDW_Budget_Master__c> mapOfMasters = new Map<id,DRDW_Budget_Master__c>([select id,Total_Actuals__c,Total_Rolling_Forecast__c,Total_F_X_Forecast__c,Total_Business_Plan__c from DRDW_Budget_Master__c where id in:bIds]);
        
       
        
        if(!mapOfMasters.isEmpty()){
            
        List<DRDW_Budget_Master__c> lBudgets = new List<DRDW_Budget_Master__c>();
        
            for(DRDW_Budget_Summary__c oSummary:oldMasters){                      
            DRDW_Budget_Master__c oMaster = mapOfMasters.get(oSummary.DRDW_Budget_Master__c);
            
            if(oMaster.Total_Actuals__c==null){
                oMaster.Total_Actuals__c = 0;
                }
            if(oMaster.Total_Rolling_Forecast__c == null){
                oMaster.Total_Rolling_Forecast__c=0;
                }
                
                oMaster.Total_Actuals__c = oMaster.Total_Actuals__c - oSummary.Q_Total_Actuals__c;
                system.debug('Total Actual'+oSummary.Q_Total_Actuals__c);
                
                oMaster.Total_Rolling_Forecast__c =oMaster.Total_Rolling_Forecast__c - oSummary.Rolling_Forecast__c;
                
                 
                oMaster.Total_Business_Plan__c=oMaster.Total_Business_Plan__c- oSummary.Business_Plan__c;
                
                  
                oMaster.Total_F_X_Forecast__c=oMaster.Total_F_X_Forecast__c- oSummary.F_X_Forecast__c;
                
              system.debug('Total Forecast'+oSummary.Rolling_Forecast__c);
              oMaster.Total_Actuals__c = oMaster.Total_Actuals__c.round(System.RoundingMode.HALF_EVEN);
              lBudgets.add(oMaster);
            
        }
        
        Set<DRDW_Budget_Master__c> sBudgets = new Set<DRDW_Budget_Master__c>();
        sBudgets.addAll(lBudgets);
        lBudgets.clear();
        lBudgets.addAll(sBudgets);
        
        update lBudgets;
            
        }        

}
    
}