Public class sr2Index{
    Public Boolean IsAdmin{get;set;}
    
    Public sr2Index(){
     IsAdminUser();
    }
    
    Public void IsAdminUser(){
        For(PermissionSetAssignment p :[SELECT PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId()]){
            If(p.PermissionSet.Name == 'Admin'){
                IsAdmin = true;
                break;
            }else {
                IsAdmin = false;
            }
        }
    }    
}