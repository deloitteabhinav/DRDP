<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>DRDW_Send_mail_120days_before_Start_date_and_status_is_in_Draft</fullName>
        <description>DRDW_Send mail 120days before Start date and status is in Draft</description>
        <protected>false</protected>
        <recipients>
            <field>Project_PM__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_RPL__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Requested_by__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Study_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DRDW/DRDW_SendEmailBefore120DaysOnDraftH</template>
    </alerts>
    <alerts>
        <fullName>DRDW_Send_mail_30days_before_Start_date_and_Status_is_IN_QUEUE</fullName>
        <description>DRDW_Send mail 30days before Start date and Status is IN QUEUE</description>
        <protected>false</protected>
        <recipients>
            <field>Project_PM__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_RPL__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Requested_by__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Study_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DRDW/DRDW_SendEmailBefore30DaysOnInQueueH</template>
    </alerts>
    <alerts>
        <fullName>DRDW_Send_mail_60days_before_Start_date_and_Status_is_IN_QUEUE</fullName>
        <description>DRDW_Send mail 60days before Start date and Status is IN QUEUE</description>
        <protected>false</protected>
        <recipients>
            <field>Project_PM__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_RPL__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Requested_by__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Study_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DRDW/DRDW_SendEmailBefore60DaysOnInQueueH</template>
    </alerts>
    <alerts>
        <fullName>DRDW_Send_mail_90days_before_Start_date_and_Status_is_IN_QUEUE</fullName>
        <description>DRDW_Send mail 90days before Start date and Status is IN QUEUE</description>
        <protected>false</protected>
        <recipients>
            <field>Project_PM__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_RPL__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Requested_by__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Study_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DRDW/DRDW_SendEmailBefore90DaysOnInQueueh</template>
    </alerts>
    <alerts>
        <fullName>DRDW_Send_mail_90days_before_Start_date_and_Status_is_in_Draft</fullName>
        <description>DRDW_Send mail 90days before Start date and Status is in Draft</description>
        <protected>false</protected>
        <recipients>
            <field>Project_PM__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_RPL__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Requested_by__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Study_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DRDW/DRDW_SendEmailBefore90DaysOnDraftH</template>
    </alerts>
    <alerts>
        <fullName>DRDW_Send_mail_When_the_Status_is_Approved</fullName>
        <description>DRDW_Send mail When the Status is Approved</description>
        <protected>false</protected>
        <recipients>
            <field>Project_PM__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_RPL__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Requested_by__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Study_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DRDW/DRDW_SendEmailWhenApprovedH</template>
    </alerts>
    <alerts>
        <fullName>DRDW_Send_mail_When_the_Status_is_Rejected_and_reason_is_Resource_Constraints</fullName>
        <description>DRDW_Send mail When the Status is Rejected and reason is Resource Constraints</description>
        <protected>false</protected>
        <recipients>
            <field>Project_PM__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_RPL__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Requested_by__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Study_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DRDW/DRDW_SendEmailWhenRejectedResourceConstraintsH</template>
    </alerts>
    <alerts>
        <fullName>DRDW_Send_mail_When_the_Status_is_Rejected_and_reason_is_not_technically_feasibl</fullName>
        <description>DRDW_Send mail When the Status is Rejected and reason is not technically feasible</description>
        <protected>false</protected>
        <recipients>
            <field>Project_PM__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_RPL__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Requested_by__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Study_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DRDW/DRDW_SendEmailWhenRejectedNotTechFeasibleH</template>
    </alerts>
    <alerts>
        <fullName>DRDW_Send_mail_When_the_Status_is_Submitted</fullName>
        <description>DRDW_Send mail When the Status is Submitted</description>
        <protected>false</protected>
        <recipients>
            <field>Project_PM__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_RPL__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Requested_by__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Study_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DRDW/DRDW_SendEmailWhenSubmittedH</template>
    </alerts>
    <fieldUpdates>
        <fullName>DRDW_Status_Update_Resubmission_Required</fullName>
        <field>Request_Status__c</field>
        <literalValue>Re-Submit: Data Request</literalValue>
        <name>DRDW Status Update Resubmission Required</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>DRDW ERL%2FGO request notification</fullName>
        <active>false</active>
        <description>This workflow will send an email template when the &apos;Do you know your activities&apos; is No to the PM group and ERL head</description>
        <formula>ISPICKVAL(Do_you_know_your_Activities__c, &apos;No&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DRDW_SendEmail_FormNotComplete30</fullName>
        <active>true</active>
        <formula>AND(  isFormNotComplete_TF__c  ,  RecordType.DeveloperName == &apos;GO&apos; ,FinalDateTobeConsidered__c &gt;= ( Today() + 30) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>DRDW_Send_mail_30days_before_Start_date_and_Status_is_IN_QUEUE</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>DRDW_Status_Update_Resubmission_Required</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>DRDW_Cap_Request__c.FinalDateTobeConsidered__c</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>DRDW_SendMailOnStatusApproved</fullName>
        <actions>
            <name>DRDW_Send_mail_When_the_Status_is_Approved</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow sends a mail, when the status is &quot;Approved&quot;</description>
        <formula>AND(IsPickVal(Request_Status__c , &apos;Approved-Locked&apos;),  (RecordType.DeveloperName = &apos;GO&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DRDW_SendMailOnStatusDraft120Days</fullName>
        <active>true</active>
        <description>This workflow sends mails when the planned study start date is after 120 days and the status is in Draft</description>
        <formula>AND(IsPickVal(Request_Status__c , &apos;Draft&apos;),  (RecordType.DeveloperName = &apos;GO&apos;) , FinalDateTobeConsidered__c &gt;= Today() + 120 )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>DRDW_Send_mail_120days_before_Start_date_and_status_is_in_Draft</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>DRDW_Cap_Request__c.FinalDateTobeConsidered__c</offsetFromField>
            <timeLength>-120</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>DRDW_SendMailOnStatusDraft90Days</fullName>
        <active>true</active>
        <description>This workflow sends mails when the planned study start date is after 90 and 120 days and the status is in Draft</description>
        <formula>AND(IsPickVal(Request_Status__c , &apos;Draft&apos;),  (RecordType.DeveloperName = &apos;GO&apos;),FinalDateTobeConsidered__c &gt;= Today() + 90)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>DRDW_Send_mail_90days_before_Start_date_and_Status_is_in_Draft</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>DRDW_Cap_Request__c.FinalDateTobeConsidered__c</offsetFromField>
            <timeLength>-90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>DRDW_SendMailOnStatusInQueue60Days</fullName>
        <active>true</active>
        <description>This workflow sends mails when the planned study start date is after 30, 60 and 90 days and the status is in &quot;In Queue&quot;</description>
        <formula>AND(IsPickVal(Request_Status__c , &apos;In Queue&apos;),  (RecordType.DeveloperName = &apos;GO&apos;) , FinalDateTobeConsidered__c &gt;= Today() + 60)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>DRDW_Send_mail_60days_before_Start_date_and_Status_is_IN_QUEUE</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>DRDW_Cap_Request__c.FinalDateTobeConsidered__c</offsetFromField>
            <timeLength>-60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>DRDW_SendMailOnStatusInQueue90</fullName>
        <active>true</active>
        <formula>AND(IsPickVal(Request_Status__c , &apos;In Queue&apos;), (RecordType.DeveloperName = &apos;GO&apos;) , FinalDateTobeConsidered__c &gt;= Today() + 90)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>DRDW_Send_mail_90days_before_Start_date_and_Status_is_IN_QUEUE</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>DRDW_Cap_Request__c.FinalDateTobeConsidered__c</offsetFromField>
            <timeLength>-90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>DRDW_SendMailOnStatusRejectedNotTechFeasible</fullName>
        <actions>
            <name>DRDW_Send_mail_When_the_Status_is_Rejected_and_reason_is_not_technically_feasibl</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow sends a mail, when the status is &quot;Rejected&quot; and the Rejection Reason is &quot;Not Technically Feasible&quot;</description>
        <formula>AND( ISPICKVAL(Request_Status__c, &apos;Rejected&apos;), ISPICKVAL(Reasons_for_Rejection__c, &apos;Not Technically Feasible&apos;),(RecordType.DeveloperName = &apos;GO&apos;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DRDW_SendMailOnStatusRejectedResourceConstraints</fullName>
        <actions>
            <name>DRDW_Send_mail_When_the_Status_is_Rejected_and_reason_is_Resource_Constraints</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow sends a mail, when the status is &quot;Rejected&quot; and the Rejection Reason is &quot;Resource Constraints&quot;</description>
        <formula>AND(IsPickVal(Request_Status__c , &apos;Rejected&apos;), OR(IsPickVal(Reasons_for_Rejection__c, &apos;Facility Resource Constraints&apos;),  ISPICKVAL(Reasons_for_Rejection__c, &apos;Personnel Resource Constraints&apos;) ), (RecordType.DeveloperName = &apos;GO&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DRDW_SendMailOnStatusSubmitted</fullName>
        <actions>
            <name>DRDW_Send_mail_When_the_Status_is_Submitted</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow sends a mail, when the status is &quot;Submitted&quot;</description>
        <formula>AND(IsPickVal(Request_Status__c , &apos;Submitted&apos;),  (RecordType.DeveloperName = &apos;GO&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>