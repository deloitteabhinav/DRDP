public class DRDW_Discretionary {

    List<DRDW_ND_Budget_Master__c> lBMasters{get;set;}
    List<DRDW_Cost_Center__c> lCost{get;set;}
    public String selectedYear {get; set;}
    public String wRecord{get; set;}
    public String selectedCost{get; set;}
    public List<SelectOption> Years{get;set;}
    public List<SelectOption> lCostcenters{get;set;} 
    Public List<DRDW_NDBM_Category__c> lCategory{get;set;} 
    Public List<DRDW_NDBD_Category__c> ldCategory{get;set;}

    public DRDW_Discretionary(){
    
        lBMasters = [select id,Year__c from DRDW_ND_Budget_Master__c ORDER BY Year__c ASC ];
        lCost = [select id,Name from DRDW_Cost_Center__c where status__c = 'Active' ORDER BY Name];
        
         Years = new List<SelectOption>();
         lCostcenters = new List<SelectOption>();
         for(DRDW_ND_Budget_Master__c b: lBMasters){
            Years.add(new SelectOption(b.Year__c,b.Year__c));
         }
         
         lCostcenters.add(new SelectOption('','--NONE--'));
         for(DRDW_Cost_Center__c c: lCost){
            lCostcenters.add(new SelectOption(c.Name,c.Name));
         }
         
         
    }
    
    Public void displayMCategory(){
        
         lCategory = [select id,Name,Category__c,Non_Discretionary_Year_Total__c,Q1__c,Q2__c,Q3__c,Q4__c from DRDW_NDBM_Category__c where Year__c =: selectedYear]; 
          ldCategory = [select id,Name,Category__c,Non_Discretionary_Year_Total__c,Q1__c,Q2__c,Q3__c,Q4__c from DRDW_NDBD_Category__c where Year__c =: selectedYear and Cost_Center__c =:selectedCost];
    }
    
     public Void updateMCategory(){
    
        update lCategory;
        lCategory = [select id,Name,Category__c,Non_Discretionary_Year_Total__c,Q1__c,Q2__c,Q3__c,Q4__c from DRDW_NDBM_Category__c where Year__c =:selectedYear];
        
    }
    
     public Void ResetMCategory(){
    
        
        lCategory = [select id,Name,Category__c,Non_Discretionary_Year_Total__c,Q1__c,Q2__c,Q3__c,Q4__c from DRDW_NDBM_Category__c where Year__c =: selectedYear];
        
    }
    
     public Void updateDCategory(){
    
        update ldCategory;
          ldCategory = [select id,Name,Category__c,Non_Discretionary_Year_Total__c,Q1__c,Q2__c,Q3__c,Q4__c from DRDW_NDBD_Category__c where Year__c =: selectedYear and Cost_Center__c =:selectedCost];
        
    }
    
     public Void ResetDCategory(){
    
        
           ldCategory = [select id,Name,Category__c,Non_Discretionary_Year_Total__c,Q1__c,Q2__c,Q3__c,Q4__c from DRDW_NDBD_Category__c where Year__c =: selectedYear and Cost_Center__c =:selectedCost];
        
    }
    
    
}