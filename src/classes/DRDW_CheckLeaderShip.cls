Public without sharing Class DRDW_CheckLeaderShip{ 
    public boolean isLeader{get;set;}
    public boolean isPMorScientist{get;set;}
    public DRDW_CheckLeaderShip(){
        isLeader =  getUserPermission(UserInfo.getUserId());
        isPMorScientist = CheckifPMorSci(UserInfo.getUserId());
    }

    Public Boolean getUserPermission(Id UserID){
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserID AND PermissionSet.Name IN  ('DRDW_Leadership_User','DRDW_Senior_Leadership_User')]);
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
    
    Public Boolean CheckifPMorSci(Id UserID){
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserID AND PermissionSet.Name IN  ('DRDW_Scientist','DRDW_Project_Manager','DRDW_Financial_User','DRDW_Business_Admin','DRDW_Functional_Head','DRDW_GO_User','DRDW_Study_Managers')]);
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
}