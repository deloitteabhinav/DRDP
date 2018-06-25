Public class BPFieldChanges{
    
    Public Set<PermissionSetAssignment> UserPermission = new Set<PermissionSetAssignment>();

    public BPFieldChanges(ApexPages.StandardController controller) {
        UserPermission = new Set<PermissionSetAssignment>([SELECT PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId()]);
    }

    
    Public pageReference changeStatusOnSubmit(){
        Id UserId = UserInfo.getUserId();  
        Id BpID = ApexPages.currentPage().getParameters().get('Id');
        boolean isBpAdmin = false;  
        
        For(PermissionSetAssignment pa : UserPermission){
            if(pa.PermissionSet.Name == 'Business_Admin'){
                isBpAdmin = true;
            }
        }
        
        Business_Planning__c bp = new Business_Planning__c();
        bp = [Select id,Business_Planning_Approval_Status__c,OwnerId,PM__c From Business_Planning__c where Id=:BpID Limit 1];
        
        If(bp.Business_Planning_Approval_Status__c =='In Process'){
            bp.Business_Planning_Approval_Status__c ='Submitted for BP Approval';
            bp.IsSubmit__c = true;
           // bp.IsEmail__c=true;
            update bp;
        }else if(isBpAdmin && bp.Business_Planning_Approval_Status__c =='In Review'){
            bp.Business_Planning_Approval_Status__c ='Submitted for BP session';
            bp.IsSubmit__c = true;
            //bp.IsEmail__c=true;
            update bp;
            
        }else if(isBpAdmin && bp.Business_Planning_Approval_Status__c =='BP review in process'){
            List<Business_Planning__c> lBp = new List<Business_Planning__c>();
            bp.Business_Planning_Approval_Status__c = 'BP Review Period';
            //bp.IsEmail__c=false;
            update bp;
            
            lBp.add(bp);
            
            ApexPages.StandardSetController sc = new ApexPages.StandardSetController(lBp);        
            SubmitBPApproval submitBp = new SubmitBPApproval(sc);
            submitBp.Submit();
            //bp.Lock__c=true;
        }
        
        return new pageReference('/'+BpID);
    }
    
}