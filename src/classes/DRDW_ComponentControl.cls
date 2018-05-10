Public with Sharing Class DRDW_ComponentControl{

Public List<SelectOption> lExperience {get;set;}
Public String sSelectedExperience{get;set;}
Public DRDW_Feedback__c oFeedback{get;set;}
 Public String HomeHeader1{get;set;}

    Public DRDW_ComponentControl(){
        HomeHeader1 = '/servlet/servlet.FileDownload?file=';
        List< document > documentList=[select id,name from document where Name IN ('DRDW Home Header logo')];
        if(!Test.isRunningTest()){
        HomeHeader1 = HomeHeader1 + documentList[0].id;
        }
        lExperience = new List<SelectOption>();
        oFeedback = new DRDW_Feedback__c();
        for (Schema.Picklistentry oPicklistValues : DRDW_Feedback__c.Experience__c.getDescribe().getPicklistValues()) {
            lExperience.add(new SelectOption(oPicklistValues.Label,oPicklistValues.Label));
        }
    }

   Public void SaveFeedback(){
        oFeedback.Experience__c = sSelectedExperience;
       // oFeedback.Submitter__c = UserInfo.getUserId();        
        Insert oFeedback;
        oFeedback = new DRDW_Feedback__c();
   }

}