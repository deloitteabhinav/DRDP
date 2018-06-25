/****************************************************************************************************************************************** 
* Class Name   : partnerSelection
* Description  : Class for partnerSelection
* Created By   : Deloitte Consulting
* 
*****************************************************************************************************************************************/
public with sharing class partnerSelection{    
    public List<Account> lAcc {get; set;}
    public Id contactId{get;set;}
    public List<AccountContactRelation> lAccContact {get;set;}
    public string communityId;
    public string communityName{get;set;}
    //Loading the Contructor
        public partnerSelection(ApexPages.StandardController stdController) {
        
        contactId = [SELECT contactId from USER where id=:userinfo.getuserID() LIMIT 1].contactId;
        
        lAccContact = new List<AccountContactRelation>([select accountId,Account.Name,Account.isPartner,Account.Logo_URL__c,Account.Organization_Welcome_Description__c from AccountContactRelation where contactid =:contactId AND Account.isPartner = true]);
        
        communityId=Network.getNetworkId(); 
        System.debug('******** ' + communityId);
        communityName = [SELECT Id, Name, UrlPathPrefix FROM Network where id =: communityId].UrlPathPrefix;     
             
    }

}