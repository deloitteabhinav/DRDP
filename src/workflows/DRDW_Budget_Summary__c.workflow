<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>DRDW_Update_Quarter_unique_field_Summary</fullName>
        <field>Quarter_Duplication_TF__c</field>
        <formula>DRDW_Budget_Master__r.Name + text( Quarter__c ) +text( Year__c )</formula>
        <name>DRDW Update Quarter unique field Summary</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>DRDW Restrict duplicate quarter values on Summary</fullName>
        <actions>
            <name>DRDW_Update_Quarter_unique_field_Summary</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
