Public class DRDP_AddPicklists{
    Public Set<GLBL_Global_List_of_Values__c> sPicklists{get;set;}
    Public List<GLBL_Global_List_of_Values__c> vPicklists{get;set;}
    Public String values{get;set;}
    Public String NewPicklist{get;set;}
    Public Boolean isDuplicate{get;set;}
    public DRDP_AddPicklists() {
        //values = 'None';
        vPicklists = new List<GLBL_Global_List_of_Values__c>();
        getPicklistValues();
        isDuplicate = false;
    }
    Public void getPicklistValues(){
        vPicklists.clear();
        if(values == 'App Retention Decision'){
            sPicklists = new Set<GLBL_Global_List_of_Values__c>([SELECT Active__c,Name,RecordType.DeveloperName,recordtypeid FROM GLBL_Global_List_of_Values__c where RecordType.DeveloperName = 'App_Retention_Decision']);
            vPicklists.addall(sPicklists);
        }
        else if(values =='Contract Decision/Contract Integration Decision'){
            sPicklists = new Set<GLBL_Global_List_of_Values__c>([SELECT Active__c,Name,RecordType.DeveloperName,recordtypeid FROM GLBL_Global_List_of_Values__c where RecordType.DeveloperName = 'Contract_Decision']);
            vPicklists.addall(sPicklists);
        }
        else{
            sPicklists = new Set<GLBL_Global_List_of_Values__c>();
            vPicklists = new List<GLBL_Global_List_of_Values__c>();
        }  
    }
    Public void SavePicklist(){
        sPicklists.clear(); 
        sPicklists.addall(vPicklists); 
        Set<String> sPick = new Set<String>();
        For(GLBL_Global_List_of_Values__c oglbl : sPicklists){
            String s = oglbl.Name;
            sPick.add(s.toLowerCase());
        }
        If(NewPicklist != null && NewPicklist != '' && sPick.Contains(NewPicklist.toLowerCase())){
            isDuplicate = true;
        }else{
            isDuplicate = false;    
        }
        If(NewPicklist != null && NewPicklist != '' && !sPick.Contains(NewPicklist.toLowerCase())) {
            system.debug('picklist'+sPicklists.size()+'************'+sPicklists);
            if(NewPicklist != null && NewPicklist != ''&& values == 'Contract Decision/Contract Integration Decision'){
                GLBL_Global_List_of_Values__c oGlblList = new GLBL_Global_List_of_Values__c();
                oGlblList.Active__c = true;
                oGlblList.Name = NewPicklist;
                oGlblList.recordtypeid = getObjectRecordTypeId(GLBL_Global_List_of_Values__c.SObjectType,'Contract Decision');
                sPicklists.add(oGlblList);
            }
            else if(NewPicklist != null && NewPicklist != '' && values == 'App Retention Decision'){
                GLBL_Global_List_of_Values__c oGlblList = new GLBL_Global_List_of_Values__c();
                oGlblList.Active__c = true;
                oGlblList.Name = NewPicklist;
                oGlblList.recordtypeid = getObjectRecordTypeId(GLBL_Global_List_of_Values__c.SObjectType,'App Retention Decision');
                sPicklists.add(oGlblList);
            }
        }     
        List<GLBL_Global_List_of_Values__c> olist = new List<GLBL_Global_List_of_Values__c>();
        olist.addAll(sPicklists);
        upsert olist;
        getPicklistValues();
    }
    /*
    * @Method Name                    :  getObjectRecordTypeId
    * @Description                    :  Method to retrieve recordtypeid
    * @Return Type                    :  String
    * @Parameters                     :  string,SObjectType
    */
    public String getObjectRecordTypeId(SObjectType sObjectType, String recordTypeName){
        //Generate a map of tokens for all the Record Types for the desired object
        Map<String,Schema.RecordTypeInfo> recordTypeInfo = sObjectType.getDescribe().getRecordTypeInfosByName();        
        //Retrieve the record type id by name
        return recordTypeInfo.get(recordTypeName).getRecordTypeId();
    }
}