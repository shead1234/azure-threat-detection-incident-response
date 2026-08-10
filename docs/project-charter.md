# Project Charter

## Project Name

Azure Threat Detection and Automated Incident Response with Microsoft Sentinel

## Organization

Northstar Retail Group

## Environment

Development / Portfolio Lab

## Primary Azure Region

East US

## Business Scenario

Northstar Retail Group requires centralized security monitoring and incident response capabilities for its Azure environment.

The organization needs to collect security telemetry, detect suspicious activity, investigate incidents, map threats to MITRE ATT&CK techniques, and automate selected response actions.

## Project Objectives

This project will implement and validate:

- Microsoft Sentinel
- Log Analytics workspace
- Azure security and activity telemetry
- Windows security event collection
- Identity-related security telemetry where available
- KQL detection and hunting queries
- Custom analytics rules
- Microsoft Sentinel incidents
- MITRE ATT&CK technique mapping
- Threat investigation workflows
- Watchlists
- Security workbooks and dashboards
- Automation rules
- Logic App response playbook
- Incident response runbook
- Positive and negative detection testing
- Evidence collection and validation
- Cost monitoring and cleanup

## Detection and Response Workflow

Security Activity
-> Telemetry Collection
-> Log Analytics
-> KQL Detection
-> Sentinel Analytics Rule
-> Alert
-> Sentinel Incident
-> Investigation
-> Automated or Manual Response
-> Validation
-> Documentation

## Validation Strategy

Controls will be validated using real Azure resources and real telemetry.

No dummy screenshots or fabricated security evidence will be used.

Where practical, both positive and negative tests will be performed to demonstrate that detections trigger when expected and remain quiet when conditions are not met.

## Portfolio Outcome

The completed repository will demonstrate practical skills in:

- Cloud security monitoring
- SIEM administration
- KQL
- Threat detection engineering
- Security analytics
- Incident investigation
- MITRE ATT&CK
- SOAR
- Automated incident response
- Azure Monitor
- Microsoft Sentinel

