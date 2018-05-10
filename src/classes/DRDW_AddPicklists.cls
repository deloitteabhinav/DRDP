Public class DRDW_AddPicklists{
    Public Set<GLBL_Global_List_of_Values__c> sPicklists{get;set;}
    Public List<GLBL_Global_List_of_Values__c> vPicklists{get;set;}
    Public String values{get;set;}
    Public String ElancoGroup{get;set;}
    Public String NewPicklist{get;set;}
    Public Boolean isDuplicate{get;set;}
    public DRDW_AddPicklists() {
        //values = 'None';
        vPicklists = new List<GLBL_Global_List_of_Values__c>();
        getPicklistValues();
        isDuplicate = false;
    }
    Public void getPicklistValues(){
        vPicklists.clear();
        if(values == 'Simplified Project Name'){
            sPicklists = new Set<GLBL_Global_List_of_Values__c>([SELECT Active__c,Name,RecordType.DeveloperName,recordtypeid FROM GLBL_Global_List_of_Values__c where RecordType.DeveloperName = 'DRDW_Elanco_Simplified_Project_Name']);
            vPicklists.addall(sPicklists);
        }
        else if(values =='Activity'){
            sPicklists = new Set<GLBL_Global_List_of_Values__c>([SELECT Active__c,Name,RecordType.DeveloperName,recordtypeid FROM GLBL_Global_List_of_Values__c where RecordType.DeveloperName = 'DRDW_Elanco_Capability']);
            vPicklists.addall(sPicklists);
        }
        else if(values =='Impacted Project Timeline Activity'){
            sPicklists = new Set<GLBL_Global_List_of_Values__c>([SELECT Active__c,Name,RecordType.DeveloperName,recordtypeid FROM GLBL_Global_List_of_Values__c where RecordType.DeveloperName = 'DRDW_Elanco_Impacted_Project_Timeline_Activity']);
            vPicklists.addall(sPicklists);
        }
        else if(values =='Risk Details'){
            sPicklists = new Set<GLBL_Global_List_of_Values__c>([SELECT Active__c,Name,RecordType.DeveloperName,recordtypeid FROM GLBL_Global_List_of_Values__c where RecordType.DeveloperName = 'DRDW_Elanco_Risk_Details']);
            vPicklists.addall(sPicklists);
        }
        else if(values == 'Termination Reason'){
            sPicklists = new Set<GLBL_Global_List_of_Values__c>([SELECT Active__c,Name,RecordType.DeveloperName,recordtypeid FROM GLBL_Global_List_of_Values__c where RecordType.DeveloperName = 'DRDW_Elanco_Termination_Reason']);
            vPicklists.addall(sPicklists);
        }else if(values == 'Samples To Collect'){
            sPicklists = new Set<GLBL_Global_List_of_Values__c>([SELECT Active__c,Name,RecordType.DeveloperName,recordtypeid FROM GLBL_Global_List_of_Values__c where RecordType.DeveloperName = 'DRDW_Samples_To_Collect']);
            vPicklists.addall(sPicklists);
        }else if(values == 'Go-Sub Activities'){
            ShowGroupBased();
            sPicklists = new Set<GLBL_Global_List_of_Values__c>([SELECT Active__c,Parent__c,Name,RecordType.DeveloperName,recordtypeid FROM GLBL_Global_List_of_Values__c where RecordType.DeveloperName = 'DRDW_Elanco_Go_sub_Activity']);
        }else{
            sPicklists = new Set<GLBL_Global_List_of_Values__c>();
            vPicklists = new List<GLBL_Global_List_of_Values__c>();
        }  
    }
    
    Public void ShowGroupBased(){
        Id GroupId;
        system.debug('******* '+ElancoGroup);
        if(ElancoGroup != NULL && ElancoGroup != 'None'){
            GroupId = getGroupRecId(ElancoGroup);
        }
        if(GroupId != NULL){           
            sPicklists = new Set<GLBL_Global_List_of_Values__c>([SELECT Active__c,Parent__c,Name,RecordType.DeveloperName,recordtypeid FROM GLBL_Global_List_of_Values__c where RecordType.DeveloperName = 'DRDW_Elanco_Go_sub_Activity' AND Parent__c =: GroupId ]);
            vPicklists.addall(sPicklists);
        }else{
            sPicklists = new Set<GLBL_Global_List_of_Values__c>();
            vPicklists = new List<GLBL_Global_List_of_Values__c>();
        }
    }
    
    Public ID getGroupRecId(String GroupName){
        GLBL_Global_List_of_Values__c oglbl = new GLBL_Global_List_of_Values__c();
        oglbl = [SELECT id,Active__c,Name,RecordType.DeveloperName,recordtypeid FROM GLBL_Global_List_of_Values__c where RecordType.DeveloperName = 'DRDW_Elanco_Group' AND Name =:GroupName AND Active__c = true];
        return oglbl.id;
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
            if(NewPicklist != null && NewPicklist != ''&& values == 'Simplified Project Name'){
                GLBL_Global_List_of_Values__c oGlblList = new GLBL_Global_List_of_Values__c();
                oGlblList.Active__c = true;
                oGlblList.Name = NewPicklist;
                oGlblList.recordtypeid = getObjectRecordTypeId(GLBL_Global_List_of_Values__c.SObjectType,'Elanco Simplified Project Name');
                sPicklists.add(oGlblList);
            }
            else if(NewPicklist != null && NewPicklist != '' && values == 'Activity'){
                GLBL_Global_List_of_Values__c oGlblList = new GLBL_Global_List_of_Values__c();
                oGlblList.Active__c = true;
                oGlblList.Name = NewPicklist;
                oGlblList.recordtypeid = getObjectRecordTypeId(GLBL_Global_List_of_Values__c.SObjectType,'Elanco Capability');
                sPicklists.add(oGlblList);
            }
            else if(NewPicklist != null && NewPicklist != '' && values == 'Impacted Project Timeline Activity'){
                GLBL_Global_List_of_Values__c oGlblList = new GLBL_Global_List_of_Values__c();
                oGlblList.Active__c = true;
                oGlblList.Name = NewPicklist;
                oGlblList.recordtypeid = getObjectRecordTypeId(GLBL_Global_List_of_Values__c.SObjectType,'Elanco Impacted Project Timeline Activity');
                sPicklists.add(oGlblList);
            }
            else if(NewPicklist != null && NewPicklist != '' && values == 'Risk Details'){
                GLBL_Global_List_of_Values__c oGlblList = new GLBL_Global_List_of_Values__c();
                oGlblList.Active__c = true;
                oGlblList.Name = NewPicklist;
                oGlblList.recordtypeid = getObjectRecordTypeId(GLBL_Global_List_of_Values__c.SObjectType,'Elanco Risk Details');
                sPicklists.add(oGlblList);
            }
            else if(NewPicklist != null && NewPicklist != '' && values == 'Termination Reason'){
                GLBL_Global_List_of_Values__c oGlblList = new GLBL_Global_List_of_Values__c();
                oGlblList.Active__c = true;
                oGlblList.Name = NewPicklist;
                oGlblList.recordtypeid = getObjectRecordTypeId(GLBL_Global_List_of_Values__c.SObjectType,'Elanco Termination Reason');
                sPicklists.add(oGlblList);
            }else if(NewPicklist != null && NewPicklist != '' && values == 'Samples To Collect'){
                GLBL_Global_List_of_Values__c oGlblList = new GLBL_Global_List_of_Values__c();
                oGlblList.Active__c = true;
                oGlblList.Name = NewPicklist;
                oGlblList.recordtypeid = getObjectRecordTypeId(GLBL_Global_List_of_Values__c.SObjectType,'DRDW Samples To Collect');
                sPicklists.add(oGlblList);
            }else if(NewPicklist != null && NewPicklist != '' && values == 'Go-Sub Activities'){
                GLBL_Global_List_of_Values__c oGlblList = new GLBL_Global_List_of_Values__c();
                oGlblList.Active__c = true;
                oGlblList.Name = NewPicklist;
                oGlblList.recordtypeid = getObjectRecordTypeId(GLBL_Global_List_of_Values__c.SObjectType,'Elanco Go-sub Activity');
                oGlblList.Parent__c = getGroupRecId(ElancoGroup);
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