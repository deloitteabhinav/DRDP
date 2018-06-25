Public class SR2IndexController{

    Public List<DRDP_Configuration__c> lHomeTabs{get;set;}
    Public String HomeHeader1{get;set;}
    Public String HomeHeader2{get;set;}
    
    
    Public SR2IndexController(){
        GetHeaderImage();
        HomeTabs();
    }
    
    Public Void GetHeaderImage(){
        HomeHeader1 = '/servlet/servlet.FileDownload?file=';
        HomeHeader2 = '/servlet/servlet.FileDownload?file=';
        
        List< document > documentList=[select id,name from document where Name IN ('DRDP Home Header Client logo','DRDP Home Header logo')];
        For(Document d:documentList)
        {
           if(d.Name == 'DRDP Home Header logo'){
               HomeHeader1 = HomeHeader1 +d.id;
           }else if(d.Name == 'DRDP Home Header Client logo'){
               HomeHeader2 = HomeHeader2 + d.id;
           }
        }
    }
    
    Public void HomeTabs(){
        lHomeTabs = new List<DRDP_Configuration__c>([Select Value__c,URL__c,Tab_Sequence__c,Display__c from DRDP_Configuration__c where Display__c=true AND RecordType.Name = 'Tabs' ORDER BY Tab_Sequence__c]);
    }
}