Public with Sharing Class DRDP_ComponentControl{

Public List<SelectOption> lExperience {get;set;}
Public String sSelectedExperience{get;set;}
Public DRDP_Feedback__c oFeedback{get;set;}
 Public String HomeHeader1{get;set;}

    Public DRDP_ComponentControl(){
        HomeHeader1 = '/servlet/servlet.FileDownload?file=';
        List< document > documentList=[select id,name from document where Name IN ('DRDP Home Header logo')];
        HomeHeader1 = HomeHeader1 + documentList[0].id;
        lExperience = new List<SelectOption>();
        oFeedback = new DRDP_Feedback__c();
        for (Schema.Picklistentry oPicklistValues : DRDP_Feedback__c.Experience__c.getDescribe().getPicklistValues()) {
            lExperience.add(new SelectOption(oPicklistValues.Label,oPicklistValues.Label));
        }
    }

   Public void SaveFeedback(){
        oFeedback.Experience__c = sSelectedExperience;
        Insert oFeedback;
        oFeedback = new DRDP_Feedback__c();
   }

}