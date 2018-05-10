Public without sharing Class DRDW_SaveBudgetLine{ 

    Public Id RecId{get;set;}
    Public Boolean fieldvalidate{get;set;}
    Public id BudgetId{get;set;}
    
    Public List<DRDW_Bdg_LI_Data_load__c> newbdgli{get;set;}
    Public List<DRDW_Budget_Line_Item__c> lbudgetLine = new List<DRDW_Budget_Line_Item__c>();
    Public List<DRDW_Bdg_LI_Data_load__c> oldbdgli{get;set;}
    Public List<DRDW_Bdg_LI_Data_load__c> delbdgli = new List<DRDW_Bdg_LI_Data_load__c>();
    Public Static List<DRDW_Bdg_LI_Data_load__c> lnewList = new list<DRDW_Bdg_LI_Data_load__c>();
    Map<id,DRDW_Budget_Master__c> mBudget = new Map<id,DRDW_Budget_Master__c>();
    Map<String,DRDW_Budget_Line_Item__c> mline = new Map<String,DRDW_Budget_Line_Item__c>();

     Public DRDW_SaveBudgetLine(){        
        For(DRDW_Budget_Master__c budgetM : [Select id,Name,Activity__c,Related_To__c,Activity__r.Title__c,Related_To__r.Name__c,Cost_Center__r.Name,PO__c from DRDW_Budget_Master__c]){
            mBudget.put(budgetM.id,budgetM);
        }
        
        For(DRDW_Budget_Line_Item__c oldline : [Select id,PO__c,Vendor__c,PO_Description__c,Related_To__c,Actual_Amount__c,Posting_Date__c,save__c,Save_And_Lock__c,cost_center__c,sapid__c from DRDW_Budget_Line_Item__c]){
            mline.put(oldline.sapid__c,oldline);
        }       
       // showdata();
     }  
     
     

     Public void showdata(){
        newbdgli = new List<DRDW_Bdg_LI_Data_load__c>();
        oldbdgli = new List<DRDW_Bdg_LI_Data_load__c>();
         For(DRDW_Bdg_LI_Data_load__c allBdg : [Select id,isChanged__c,isPo__c,isPoDesc__c,isVendor__c,isAmount__c,isCostCenter__c,isPosting__c,DRDW_Budget_Line_Item__c,SAPIDPO__c,DRDW_Cost_Center__c,Related_To__c,PO__c,PO_Description__c,Project_Idea__c,DRDW_Capability__c,Posting_Date__c,Actual_Amount__c,Vendor__c from DRDW_Bdg_LI_Data_load__c]){
             if(mline.containsKey(allBdg.SAPIDPO__c)){
                 DRDW_Budget_Line_Item__c BuDline = (DRDW_Budget_Line_Item__c)mline.get(allBdg.SAPIDPO__c);
                 DRDW_Budget_Master__c omaster = (DRDW_Budget_Master__c)mBudget.get(BuDline.Related_To__c);
                 if(BuDline.Save_And_Lock__c){
                     delbdgli.add(allBdg);
                 }else{
                     if(BuDline.PO__c != allBdg.PO__c || BuDline.PO_Description__c != allBdg.PO_Description__c || BuDline.Vendor__c != allBdg.Vendor__c || BuDline.Actual_Amount__c != allBdg.Actual_Amount__c || BuDline.cost_center__c != allBdg.DRDW_Cost_Center__c || BuDline.Posting_Date__c != allBdg.Posting_Date__c){
                         allBdg.isChanged__c = true;
                         system.debug('****'+ BuDline.Actual_Amount__c );
                         system.debug('****'+ allBdg.Actual_Amount__c );
                         if(BuDline.PO__c != allBdg.PO__c){
                             allBdg.isPo__c = true;
                         }
                         if(BuDline.PO_Description__c != allBdg.PO_Description__c){
                             allBdg.isPoDesc__c= true;
                         }
                         if(BuDline.Vendor__c != allBdg.Vendor__c){
                             allBdg.isVendor__c= true;
                         }
                         if(BuDline.Actual_Amount__c != allBdg.Actual_Amount__c){                             
                             allBdg.isAmount__c= true;
                         }
                         if(BuDline.cost_center__c != allBdg.DRDW_Cost_Center__c){
                             allBdg.isCostCenter__c= true;
                         }
                         if(BuDline.Posting_Date__c != allBdg.Posting_Date__c){
                             allBdg.isPosting__c= true;
                         }
                     }
                     allBdg.Project_Idea__c = omaster.Related_To__r.Name__c;
                     allBdg.Related_To__c = omaster.id;
                     allBdg.PO__c= omaster.PO__c;
                     allBdg.DRDW_Cost_Center__c = BuDline.cost_center__c;
                     allBdg.DRDW_Capability__c = omaster.Activity__r.Title__c;
                     oldbdgli.add(allBdg);
                 }
             }else{
                     newbdgli.add(allBdg);
                 }
         }       
         if(!delbdgli.isEmpty()){
             delete delbdgli;
         }
     }
     
     Public void updateLists(){
         For(DRDW_Bdg_LI_Data_load__c newbdg : newbdgli){
             if(newbdg.id == RecId && newbdg.Related_To__c != NULL){
                 if(mBudget.ContainsKey(newbdg.Related_To__c)){
                     DRDW_Budget_Master__c BudMaster = (DRDW_Budget_Master__c)mBudget.get(newbdg.Related_To__c);
                     newbdg.PO__c = BudMaster.PO__c;
                     newbdg.Project_Idea__c = BudMaster.Related_To__r.Name__c;
                     newbdg.DRDW_Capability__c = BudMaster.Activity__r.Title__c;
                     newbdg.DRDW_Cost_Center__c = BudMaster.Cost_Center__r.name;
                 }
             }  
         }
         For(DRDW_Bdg_LI_Data_load__c OldNbdgli : oldbdgli){
             if(OldNbdgli.id == RecId && OldNbdgli.Related_To__c != NULL){
                 if(mBudget.ContainsKey(OldNbdgli.Related_To__c)){
                    DRDW_Budget_Master__c BudMaster = (DRDW_Budget_Master__c)mBudget.get(OldNbdgli.Related_To__c);
                     OldNbdgli.PO__c = BudMaster.PO__c;
                     OldNbdgli.Project_Idea__c = BudMaster.Related_To__r.Name__c;
                     OldNbdgli.DRDW_Capability__c = BudMaster.Activity__r.Title__c;
                     OldNbdgli.DRDW_Cost_Center__c = BudMaster.Cost_Center__r.name;
                 }
             }  
         }
     }  
     
     Public void savebdg(){  
        integer i =0;
        Integer j = 0;
        delbdgli = new List<DRDW_Bdg_LI_Data_load__c>();
        
         for(DRDW_Bdg_LI_Data_load__c newbd : newbdgli){
             
             if(newbd.id == RecId){
                 if(newbd.Related_To__c == NULL || newbd.Posting_Date__c == NULL || newbd.PO__c == NULL || newbd.Actual_Amount__c  == NULL|| newbd.DRDW_Cost_Center__c == NULL || (newbd.Project_Idea__c == NULL || newbd.DRDW_Cost_Center__c == NULL)){
                    ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'In order to save, please update blank field values.');
                    ApexPages.addMessage(myMsg1); 
                 }else{
                     if(mBudget.ContainsKey(newbd.Related_To__c)){
                         DRDW_Budget_Master__c oBudMaster = (DRDW_Budget_Master__c)mBudget.get(newbd.Related_To__c);
                         DRDW_Budget_Line_Item__c newLine = new DRDW_Budget_Line_Item__c();
                         newLine.PO__c = oBudMaster.PO__c;
                         newLine.Project_Idea__c = oBudMaster.Related_To__c;
                         newLine.PO_Description__c = newbd.PO_Description__c;
                         newLine.Actual_Amount__c = newbd.Actual_Amount__c;
                         newLine.Posting_Date__c = newbd.Posting_Date__c;
                         newLine.Vendor__c = newbd.Vendor__c;
                         newLine.Related_To__c = newbd.Related_To__c;
                         newLine.save__c = true;
                         newLine.sapid__c = newbd.SAPIDPO__c;
                         lbudgetLine.add(newLine);
                         delbdgli.add(newbd);
                         j = i;
                      }
                 } 
                 
             }
             i++;
             
         }
         if(!lbudgetLine.isEmpty()){ 
         try{                
             insert lbudgetLine;
             newbdgli.remove(j);
             lbudgetLine = new List<DRDW_Budget_Line_Item__c>(); 
             delete delbdgli;
            }catch(Exception e){
                ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Oops! Something went wrong. Please verify the details and cost center should be active');
                ApexPages.addMessage(myMsg1); 
            }
         }
     }
     
     Public void saveandLockNew(){
            integer i =0;
            Integer j = 0;
             delbdgli = new List<DRDW_Bdg_LI_Data_load__c>();
         for(DRDW_Bdg_LI_Data_load__c newbd : newbdgli){
             
             if(newbd.id == RecId){
                 if(newbd.Related_To__c == NULL || newbd.Posting_Date__c == NULL || newbd.PO__c == NULL || newbd.Actual_Amount__c  == NULL|| newbd.DRDW_Cost_Center__c == NULL || (newbd.Project_Idea__c == NULL || newbd.DRDW_Cost_Center__c == NULL)){
                    ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'In order to save, please update blank field values.');
                    ApexPages.addMessage(myMsg1); 
                 }else{
                     if(mBudget.ContainsKey(newbd.Related_To__c)){
                         DRDW_Budget_Master__c oBudMaster = new DRDW_Budget_Master__c();
                         DRDW_Budget_Line_Item__c newLine = new DRDW_Budget_Line_Item__c();
                         oBudMaster = (DRDW_Budget_Master__c)mBudget.get(newbd.Related_To__c);
                         newLine.PO__c = oBudMaster.PO__c; 
                         newLine.Project_Idea__c = oBudMaster.Related_To__c;                       
                         newLine.Related_To__c = newbd.Related_To__c;
                         newLine.PO_Description__c = newbd.PO_Description__c;
                         newLine.Actual_Amount__c = newbd.Actual_Amount__c;
                         newLine.Posting_Date__c = newbd.Posting_Date__c;
                         newLine.Vendor__c = newbd.Vendor__c;
                         newLine.Save_And_Lock__c = true;
                         newLine.sapid__c = newbd.SAPIDPO__c;
                         lbudgetLine.add(newLine);
                         delbdgli.add(newbd);
                         j = i;
                      }
                 }
             }
                 i++;
         }
         if(!lbudgetLine.isEmpty()){
             try{
                 insert lbudgetLine;
                 newbdgli.remove(j);
                 delete delbdgli;
                 lbudgetLine = new List<DRDW_Budget_Line_Item__c>(); 
                 }catch(Exception e){
                ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Oops! Something went wrong. Please verify the details and cost center should be active');
                ApexPages.addMessage(myMsg1); 
                }
            }
     }
     
     Public void DeleteBdgNew(){
         integer i = 0 ;
         integer j = 0 ;
        delbdgli = new List<DRDW_Bdg_LI_Data_load__c>();
          for(DRDW_Bdg_LI_Data_load__c newbd : newbdgli){
              
              if(newbd.id == RecId){
                  delbdgli.add(newbd);
                  j = i;
              }
              i++;
          }
          if(!delbdgli.isEmpty()){
              delete delbdgli;
              newbdgli.remove(j);
          }
     }
     
     Public Void SaveUpdatebdg(){
         integer i = 0;
         integer j = 0;
         lbudgetLine = new List<DRDW_Budget_Line_Item__c>();
         delbdgli = new List<DRDW_Bdg_LI_Data_load__c>();
         for(DRDW_Bdg_LI_Data_load__c oldbd : oldbdgli){
             if(oldbd.id == RecId){
                 if(oldbd.Related_To__c == NULL || oldbd.Posting_Date__c == NULL || oldbd.PO__c == NULL || oldbd.Actual_Amount__c  == NULL|| oldbd.DRDW_Cost_Center__c == NULL || (oldbd.Project_Idea__c == NULL || oldbd.DRDW_Cost_Center__c == NULL)){
                    ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'In order to save, please update blank field values.');
                    ApexPages.addMessage(myMsg1); 
                 }else{
                     if(mBudget.ContainsKey(oldbd.Related_To__c) && mline.containsKey(oldbd.SAPIDPO__c)){
                          DRDW_Budget_Line_Item__c oldLineItem = new DRDW_Budget_Line_Item__c();
                          oldLineItem = (DRDW_Budget_Line_Item__c)mline.get(oldbd.SAPIDPO__c);
                          DRDW_Budget_Master__c oBudMaster = new DRDW_Budget_Master__c();
                          oBudMaster = (DRDW_Budget_Master__c)mBudget.get(oldbd.Related_To__c);
                         oldLineItem.PO__c = oBudMaster.PO__c;
                         oldLineItem.Project_Idea__c = oBudMaster.Related_To__c;                                                  
                         oldLineItem.Related_To__c = oldbd.Related_To__c;
                         oldLineItem.PO_Description__c = oldbd.PO_Description__c;
                         oldLineItem.Actual_Amount__c = oldbd.Actual_Amount__c;
                         oldLineItem.Posting_Date__c = oldbd.Posting_Date__c;
                         oldLineItem.Vendor__c = oldbd.Vendor__c;
                         lbudgetLine.add(oldLineItem);
                         j = i;
                         delbdgli.add(oldbd);
                     }
                 }
             }
                 
             i++;
         }
         if(!lbudgetLine.isEmpty()){
            try{
             update lbudgetLine;
             oldbdgli.remove(j);
             delete delbdgli;
             }catch(Exception e){
                ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Oops! Something went wrong. Please verify the details and cost center should be active');
                ApexPages.addMessage(myMsg1); 
            }
         }
     }
     
     
     Public void oldsaveNlock(){         
         integer i = 0 ;
         integer j = 0;
         lbudgetLine = new List<DRDW_Budget_Line_Item__c>();
         delbdgli = new List<DRDW_Bdg_LI_Data_load__c>();
         for(DRDW_Bdg_LI_Data_load__c oldbd : oldbdgli){
             
             if(oldbd.id == RecId){
                 if(oldbd.Related_To__c == NULL || oldbd.Posting_Date__c == NULL || oldbd.PO__c == NULL || oldbd.Actual_Amount__c  == NULL|| oldbd.DRDW_Cost_Center__c == NULL || (oldbd.Project_Idea__c == NULL || oldbd.DRDW_Cost_Center__c == NULL)){
                    ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'In order to save, please update blank field values.');
                    ApexPages.addMessage(myMsg1); 
                 }else{
                     if(mBudget.ContainsKey(oldbd.Related_To__c) && mline.containsKey(oldbd.SAPIDPO__c)){
                          DRDW_Budget_Line_Item__c oldLineItem = new DRDW_Budget_Line_Item__c();
                          oldLineItem = (DRDW_Budget_Line_Item__c)mline.get(oldbd.SAPIDPO__c);
                          DRDW_Budget_Master__c oBudMaster = new DRDW_Budget_Master__c();
                          oBudMaster = (DRDW_Budget_Master__c)mBudget.get(oldbd.Related_To__c);
                          oldLineItem.PO__c = oBudMaster.PO__c;                          
                         oldLineItem.Project_Idea__c = oBudMaster.Related_To__c;
                         oldLineItem.PO_Description__c = oldbd.PO_Description__c;
                         oldLineItem.Actual_Amount__c = oldbd.Actual_Amount__c;
                         oldLineItem.Posting_Date__c = oldbd.Posting_Date__c;
                         oldLineItem.Vendor__c = oldbd.Vendor__c;
                         oldLineItem.Save_And_Lock__c = true;
                         lbudgetLine.add(oldLineItem);
                         j= i;
                         delbdgli.add(oldbd);
                     }
                 }
             }
                 i++;
         }
         if(!lbudgetLine.isEmpty()){
         try{
             update lbudgetLine;
             oldbdgli.remove(j);
             delete delbdgli;
             }catch(Exception e){
                ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Oops! Something went wrong. Please verify the details and cost center should be active');
                ApexPages.addMessage(myMsg1); 
            }
         }       
     }
     
     Public void DeleteoldBdg(){
        integer i = 0 ;
        integer j = 0;
        delbdgli = new List<DRDW_Bdg_LI_Data_load__c>();
          for(DRDW_Bdg_LI_Data_load__c oldbd : oldbdgli){
              
              if(oldbd.id == RecId){
                  delbdgli.add(oldbd);
                  j=i;
              }
              i++;
          }
          if(!delbdgli.isEmpty()){
              oldbdgli.remove(j);
              delete delbdgli;
          }
     }
     
}