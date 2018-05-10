Public without sharing Class DRDW_CycleTime{
    
    public DRDW_CycleTime() {

    } 
       
    Public DRDW_Cycle_Time_Standard__c oCycle{get;set;}
    Public Id currentRecordID {get; set;}
  
    Public Boolean isAdmin{get;set;}
   

    Public DRDW_CycleTime(ApexPages.StandardController controller){
          oCycle = (DRDW_Cycle_Time_Standard__c)controller.getRecord();
          
          currentRecordID = ApexPages.currentPage().getParameters().get('id');
          
           if(currentRecordID != null){
                    
                     String SobjectApiName = 'DRDW_Cycle_Time_Standard__c';
            Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
            Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();

            String commaSeparatedFields = '';
            for (String fieldName : fieldMap.keyset()) {
                if (commaSeparatedFields == null || commaSeparatedFields == '') {
                    commaSeparatedFields = fieldName;
                } else {
                    commaSeparatedFields = commaSeparatedFields + ', ' + fieldName;
                }
            }

           string query = 'select ' + commaSeparatedFields + ' from ' + SobjectApiName + ' where id =\'' + currentRecordID + '\' limit 1';
           oCycle = Database.query(query);
                    
           }         
             isAdmin = getUserPermission(UserInfo.getUserId());
        
        }
        
        Public PageReference redirect(){
          
          DRDW_Cycle_Time_Standard__c oNewCycle = new DRDW_Cycle_Time_Standard__c();
          
          oNewCycle = [Select id from DRDW_Cycle_Time_Standard__c limit 1];
          if(oNewCycle == NULL){
              insert oNewCycle;
              PageReference pageref = new PageReference('/apex/DRDW_CycleTime?id='+oNewCycle.Id+'&isEdit=true');
              pageref.setredirect(true);
              return pageref;
          }else{          
              PageReference pageref = new PageReference('/apex/DRDW_CycleTime?id='+oNewCycle.Id+'&isEdit=true');
              pageref.setredirect(true);
              return pageref;
          }
        
        }
                
         Public PageReference save(){
         try{
         Upsert oCycle;
         
         PageReference pageref = new PageReference('/apex/DRDW_CycleTime?id='+oCycle.Id+'&isEdit=false');
          pageref.setredirect(true);
          return pageref;
          }catch(Exception ex){
               ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Days Cannot be Negative');
              ApexPages.addMessage(myMsg1);
              return null;
          }
         
         }
         
         
         Public PageReference edit(){
        PageReference pageref = new PageReference('/apex/DRDW_CycleTime?id='+currentRecordID+'&isEdit=true');
          pageref.setredirect(true);
          return pageref;
    }
    
     Public PageReference DeleteRecord(){
        
          delete oCycle;
        
          PageReference pageref = new PageReference('/apex/DRDW_CostCenterinfo');
          pageref.setredirect(true);
          return pageref;
    }
    
     Public Boolean getUserPermission(Id UserID){
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserID AND PermissionSet.Name = 'DRDW_Business_Admin']);
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