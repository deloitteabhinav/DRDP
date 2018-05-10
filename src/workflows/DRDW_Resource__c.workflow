<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>update_user_id_in_unique_check_field</fullName>
        <field>User_Unique_Check__c</field>
        <formula>Name__r.Id</formula>
        <name>update user id in unique check field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Check_Unique</fullName>
        <actions>
            <name>update_user_id_in_unique_check_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
