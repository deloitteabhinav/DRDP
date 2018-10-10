public class attachmentTriggerHelper {
    
    public static void setCheckBoxOnProject(List<Attachment> newrecords){
        Set<Id> parentIds = new Set<Id>();
        for(Attachment att: newrecords){
            parentIds.add(att.ParentId);
        }
        List<DRDW_Project_Deliverable__c> lPDeliverables = new List<DRDW_Project_Deliverable__c>();
        lPDeliverables = [select id,Attachment__c,Type__c from DRDW_Project_Deliverable__c where id IN:parentIds];
        if(lPDeliverables.size()>0){
            for(DRDW_Project_Deliverable__c obj:lPDeliverables){
                obj.Attachment__c = true;
                obj.Type__c = 'Attachment';
            }   
            update lPDeliverables;
        }
    }
    
     public static void unSetCheckBoxOnProject(List<Attachment> records){
        Set<Id> parentIds = new Set<Id>();
        for(Attachment att: records){
            parentIds.add(att.ParentId);
        }
        List<DRDW_Project_Deliverable__c> lPDeliverables = new List<DRDW_Project_Deliverable__c>();
        lPDeliverables = [select id,Attachment__c,Type__c,(select id from Attachments) from DRDW_Project_Deliverable__c where id IN:parentIds];
        if(lPDeliverables.size()>0){
            for(DRDW_Project_Deliverable__c obj:lPDeliverables){
                Integer count = 0;
               for(Attachment att:obj.Attachments){
                    count++;
                }
                if(count == 0){
                     obj.Attachment__c = false;
                     obj.Type__c = 'Link';
                }
               
            }   
            update lPDeliverables;
        }
    }
    
}