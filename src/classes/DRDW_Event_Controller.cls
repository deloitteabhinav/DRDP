public with sharing class DRDW_Event_Controller {
    public DRDW_Event__c oEvent{get;set;}
    public string currentRecordID{get;set;}
    public list<DRDW_Assign_Resource__c> lAssignedResources{get;set;}
    public string AssignedResourceId{get;set;}
    public boolean showRelatedList{get;set;}
    public boolean showRemoveButton{get;set;}
    public Set<String> sPermissionAssigned;
    public DRDW_Event_Controller (ApexPages.StandardController controller){
        currentRecordID = ApexPages.currentPage().getParameters().get('id');
        oEvent = (DRDW_Event__c)controller.getRecord();
        if(currentRecordID != null){
            String SobjectApiName = 'DRDW_Event__c';
            Map<String, Schema.SObjectType> schemaMap = schema.getGlobalDescribe();
            Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
            String commaSeparatedFields = '';
            for(String fieldName : fieldMap.keyset()){
                if(commaSeparatedFields == null || commaSeparatedFields == '') {
                    commaSeparatedFields = fieldName;
                } 
                else{
                    commaSeparatedFields = commaSeparatedFields + ', ' + fieldName;
                }
            }
            string query = 'select ' + commaSeparatedFields + ',DRDW_Activity__r.DRDW_Request__r.Name ' + ' from ' + SobjectApiName + ' where id =\'' + string.escapesinglequotes(currentRecordID) + '\' limit 1';
            oEvent = Database.query(query);           
            checkDataVisibility();
        }
    }
    
    /*
    * @Method Name                    :  DeleteRecord
    * @Description                    :  Method for deleting the record
    * @Return Type                    :  PageReference
    * @Parameters                     :  None
    */
    Public PageReference DeleteRecord(){
        try{        
            Database.delete([Select id from DRDW_Assign_Resource__c where Id=:AssignedResourceId]); 
       /*     List<DRDW_Event_Days__c> lEventdays = new List<DRDW_Event_Days__c>();   
            Map<Id,List<String>> mEventFrequency = new Map<Id,List<String>>();             
            lEventdays = [select id,Date__c,DRDW_Event__c,frequency__c,Go_Sub_Activities__c from DRDW_Event_Days__c where DRDW_Event__c =:currentRecordID];
            for(DRDW_Event_Days__c evtDay:lEventdays){
                if(!mEventFrequency.containsKey(evtDay.DRDW_Event__c)){
                    mEventFrequency.put(evtDay.DRDW_Event__c,new List<String>());
                }
                mEventFrequency.get(evtDay.DRDW_Event__c).add(evtDay.Frequency__c);
            }   
            Integer count=0;
            List<String> evtFrequency = oEvent.Frequency__c.split(',');
            if(mEventFrequency.get(oEvent.id)!=null){
            List<String> dayFrequency = mEventFrequency.get(oEvent.id);        
            for(String f:dayFrequency){
                if(evtFrequency.contains(f)){
                    count++;
                }
            }
            }
            if(count ==evtFrequency.size()){
                oEvent.Status__c = 'Assigned';
            }else if(count < evtFrequency.size() && count!=0){
                oEvent.Status__c = 'Partially Assigned';
            }else{
                oEvent.Status__c = 'Unassigned';
            }
            update oEvent;  */
            
             List<DRDW_Event__c> lEvents = new List<DRDW_Event__c>();
                  lEvents = [select id,Event_Dates__c,Status__c,frequency__c,Go_Sub_Activities__c,Type__c from DRDW_Event__c where Id =: currentRecordID and Type__c = 'GO'];
                  List<DRDW_Assign_Resource__c> lAssignRes = [select id,Go_Sub_Activities__c,DRDW_Event__c from DRDW_Assign_Resource__c where DRDW_Event__c in:lEvents];
                  
                  Map<Id,List<DRDW_Assign_Resource__c>> mapofeventResource = new  Map<Id,List<DRDW_Assign_Resource__c>>();
                  Map<Id,Set<String>> mapEventSub = new Map<Id,Set<String>>();
                  Map<Id,Set<String>> mapEventSubchild = new Map<Id,Set<String>>();
                  
                   if(lEvents.size()>0){
                        for(DRDW_Event__c eve:lEvents){
                            List<String> lsubact = new List<String>();
                            lsubact = eve.Go_Sub_Activities__c.replace('[','').replace(']','').split(', ');              
                            if(!mapEventSub.containskey(eve.id)){
                                Set<String> ssubact = new Set<String>();
                                mapEventSub.put(eve.id,ssubact);
                            }
                            mapEventSub.get(eve.id).addAll(lsubact);
                        }
                        
                        if(lAssignRes.size()>0){
                            for(DRDW_Assign_Resource__c oAssign:lAssignRes){
                                if(!mapEventSubchild.containskey(oAssign.DRDW_Event__c)){
                                    Set<String> ssubact = new Set<String>();
                                    mapEventSubchild.put(oAssign.DRDW_Event__c,ssubact);
                                }
                                mapEventSubchild.get(oAssign.DRDW_Event__c).add(oAssign.Go_Sub_Activities__c);
                            }
                        
                        
                        for(DRDW_Event__c eve:lEvents){
                            if(mapEventSubchild.get(eve.id).size()==mapEventSub.get(eve.id).size()){
                                eve.Status__c = 'Assigned';
                            }else{
                                eve.Status__c = 'Partially Assigned';
                            }
                        }
                        }else{
                            for(DRDW_Event__c eve:lEvents){
                                eve.Status__c = 'Unassigned';
                        }
                        }
                   }
                   
                update lEvents;            
                        
            PageReference pageref = new PageReference('/apex/DRDW_Event?id='+currentRecordID);
            pageref.setredirect(true);
            return pageref;
        }
        catch(exception e){
            addError(e.getmessage());
            return null;
        }
    }
    
    public void addError(string s) {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, s);
        ApexPages.addMessage(myMsg);
    }
    
    public void checkDataVisibility(){
        showRelatedList =  false;
        showRemoveButton = false;
        sPermissionAssigned = new set<String>();
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserInfo.getUserId()]); 
        for(PermissionSetAssignment opermission : lPermission){             
            sPermissionAssigned.add(opermission.PermissionSet.Name);         
        } 
        if(sPermissionAssigned.contains('DRDW_GO_User') || sPermissionAssigned.contains('DRDW_Senior_Leadership_User') || sPermissionAssigned.contains('DRDW_Business_Admin')
                || sPermissionAssigned.contains('DRDW_Financial_User')) {
            showRelatedList =  true;
            showRemoveButton = true;
            if(sPermissionAssigned.contains('DRDW_Senior_Leadership_User')){
                showRemoveButton = false;
            }
            lAssignedResources = [Select Id,Name,Activity_Area__c,DRDW_Resources__r.Name__r.Name,Activity_Title__c,Allocation_End_Date__c,Allocation_Start_Date__c,DRDW_Event__c,Hours_Per_Day__c,Group__c,Other_Task__c,Task__c,Frequency_UI__c,Go_Sub_Activities__c from DRDW_Assign_Resource__c where DRDW_Event__c=:currentRecordID];
        }else{
            lAssignedResources = [Select Id,Name,Activity_Area__c,DRDW_Resources__r.Name__r.Name,Activity_Title__c,Allocation_End_Date__c,Allocation_Start_Date__c,DRDW_Event__c,Hours_Per_Day__c,Group__c,Other_Task__c,Task__c,Frequency_UI__c,Go_Sub_Activities__c from DRDW_Assign_Resource__c where DRDW_Event__c=:currentRecordID and DRDW_Resources__r.Name__c =: UserInfo.getUserId()];
            showRelatedList = true;
        }
    }   
}