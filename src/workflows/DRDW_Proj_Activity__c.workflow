<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notification_End_date_is_approaching</fullName>
        <description>Notification : End date is approaching</description>
        <protected>false</protected>
        <recipients>
            <recipient>drdpsrini@deloitte.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DRDP_Email_Templates/End_Date_is_approaching</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Activity_Status</fullName>
        <field>Status__c</field>
        <literalValue>Completed</literalValue>
        <name>Update Activity Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Assigned</fullName>
        <field>Status__c</field>
        <literalValue>Assigned</literalValue>
        <name>Update Status to Assigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Email Notification %3A End date approaching</fullName>
        <active>true</active>
        <criteriaItems>
            <field>DRDW_Proj_Activity__c.Planned_End_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>DRDW_Proj_Activity__c.Status__c</field>
            <operation>notEqual</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Notification_End_date_is_approaching</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>DRDW_Proj_Activity__c.Planned_End_Date__c</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Status to Assigned</fullName>
        <actions>
            <name>Update_Status_to_Assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>DRDW_Proj_Activity__c.Activity_Owner__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
