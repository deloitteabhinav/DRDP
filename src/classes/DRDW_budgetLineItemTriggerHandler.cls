Public class DRDW_budgetLineItemTriggerHandler{
    

    public DRDW_budgetLineItemTriggerHandler(){
    }
    
   
   public Static void insertBudgetSummary(List<DRDW_Budget_Line_Item__c> lLineItems,Map<id,DRDW_Budget_Line_Item__c> mLineOld){
      Map<String,Map<integer,List<DRDW_Budget_Line_Item__c>>> mBudgetLineItem = new Map<String,Map<integer,List<DRDW_Budget_Line_Item__c>>>();
      list<Id> lMasterId = new List<id>();
      
      Map<id,List<DRDW_Budget_Summary__c>> mBudgetSummary = new Map<id,List<DRDW_Budget_Summary__c>>();
      //Set<String> syear = new Set<String>();
      Map<String,List<Id>> myear = new Map<String,List<Id>>();
      Map<Id,List<DRDW_Budget_Summary_Detail__c>> mBudgetSummaryDetails = new Map<Id,List<DRDW_Budget_Summary_Detail__c>>();
      List<DRDW_Budget_Summary__c> lSummary = new List<DRDW_Budget_Summary__c>();
      List<DRDW_Budget_Summary_Detail__c> lSumDetails = new List<DRDW_Budget_Summary_Detail__c>();
      
      For(DRDW_Budget_Line_Item__c bl : lLineItems){
          //syear.add(String.ValueOf(bl.Posting_Date__c.Year()));
          if(myear.containsKey(String.ValueOf(bl.Posting_Date__c.Year()))){
                myear.get(String.ValueOf(bl.Posting_Date__c.Year())).add(bl.Related_To__c);
            }else{
                myear.put(String.ValueOf(bl.Posting_Date__c.Year()),New List<Id>{bl.Related_To__c});
            }
          lMasterId.add(bl.Related_To__c);
      }
      
      If(!lMasterId.isEmpty()){
        if(!myear.isEmpty()){
            Set<String> SetYear = new Set<String>();            
            List<DRDW_Budget_Summary__c> lBudSummary = new List<DRDW_Budget_Summary__c>([Select id,Year__c,DRDW_Budget_Master__c from DRDW_Budget_Summary__c Where DRDW_Budget_Master__c IN: lMasterId]);
            if(!lBudSummary.isEmpty()){
                for(DRDW_Budget_Summary__c lbLine : lBudSummary){
                    SetYear.add(lbLine.Year__c);                    
                }               
            }
            
            List<DRDW_Budget_Summary__c> lbSy = new List<DRDW_Budget_Summary__c>();
            For(String s : myear.KeySet()){
                if(!SetYear.contains(s)){
                    for(Id bmId : myear.get(s)){
                        
                        DRDW_Budget_Summary__c q1bs = new DRDW_Budget_Summary__c(DRDW_Budget_Master__c = bmId,Quarter__c = '1',Year__c = s);
                        DRDW_Budget_Summary__c q2bs = new DRDW_Budget_Summary__c(DRDW_Budget_Master__c = bmId,Quarter__c = '2',Year__c = s);
                        DRDW_Budget_Summary__c q3bs = new DRDW_Budget_Summary__c(DRDW_Budget_Master__c = bmId,Quarter__c = '3',Year__c = s);
                        DRDW_Budget_Summary__c q4bs = new DRDW_Budget_Summary__c(DRDW_Budget_Master__c = bmId,Quarter__c = '4',Year__c = s);
                        lbSy.add(q1bs);
                        lbSy.add(q2bs);
                        lbSy.add(q3bs);
                        lbSy.add(q4bs);                      
                    }                                   
                }               
            }
            If(!lbSy.isEmpty()){
                insert lbSy;
            }
        }         
        
        
        //adding as part of defect 
      if(Trigger.isInsert){  
            
   List<String> qrter = new List<String>{'1','2','3','4'};
    List<String> months = new List<String>();
    
    
    List<DRDW_Budget_Summary__c> lbSummary = new List<DRDW_Budget_Summary__c>();
        lbSummary = [select id,Year__c,Quarter__c from DRDW_Budget_Summary__c where DRDW_Budget_Master__c    =:lMasterId];
        
    List<DRDW_Budget_Summary_Detail__c> lbDetails = new List<DRDW_Budget_Summary_Detail__c>();      
        lbDetails = [select id,Year__c,Month__c,Quarter__c from DRDW_Budget_Summary_Detail__c where DRDW_Budget_Summary__c =:lbSummary];
        
        Map<String,List<String>> summaryquartermap = new Map<String,List<String>>();
        Map<String,List<String>> detailmonthmap = new Map<String,List<String>>();
        Map<String,Id> summarymapid = new Map<String,Id>();
        
        
        for(DRDW_Budget_Summary__c b:lbSummary){
        
            if(!summaryquartermap.containsKey(b.Year__c)){
                List<String> s = new List<String>();                
                summaryquartermap.put(b.Year__c,s);
            }
            summaryquartermap.get(b.Year__c).add(b.Quarter__c);
            summarymapid.put(b.Year__c+'_'+b.Quarter__c,b.id);
        
        }
        
        
        for(DRDW_Budget_Summary_Detail__c d:lbDetails){
                
            String Key = d.Year__c+'_'+d.Quarter__c;
            
            if(!detailmonthmap.containsKey(Key)){
                List<String> s = new List<String>();                
                detailmonthmap.put(Key,s);
            }
            detailmonthmap.get(Key).add(d.Month__c);
        
        }
        
        
        List<DRDW_Budget_Summary__c> insertList = new List<DRDW_Budget_Summary__c>();
        List<DRDW_Budget_Summary_Detail__c> insertDetailList = new List<DRDW_Budget_Summary_Detail__c>();
        
        for(DRDW_Budget_Line_Item__c l:lLineItems){
            
            String year = String.valueOf(l.Posting_Date__c.Year());
            String Quarter = l.Quarter__c;
            
            String Key = Year+'_'+quarter;
            
            if(summaryquartermap.get(year).size()<4){
            
                
                
                for(String s: qrter){
                    
                    if(!summaryquartermap.get(year).contains(s)){
                    
                        DRDW_Budget_Summary__c b = new DRDW_Budget_Summary__c();
                        b.DRDW_Budget_Master__c = l.Related_To__c;
                        b.Quarter__c = s;
                        b.Year__c =year;
                        insertList.add(b);
                        summaryquartermap.get(year).add(s);
                    }
                    
                }                                                           
            
            }else{
            
                if( detailmonthmap.get(Key) == null || detailmonthmap.get(Key).size()<3){
                    
                    months = getCurrentMonths(Quarter);    
                        
                    for(String s:months){
                            
                            if(detailmonthmap.get(Key) == null || !detailmonthmap.get(Key).contains(s)){
                            DRDW_Budget_Summary_Detail__c d = new DRDW_Budget_Summary_Detail__c();
                            d.DRDW_Budget_Summary__c = summarymapid.get(Key);
                            d.Month__c = s;
                            d.Year__c = year;
                            d.Quarter__c = Quarter;
                            insertDetailList.add(d);
                            if(detailmonthmap.get(Key) != null)
                            detailmonthmap.get(Key).add(s);
                            
                            }
                        
                    }
                        
                }
            
            
            }
            
            
        
        }
        
        insert insertList;
        insert insertDetailList;
        }
        
        // added till here
        
        
        
        List<DRDW_Budget_Summary__c> lBudgetSummary = new List<DRDW_Budget_Summary__c>([Select id,Q_Actual__c,Quarter__c,Year__c,Q_Total_Actuals__c,DRDW_Budget_Master__c from DRDW_Budget_Summary__c Where DRDW_Budget_Master__c IN: lMasterId]);
        
        For(DRDW_Budget_Summary__c bS : lBudgetSummary){
            If(mBudgetSummary.ContainsKey(bS.DRDW_Budget_Master__c)){
                mBudgetSummary.get(bS.DRDW_Budget_Master__c).add(bS);
             }else{
                 mBudgetSummary.put(bS.DRDW_Budget_Master__c, new List<DRDW_Budget_Summary__c>{bs});
             }   
        }
        
        if(!lBudgetSummary.isEmpty()){
        List<DRDW_Budget_Summary_Detail__c> lBudgetSumDetails = new List<DRDW_Budget_Summary_Detail__c>([Select id,Month__c,Year__c,M_Actual__c,DRDW_Budget_Summary__c From DRDW_Budget_Summary_Detail__c where DRDW_Budget_Summary__c IN: lBudgetSummary]);
            
        for(DRDW_Budget_Summary_Detail__c bsD : lBudgetSumDetails){
            If(mBudgetSummaryDetails.containsKey(bsD.DRDW_Budget_Summary__c)){
                mBudgetSummaryDetails.get(bsD.DRDW_Budget_Summary__c).add(bsD);
            }else{
                mBudgetSummaryDetails.put(bsD.DRDW_Budget_Summary__c,New List<DRDW_Budget_Summary_Detail__c>{bsD});
            }
        }
    
        }
        }
      
      For(DRDW_Budget_Line_Item__c budgetline : [Select Actual_Amount__c,Accrual__c,Related_To__c,id,Posting_Date__c from DRDW_Budget_Line_Item__c where Related_To__c IN: lMasterId]){
          System.debug('*****'+ budgetline.Posting_Date__c);
           system.debug('DetailLine+++++++'+budgetline);
          Integer Month = budgetline.Posting_Date__c.month();
          Integer Year = budgetline.Posting_Date__c.Year();
          
          if(month < 4){
              if(mBudgetLineItem.ContainsKey('Q1'+Year)){
                  if(mBudgetLineItem.get('Q1'+Year).ContainsKey(month)){
                      mBudgetLineItem.get('Q1'+Year).get(month).add(budgetline);
                  }else{
                      mBudgetLineItem.get('Q1'+Year).put(month,New List<DRDW_Budget_Line_Item__c>{budgetline});
                  }
              }else{
                  mBudgetLineItem.put('Q1'+Year,new Map<integer,List<DRDW_Budget_Line_Item__c>>{month=>New List<DRDW_Budget_Line_Item__c>{budgetline}});
              }    
          }else if(month > 3 && month < 7){
              if(mBudgetLineItem.ContainsKey('Q2'+Year)){
                  if(mBudgetLineItem.get('Q2'+Year).ContainsKey(month)){
                      mBudgetLineItem.get('Q2'+Year).get(month).add(budgetline);
                  }else{
                      mBudgetLineItem.get('Q2'+Year).put(month,New List<DRDW_Budget_Line_Item__c>{budgetline});
                  }
              }else{
                  mBudgetLineItem.put('Q2'+Year,new Map<integer,List<DRDW_Budget_Line_Item__c>>{month=>New List<DRDW_Budget_Line_Item__c>{budgetline}});
              }  
          }else if(month > 6 && month < 10){
              if(mBudgetLineItem.ContainsKey('Q3'+Year)){
                  if(mBudgetLineItem.get('Q3'+Year).ContainsKey(month)){
                      mBudgetLineItem.get('Q3'+Year).get(month).add(budgetline);
                  }else{
                      mBudgetLineItem.get('Q3'+Year).put(month,New List<DRDW_Budget_Line_Item__c>{budgetline});
                  }
              }else{
                  mBudgetLineItem.put('Q3'+Year,new Map<integer,List<DRDW_Budget_Line_Item__c>>{month=>New List<DRDW_Budget_Line_Item__c>{budgetline}});
              }  
          }else if(month > 9){
              if(mBudgetLineItem.ContainsKey('Q4'+Year)){
                  if(mBudgetLineItem.get('Q4'+Year).ContainsKey(month)){
                      mBudgetLineItem.get('Q4'+Year).get(month).add(budgetline);
                  }else{
                      mBudgetLineItem.get('Q4'+Year).put(month,New List<DRDW_Budget_Line_Item__c>{budgetline});
                  }
              }else{
                  mBudgetLineItem.put('Q4'+Year,new Map<integer,List<DRDW_Budget_Line_Item__c>>{month=>New List<DRDW_Budget_Line_Item__c>{budgetline}});
              }  
          }         
          
      }
      
      
      
      for(Id ids : lMasterId){
          for(DRDW_Budget_Summary__c bs : mBudgetSummary.get(ids)){
            for(DRDW_Budget_Summary_Detail__c bcd : mBudgetSummaryDetails.get(bs.id)){
                if(bcd.Month__c == 'Jan'){
                    
                    if(mBudgetLineItem.ContainsKey('Q1'+bcd.Year__c) && mBudgetLineItem.get('Q1'+bcd.Year__c).containsKey(1)){
                        bcd.M_Actual__c = 0;
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q1'+bcd.Year__c).get(1)){
                            bcd.M_Actual__c = bcd.M_Actual__c + bli.Actual_Amount__c;
                        }
                    }
                }else if(bcd.Month__c == 'Feb'){
                    
                    if(mBudgetLineItem.ContainsKey('Q1'+bcd.Year__c) && mBudgetLineItem.get('Q1'+bcd.Year__c).containsKey(2)){
                        bcd.M_Actual__c = 0;
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q1'+bcd.Year__c).get(2)){
                            bcd.M_Actual__c = bcd.M_Actual__c + bli.Actual_Amount__c;
                        }
                    }
                }else if(bcd.Month__c == 'March'){
                    
                    if(mBudgetLineItem.ContainsKey('Q1'+bcd.Year__c) && mBudgetLineItem.get('Q1'+bcd.Year__c).containsKey(3)){
                        bcd.M_Actual__c = 0;
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q1'+bcd.Year__c).get(3)){
                            bcd.M_Actual__c = bcd.M_Actual__c + bli.Actual_Amount__c;
                        }
                    }
                }else if(bcd.Month__c == 'April'){
                    if(mBudgetLineItem.ContainsKey('Q2'+bcd.Year__c) && mBudgetLineItem.get('Q2'+bcd.Year__c).containsKey(4)){
                        bcd.M_Actual__c = 0;
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q2'+bcd.Year__c).get(4)){
                            bcd.M_Actual__c = bcd.M_Actual__c + bli.Actual_Amount__c;
                        }
                    }   
                }else if(bcd.Month__c == 'May'){
                    if(mBudgetLineItem.ContainsKey('Q2'+bcd.Year__c) && mBudgetLineItem.get('Q2'+bcd.Year__c).containsKey(5)){
                        bcd.M_Actual__c = 0;
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q2'+bcd.Year__c).get(5)){
                            bcd.M_Actual__c = bcd.M_Actual__c + bli.Actual_Amount__c;
                        }
                    }                   
                }else if(bcd.Month__c == 'June'){
                    if(mBudgetLineItem.ContainsKey('Q2'+bcd.Year__c) && mBudgetLineItem.get('Q2'+bcd.Year__c).containsKey(6)){
                        bcd.M_Actual__c = 0;
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q2'+bcd.Year__c).get(6)){
                            bcd.M_Actual__c = bcd.M_Actual__c + bli.Actual_Amount__c;
                        }
                    }
                }else if(bcd.Month__c == 'July'){
                    if(mBudgetLineItem.ContainsKey('Q3'+bcd.Year__c) && mBudgetLineItem.get('Q3'+bcd.Year__c).containsKey(7)){
                        bcd.M_Actual__c = 0;
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q3'+bcd.Year__c).get(7)){
                            bcd.M_Actual__c = bcd.M_Actual__c + bli.Actual_Amount__c;
                        }
                    }
                }else if(bcd.Month__c == 'Aug'){
                    if(mBudgetLineItem.ContainsKey('Q3'+bcd.Year__c) && mBudgetLineItem.get('Q3'+bcd.Year__c).containsKey(8)){
                        bcd.M_Actual__c = 0;
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q3'+bcd.Year__c).get(8)){
                            bcd.M_Actual__c = bcd.M_Actual__c + bli.Actual_Amount__c;
                        }
                    }
                }else if(bcd.Month__c == 'Sept'){
                    if(mBudgetLineItem.ContainsKey('Q3'+bcd.Year__c) && mBudgetLineItem.get('Q3'+bcd.Year__c).containsKey(9)){
                        bcd.M_Actual__c = 0;
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q3'+bcd.Year__c).get(9)){
                            bcd.M_Actual__c = bcd.M_Actual__c + bli.Actual_Amount__c;
                        }
                    }
                }else if(bcd.Month__c == 'Oct'){
                    if(mBudgetLineItem.ContainsKey('Q4'+bcd.Year__c) && mBudgetLineItem.get('Q4'+bcd.Year__c).containsKey(10)){
                        bcd.M_Actual__c = 0;
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q4'+bcd.Year__c).get(10)){
                            bcd.M_Actual__c = bcd.M_Actual__c + bli.Actual_Amount__c;
                        }
                    }
                }else if(bcd.Month__c == 'Nov'){
                    if(mBudgetLineItem.ContainsKey('Q4'+bcd.Year__c) && mBudgetLineItem.get('Q4'+bcd.Year__c).containsKey(11)){
                        bcd.M_Actual__c = 0;
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q4'+bcd.Year__c).get(11)){
                            bcd.M_Actual__c = bcd.M_Actual__c + bli.Actual_Amount__c;
                        }
                    }
                }else if(bcd.Month__c == 'Dec'){
                    if(mBudgetLineItem.ContainsKey('Q4'+bcd.Year__c) && mBudgetLineItem.get('Q4'+bcd.Year__c).containsKey(12)){
                        bcd.M_Actual__c = 0;
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q4'+bcd.Year__c).get(12)){
                            bcd.M_Actual__c = bcd.M_Actual__c + bli.Actual_Amount__c;
                        }
                    }   
                }  
                bcd.M_Actual__c = bcd.M_Actual__c.round(System.RoundingMode.HALF_EVEN);             
            }
                if(bs.Quarter__c == '1'){
                    bs.Q_Total_Actuals__c = 0;
                    bs.Q_Actual__c = 0;
                    if(mBudgetLineItem.ContainsKey('Q1'+bs.Year__c) && mBudgetLineItem.get('Q1'+bs.Year__c).containsKey(1)){
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q1'+bs.Year__c).get(1)){
                            if(!bli.Accrual__c){
                                bs.Q_Actual__c = bs.Q_Actual__c + bli.Actual_Amount__c;
                            }
                            bs.Q_Total_Actuals__c = bs.Q_Total_Actuals__c + bli.Actual_Amount__c;
                        }
                    }
                    if(mBudgetLineItem.ContainsKey('Q1'+bs.Year__c) && mBudgetLineItem.get('Q1'+bs.Year__c).containsKey(2)){
                        
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q1'+bs.Year__c).get(2)){
                            if(!bli.Accrual__c){
                                bs.Q_Actual__c = bs.Q_Actual__c + bli.Actual_Amount__c;
                            }
                            bs.Q_Total_Actuals__c = bs.Q_Total_Actuals__c + bli.Actual_Amount__c;
                        }
                    }
                    if(mBudgetLineItem.ContainsKey('Q1'+bs.Year__c) && mBudgetLineItem.get('Q1'+bs.Year__c).containsKey(3)){
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q1'+bs.Year__c).get(3)){
                            if(!bli.Accrual__c){
                                bs.Q_Actual__c = bs.Q_Actual__c + bli.Actual_Amount__c;
                            }
                            bs.Q_Total_Actuals__c = bs.Q_Total_Actuals__c + bli.Actual_Amount__c;
                        }
                    }
                }else if(bs.Quarter__c == '2'){
                    bs.Q_Total_Actuals__c = 0;
                    bs.Q_Actual__c = 0;
                    if(mBudgetLineItem.ContainsKey('Q2'+bs.Year__c) && mBudgetLineItem.get('Q2'+bs.Year__c).containsKey(4)){
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q2'+bs.Year__c).get(4)){
                            if(!bli.Accrual__c){
                                bs.Q_Actual__c = bs.Q_Actual__c + bli.Actual_Amount__c;
                            }
                            bs.Q_Total_Actuals__c = bs.Q_Total_Actuals__c + bli.Actual_Amount__c;
                        }
                    }
                    if(mBudgetLineItem.ContainsKey('Q2'+bs.Year__c) && mBudgetLineItem.get('Q2'+bs.Year__c).containsKey(5)){
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q2'+bs.Year__c).get(5)){
                            if(!bli.Accrual__c){
                                bs.Q_Actual__c = bs.Q_Actual__c + bli.Actual_Amount__c;
                            }
                            bs.Q_Total_Actuals__c = bs.Q_Total_Actuals__c + bli.Actual_Amount__c;
                        }
                    }
                    if(mBudgetLineItem.ContainsKey('Q2'+bs.Year__c) && mBudgetLineItem.get('Q2'+bs.Year__c).containsKey(6)){
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q2'+bs.Year__c).get(6)){
                            if(!bli.Accrual__c){
                                bs.Q_Actual__c = bs.Q_Actual__c + bli.Actual_Amount__c;
                            }
                            bs.Q_Total_Actuals__c = bs.Q_Total_Actuals__c + bli.Actual_Amount__c;
                        }
                    }
                }else if(bs.Quarter__c == '3'){
                    bs.Q_Total_Actuals__c = 0;
                    bs.Q_Actual__c = 0;
                    if(mBudgetLineItem.ContainsKey('Q3'+bs.Year__c) && mBudgetLineItem.get('Q3'+bs.Year__c).containsKey(7)){
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q3'+bs.Year__c).get(7)){
                            if(!bli.Accrual__c){
                                bs.Q_Actual__c = bs.Q_Actual__c + bli.Actual_Amount__c;
                            }
                            bs.Q_Total_Actuals__c = bs.Q_Total_Actuals__c + bli.Actual_Amount__c;
                        }
                    }
                    if(mBudgetLineItem.ContainsKey('Q3'+bs.Year__c) && mBudgetLineItem.get('Q3'+bs.Year__c).containsKey(8)){
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q3'+bs.Year__c).get(8)){
                            if(!bli.Accrual__c){
                                bs.Q_Actual__c = bs.Q_Actual__c + bli.Actual_Amount__c;
                            }
                            bs.Q_Total_Actuals__c = bs.Q_Total_Actuals__c + bli.Actual_Amount__c;
                        }
                    }
                    if(mBudgetLineItem.ContainsKey('Q3'+bs.Year__c) && mBudgetLineItem.get('Q3'+bs.Year__c).containsKey(9)){
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q3'+bs.Year__c).get(9)){
                            if(!bli.Accrual__c){
                                bs.Q_Actual__c = bs.Q_Actual__c + bli.Actual_Amount__c;
                            }
                            bs.Q_Total_Actuals__c = bs.Q_Total_Actuals__c + bli.Actual_Amount__c;
                        }
                    }
                }else if(bs.Quarter__c == '4'){
                    bs.Q_Total_Actuals__c = 0;
                    bs.Q_Actual__c = 0;
                    if(mBudgetLineItem.ContainsKey('Q4'+bs.Year__c) && mBudgetLineItem.get('Q4'+bs.Year__c).containsKey(10)){
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q4'+bs.Year__c).get(10)){
                            if(!bli.Accrual__c){
                                bs.Q_Actual__c = bs.Q_Actual__c + bli.Actual_Amount__c;
                            }
                            bs.Q_Total_Actuals__c = bs.Q_Total_Actuals__c + bli.Actual_Amount__c;
                        }
                    }
                    if(mBudgetLineItem.ContainsKey('Q4'+bs.Year__c) && mBudgetLineItem.get('Q4'+bs.Year__c).containsKey(11)){
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q4'+bs.Year__c).get(11)){
                            if(!bli.Accrual__c){
                                bs.Q_Actual__c = bs.Q_Actual__c + bli.Actual_Amount__c;
                            }
                            bs.Q_Total_Actuals__c = bs.Q_Total_Actuals__c + bli.Actual_Amount__c;
                        }
                    }
                    if(mBudgetLineItem.ContainsKey('Q4'+bs.Year__c) && mBudgetLineItem.get('Q4'+bs.Year__c).containsKey(12)){
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q4'+bs.Year__c).get(12)){
                            if(!bli.Accrual__c){
                                bs.Q_Actual__c = bs.Q_Actual__c + bli.Actual_Amount__c;
                            }
                            bs.Q_Total_Actuals__c = bs.Q_Total_Actuals__c + bli.Actual_Amount__c;
                        }
                    }
                }   

                bs.Q_Total_Actuals__c = bs.Q_Total_Actuals__c.round(System.RoundingMode.HALF_EVEN);        
            
          }
      }
      
      For(Id ids : mBudgetSummary.keyset()){
            lSummary.addAll(mBudgetSummary.get(ids));
        }       
        
        
        For(Id ids : mBudgetSummaryDetails.keyset()){
            lSumDetails.addAll(mBudgetSummaryDetails.get(ids));
        }
        
        if(!lSummary.isEmpty() && lSummary != NULL){
            update lSummary;
        }
        if(!lSumDetails.isEmpty() && lSumDetails != NULL){
           update lSumDetails;
        }
        system.debug('Detail+++++++'+lSumDetails);
      
   } 
   
   public void onBeforeInsert(List<DRDW_Budget_Line_Item__c> NewLineitemList){
     List<DRDW_Budget_Line_Item__c> lbudLineItems = new List<DRDW_Budget_Line_Item__c>();  
        //Changing the currency ISO for all Budget Master records getting inserted  
            for(DRDW_Budget_Line_Item__c oLineitem : NewLineitemList){
                oLineitem.CurrencyIsoCode = Label.DRDW_Currency_Label;
                lbudLineItems.add(oLineitem);
            }
        /* updating the records if not null
        if(!lbudLineItems.isEmpty() && lbudLineItems != null){
            update lbudLineItems;
        }  */      
        
    }
    
    
    
       public Static void deleteBudgetSummary(List<DRDW_Budget_Line_Item__c> lLineItems,Map<id,DRDW_Budget_Line_Item__c> mLineOld){
      Map<String,Map<integer,List<DRDW_Budget_Line_Item__c>>> mBudgetLineItem = new Map<String,Map<integer,List<DRDW_Budget_Line_Item__c>>>();
      list<Id> lMasterId = new List<id>();
      
      Map<id,List<DRDW_Budget_Summary__c>> mBudgetSummary = new Map<id,List<DRDW_Budget_Summary__c>>();
      //Set<String> syear = new Set<String>();
      Map<String,List<Id>> myear = new Map<String,List<Id>>();
      Map<Id,List<DRDW_Budget_Summary_Detail__c>> mBudgetSummaryDetails = new Map<Id,List<DRDW_Budget_Summary_Detail__c>>();
      List<DRDW_Budget_Summary__c> lSummary = new List<DRDW_Budget_Summary__c>();
      List<DRDW_Budget_Summary_Detail__c> lSumDetails = new List<DRDW_Budget_Summary_Detail__c>();
      
      For(DRDW_Budget_Line_Item__c bl : lLineItems){
          //syear.add(String.ValueOf(bl.Posting_Date__c.Year()));
          if(myear.containsKey(String.ValueOf(bl.Posting_Date__c.Year()))){
                myear.get(String.ValueOf(bl.Posting_Date__c.Year())).add(bl.Related_To__c);
            }else{
                myear.put(String.ValueOf(bl.Posting_Date__c.Year()),New List<Id>{bl.Related_To__c});
            }
          lMasterId.add(bl.Related_To__c);
      }
      
      If(!lMasterId.isEmpty()){
        if(!myear.isEmpty()){
            Set<String> SetYear = new Set<String>();            
            List<DRDW_Budget_Summary__c> lBudSummary = new List<DRDW_Budget_Summary__c>([Select id,Year__c,DRDW_Budget_Master__c from DRDW_Budget_Summary__c Where DRDW_Budget_Master__c IN: lMasterId]);
               
               
        
        
        
        List<DRDW_Budget_Summary__c> lBudgetSummary = new List<DRDW_Budget_Summary__c>([Select id,Q_Actual__c,Quarter__c,Year__c,Q_Total_Actuals__c,DRDW_Budget_Master__c from DRDW_Budget_Summary__c Where DRDW_Budget_Master__c IN: lMasterId]);
        
        For(DRDW_Budget_Summary__c bS : lBudgetSummary){
            If(mBudgetSummary.ContainsKey(bS.DRDW_Budget_Master__c)){
                mBudgetSummary.get(bS.DRDW_Budget_Master__c).add(bS);
             }else{
                 mBudgetSummary.put(bS.DRDW_Budget_Master__c, new List<DRDW_Budget_Summary__c>{bs});
             }   
        }
        
        if(!lBudgetSummary.isEmpty()){
        List<DRDW_Budget_Summary_Detail__c> lBudgetSumDetails = new List<DRDW_Budget_Summary_Detail__c>([Select id,Month__c,Year__c,M_Actual__c,DRDW_Budget_Summary__c From DRDW_Budget_Summary_Detail__c where DRDW_Budget_Summary__c IN: lBudgetSummary]);
            
        for(DRDW_Budget_Summary_Detail__c bsD : lBudgetSumDetails){
            If(mBudgetSummaryDetails.containsKey(bsD.DRDW_Budget_Summary__c)){
                mBudgetSummaryDetails.get(bsD.DRDW_Budget_Summary__c).add(bsD);
            }else{
                mBudgetSummaryDetails.put(bsD.DRDW_Budget_Summary__c,New List<DRDW_Budget_Summary_Detail__c>{bsD});
            }
        }
    
        }
        }
      
      For(DRDW_Budget_Line_Item__c budgetline : lLineItems){
          System.debug('*****'+ budgetline.Posting_Date__c);
           system.debug('DetailLine+++++++'+budgetline);
          Integer Month = budgetline.Posting_Date__c.month();
          Integer Year = budgetline.Posting_Date__c.Year();
          
          if(month < 4){
              if(mBudgetLineItem.ContainsKey('Q1'+Year)){
                  if(mBudgetLineItem.get('Q1'+Year).ContainsKey(month)){
                      mBudgetLineItem.get('Q1'+Year).get(month).add(budgetline);
                  }else{
                      mBudgetLineItem.get('Q1'+Year).put(month,New List<DRDW_Budget_Line_Item__c>{budgetline});
                  }
              }else{
                  mBudgetLineItem.put('Q1'+Year,new Map<integer,List<DRDW_Budget_Line_Item__c>>{month=>New List<DRDW_Budget_Line_Item__c>{budgetline}});
              }    
          }else if(month > 3 && month < 7){
              if(mBudgetLineItem.ContainsKey('Q2'+Year)){
                  if(mBudgetLineItem.get('Q2'+Year).ContainsKey(month)){
                      mBudgetLineItem.get('Q2'+Year).get(month).add(budgetline);
                  }else{
                      mBudgetLineItem.get('Q2'+Year).put(month,New List<DRDW_Budget_Line_Item__c>{budgetline});
                  }
              }else{
                  mBudgetLineItem.put('Q2'+Year,new Map<integer,List<DRDW_Budget_Line_Item__c>>{month=>New List<DRDW_Budget_Line_Item__c>{budgetline}});
              }  
          }else if(month > 6 && month < 10){
              if(mBudgetLineItem.ContainsKey('Q3'+Year)){
                  if(mBudgetLineItem.get('Q3'+Year).ContainsKey(month)){
                      mBudgetLineItem.get('Q3'+Year).get(month).add(budgetline);
                  }else{
                      mBudgetLineItem.get('Q3'+Year).put(month,New List<DRDW_Budget_Line_Item__c>{budgetline});
                  }
              }else{
                  mBudgetLineItem.put('Q3'+Year,new Map<integer,List<DRDW_Budget_Line_Item__c>>{month=>New List<DRDW_Budget_Line_Item__c>{budgetline}});
              }  
          }else if(month > 9){
              if(mBudgetLineItem.ContainsKey('Q4'+Year)){
                  if(mBudgetLineItem.get('Q4'+Year).ContainsKey(month)){
                      mBudgetLineItem.get('Q4'+Year).get(month).add(budgetline);
                  }else{
                      mBudgetLineItem.get('Q4'+Year).put(month,New List<DRDW_Budget_Line_Item__c>{budgetline});
                  }
              }else{
                  mBudgetLineItem.put('Q4'+Year,new Map<integer,List<DRDW_Budget_Line_Item__c>>{month=>New List<DRDW_Budget_Line_Item__c>{budgetline}});
              }  
          }         
          
      }
      
      
      
      for(Id ids : lMasterId){
          if( mBudgetSummary.get(ids)!=null)
          for(DRDW_Budget_Summary__c bs : mBudgetSummary.get(ids)){
              if(mBudgetSummaryDetails.get(bs.id)!=null)
            for(DRDW_Budget_Summary_Detail__c bcd : mBudgetSummaryDetails.get(bs.id)){
                if(bcd.Month__c == 'Jan'){
                    
                    if(mBudgetLineItem.ContainsKey('Q1'+bcd.Year__c) && mBudgetLineItem.get('Q1'+bcd.Year__c).containsKey(1)){
                      //  bcd.M_Actual__c = 0;
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q1'+bcd.Year__c).get(1)){
                            bcd.M_Actual__c = bcd.M_Actual__c - bli.Actual_Amount__c;
                        }
                    }
                }else if(bcd.Month__c == 'Feb'){
                    
                    if(mBudgetLineItem.ContainsKey('Q1'+bcd.Year__c) && mBudgetLineItem.get('Q1'+bcd.Year__c).containsKey(2)){
                    //    bcd.M_Actual__c = 0;
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q1'+bcd.Year__c).get(2)){
                            bcd.M_Actual__c = bcd.M_Actual__c - bli.Actual_Amount__c;
                        }
                    }
                }else if(bcd.Month__c == 'March'){
                    
                    if(mBudgetLineItem.ContainsKey('Q1'+bcd.Year__c) && mBudgetLineItem.get('Q1'+bcd.Year__c).containsKey(3)){
                      //  bcd.M_Actual__c = 0;
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q1'+bcd.Year__c).get(3)){
                            bcd.M_Actual__c = bcd.M_Actual__c - bli.Actual_Amount__c;
                        }
                    }
                }else if(bcd.Month__c == 'April'){
                    if(mBudgetLineItem.ContainsKey('Q2'+bcd.Year__c) && mBudgetLineItem.get('Q2'+bcd.Year__c).containsKey(4)){
                        //bcd.M_Actual__c = 0;
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q2'+bcd.Year__c).get(4)){
                            bcd.M_Actual__c = bcd.M_Actual__c - bli.Actual_Amount__c;
                        }
                    }   
                }else if(bcd.Month__c == 'May'){
                    if(mBudgetLineItem.ContainsKey('Q2'+bcd.Year__c) && mBudgetLineItem.get('Q2'+bcd.Year__c).containsKey(5)){
                       // bcd.M_Actual__c = 0;
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q2'+bcd.Year__c).get(5)){
                            bcd.M_Actual__c = bcd.M_Actual__c - bli.Actual_Amount__c;
                        }
                    }                   
                }else if(bcd.Month__c == 'June'){
                    if(mBudgetLineItem.ContainsKey('Q2'+bcd.Year__c) && mBudgetLineItem.get('Q2'+bcd.Year__c).containsKey(6)){
                      //  bcd.M_Actual__c = 0;
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q2'+bcd.Year__c).get(6)){
                            bcd.M_Actual__c = bcd.M_Actual__c - bli.Actual_Amount__c;
                        }
                    }
                }else if(bcd.Month__c == 'July'){
                    if(mBudgetLineItem.ContainsKey('Q3'+bcd.Year__c) && mBudgetLineItem.get('Q3'+bcd.Year__c).containsKey(7)){
                      //  bcd.M_Actual__c = 0;
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q3'+bcd.Year__c).get(7)){
                            bcd.M_Actual__c = bcd.M_Actual__c - bli.Actual_Amount__c;
                        }
                    }
                }else if(bcd.Month__c == 'Aug'){
                    if(mBudgetLineItem.ContainsKey('Q3'+bcd.Year__c) && mBudgetLineItem.get('Q3'+bcd.Year__c).containsKey(8)){
                    //    bcd.M_Actual__c = 0;
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q3'+bcd.Year__c).get(8)){
                            bcd.M_Actual__c = bcd.M_Actual__c - bli.Actual_Amount__c;
                        }
                    }
                }else if(bcd.Month__c == 'Sept'){
                    if(mBudgetLineItem.ContainsKey('Q3'+bcd.Year__c) && mBudgetLineItem.get('Q3'+bcd.Year__c).containsKey(9)){
                     //   bcd.M_Actual__c = 0;
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q3'+bcd.Year__c).get(9)){
                            bcd.M_Actual__c = bcd.M_Actual__c - bli.Actual_Amount__c;
                        }
                    }
                }else if(bcd.Month__c == 'Oct'){
                    if(mBudgetLineItem.ContainsKey('Q4'+bcd.Year__c) && mBudgetLineItem.get('Q4'+bcd.Year__c).containsKey(10)){
                      //  bcd.M_Actual__c = 0;
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q4'+bcd.Year__c).get(10)){
                            bcd.M_Actual__c = bcd.M_Actual__c - bli.Actual_Amount__c;
                        }
                    }
                }else if(bcd.Month__c == 'Nov'){
                    if(mBudgetLineItem.ContainsKey('Q4'+bcd.Year__c) && mBudgetLineItem.get('Q4'+bcd.Year__c).containsKey(11)){
                     //   bcd.M_Actual__c = 0;
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q4'+bcd.Year__c).get(11)){
                            bcd.M_Actual__c = bcd.M_Actual__c - bli.Actual_Amount__c;
                        }
                    }
                }else if(bcd.Month__c == 'Dec'){
                    if(mBudgetLineItem.ContainsKey('Q4'+bcd.Year__c) && mBudgetLineItem.get('Q4'+bcd.Year__c).containsKey(12)){
                     //   bcd.M_Actual__c = 0;
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q4'+bcd.Year__c).get(12)){
                            bcd.M_Actual__c = bcd.M_Actual__c - bli.Actual_Amount__c;
                        }
                    }   
                }  
                bcd.M_Actual__c = bcd.M_Actual__c.round(System.RoundingMode.HALF_EVEN);             
            }
                if(bs.Quarter__c == '1'){
                 //   bs.Q_Total_Actuals__c = 0;
                 //   bs.Q_Actual__c = 0;
                    if(mBudgetLineItem.ContainsKey('Q1'+bs.Year__c) && mBudgetLineItem.get('Q1'+bs.Year__c).containsKey(1)){
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q1'+bs.Year__c).get(1)){
                            if(!bli.Accrual__c){
                                bs.Q_Actual__c = bs.Q_Actual__c - bli.Actual_Amount__c;
                            }
                            bs.Q_Total_Actuals__c = bs.Q_Total_Actuals__c - bli.Actual_Amount__c;
                        }
                    }
                    if(mBudgetLineItem.ContainsKey('Q1'+bs.Year__c) && mBudgetLineItem.get('Q1'+bs.Year__c).containsKey(2)){
                        
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q1'+bs.Year__c).get(2)){
                            if(!bli.Accrual__c){
                                bs.Q_Actual__c = bs.Q_Actual__c - bli.Actual_Amount__c;
                            }
                            bs.Q_Total_Actuals__c = bs.Q_Total_Actuals__c - bli.Actual_Amount__c;
                        }
                    }
                    if(mBudgetLineItem.ContainsKey('Q1'+bs.Year__c) && mBudgetLineItem.get('Q1'+bs.Year__c).containsKey(3)){
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q1'+bs.Year__c).get(3)){
                            if(!bli.Accrual__c){
                                bs.Q_Actual__c = bs.Q_Actual__c - bli.Actual_Amount__c;
                            }
                            bs.Q_Total_Actuals__c = bs.Q_Total_Actuals__c - bli.Actual_Amount__c;
                        }
                    }
                }else if(bs.Quarter__c == '2'){
                 //   bs.Q_Total_Actuals__c = 0;
                  //  bs.Q_Actual__c = 0;
                    if(mBudgetLineItem.ContainsKey('Q2'+bs.Year__c) && mBudgetLineItem.get('Q2'+bs.Year__c).containsKey(4)){
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q2'+bs.Year__c).get(4)){
                            if(!bli.Accrual__c){
                                bs.Q_Actual__c = bs.Q_Actual__c - bli.Actual_Amount__c;
                            }
                            bs.Q_Total_Actuals__c = bs.Q_Total_Actuals__c - bli.Actual_Amount__c;
                        }
                    }
                    if(mBudgetLineItem.ContainsKey('Q2'+bs.Year__c) && mBudgetLineItem.get('Q2'+bs.Year__c).containsKey(5)){
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q2'+bs.Year__c).get(5)){
                            if(!bli.Accrual__c){
                                bs.Q_Actual__c = bs.Q_Actual__c - bli.Actual_Amount__c;
                            }
                            bs.Q_Total_Actuals__c = bs.Q_Total_Actuals__c - bli.Actual_Amount__c;
                        }
                    }
                    if(mBudgetLineItem.ContainsKey('Q2'+bs.Year__c) && mBudgetLineItem.get('Q2'+bs.Year__c).containsKey(6)){
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q2'+bs.Year__c).get(6)){
                            if(!bli.Accrual__c){
                                bs.Q_Actual__c = bs.Q_Actual__c - bli.Actual_Amount__c;
                            }
                            bs.Q_Total_Actuals__c = bs.Q_Total_Actuals__c - bli.Actual_Amount__c;
                        }
                    }
                }else if(bs.Quarter__c == '3'){
                  //  bs.Q_Total_Actuals__c = 0;
                  //  bs.Q_Actual__c = 0;
                    if(mBudgetLineItem.ContainsKey('Q3'+bs.Year__c) && mBudgetLineItem.get('Q3'+bs.Year__c).containsKey(7)){
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q3'+bs.Year__c).get(7)){
                            if(!bli.Accrual__c){
                                bs.Q_Actual__c = bs.Q_Actual__c - bli.Actual_Amount__c;
                            }
                            bs.Q_Total_Actuals__c = bs.Q_Total_Actuals__c - bli.Actual_Amount__c;
                        }
                    }
                    if(mBudgetLineItem.ContainsKey('Q3'+bs.Year__c) && mBudgetLineItem.get('Q3'+bs.Year__c).containsKey(8)){
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q3'+bs.Year__c).get(8)){
                            if(!bli.Accrual__c){
                                bs.Q_Actual__c = bs.Q_Actual__c - bli.Actual_Amount__c;
                            }
                            bs.Q_Total_Actuals__c = bs.Q_Total_Actuals__c - bli.Actual_Amount__c;
                        }
                    }
                    if(mBudgetLineItem.ContainsKey('Q3'+bs.Year__c) && mBudgetLineItem.get('Q3'+bs.Year__c).containsKey(9)){
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q3'+bs.Year__c).get(9)){
                            if(!bli.Accrual__c){
                                bs.Q_Actual__c = bs.Q_Actual__c - bli.Actual_Amount__c;
                            }
                            bs.Q_Total_Actuals__c = bs.Q_Total_Actuals__c - bli.Actual_Amount__c;
                        }
                    }
                }else if(bs.Quarter__c == '4'){
                 //   bs.Q_Total_Actuals__c = 0;
                 //   bs.Q_Actual__c = 0;
                    if(mBudgetLineItem.ContainsKey('Q4'+bs.Year__c) && mBudgetLineItem.get('Q4'+bs.Year__c).containsKey(10)){
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q4'+bs.Year__c).get(10)){
                            if(!bli.Accrual__c){
                                bs.Q_Actual__c = bs.Q_Actual__c - bli.Actual_Amount__c;
                            }
                            bs.Q_Total_Actuals__c = bs.Q_Total_Actuals__c - bli.Actual_Amount__c;
                        }
                    }
                    if(mBudgetLineItem.ContainsKey('Q4'+bs.Year__c) && mBudgetLineItem.get('Q4'+bs.Year__c).containsKey(11)){
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q4'+bs.Year__c).get(11)){
                            if(!bli.Accrual__c){
                                bs.Q_Actual__c = bs.Q_Actual__c - bli.Actual_Amount__c;
                            }
                            bs.Q_Total_Actuals__c = bs.Q_Total_Actuals__c - bli.Actual_Amount__c;
                        }
                    }
                    if(mBudgetLineItem.ContainsKey('Q4'+bs.Year__c) && mBudgetLineItem.get('Q4'+bs.Year__c).containsKey(12)){
                        for(DRDW_Budget_Line_Item__c bli : mBudgetLineItem.get('Q4'+bs.Year__c).get(12)){
                            if(!bli.Accrual__c){
                                bs.Q_Actual__c = bs.Q_Actual__c - bli.Actual_Amount__c;
                            }
                            bs.Q_Total_Actuals__c = bs.Q_Total_Actuals__c - bli.Actual_Amount__c;
                        }
                    }
                }   

                bs.Q_Total_Actuals__c = bs.Q_Total_Actuals__c.round(System.RoundingMode.HALF_EVEN);        
            
          }
      }
      
      For(Id ids : mBudgetSummary.keyset()){
            lSummary.addAll(mBudgetSummary.get(ids));
        }       
        
        
        For(Id ids : mBudgetSummaryDetails.keyset()){
            lSumDetails.addAll(mBudgetSummaryDetails.get(ids));
        }
        
        if(!lSummary.isEmpty() && lSummary != NULL){
            update lSummary;
        }
        if(!lSumDetails.isEmpty() && lSumDetails != NULL){
           update lSumDetails;
        }
        system.debug('Detail+++++++'+lSumDetails);
      
   } 
   
   } 
    
     Public Static List<String> getCurrentMonths(String i){
    
        List<String> months = new List<String>();
        
        if(i=='1'){
        
          months.add('Jan');
               months.add('Feb');
                months.add('March');
        
        }else if(i=='2'){
        
             months.add('April');
               months.add('May');
                months.add('June');
            
        }else if(i=='3'){
        
             months.add('July');
               months.add('Aug');
                months.add('Sept');
         
        
        }else if(i=='4'){
        
             months.add('Oct');
               months.add('Nov');
                months.add('Dec');
            
        }
        
        return months;
        
    }
   
   
}