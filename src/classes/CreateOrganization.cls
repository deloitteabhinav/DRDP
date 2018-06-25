public with sharing class CreateOrganization{
    
    public Account oAccount{get; set;}
        
    public CreateOrganization(ApexPages.StandardController controller) {
        
        Id oRecordTypeId = [select Id from RecordType where sObjectType = 'Account' AND DeveloperName='DRDP_Partners' LIMIT 1].Id;
        oAccount = new Account(RecordTypeId= oRecordTypeId );
    }
    
    public pagereference save(){
        try{
            upsert oAccount;
            
            PageReference pr = new PageReference('/apex/CreatePartnership?recTypeName=Partnership_Exploration');
            return pr;
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
            return null;
        }
        return null;
    }
    
}