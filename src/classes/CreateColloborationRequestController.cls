/****************************************************************************************************************************************** 
 * Class Name   : CreateColloborationRequestController
 * Description  : Class to display the List of Partnership Colloboration requests/records
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
Public with sharing class CreateColloborationRequestController {
    
    public CreateColloborationRequestController(ApexPages.StandardController controller) {
    
         Id oRecordTypeId = [select Id from RecordType where sObjectType = 'Request__c' AND DeveloperName='Partnership_Collab_Space_Request' LIMIT 1].Id;
         oRequest = new Request__c(RecordTypeId= oRecordTypeId );
         
    }

    
    public Request__c oRequest {get;set;}
    //Loading the constructor the page
    
    public AccountContactRelation oAccCon;
    
    Public CreateColloborationRequestController() {
        
         Id oRecordTypeId = [select Id from RecordType where sObjectType = 'Request__c' AND DeveloperName='Partnership_Collab_Space_Request' LIMIT 1].Id;
         oRequest = new Request__c(RecordTypeId= oRecordTypeId );
         
    }
    
    public pagereference save(){
    
        if(oRequest.Partner_Contact__c!=null && oRequest.Partner__c!=null){
        try{
            
            for(AccountContactRelation oACR : [select accountId,contactId from AccountContactRelation where contactid =:oRequest.Partner_Contact__c AND accountid =:oRequest.Partner__c])
            {
                oAccCon = oACR;
            }
            system.debug('******** ' + oAccCon);
            
            if(oAccCon!=null){
            
                system.debug('*********** ' + 'Into If loop');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Contact already exists for the account'));
            }
            else{
            
                oAccCon = new AccountContactRelation();
                oAccCon.accountId = oRequest.Partner__c;
                oAccCon.contactId = oRequest.Partner_Contact__c;
                insert oAccCon; 
                
                system.debug('*********** oAccCon' + oAccCon.Id);
                oRequest.Partnership_Status__c ='Approved and Active';
                upsert oRequest;
                system.debug('*********** oRequest' + oRequest.Id);
                
                PageReference pr = new PageReference('/apex/PartnerShipList');
                return pr;
            }
            
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
            return null;
        }
       }
        return null;
    }
    
}