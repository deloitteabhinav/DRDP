Public with sharing class DRDW_GlobalSearchController  {
    //Instantiate the StandardSetController  
     public ApexPages.StandardSetController cStudiesListController{get;set;}
     
     public ApexPages.StandardSetController cIdeasListController{get;set;}
     public ApexPages.StandardSetController cEvalListController{get;set;}
     public ApexPages.StandardSetController cProjectsListController{get;set;}
     
     
    public Integer pNoLimit {get;set;}
    public string previousSField {get;set;}
    public string sField {get;set;}
    public string sOrder {get;set;}
    public string sFinalSort{get;set;}
    
    Public List < Integer > lStudyPageNumbers{get;private set;}
    
     Public List < Integer > lIdeaPageNumbers{get;private set;}
      Public List < Integer > lEvalPageNumbers{get;private set;}
    Public List < Integer > lprojectPageNumbers{get;private set;}
    
    
    Public Integer iPageNumber{get;set;}
        
    public Decimal dStudyPageCount{get;set;}
    
    
     public Decimal dIdeaPageCount{get;set;}
      public Decimal dEvalPageCount{get;set;}
     public Decimal dProjectPageCount{get;set;}
   
        
    public Boolean isStudies {get;set;}    
   

    public Boolean isShrink {get;set;}
    public string sLocalSearch {get;set;}
    

    Public List < DRDW_Project__c > lProjects {get;set;}
    Public List < DRDW_Project__c > lideas {get;set;}
      Public List < DRDW_Project__c > lEvals {get;set;}
   

    public Map < string, string > mURLparams = new map < string, string > ();
    public Map < String, Integer > mCategoyCount;
    Public Map < String, List < wStudyObject >> mStudyObjectStructure {get;set;}
    
    public boolean bShowMoreFlag{get;set;} 

    //Constructor of the Page
    Public DRDW_GlobalSearchController () {
        sField = 'Name';
        previousSField = 'Name';
        sOrder = 'ASC NULLS FIRST';
        pNoLimit = 10;
        isShrink = FALSE;
        bShowMoreFlag = True;
        mURLparams = ApexPages.currentPage().getParameters();
        mStudyObjectStructure = new Map < String, List < wStudyObject >> ();
        //Populating picklist filters
        mStudyObjectStructure.put('TherapeuticArea', populateTherapeuticArea());
        mStudyObjectStructure.put('BU', populateBU());
        mStudyObjectStructure.put('Phase', populatePhase());
        mStudyObjectStructure.put('Species', populateSpecies());
        

        //setting the boolean attributes to choose objects for search
          
            isStudies = true;
           
        
        String sQuery = string.escapeSingleQuotes(sField)+' '+string.escapeSingleQuotes(sOrder);
        
            Query(sQuery,null);
           
    }
    
     /* 
     * @Method Name                    :  toggleOff
     * @Description                    :  Show More filter is toggled OFF
     * @Return Type                    :  None
     * @Parameters                     :  None
     */
    
    Public void toggleOff() {
        bShowMoreFlag= false;
    }

    
     Public List < DRDW_Project__c > getStudies() {
        return (List < DRDW_Project__c > ) cStudiesListController.getRecords();
    }
    
    
      Public List < DRDW_Project__c > getIdeas() {
        return (List < DRDW_Project__c > ) cIdeasListController.getRecords();
    }
    
      Public List < DRDW_Project__c > getEvals() {
        return (List < DRDW_Project__c > ) cEvalListController.getRecords();
    }
    
     Public List < DRDW_Project__c > getProjects() {
        return (List < DRDW_Project__c > ) cProjectsListController.getRecords();
    }
  

    /* 
    * @Method Name                    :  populateTherapeuticArea
    * @Description                    :  Method to populate therapeutic area picklist filter
    * @Return Type                    :  List
    * @Parameters                     :  None
    */  
    Public list < wStudyObject > populateTherapeuticArea() {

        List < wStudyObject > lPicklist = new List < wStudyObject > ();        
        for (Schema.Picklistentry oPicklistValues : DRDW_Project__c.Therapeutic_Area__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wStudyObject(oPicklistValues.Value, false));
        }

        return lPicklist;
    }

    /* 
    * @Method Name                    :  populateBU
    * @Description                    :  Method to populate BU picklist filter
    * @Return Type                    :  List
    * @Parameters                     :  None
    
    */  
    Public list < wStudyObject > populateBU() {

        List < wStudyObject > lPicklist = new List < wStudyObject > ();
        for (Schema.Picklistentry oPicklistValues: DRDW_Project__c.Business_Unit__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wStudyObject(oPicklistValues.Value, false));
        }

        return lPicklist;
    }
    
     /* 
    * @Method Name                    :  populateSpecies
    * @Description                    :  Method to populate BU picklist filter
    * @Return Type                    :  List
    * @Parameters                     :  None
    
    */  
    Public list < wStudyObject > populateSpecies() {

        List < wStudyObject > lPicklist = new List < wStudyObject > ();
        for (Schema.Picklistentry oPicklistValues: DRDW_Project__c.Species__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wStudyObject(oPicklistValues.Value, false));
        }

        return lPicklist;
    }
    
      /* 
    * @Method Name                    :  populatePhase
    * @Description                    :  Method to populate BU picklist filter
    * @Return Type                    :  List
    * @Parameters                     :  None
    
    */  
    Public list < wStudyObject > populatePhase() {

        List < wStudyObject > lPicklist = new List < wStudyObject > ();
        for (Schema.Picklistentry oPicklistValues: DRDW_Project__c.Phase__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wStudyObject(oPicklistValues.Value, false));
        }

        return lPicklist;
    }


    

     /* 
    * @Method Name                    :  FrameClause
    * @Description                    :  Creating query parameters for checkboxes selected
    * @Return Type                    :  string
    * @Parameters                     :  lWrapperForProcessing
    */  
    Public string FrameClause(List < wStudyObject > lWrapperForProcessing) {
        String sClause = '';
        for (wStudyObject oWrapper: lWrapperForProcessing) {
            if (oWrapper.isSelected) {
                sClause += '\'' + oWrapper.label + '\',';
            }
        }
        if (sClause != '') {
            sClause = '(' + sClause.removeend(',') + ')';
        }
        return sClause;
    }

   

    /* 
    * @Method Name                    :  CombineQuery
    * @Description                    :  Method to combine all query parameters
    * @Return Type                    :  string
    * @Parameters                     :  sPrefix,sClauses
    */
    public String CombineQuery(String sPrefix, List < String > sClauses) {
        List < String > sCombineClause = new List < String > ();
        for (String sClause: sClauses) {
            if (sClause != null && sClause != '')
                sCombineClause.add(sClause);
        }
        if (sCombineClause.size() > 0)
            return ' ' + sPrefix + ' ' + string.join(sCombineClause, ' AND ');
        return '';
    }

    //Query constructor method
     /* 
    * @Method Name                    :  Query
    * @Description                    :  Query constructor method
    * @Return Type                    :  void
    * @Parameters                     :  None
    */
    Public void Query(string sFinalSort,string sObjectName) {
            
        
            String sDynamicQuery;
            String sDynamicQuery2;

            String sSearchWord = mURLparams.get('searchWord');
            if(sSearchWord.length()>49){
                isShrink=TRUE;
            }   
            
   
            
            String sReqStudyTherapeuticAreaClause = '';
           
            String sRequestStudyBUClause = '';
            String sRequestStudyPhaseClause = '';
            String sRequestStudySpeciesClause = '';
            
      
          
           


            /*Start of Related Object Search Section*/

            //Initial Sets. Used for related object search
            set<id> sStudyIDs = new set<id>();
        

            sSearchWord = sSearchWord.trim();
           if(sLocalSearch != NULL){
                sLocalSearch = sLocalSearch.trim();
            }

            String sWord;

            //Searching related objects and adding them to the initial Set
            if (sSearchWord != null && sSearchWord.trim() != '') {
                sWord = sSearchWord;
            }

      

            //Getting Therapeutic Areas based on User Selection. This set will be used to filter the records obtained for related object search
            Set<String> sChildTherapeuticArea = new Set<String>();
            for (wStudyObject oWrapper: mStudyObjectStructure.get('TherapeuticArea')) {
            if (oWrapper.isSelected) {
                sChildTherapeuticArea.add(oWrapper.label);
                }
            }

            //Getting Region based on User Selection. This set will be used to filter the records obtained for related objects search
            Set<String> sChildRegion = new Set<String>();
            for (wStudyObject oWrapper: mStudyObjectStructure.get('BU')) {
            if (oWrapper.isSelected) {
                sChildRegion.add(oWrapper.label);
                }
            }
            
             Set<String> sChildPhase = new Set<String>();
            for (wStudyObject oWrapper: mStudyObjectStructure.get('Phase')) {
            if (oWrapper.isSelected) {
                sChildPhase.add(oWrapper.label);
                }
            }
            
             Set<String> sChildSpecies = new Set<String>();
            for (wStudyObject oWrapper: mStudyObjectStructure.get('Species')) {
            if (oWrapper.isSelected) {
                sChildSpecies.add(oWrapper.label);
                }
            }

            
            sReqStudyTherapeuticAreaClause = FrameClause(mStudyObjectStructure.get('TherapeuticArea'));
            if (sReqStudyTherapeuticAreaClause != '') {
                sReqStudyTherapeuticAreaClause = ' Therapeutic_Area__c IN ' + sReqStudyTherapeuticAreaClause;
            }
            
            sRequestStudyBUClause = FrameClause(mStudyObjectStructure.get('BU'));
            if (sRequestStudyBUClause != '') {
                sRequestStudyBUClause = ' Business_Unit__c IN ' + sRequestStudyBUClause ;
            }
            
            sRequestStudyPhaseClause = FrameClause(mStudyObjectStructure.get('Phase'));
            if (sRequestStudyPhaseClause != '') {
                sRequestStudyPhaseClause = ' Phase__c IN ' + sRequestStudyPhaseClause ;
            }
            
            sRequestStudySpeciesClause = FrameClause(mStudyObjectStructure.get('Species'));
            if (sRequestStudySpeciesClause != '') {
                sRequestStudySpeciesClause = ' Species__c IN ' + sRequestStudySpeciesClause ;
            }
          

         if (sSearchWord != null && sSearchWord.trim() != '') {
                if (sLocalSearch != null && sLocalSearch.trim() != '') {
                    sDynamicQuery = 'FIND \'' + string.escapeSingleQuotes(sSearchWord) + ' AND ' + string.escapeSingleQuotes(+sLocalSearch) + '\' IN ALL FIELDS RETURNING ';

                } else {
                    sDynamicQuery = 'FIND \'' + string.escapeSingleQuotes(sSearchWord) + '\' IN ALL FIELDS RETURNING ';
                }
                 sDynamicQuery += 'DRDW_Project__c   (id ' + CombineQuery('WHERE',new List <String>{sReqStudyTherapeuticAreaClause,sRequestStudyBUClause,sRequestStudyPhaseClause,sRequestStudySpeciesClause }) + '),DRDW_Risk__c(id,Related_To__c),DRDW_Budget_Master__c(id,Related_To__c),DRDW_Capability__c(id,Related_Idea__c,Related_Project__c),';
                 
                 }
                 
                 sDynamicQuery = sDynamicQuery.removeEnd(',');

                 system.debug('*****Query******'+sDynamicQuery);
                 
            List <List<sObject>> lDynamicSearchResult = search.query(sDynamicQuery);
            
             list<DRDW_Project__c > lStudies2 = new list<DRDW_Project__c >();
             list<DRDW_Risk__c > lRisks = new list<DRDW_Risk__c >();
             list<DRDW_Budget_Master__c> lBudgets = new list<DRDW_Budget_Master__c>();
             list<DRDW_Capability__c> lCaps = new list<DRDW_Capability__c>();
             
             
             
             
             
             lStudies2 = lDynamicSearchResult[0];
              lRisks = lDynamicSearchResult[1];
               lBudgets = lDynamicSearchResult[2];
               lCaps = lDynamicSearchResult[3];
               
               Set<Id> projectIds = new Set<Id>();
               
               for(DRDW_Project__c p:lStudies2){
                   projectIds.add(p.id);
               }
               
               for(DRDW_Risk__c r:lRisks){
                   projectIds.add(r.Related_To__c);
               }
               
                for(DRDW_Budget_Master__c b:lBudgets){
                   projectIds.add(b.Related_To__c);
               }
               
                  for(DRDW_Capability__c c:lCaps){
                  if(c.Related_Idea__c!=Null)
                   projectIds.add(c.Related_Idea__c);
                  if(c.Related_Project__c!=Null)
                   projectIds.add(c.Related_Project__c);
               }
               
               
                        
            //Final Queries of the records
             lideas = new list<DRDW_Project__c>();
             lEvals = new list<DRDW_Project__c>();
             lprojects = new list<DRDW_Project__c>();
            
                
           
                lideas = Database.query('Select id,recordtype.Name,Idea_Name__c,New_Idea_Name__c,Date_Initiated__c,New_Status__c,Decision_to_Evaluate_DTE__c,Duration__c,ERL_Primary_Contact__r.Name,Go_No_Go__c,Business_Unit__c,Phase__c,Disease_Area__c,Species__c,Project_Name__c,Research_Project_Lead__r.Name,Project_Health__c From DRDW_Project__c  where id in:projectIds and RecordType.Name = \'Idea\'Order By '+ sFinalSort);
                
                  lEvals = Database.query('Select id,recordtype.Name,Idea_Name__c,Decision_to_Evaluate_DTE__c,Duration__c,ERL_Primary_Contact__r.Name,Go_No_Go__c,Business_Unit__c,Phase__c,Disease_Area__c,Species__c,Project_Name__c,Research_Project_Lead__r.Name,Project_Health__c,Related_Idea__r.New_Idea_Name__c From DRDW_Project__c  where id in:projectIds and RecordType.Name = \'Idea Project\'Order By '+ sFinalSort);
                
                
                lprojects = Database.query('Select id,recordtype.Name,Idea_Name__c,Decision_to_Evaluate_DTE__c,Duration__c,ERL_Primary_Contact__r.Name,Go_No_Go__c,Business_Unit__c,Phase__c,Disease_Area__c,Species__c,Project_Name__c,Research_Project_Lead__r.Name,Project_Health__c From DRDW_Project__c  where id in:projectIds and (RecordType.Name = \'Assessment Project\' or RecordType.Name = \'Generation Project\') Order By '+ sFinalSort);
            
           system.debug('*******'+sObjectName);
            
           List < DRDW_Project__c > lideasf = new List < DRDW_Project__c > ();
            List < DRDW_Project__c > lEvalf = new List < DRDW_Project__c > ();
            List < DRDW_Project__c >  lprojectsf = new List < DRDW_Project__c > ();
           
               

                   lideasf.addall(lideas);
                   lEvalf.addall(lEvals);
                   lprojectsf.addall(lprojects);
                    
               

                cStudiesListController = new ApexPages.StandardSetController(lideasf);
                cStudiesListController.setPageSize(20);
                
                   cEvalListController = new ApexPages.StandardSetController(lEvalf);
                cEvalListController.setPageSize(20);
                
                   cIdeasListController = new ApexPages.StandardSetController(lideasf);
                cIdeasListController.setPageSize(20);
              
                cProjectsListController =  new ApexPages.StandardSetController(lprojectsf);
                cProjectsListController.setPageSize(20);
                
                lStudyPageNumbers = new List < Integer > ();
                
                
                
                lEvalPageNumbers = new List < Integer > ();
                lIdeaPageNumbers = new List < Integer > ();             
                lProjectPageNumbers = new List < Integer > ();
               
               dStudyPageCount = pagecount(cStudiesListController);
               
               dEvalPageCount = pagecount(cEvalListController);
               dIdeaPageCount = pagecount(cIdeasListController);
               dProjectPageCount = pagecount(cProjectsListController);
                                
                lStudyPageNumbers = pagenumbers(dStudyPageCount);
                
               lEvalPageNumbers = pagenumbers(dEvalPageCount);
                lIdeaPageNumbers = pagenumbers(dIdeaPageCount);
                lProjectPageNumbers = pagenumbers(dProjectPageCount);
                                
                    
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
    /*
     * Method name  : GoToPageNumber
     * Description  : This method takes the user to results of that particular page on upon clicking any number on pagination panel on UI
     * Return Type  : void
     * @Parameters  : None
     */
    Public void GoToStudyPageNumber() 
    {   
        cStudiesListController.setPagenumber(iPageNumber);
    }
    
     Public void GoToIdeaPageNumber() 
    {   
        cIdeasListController.setPagenumber(iPageNumber);
    }
    
     Public void GoToEvalPageNumber() 
    {   
        cEvalListController.setPagenumber(iPageNumber);
    }
   
    Public void GoToProjectPageNumber() 
    {   
        cProjectsListController.setPagenumber(iPageNumber);
    }
   

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

    Public list<integer> PreviousPageSeries(list<integer> lPageNumbers) {
        Integer currentLimit = lPageNumbers[0] - pNoLimit - 1;

        lPageNumbers = new List < Integer > ();
        for (Integer i = 1; i <= pNoLimit; i++) 
        {
            lPageNumbers.add(currentLimit + i);
        }
        return lPageNumbers;
    }
    
    Public void NextStudyPageSeries(){
       lStudyPageNumbers= NextPageSeries(lStudyPageNumbers,dStudyPageCount);
    }
    Public void PreviousStudyPageSeries(){
       lStudyPageNumbers= PreviousPageSeries(lStudyPageNumbers);
    }
    
     Public void NextIdeaPageSeries(){
       lIdeaPageNumbers= NextPageSeries(lIdeaPageNumbers,dIdeaPageCount);
    }
    Public void PreviousIdeaPageSeries(){
       lIdeaPageNumbers= PreviousPageSeries(lIdeaPageNumbers);
    }
    
     Public void NextEvalPageSeries(){
       lEvalPageNumbers= NextPageSeries(lEvalPageNumbers,dEvalPageCount);
    }
    Public void PreviousEvalPageSeries(){
       lEvalPageNumbers= PreviousPageSeries(lEvalPageNumbers);
    }
    
     Public void NextProjectPageSeries(){
       lProjectPageNumbers= NextPageSeries(lProjectPageNumbers,dProjectPageCount);
    }
    Public void PreviousProjectPageSeries(){
       lProjectPageNumbers= PreviousPageSeries(lProjectPageNumbers);
    }
   
    
    public void sortStudies(){
        sort();
        query(sFinalSort ,'Studies');
    }
   
    
    
    /*
     * Method name  : sort
     * Description  : Sorting of the results displayed by clicking on the column link
     * Return Type  : void
     * @Parameters  : None
     */

    Public void sort() 
    {
        if (sField == previousSField) 
        {
            if (sOrder.contains('ASC')) 
            {
                sOrder = sOrder.replace('ASC', 'DESC');
                sOrder = sOrder.replace('FIRST', 'LAST');
            } 
            else 
            {
                sorder = sorder.replace('DESC', 'ASC');
                sOrder = sOrder.replace('LAST', 'FIRST');
            }
        } 
        else 
        {
            sOrder = 'ASC NULLS FIRST';
            previoussField = sField;
        }
        
        sFinalSort = string.escapeSingleQuotes(sField)+' '+string.escapeSingleQuotes(sOrder);
    }
    
    /*
         * Class name   : wStudyObject
         * Description  : This is a wrapper class which holds the picklist value name and checkbox to filter out results on Global Search Page
         */

        Public class wStudyObject {
            Public Boolean isSelected {get;set;}
            Public string label {get;set;}

            public wStudyObject(String l, Boolean isC) {
                isSelected = isC;
                label = l;
            }
        }
        
        public void FetchDataForCriteria(){
        String sQuery = string.escapeSingleQuotes(sField)+' '+string.escapeSingleQuotes(sOrder);
        Query(sQuery,null);
    }
}