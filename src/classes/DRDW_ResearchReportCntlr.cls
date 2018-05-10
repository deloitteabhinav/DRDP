/****************************************************************************************************************************************** 
 * Class Name   : DRDW_ResearchReportCntlr
 * Description  : Class to display the List of DRDW Research
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
Public with sharing class DRDW_ResearchReportCntlr {

    Public ApexPages.StandardSetController cResearchListCntlr {get;set;}
    Public String sQuery{get;set;}
    Public string sField {get;set;}
    Public string sSearchWord {get;set;}
    Public string sOrder {get;set;}
    Public Map < String, Integer > mCategoyCount {get;set;}
    //Public List < SelectOption > oPartnershipTypeOptions {get;set;}
    //Public string sPartnershipType {get;set;}
    Public List < Integer > lPageNumbers {get; private set;}
    Public Integer iPageNumber {get;set;}
    Public Map < String, List < wFilterWrapper >> mResearchStructure {get;set;}
    public Integer pNoLimit {get;set;}
    public Decimal dPageCount {get;set;}
    public string previousSField {get;set;}
    public boolean bShowMoreFlag {get; set;}
    public boolean bShowMoreFlag2 {get; set;}

    public List < wFieldSelected > lFieldWrapper;

    public set < id > sSelectedRequestId {get;set;}
    public Set < String > sSelectedFields {get;set;}
    public List < String > lSelectedFields {get;set;}

    Public Map < String, String > mFieldList;

    Public List < DRDW_Project__c > ResearchSelectedList {get;set;}
    Public List < String > lSections {get;set;}
    Public Map < String, String > mLabel {get;set;}    
    Public List < wFieldSelected > FieldList{get;set;}
    Public List<DRDW_Project__c> ResearchExpList {get; set;}
    @TestVisible List < wResearchRecordWrap > lResearchRecordWrap {get; set;}
    
    //Loading the constructor the page
    Public DRDW_ResearchReportCntlr() {
        sField = 'Name';
        previousSField = 'Name';
        bShowMoreFlag2= true;        
        sOrder = 'ASC NULLS FIRST';
        mResearchStructure = new Map < String, List < wFilterWrapper >> ();
        
        
        //Initialisation for compare report collections
        sSelectedFields = new Set < String > ();
        lSelectedFields = new List < String > ();
        mFieldList = new Map < String, String > ();
        sSelectedRequestId = new Set < Id > ();
        ResearchSelectedList = new List < DRDW_Project__c > ();
        lSections = new List < String > ();
        lResearchRecordWrap = new List < wResearchRecordWrap > ();

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
    Public List< wResearchRecordWrap > getlResearchRecordWrap() {
        lResearchRecordWrap = new List<wResearchRecordWrap>();
        for (DRDW_Project__c oPR : (List<DRDW_Project__c>)cResearchListCntlr.getRecords())
            lResearchRecordWrap.add(new wResearchRecordWrap(oPR));

        return lResearchRecordWrap;
    }
    
    Public List<DRDW_Project__c> getResearchExpList(){
        ResearchExpList = cResearchListCntlr.getRecords();
        system.debug('list in get method'+ResearchExpList);
        return ResearchExpList;
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
        /*for (Schema.Picklistentry oPicklistValues: DRDW_Project__c.RecordTypeId.getDescribe().getPicklistValues()) {
            lPicklist.add(new wFilterWrapper(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }*/
        lPicklist.add(new wFilterWrapper('Research', false));
        mCategoyCount.put('Research', 0);
        lPicklist.add(new wFilterWrapper('Development', false));
        mCategoyCount.put('Development', 0);
        mResearchStructure.put('RecordType', lPicklist);

        // Describing picklist values for sub record types

        lPicklist = new List < wFilterWrapper > ();
        lPicklist.add(new wFilterWrapper('Generation Projects', false));
        mCategoyCount.put('Generation Projects', 0);
        lPicklist.add(new wFilterWrapper('Assessment Projects', false));
        mCategoyCount.put('Assessment Projects', 0);
         lPicklist.add(new wFilterWrapper('Evaluation Projects', false));
        mCategoyCount.put('Evaluation Projects', 0);
        mResearchStructure.put('RSubRecordType', lPicklist);

        lPicklist = new List < wFilterWrapper > ();
        lPicklist.add(new wFilterWrapper('Early Development Projects', false));
        mCategoyCount.put('Early Development Projects', 0);
        lPicklist.add(new wFilterWrapper('Full Development Projects', false));
        mCategoyCount.put('Full Development Projects', 0);
        mResearchStructure.put('DSubRecordType', lPicklist);


        lPicklist = new List < wFilterWrapper > ();
        for (Schema.Picklistentry oPicklistValues: DRDW_Project__c.Functional_Area__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wFilterWrapper(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mResearchStructure.put('Functional_Area__c', lPicklist);
        
        lPicklist = new List < wFilterWrapper > ();
        for (Schema.Picklistentry oPicklistValues: DRDW_Project__c.Business_Unit__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wFilterWrapper(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mResearchStructure.put('Business_Unit__c', lPicklist);
        
        /* lPicklist = new List < wFilterWrapper > ();
        for (Schema.Picklistentry oPicklistValues: DRDW_Project__c.Go_No_Go__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wFilterWrapper(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mResearchStructure.put('Go_No_Go__c', lPicklist); */
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
            return ' ' + sPrefix + ' ' +string.join(sCombineClause, ' AND ');
        } else {
            return '';
        }
    }
    
    public String CombineQuery1(String sPrefix, List < String > sClauses) {
        List < String > sCombineClause = new List < String > ();
        for (String sClause: sClauses) {
            if (sClause != null && sClause != '')
                sCombineClause.add(sClause);
        }
        if (sCombineClause.size() > 0) {
            return ' ' + sPrefix + ' ' +string.join(sCombineClause, ' AND ')+ 'AND';
        } else {
            return ''+sPrefix;
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
        String sRecordTypeClause = '';
        String sSearchClause ='';
        String sUnitClause = '';

        List < DRDW_Project__c > lSearchWordProjects = new List < DRDW_Project__c > ();

        sAreaClause = FrameClause(mResearchStructure.get('Functional_Area__c'));
        if (sAreaClause != '') 
        {
            sAreaClause = ' Functional_Area__c IN ' + sAreaClause;
        }
        
        if(FrameClause(mResearchStructure.get('RSubRecordType')) != ''){

            if(FrameClause(mResearchStructure.get('RSubRecordType')).contains('Generation') && FrameClause(mResearchStructure.get('RSubRecordType')).contains('Assessment')&& FrameClause(mResearchStructure.get('RSubRecordType')).contains('Evaluation')){
                    system.debug('Inside 2 researches');
                    sRecordTypeClause = '(' + '\'' + 'Generation_Project' + '\',' + '\'' + 'Assessment_Project' +'\','+ '\'' + 'Idea_Project' +'\''+')';
            }else { 
                    if(FrameClause(mResearchStructure.get('RSubRecordType')).contains('Generation')){
                            system.debug('Inside gen');
                            sRecordTypeClause = '(' + '\'' + 'Generation_Project' + '\'' +')';
                    }
                    if(FrameClause(mResearchStructure.get('RSubRecordType')).contains('Assessment')){
                            system.debug('Inside Assess');
                            sRecordTypeClause = '(' + '\'' + 'Assessment_Project' + '\'' +')';
                    } 
                    if(FrameClause(mResearchStructure.get('RSubRecordType')).contains('Evaluation')){
                            system.debug('Inside Assess');
                            sRecordTypeClause = '(' + '\'' + 'Idea_Project' + '\'' +')';
                    }
            }    
        }

            /* Code when Development is included.
            if(FrameClause(mResearchStructure.get('RSubRecordType')) != '' || FrameClause(mResearchStructure.get('DSubRecordType')) != ''){
                if(FrameClause(mResearchStructure.get('RSubRecordType')).contains('Generation') && FrameClause(mResearchStructure.get('RSubRecordType')).contains('Assessment') && FrameClause(mResearchStructure.get('DSubRecordType')).contains('Early') && FrameClause(mResearchStructure.get('DSubRecordType')).contains('Full')){
                        system.debug('Inside all 4');
                        sRecordTypeClause = '(' + '\'' + 'Generation_Project' + '\',' + '\'' + 'Assessment_Project' +'\','+ '\'' + 'DP1_Project' + '\','+ '\'' + 'DP2_Project' + '\'' +')';                
                }else {
                    if(FrameClause(mResearchStructure.get('RSubRecordType')).contains('Generation') && FrameClause(mResearchStructure.get('RSubRecordType')).contains('Assessment') && FrameClause(mResearchStructure.get('DSubRecordType')).contains('Early')){
                        system.debug('Inside 3');
                        sRecordTypeClause = '(' + '\'' + 'Generation_Project' + '\',' + '\'' + 'Assessment_Project' +'\','+ '\'' + 'DP1_Project' + '\''+')';                
                    }else{
                            if(FrameClause(mResearchStructure.get('RSubRecordType')).contains('Generation') && FrameClause(mResearchStructure.get('RSubRecordType')).contains('Assessment') && FrameClause(mResearchStructure.get('DSubRecordType')).contains('Full')){
                                system.debug('Inside 3');
                                sRecordTypeClause = '(' + '\'' + 'Generation_Project' + '\',' + '\'' + 'Assessment_Project' +'\','+ '\'' + 'DP2_Project' + '\''+')';                
                            }else {
                                if(FrameClause(mResearchStructure.get('RSubRecordType')).contains('Generation') && FrameClause(mResearchStructure.get('DSubRecordType')).contains('Full') && FrameClause(mResearchStructure.get('DSubRecordType')).contains('Early')){
                                    system.debug('Inside 3');
                                    sRecordTypeClause = '(' + '\'' + 'Generation_Project' + '\',' + '\'' + 'DP1_Project' +'\','+ '\'' + 'DP2_Project' + '\''+')';                
                                }else {
                                    if(FrameClause(mResearchStructure.get('RSubRecordType')).contains('Assessment') && FrameClause(mResearchStructure.get('DSubRecordType')).contains('Full') && FrameClause(mResearchStructure.get('DSubRecordType')).contains('Early')){
                                        system.debug('Inside 3');
                                        sRecordTypeClause = '(' + '\'' + 'DP1_Project' + '\',' + '\'' + 'Assessment_Project' +'\','+ '\'' + 'DP2_Project' + '\''+')';                
                                    }else
                                    {
                                       if(FrameClause(mResearchStructure.get('RSubRecordType')).contains('Assessment') && FrameClause(mResearchStructure.get('DSubRecordType')).contains('Full')){
                                            system.debug('Inside 2');
                                            sRecordTypeClause = '(' + '\'' + 'Assessment_Project' +'\','+ '\'' + 'DP2_Project' + '\''+')';                
                                        }else {
                                            if(FrameClause(mResearchStructure.get('RSubRecordType')).contains('Generation') && FrameClause(mResearchStructure.get('DSubRecordType')).contains('Full')){
                                                system.debug('Inside 2');
                                                sRecordTypeClause = '(' + '\'' + 'Generation_Project' +'\','+ '\'' + 'DP2_Project' + '\''+')';                
                                            }else {
                                                if(FrameClause(mResearchStructure.get('RSubRecordType')).contains('Generation') && FrameClause(mResearchStructure.get('DSubRecordType')).contains('Early')){
                                                    system.debug('Inside 2');
                                                    sRecordTypeClause = '(' + '\'' + 'Generation_Project' +'\','+ '\'' + 'DP1_Project' + '\''+')';                
                                                }else {
                                                    if(FrameClause(mResearchStructure.get('RSubRecordType')).contains('Generation') && FrameClause(mResearchStructure.get('DSubRecordType')).contains('Full')){
                                                        system.debug('Inside 2');
                                                        sRecordTypeClause = '(' + '\'' + 'Generation_Project' +'\','+ '\'' + 'DP2_Project' + '\''+')';                
                                                    }else {

                                                        if(FrameClause(mResearchStructure.get('RSubRecordType')).contains('Generation') && FrameClause(mResearchStructure.get('RSubRecordType')).contains('Assessment')){
                                                            system.debug('Inside 2 researches');
                                                            sRecordTypeClause = '(' + '\'' + 'Generation_Project' + '\',' + '\'' + 'Assessment_Project' +'\''+ ')';
                                                        }else { 
                                                            if(FrameClause(mResearchStructure.get('RSubRecordType')).contains('Generation')){
                                                                    system.debug('Inside gen');
                                                                    sRecordTypeClause = '(' + '\'' + 'Generation_Project' + '\'' +')';
                                                            }
                                                            if(FrameClause(mResearchStructure.get('RSubRecordType')).contains('Assessment')){
                                                                    system.debug('Inside Ass');
                                                                    sRecordTypeClause = '(' + '\'' + 'Assessment_Project' + '\'' +')';
                                                            }  
                                                        }    
                                                        if(FrameClause(mResearchStructure.get('DSubRecordType')).contains('Early') && FrameClause(mResearchStructure.get('DSubRecordType')).contains('Full')){
                                                            sRecordTypeClause = '(' + '\'' + 'DP1_Project' + '\','+ '\'' + 'DP2_Project' + '\'' +')';
                                                        }else {
                                                            if(FrameClause(mResearchStructure.get('DSubRecordType')).contains('Early')){
                                                                    sRecordTypeClause = '(' + '\'' + 'DP1_Project' + '\'' +')';
                                                            }
                                                            if(FrameClause(mResearchStructure.get('DSubRecordType')).contains('Full')){
                                                                sRecordTypeClause = '(' + '\'' + 'DP2_Project' + '\'' +')';
                                                            }
                                                        }

                                                    }
                                                }
                                            }
                                        } 
                                    }
                                }
                            }
                                        
                    }       
                  }  
           }
           if(FrameClause(mResearchStructure.get('DSubRecordType')) == '' && FrameClause(mResearchStructure.get('RSubRecordType')) == ''){
                sRecordTypeClause = '(' + '\'' + 'Generation_Project' + '\',' + '\'' + 'Assessment_Project' + '\',' + '\'' + 'DP1_Project' + '\',' + '\'' + 'DP2_Project' + '\''+ ')'; 
            } */

        
        if (sRecordTypeClause != '') {
            sRecordTypeClause = ' RecordType.DeveloperName IN ' + sRecordTypeClause;
            system.debug('Final Recordtype clause'+sRecordTypeClause);
        }
        
        sUnitClause = FrameClause(mResearchStructure.get('Business_Unit__c'));
        if (sUnitClause != '') {
            sUnitClause = ' Business_Unit__c IN ' + sUnitClause;
        }
       

        if (sSearchWord != null && sSearchWord.trim() != '') {
            sSearchClause = ' Id IN : lSearchWordProjects';
        }
        
        
       if (sSearchWord != null && sSearchWord.trim() != '') {
                system.debug('Im inside local search');
                
            List < List < sObject >> lDynamicSearchResult = search.query('FIND \'' + string.escapeSingleQuotes(sSearchWord) + '\' IN ALL FIELDS RETURNING DRDW_Project__c (Id,Name,RecordTypeId,RecordType.DeveloperName, Functional_Area__c, Work_Activity__c, Duration__c, Go_No_Go__c, Therapeutic_Area__c,Phase__c,Business_Unit__c,Disease_Area__c,Species__c,Project_Name__c,Research_Project_Lead__c,Project_Health__c, Project_Health_new__c ,ERL_Primary_Contact__c ' + CombineQuery1('WHERE', new List < String > {
                sAreaClause, sRecordTypeClause,sUnitClause }) + ' RecordType.DeveloperName NOT IN ('+'\'' + 'DP1_Project' + '\',' + '\'' + 'DP2_Project' + '\','+'\'' + 'Idea' + '\','+'\'' + 'Idea_Project' + '\''+ ')' +' ORDER BY ' + sOrder + ')');
            lSearchWordProjects = lDynamicSearchResult[0];
            cResearchListCntlr = new ApexPages.StandardSetController(lDynamicSearchResult[0]);
                
        } else {
           
            cResearchListCntlr = new ApexPages.StandardSetController(
            //Database.getQueryLocator(Qstring));
            Database.getQueryLocator('SELECT Id,Name,RecordTypeId,RecordType.DeveloperName,Functional_Area__c, Work_Activity__c,Duration__c, Go_No_Go__c,Therapeutic_Area__c,Phase__c,Business_Unit__c,Disease_Area__c,Species__c,Project_Name__c,Research_Project_Lead__c,Project_Health__c, Project_Health_new__c,ERL_Primary_Contact__c FROM DRDW_Project__c '
            + CombineQuery1('WHERE', new List < String > {
                    sRecordTypeClause,sAreaClause,sUnitClause})+ ' RecordType.DeveloperName NOT IN ('+'\'' + 'DP1_Project' + '\',' + '\'' + 'DP2_Project' + '\','+'\'' + 'Idea' + '\','+'\'' + 'Idea_Project' + '\''+ ')' + ' ORDER BY ' + sOrder));
                    
                    system.debug('+++++list of records'+cResearchListCntlr.getRecords());

        }
        
        cResearchListCntlr.setPageSize(50);
        lPageNumbers = new List < Integer > ();
        dPageCount = 0;
        dPageCount = (decimal.valueof(cResearchListCntlr.getResultSize()) / decimal.valueof(cResearchListCntlr.getPageSize()));
        dPageCount = dPageCount.round(System.RoundingMode.UP);
        
        for (Integer i = 1; i <= dPageCount; i++) {
            lPageNumbers.add(i);
            if (lPageNumbers.size() == pNoLimit)
                break;
        }
        
        
        //Adding dynamic numbers to the labels which will return number of results 
        
        for (String mCount: mCategoyCount.keyset()) {
            mCategoyCount.put(mCount, 0);
        }

        for (AggregateResult ar: database.query('SELECT count(Id),Functional_Area__c FROM DRDW_Project__c where Functional_Area__c!=null ' + CombineQuery('AND', new List < String > {
                sRecordTypeClause, sSearchClause, sUnitClause
            }) + ' Group BY Functional_Area__c')) {
            mCategoyCount.put((String) ar.get('Functional_Area__c'), (Integer) ar.get('expr0'));
        }

        /*for (AggregateResult ar: database.query('SELECT count(Id),RecordType.Name FROM DRDW_Project__c where RecordTypeId!=null ' + CombineQuery('AND', new List < String > {
                sAreaClause, sSearchClause,sUnitClause
            }) + ' Group BY RecordType.Name')) {
            mCategoyCount.put((String) ar.get('RecordType'), (Integer) ar.get('expr0'));
        }*/
        
        for (AggregateResult ar: database.query('SELECT count(Id),Business_Unit__c FROM DRDW_Project__c where Business_Unit__c!=null ' + CombineQuery('AND', new List < String > {
                sAreaClause, sSearchClause, sRecordTypeClause
            }) + ' Group BY Business_Unit__c')) {
            mCategoyCount.put((String) ar.get('Business_Unit__c'), (Integer) ar.get('expr0'));
        }
              
        
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
    
    Public void GoToPageNumber() {
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
     * @Method Name                    :  NextPageSeries
     * @Description                    :  This method takes the user to next set of pages on pagination panel on UI
     * @Return Type                    :  void
     * @Parameters                     :  None
     */
    Public void NextPageSeries() {

        Integer currentLimit = lPageNumbers[lPageNumbers.size() - 1];
        lPageNumbers = new List < Integer > ();
        for (Integer i = 1; i <= pNoLimit; i++) {
            if (currentLimit + i <= dPageCount) {
                lPageNumbers.add(currentLimit + i);

            }
        }
    }

    /* 
     * @Method Name                    :  PreviousPageSeries
     * @Description                    :  This method takes the user to previous set of pages on pagination panel on UI
     * @Return Type                    :  void
     * @Parameters                     :  None
     */
    Public void PreviousPageSeries() {

        Integer currentLimit = lPageNumbers[0] - pNoLimit - 1;

        lPageNumbers = new List < Integer > ();
        for (Integer i = 1; i <= pNoLimit; i++) {
            lPageNumbers.add(currentLimit + i);
        }
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
    
    
     /*
    * @Method Name                    :  ExportToExcel
    * @Description                    :  This method redirects the page with excel parameter to rerender the page as excel
    * @Return Type                    :  PageReference
    * @Parameters                     :  None
    */
    
    Public PageReference ExportToExcel() {
        //QueryMaker();
        //PageReference PageRef = new PageReference('/apex/DRDW_ResearchReport?IsExcel=TRUE');
        //ShowTable();
        getResearchExpList();
        system.debug('List before redirecting '+ResearchExpList);
        PageReference PageRef = new PageReference('/apex/DRDW_LeadershipExport');    
        PageRef.setRedirect(false);
        return PageRef;
    }
    
     /* 
     * @Method Name                    :  ShowTable
     * @Description                    :  This method is called upon when a user generates or exports a report
     * @Return Type                    :  void
     * @Parameters                     :  None
     */

    Public void ShowTable() {
        List<DRDW_Project__c> ResearchExpList = cResearchListCntlr.getRecords();
        system.debug('List in show table'+ResearchExpList);
    }
    
    /*
    * @Method Name                    :  QueryMaker
    * @Description                    :  This method Generates Dynamic Query based on Filter option selected, fetches the record and stores them in the wrapper
    * @Return Type                    :  void
    * @Parameters                     :  None
    */
    
    Public void QueryMaker(){
        
        Transient List<DRDW_Project__c> lProjects = new List<DRDW_Project__c>();
        
        sQuery = 'Select Id,Name from DRDW_Project__c';
        //Query the Bp based on filters 
        lProjects = Database.Query(sQuery);  
      }

}