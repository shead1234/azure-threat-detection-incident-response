# Implementation Guide

## Overview

This project implements Azure threat detection and automated incident response using Microsoft Sentinel, Microsoft Defender XDR, KQL analytics, Azure security telemetry, automation rules, and a managed-identity Logic App.

The environment was deployed and validated using real Azure resources and controlled security events.

---

## Implementation Sequence

1. **Core Infrastructure**  
   Created the project resource group and deployed a Log Analytics workspace using Bicep.

2. **Microsoft Sentinel**  
   Enabled Microsoft Sentinel on the Log Analytics workspace and validated the onboarding state.

3. **Azure Activity Telemetry**  
   Configured subscription Activity Log diagnostic settings to send administrative and security events to Log Analytics.

4. **Detection Engineering**  
   Created KQL detections and scheduled analytics rules for Azure resource tag changes and Azure RBAC role-assignment changes.

5. **Incident Investigation**  
   Validated Sentinel alerts, incidents, entity mapping, MITRE ATT&CK mappings, and investigation workflows using controlled Azure changes.

6. **Threat Hunting**  
   Added hunting queries for repeated RBAC changes and security-control modifications.

7. **Key Vault Telemetry**  
   Deployed Azure Key Vault with AuditEvent diagnostic logging and validated real SecretGet and SecretSet activity in `AZKVAuditLogs`.

8. **Watchlist and Workbook**  
   Deployed a critical-assets Sentinel watchlist and a custom security operations workbook for security-control activity, Key Vault events, critical assets, and activity trends.

9. **Incident Automation**  
   Created Sentinel automation rules for Medium-severity incidents and for Defender XDR incident updates when new alerts are added.

10. **Logic App Playbook**  
    Deployed a Consumption Logic App using a system-assigned managed identity. The playbook is invoked by Sentinel automation and adds an automated response comment to the incident.

11. **Permissions**  
    Granted the Logic App identity Microsoft Sentinel Responder and configured Microsoft Sentinel Automation Contributor so Sentinel can invoke the playbook.

12. **End-to-End Validation**  
    Generated controlled Azure RBAC activity and validated the complete workflow from Azure Activity Log ingestion through Sentinel detection, Defender XDR correlation, automation-rule execution, Logic App execution, and automated incident response.

---

## Infrastructure as Code

Project resources are maintained through Bicep where practical, including:

- Log Analytics and Sentinel onboarding
- Analytics rules
- Key Vault telemetry
- Watchlist
- Workbook
- Automation rules
- Logic App playbook

Azure CLI was used for deployment, validation, provider registration, RBAC configuration, and controlled security testing.

---

## Operational State

Detection rules used for controlled testing are left disabled when continuous alert generation is not required.

Core Sentinel, Log Analytics, Key Vault telemetry, watchlist, workbook, automation rules, and Logic App resources remain available for portfolio demonstration and future testing.

Detailed test results are documented in:

`docs/validation-report.md`

Incident handling procedures are documented in:

`docs/incident-response-runbook.md`
