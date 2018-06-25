/******************************************************************************************************************************************
 * Class Name   : RequestList
 * Description  : List page with filters for Request records
 * Created By   : Deloitte Consulting
 *
 *****************************************************************************************************************************************/
Public with sharing class RequestList {

    Public ApexPages.StandardSetController cRequestListCntlr {
        get;
        set;
    }
    Public string sField {
        get;
        set;
    }
    Public string sSearchWord {
        get;
        set;
    }
    Public string sOrder {
        get;
        set;
    }
     Public string sReqStatus{
        get;
        set;
    }
    Public Map < String, Integer > mCategoyCount {
        get;
        set;
    }
    Public List < Integer > lPageNumbers {
        get;
        private set;
    }
    Public Integer iPageNumber {
        get;
        set;
    }
    Public Map < String, List < wFilterWrapper >> mRequestObjectStructure {
        get;
        set;
    }
    public Integer pNoLimit {
        get;
        set;
    }
    public Decimal dPageCount {
        get;
        set;
    }
    public string previousSField {
        get;
        set;
    }
     Public List<SelectOption> ReqStatus{
        get;
        set;
    }
    public boolean bShowMoreFlag 
    {
        get;
        set;
    }

    //Loading the constructor the page
    Public RequestList() {
        pNoLimit = 20;
        // Initialisation
        sField = 'Name';
        previousSField = 'Name';
        sOrder = 'ASC NULLS FIRST';
        bShowMoreFlag = true;
        mRequestObjectStructure = new Map < String, List < wFilterWrapper >> ();

        // Methods for call
        DescribeObjectWithDetails();
        Query(string.escapeSingleQuotes(sField) + ' ' + string.escapeSingleQuotes(sOrder));
    }
    
     Public void toggleOff() {
        bShowMoreFlag= false;
    }

    /*
     * @Method Name                    :  getRequests
     * @Description                    :  Initialize cRequestListCntlr and return a list of records
     * @Return Type                    :  List of Requests
     * @Parameters                     :  None
     */

    Public List < Contracts__c > getRequests() {
        return (List < Contracts__c > ) cRequestListCntlr.getRecords();
    }

    /*
     * @Method Name                    :  DescribeObjectWithDetails
     * @Description                    :  Method to get and populate therapeutic area, request type, status and region picklist filters on UI
     * @Return Type                    :  void
     * @Parameters                     :  None
     */

    Public Void DescribeObjectWithDetails() {
        List < wFilterWrapper > lPicklist = new List < wFilterWrapper > ();
        mCategoyCount = new Map < String, Integer > ();

        for (Schema.Picklistentry oPicklistValues : Contracts__c.Contract_Category__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wFilterWrapper(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label+'TA', 0);
        }
        mRequestObjectStructure.put('Contract_Category__c', lPicklist);

        lPicklist = new List < wFilterWrapper > ();
        for (Schema.Picklistentry oPicklistValues : Contracts__c.Contract_Type__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wFilterWrapper(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mRequestObjectStructure.put('Contract_Type__c', lPicklist);

        lPicklist = new List < wFilterWrapper > ();
        for (Schema.Picklistentry oPicklistValues : Contracts__c.Contract_Specific_Type__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wFilterWrapper(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label+'BU', 0);
        }
        mRequestObjectStructure.put('Contract_Specific_Type__c', lPicklist);

        lPicklist = new List < wFilterWrapper > ();
        for (Schema.Picklistentry oPicklistValues : Contracts__c.Contract_Status__c.getDescribe().getPicklistValues()) {
            
                lPicklist.add(new wFilterWrapper(oPicklistValues.Value, false));
                mCategoyCount.put(oPicklistValues.Label, 0);
            
        }
        mRequestObjectStructure.put('Contract_Status__c', lPicklist);
        
        
        ReqStatus = new List<SelectOption>();
        sReqStatus = 'All Status';
        ReqStatus.add(new SelectOption('All Status', 'All Status'));
        for (Schema.Picklistentry oPicklistValues: Request__c.Request_Status__c.getDescribe().getPicklistValues()) 
        {
            ReqStatus.add(new SelectOption(oPicklistValues.Label,oPicklistValues.Value));
            
        }
    }

    /*
     * @Method Name                    :  FrameClause
     * @Description                    :  This method constructs the query clause if check boxes are checked for filtering on UI
     * @Return Type                    :  string
     * @Parameters                     :  list of wFilterWrapper
     */

    Public string FrameClause(List < wFilterWrapper > lWrapperForProcessing) {
        String sClause = '';
        for (wFilterWrapper oWrapper : lWrapperForProcessing) {
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
        for (String sClause : sClauses) {
            if (sClause != null && sClause != '')
                sCombineClause.add(sClause);
        }
        if (sCombineClause.size() > 0)
            return ' ' + sPrefix + ' ' + string.join(sCombineClause, ' AND ');
        return ' ';
    }

    /*
     * @Method Name                    :  Query
     * @Description                    :  This method queries the data base and fetches the results
     * @Return Type                    :  void
     * @Parameters                     :  string
     */

    Public void Query(String sOrder) {
        String sRegionClause = '';
        String sTherapeuticAreaClause = '';
        String sStatusClause = '';
        String sRequestTypeClause = '';
        String sSearchClause = '';
        String sBUClause = '';
        List < Contracts__c > lSearchWordProjects = new List < Contracts__c > ();

        sRegionClause = FrameClause(mRequestObjectStructure.get('Contract_Category__c'));
        if (sRegionClause != '') {
            sRegionClause = ' Contract_Category__c IN ' + sRegionClause;
        }
        
        sBUClause = FrameClause(mRequestObjectStructure.get('Contract_Specific_Type__c'));
        if (sBUClause != '') {
            sBUClause = ' Contract_Specific_Type__c IN ' + sBUClause;
        }
        
        
        sTherapeuticAreaClause = FrameClause(mRequestObjectStructure.get('Contract_Status__c'));
        if (sTherapeuticAreaClause != '') {
            sTherapeuticAreaClause = ' Contract_Status__c IN ' + sTherapeuticAreaClause;
        }

        sRequestTypeClause = FrameClause(mRequestObjectStructure.get('Contract_Type__c'));
        if (sRequestTypeClause != '') {
            sRequestTypeClause = ' Contract_Type__c IN ' + sRequestTypeClause;
        }

        if (sReqStatus != 'All Status') 
        {
            sStatusClause = ' Request_Status__c IN (\'' + string.escapeSingleQuotes(sReqStatus) +'\')';
        }
        

        if ((sSearchWord != null && sSearchWord.length()>1) && sSearchWord.trim() != '') {
            sSearchClause = ' Id IN : lSearchWordProjects';
        }

        if ((sSearchWord != null && sSearchWord.length()>1) && sSearchWord.trim() != '') {
            List < List < sObject >> lDynamicSearchResult = search.query('FIND \'' + string.escapeSingleQuotes(sSearchWord) + '\' IN ALL FIELDS RETURNING Contracts__c  (id,Name,Client_Contract_Lead__c,Client_Contract_Lead__r.Name,Contract_Category__c ,Contract_Decision_Contract_Integration_D__c,Contract_Notes__c,Contract_Specific_Type__c ,Contract_Status__c,Contract_Type__c,Cost_of_this_purchase__c ' + CombineQuery('WHERE', new List < String > {
                sRegionClause, sTherapeuticAreaClause, sStatusClause, sRequestTypeClause,sBUClause
            }) + ' ORDER BY ' + sOrder +')');
            lSearchWordProjects = lDynamicSearchResult[0];
            cRequestListCntlr = new ApexPages.StandardSetController(lDynamicSearchResult[0]);
        } else {
            cRequestListCntlr = new ApexPages.StandardSetController(Database.getQueryLocator(
            'SELECT a.Client_Contract_Lead__c,Client_Contract_Lead__r.Name,a.Contract_Category__c,a.Contract_Decision_Contract_Integration_D__c,a.Name,a.Contract_Notes__c,a.Contract_Specific_Type__c,a.Contract_Status__c,a.Contract_Type__c,a.Cost_of_this_purchase__c FROM Contracts__c  a ' + CombineQuery('WHERE  ', new List < String > {
                sRegionClause, sTherapeuticAreaClause, sStatusClause,sBUClause,sRequestTypeClause
            }) + ' ORDER BY ' + sOrder));
        }

        cRequestListCntlr.setPageSize(50);
        lPageNumbers = new List < Integer > ();
        dPageCount = 0;
        dPageCount = (decimal.valueof(cRequestListCntlr.getResultSize()) / decimal.valueof(cRequestListCntlr.getPageSize()));
        dPageCount = dPageCount.round(System.RoundingMode.UP);

        for (Integer i = 1; i <= dPageCount; i++) {
            lPageNumbers.add(i);
            if (lPageNumbers.size() == pNoLimit)
                break;
        }

        for (String mCount : mCategoyCount.keyset()) {
            mCategoyCount.put(mCount, 0);
        }
        for (AggregateResult ar : database.query('SELECT count(Id),Contract_Category__c FROM Contracts__c where Contract_Category__c !=null ' + CombineQuery('AND', new List < String > {
        sRegionClause,sTherapeuticAreaClause,sSearchClause,sStatusClause,sRequestTypeClause,sBUClause
    }) + ' Group BY Contract_Category__c')) {
            mCategoyCount.put((String) ar.get('Contract_Category__c')+'TA', (Integer) ar.get('expr0'));
        }

        for (AggregateResult ar : database.query('SELECT count(Id),Contract_Specific_Type__c FROM Contracts__c where Contract_Specific_Type__c!=null ' + CombineQuery('AND', new List < String > {
        sRegionClause,sTherapeuticAreaClause,sSearchClause,sStatusClause,sRequestTypeClause,sBUClause
    }) + ' Group BY Contract_Specific_Type__c')) {
            mCategoyCount.put((String) ar.get('Contract_Specific_Type__c')+'BU', (Integer) ar.get('expr0'));
        }
        for (AggregateResult ar : database.query('SELECT count(Id),Contract_Status__c FROM Contracts__c where Contract_Status__c !=null ' + CombineQuery('AND', new List < String > {
        sRegionClause,sTherapeuticAreaClause,sSearchClause,sStatusClause,sRequestTypeClause,sBUClause
    }) + ' Group BY Contract_Status__c')) {
            mCategoyCount.put((String) ar.get('Contract_Status__c'), (Integer) ar.get('expr0'));
        }

        for (AggregateResult ar : database.query('SELECT count(Id),Contract_Type__c FROM Contracts__c where Contract_Type__c !=NULL ' + CombineQuery('AND', new List < String > {
        sRegionClause,sTherapeuticAreaClause,sSearchClause,sStatusClause,sRequestTypeClause,sBUClause
    }) + ' Group BY Contract_Type__c')) {
            mCategoyCount.put((String) ar.get('Contract_Type__c'), (Integer) ar.get('expr0'));

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
     * @Method Name                    :  FetchDataForCriteria
     * @Description                    :  This method is called upon anny action on UI to query the data base
     * @Return Type                    :  void
     * @Parameters                     :  None
     */

    public void FetchDataForCriteria() {
        Query(string.escapeSingleQuotes(sField) + ' ' + string.escapeSingleQuotes(sOrder));
    }

    /*
     * @Method Name                    :  GoToPageNumber
     * @Description                    :  This method will take user to the results on that page upon clicking any page number on pagination panel
     * @Return Type                    :  void
     * @Parameters                     :  None
     */

    Public void GoToPageNumber() {
        cRequestListCntlr.setPagenumber(iPageNumber);
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

    /*
     * @Class Name                     :  wFilterWrapper
     * @Description                    :  This is a wrapper class which holds the picklist value name and checkbox to filter out results on Requestlist Page
     */

    Public class wFilterWrapper {
        Public Boolean isSelected {
            get;
            set;
        }
        Public string label {
            get;
            set;
        }
        public wFilterWrapper(String l, Boolean isC) {
            label = l;
            isSelected = isC;
        }
    }

}