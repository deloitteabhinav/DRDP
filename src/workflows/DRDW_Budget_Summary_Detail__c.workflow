<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>DRDW_Summary_detail_unique_field_update</fullName>
        <field>Quarter_Duplication_TF__c</field>
        <formula>DRDW_Budget_Summary__r.Name + TEXT( Quarter__c ) +TEXT( Month__c ) +TEXT( Year__c )</formula>
        <name>DRDW Summary detail unique field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>DRDW Restrict quarter duplication on summary detail</fullName>
        <actions>
            <name>DRDW_Summary_detail_unique_field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
