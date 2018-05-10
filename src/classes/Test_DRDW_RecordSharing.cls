@isTest(SeeAllData = false)
public class Test_DRDW_RecordSharing {
    static testMethod void testRecordShare1() {
        User u = DRDW_TestDataFactory.getTestingUser();
        DRDW_TestDataFactory.givePermissions(u.id,'DRDW_Business_Admin');
        User u2 = DRDW_TestDataFactory.getTestingUser();
        DRDW_TestDataFactory.givePermissions(u2.id,'DRDW_Business_Admin');
        System.runAs(u) {
            List<DRDW_Project__c> lAllProjects = new List<DRDW_Project__c>();
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');
            system.assertNotEquals(lprojects.size(), 0);
            insert lprojects;
            List<DRDW_Project__c> lAssessments = DRDW_TestDataFactory.returnProjects(2,'Assessment Project');
            system.assertNotEquals(lAssessments.size(), 0);
            insert lAssessments;
            List<DRDW_Project__c> lIdeas = DRDW_TestDataFactory.returnProjects(2,'Idea');
            system.assertNotEquals(lIdeas.size(), 0);
            insert lIdeas;
            List<DRDW_Risk__c> lRisks = DRDW_TestDataFactory.returnRisks(2,lprojects[0].id);
            system.assertNotEquals(lRisks.size(), 0);
            insert lRisks;
            lAllProjects.addAll(lprojects);
            lAllProjects.addAll(lAssessments);
            lAllProjects.addAll(lIdeas);
            for(DRDW_Project__c oProject:lAllProjects ){
                oProject.Development_Team_Director__c=u2.id;
                oProject.Director__c=u2.id;
                oProject.ERL_Primary_Contact__c=u2.id;
                oProject.Global_Marketer__c=u2.id;
                oProject.Internal_Development_Partner__c=u2.id;
                oProject.Launch_Leader__c=u2.id;
                oProject.Lead_Finder__c=u2.id;
                oProject.Lead_Scientist__c=u2.id;
                oProject.Legal_REP__c=u2.id;
                oProject.Regulatory_Rep__c=u2.id;
                oProject.Research_Project_Lead__c=u2.id;
                oProject.Research_Team_Contact__c=u2.id;
            }
            update lAllProjects;
            List<Id> projectIds= new List<Id>();
            projectIds.add(lprojects[0].id);
            projectIds.add(lprojects[1].id);
            projectIds.add(lAssessments[0].id);
            projectIds.add(lAssessments[1].id);
            projectIds.add(lIdeas[0].id);
            projectIds.add(lIdeas[1].id);
            lprojects[0].Related_Assessment_Project__c=lAssessments[0].id;
            lprojects[0].Related_Idea__c=lIdeas[0].id;
            lprojects[1].Related_Assessment_Project__c=lAssessments[1].id;
            lprojects[1].Related_Idea__c= lIdeas[1].id;
            lAssessments[0].Related_Generation_Project__c=lprojects[0].id;
            lAssessments[0].Related_Idea__c=lIdeas[0].id;
            lAssessments[1].Related_Generation_Project__c=lprojects[1].id;
            lAssessments[1].Related_Idea__c= lIdeas[1].id;
            update lprojects;
            update lAssessments;
            Test.startTest();
            DRDW_RecordSharing.getRecordIdShare(projectIds,false,true);
            
            DRDW_RecordSharing.getRecordIdShare(projectIds,true,false);
            System.assertNotEquals(null,u.Id,'error');
            Test.stopTest();
        }
    }
    
    static testMethod void testRecordShare2() {
        User u = DRDW_TestDataFactory.getTestingUser();
        DRDW_TestDataFactory.givePermissions(u.id,'DRDW_Business_Admin'); 
        User u2 = DRDW_TestDataFactory.getTestingUser();
        DRDW_TestDataFactory.givePermissions(u2.id,'DRDW_Business_Admin'); 
        
        System.runAs(u) {
            List<DRDW_Project__c> lAllProjects = new List<DRDW_Project__c>();
            List<DRDW_Project__c> lprojects = DRDW_TestDataFactory.returnProjects(2,'Generation Project');
            system.assertNotEquals(lprojects.size(), 0);
            insert lprojects;
            List<DRDW_Project__c> lAssessments = DRDW_TestDataFactory.returnProjects(2,'Assessment Project');
            system.assertNotEquals(lAssessments.size(), 0);
            insert lAssessments;
            List<DRDW_Project__c> lIdeas = DRDW_TestDataFactory.returnProjects(2,'Idea');
            system.assertNotEquals(lIdeas.size(), 0);
            insert lIdeas;
            List<DRDW_Risk__c> lRisks = DRDW_TestDataFactory.returnRisks(2,lprojects[0].id);
            system.assertNotEquals(lRisks.size(), 0);
            insert lRisks;
            DRDW_Resource__c oResource=new DRDW_Resource__c(Name__c =u2.id, Role__c ='Animal Caretaker', Status__c ='Active',Type__c ='GO',User_Unique_Check__c ='748514800235', Days_Per_Week__c ='5',Hours_Available_Per_Day__c =5,Hours_per_Week__c =25 );
            insert oResource;
            system.assertNotEquals(oResource.id,null);
            lAllProjects.addAll(lprojects);
            lAllProjects.addAll(lAssessments);
            lAllProjects.addAll(lIdeas);
            for(DRDW_Project__c oProject:lAllProjects ){
                oProject.Development_Team_Director__c=u2.id;
                oProject.Director__c=u2.id;
                oProject.ERL_Primary_Contact__c=u2.id;
                oProject.Global_Marketer__c=u2.id;
                oProject.Internal_Development_Partner__c=u2.id;
                oProject.Launch_Leader__c=u2.id;
                oProject.Lead_Finder__c=u2.id;
                oProject.Lead_Scientist__c=u2.id;
                oProject.Legal_REP__c=u2.id;
                oProject.Regulatory_Rep__c=u2.id;
                oProject.Research_Project_Lead__c=u2.id;
                oProject.Research_Team_Contact__c=u2.id;
            }
            update lAllProjects;List<Id> projectIds= new List<Id>();
            projectIds.add(lprojects[0].id);
            projectIds.add(lprojects[1].id);
            projectIds.add(lAssessments[0].id);
            projectIds.add(lAssessments[1].id);
            projectIds.add(lIdeas[0].id);
            projectIds.add(lIdeas[1].id);
            lprojects[0].Related_Assessment_Project__c=lAssessments[0].id;
            lprojects[0].Related_Idea__c=lIdeas[0].id;
            lprojects[1].Related_Assessment_Project__c=lAssessments[1].id;
            lprojects[1].Related_Idea__c= lIdeas[1].id;
            lAssessments[0].Related_Generation_Project__c=lprojects[0].id;
            lAssessments[0].Related_Idea__c=lIdeas[0].id;
            lAssessments[1].Related_Generation_Project__c=lprojects[1].id;
            lAssessments[1].Related_Idea__c= lIdeas[1].id;
            update lprojects;
            update lAssessments;
            Test.startTest();
            DRDW_RecordSharing.getRecordIdShare(projectIds,false,true, oResource.id);
            
            DRDW_RecordSharing.getRecordIdShare(projectIds,true,false, oResource.id);
            System.assertNotEquals(null,u.Id,'error');
            Test.stopTest();
        }
    }
}