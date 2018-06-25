<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Update_Client_BT_Lead_whenever_App_Retention_Decision_is_updated</fullName>
        <description>Update Client BT Lead whenever App Retention Decision is updated</description>
        <protected>false</protected>
        <recipients>
            <field>Client_BT_Lead1__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/App_Retention_Decision1</template>
    </alerts>
    <rules>
        <fullName>Send update to Client BT Lead</fullName>
        <actions>
            <name>Update_Client_BT_Lead_whenever_App_Retention_Decision_is_updated</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( App_Retention_Decision__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
