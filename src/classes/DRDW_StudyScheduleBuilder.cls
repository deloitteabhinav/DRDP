public class DRDW_StudyScheduleBuilder {
    Public DRDW_Cap_Request__c oRequest{get;set;}
    Public Id requestRecordID {get; set;}
    public List<DRDW_Event__c> lEvents{get;set;}
    public List<eventWrapper> leventWrapper{get;set;}
    Public Integer index{get;set;}
    public DRDW_Capability__c oActivity{get;set;}
    Public List<SelectOption> lStudyevents{get;set;}
    Public List<SelectOption> lSubEvents{get; set;}
    Public set<String> PSAssignedResource{get;set;} 
    Public Boolean isAccess{get;set;}    
    
    public DRDW_StudyScheduleBuilder(){
        requestRecordID = ApexPages.currentPage().getParameters().get('reqId');
        if(requestRecordID!=null){
             String SobjectApiName = 'DRDW_Cap_Request__c';           
            Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
            Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
            String commaSeparatedFields = '';
            for (String fieldName : fieldMap.keyset()) {
                if (commaSeparatedFields == null || commaSeparatedFields == '') {
                    commaSeparatedFields = fieldName;
                } else {
                    commaSeparatedFields = commaSeparatedFields + ', ' + fieldName;
                }
            }
            string query = 'select ' + commaSeparatedFields + ', Project__r.Business_Unit__c'  +' from ' + SobjectApiName + ' where id =\'' + requestRecordID + '\' limit 1';
            oRequest = Database.query(query);
            lStudyevents = new List<SelectOption>();
             For(GLBL_Global_List_of_Values__c oglbl : [Select Name,RecordType.developerName from GLBL_Global_List_of_Values__c where Active__c = True AND RecordType.DeveloperName = 'DRDW_Samples_To_Collect' order by name ASC]){
            System.debug('GLBL values'+oglbl.Name);
            lStudyevents.add(new SelectOption(oglbl.Name,oglbl.Name));
            }
            /*Schema.DescribeFieldResult describeResult = DRDW_Cap_Request__c.Lab_Testing_required__c.getDescribe();
            // get the picklist values from this describe result
            List<Schema.PicklistEntry> entries = describeResult.getPicklistValues();
            // list of options to be returned to the VF page
            lSubEvents = new List<SelectOption>();
            for (Schema.PicklistEntry pEntry : entries) {
                if (pEntry.isActive()) {
                    lSubEvents.add(new SelectOption(pEntry.getValue(), pEntry.getLabel()));
                }
            } */  
            lSubEvents = new List<SelectOption>();
            For(GLBL_Global_List_of_Values__c oglbl : [Select Name,RecordType.developerName from GLBL_Global_List_of_Values__c where Active__c = True AND RecordType.DeveloperName = 'DRDW_Elanco_Go_sub_Activity' order by name ASC]){
                System.debug('GLBL values'+oglbl.Name);
                lSubEvents.add(new SelectOption(oglbl.Name,oglbl.Name));
            }          
            oActivity = [select id from DRDW_Capability__c where DRDW_Request__c =: oRequest.id];
            leventWrapper = new List<eventWrapper>();
            generateWrapper(oActivity.Id);            
            AddEventRow();
            permissionSetAssignedResource();
            if(PSAssignedResource.contains('DRDW_GO_User')|| PSAssignedResource.contains('DRDW_Business_Admin') || PSAssignedResource.contains('DRDW_Financial_User')) {
                isAccess = true;
            }
        }
    }
    
    public void generateWrapper(Id actId){
        lEvents = [select id,Event_type__c,Frequency__c,Frequency_UI__c,Go_Sub_Activities__c,Display_Order__c from DRDW_Event__c where DRDW_Activity__c =: actId order by Order__c ASC NULLS LAST];
        if(lEvents!=null){
            for(DRDW_Event__c eve:lEvents){
                 eventWrapper oeventWrapper = new eventWrapper(leventWrapper.size()+1,true,eve,false);
                 leventWrapper.add(oeventWrapper);
            }
        }
    }
    
    public void AddEventRow(){
        Integer count = 0; 
        for(eventWrapper oeventWrapper : leventWrapper){
            if(oeventWrapper.issaved){
                count = count + 1;
            }
        }
        if(leventWrapper.size()-count == 0){
           eventWrapper oeventWrapper = new eventWrapper(leventWrapper.size()+1,false,new DRDW_Event__c(),true);
           leventWrapper.add(oeventWrapper);
        }                 
    }
    
    Public void subEventRow(){
        for(eventWrapper oeventWrapper : leventWrapper){
            if(oeventWrapper.index == index){
                try{
                    if(oeventWrapper.issaved){
                        delete oeventWrapper.eventObject;
                        leventWrapper.remove(leventWrapper.indexOf(oeventWrapper));
                    }
                    else{
                        leventWrapper.remove(leventWrapper.indexOf(oeventWrapper));
                    }
                }catch(exception e){
                    addError(e.getmessage());
                }
                break;
            }        
        }
    }
    
    Public void editSubAct(){    
        for(eventWrapper oeventWrapper : leventWrapper){
                DRDW_Event__c  tempEventObject = oeventWrapper.eventObject;           
                if(oeventWrapper.index == index){
                    oeventWrapper.subActList = new List<String>();
                    if(oeventWrapper.eventObject.Go_Sub_Activities__c !=Null && oeventWrapper.eventObject.Go_Sub_Activities__c !='' ){
                       String subAct = oeventWrapper.eventObject.Go_Sub_Activities__c;
                        subAct = subAct.substring(1,subAct.length()-1);
                        For(String s : subAct.split(', ')){
                            system.debug('s'+s);
                            oeventWrapper.subActList.add(s);
                        }
                    }
                }                
          }   
    }
    
        Public void saveEvent(){
        for(eventWrapper oeventWrapper : leventWrapper){
            DRDW_Event__c  tempEventObject = oeventWrapper.eventObject;           
            if(oeventWrapper.index == index){
                boolean iserrored = false;
                if(tempEventObject.Event_Type__c == null || tempEventObject.Frequency_UI__c == null  ){
                    addError('Please enter manadtory values.');
                    iserrored = true;
                }                           
                if(iserrored){
                    break;
                }
                try{                    
                    oEventWrapper.eventObject.Type__c ='GO';
                    oEventWrapper.eventObject.DRDW_Activity__c = oActivity.id;
                    oEventWrapper.eventObject.Study_Title__c = oRequest.Study_Title__c;
                    oEventWrapper.eventObject.Status__c = 'Unassigned';
                    String picklist = '[';   
                    for(String s:oEventWrapper.subActList){
                        picklist = picklist + s +', ' ;
                    }   
                    if(picklist.length()>1)
                    picklist = picklist.substring(0, picklist.length()-1);
                    picklist = picklist.removeEnd(',') +']';                 
                    oEventWrapper.eventObject.Go_Sub_Activities__c = picklist;
                    upsert oEventWrapper.eventObject;                    
                    oEventWrapper.issaved = true;
                    oEventWrapper.isedit = false;       
                    leventWrapper.clear();
                    generateWrapper(oActivity.Id);
                                 
                }
                catch(exception e){
                    if(e.getmessage().contains('DUPLICATE_VALUE')){
                        addError('The activity with this title already exist.');
                    }
                    else{
                        addError(e.getmessage());
                    }
                }
                break;
            }
        }
    } 
    
     public void addError(string s) {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, s);
        ApexPages.addMessage(myMsg);
    }  
    
     Public void permissionSetAssignedResource(){
        PSAssignedResource = new set<String>();
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserInfo.getUserId()]); 
        for(PermissionSetAssignment opermission : lPermission){             
            PSAssignedResource.add(opermission.PermissionSet.Name);         
        } 
    }  
    
     //Wrapper Structure for Summary Modal Popup Table
    Public class eventWrapper{      
        Public Boolean issaved{get;set;}      
        Public Integer index{get;set;}
        Public Boolean isEdit{get;set;}
        Public DRDW_Event__c eventObject{get;set;}
        Public List<String> subActList{get;set;}
        Public eventWrapper(Integer index,Boolean issaved,DRDW_Event__c eventObject,Boolean isEdit){            
            this.index = index;
            this.issaved = issaved;            
            this.eventObject = eventObject;
            this.isEdit = isEdit;
        }          
    }
}