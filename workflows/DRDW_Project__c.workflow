<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Change_Owner_to_Admin_Approved</fullName>
        <field>OwnerId</field>
        <lookupValue>shparsi@deloitte.com.drdworkbench</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Change Owner to Admin - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Owner_to_Admin_Reject</fullName>
        <field>OwnerId</field>
        <lookupValue>shparsi@deloitte.com.drdworkbench</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Change Owner to Admin - Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Recall_after_Submit_For_Approval</fullName>
        <field>Status__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>Recall after Submit For Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Submitted_for_Approval</fullName>
        <description>Update Status to Submitted for Approval</description>
        <field>Status__c</field>
        <literalValue>Submitted for Approval</literalValue>
        <name>Update Status to Submitted for Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Status to approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
