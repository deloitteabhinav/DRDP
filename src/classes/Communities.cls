/****************************************************************************************************************************************** 
* Class Name   : Communities
* Description  : Class for Communities
* Created By   : Deloitte Consulting
* 
*****************************************************************************************************************************************/
public with sharing class Communities{    
    public Account a {get; set;}
    public String communityId;
    public String communityName{get;set;}
    public String accountId {get;set;}
    //Loading the Contructor
        public Communities(ApexPages.StandardController stdController) {
        
        User u = [SELECT AccountID from USER where id=:userinfo.getuserID()];
        
        accountId = ApexPages.currentPage().getParameters().get('accId');
        if(accountId!=null){
        a = [SELECT Name,Logo_URL__c, Organization_Welcome_Description__c, Logo__c
             FROM Account 
             WHERE id=:accountId ];    
         }
        communityId=Network.getNetworkId(); 
        System.debug('******** ' + communityId);
        communityName = [SELECT Id, Name, UrlPathPrefix FROM Network where id =: communityId].UrlPathPrefix;
        System.debug('@@@@@@@@ ' + communityName );
     }

}