/****************************************************************************************************************************************** 
* Class Name   : HomePage
* Description  : Class for the HomePage on the UI
* Created By   : Deloitte Consulting
* 
*****************************************************************************************************************************************/
global with sharing class HomePage{   
    Public List<SelectOption> lExperience {get;set;}
    Public String sSelectedExperience{get;set;}
    Public DRDP_Feedback__c oFeedback{get;set;}
    Public String searchWord {get;set;}
    Public String searchWordMobile{get;set;}
    Public Boolean IsMobile{get;set;}
    Public String HomeHeader1{get;set;}
    Public String HomeHeader2{get;set;}
    Public String HomeCard1{get;set;}
    Public String HomeCard2{get;set;}
    Public String HomeCard3{get;set;}
    Public String HomeBanner{get;set;}
    Public String HomeTitle{get;set;}
    Public String HomeTitleDiscription{get;set;}
    Public String HomeCard1Text{get;set;}
    Public String HomeCard2Text{get;set;}
    Public String HomeCard3Text{get;set;}
    Public String HomeCard1URL{get;set;}
    Public String HomeCard2URL{get;set;}
    Public String HomeCard3URL{get;set;}
    Public List<DRDP_Configuration__c> lHomeTabs{get;set;}
       
    
    //Loading the Constructor
    global HomePage() {
        GetImageUrls();
        HomeTabs();
        IsMobile = isSF1();
        lExperience = new List<SelectOption>();
        oFeedback = new DRDP_Feedback__c();
        for (Schema.Picklistentry oPicklistValues : DRDP_Feedback__c.Experience__c.getDescribe().getPicklistValues()) {
            lExperience.add(new SelectOption(oPicklistValues.Label,oPicklistValues.Label));
        }
        System.debug('***'+ApexPages.currentPage().getHeaders().get('USER-AGENT'));
         
    }
    
    Global void HomeTabs(){
        lHomeTabs = new List<DRDP_Configuration__c>([Select Value__c,URL__c,Tab_Sequence__c,Display__c from DRDP_Configuration__c where Display__c=true AND RecordType.Name = 'Tabs' ORDER BY Tab_Sequence__c]);
    }
    
    global void GetImageUrls(){
        HomeHeader1 = '/servlet/servlet.FileDownload?file=';
        HomeHeader2 = '/servlet/servlet.FileDownload?file=';
        HomeCard1 = '/servlet/servlet.FileDownload?file=';
        HomeCard2 = '/servlet/servlet.FileDownload?file=';
        HomeCard3 = '/servlet/servlet.FileDownload?file=';
        HomeBanner = '/servlet/servlet.FileDownload?file=';
        
        List< document > documentList=[select id,name from document where Name IN ('DRDP Home Banner Image','DRDP Home Card1 image','DRDP Home Card2 image','DRDP Home Card3 image','DRDP Home Header Client logo','DRDP Home Header logo')];
        For(Document d:documentList)
        {
           if(d.Name == 'DRDP Home Header logo'){
               HomeHeader1 = HomeHeader1 +d.id;
           }else if(d.Name == 'DRDP Home Header Client logo'){
               HomeHeader2 = HomeHeader2 + d.id;
           }else if(d.Name == 'DRDP Home Card1 image'){
               HomeCard1 = HomeCard1 + d.id;
           }else if(d.Name == 'DRDP Home Card2 image'){
               HomeCard2 = HomeCard2 + d.id;
           }else if(d.Name == 'DRDP Home Card3 image'){
               HomeCard3 = HomeCard3 + d.id;
           }else{
               HomeBanner = HomeBanner + d.id;
           }
           
           
          
        }
        List<DRDP_Configuration__c> lUIText = new List<DRDP_Configuration__c>([Select Name,Display__c,URL__c,Value__c from DRDP_Configuration__c]);
        
        For(DRDP_Configuration__c DRDPc : lUIText){
            If(DRDPc.Name=='Home Banner Title' && DRDPc.Display__c){
                HomeTitle = DRDPc.Value__c;
            }else If(DRDPc.Name=='Home Banner Discription' && DRDPc.Display__c){
                HomeTitleDiscription = DRDPc.Value__c;
            }else If(DRDPc.Name=='Home Card1 Text' && DRDPc.Display__c){
                HomeCard1Text = DRDPc.Value__c;
                HomeCard1URL = DRDPc.URL__c;
            }else If(DRDPc.Name=='Home Card2 Text' && DRDPc.Display__c){
                HomeCard2Text = DRDPc.Value__c;
                HomeCard2URL = DRDPc.URL__c; 
            }else If(DRDPc.Name=='Home Card3 Text' && DRDPc.Display__c){
                HomeCard3Text = DRDPc.Value__c;
                HomeCard3URL = DRDPc.URL__c;
            }
        }
    }
    
    global void SaveFeedback(){
    oFeedback.Experience__c = sSelectedExperience;
    Insert oFeedback;
    oFeedback = new DRDP_Feedback__c();
    }
    
    global static Boolean isSF1(){
        if((String.isNotBlank(ApexPages.currentPage().getParameters().get('sfdcIFrameHost')) ||
            String.isNotBlank(ApexPages.currentPage().getParameters().get('sfdcIFrameOrigin')) ||
            ApexPages.currentPage().getParameters().get('isdtp') == 'p1' ||
            (ApexPages.currentPage().getParameters().get('retURL') != null && ApexPages.currentPage().getParameters().get('retURL').contains('projectone'))) && !ApexPages.currentPage().getHeaders().get('USER-AGENT').contains('iPad')
        ){
            return true;
        }else{
            return false;
        }
    }
    
    global PageReference populateGlobalURL() {
        If(searchWordMobile !='' && searchWordMobile !=null){
            searchWord = searchWordMobile;
        }
        if (searchWord != NULL && searchWord != '') {
            string reference;
            string encodedString;
            searchWord = EncodingUtil.urlEncode(searchWord, 'UTF-8');
            reference = '/apex/Global_Search?searchWord=' + searchWord ;
            PageReference pageRef = new PageReference(reference);
            pageRef.setRedirect(true);
            return pageRef;
        } else {
            return NULL;
        }
    }
}