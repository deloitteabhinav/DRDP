<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>DRDP_SendApproveEmail</fullName>
        <description>DRDP_SendApproveEmail</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Templates/DRDP_Approved_MailTemplate</template>
    </alerts>
    <alerts>
        <fullName>DRDP_SendRejectEmail</fullName>
        <description>DRDP_SendRejectEmail</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Email_Templates/DRDP_Rejected_MailTemplate</template>
    </alerts>
    <fieldUpdates>
        <fullName>UpdateStudyStage</fullName>
        <field>Study_Stage__c</field>
        <name>UpdateStudyStage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>UpdateFieldsWithLookUpNames_OnStudy</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Project__c.OwnerId</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update_research_status</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Project__c.Research_Type__c</field>
            <operation>equals</operation>
            <value>Research Topic</value>
        </criteriaItems>
        <criteriaItems>
            <field>Project__c.Research_Topic_Status__c</field>
            <operation>equals</operation>
            <value>On Hold</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update_research_status_cancel</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Project__c.Research_Type__c</field>
            <operation>equals</operation>
            <value>Research Topic</value>
        </criteriaItems>
        <criteriaItems>
            <field>Project__c.Research_Topic_Status__c</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update_research_status_complete</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Project__c.Research_Type__c</field>
            <operation>equals</operation>
            <value>Research Topic</value>
        </criteriaItems>
        <criteriaItems>
            <field>Project__c.Research_Topic_Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>