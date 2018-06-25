Public without sharing Class DRDW_DataLoad{

    Public String Dataload{get;set;}
    Public Blob csvFileBody{get;set;}
    Public String[] readData{get;set;}
    Public String[] fieldName{get;set;}
    Public List<Information_Landscape__c> lLandscapes {get; set;}
    Public List<landscapeWrapper> landscapeWrapperList{get;set;}
    Public List<landscapeWrapper> savedWrapperList{get;set;}
    Public Integer index{get;set;}
    Public Set<String> appNameSet{get;set;}
    
    Public DRDW_DataLoad(){
        lLandscapes = new List<Information_Landscape__c>();
        Dataload = '';
        readData = new String[]{};
        fieldName = new String[]{};
        
        landscapeWrapperList = new List<landscapeWrapper>();
        savedWrapperList = new List<landscapeWrapper>();
        appNameSet = new Set<String>();
    }
    
    Public PageReference redirect(){
        List<Information_Landscape__c> loldbdg = new List<Information_Landscape__c>([Select id from Information_Landscape__c]);
        if(!loldbdg.isEmpty()){
            PageReference pageref = new PageReference('/apex/DRDP_InformationLandscapeList');
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
              List<Information_Landscape__c> lstBlDL = new List<Information_Landscape__c>();
              
              For(Integer i = 0; i < csvFieldNames.size(); i++){
                  mfields.put(csvFieldNames[i],i);
              }             
              
              For(Integer i = 1; i < readData.size(); i++){
                  Information_Landscape__c bldl = new Information_Landscape__c();
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
                  system.debug('****** readData ' + readData);
                  for(String oString : csvRowData){
                      system.debug('************** ' + oString);
                  }
                  
                  For(Integer j = 0; j < csvRowData.size(); j++){
                      csvRowData[j] = csvRowData[j].replaceAll(':quotes:', '').replaceAll(':comma:', '');
                  }
                  
                  For(String data : csvFieldNames){
                      
                      integer fieldNumber = mfields.get(data);
                      String fieldValue = csvRowData[fieldNumber];
                      if(data=='Name'){
                          appNameSet.add(fieldValue.trim());
                      }                   
                      if(data == 'App_Disposition_Timeframe__c' || data == 'Contract_Termination_Date__c' ||  data == 'Effective_Date__c' || data == 'ERIM_Submission_Date__c'|| data == 'Target_Date__c' ){
                          try{
                          bldl.put(data.trim(),date.parse(fieldValue.trim()));
                          }catch(Exception e){                         
                                   bldl.put(data.trim(),date.valueOf(fieldValue.trim()));                              
                          }
                      }else if(data == 'Cost_of_this_purchase__c' ){
                          fieldValue = fieldValue.removeEnd('"');
                          fieldValue = fieldValue.removeStart('"');
                          bldl.put(data.trim(),decimal.valueOf(fieldValue.trim()));
                      }else{
                          bldl.put(data.trim(),fieldValue.trim());
                       }   
                  }
                  lstBlDL.add(bldl);
                 
              }
              
              //List<Information_Landscape__c> loldbdg = new List<Information_Landscape__c>([Select id,SAPIDPO__c from Information_Landscape__c]); 
              
              if(!lstBlDL.isEmpty()){
                 // insert lstBlDL;
                 // lLandscapes = [select id,Name from Information_Landscape__c where Id IN: lstBlDL];
                  
                //   PageReference pageref = new PageReference('/apex/DRDP_InformationLandscapeList');
                //   pageref.setredirect(true);
                //   return pageref;
                List<Information_Landscape__c> lLandscapesCheck = new List<Information_Landscape__c>();
                lLandscapesCheck = [select id, Name from Information_Landscape__c where Name in:appNameSet];
                Map<String,ID> mapNameID = new Map<String,Id>();
                
                for (Information_Landscape__c oLandscape : lLandscapesCheck) {
                          mapNameID.put(oLandscape.Name, oLandscape.Id);
                    }
                
                for(Information_Landscape__c oLandscape:lstBlDL){
                    if(mapNameID.containsKey(oLandscape.Name)){
                 landscapeWrapperList.add(new landscapeWrapper(false,oLandscape,landscapeWrapperList.size()+1,'Existing'));
                    }else{
                 landscapeWrapperList.add(new landscapeWrapper(false,oLandscape,landscapeWrapperList.size()+1,'New'));
                    }
                    }
              }
              
              return null;
              
              
              
        }catch(Exception e){
            system.debug('Error ' + e.getMessage());
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Oops! Something Went Wrong, Please verify CSV');
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , e.getMessage()));  
            return null;
        }
        
    }
    
    Public void saveLandscape(){
        for(landscapeWrapper olandscapeWrapper : landscapeWrapperList){
            Information_Landscape__c tempLandscape = olandscapeWrapper.oLandscape;
            if(olandscapeWrapper.index == index){
                    try{
                        insert tempLandscape;
                    }catch(Exception e){
                        system.debug(e);
                    }
                break;      
            }           
        }
        savedWrapperList.add(landscapeWrapperList.remove(index-1));
    }
    
    Public Void saveSelectedLandscape(){
        
        List<Information_Landscape__c> selectedList = new List<Information_Landscape__c>(); 
        List<landscapeWrapper> wrapperNotList = new List<landscapeWrapper>();                
        for(landscapeWrapper olandscapeWrapper : landscapeWrapperList){
            Information_Landscape__c tempLandscape = olandscapeWrapper.oLandscape;
            if(olandscapeWrapper.flag == true){                    
                        selectedList.add(tempLandscape);   
                        savedWrapperList.add(olandscapeWrapper); 
            }else{
                wrapperNotList.add(olandscapeWrapper);
            }
        }
        
        try{
            Database.upsert(selectedList,Information_Landscape__c.Fields.Name);
            landscapeWrapperList.clear();
            landscapeWrapperList.addAll(wrapperNotList);
        }catch(Exception e){
            System.debug(e);
        }           
    }
    
     Public void removeLandscape(){
        landscapeWrapperList.remove(index-1);
     }
    
    Public Class landscapeWrapper{
        
        public Boolean flag{get;set;}
        public Information_Landscape__c oLandscape{get;set;}
        public Integer index{get;set;}
        public String status{get;set;}
        Public landscapeWrapper(Boolean flag,Information_Landscape__c oLandscape,Integer index,String status){
            this.flag = flag;
            this.oLandscape = oLandscape;
            this.index = index;
            this.status = status;
        }
    
    }

}