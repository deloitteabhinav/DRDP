public class DRDW_RecordSharing {
    Public Static void getRecordIdShare(List<Id> parentIds,Boolean flag,Boolean isNew){
        List<DRDW_Project__c> lProjects = new List<DRDW_Project__c>();
        lProjects = [select id,Development_Team_Director__c,Director__c,ERL_Primary_Contact__c,Global_Marketer__c,Internal_Development_Partner__c,Launch_Leader__c,Lead_Finder__c,Lead_Scientist__c,Legal_REP__c,Regulatory_Rep__c,Related_Assessment_Project__c,Related_Idea_Project__c,Related_Generation_Project__c,Related_Idea__c,Research_Project_Lead__c,Research_Team_Contact__c,RP_Project_Manager__c from DRDW_Project__c where id in:parentIds];
        List<Id> oIds = new List<Id>();
        List<Id> uIds = new List<Id>();
        Map<Id,Id> recordownermap = new Map<Id,Id>();
        Map<Id,Id> rteammap = new Map<Id,Id>();
        List<Id> pIds = new List<Id>();
        List<Id> cIds = new List<Id>();
        List<Id> rIds = new List<Id>();
        for(DRDW_Project__c p: lProjects ){
            oIds.add(p.id);
            if(p.Related_Assessment_Project__c!=null)
                oIds.add(p.Related_Assessment_Project__c);
            if(p.Related_Idea_Project__c!=null)
                oIds.add(p.Related_Idea_Project__c);
            if(p.Related_Generation_Project__c!=null)
                oIds.add(p.Related_Generation_Project__c);       
            if(p.Related_Idea__c!=null)
                oIds.add(p.Related_Idea__c);
        }
        lProjects = [select id,Development_Team_Director__c,Director__c,ERL_Primary_Contact__c,Global_Marketer__c,Internal_Development_Partner__c,Launch_Leader__c,Lead_Finder__c,Lead_Scientist__c,Legal_REP__c,Regulatory_Rep__c,Related_Assessment_Project__c,Related_Idea_Project__c,Related_Idea__c,Related_Generation_Project__c,Research_Project_Lead__c,Research_Team_Contact__c,RP_Project_Manager__c,OwnerId from DRDW_Project__c where id in:oIds];
        oIds.clear();
        for(DRDW_Project__c p: lProjects ){
            oIds.add(p.id);
            pIds.add(p.id);
            uIds.add(p.ownerId);
            recordownermap.put(p.id,p.ownerId);
            if(p.Related_Assessment_Project__c!=null){
                oIds.add(p.Related_Assessment_Project__c);
                pIds.add(p.Related_Assessment_Project__c);
            }
            if(p.Related_Idea_Project__c!=null){
                oIds.add(p.Related_Idea_Project__c);
                pIds.add(p.Related_Idea_Project__c);
            }
            if(p.Related_Generation_Project__c!=null){
                oIds.add(p.Related_Generation_Project__c);
                pIds.add(p.Related_Generation_Project__c);
            }  
            if(p.Related_Idea__c!=null){
                oIds.add(p.Related_Idea__c);
                pIds.add(p.Related_Idea__c);
            }      
            if(p.Development_Team_Director__c!=null && p.Development_Team_Director__c!=p.OwnerId)
                uIds.add(p.Development_Team_Director__c);    
            if(p.Director__c!=null && p.Director__c!=p.OwnerId)
                uIds.add(p.Director__c); 
            if(p.ERL_Primary_Contact__c!=null  && p.ERL_Primary_Contact__c!=p.OwnerId)
                uIds.add(p.ERL_Primary_Contact__c);  
            if(p.Global_Marketer__c!=null  && p.Global_Marketer__c!=p.OwnerId )
                uIds.add(p.Global_Marketer__c);  
            if(p.Internal_Development_Partner__c!=null  && p.Internal_Development_Partner__c!=p.OwnerId)
                uIds.add(p.Internal_Development_Partner__c); 
            if(p.Launch_Leader__c!=null  && p.Launch_Leader__c!=p.OwnerId)
                uIds.add(p.Launch_Leader__c);    
            if(p.Lead_Finder__c!=null  && p.Lead_Finder__c!=p.OwnerId)
                uIds.add(p.Lead_Finder__c);  
            if(p.Lead_Scientist__c!=null  && p.Lead_Scientist__c!=p.OwnerId)
                uIds.add(p.Lead_Scientist__c);   
            if(p.Legal_REP__c!=null  && p.Legal_REP__c!=p.OwnerId)
                uIds.add(p.Legal_REP__c);
            if(p.Regulatory_Rep__c!=null  && p.Regulatory_Rep__c!=p.OwnerId)
                uIds.add(p.Regulatory_Rep__c);
            if(p.Research_Project_Lead__c!=null  && p.Research_Project_Lead__c!=p.OwnerId)
                uIds.add(p.Research_Project_Lead__c);
            if(p.Research_Team_Contact__c!=null  && p.Research_Team_Contact__c!=p.OwnerId){
                uIds.add(p.Research_Team_Contact__c);
                rteammap.put(p.id,p.Research_Team_Contact__c);
            }
            if(p.RP_Project_Manager__c!=null && p.RP_Project_Manager__c!=p.OwnerId)
                uIds.add(p.RP_Project_Manager__c);
        }
        List<DRDW_Capability__c> lCaps = new List<DRDW_Capability__c>();
        lCaps = [select id,OwnerId,Assigned_Resource__c,ERL_Primary_Contact__c,Research_Project_Lead__c from DRDW_Capability__c where Related_Idea__c in :oids or Related_Project__c in :oids];
        for(DRDW_Capability__c c:lCaps){
            oIds.add(c.id);
            cIds.add(c.id);
            uIds.add(c.ownerId);
            recordownermap.put(c.id,c.ownerId);
            if(c.Assigned_Resource__c!=null && c.Assigned_Resource__c!=c.OwnerId)
                uIds.add(c.Assigned_Resource__c);
            if(c.ERL_Primary_Contact__c!=null && c.ERL_Primary_Contact__c!=c.OwnerId )
                uIds.add(c.ERL_Primary_Contact__c);
            if(c.Research_Project_Lead__c!=null && c.Research_Project_Lead__c!=c.OwnerId )
                uIds.add(c.Research_Project_Lead__c);  
        }
        List<DRDW_Risk__c> lRisks = new List<DRDW_Risk__c>();
        lRisks = [select id,ownerid from DRDW_Risk__c where Related_To__c in :oids ];
        for(DRDW_Risk__c r:lRisks){
            oids.add(r.id);
            rids.add(r.id);
            uIds.add(r.ownerId);
            recordownermap.put(r.id,r.ownerId);
        }
        system.debug('oids'+oIds);
        system.debug('uid'+uIds);
        Set<Id> temp = new Set<Id>();
        temp.addAll(oIds);
        List<Id> finaloIds = new List<Id>();
        finaloIds.addAll(temp);
        temp.clear();
        temp.addAll(uIds);
        List<Id> finaluIds = new List<Id>();
        finaluIds.addAll(temp);
        system.debug('oids'+finaloIds);
        system.debug('uid'+finaluIds);
        //   DRDW_CompareShare.oValue = 'in Test';
        if(flag == false || isNew == true)
        DRDW_CompareShare.uIds = temp;
        system.debug('Static value'+ DRDW_CompareShare.oValue);
        if(flag == true){
            List<DRDW_Project__Share> lPshares  = [select Id,UserOrGroupID,ParentId,AccessLevel,RowCause from DRDW_Project__Share where ParentId IN :pIds and UserOrGroupID in: DRDW_CompareShare.uIds and RowCause !='Owner'];
            List<DRDW_Capability__Share> lCshares  = [select Id,UserOrGroupID,ParentId,AccessLevel,RowCause from DRDW_Capability__Share where ParentId IN :cIds and UserOrGroupID in: DRDW_CompareShare.uIds and RowCause !='Owner'];
            List<DRDW_Risk__Share> lRshares  = [select Id,UserOrGroupID,ParentId,AccessLevel,RowCause from DRDW_Risk__Share where ParentId IN :rIds and UserOrGroupID in: DRDW_CompareShare.uIds and RowCause !='Owner' ];
            system.debug('Project share'+lPshares);
            system.debug('Project share'+lCshares);
            system.debug('Project share'+lRshares);
            try{
                delete lPshares;
                delete lCshares;
                delete lRshares;
            }catch(Exception e){
            }
            //  DRDW_CompareShare.compareuserids(DRDW_CompareShare.uIds,temp);
            List<SObject> lShares = new List<SObject>();
            for(Id oid:finaloIds){
                Schema.SObjectType obj = oid.getsobjecttype();
                String name = obj.getDescribe().getName();
                name = name.substring(0,name.length()-1);
                name+='Share';
                system.debug('obj'+name);
                for(Id uid:finaluIds){
                    Schema.SObjectType testShareType = Schema.getGlobalDescribe().get(name);
                    SObject testShare = testShareType.newSObject();
                    testShare.put('ParentId', oid);
                    testShare.put('UserOrGroupId',uid);
                    if(rteammap!=null && uid==rteammap.get(oid))
                    {
                        testShare.put('AccessLevel', 'Read');
                    }
                    else{
                        testShare.put('AccessLevel', 'Edit');
                    }
                    if(uid!=recordownermap.get(oid))
                    lShares.add(testShare);
                }
            }
            system.debug('Insert share record'+lShares);
            system.debug('Static value'+ DRDW_CompareShare.oValue);
            Database.insert(lShares,false);
        }
    }
    
     Public Static void getRecordIdShare(List<Id> parentIds,Boolean flag,Boolean isNew,Id resourceid){
        
        DRDW_Resource__c oResource = [select id,Name__r.Id from DRDW_Resource__c where id=:resourceid limit 1];
        
        List<DRDW_Project__c> lProjects = new List<DRDW_Project__c>();
        lProjects = [select id,Development_Team_Director__c,Director__c,ERL_Primary_Contact__c,Global_Marketer__c,Internal_Development_Partner__c,Launch_Leader__c,Lead_Finder__c,Lead_Scientist__c,Legal_REP__c,Regulatory_Rep__c,Related_Assessment_Project__c,Related_Idea_Project__c,Related_Generation_Project__c,Related_Idea__c,Research_Project_Lead__c,Research_Team_Contact__c,RP_Project_Manager__c from DRDW_Project__c where id in:parentIds];
        List<Id> oIds = new List<Id>();
        List<Id> uIds = new List<Id>();
        Map<Id,Id> recordownermap = new Map<Id,Id>();
        Map<Id,Id> rteammap = new Map<Id,Id>();
        List<Id> pIds = new List<Id>();
        List<Id> cIds = new List<Id>();
        List<Id> rIds = new List<Id>();
        
        if(oResource!=null)
            uids.add(oResource.Name__r.id);
        
        for(DRDW_Project__c p: lProjects ){
            oIds.add(p.id);
            if(p.Related_Assessment_Project__c!=null)
                oIds.add(p.Related_Assessment_Project__c);
            if(p.Related_Idea_Project__c!=null)
                oIds.add(p.Related_Idea_Project__c);
            if(p.Related_Generation_Project__c!=null)
                oIds.add(p.Related_Generation_Project__c);       
            if(p.Related_Idea__c!=null)
                oIds.add(p.Related_Idea__c);
        }
        lProjects = [select id,Development_Team_Director__c,Director__c,ERL_Primary_Contact__c,Global_Marketer__c,Internal_Development_Partner__c,Launch_Leader__c,Lead_Finder__c,Lead_Scientist__c,Legal_REP__c,Regulatory_Rep__c,Related_Assessment_Project__c,Related_Idea_Project__c,Related_Idea__c,Related_Generation_Project__c,Research_Project_Lead__c,Research_Team_Contact__c,RP_Project_Manager__c,OwnerId from DRDW_Project__c where id in:oIds];
        oIds.clear();
        for(DRDW_Project__c p: lProjects ){
            oIds.add(p.id);
            pIds.add(p.id);
            uIds.add(p.ownerId);
            recordownermap.put(p.id,p.ownerId);
            if(p.Related_Assessment_Project__c!=null){
                oIds.add(p.Related_Assessment_Project__c);
                pIds.add(p.Related_Assessment_Project__c);
            }
            if(p.Related_Idea_Project__c!=null){
                oIds.add(p.Related_Idea_Project__c);
                pIds.add(p.Related_Idea_Project__c);
            }
            if(p.Related_Generation_Project__c!=null){
                oIds.add(p.Related_Generation_Project__c);
                pIds.add(p.Related_Generation_Project__c);
            }  
            if(p.Related_Idea__c!=null){
                oIds.add(p.Related_Idea__c);
                pIds.add(p.Related_Idea__c);
            }      
            if(p.Development_Team_Director__c!=null && p.Development_Team_Director__c!=p.OwnerId)
                uIds.add(p.Development_Team_Director__c);    
            if(p.Director__c!=null && p.Director__c!=p.OwnerId)
                uIds.add(p.Director__c); 
            if(p.ERL_Primary_Contact__c!=null  && p.ERL_Primary_Contact__c!=p.OwnerId)
                uIds.add(p.ERL_Primary_Contact__c);  
            if(p.Global_Marketer__c!=null  && p.Global_Marketer__c!=p.OwnerId )
                uIds.add(p.Global_Marketer__c);  
            if(p.Internal_Development_Partner__c!=null  && p.Internal_Development_Partner__c!=p.OwnerId)
                uIds.add(p.Internal_Development_Partner__c); 
            if(p.Launch_Leader__c!=null  && p.Launch_Leader__c!=p.OwnerId)
                uIds.add(p.Launch_Leader__c);    
            if(p.Lead_Finder__c!=null  && p.Lead_Finder__c!=p.OwnerId)
                uIds.add(p.Lead_Finder__c);  
            if(p.Lead_Scientist__c!=null  && p.Lead_Scientist__c!=p.OwnerId)
                uIds.add(p.Lead_Scientist__c);   
            if(p.Legal_REP__c!=null  && p.Legal_REP__c!=p.OwnerId)
                uIds.add(p.Legal_REP__c);
            if(p.Regulatory_Rep__c!=null  && p.Regulatory_Rep__c!=p.OwnerId)
                uIds.add(p.Regulatory_Rep__c);
            if(p.Research_Project_Lead__c!=null  && p.Research_Project_Lead__c!=p.OwnerId)
                uIds.add(p.Research_Project_Lead__c);
            if(p.Research_Team_Contact__c!=null  && p.Research_Team_Contact__c!=p.OwnerId){
                uIds.add(p.Research_Team_Contact__c);
                rteammap.put(p.id,p.Research_Team_Contact__c);
            }
            if(p.RP_Project_Manager__c!=null && p.RP_Project_Manager__c!=p.OwnerId)
                uIds.add(p.RP_Project_Manager__c);
        }
        List<DRDW_Capability__c> lCaps = new List<DRDW_Capability__c>();
        lCaps = [select id,OwnerId,Assigned_Resource__c,ERL_Primary_Contact__c,Research_Project_Lead__c from DRDW_Capability__c where Related_Idea__c in :oids or Related_Project__c in :oids];
        for(DRDW_Capability__c c:lCaps){
            oIds.add(c.id);
            cIds.add(c.id);
            uIds.add(c.ownerId);
            recordownermap.put(c.id,c.ownerId);
            if(c.Assigned_Resource__c!=null && c.Assigned_Resource__c!=c.OwnerId)
                uIds.add(c.Assigned_Resource__c);
            if(c.ERL_Primary_Contact__c!=null && c.ERL_Primary_Contact__c!=c.OwnerId )
                uIds.add(c.ERL_Primary_Contact__c);
            if(c.Research_Project_Lead__c!=null && c.Research_Project_Lead__c!=c.OwnerId )
                uIds.add(c.Research_Project_Lead__c);  
        }
        List<DRDW_Risk__c> lRisks = new List<DRDW_Risk__c>();
        lRisks = [select id,ownerid from DRDW_Risk__c where Related_To__c in :oids ];
        for(DRDW_Risk__c r:lRisks){
            oids.add(r.id);
            rids.add(r.id);
            uIds.add(r.ownerId);
            recordownermap.put(r.id,r.ownerId);
        }
        system.debug('oids'+oIds);
        system.debug('uid'+uIds);
        Set<Id> temp = new Set<Id>();
        temp.addAll(oIds);
        List<Id> finaloIds = new List<Id>();
        finaloIds.addAll(temp);
        temp.clear();
        temp.addAll(uIds);
        List<Id> finaluIds = new List<Id>();
        finaluIds.addAll(temp);
        system.debug('oids'+finaloIds);
        system.debug('uid'+finaluIds);
        //   DRDW_CompareShare.oValue = 'in Test';
        if(flag == false || isNew == true)
        DRDW_CompareShare.uIds = temp;
        system.debug('Static value'+ DRDW_CompareShare.oValue);
        if(flag == true){
            List<DRDW_Project__Share> lPshares  = [select Id,UserOrGroupID,ParentId,AccessLevel,RowCause from DRDW_Project__Share where ParentId IN :pIds and UserOrGroupID in: DRDW_CompareShare.uIds and RowCause !='Owner'];
            List<DRDW_Capability__Share> lCshares  = [select Id,UserOrGroupID,ParentId,AccessLevel,RowCause from DRDW_Capability__Share where ParentId IN :cIds and UserOrGroupID in: DRDW_CompareShare.uIds and RowCause !='Owner'];
            List<DRDW_Risk__Share> lRshares  = [select Id,UserOrGroupID,ParentId,AccessLevel,RowCause from DRDW_Risk__Share where ParentId IN :rIds and UserOrGroupID in: DRDW_CompareShare.uIds and RowCause !='Owner' ];
            system.debug('Project share'+lPshares);
            system.debug('Project share'+lCshares);
            system.debug('Project share'+lRshares);
            try{
                delete lPshares;
                delete lCshares;
                delete lRshares;
            }catch(Exception e){
            }
            //  DRDW_CompareShare.compareuserids(DRDW_CompareShare.uIds,temp);
            List<SObject> lShares = new List<SObject>();
            for(Id oid:finaloIds){
                Schema.SObjectType obj = oid.getsobjecttype();
                String name = obj.getDescribe().getName();
                name = name.substring(0,name.length()-1);
                name+='Share';
                system.debug('obj'+name);
                for(Id uid:finaluIds){
                    Schema.SObjectType testShareType = Schema.getGlobalDescribe().get(name);
                    SObject testShare = testShareType.newSObject();
                    testShare.put('ParentId', oid);
                    testShare.put('UserOrGroupId',uid);
                    if(rteammap!=null && uid==rteammap.get(oid))
                    {
                        testShare.put('AccessLevel', 'Read');
                    }
                    else{
                        testShare.put('AccessLevel', 'Edit');
                    }
                    if(uid!=recordownermap.get(oid))
                    lShares.add(testShare);
                }
            }
            system.debug('Insert share record'+lShares);
            system.debug('Static value'+ DRDW_CompareShare.oValue);
            Database.insert(lShares,false);
        }
    }
    
}