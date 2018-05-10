Public without sharing Class DRDW_DataLoad{

    Public String Dataload{get;set;}
    Public Blob csvFileBody{get;set;}
    Public String[] readData{get;set;}
    Public String[] fieldName{get;set;}
    
    Public DRDW_DataLoad(){
        Dataload = '';
        readData = new String[]{};
        fieldName = new String[]{};
        
    }
    
    Public PageReference redirect(){
        List<DRDW_Bdg_LI_Data_load__c> loldbdg = new List<DRDW_bdg_LI_Data_load__c>([Select id from DRDW_Bdg_LI_Data_load__c]);
        if(!loldbdg.isEmpty()){
            PageReference pageref = new PageReference('/apex/DRDW_SaveBudgetLine');
            pageref.setredirect(true);
            return pageref;
        }else{
            return null;
        }
    }
    
    Public PageReference readCsv(){          
          String csvdata;
          Map<String,Integer> mfields = new Map<String,Integer>();
          
        try{ 
              csvdata = csvFileBody.toString();
              readData = csvdata.split('\n');
              
              string[] csvFieldNames = readData[0].split(',');
              List<DRDW_Bdg_LI_Data_load__c> lstBlDL = new List<DRDW_Bdg_LI_Data_load__c>();
              
              For(Integer i = 0; i < csvFieldNames.size(); i++){
                  mfields.put(csvFieldNames[i],i);
              }             
              
              For(Integer i = 1; i < readData.size(); i++){
                  DRDW_Bdg_LI_Data_load__c bldl = new DRDW_Bdg_LI_Data_load__c();
                   Integer startIndex;
                   Integer endIndex;
                  
                  while(readData[i].indexOf('"') > -1){
                 

                    if(startIndex == null){
                        startIndex = readData[i].indexOf('"');                        
                         readData[i] = readData[i].substring(0, startIndex) + ':quotes:' + readData[i].substring(startIndex+1, readData[i].length());
                        }else{
                            if(endIndex == null){
                                system.debug('endIndex ' + endIndex);
                                endIndex = readData[i].indexOf('"');
                                System.debug(readData[i].substring(0, endIndex));
                                System.debug(readData[i].substring(endIndex+1, readData[i].length()));
                                readData[i] = readData[i].substring(0, endIndex) + ':quotes:' + readData[i].substring(endIndex+1, readData[i].length());
                            }
                        }
                        if(startIndex != null && endIndex != null){
                            String sub = readData[i].substring(startIndex, endIndex);
                            sub = sub.replaceAll(',', ':comma:');
                            readData[i] = readData[i].substring(0, startIndex) + sub + readData[i].substring(endIndex, readData[i].length());
                            startIndex = null;
                            endIndex = null;
                        }
                    }
                    
                                  
                  String[] csvRowData = readData[i].Split(',');
                  
                  For(Integer j = 0; j < csvRowData.size(); j++){
                      csvRowData[j] = csvRowData[j].replaceAll(':quotes:', '').replaceAll(':comma:', '');
                  }
                  
                  For(String data : csvFieldNames){
                      
                      integer fieldNumber = mfields.get(data);
                      String fieldValue = csvRowData[fieldNumber];
                      if(data == 'Posting_Date__c'){
                          bldl.put(data.trim(),date.parse(fieldValue.trim()));
                      }else if(data == 'Actual_Amount__c'){
                          fieldValue = fieldValue.removeEnd('"');
                          fieldValue = fieldValue.removeStart('"');
                          bldl.put(data.trim(),decimal.valueOf(fieldValue.trim()));
                      }else{
                          bldl.put(data.trim(),fieldValue.trim());
                       }   
                  }
                  lstBlDL.add(bldl);
              }
              
              //List<DRDW_Bdg_LI_Data_load__c> loldbdg = new List<DRDW_bdg_LI_Data_load__c>([Select id,SAPIDPO__c from DRDW_bdg_LI_Data_load__c]); 
              Boolean isError = false;
              if(!lstBlDL.isEmpty()){
              for(integer i = 0; i< lstBlDL.size()-1; i++){
                      String sapid1 = lstBlDL[i].SAPID__c + lstBlDL[i].Posting_Row__c;
                      for(integer j = i+1; j< lstBlDL.size(); j++){
                          String sapid = lstBlDL[j].SAPID__c + lstBlDL[j].Posting_Row__c;
                          if(sapid == sapid1){
                              isError = true;                                                          
                          }
                      }
                  }
              }
              
              if(isError){
                  ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Your CSV file contains duplicate records.Please verify and upload it again');
                  ApexPages.addMessage(myMsg1);  
              }
              if(!lstBlDL.isEmpty() && !isError){
                  insert lstBlDL;
                   PageReference pageref = new PageReference('/apex/DRDW_SaveBudgetLine');
                   pageref.setredirect(true);
                   return pageref;
              }
              
              return null;
              
              
              
        }catch(Exception e){
            system.debug('Error ' + e);
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Oops! Something Went Wrong, Please verify CSV');
             ApexPages.addMessage(myMsg1);  
            return null;
        }
        
    }
    

}