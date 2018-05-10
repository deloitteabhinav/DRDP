Public with sharing class DRDW_ResourceList {

Public ApexPages.StandardSetController cResourceListCntlr {get;set;}


    Public string sField {get;set;}
    Public string sSearchWord {get;set;}
    Public string sOrder {get;set;}
   
    //Public List < Integer > lPageNumbers {get; private set;}
    Public Integer iPageNumber {get;set;}
  
    public Integer pNoLimit {get;set;}
    public Decimal dPageCount {get;set;}
    public string previousSField {get;set;}
   
    
  
     public Decimal dResourcePageCount{get;set;}
     

   
    Public List < Integer > lResourcePageNumbers{get;private set;}
    
   

   

   

 
 
    
    //Loading the constructor the page
    Public DRDW_ResourceList () {
        sField = 'Name';
        previousSField = 'Name';
             
        sOrder = 'ASC NULLS FIRST';
        pNoLimit = 10;
       

        // Methods for call
        //DescribeObjectWithDetails();
        Query(string.escapeSingleQuotes(sField) + ' ' + string.escapeSingleQuotes(sOrder));
      
    }

    
   

     /*
     * @Method Name                    :  getlResearchRecordWrap
     * @Description                    :  making a data asset wrapper with selection choices
     * @Return Type                    :  list of data asset record wrapper
     * @Parameters                     :  None
     */
    Public List<DRDW_Resource__c> getlResourceRecordWrap() {
        

        return cResourceListCntlr.getRecords();
    }
    
   

 
    
         /* 
     * @Method Name                    :  FetchDataForCriteria
     * @Description                    :  This method is called upon anny action on UI to query the data base
     * @Return Type                    :  void
     * @Parameters                     :  None
     */

    public void FetchDataForCriteria() {
        Query(string.escapeSingleQuotes(sField) + ' ' + string.escapeSingleQuotes(sOrder));
    }


  

    
     /* 
     * @Method Name                    :  Query
     * @Description                    :  This method queries the data base and fetches the results
     * @Return Type                    :  void
     * @Parameters                     :  string
     */
    Public void Query(String sOrder) {
          
        
       if (sSearchWord != null && sSearchWord.trim() != '') {
                system.debug('Im inside local search');
                
         //   List < List < sObject >> lDynamicSearchResult = search.query('FIND \'' + string.escapeSingleQuotes(sSearchWord) + '\' IN ALL FIELDS RETURNING DRDW_Resource__c ( Id,Name__r.Name,Department__c,Role__c,Type__c ORDER BY ' + sOrder + ')');
                
          
cResourceListCntlr = new ApexPages.StandardSetController(
            Database.getQueryLocator('SELECT Id,Name__r.Name,Department__c,Role__c,Type__c,Hours_per_Week__c,Hours_Available_Per_Day__c,Days_Per_Week__c FROM DRDW_Resource__c where Name__r.Name LIKE \'%'+string.escapeSingleQuotes(sSearchWord)+'%\' ORDER BY ' + sOrder));
                
            
         //   cResourceListCntlr = new ApexPages.StandardSetController(lDynamicSearchResult[0]);
           
                
        } else {
            cResourceListCntlr = new ApexPages.StandardSetController(
            Database.getQueryLocator('SELECT Id,Name__r.Name,Department__c,Role__c,Type__c,Hours_per_Week__c,Hours_Available_Per_Day__c,Days_Per_Week__c FROM DRDW_Resource__c ORDER BY ' + sOrder));
                    
                    
            
         

        }
        
        cResourceListCntlr.setPageSize(30);
       
        
         lResourcePageNumbers = new List < Integer > ();
        
          
           
          dResourcePageCount = pagecount(cResourceListCntlr);
          
        
          lResourcePageNumbers = pagenumbers(dResourcePageCount);
         
                
    }

    
      public list<integer> pagenumbers(decimal pagecount){
        list<integer> lPageNumbers = new list<integer>();
            for (Integer i = 1; i <= pagecount; i++) {
                    lPageNumbers.add(i);
                    if (lPageNumbers.size() == pNoLimit)
                        break;
                }
                return lPagenumbers;
        }
        
        public decimal pagecount(ApexPages.StandardSetController stdcntrlr){
            decimal dStudyPageCount= 0;
            dStudyPageCount= (decimal.valueof(stdcntrlr.getResultSize()) / decimal.valueof(stdcntrlr.getPageSize()));
            dStudyPageCount= dStudyPageCount.round(System.RoundingMode.UP);
            return dStudyPageCount;
        }
        
    
    
     Public void NextResourcePageSeries(){
       lResourcePageNumbers= NextPageSeries(lResourcePageNumbers,dResourcePageCount);
    }
    Public void PreviousResourcePageSeries(){
       lResourcePageNumbers= PreviousPageSeries(lResourcePageNumbers);
    }


         /* 
     * @Method Name                    :  sort
     * @Description                    :  This method sorts the results upon clicking sortable field names on results header on UI
     * @Return Type                    :  void
     * @Parameters                     :  None
     */

    Public void sort() {
    
       if (sField == previousSField) {
            if (sOrder.contains('ASC')) {
                sOrder = sOrder.replace('ASC', 'DESC');
                sOrder = sOrder.replace('FIRST', 'LAST');
            } else {
                sorder = sorder.replace('DESC', 'ASC');
                sOrder = sOrder.replace('LAST', 'FIRST');
            }
        } else {
            sOrder = 'ASC NULLS FIRST';
            previoussField = sField;
        }
        Query(string.escapeSingleQuotes(sField) + ' ' + string.escapeSingleQuotes(sOrder));
    
    }
    
    
   
   
    Public void GoToResourcePageNumber() 
    {   
        cResourceListCntlr.setPagenumber(iPageNumber);
    }
    
   
   

    /* 
     * @Method Name                    :  NextPageSeries
     * @Description                    :  This method takes the user to next set of pages on pagination panel on UI
     * @Return Type                    :  void
     * @Parameters                     :  None
     */
     Public list<integer> NextPageSeries(list<integer> lPageNumbers,Decimal dPageCount) {
        Integer currentLimit = lPageNumbers[lPageNumbers.size() - 1];
        lPageNumbers = new List < Integer > ();
        for (Integer i = 1; i <= pNoLimit; i++) 
        {
            if (currentLimit + i <= dPageCount) 
            {
                lPageNumbers.add(currentLimit + i);
            }
        }
        return lPageNumbers;
    }

    /* 
     * @Method Name                    :  PreviousPageSeries
     * @Description                    :  This method takes the user to previous set of pages on pagination panel on UI
     * @Return Type                    :  void
     * @Parameters                     :  None
     */
     Public list<integer> PreviousPageSeries(list<integer> lPageNumbers) {
        Integer currentLimit = lPageNumbers[0] - pNoLimit - 1;

        lPageNumbers = new List < Integer > ();
        for (Integer i = 1; i <= pNoLimit; i++) 
        {
            lPageNumbers.add(currentLimit + i);
        }
        return lPageNumbers;
    }

    
    
   

   

}