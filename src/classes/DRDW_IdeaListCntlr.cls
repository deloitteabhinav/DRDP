Public with sharing class DRDW_IdeaListCntlr {

Public ApexPages.StandardSetController cResearchListCntlr {get;set;}
Public ApexPages.StandardSetController cIdeasListCntlr {get;set;}
Public ApexPages.StandardSetController cNewIdeasListCntlr {get;set;}

    Public string sField {get;set;}
    Public string sSearchWord {get;set;}
    Public string sOrder {get;set;}
    Public Map < String, Integer > mCategoyCount {get;set;}
    //Public List < SelectOption > oPartnershipTypeOptions {get;set;}
    //Public string sPartnershipType {get;set;}
    //Public List < Integer > lPageNumbers {get; private set;}
    Public Integer iPageNumber {get;set;}
    Public Map < String, List < wFilterWrapper >> mResearchStructure {get;set;}
    public Integer pNoLimit {get;set;}
    public Decimal dPageCount {get;set;}
    public string previousSField {get;set;}
    public boolean bShowMoreFlag {get; set;}
    public boolean bShowMoreFlag2 {get; set;}
    public boolean bShowMoreFlag3 {get; set;}
    
    public Decimal dIdeaPageCount{get;set;}
     public Decimal dProjectPageCount{get;set;}
      public Decimal dNewIdeaPageCount{get;set;}

    Public List < Integer > lnewideaPageNumbers{get;private set;}
    Public List < Integer > lideaPageNumbers{get;private set;}
    Public List < Integer > lprojectPageNumbers{get;private set;}
    
    public List < wFieldSelected > lFieldWrapper;

    public set < id > sSelectedRequestId {get;set;}
    public Set < String > sSelectedFields {get;set;}
    public List < String > lSelectedFields {get;set;}

    Public Map < String, String > mFieldList;

    Public List < DRDW_Project__c > ResearchSelectedList {get;set;}
    Public List < String > lSections {get;set;}
    Public Map < String, String > mLabel {get;set;}    
    Public List < wFieldSelected > FieldList{get;set;}
 
    
    //Loading the constructor the page
    Public DRDW_IdeaListCntlr() {
        sField = 'Name';
        previousSField = 'Name';
        bShowMoreFlag= true;
        bShowMoreFlag2= true;
        bShowMoreFlag3= true;        
        sOrder = 'ASC NULLS FIRST';
        pNoLimit = 10;
        mResearchStructure = new Map < String, List < wFilterWrapper >> ();
        
        
        //Initialisation for compare report collections
        sSelectedFields = new Set < String > ();
        lSelectedFields = new List < String > ();
        mFieldList = new Map < String, String > ();
        sSelectedRequestId = new Set < Id > ();
        ResearchSelectedList = new List < DRDW_Project__c > ();
        lSections = new List < String > ();
       // lResearchRecordWrap = new List < wResearchRecordWrap > ();

        // Methods for call
        DescribeObjectWithDetails();
        Query(string.escapeSingleQuotes(sField) + ' ' + string.escapeSingleQuotes(sOrder));
        //FieldListMaker();
        //FieldList = getFieldList();
    }

    
     /*
     * @Method Name                    :  getlResearchRecordWrap
     * @Description                    :  making a data asset wrapper with selection choices
     * @Return Type                    :  list of data asset record wrapper
     * @Parameters                     :  None
     */
    Public List< DRDW_Project__c > getlNewIdeaRecordWrap() {
        

        return cNewIdeasListCntlr.getRecords();
    }

     /*
     * @Method Name                    :  getlResearchRecordWrap
     * @Description                    :  making a data asset wrapper with selection choices
     * @Return Type                    :  list of data asset record wrapper
     * @Parameters                     :  None
     */
    Public List< DRDW_Project__c > getlResearchRecordWrap() {
        

        return cResearchListCntlr.getRecords();
    }
    
     /*
     * @Method Name                    :  getlideaRecordwrap
     * @Description                    :  making a data asset wrapper with selection choices
     * @Return Type                    :  list of data asset record wrapper
     * @Parameters                     :  None
     */
    Public List< DRDW_Project__c > getlIdeaRecordwrap() {
                           
        return cIdeasListCntlr.getRecords();
    }

     /* 
     * @Method Name                    :  DescribeObjectWithDetails
     * @Description                    :  Method to get and populate filters on UI
     * @Return Type                    :  void 
     * @Parameters                     :  None
     */
    Public Void DescribeObjectWithDetails() {
        List < wFilterWrapper > lPicklist = new List < wFilterWrapper > ();
        mCategoyCount = new Map < String, Integer > ();

        // Not using global describe which is taking longer time, hence hardcoding the field for describe
        for (Schema.Picklistentry oPicklistValues: DRDW_Project__c.Therapeutic_Area__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wFilterWrapper(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mResearchStructure.put('Therapeutic_Area__c', lPicklist);

        lPicklist = new List < wFilterWrapper > ();
        for (Schema.Picklistentry oPicklistValues: DRDW_Project__c.Phase__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wFilterWrapper(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mResearchStructure.put('Phase__c', lPicklist);
        system.debug('Phase value'+mCategoyCount);
        lPicklist = new List < wFilterWrapper > ();
        for (Schema.Picklistentry oPicklistValues: DRDW_Project__c.Business_Unit__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wFilterWrapper(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mResearchStructure.put('Business_Unit__c', lPicklist);
        
        lPicklist = new List < wFilterWrapper > ();
        for (Schema.Picklistentry oPicklistValues: DRDW_Project__c.Species__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wFilterWrapper(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mResearchStructure.put('Species__c', lPicklist); 
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
     * @Method Name                    :  FrameClause
     * @Description                    :  This method constructs the query clause if check boxes are checked for filtering on UI 
     * @Return Type                    :  string 
     * @Parameters                     :  list of wFilterWrapper 
     */
    Public string FrameClause(List < wFilterWrapper > lWrapperForProcessing) {
        String sClause = '';

        for (wFilterWrapper oWrapper: lWrapperForProcessing) {
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
     * @Description                    :  This method combines all query clauses generated in FrameClause() method 
     * @Return Type                    :  string 
     * @Parameters                     :  string and list of strings
     */
    public String CombineQuery(String sPrefix, List < String > sClauses) {
        List < String > sCombineClause = new List < String > ();
        for (String sClause: sClauses) {
            if (sClause != null && sClause != '')
                sCombineClause.add(sClause);
        }
        if (sCombineClause.size() > 0) {
            return ' ' + sPrefix + ' ' + string.join(sCombineClause, ' AND ');
        } else {
            return '';
        }
    }

    
     /* 
     * @Method Name                    :  Query
     * @Description                    :  This method queries the data base and fetches the results
     * @Return Type                    :  void
     * @Parameters                     :  string
     */
    Public void Query(String sOrder) {
        String sAreaClause = '';
        String sPhaseClause = '';
        String sSearchClause ='';
        String sUnitClause = '';
        String speciesClause ='';
        String RecordTypes = '';
         String IdeaRecordType = '';
           String NewIdeaRecordType = '';

       // List < DRDW_Project__c > lSearchWordProjects = new List < DRDW_Project__c > ();
       List < SObject > lSearchWordProjects = new List < SObject > ();

        sAreaClause = FrameClause(mResearchStructure.get('Therapeutic_Area__c'));
        if (sAreaClause != '') 
        {
            sAreaClause = ' Therapeutic_Area__c IN ' + sAreaClause;
        }

        sPhaseClause = FrameClause(mResearchStructure.get('Phase__c'));
        if (sPhaseClause != '') {
            sPhaseClause = ' Phase__c IN ' + sPhaseClause;
        }
        
        sUnitClause = FrameClause(mResearchStructure.get('Business_Unit__c'));
        if (sUnitClause != '') {
            sUnitClause = ' Business_Unit__c IN ' + sUnitClause;
        }
        
        speciesClause = FrameClause(mResearchStructure.get('Species__c'));
        if (speciesClause != '') {
            speciesClause = ' Species__c IN ' + speciesClause;
        } 
       

        if (sSearchWord != null && sSearchWord.trim() != '') {
            sSearchClause = ' Id IN : lSearchWordProjects';
        } 
        List<String> lrecordType = new List<String>();
        lrecordType.add('Generation_Project');
        lrecordType.add('Assessment_Project');
        //lrecordType.add('Idea');
       // lrecordType.add('Idea_Project');
        RecordTypes = 'RecordType.DeveloperName IN:lrecordType';
        
         List<String> lideaType = new List<String>();
        lideaType.add('Idea_Project');       
        IdeaRecordType = 'RecordType.DeveloperName IN:lideaType';
        
         List<String> lNewideaType = new List<String>();
        lNewideaType.add('Idea');       
        NewIdeaRecordType = 'RecordType.DeveloperName IN:lNewideaType';
        
       if (sSearchWord != null && sSearchWord.trim() != '') {
                system.debug('Im inside local search');
                
            List < List < sObject >> lDynamicSearchResult = search.query('FIND \'' + string.escapeSingleQuotes(sSearchWord) + '\' IN ALL FIELDS RETURNING DRDW_Project__c (Id,Name,Idea_Name__c, recordtype.Name,Functional_Area__c, Work_Activity__c, Duration__c, Go_No_Go__c, Therapeutic_Area__c,Phase__c,Business_Unit__c,Disease_Area__c,Species__c,Project_Name__c,Research_Project_Lead__c,Project_Health__c,Date_Initiated__c,New_Status__c,New_Idea_Name__c,Related_Idea__r.New_Idea_Name__c' + CombineQuery('WHERE', new List < String > {
                sAreaClause, sPhaseClause,sUnitClause,speciesClause,RecordTypes }) + ' ORDER BY ' + sOrder + ')');
                
             List < List < sObject >> lDynamicSearchResult1 = search.query('FIND \'' + string.escapeSingleQuotes(sSearchWord) + '\' IN ALL FIELDS RETURNING DRDW_Project__c (Id,Name,Idea_Name__c, recordtype.Name,Functional_Area__c, Work_Activity__c, Duration__c, Go_No_Go__c, Therapeutic_Area__c,Phase__c,Business_Unit__c,Disease_Area__c,Decision_to_Evaluate_DTE__c,ERL_Primary_Contact__r.Name,Species__c,Project_Name__c,Research_Project_Lead__c,Project_Health__c,Date_Initiated__c,New_Status__c,New_Idea_Name__c,Related_Idea__r.New_Idea_Name__c ' + CombineQuery('WHERE', new List < String > {
                sAreaClause, sPhaseClause,sUnitClause,speciesClause,IdeaRecordType }) + ' ORDER BY ' + sOrder + ')');
                
                 List < List < sObject >> lDynamicSearchResult2 = search.query('FIND \'' + string.escapeSingleQuotes(sSearchWord) + '\' IN ALL FIELDS RETURNING DRDW_Project__c (Id,Name,Idea_Name__c, recordtype.Name,Functional_Area__c, Work_Activity__c, Duration__c, Go_No_Go__c, Therapeutic_Area__c,Phase__c,Business_Unit__c,Disease_Area__c,Decision_to_Evaluate_DTE__c,ERL_Primary_Contact__r.Name,Species__c,Project_Name__c,Research_Project_Lead__c,Project_Health__c,Date_Initiated__c,New_Status__c,New_Idea_Name__c,Related_Idea__r.New_Idea_Name__c ' + CombineQuery('WHERE', new List < String > {
                sAreaClause, sPhaseClause,sUnitClause,speciesClause,NewIdeaRecordType }) + ' ORDER BY ' + sOrder + ')');

            System.debug('&&&&&&&&List of seatchwords'+lDynamicSearchResult);
            System.debug('&&&&&&&&List of seatchwords'+lDynamicSearchResult1);
            System.debug('&&&&&&&&List of seatchwords'+lDynamicSearchResult2);

            //lSearchWordProjects = lDynamicSearchResult[0];
            //lSearchWordProjects =  lDynamicSearchResult1[0];
            /*lSearchWordProjects =+ lDynamicSearchResult2[0];
            for(SObject oObject: lDynamicSearchResult[0]){
                lSearchWordProjects.add(()oObject)
            }*/

            lSearchWordProjects.addAll(lDynamicSearchResult[0]);
            lSearchWordProjects.addAll(lDynamicSearchResult1[0]);
            lSearchWordProjects.addAll(lDynamicSearchResult2[0]);

            cResearchListCntlr = new ApexPages.StandardSetController(lDynamicSearchResult[0]);
            cIdeasListCntlr = new ApexPages.StandardSetController(lDynamicSearchResult1[0]);
             cNewIdeasListCntlr = new ApexPages.StandardSetController(lDynamicSearchResult2[0]);
                
        } else {
            cResearchListCntlr = new ApexPages.StandardSetController(
            Database.getQueryLocator('SELECT Id,Name,recordtype.Name,Idea_Name__c,Functional_Area__c, Work_Activity__c,Duration__c, Go_No_Go__c,Therapeutic_Area__c,Phase__c,Business_Unit__c,Disease_Area__c,Species__c,Project_Name__c,Research_Project_Lead__c,Project_Health__c,Date_Initiated__c,New_Status__c,New_Idea_Name__c,Related_Idea__r.New_Idea_Name__c FROM DRDW_Project__c '
            + CombineQuery ('WHERE', new List < String > {
                    sAreaClause, sPhaseClause,sUnitClause,speciesClause,RecordTypes}) + ' ORDER BY ' + sOrder));
                    system.debug('+++++list of records'+cResearchListCntlr.getRecords());
            
            cIdeasListCntlr = new ApexPages.StandardSetController(
            Database.getQueryLocator('SELECT Id,Name,recordtype.Name,Idea_Name__c,Functional_Area__c, Work_Activity__c,Duration__c, Go_No_Go__c,Therapeutic_Area__c,Phase__c,Business_Unit__c,Decision_to_Evaluate_DTE__c,ERL_Primary_Contact__r.Name,Disease_Area__c,Species__c,Project_Name__c,Research_Project_Lead__c,Project_Health__c,Date_Initiated__c,New_Status__c,New_Idea_Name__c,Related_Idea__r.New_Idea_Name__c FROM DRDW_Project__c '
            + CombineQuery ('WHERE', new List < String > {
                    sAreaClause, sPhaseClause,sUnitClause,speciesClause,IdeaRecordType}) + ' ORDER BY ' + sOrder)); 
                    
                     system.debug('+++++list of records'+cIdeasListCntlr.getRecords());
                     
                      cNewIdeasListCntlr = new ApexPages.StandardSetController(
            Database.getQueryLocator('SELECT Id,Name,recordtype.Name,Idea_Name__c,Functional_Area__c, Work_Activity__c,Duration__c, Go_No_Go__c,Therapeutic_Area__c,Phase__c,Business_Unit__c,Decision_to_Evaluate_DTE__c,ERL_Primary_Contact__r.Name,Disease_Area__c,Species__c,Project_Name__c,Research_Project_Lead__c,Project_Health__c,Date_Initiated__c,New_Status__c,New_Idea_Name__c,Related_Idea__r.New_Idea_Name__c FROM DRDW_Project__c '
            + CombineQuery ('WHERE', new List < String > {
                    sAreaClause, sPhaseClause,sUnitClause,speciesClause,NewIdeaRecordType}) + ' ORDER BY ' + sOrder)); 
                    
                     system.debug('+++++list of records'+cNewIdeasListCntlr.getRecords());

        }
        
        cResearchListCntlr.setPageSize(30);
        cIdeasListCntlr.setPageSize(30);
          cNewIdeasListCntlr.setPageSize(30);
        
         lProjectPageNumbers = new List < Integer > ();
          lideaPageNumbers = new List < Integer > ();
           lnewideaPageNumbers = new List < Integer > ();
          
           dNewIdeaPageCount = pagecount(cNewIdeasListCntlr);
          dIdeaPageCount = pagecount(cIdeasListCntlr);
          dProjectPageCount = pagecount(cResearchListCntlr);
          
          lIdeaPageNumbers = pagenumbers(dIdeaPageCount);
          lProjectPageNumbers = pagenumbers(dProjectPageCount);
          lNewIdeaPageNumbers = pagenumbers(dNewIdeaPageCount);
        
      
        
        //Adding dynamic numbers to the labels which will return number of results 
        
        for (String mCount: mCategoyCount.keyset()) {
            mCategoyCount.put(mCount, 0);
        }

        for (AggregateResult ar: database.query('SELECT count(Id),Therapeutic_Area__c FROM DRDW_Project__c where Therapeutic_Area__c!=null ' + CombineQuery('AND', new List < String > {
                sPhaseClause, sSearchClause, sUnitClause ,speciesClause
            }) + ' Group BY Therapeutic_Area__c')) {
            mCategoyCount.put((String) ar.get('Therapeutic_Area__c'), (Integer) ar.get('expr0'));
        }
        System.debug('Before Phase');
        for (AggregateResult ar: database.query('SELECT count(Id),Phase__c FROM DRDW_Project__c where Phase__c != null ' + CombineQuery('AND', new List < String > {
                sAreaClause, sSearchClause, sUnitClause, speciesClause
            }) + ' Group BY Phase__c')) {
            System.debug('Query resultsssssssssssss filters'+sAreaClause+sSearchClause+sUnitClause+speciesClause);
            System.debug('Query resultsssssssssssss'+ar);
            System.debug((String) ar.get('Phase__c')+'$$$$$$$$$$$$$$$$$$$$counts'+(Integer) ar.get('expr0'));
            mCategoyCount.put((String) ar.get('Phase__c'), (Integer) ar.get('expr0'));
        }
        
        for (AggregateResult ar: database.query('SELECT count(Id),Business_Unit__c FROM DRDW_Project__c where Business_Unit__c!=null ' + CombineQuery('AND', new List < String > {
                sAreaClause, sSearchClause, sPhaseClause,speciesClause
            }) + ' Group BY Business_Unit__c')) {
            mCategoyCount.put((String) ar.get('Business_Unit__c'), (Integer) ar.get('expr0'));
        }
        
        /*for (AggregateResult ar: database.query('SELECT count(Id),Species__c FROM DRDW_Project__c where Species__c!=null ' + CombineQuery('AND', new List < String > {
                sAreaClause, sSearchClause, sUnitClause, sPhaseClause
            }) + ' Group BY Species__c')) {
            mCategoyCount.put((String) ar.get('Species__c'), (Integer) ar.get('expr0'));
        } */
        
        
        //forming drop down values for partnership type
        
        /*set < string > sTypeVal = new set < string > ();
        List < string > lTypeVal = new list < string > ();

        list < DRDW_Project__c > lPicklistValues = [SELECT id, RWE_Partnership_Type__c FROM DRDW_Project__c WHERE ID in : cPartnershipListCntlr.getrecords()];
        for (DRDW_Project__c oReq: lPicklistValues) {
            If(oReq.RWE_Partnership_Type__c != NULL && oReq.RWE_Partnership_Type__c != '') {
                for (string s: oReq.RWE_Partnership_Type__c.split(';')) {
                    sTypeVal.add(s.trim());
                }
            }
        }*/
        
        
        //To Sort the Dropdown List        
        /*If(sTypeVal.contains('Other'))
        {
            sTypeVal.remove('Other');
            lTypeVal.addall(sTypeVal);
            lTypeVal.sort();
            lTypeVal.add('Other');
        }
        else
        {
            lTypeVal.addall(sTypeVal);
            lTypeVal.sort();
        } */
        
        //Initializing the dropdown of Dynamic Drop down of Partnership Type field
        /*
        oPartnershipTypeOptions = new List < SelectOption > ();
        oPartnershipTypeOptions.add(new SelectOption('', 'All Partnership Types'));
        for (string s: lTypeVal) {
            oPartnershipTypeOptions.add(new SelectOption(s, s));
        } */
              
        
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
        
          Public void NextNewIdeaPageSeries(){
       lNewIdeaPageNumbers= NextPageSeries(lNewIdeaPageNumbers,dNewIdeaPageCount);
    }
    Public void PreviousNewIdeaPageSeries(){
       lNewIdeaPageNumbers= PreviousPageSeries(lNewIdeaPageNumbers);
    }
        
        
         Public void NextIdeaPageSeries(){
       lIdeaPageNumbers= NextPageSeries(lIdeaPageNumbers,dIdeaPageCount);
    }
    Public void PreviousIdeaPageSeries(){
       lIdeaPageNumbers= PreviousPageSeries(lIdeaPageNumbers);
    }
    
     Public void NextProjectPageSeries(){
       lProjectPageNumbers= NextPageSeries(lProjectPageNumbers,dProjectPageCount);
    }
    Public void PreviousProjectPageSeries(){
       lProjectPageNumbers= PreviousPageSeries(lProjectPageNumbers);
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
    
    
     /* 
     * @Method Name                    :  GoToPageNumber
     * @Description                    :  This method will take user to the results on that page upon clicking any page number on pagination panel
     * @Return Type                    :  void
     * @Parameters                     :  None
     */
     
       Public void GoToNewIdeaPageNumber() 
    {   
        cNewIdeasListCntlr.setPagenumber(iPageNumber);
    }
   
    
     Public void GoToIdeaPageNumber() 
    {   
        cIdeasListCntlr.setPagenumber(iPageNumber);
    }
   
    Public void GoToProjectPageNumber() 
    {   
        cResearchListCntlr.setPagenumber(iPageNumber);
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
    
    /* 
     * @Method Name                    :  toggleOff2
     * @Description                    :  Show More filter is toggled OFF
     * @Return Type                    :  None
     * @Parameters                     :  None
     */
    Public void toggleOff2() {
        bShowMoreFlag2 = false;
    }

    /* 
     * @Method Name                    :  toggleOff3
     * @Description                    :  Show More filter is toggled OFF
     * @Return Type                    :  None
     * @Parameters                     :  None
     */
    Public void toggleOff3() {
        bShowMoreFlag3 = false;
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

    
    
     /* **********************************************************************
     * Class name   : wResearchRecordWrap
     * Description  : This is a wrapper class to hold Checkbox against the Partnership Records to compare
     ********************************************************************** */

    Public class wResearchRecordWrap {
        Public Boolean isSelected {get; set;}
        Public DRDW_Project__c oResearch {get; set;}
        
        Public wResearchRecordWrap (DRDW_Project__c oPR) {
            oResearch = oPR;
        }
    }
    
        /* **********************************************************************
     * @Class Name                     :  wFilterWrapper 
     * @Description                    :  This is a wrapper class which holds the picklist value name and checkbox to filter out results on Requestlist Page
     ********************************************************************** */

    Public class wFilterWrapper {
        Public Boolean isSelected {get;set;}
        Public string label {get;set;}
        public wFilterWrapper(String l, Boolean isC) {
            label = l;
            isSelected = isC;
        }
    }

    /* **********************************************************************
     * Class name   : wFieldSelected
     * Description  : This is a wrapper class which holds the field values and checkbox to generate dynamic report
     ********************************************************************** */

    Public class wFieldSelected {
        Public Boolean fSelected {get;set;}
        Public String Section {get;set;}
        Public String Label {get;set;}
        Public String API {get;set;}
        public wFieldSelected(String l, String a, Boolean isC, String s) {
            Label = l;
            API = a;
            fSelected = isC;
            Section = s;
        }
    }

}