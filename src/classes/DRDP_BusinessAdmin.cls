Public without sharing Class DRDP_BusinessAdmin{
    public boolean isAdmin{get;set;}
    public boolean isFinancialAdmin{get;set;}
    public DRDP_BusinessAdmin(){
        isAdmin =  getUserPermission(UserInfo.getUserId());
        isFinancialAdmin = getFinUserPermission(UserInfo.getUserId());
    }

    Public Boolean getUserPermission(Id UserID){
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserID AND (PermissionSet.Name = 'DRDW_Functional_Head' OR PermissionSet.Name = 'DRDW_ERL_Head' OR  PermissionSet.Name = 'DRDW_GO_User')]);
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

    Public Boolean getFinUserPermission(Id UserID){
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserID AND ((PermissionSet.Name ='DRDW_Financial_User') or (PermissionSet.Name ='DRDW_Business_Admin'))]);
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