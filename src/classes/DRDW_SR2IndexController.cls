Public class DRDW_SR2IndexController{

    Public List<DRDW_Configuration__c> lHomeTabs{get;set;}
    Public String HomeHeader1{get;set;}
    Public String HomeHeader2{get;set;}
    public String demo{get;set;}
    public String demo1{get;set;}
    public boolean isAdmin{get;set;}
    public String research{get;set;}
    public String admin{get;set;}
    public String budget{get;set;}
    Public String capacity{get;set;}
    Public set<String> PSAssigned{get;set;} 
    Public Boolean showGOPage{get;set;}
    public boolean hidecapacityTab{get;set;}
       
    Public DRDW_SR2IndexController(){
   
        GetHeaderImage();
        HomeTabs();
        isAdmin =  getUserPermission(UserInfo.getUserId());
        permissionSetAssigned();
        research = '/apex/DRDW_PlanResearch-/apex/DRDW_ResearchList-/apex/DRDW_SelectCreateEvaluationPrj-/apex/DRDW_CreateIdea-/apex/DRDW_CreateGeneration-/apex/DRDW_SelectCreateAssessment-/apex/DRDW_CreateAssessment-/apex/DRDW_CreateNewIdea-/apex/DRDW_CreateIdeaCapability-/apex/DRDW_CreateRisk-/apex/DRDW_CreateProjectCapability';
       admin ='/apex/DRDW_BusinessAdmin-/apex/DRDW_CycleTime-/apex/DRDW_AddPicklists-/apex/DRDW_CostCenterinfo-/apex/DRDW_CostCenter-/apex/DRDW_NonDiscretionary-/apex/DRDW_CreateNDBudgetMaster-/apex/DRDW_Discretionary-/apex/DRDW_ResourceList-/apex/DRDW_CreateResource';
        capacity='/apex/DRDW_ERLView-/apex/DRDW_ViewActivity-/apex/DRDW_CreateERLRequest';
        budget = '/apex/DRDW_CreateBudgetMaster-/apex/DRDW_CreateBudgetLineItem-apex/DRDW_CreateBudgetSummaryinfo-/apex/DRDW_CreateBudgetSummaryDetail-/apex/DRDW_BudgetReport-/apex/DRDW_BudgetCostCenterReport-/apex/DRDW_SaveBudgetLine-/apex/DRDW_DataLoad';
    }
    
    Public Void GetHeaderImage(){
        HomeHeader1 = '/servlet/servlet.FileDownload?file=';
        HomeHeader2 = '/servlet/servlet.FileDownload?file=';
        
        List< document > documentList=[select id,name from document where Name IN ('DRDW Home Header Client logo','DRDW Home Header logo')];
    
        For(Document d:documentList)
        {
           if(d.Name == 'DRDW Home Header logo'){
               HomeHeader1 = HomeHeader1 +d.id;
           }else if(d.Name == 'DRDW Home Header Client logo'){
               HomeHeader2 = HomeHeader2 + d.id;
           }
        }
      
        
    }
    
    Public void HomeTabs(){
        lHomeTabs = new List<DRDW_Configuration__c>([Select Value__c,URL__c,Tab_Sequence__c,Display__c from DRDW_Configuration__c where Display__c=true AND RecordType.Name = 'Tabs' ORDER BY Tab_Sequence__c]);
    }
    
     Public Boolean getUserPermission(Id UserID){
            List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserID AND ((PermissionSet.Name = 'DRDW_Business_Admin') OR (PermissionSet.Name = 'DRDW_Financial_User') OR (PermissionSet.Name = 'DRDW_Functional_Head') OR (PermissionSet.Name = 'DRDW_ERL_Head') OR ( PermissionSet.Name = 'DRDW_GO_User'))]);
            Set<Id> lUserId = new Set<Id>();
            If(!lPermission.isEmpty()){
                For(PermissionSetAssignment p : lPermission){
                    lUserId.add(p.Assignee.Id);
                }
            }
            If(lUserId.Contains(UserID)){
                return true;
            }
            
            return false;
    }
   Public void permissionSetAssigned(){
                          
         PSAssigned = new set<String>();
         List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserInfo.getUserId()]); 
         for(PermissionSetAssignment opermission : lPermission){             
             PSAssigned.add(opermission.PermissionSet.Name);         
         } 
         if(PSAssigned.contains('DRDW_GO_User')) {         
             showGOPage =  true;
         } 
         if(PSAssigned.contains('DRDW_Leadership_User')) {         
             hidecapacityTab =  true;
         }        
            
     }   
}