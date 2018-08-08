/****************************************************************************************************************************************** 
* Class Name   : ActivitiesList 
* Description  : Class to get the List of Activity records
* Created By   : Deloitte Consulting
* 
*****************************************************************************************************************************************/


 Public with sharing class ActivitiesList 
{

    Public ApexPages.StandardSetController cProjectListCntlr 
    {
        get;
        set;
    }
    Public string sField 
    {
        get;
        set;
    }
    Public string sSearchWord 
    {
        get;
        set;
    }
    Public string sOrder 
    {
        get;
        set;
    }
    Public string sStudyStatus{
        get;
        set;
    }
    Public Map < String, Integer > mCategoyCount 
    {
        get;
        set;
    }
    Public List < Integer > lPageNumbers 
    {
        get;
        private set;
    }
    Public Integer iPageNumber 
    {
        get;
        set;
    }
    Public Map < String, List < wActivityObject >> mStudyObjectStructure 
    {
        get;
        set;
    }
    public Integer pNoLimit 
    {
        get;
        set;
    }
    public Decimal dPageCount 
    {
        get;
        set;
    }
    public string previousSField 
    {
        get;
        set;
    }
    Public List<SelectOption> ActivityStatus{
        get;
        set;
    }
    public boolean bShowMoreFlag 
    {
        get;
        set;
    }
    public boolean bShowMoreFlag2 
    {
        get;
        set;
    }
    Public Map<Id,String> mTeamMembers
    {
        get;
        set;
    }
    Public Map<Id,String> mUserNames
    {
        get;
        set;
    }

    /* 
     * @Method Name                    :  getActivities
     * @Description                    :  Initialize cProjectListCntlr and return a list of records
     * @Return Type                    :  list of Study records
     * @Parameters                     :  None
     */
    Public List < DRDW_Proj_Activity__c > getStudies() {
        return (List < DRDW_Proj_Activity__c > ) cProjectListCntlr.getRecords();
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

    //Loading the Constructor for the Study List page     
    Public ActivitiesList() 
    {
            pNoLimit = 20;
            // Initialisation 
            sField = 'Name';
            previousSField = 'Name';
            sOrder = 'ASC NULLS FIRST';
            bShowMoreFlag= true;
            bShowMoreFlag2= true;
            mStudyObjectStructure = new Map < String, List < wActivityObject >> ();

            // Methods for call
            DescribeObjectWithDetails();
            Query(string.escapeSingleQuotes(sField) + ' ' + string.escapeSingleQuotes(sOrder));

      }
    /* 
    * @Method Name                    :  DescribeObjectWithDetails
    * @Description                    :  This method populates the filtering fields on the UI page 
    * @Return Type                    :  void
    * @Parameters                     :  None
    */ 
    Public Void DescribeObjectWithDetails() 
    {
        /*  commented out
        List < wActivityObject > lPicklist = new List < wActivityObject > ();
        mCategoyCount = new Map < String, Integer > ();

        // Not using global describe which is taking longer time, hence hardcoding the field for describe
        for (Schema.Picklistentry oPicklistValues: DRDW_Proj_Activity__c.Classification__c.getDescribe().getPicklistValues()) 
        {
            lPicklist.add(new wActivityObject(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mStudyObjectStructure.put('Classification__c', lPicklist);
        
        lPicklist = new List < wActivityObject > ();
        for (Schema.Picklistentry oPicklistValues: DRDW_Proj_Activity__c.Business_Unit__c.getDescribe().getPicklistValues()) 
        {
            lPicklist.add(new wActivityObject(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label+'BU', 0);
        }
        mStudyObjectStructure.put('Business_Unit__c', lPicklist);
        
        lPicklist = new List < wActivityObject > ();
        for (Schema.Picklistentry oPicklistValues: DRDW_Project__c.Therapeutic_Area__c.getDescribe().getPicklistValues()) 
        {
            lPicklist.add(new wActivityObject(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label+'TA', 0);
        }
        mStudyObjectStructure.put('Therapeutic_Area__c', lPicklist);

        StudyStatus = new List<SelectOption>();
        StudyStatus.add(new SelectOption('', 'All Status'));
        for (Schema.Picklistentry oPicklistValues: DRDW_Project__c.Status__c.getDescribe().getPicklistValues()) 
        {
            StudyStatus.add(new SelectOption(oPicklistValues.Label,oPicklistValues.Value));
            
        }
        mStudyObjectStructure.put('Status__c', lPicklist);
        
        lPicklist = new List < wActivityObject > ();
               
        for (Schema.Picklistentry oPicklistValues: DRDW_Project__c.Is_Molecule__c.getDescribe().getPicklistValues()) 
        {   
            lPicklist.add(new wActivityObject(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
            
        }
        mStudyObjectStructure.put('Is_Molecule__c', lPicklist);
        
        */ 

        List < wActivityObject > lPicklist = new List < wActivityObject > ();
        mCategoyCount = new Map < String, Integer > ();

        ActivityStatus = new List<SelectOption>();
        ActivityStatus.add(new SelectOption('', 'All Status'));
        for (Schema.Picklistentry oPicklistValues: DRDW_Proj_Activity__c.Status__c.getDescribe().getPicklistValues()) 
        {
            ActivityStatus.add(new SelectOption(oPicklistValues.Label,oPicklistValues.Value));
            
        }
        mStudyObjectStructure.put('Status__c', lPicklist);

    }

    /* 
    * @Method Name                    :  FrameClause
    * @Description                    :  This method constructs the query clause if check boxes are checked on UI 
    * @Return Type                    :  string
    * @Parameters                     :  List of wActivityObject
    */
    Public string FrameClause(List < wActivityObject > lWrapperForProcessing) 
    {
        String sClause = '';

        for (wActivityObject oWrapper: lWrapperForProcessing)
         {
            if (oWrapper.isSelected) 
            {
                sClause += '\'' + oWrapper.label + '\',';
            }
         }
        if (sClause != '') 
        {
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
        if (sCombineClause.size() > 0)
            return ' ' + sPrefix + ' ' + string.join(sCombineClause, ' AND ');
        return '';
    }
    
    /* 
    * @Method Name                    :  Query
    * @Description                    :  This method queries the data base and displays the results on UI 
    * @Return Type                    :  void
    * @Parameters                     :  String sOrder
    */
    Public void Query(String sOrder) 
    {
        String sTheraClause = '';
        String sResearchTypeClause = '';
        String sStatusClause = '';
        String sMoleculeTypeClause = '';
        String sSearchClause = '';
        String sBUClause = '';
        List < DRDW_Proj_Activity__c > lSearchWordProjects = new List < DRDW_Proj_Activity__c > ();
        
        if ((sSearchWord != null && sSearchWord.length() > 1 ) && sSearchWord.trim() != ''   && (lSearchWordProjects.size() > 0) ) 
        {
            sSearchClause = ' Id IN : lSearchWordProjects';
        }

        if ((sSearchWord != null && sSearchWord.length() > 1 ) && sSearchWord.trim() != '') 
        {                
            List < List < sObject >> lDynamicSearchResult = search.query('FIND \'' + string.escapeSingleQuotes(sSearchWord) + '\' IN ALL FIELDS RETURNING DRDW_Proj_Activity__c (Id,Name,Start_Date__c,End_Date__c, Status__c,Sequence__c,Parent_Project__c,Parent_Project__r.name ' + ' ORDER BY ' + sOrder +')');
            System.debug('SOSL***'+'FIND \'' + string.escapeSingleQuotes(sSearchWord) + '\' IN ALL FIELDS RETURNING DRDW_Proj_Activity__c (Id,Name,Start_Date__c,End_Date__c, Status__c,Sequence__c,Parent_Project__c,Parent_Project__r.name ' +  ' ORDER BY ' + sOrder +')');
            lSearchWordProjects = lDynamicSearchResult[0];
            cProjectListCntlr = new ApexPages.StandardSetController(lDynamicSearchResult[0]);
        } 
        else 
        {
            cProjectListCntlr = new ApexPages.StandardSetController(Database.getQueryLocator(
                'SELECT Id,Name,Start_Date__c,End_Date__c, Status__c,Sequence__c,Parent_Project__c,Parent_Project__r.name  FROM DRDW_Proj_Activity__c ' +  ' ORDER BY ' + sOrder));
                
        }

        cProjectListCntlr.setPageSize(50);
        lPageNumbers = new List < Integer > ();
        dPageCount = 0;
        dPageCount = (decimal.valueof(cProjectListCntlr.getResultSize()) / decimal.valueof(cProjectListCntlr.getPageSize()));
        dPageCount = dPageCount.round(System.RoundingMode.UP);

        for (Integer i = 1; i <= dPageCount; i++) 
        {
            lPageNumbers.add(i);
            if (lPageNumbers.size() == pNoLimit)
                break;
        }

        for (String mCount: mCategoyCount.keyset()) 
        {
            mCategoyCount.put(mCount, 0);
        }
                    
        Set<Id> sActivityIds = new Set<Id>(); 
        mTeamMembers = new Map<Id,String>();  
        for(DRDW_Proj_Activity__c oActivity : (List < DRDW_Proj_Activity__c > ) cProjectListCntlr.getRecords()){
            sActivityIds.add(oActivity.Id);
        }
        //Querying Study Team 
        /* commented out
        Map <Id, Set<Id> > mStudyTeam = new Map < Id, Set<Id> > ();
        Set<Id> sUserIds = new Set<Id>();
        For (Project__Share oShare : [Select ParentId, AccessLevel, UserOrGroupId from Project__Share where (AccessLevel = 'Edit' OR AccessLevel = 'All') and ParentId IN: sActivityIds]) {
            If(mStudyTeam.containsKey(oShare.ParentId)){
                mStudyTeam.get(oShare.ParentId).add(oShare.UserOrGroupId);
            }
            else{
                mStudyTeam.put(oShare.ParentId, new Set<Id>{oShare.UserOrGroupId});
            }
            sUserIds.add(oShare.UserOrGroupId);
        }
      
        GenerateUserNames(sUserIds);
        */
        
        /* commented out - not using Project Team members
        for(DRDW_Proj_Activity__c oActivity : (List < DRDW_Proj_Activity__c > ) cProjectListCntlr.getRecords()){
            If(mStudyTeam.containsKey(oActivity.Id)){
                String sStudyTeam = '';
                For(Id iUserId : mStudyTeam.get(oActivity.Id)){
                    If(iUserId != oActivity.OwnerId){
                        sStudyTeam = sStudyTeam +''+ String.valueOf(mUserNames.get(iUserId))+', ';
                    }
                }
                sStudyTeam = sStudyTeam.removeEnd(', ');
                mTeamMembers.put(oActivity.Id,sStudyTeam); 
            }
        }
        */
    }
    
    Public void GenerateUserNames(Set<Id> sUserIds){
        mUserNames = new Map<Id,String>();
        For(User oUser : [Select Id, Name from User where Id IN: sUserIds]){
            mUserNames.put(oUser.Id,oUser.Name);
        }
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

        Query(string.escapeSingleQuotes(sField) + ' ' + string.escapeSingleQuotes(sOrder));
    }

    /* 
    * @Method Name                    :  FetchDataForCriteria
    * @Description                    :  This method is called upon anny action on UI to query the data base
    * @Return Type                    :  void
    * @Parameters                     :  None
    */
    public void FetchDataForCriteria() 
    {
        Query(string.escapeSingleQuotes(sField) + ' ' + string.escapeSingleQuotes(sOrder));
    }


    /*
     * Method name  : GoToPageNumber
     * Description  : This method takes the user to results of that particular page on upon clicking any number on pagination panel on UI
     * Return Type  : void
     * @Parameters  : None
     */
    Public void GoToPageNumber() 
    {
        cProjectListCntlr.setPagenumber(iPageNumber);
    }

    /* 
    * @Method Name                    :  NextPageSeries
    * @Description                    :  This method takes the user to next set of pages on pagination panel on UI
    * @Return Type                    :  void
    * @Parameters                     :  None
    */
        Public void NextPageSeries() 
    {
        Integer currentLimit = lPageNumbers[lPageNumbers.size() - 1];
        lPageNumbers = new List < Integer > ();
        for (Integer i = 1; i <= pNoLimit; i++) 
        {
            if (currentLimit + i <= dPageCount) 
            {
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
    Public void PreviousPageSeries() 
    {
        Integer currentLimit = lPageNumbers[0] - pNoLimit - 1;

        lPageNumbers = new List < Integer > ();
        for (Integer i = 1; i <= pNoLimit; i++) 
        {
            lPageNumbers.add(currentLimit + i);
        }
    }

    /*
     * Class name   : wActivityObject
     * Description  : This is a wrapper class which holds the picklist value name and checkbox to filter out results on Studylist Page
     */

    Public class wActivityObject 
    {
        Public Boolean isSelected 
        {
            get;
            set;
        }
        Public string label 
        {
            get;
            set;
        }
        public wActivityObject(String l, Boolean isC) 
        {
            label = l;
            isSelected = isC;
        }
    }
}