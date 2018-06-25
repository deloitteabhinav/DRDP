/******************************************************************************************************************************************
 * Class Name   : BusinessPlanning_TriggerHandler
 * Description  : Handler Class for BP Object
 * Created By   : Deloitte Consulting
 *
 *****************************************************************************************************************************************/
Public with sharing class BusinessPlanning_TriggerHandler {
    
    /*
     * @Method Name                    :  UpdateBPComments
     * @Description                    :  Method to Update the BP comments when approved / rejected
     * @Return Type                    :  void
     * @Parameters                     :  List < Business_Planning__c>
     */

    public static boolean bToUpdate = TRUE;
    Public Static Set<PermissionSetAssignment> UserPermission = new Set<PermissionSetAssignment>([SELECT PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId()]);
    Public static boolean isBpAdmin = false;  
    
    
    Public BusinessPlanning_TriggerHandler(){
        
    }
    
    public static void UpdateBPComments( Map<Id,Business_Planning__c> mNewMap) {
          
          Try{
              if(bToUpdate){
                  List<Business_Planning__c> lBPwithComments = [Select Id, Business_Planning_Approval_Status__c ,Approver_Comment__c, (Select Id, IsPending, ProcessInstanceId, TargetObjectId, StepStatus, Comments, IsDeleted, CreatedDate From ProcessSteps WHERE Comments!=null ORDER BY SystemModstamp DESC LIMIT 1) From Business_Planning__c  WHERE (Business_Planning_Approval_Status__c ='Approved' OR Business_Planning_Approval_Status__c ='Rejected') AND id IN :mNewMap.keyset()];
                  List<Business_Planning__c> lBPtoUpdate = new List<Business_Planning__c>();
                  if (lBPwithComments.size()>0)
                  {
                     for(Business_Planning__c oBP : lBPwithComments){
                     if(true){
                         if(oBP.ProcessSteps !=null && oBP.ProcessSteps.size()==1 && oBP.ProcessSteps[0].Comments!=NULL && oBP.ProcessSteps[0].Comments!=''){
                             oBP.Approver_Comment__c = oBP.ProcessSteps[0].Comments.left(255);
                             lBPtoUpdate.add(oBP);
                         }
                     }else{
                        // oBP.addError('Only BPAdmin Can update the record');
                     }
                         
                     }
                     If(!lBPtoUpdate.IsEmpty() && bToUpdate) {
                        //Flag off to disallow Recursion and Update the comments only Once for the Approved/Rejected BPs
                        bToUpdate=False;
                        Database.Update(lBPtoUpdate, False);
                     }
                  }
              }
          }
          Catch(Exception e) {
            GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(Error_Datetime__c = DateTime.Now(), Error_Message__c = e.getMessage(), Running_User__c = UserInfo.getUserId(), Stack_Trace__c = e.getStackTraceString());
            insert errlog;
        }
    }
    
    
    
    
    
    
    /*
     * @Method Name                    :  UpdateItemstoLocked
     * @Description                    :  Method to Update the BP & Study records to lock/freeze
     * @Return Type                    :  void
     * @Parameters                     :  List < Business_Planning__c>
     */

    public static void UpdateItemstoLocked(List < Business_Planning__c > lBusinessPlanning) {
        Map < Id, Project__c > mStudyMap = new Map < Id, Project__c > ();
        Map < Id, Id > mStudyPlanningIds = new Map < Id, Id > ();
        List < Project__c > lStudies = new List < Project__c > ();

        For(Business_Planning__c oPlanning: lBusinessPlanning) {
            //if SkipValidation__c is added to take snapshot and overpass any condition
            If(oPlanning.Study__c <> NULL && !oPlanning.SkipValidation__c) {
                mStudyPlanningIds.put(oPlanning.Id, oPlanning.Study__c);
            }
        }

        If(!mStudyPlanningIds.IsEmpty()) {
            mStudyMap = new Map < Id, Project__c > ([Select Id, Study_Lock__c, (Select Id, Lock__c from RWE_Business_Plannings__r where Id IN: mStudyPlanningIds.Keyset()) from Project__c where Id IN: mStudyPlanningIds.values()]);
        }

        If(!mStudyMap.IsEmpty()) {
            For(Business_Planning__c oPlanning: lBusinessPlanning) {
                Project__c oProject = mStudyMap.get(oPlanning.Study__c);
                If(oProject != NULL) {
                    If(oProject.Study_Lock__c != oPlanning.Lock__c) {
                        oProject.Study_Lock__c = oPlanning.Lock__c;
                        lStudies.add(oProject);
                    }
                }
            }
        }


        If(!lStudies.IsEmpty()) {
            Database.Update(lStudies, False);
        }
    }
    
    /*
    * @Method Name                    :  UpdateSkipValidationtoFalse
    * @Description                    :  Method to Update SkipValidation Field in BP to False
    * @Return Type                    :  void
    * @Parameters                     :  List < Business_Planning__c>
    */
    public static void UpdateSkipValidationtoFalse(List < Business_Planning__c > lBusinessPlanning) {
        List<Business_Planning__c> lBPstoUpdate = new List<Business_Planning__c>();
        for(Business_Planning__c oPlanning : [select id,SkipValidation__c from Business_Planning__c Where id in :lBusinessPlanning AND SkipValidation__c = TRUE]){
            oPlanning.SkipValidation__c = false;
            lBPstoUpdate.add(oPlanning);
        } 
        if(!lBPstoUpdate.IsEmpty()) {
            Database.Update(lBPstoUpdate, false);
        }       
    }
    
    /*
    * @Method Name                    :  ValidAnticipatedEndDate
    * @Description                    :  Method to Valid Anticipated End Date with Forecast Date of Payment
    * @Return Type                    :  void
    * @Parameters                     :  List < Business_Planning__c>
    */
    public static void ValidAnticipatedEndDate(List < Business_Planning__c > lBusinessPlanning) {
        Set<Id> BpID = new Set<Id>();
        List<Operational_Tracking__c> lOperational = new List<Operational_Tracking__c>();
        for(Business_Planning__c lBP : lBusinessPlanning){
            BpID.add(lBP.Id);
        }
        
        lOperational.addAll([Select Business_Planning_ID__c,Estimated_Date_of_payment__c from Operational_Tracking__c where Business_Planning_ID__c IN: BpID]);
        
        if(!lOperational.isEmpty()){
            for(Business_Planning__c lBP : lBusinessPlanning){
                for(Operational_Tracking__c lOptTrac : lOperational){
                    IF(lBP.Estimated_End_Date__c < lOptTrac.Estimated_Date_of_payment__c){
                           lBP.addError('Milestones cannot have a date that is after the Anticipated End Date of the Study.  Please update the Anticipated End Date of the study/project to a later date.');
                    }
                }
            }
         }        
    }
    
    Public Static void giveError(List < Business_Planning__c > lBusinessPlanning){
            For(PermissionSetAssignment pa : UserPermission){
                if(pa.PermissionSet.Name == 'Business_Admin'){
                    isBpAdmin = true;
                }
            }
            
          For(Business_Planning__c bp :lBusinessPlanning){
              
              if(bp.Business_Planning_Approval_Status__c != 'Draft' &&  bp.Business_Planning_Approval_Status__c != 'In Process' && (bp.Business_Planning_Approval_Status__c !='Submitted for BP Approval' || !bp.isEdit__c) && !isBpAdmin){
                  bp.addError('Update Failed. Business Planning record is Locked. Please contact your Administrator.');
              }
          }   
    }

    /*
    * @Method Name                    :  UpdateFields
    * @Description                    :  Method to Update Fields on Bp
    * @Return Type                    :  void
    * @Parameters                     :  List < Business_Planning__c>
    */
    Public Static void UpdateFields(List < Business_Planning__c > lBusinessPlanning){
        Id Userid = UserInfo.getUserId();
        
         For(PermissionSetAssignment pa : UserPermission){
                if(pa.PermissionSet.Name == 'Business_Admin'){
                    isBpAdmin = true;
                }
            }
        
            For(Business_Planning__c bp :lBusinessPlanning){
                If(bp.Business_Planning_Approval_Status__c == 'Draft'){
                    bp.Business_Planning_Approval_Status__c = 'In Process'; 
                    bp.BPType__c = 'Study'; 
                    
                }else if(isBpAdmin && bp.Business_Planning_Approval_Status__c == 'Submitted for BP Approval' && !bp.IsSubmit__c){
                    
                    bp.Business_Planning_Approval_Status__c = 'In Review';
                    
                }else if(isBpAdmin && bp.Business_Planning_Approval_Status__c == 'Submitted for BP session' && !bp.IsSubmit__c){
                    bp.Business_Planning_Approval_Status__c = 'BP review in process';
                   
                }
                    //bp.addError('Update Failed. Business Planning record is Locked. Please contact your Administrator.');
                
                if(bp.Business_Planning_Approval_Status__c == 'Submitted for BP Approval' && !bp.IsSubmit__c){
                    bp.isEdit__c = false;
                }
               
                
                 bp.IsSubmit__c = false;
                 
            }
    }
    
    /*
    * @Method Name                    :  SyncFromBpToStudy
    * @Description                    :  Method to Sync Fields Between Study and Bp
    * @Return Type                    :  void
    * @Parameters                     :  List < Business_Planning__c>
    */

    public static void SyncFromBpToStudy(List < Business_Planning__c > lBusinessPlanning) {
        Map < Id, Project__c > mStudyMap = new Map < Id, Project__c > ();
        Map < Id, Id > mStudyPlanningIds = new Map < Id, Id > ();
        List < Project__c > lStudies = new List < Project__c > ();

        For(Business_Planning__c oPlanning: lBusinessPlanning) {
            //if SkipValidation__c is added to take snapshot and overpass any condition
            If(oPlanning.Study__c <> NULL && !oPlanning.SkipValidation__c) {
                mStudyPlanningIds.put(oPlanning.Id, oPlanning.Study__c);
            }
        }


        If(!mStudyPlanningIds.IsEmpty()) {
            mStudyMap = new Map < Id, Project__c > ([Select Id
       , OwnerId, Will_HCPs_be_paid_for_participation__c, Study_Description__c ,Anticipated_Start_Date__c, Actual_Start_Date__c, 
            Project_Manager__c, 
      /* GPORWE_Functional_Area__c, Therapeutic_Area_Primary__c, Execution_Function__c, Business_Unit_Primary__c, Name, Secondary_Study_Type__c, Study_Source_ID__c, Anticipated_End_Date__c, 
            Execution_Resource__c, Study_Region__c, Teritiary_Study_Type__c, Primary_Value_Area__c , Study_Title_Short__c, Description__c, 
            Disease_State__c, Indication__c , Business_Critical_Rationale__c ,Target_Audience__c,Approver_Table__c,Primary_Purpose__c, Other_Sub_Function__c,Study_conducte4d_with_an_RWE_Partner__c, TPO_Location__c, 
            RWE_Partnership_Execution_Resource__c, Status_Information__c,*/
      
      (Select Id from RWE_Business_Plannings__r where Id IN: mStudyPlanningIds.Keyset()) from Project__c where Id IN: mStudyPlanningIds.values()]);
        }

        If(!mStudyMap.IsEmpty()) {
            For(Business_Planning__c oPlanning: lBusinessPlanning) {
                Project__c oProject = mStudyMap.get(oPlanning.Study__c);
                 If(oProject != NULL) {
                    If(oPlanning.Study__c == oProject.id && (oProject.Study_Project_ID__c == oPlanning.Name || oProject.Name == oPlanning.Title__c || oProject.Description__c == oPlanning.Description__c||oProject.Notes_Log__c == oPlanning.Notes__c|| oProject.Business_Unit_Primary__c == oPlanning.Business_Unit_Primary__c|| oProject.Therapeutic_Area_Primary__c == oPlanning.Therapeutic_Area_Primary__c|| oProject.Execution_Function__c == oPlanning.Executing_Function__c || oProject.Project_Manager__c == oPlanning.PM__c || oProject.Approver_Table__c == oPlanning.Approver_Table__c|| oProject.Execution_Function__c == oPlanning.Executing_Function__c|| oProject.Anticipated_Start_Date__c == oPlanning.Estimated_Start_Date__c||  oProject.Actual_Start_Date__c == oPlanning.Actual_Start_Date__c || oProject.Anticipated_End_Date__c == oPlanning.Estimated_End_Date__c)) {
                        oProject.Name = oPlanning.Title__c;
                        oProject.Description__c = oPlanning.Description__c;
                        oProject.Notes_Log__c = oPlanning.Notes__c;
                        oProject.Business_Unit_Primary__c = oPlanning.Business_Unit_Primary__c;
                        oProject.Therapeutic_Area_Primary__c = oPlanning.Therapeutic_Area_Primary__c;
                        oProject.Execution_Function__c = oPlanning.Executing_Function__c;
                        oProject.Project_Manager__c = oPlanning.PM__c;
                        oProject.Approver_Table__c = oPlanning.Approver_Table__c;
                        oProject.Execution_Function__c = oPlanning.Executing_Function__c;
                        oProject.Anticipated_Start_Date__c = oPlanning.Estimated_Start_Date__c;
                        oProject.Actual_Start_Date__c = oPlanning.Actual_Start_Date__c;
                        oProject.Anticipated_End_Date__c = oPlanning.Estimated_End_Date__c;
                     /*   oProject.Teritiary_Study_Type__c = oPlanning.Observational_Study_Details__c;
                        oProject.Primary_Value_Area__c = oPlanning.Primary_Value_Area__c;
                        oProject.Study_Title_Short__c = oPlanning.Title__c;
                        oProject.Description__c = oPlanning.Description__c;
                        oProject.Disease_State__c = oPlanning.Disease_State__c;
                        oProject.Target_Audience__c = oPlanning.Target_Audience__c;
                        oProject.Approver_Table__c = oPlanning.Approver_Table__c;
                        oProject.Primary_Purpose__c = oPlanning.Primary_Purpose__c; 
                        oProject.Other_Sub_Function__c = oPlanning.Other_Sub_Function__c;
                        oProject.Business_Critical_Rationale__c = oPlanning.Business_Critical_Rationale__c;
                        oProject.Indication__c = oPlanning.Indication__c;
                        oProject.Study_conducte4d_with_an_RWE_Partner__c = oPlanning.Conducted_with_an_RWE_partner__c; 
                        oProject.TPO_Location__c = oPlanning.Proposed_TPO__c; 
                        oProject.RWE_Partnership_Execution_Resource__c = oPlanning.RWE_Partner__c; 
                        oProject.Status_Information__c = oPlanning.Status_Information__c;
                        oProject.OwnerId = oPlanning.OwnerId;
                        If(oProject.Study_Description__c != oPlanning.Study_Type__c){
                        oProject.Study_Description__c = oPlanning.Study_Type__c;
                        oProject.Study_Stage__c = '';*/
                        }
            
                        lStudies.add(oProject);
                    }
                } 
            }        
    
        If(!lStudies.IsEmpty()) {
            Database.Update(lStudies, False);
        }
    }

    /*
     * @Method Name                    :  SyncIndiactionsonForecasts
     * @Description                    :  Method to Sync Operation Related List when Indications Values are changed
     * @Return Type                    :  void
     * @Parameters                     :  List < Business_Planning__c>, Map<Id,Business_Planning__c>
     */

    public static void SyncIndiactionsonForecasts(List < Business_Planning__c > lBusinessPlanning, Map < Id, Business_Planning__c > mBusinessPlanning) {

        Try {

            Set < Id > sPlanningIds = new Set < Id > ();

            For(Business_Planning__c oPlanning: lBusinessPlanning) {
                //if SkipValidation__c is added to take snapshot and overpass any condition
                If((oPlanning.Indication__c != mBusinessPlanning.get(oPlanning.Id).Indication__c) && !oPlanning.SkipValidation__c) {
                    sPlanningIds.add(oPlanning.Id);
                }
            }

            List < Operational_Tracking__c > lTracking = new List < Operational_Tracking__c > ();
            If(!sPlanningIds.IsEmpty()) {
                lTracking = [Select Id from Operational_Tracking__c where Business_Planning_ID__r.Id IN: sPlanningIds];
            }

            List < Business_Planning_Estimate__c > lForecasts = new List < Business_Planning_Estimate__c > ();
            If(!sPlanningIds.IsEmpty()) {
                lForecasts = [Select Id from Business_Planning_Estimate__c where Business_Planning_ID__r.Id IN: sPlanningIds];
            }

            If(!lTracking.IsEmpty()) {
                Update lTracking;
            }

            If(!lForecasts.IsEmpty()) {
                For(Business_Planning_Estimate__c oEstimate: lForecasts){
                    oEstimate.Skip_Validation__c = True;
                }
                Update lForecasts;
            }
        }

        Catch(Exception e) {
            GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(Error_Datetime__c = DateTime.Now(), Error_Message__c = e.getMessage(), Running_User__c = UserInfo.getUserId(), Stack_Trace__c = e.getStackTraceString());
            insert errlog;
        }

    }

    /*
     * @Method Name                    :  DeleteStudyWithBp
     * @Description                    :  Method to Delete Associated Study When a BP is Deleted
     * @Return Type                    :  void
     * @Parameters                     :  List < Business_Planning__c>
     */

    public static void DeleteStudyWithBp(List < Business_Planning__c > lBusinessPlanning) {

        Try {
            List < Project__c > lProjects = new List < Project__c > ();
            Set < Id > sProjectIds = new Set < Id > ();

            For(Business_Planning__c oPlanning: lBusinessPlanning) {
                sProjectIds.add(oPlanning.Study__c);
            }

            lProjects = [Select Id from Project__c where Id IN: sProjectIds];

            Delete lProjects;
        }

        Catch(Exception e) {
            GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(Error_Datetime__c = DateTime.Now(), Error_Message__c = e.getMessage(), Running_User__c = UserInfo.getUserId(), Stack_Trace__c = e.getStackTraceString());
            insert errlog;
        }

    }

    //This class is made to enforce without sharing method
    Public without sharing class CopyApproverPMClass {

        /*
         * @Method Name                    :  CopyApproverPM
         * @Description                    :  Method to add Approver and PM to Sharing Table
         * @Return Type                    :  void
         * @Parameters                     :  lBusinessPlanning
         */

        Public void CopyApproverPM(List < Business_Planning__c > lBusinessPlanning) {
            Map < Id, Set < Id >> mCurrentSharingForBp = new Map < Id, Set < Id >> ();
            Map < Id, Set < Id >> mApproversInBp = new Map < Id, Set < Id >> ();
            List < Business_Planning__Share > lShare = new List < Business_Planning__Share > ();

            for (Business_Planning__Share oShare : [Select ParentId, AccessLevel, UserOrGroupId from Business_Planning__Share where ParentId IN: lBusinessPlanning AND(AccessLevel = 'Edit'
                    OR AccessLevel = 'All')]) {
                if (!mCurrentSharingForBp.containsKey(oShare.ParentId)) {
                    mCurrentSharingForBp.put(oShare.ParentId, new Set < id > {
                        oShare.UserOrGroupId
                    });
                } else {
                    mCurrentSharingForBp.get(oShare.ParentId).add(oShare.UserOrGroupId);
                }

            }
            for (Business_Planning__c oPlanning : lBusinessPlanning) {
                //if SkipValidation__c is added to take snapshot and overpass any condition
                if(!oPlanning.SkipValidation__c){
                    mApproversInBp.put(oPlanning.Id, new set < Id > ());
                    if ((oPlanning.Approver__c != NULL && (!mCurrentSharingForBp.containsKey(oPlanning.Id) || !mCurrentSharingForBp.get(oPlanning.Id).contains(oPlanning.Approver__c))) && oPlanning.Approver__c != oPlanning.Ownerid) {
                        mApproversInBp.get(oPlanning.Id).add(oPlanning.Approver__c);
                    }
                    if ((oPlanning.PM__c != NULL && (!mCurrentSharingForBp.containsKey(oPlanning.Id) || !mCurrentSharingForBp.get(oPlanning.Id).contains(oPlanning.PM__c))) && oPlanning.PM__c != oPlanning.Ownerid) {
                        mApproversInBp.get(oPlanning.Id).add(oPlanning.PM__c);
                    }
                }
            }


            for (Id oShare : mApproversInBp.keyset()) {
                for (Id sId : mApproversInBp.get(oShare)) {
                    Business_Planning__Share oBpShare = new Business_Planning__Share();
                    oBpShare.UserOrGroupId = sId;
                    oBpShare.AccessLevel = 'Edit';
                    oBpShare.ParentId = oShare;
                    lShare.add(oBpShare);
                }
            }

            If(!lShare.IsEmpty()) {
                database.insert(lShare, true);
            }


        }
    }

    // This class is made to enforce without sharing method
    Public without sharing class RemoveApprovePMClass {


        /*
         * @Method Name                    :  RemoveApproverPM
         * @Description                    :  Method to Remove Approver and PM to Sharing Table
         * @Return Type                    :  void
         * @Parameters                     :  lBusinessPlanning,mBusinessPlanning
         */
        Public void RemoveApproverPM(List < Business_Planning__c > lPlanning, Map < Id, Business_Planning__c > mBusinessPlanning) {

            Map < Id, Set < id >> mApproverPMtoRemove = new Map < id, Set < id >> ();
            Map < Id, Set < Id >> mCurrentSharingForStudies = new Map < Id, Set < Id >> ();
            Set < Id > lProject = new Set < Id > ();

            for (Business_Planning__c oPlanning : lPlanning) {
                //if SkipValidation__c is added to take snapshot and overpass any condition
                If(oPlanning.Study__c != NULL && !oPlanning.SkipValidation__c) {
                    lProject.add(oPlanning.Study__c);
                }
            }

            for (Project__Share oShare : [Select ParentId, AccessLevel, UserOrGroupId from Project__Share where ParentId IN: lProject AND(AccessLevel = 'Edit'
                                               OR AccessLevel = 'All')]) {
                if (!mCurrentSharingForStudies.containsKey(oShare.ParentId)) {
                    mCurrentSharingForStudies.put(oShare.ParentId, new Set < id > {
                        oShare.UserOrGroupId
                    });
                } else {
                    mCurrentSharingForStudies.get(oShare.ParentId).add(oShare.UserOrGroupId);
                }
            }

            For(Business_Planning__c oPlanning: lPlanning) {
                //if SkipValidation__c is added to take snapshot and overpass any condition
                if(!oPlanning.SkipValidation__c){
                    Business_Planning__c oldPlanning = mBusinessPlanning.get(oPlanning.id);
                    If(oldPlanning.Approver__c != oPlanning.Approver__c && oldPlanning.Approver__c != oPlanning.PM__c && oPlanning.Study__c != NULL) {
                        if (!mCurrentSharingForStudies.get(oPlanning.Study__c).contains(oldPlanning.Approver__c)) {
                            If(!mApproverPMtoRemove.containsKey(oldPlanning.id)) {
                                mApproverPMtoRemove.put(oldPlanning.id, new Set < id > {
                                    oldPlanning.Approver__c
                                });
                            }
                            else {
                                mApproverPMtoRemove.get(oldPlanning.id).add(oldPlanning.Approver__c);
                            }
                        }
                    }
                    If(oldPlanning.Approver__c != oPlanning.Approver__c && oldPlanning.Approver__c != oPlanning.PM__c && oPlanning.Study__c == NULL) {
                        if (!mApproverPMtoRemove.containsKey(oldPlanning.id)) {
                            mApproverPMtoRemove.put(oldPlanning.id, new Set < id > {
                                oldPlanning.Approver__c
                            });
                        } else {
                            mApproverPMtoRemove.get(oldPlanning.id).add(oldPlanning.Approver__c);
                        }
                    }
                    If(oldPlanning.PM__c != oPlanning.Approver__c && oldPlanning.PM__c != oPlanning.PM__c && oPlanning.Study__c != NULL) {
                        If(!mCurrentSharingForStudies.get(oPlanning.Study__c).contains(oldPlanning.PM__c)) {
                            if (!mApproverPMtoRemove.containsKey(oldPlanning.id)) {
                                mApproverPMtoRemove.put(oldPlanning.id, new Set < id > {
                                    oldPlanning.PM__c
                                });
                            } else {
                                mApproverPMtoRemove.get(oldPlanning.id).add(oldPlanning.PM__c);
                            }
                        }
                    }
                    If(oldPlanning.PM__c != oPlanning.Approver__c && oldPlanning.PM__c != oPlanning.PM__c && oPlanning.Study__c == NULL) {
                        if (!mApproverPMtoRemove.containsKey(oldPlanning.id)) {
                            mApproverPMtoRemove.put(oldPlanning.id, new Set < id > {
                                oldPlanning.PM__c
                            });
                        } else {
                            mApproverPMtoRemove.get(oldPlanning.id).add(oldPlanning.PM__c);
                        }
                    }
                }
            }
            List < Business_Planning__Share > lShareToDelete = new List < Business_Planning__Share > ();
            List < Business_Planning__Share > lShare = new List < Business_Planning__Share > ();
            lShare = [Select ParentId, AccessLevel, UserOrGroupId from Business_Planning__Share where ParentId IN: mBusinessPlanning.KeySet() AND AccessLevel = 'Edit'];
            If(!mApproverPMtoRemove.IsEmpty() && !lShare.IsEmpty()) {
                For(Business_Planning__Share oShare: lShare) {
                    If(mApproverPMtoRemove.containsKey(oShare.ParentId) && mApproverPMtoRemove.get(oShare.ParentId).contains(oShare.UserOrGroupId)) {
                        lShareToDelete.add(oShare);
                    }
                }
            }

            If(!lShareToDelete.IsEmpty()) {
                Database.delete(lShareToDelete, false);
            }
        }
    }

    /*
     * @Method Name                    :  CreateBusinessEstimates
     * @Description                    :  Method to create Business Estimate Records when BP is created(used in Process Builder)
     * @Return Type                    :  void
     * @Parameters                     :  lBusinessPlanning
     */
    @InvocableMethod()
    public static void CreateBusinessEstimates(List < Business_Planning__c > lBusinessPlanning) {
        List < Business_Planning_Estimate__c > lBusinessPlanningEstimate = new List < Business_Planning_Estimate__c > ();
        Set < id > sCurrentEstimateRecords = new Set < Id > ();

        //Loop through the years and create records for quaters
        If(!lBusinessPlanning.IsEmpty()) {
            for (Business_Planning__c oBusinessPlanning : lBusinessPlanning) {
                Decimal StartDate = (oBusinessPlanning.Estimated_Start_Date__c.month() / 3.00).round(System.RoundingMode.Up);
                Integer iYearsBetween = oBusinessPlanning.Estimated_End_Date__c.year() - oBusinessPlanning.Estimated_Start_Date__c.year();
                Decimal EndDate = ((oBusinessPlanning.Estimated_End_Date__c.month() + (12 * iYearsBetween)) / 3.00).round(System.RoundingMode.Up);
                String sQuarter = 'Q' + String.valueof(EndDate - StartDate + 1);
                Map < Decimal, Decimal > mFormula = new Map < Decimal, Decimal > ();
                If((EndDate - StartDate + 1) < 10) {
                    BPFormulas__c oFormula = BPFormulas__c.getInstance(sQuarter);
                    mFormula.put(0, oFormula.Q1__c);
                    mFormula.put(1, oFormula.Q2__c);
                    mFormula.put(2, oFormula.Q3__c);
                    mFormula.put(3, oFormula.Q4__c);
                    mFormula.put(4, oFormula.Q5__c);
                    mFormula.put(5, oFormula.Q6__c);
                    mFormula.put(6, oFormula.Q7__c);
                    mFormula.put(7, oFormula.Q8__c);
                    mFormula.put(8, oFormula.Q9__c);
                }
                for (integer i = 0; i <= (EndDate - StartDate); i++) {
                    Business_Planning_Estimate__c oEstimate = new Business_Planning_Estimate__c();
                    oEstimate.Business_Planning_ID__c = oBusinessPlanning.Id;
                    Date dEstimateDate;
                    Decimal dEstimateAmount;
                    if (i == 0) {
                        dEstimateDate = oBusinessPlanning.Estimated_Start_Date__c;
                    } else if (i == (EndDate - StartDate)) {
                        dEstimateDate = oBusinessPlanning.Estimated_End_Date__c;
                    } else {
                        dEstimateDate = date.newinstance(oBusinessPlanning.Estimated_Start_Date__c.year(), ((Integer.valueof(StartDate) + i) * 3) - 2, 1);
                    }
                    oEstimate.Estimate_Date__c = dEstimateDate;
                    //Defaulting Amount to ZERO as Auto-Distribute should not work upon creation
                    oEstimate.Estimate_Amount__c = 0;
                    lBusinessPlanningEstimate.add(oEstimate);
                }
                sCurrentEstimateRecords.add(oBusinessPlanning.Id);
            }
        }

        //Delete existing records
        If(!sCurrentEstimateRecords.IsEmpty()) {
            Delete[Select id from Business_Planning_Estimate__c where Business_Planning_ID__c in : sCurrentEstimateRecords];
        }

        If(!lBusinessPlanningEstimate.IsEmpty()) {
            Database.insert(lBusinessPlanningEstimate, true);
        }
    }
    
    
     //this class is made to send an email alert to pm/owner
     Public Static void SendEmail(List<Business_Planning__c> lBusinessPlanning){
         List<Id> lPMOwnerId = new List<id>();
         Map<Id,set<Id>> mBpUserId = new Map<Id,set<Id>>();
         List<Messaging.SingleEmailMessage> lmail = new list<Messaging.SingleEmailMessage>();
         For(Business_Planning__c bp : lBusinessPlanning){
             if(bp.Business_Planning_Approval_Status__c != 'Draft'){
                 if(mBpUserId.containsKey(bp.Id)){
                     mBpUserId.get(bp.Id).Add(bp.OwnerId);
                     mBpUserId.get(bp.Id).Add(bp.PM__c);
                 }else{
                      mBpUserId.put(bp.Id,new Set<Id>{bp.OwnerId,bp.PM__c});
                 }
             }    
         }
         
         Id emailTemplateID = [Select Id,Name from EmailTemplate where Name = 'DRDP BP Change Status' Limit 1].id ;
         
         For(Business_Planning__c bp : lBusinessPlanning){
             Set<Id> UserId = new Set<Id>();
             if(mBpUserId.containsKey(bp.Id)){
             }
             if(bp.Business_Planning_Approval_Status__c != 'Approved' && bp.Business_Planning_Approval_Status__c != 'Rejected' && bp.Business_Planning_Approval_Status__c != 'Cancelled'){
                 UserId.addAll(mBpUserId.get(bp.Id));
                 For(Id uId : UserId){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTargetObjectId(uId);
                    mail.setOrgWideEmailAddressId('0D246000000PE5a');
                    mail.setSaveAsActivity(false);
                    mail.setSubject('Business Planning with Id '+bp.Name+' Updates');
                    mail.setHtmlBody('<p>Hi,<br/><br/>Your Business Planning with '+bp.Name+' Id, is being updated to '+bp.Business_Planning_Approval_Status__c+' <br/> <br/> <br/>Regards.');
                    //mail.setTemplateId(emailTemplateID);
                    //mail.setWhatId(bpId);
                    lmail.add(mail);
                 }
                 
             }
             
         }
         
         Messaging.sendEmail(lmail);
                 
     }
   
    /*
     * @Method Name                    :  restrictPMUser
     * @Description                    :  Method to create restrict user selection based on permissionSet
     * @Return Type                    :  void
     * @Parameters                     :  lBusinessPlanning,oldBusinessPlanning
     */
     
     Public static void restrictPMUser(List < Business_Planning__c > lBusinessPlanning, List < Business_Planning__c > oldBusinessPlanning){
        try {     
            Set<Id> sUserPermission = new Set<Id>();
            for(PermissionSet userids : [SELECT Name, (SELECT AssigneeId FROM Assignments) FROM PermissionSet WHERE PermissionSet.Name = 'RWE_BP_Admin' OR PermissionSet.Name = 'RWE_Pangaea_Support_Team']){
                for(PermissionSetAssignment oAssign : userIds.Assignments){
                    sUserPermission.add(oAssign.AssigneeId);
                }    
            }
            for(Business_Planning__c BpRecords : lBusinessPlanning){
                //if SkipValidation__c is added to take snapshot and overpass any condition
                if(!BpRecords.SkipValidation__c){
                if((BpRecords.PM__c !=NULL)){
                    if(!oldBusinessPlanning.isEmpty()){
                        for(Business_Planning__c oldBpRecord : oldBusinessPlanning){
                            if(BpRecords.PM__c !=oldBpRecord.PM__c && !sUserPermission.contains(BpRecords.PM__c) && BpRecords.Id == oldBpRecord.Id){
                                BpRecords.IsPMError__c = TRUE;
                            }
                        }
                    }
                    else{
                        if(!sUserPermission.contains(BpRecords.PM__c)){
                            BpRecords.IsPMError__c = TRUE;
                        }
                    }
                }
            }
           }
        }
        catch(Exception e) {
            GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(Error_Datetime__c = DateTime.Now(), Error_Message__c = e.getMessage(), Running_User__c = UserInfo.getUserId(), Stack_Trace__c = e.getStackTraceString());
            insert errlog;
        }
     }
     
     

    // This class is made to enforce without sharing method
    Public without sharing class CopyApproverTable {

        /*
         * @Method Name                    :  CopyApproverTable
         * @Description                    :  Method to Copy Approver ID field to the BP Record
         * @Return Type                    :  void
         * @Parameters                     :  lBusinessPlanning
         */

        Public void CopyApproverTable(List < Business_Planning__c > lBusinessPlanning) {
            Map < Id, Id > mApproverTable = new Map < Id, Id > ();

            for (Approver__c oApprover : [Select id, Approver__c from Approver__c limit 10000]) {
                mApproverTable.put(oApprover.Id, oApprover.Approver__c);
            }

            for (Business_Planning__c oPlanning : lBusinessPlanning) {
                //if SkipValidation__c is added to take snapshot and overpass any condition
                if (oPlanning.Approver_Table__c != oPlanning.Approver__c && mApproverTable.containskey(oPlanning.Approver_Table__c) && !oPlanning.SkipValidation__c) {
                    oPlanning.Approver__c = mApproverTable.get(oPlanning.Approver_Table__c);
                } else
                    oPlanning.Approver__c = null;
            }

        }

    }
}