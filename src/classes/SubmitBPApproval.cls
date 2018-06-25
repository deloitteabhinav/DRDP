/****************************************************************************************************************************************** 
 * Class Name   : SubmitBPApproval 
 * Description  : Class to Submit BP Items for Approval from List View
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
Public with sharing class SubmitBPApproval {
    Private ApexPages.StandardSetController standardController;
    Public Boolean bIsBPAdmin {
        get;
        set;
    }
    Public List < wPlanning > lwPlanning {
        get;
        set;
    }
    Public Integer ErrorCount;
    Public String sRetUrl;

    Public SubmitBPApproval(ApexPages.StandardSetController standardController) {
        this.standardController = standardController;
        ErrorCount = 0;
        sRetUrl = ApexPages.currentPage().getParameters().get('retURL');
        
        //Allowing only Admins to Access the Functionality of Submitting the BP Items for Approvals. 
        List < PermissionSetAssignment > lPermissionsetCheck = [SELECT Id, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = : userinfo.getuserID() and(PermissionSet.name like: '%Business_Admi%'
            OR PermissionSet.name like: '%RWE_Pangaea_Support%'
            OR PermissionSet.name like: '%RWE_Admin%')];
        if (lPermissionsetCheck.size() > 0) {
            bIsBPAdmin = true;
        }

        if(!Test.isRunningTest()){
        
           /* standardController.addFields(
            new list < string > {
                'Business_Planning_Approval_Status__c',
                'PM__c'
            }
            );*/
        
        }

        lwPlanning = new List < wPlanning > ();

    }
    
     /* 
     * @Method Name                    :  Submit
     * @Description                    :  Method to Submit Bp Items which match the criteria
     * @Return Type                    :  String
     * @Parameters                     :  None
     */

    Public String Submit() {

        If(bIsBPAdmin == TRUE) {
            List < Business_Planning__c > lPlanning = new List < Business_Planning__c > ();

            lPlanning = (List < Business_Planning__c > ) standardController.getSelected();

            If(lPlanning.IsEmpty()) {
                lPlanning = (List < Business_Planning__c > ) standardController.getRecords();
            }
            Set < Id > sInstanceId = new Set < Id > ();

            //Getting a list of records which are already in Approval Process
            List < ProcessInstance > lInstance = [Select TargetObjectId, Status from ProcessInstance where TargetObjectId IN: lPlanning AND Status != 'Rejected' AND Status != 'Removed'];
            For(ProcessInstance oInstance: lInstance) {
                sInstanceId.add(oInstance.TargetObjectId);
            }

            // Create an approval request for the BP
            List<Approval.ProcessSubmitRequest> lrequests = new List<Approval.ProcessSubmitRequest>();
            for (Business_Planning__c oBusiness: lPlanning) {
                if (oBusiness.Business_Planning_Approval_Status__c == 'BP Review Period' && !sInstanceId.contains(oBusiness.Id) && bIsBPAdmin == TRUE) {
                    Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                    req.setComments('Request Submitted for Approval');
                    req.setObjectId(oBusiness.Id);

                    // Submit the approval request for the BP
                    lrequests.add(req);
                }
                Else If(sInstanceId.contains(oBusiness.Id)) {
                    lwPlanning.add(new wPlanning(oBusiness, 'Record is Already in the Approval Process'));
                    ErrorCount++;
                }
                Else {
                    lwPlanning.add(new wPlanning(oBusiness, 'Cannot Submit for Approval. Criteria Not Met.'));
                    ErrorCount++;
                }
            }
            Approval.ProcessResult[] processResults = null;
            processResults = Approval.process(lrequests, false);
            for (Business_Planning__c oBusiness: lPlanning) {
                for(Integer i=0;i<processResults.size();i++){
                    if(processResults[i].getEntityId() == oBusiness.Id){
                        if(processResults[i].isSuccess()){
                            lwPlanning.add(new wPlanning(oBusiness, 'Record Successfully Submitted for Approval'));    
                        }
                        else{
                            lwPlanning.add(new wPlanning(oBusiness, 'There was an Error Submitting the Record for Approval. Please Contact your Administrator.'));
                        }
                    }
                }
            }
            If(ErrorCount == 0) {
                return sRetUrl;
            }
            Else {
                return null;
            }
        }
        Else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Only Administrators can Submit Business Planning Items for Approval.');
            ApexPages.addMessage(myMsg);
            return null;
        }
    }
    
    /* 
     * @Method Name                    :  Back
     * @Description                    :  Method to Navigate back to the List View
     * @Return Type                    :  String
     * @Parameters                     :  None
     */
    

    Public String Back() {
        return sRetUrl;
    }

    //Wrapper Class to Hold the BP Items and its errors messages.

    Public Class wPlanning {
        Public Business_Planning__c oPlanning {
            get;
            set;
        }
        Public String sMsg {
            get;
            set;
        }
        Public wPlanning(Business_Planning__c P, String M) {
            oPlanning = P;
            sMsg = M;
        }
    }
}