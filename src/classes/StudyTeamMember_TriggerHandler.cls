public class StudyTeamMember_TriggerHandler {
    
    public static void createStudyTeamAllocation(List<Study_Team_Members__c> lStudyMembers) {
        List<Study_Team_Allocation_Per_Week__c> lOldAllocation = [Select Id from Study_Team_Allocation_Per_Week__c where Study_Team_Members__c IN :lStudyMembers];
        if(lOldAllocation.size() > 0) {
            delete lOldAllocation;
        }
        List<Study_Team_Allocation_Per_Week__c> lAllocation = new List<Study_Team_Allocation_Per_Week__c>();
        for(Study_Team_Members__c oMember : lStudyMembers) {
            Integer startWeek = Integer.valueOf(DateTime.newInstanceGmt(oMember.Start_Date__c.toStartOfWeek(), Time.NewInstance(12,0,0,0)).format('w'));
            Integer endWeek = Integer.valueOf(DateTime.newInstanceGmt(oMember.End_Date__c.toStartOfWeek(), Time.NewInstance(12,0,0,0)).format('w'));
            Integer startYear = oMember.Start_Date__c.year();
            Integer endYear = oMember.End_Date__c.year();
            Integer count = 0;
            for(Integer y = startYear;y <= endYear;y++) {
                for(Integer i = startWeek; i <= endWeek; i++) {
                    Study_Team_Allocation_Per_Week__c oAllocation = new Study_Team_Allocation_Per_Week__c();
                    oAllocation.Hours_per_Week__c = oMember.Forecast_Weekly_Hours__c;
                    oAllocation.Actual_Capacity__c = oMember.Actual_Weekly_Hours__c;
                    oAllocation.Study_Team_Members__c = oMember.Id;
                    oAllocation.Name = y+'-WEEK'+i;
                    oAllocation.Start_Date_of_Week__c = oMember.Start_Date__c.toStartOfWeek().addDays(count* 7);
                    lAllocation.add(oAllocation);
                    count++;
                }
            }
        }
        if(lAllocation.size() > 0) {
            insert lAllocation;
        }
    }
    
    public static Boolean isFirstTime = false;
    public static void updateOverAllocation(List<Study_Team_Members__c> lStudyMembers) {
        if(isFirstTime == false) {
            isFirstTime = true;
            List<AggregateResult> lResult = [SELECT Name week, Study_Team_Members__r.Team_Member__c member FROM Study_Team_Allocation_Per_Week__c group by Study_Team_Members__r.Team_Member__c,Name having Sum(Hours_per_Week__c) > 45];
            Set<String> sWeekMember = new Set<String>();
            Set<Id> sMember = new Set<Id>();
            if(lResult.size() > 0) {
                for(AggregateResult oResult : lResult) {
                    sWeekMember.add(oResult.get('week')+''+oResult.get('member'));
                    sMember.add(String.valueOf(oResult.get('member')));
                }
                List<Study_Team_Members__c> updateMembers = new List<Study_Team_Members__c>();
                Set<ID> sTeamMemberID = new Set<ID>();
                List<Study_Team_Allocation_Per_Week__c> lAllocation = [Select Id ,  Name, Study_Team_Members__r.Team_Member__c, Study_Team_Members__c from Study_Team_Allocation_Per_Week__c where Study_Team_Members__r.Team_Member__c IN :sMember];
                for(Study_Team_Allocation_Per_Week__c oWeekAllocation : lAllocation) {
                    if(sWeekMember.contains(oWeekAllocation.Name+oWeekAllocation.Study_Team_Members__r.Team_Member__c)) {
                        sTeamMemberID.add(oWeekAllocation.Study_Team_Members__c);
                    } 
                }
                for(ID studyTeamMemberID : sTeamMemberID) {
                    Study_Team_Members__c oMember = new Study_Team_Members__c();
                    oMember.Id = studyTeamMemberID;
                    updateMembers.add(oMember);
                }
                update lAllocation;
                update updateMembers;
            }
        }
    }
}