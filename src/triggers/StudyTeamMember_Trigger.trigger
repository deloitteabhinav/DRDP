trigger StudyTeamMember_Trigger on Study_Team_Members__c (after insert, after update) {
    
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        StudyTeamMember_TriggerHandler.createStudyTeamAllocation(Trigger.new);
        StudyTeamMember_TriggerHandler.updateOverAllocation(Trigger.new);
    }
}