# Incident Response Runbook

## Purpose

This runbook defines the investigation and response process for Azure RBAC role-assignment alerts detected by Microsoft Sentinel in the Northstar Retail Group portfolio environment.

The primary detection monitors successful Azure role-assignment creation and deletion activity and generates Medium-severity Sentinel alerts for investigation.

---

## Detection Scope

The detection monitors Azure Activity Log events associated with:

`Microsoft.Authorization/roleAssignments/write`

`Microsoft.Authorization/roleAssignments/delete`

These events may represent legitimate administrative activity or unauthorized privilege changes.

MITRE ATT&CK mapping:

**T1098 - Account Manipulation**  
**T1098.003 - Additional Cloud Roles**

---

## Analyst Response Workflow

1. **Review the Sentinel incident**  
   Confirm the incident title, severity, associated alerts, entities, affected Azure resources, and event timestamps.

2. **Validate the RBAC activity**  
   Review the Azure Activity Log and determine whether the event represents a role assignment creation, modification, or deletion.

3. **Identify the initiating account**  
   Determine which account performed the RBAC change and verify whether that identity was authorized to make the change.

4. **Review the assigned role and scope**  
   Determine the Azure role involved and whether access was granted at the subscription, resource-group, or individual-resource level.

5. **Check for related activity**  
   Use Sentinel hunting queries to identify repeated RBAC changes, Sentinel configuration changes, or other suspicious administrative activity associated with the same caller.

6. **Determine disposition**  
   If the activity is authorized, document the administrative purpose and close the incident as expected activity. If unauthorized or suspicious, remove the inappropriate role assignment, preserve evidence, investigate the affected identity, and escalate according to organizational incident-response procedures.

7. **Validate automated response**  
   Confirm that the Sentinel automation rule and Logic App playbook executed successfully and that the automated response comment appears in the incident activity log.

---

## Automated Response

Microsoft Sentinel automation handles Medium-severity RBAC incidents through two workflows.

New Medium incidents can receive an automated analyst-validation task.

When Microsoft Defender XDR correlates a new alert into an existing Medium incident, an incident-update automation rule detects the alert addition and invokes the Sentinel Logic App playbook.

The playbook uses a system-assigned managed identity and automatically adds a response comment to the affected Sentinel incident.

---

## Evidence Sources

Analysts should use the following sources during investigation:

| Source | Purpose |
|---|---|
| Microsoft Sentinel Incident | Primary investigation record |
| AzureActivity | Validate Azure control-plane activity |
| SecurityAlert | Validate generated detection alerts |
| Threat Hunting Queries | Identify related administrative activity |
| Defender XDR Activity Log | Review alert correlation and incident changes |
| Logic App Run History | Validate automated-response execution |

---

## Closure Criteria

An incident may be closed when the RBAC activity has been validated, unauthorized access has been removed if necessary, related activity has been reviewed, automated-response execution has been confirmed, and investigation findings have been documented.

## Validation Status

This workflow was tested with controlled Azure RBAC role-assignment activity and successfully validated through Microsoft Sentinel, Microsoft Defender XDR, automation rules, and a managed-identity Logic App playbook.
