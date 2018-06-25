/****************************************************************************************************************************************** 
 * Class Name   : CloneBPController
 * Description  : Clones the Business Plan record only
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
Public with Sharing Class CloneBPController 
{
    Public Business_Planning__c oBPDetails {get;set;}
    List < String > sBPFields = new List < String > ();   
    
    //Loading the constructor
    public CloneBPController(ApexPages.StandardController controller) 
    {
        oBPDetails = new Business_Planning__c();
        Map < String, Schema.SObjectField > schemaFieldMap = Schema.SObjectType.Business_Planning__c.fields.getMap();               
            for (String fieldName: schemaFieldMap.keySet()) 
            {
                sBPFields.add(fieldName);
            }
            if(!test.isRunningTest())
            { 
                controller.addfields(sBPFields);
            }
        //Fetching the Current Record
        oBPDetails = (Business_Planning__c) controller.getrecord();
        
    }
    
    
/* 
* @Method Name                    :  CloneBP
* @Description                    :  This method clones the BP and its related records
* @Return Type                    :  pagereference
* @Parameters                     :  None
*/ 
    Public PageReference CloneBP() {
    
        //Cloning the Master BP Record 
        try
        {
        Business_Planning__c oBPClone = oBPDetails.clone(false,false,false,false);
        
        oBPClone.Business_Planning_Approval_Status__c='In Discussion';
        oBPClone.Lock__c = FALSE;
        oBPClone.Study__c = NULL;
        oBPClone.OwnerId = UserInfo.getUserId();
        oBPClone.Unique_Local_Identifier__c = '';
        oBPClone.Is_Approved__c=FALSE;
        oBPClone.Estimated_Start_Date__c = null;
        oBPClone.Estimated_End_Date__c = null;
        oBPClone.Initial_Anticipated_Start_Date__c = null;
        oBPClone.Approver_Comment__c = null;
        oBPClone.Actual_Start_Date__c = null;
        
        insert oBPClone;
        
        //Redirecting to the newly cloned BP record
        if(ApexPages.currentPage().getParameters().get('isVFClone')!=NULL)
            {
            PageReference pageRef = new PageReference('/apex/CreateBP?id='+oBPClone.id+'&isEdit=true');
            return pageRef;
            }
        else
            {
                PageReference pageRef = new PageReference('/'+oBPClone.id);
                return pageRef;
            }
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error, e.getmessage()));
            return null;
        }
        
    }

}