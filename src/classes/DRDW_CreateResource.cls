Public without sharing Class DRDW_CreateResource{ 
    
    Public DRDW_Resource__c oResource{get;set;}
    Public Id currentRecordID {get; set;}   
    Public Boolean isAdmin{get;set;}
     public id LinkID {get; set;}

    Public DRDW_CreateResource(ApexPages.StandardController controller){
          oResource = (DRDW_Resource__c)controller.getRecord();
          
          currentRecordID = ApexPages.currentPage().getParameters().get('id');
          
           if(currentRecordID != null){
                    
                     String SobjectApiName = 'DRDW_Resource__c';
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
           oResource = Database.query(query);
          
           
                    
           }
           
             isAdmin = getUserPermission(UserInfo.getUserId());
        
        }
        
        
         Public PageReference save(){
         
            try{
            
            if(oResource.Type__c == 'ERL')
                oResource.Days_Per_Week__c = '5';
             
             if(currentRecordID != null){
                  Update oResource;
             }else{
                  insert oResource;
                }  
                
             }catch(Exception e){
                  if(e.getmessage().contains('DUPLICATE_VALUE')){
               
              ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Resource already exists with this name.Please Check Again.');
              ApexPages.addMessage(myMsg1);
                return null;
                }else if(e.getmessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                
                 ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Hours can be from 0 to 24');
                 ApexPages.addMessage(myMsg1);
                  return null;
                }
             }   
                
         
          PageReference pageref = new PageReference('/apex/DRDW_ResourceList');
          pageref.setredirect(true);
          return pageref;
         
         }
         
         
         Public PageReference edit(){
        PageReference pageref = new PageReference('/apex/DRDW_CreateResource?id='+currentRecordID+'&isEdit=true');
          pageref.setredirect(true);
          return pageref;
    }
    
     Public PageReference DeleteRecord(){
        
          delete oResource;
        
          PageReference pageref = new PageReference('/apex/DRDW_ResourceList');
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