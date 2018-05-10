/****************************************************************************************************************************************** 
* Class Name   : DRDW_Research_TriggerHandler 
* Description  : Class to check updates on User lookups on Research
* Created By   : Deloitte Consulting
* 
*****************************************************************************************************************************************/
public class DRDW_Research_TriggerHandler {
    public static List<ID> relideaList = new List<ID>();
    
  /*  public static void Checkupdates(Map<Id, DRDW_Project__c> lOldprjMap,Map<Id, DRDW_Project__c> lNewprjMap ,List<DRDW_Project__c> lNewprjs) {
        Map<String, DRDW_Project__Share> IdeaExisShare = new Map<String, DRDW_Project__Share>();
        Map<String, DRDW_Project__Share> IdeaRelShare = new Map<String, DRDW_Project__Share>();
        List<DRDW_Project__Share> iSharedtobeinserted  = new List<DRDW_Project__Share>();
        List<DRDW_Project__Share> iSharedtobedeleted = new List<DRDW_Project__Share>();
        
        //Adding a Map to check if the new ERL contact is there is any of the related Generation records
        for(DRDW_Project__Share irShare : [select Id,UserOrGroupID,ParentId,AccessLevel,RowCause from DRDW_Project__Share where ParentId IN :lOldprjMap.keyset() and RowCause ='DRDW_Related_Research_Share__c']){
            IdeaRelShare.put(irShare.ParentId+'_'+irShare.UserOrGroupID, irShare);
        }
        
        //Adding a Map for Idea ID and it's sharing records (which are shared through link in gen)
        for(DRDW_Project__Share iShare : [select Id,UserOrGroupID,ParentId,AccessLevel,RowCause from DRDW_Project__Share where ParentId IN :lOldprjMap.keyset() and RowCause ='DRDW_Research_Share__c']){
            IdeaExisShare.put(iShare.ParentId+'_'+iShare.UserOrGroupID, iShare);
            
        }
        system.debug('rel share list idea'+IdeaRelShare);
        system.debug('share list idea'+IdeaExisShare);
        
        for(DRDW_Project__c newprjs : lNewprjs){
            DRDW_Project__c oprj = lOldprjMap.get(newprjs.Id);
            DRDW_Project__c nprj = lNewprjMap.get(newprjs.Id);
            
            // checking for updation in Idea
            if(oprj.recordtypeid == getObjectRecordTypeId(DRDW_Project__c.SObjectType,'Idea Project') && nprj.recordtypeid == getObjectRecordTypeId(DRDW_Project__c.SObjectType,'Idea Project')){
                system.debug('Inside Idea record type');
                if(oprj.ERL_Primary_Contact__c != nprj.ERL_Primary_Contact__c && oprj.ERL_Primary_Contact__c != null){
                    system.debug('Inside updation of ERL Primary contact');
                    //if old ERL is not null , delete sharing if not already there through link in Gen
                    if(oprj.ERL_Primary_Contact__c != null && IdeaRelShare.containsKey(oprj.Id+'_'+oprj.ERL_Primary_Contact__c) && !IdeaExisShare.containsKey(oprj.Id+'_'+oprj.ERL_Primary_Contact__c) ){
                        system.debug('Do not do anything since the sharing record is due to the user in gen too');
                    }else if(oprj.ERL_Primary_Contact__c != null && !IdeaRelShare.containsKey(oprj.Id+'_'+oprj.ERL_Primary_Contact__c) && IdeaExisShare.containsKey(oprj.Id+'_'+oprj.ERL_Primary_Contact__c) ) {
                        system.debug('adding idea delete');
                        iSharedtobedeleted.add(IdeaExisShare.get(oprj.Id+'_'+oprj.ERL_Primary_Contact__c));
                    }
                    //If new ERL is not null insert sharing records if not already there through link in Gen
                    if(nprj.ERL_Primary_Contact__c != null && (IdeaRelShare.containsKey(nprj.Id+'_'+nprj.ERL_Primary_Contact__c) || IdeaExisShare.containsKey(nprj.Id+'_'+nprj.ERL_Primary_Contact__c)) ){
                        system.debug('Do not do anything since the sharing record is due to the user in gen too');
                    }else if(nprj.ERL_Primary_Contact__c != null && !IdeaRelShare.containsKey(nprj.Id+'_'+nprj.ERL_Primary_Contact__c) && !IdeaExisShare.containsKey(nprj.Id+'_'+nprj.ERL_Primary_Contact__c) ) {
                        system.debug('adding idea insert');
                        iSharedtobeinserted.add(createsharingrule(nprj.Id, nprj.ERL_Primary_Contact__c, 'Research_Share'));
                    }
                }
            }else{
                if(oprj.recordtypeid == getObjectRecordTypeId(DRDW_Project__c.SObjectType,'Generation Project') && nprj.recordtypeid == getObjectRecordTypeId(DRDW_Project__c.SObjectType,'Generation Project')){
                    //adding related idea's ID for generation projects
                    relideaList.add(oprj.Related_Idea_Project__c);
                    system.debug('Before calling function');
                    checkupdatesfinal(lOldprjMap,lNewprjMap,lNewprjs);
                    
                }else if(oprj.recordtypeid == getObjectRecordTypeId(DRDW_Project__c.SObjectType,'Assessment Project') && nprj.recordtypeid == getObjectRecordTypeId(DRDW_Project__c.SObjectType,'Assessment Project')){
                    
                    relideaList.add(oprj.Related_Generation_Project__c);
                    system.debug('Before calling function from Assessment');
                    checkupdatesfinal(lOldprjMap,lNewprjMap,lNewprjs);
                }
            }
            
        }
        
        //Adding and Deleting share records if not null
        if(iSharedtobedeleted!=null && !iSharedtobedeleted.isEmpty()){
            system.debug('in idea delete'+iSharedtobedeleted);
            delete iSharedtobedeleted;
        }
        
        if(iSharedtobeinserted !=null && !iSharedtobeinserted.isEmpty()){
            system.debug('in idea insert'+iSharedtobeinserted);
            upsert iSharedtobeinserted;
        }
        
    }
    */
    /*
* @Method Name                    :  getObjectRecordTypeId
* @Description                    :  Method to retrieve recordtypeid
* @Return Type                    :  String
* @Parameters                     :  string,SObjectType
*/
    
    public static String getObjectRecordTypeId(SObjectType sObjectType, String recordTypeName){
        //Generate a map of tokens for all the Record Types for the desired object
        Map<String,Schema.RecordTypeInfo> recordTypeInfo = sObjectType.getDescribe().getRecordTypeInfosByName();        
        
        //Retrieve the record type id by name
        return recordTypeInfo.get(recordTypeName).getRecordTypeId();
    }
    
    /*
* @Method Name                    :  checkupdatesfinal
* @Description                    :  Method to insert or update Project share records
* @Return Type                    :  void
* @Parameters                     :  Old Map, New Map, list new prjs

    
    public static void checkupdatesfinal(Map<Id, DRDW_Project__c> lOldprjMap, Map<Id, DRDW_Project__c> lNewprjMap ,List<DRDW_Project__c> lNewprjs){
        
        
        //Creating Map to hold ParentID_UserID as the key and it's related Sharing record as the value.
        Map<string, DRDW_Project__Share> NewExisMapShare = new Map<string, DRDW_Project__Share>();
        List<DRDW_Project__Share> sharestobeDeleted = new List<DRDW_Project__Share>();
        List<DRDW_Project__Share> sharestobeInserted = new List<DRDW_Project__Share>();
        List<DRDW_Project__c> OtherParentLst = new List<DRDW_Project__c>();
        List<DRDW_Project__c> NewOtherparenLst = new List<DRDW_Project__c>();
        Map<string, DRDW_Project__Share> OtherParentSharing = new Map<string, DRDW_Project__Share>();
        Map<string, DRDW_Project__Share> NewOtherParentSharing = new Map<string, DRDW_Project__Share>();
        Map<string, DRDW_Project__Share> ChildSharing = new Map<string, DRDW_Project__Share>();
        Map<string, DRDW_Project__Share> NewChildSharing = new Map<string, DRDW_Project__Share>();
        
        //adding child sharing in a Map
        for(DRDW_Project__Share cshare: [select Id,UserOrGroupID,ParentId,AccessLevel,RowCause from DRDW_Project__Share
                                         where ParentId IN :relideaList]){
                                             ChildSharing.put(cshare.ParentId+'_'+cshare.UserOrGroupID, cshare);
                                         }
        //adding other researches, it's related share records in a map to check the duplication of share records
        
        OtherParentLst = [Select Id from DRDW_Project__c Where Id NOT IN : lOldprjMap.keyset() and Related_Idea_Project__c IN : relideaList];
        
        for(DRDW_Project__Share ooshare : [select Id,UserOrGroupID,ParentId,AccessLevel,RowCause from DRDW_Project__Share where ParentId IN : OtherParentLst]){
            OtherParentSharing.put(ooshare.ParentId+'_'+ooshare.UserOrGroupID, ooshare);
        }
        
        system.debug('OtherParentSharing::::'+OtherParentSharing);
        // Adding a mad to hold existing Share records for the parent
        for(DRDW_Project__Share oprjShare: [select Id,UserOrGroupID,ParentId,AccessLevel,RowCause from DRDW_Project__Share
                                            where ParentId IN :lOldprjMap.keyset()]){
                                                NewExisMapShare.put(oprjShare.ParentId+'_'+oprjShare.UserOrGroupID , oprjShare);
                                            }
        
        for(DRDW_Project__c newprjs : lNewprjs){
            DRDW_Project__c oldprj = lOldprjMap.get(newprjs.Id);
            DRDW_Project__c newprj = lNewprjMap.get(newprjs.Id);
            
            //Iterating through all 11 user lookup fields and checking if they are updated
            for(Schema.FieldSetMember fsm:Schema.SObjectType.DRDW_Project__c.fieldSets.getMap().get('user_lookups_set').getFields()){
                
                if(oldprj.get(fsm.getFieldPath()) != newprj.get(fsm.getFieldPath()) ){
                    if(newprj.recordtypeid == getObjectRecordTypeId(DRDW_Project__c.SObjectType,'Generation Project')){
                        //checking if Related Idea is null 
                        if(oldprj.Related_Idea_Project__c != null){
                            //Deleting Old user's child access in case the same user isn't there in any other parent(with same child record)
                            
                            if(oldprj.get(fsm.getFieldPath())!=null && OtherParentSharing.containsKey(oldprj.Related_Idea_Project__c+'_'+oldprj.get(fsm.getFieldPath())) ){
                                system.debug('Already has sharing through other parent do not do anything');
                            }else if(oldprj.get(fsm.getFieldPath())!=null && (ChildSharing.containsKey(oldprj.Related_Idea_Project__c+'_'+oldprj.get(fsm.getFieldPath())) ) ) {
                                sharestobeDeleted.add(ChildSharing.get(oldprj.Related_Idea_Project__c+'_'+oldprj.get(fsm.getFieldPath())));
                                system.debug('inside old child delete - sharestobeDeleted :'+sharestobeDeleted);
                            }
                            
                            //Inserting new user's child access in case the same user isn't there in any other parent(with same child record)
                            
                            if(newprj.get(fsm.getFieldPath())!=null && OtherParentSharing.containsKey(newprj.Related_Idea_Project__c+'_'+newprj.get(fsm.getFieldPath())) ){
                                system.debug('Already has sharing through other parent do not do anything');
                            }else if(newprj.get(fsm.getFieldPath())!=null && !ChildSharing.containsKey(newprj.Related_Idea_Project__c+'_'+newprj.get(fsm.getFieldPath()))){
                                sharestobeInserted.add(createsharingrule(newprj.Related_Idea_Project__c, (ID)newprj.get(fsm.getFieldPath()), 'Related_Research_Share'));
                                system.debug('inside new child inserts - sharestobeInserted'+sharestobeInserted);
                            }
                        }   
                        
                    }else if (newprj.recordtypeid == getObjectRecordTypeId(DRDW_Project__c.SObjectType,'Assessment Project')){
                        //checking if related gen is null
                        if(oldprj.Related_Generation_Project__c != null){
                            //same code for child logic but repeat it for related gen on assessment
                            
                            //Deleting Old user's child access in case the same user isn't there in any other parent(with same child record)
                            
                            if(oldprj.get(fsm.getFieldPath())!=null && OtherParentSharing.containsKey(oldprj.Related_Generation_Project__c+'_'+oldprj.get(fsm.getFieldPath())) ){
                                system.debug('Already has sharing through other parent do not do anything');
                            }else if(oldprj.get(fsm.getFieldPath())!=null && (ChildSharing.containsKey(oldprj.Related_Generation_Project__c+'_'+oldprj.get(fsm.getFieldPath())) )) {
                                sharestobeDeleted.add(ChildSharing.get(oldprj.Related_Generation_Project__c+'_'+oldprj.get(fsm.getFieldPath())));
                                system.debug('inside old child delete - sharestobeDeleted :'+sharestobeDeleted);
                            }
                            
                            //Inserting new user's child access in case the same user isn't there in any other parent(with same child record)
                            
                            if(newprj.get(fsm.getFieldPath())!=null && OtherParentSharing.containsKey(newprj.Related_Generation_Project__c+'_'+newprj.get(fsm.getFieldPath())) ){
                                system.debug('Already has sharing through other parent do not do anything');
                            }else if(newprj.get(fsm.getFieldPath())!=null && !ChildSharing.containsKey(newprj.Related_Generation_Project__c+'_'+newprj.get(fsm.getFieldPath()))){
                                sharestobeInserted.add(createsharingrule(newprj.Related_Generation_Project__c, (ID)newprj.get(fsm.getFieldPath()), 'Related_Research_Share'));
                                system.debug('inside new child inserts - sharestobeInserted'+sharestobeInserted);
                            }
                        }   
                    }    
                    // adding and deleting share records for the parent
                    
                    if(NewExisMapShare.containsKey(oldprj.Id+'_'+oldprj.get(fsm.getFieldPath())) &&  oldprj.get(fsm.getFieldPath())!= null && !checkwithin11( (ID)oldprj.get(fsm.getFieldPath()), oldprj.Id, lOldprjMap )){
                        sharestobeDeleted.add(NewExisMapShare.get(oldprj.Id+'_'+oldprj.get(fsm.getFieldPath())));
                        system.debug('inside parent delete - sharestobeDeleted :'+sharestobeDeleted);
                    }
                    
                    if( newprj.get(fsm.getFieldPath()) !=null ){
                        sharestobeInserted.add(createsharingrule(newprj.Id, (ID)newprj.get(fsm.getFieldPath()), 'Research_Share'));
                        system.debug('Inside parent insert'+sharestobeInserted);
                    }
                }
            }    
        }
        
        system.debug('FINAL: sharestobeDeleted:::'+sharestobeDeleted);
        system.debug('FINAL: sharestobeInserted:::'+sharestobeInserted);
        if(sharestobeDeleted!=null && !sharestobeDeleted.isEmpty()){
            system.debug('in delete');
            delete sharestobeDeleted;
        }
        
        if(sharestobeInserted !=null && !sharestobeInserted.isEmpty()){
            upsert sharestobeInserted;
        }
        
    }
    
    public static DRDW_Project__Share createsharingrule(ID ParentId, ID UserID, String reason){
        DRDW_Project__Share oShare = new DRDW_Project__Share();
        oShare.ParentId= ParentId;
        system.debug('share object returning'+UserID);
        oShare.UserOrGroupID= UserID;
        oShare.AccessLevel='Edit';
        if(reason == 'Research_Share')
            oShare.RowCause = Schema.DRDW_Project__Share.RowCause.DRDW_Research_Share__c;
        if(reason == 'Related_Research_Share')
            oShare.RowCause = Schema.DRDW_Project__Share.RowCause.DRDW_Related_Research_Share__c;
        return oShare;
    }
    
    public static boolean checkwithin11(ID Checkinguser, ID RecordID, Map<ID, DRDW_Project__c> Maptobecheckedagnst){
        DRDW_Project__c Templst = Maptobecheckedagnst.get(RecordID);
        Integer i=0;
        
        for(Schema.FieldSetMember fsm:Schema.SObjectType.DRDW_Project__c.fieldSets.getMap().get('user_lookups_set').getFields()){
            if(Checkinguser == Templst.get(fsm.getFieldPath())){
                i = i+1;
            }              
        }
        
        if(i>1) return true;
        else return false;
    }
    
    public static boolean checkinGen(ID Checkinguser, ID RecordID){
        List<DRDW_Project__c> Templst = [Select Id, Research_Project_lead__c, Development_Team_Director__c, Director__c, Launch_Leader__c, Global_Marketer__c, Regulatory_Rep__c, 
                                         RP_Project_Manager__c, Legal_REP__c, Lead_Finder__c, Internal_Development_Partner__c, ERL_Primary_contact__c, Name from DRDW_Project__c Where Id = :RecordID LIMIT 1];
        boolean send = false;
        
        for(Schema.FieldSetMember fsm:Schema.SObjectType.DRDW_Project__c.fieldSets.getMap().get('user_lookups_set').getFields()){
            if(Checkinguser == Templst[0].get(fsm.getFieldPath())){
                send = true;
            }              
        }
        
        return send;
    }
    
    public static boolean checkinIdea(ID Checkinguser, ID RecordID){
        List<DRDW_Project__c> Templst = [Select Id, Name,ERL_Primary_Contact__c from DRDW_Project__c Where Id = :RecordID LIMIT 1];
        boolean check = false;
        
        if(Checkinguser == Templst[0].ERL_Primary_Contact__c){
            check=true;
        }     
        
        return check;
    }
    
    public static void Handledelete (Map<Id, DRDW_Project__c> dlOldprjMap, List<DRDW_Project__c> dloldprjs){
        Map<String, DRDW_Project__Share> GenMap = new MAP<String, DRDW_Project__Share>();
        Map<String, DRDW_Project__Share> AssessMap = new MAP<String, DRDW_Project__Share>();
        List<DRDW_Project__Share> lsttobedeleted = new List<DRDW_Project__Share>();
        
        for(DRDW_Project__Share deshare : [select Id,UserOrGroupID,ParentId,AccessLevel,RowCause from DRDW_Project__Share where ParentId IN :dlOldprjMap.keyset() and RowCause!= 'Owner'] ){
            GenMap.put(deshare.ParentId+'_'+deshare.UserOrGroupID, deshare);
        }
        for(DRDW_Project__Share deshare1 : [select Id,UserOrGroupID,ParentId,AccessLevel,RowCause from DRDW_Project__Share where ParentId IN :dlOldprjMap.keyset() and RowCause!= 'Owner' ]){
            AssessMap.put(deshare1.ParentId+'_'+deshare1.UserOrGroupID, deshare1);
        }        
        
        system.debug('Gen Map'+GenMap);
        system.debug('Asses Map'+AssessMap);
        
        for (DRDW_Project__c delprjs : dloldprjs){
            DRDW_Project__c delprj = dlOldprjMap.get(delprjs.Id);
            if(delprj.recordtypeid == getObjectRecordTypeId(DRDW_Project__c.SObjectType,'Generation Project')){
                for(Schema.FieldSetMember fsm:Schema.SObjectType.DRDW_Project__c.fieldSets.getMap().get('user_lookups_set').getFields()){
                    if(delprj.Related_Idea_Project__c != null && delprj.get(fsm.getFieldPath())!= null ){
                        if(!checkinIdea( (ID)delprj.get(fsm.getFieldPath()), delprj.Related_Idea_Project__c)){
                            system.debug('Inside gen if user is not in idea');
                            if(GenMap.containsKey( delprj.Id+'_'+delprj.get(fsm.getFieldPath()))){
                                system.debug('Inside gen if user is not in idea and is not an owner');
                                lsttobedeleted.add(GenMap.get(delprj.Id+'_'+delprj.get(fsm.getFieldPath())));
                            } 
                        }
                    }    
                }
            }else if(delprj.recordtypeid == getObjectRecordTypeId(DRDW_Project__c.SObjectType,'Assessment Project')){
                for(Schema.FieldSetMember fsm:Schema.SObjectType.DRDW_Project__c.fieldSets.getMap().get('user_lookups_set').getFields()){
                    if(delprj.Related_Generation_Project__c != null && delprj.get(fsm.getFieldPath())!= null ){
                        if(!checkinGen( (ID)delprj.get(fsm.getFieldPath()), delprj.Related_Generation_Project__c)){
                            system.debug('Inside assess if user is not in gen');
                            if(AssessMap.containsKey( delprj.Id+'_'+delprj.get(fsm.getFieldPath()))){
                                system.debug('Inside assess if user is not in gen and is not an owner');
                                lsttobedeleted.add(AssessMap.get(delprj.Id+'_'+delprj.get(fsm.getFieldPath())));
                            }   
                        }
                    }   
                }
            }
        }
        system.debug('Final before deleting'+ lsttobedeleted);
        //Deleting the sharing records given that they aren't in any of the related records
        if(lsttobedeleted!=null && !lsttobedeleted.isEmpty()){
            system.debug('in delete of gen and assess'+lsttobedeleted);
            delete lsttobedeleted;
        }
        
    }  */
    
    
    public void onBeforeInsert(List<DRDW_Project__c> NewPrjList){
        List<DRDW_Project__c> lprojects = new List<DRDW_Project__c>();  
        //Changing the currency ISO for all Budget Master records getting inserted  
        for(DRDW_Project__c oProject : NewPrjList){
            oProject.CurrencyIsoCode = Label.DRDW_Currency_Label;
            lprojects.add(oProject);
        }
        /* updating the records if not null
if(!lprojects.isEmpty() && lprojects != null){
update lprojects;
}    */    
        
    }
    
    
    public void onAfterInsert(List<DRDW_Project__c> newlist,Map<Id,DRDW_Project__c> newMap){
        
        
        List<Id> parentIds = new List<Id>();
        parentIds.addAll(newMap.KeySet());
        Boolean flag = true;
        
        DRDW_RecordSharing.getRecordIdShare(parentIds,flag,true);
        
    }
    
    
    public void OnAfterUpdate(List<DRDW_Project__c> newlist,Map<Id,DRDW_Project__c> oldMap){
        
        List<Id> parentIds = new List<Id>();
        parentIds.addAll(oldMap.KeySet());
        Boolean flag = true;                
        Set<Id> buChangeIds = new Set<Id>();
        Map<Id,String> mapProjectBU = new Map<Id,String>();        
        for(DRDW_Project__c oProject:newlist){
            if(oProject.Business_Unit__c != oldMap.get(oProject.id).Business_Unit__c){
                buChangeIds.add(oProject.id);
                mapProjectBU.put(oProject.id,oProject.Business_Unit__c);
            }
        }        
        List<DRDW_Capability__c> lCaps = new List<DRDW_Capability__c>();
        lCaps = [select id,Project_Business_Unit__c,Related_Project__c,Related_Idea__c from DRDW_Capability__c where Related_Project__c=:buChangeIds or Related_Idea__c=:buChangeIds];        
        for(DRDW_Capability__c oCap:lCaps){
            if(oCap.Related_Project__c!=null){
                oCap.Project_Business_Unit__c = mapProjectBU.get(oCap.Related_Project__c);
            }else{
                oCap.Project_Business_Unit__c = mapProjectBU.get(oCap.Related_Idea__c);
            }
        }        
        List<DRDW_Risk__c> lRisks = new List<DRDW_Risk__c>();
        lRisks = [select id,Project_Business_Unit__c,Related_To__c from DRDW_Risk__c where Related_To__c=:buChangeIds];        
        for(DRDW_Risk__c oRisk:lRisks){
            if(oRisk.Related_To__c!=null){
                oRisk.Project_Business_Unit__c = mapProjectBU.get(oRisk.Related_To__c);
            }else{
                oRisk.Project_Business_Unit__c = mapProjectBU.get(oRisk.Related_To__c);
            }
        }        
        try{
            
            update lCaps;
            update lRisks;
            
        }catch(Exception e){
            system.debug('Not able to update Business Unit');         
        }
        
        DRDW_RecordSharing.getRecordIdShare(parentIds,flag,false);
        
    }
    
    public void OnBeforeUpdate(List<DRDW_Project__c> newlist,Map<Id,DRDW_Project__c> newMap){
        
        List<Id> parentIds = new List<Id>();
        parentIds.addAll(newMap.KeySet());
        Boolean flag = false;
        
        DRDW_RecordSharing.getRecordIdShare(parentIds,flag,false);
        
    }
    
    public void OnBeforeDelete(List<DRDW_Project__c> oldMasters,Map<Id,DRDW_Project__c> oldMap){
        
        Boolean isFin = false;
        
        isFin = getUserPermissionFin(UserInfo.getUserId());
        
        if(isFin){
            
            List<DRDW_Risk__c> lRisks = new List<DRDW_Risk__c>();
            List<DRDW_Budget_Master__c> lMasters = new List<DRDW_Budget_Master__c>();
            List<DRDW_Capability__c> lCaps = new List<DRDW_Capability__c>();
            
            
            lRisks = [select id from DRDW_Risk__c where Related_To__c in:oldMap.keySet()];
            lMasters = [select id from DRDW_Budget_Master__c where Related_To__c in:oldMap.keySet()];
            lCaps = [select id from DRDW_Capability__c where Related_Idea__c in:oldMap.keySet() OR Related_Project__c in:oldMap.keySet()];
            
            if(!lRisks.isEmpty())
                delete lRisks;
            
            if(!lMasters.isEmpty())
                delete lMasters;
            
            if(!lCaps .isEmpty())
                delete lCaps;    
            
        }     
    }
    
    Public Boolean getUserPermissionFin(Id UserID){
        List<PermissionSetAssignment> lPermission = new List<PermissionSetAssignment>([select Assignee.Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id=:UserID AND PermissionSet.Name = 'DRDW_Financial_User']);
        Set<Id> lUserId = new Set<Id>();
        If(!lPermission.isEmpty()){
            For(PermissionSetAssignment p : lPermission){
                lUserId.add(p.Assignee.Id);
            }
        }
        If(lUserId.Contains(UserID)){
            return true;
        }
        
        return false;
    }  
    
}