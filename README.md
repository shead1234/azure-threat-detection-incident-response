# Azure Threat Detection & Automated Incident Response

Microsoft Sentinel SIEM/SOAR portfolio project demonstrating Azure security telemetry, KQL detection engineering, threat hunting, Microsoft Defender XDR incident handling, and automated response with Logic Apps.

Built for the fictional **Northstar Retail Group** as a Development / Portfolio Lab in Azure.

## What This Project Demonstrates

- Microsoft Sentinel deployment and configuration
- Azure Activity and Key Vault security telemetry
- Custom KQL detection engineering
- Azure RBAC and resource-change monitoring
- MITRE ATT&CK mapping
- Threat hunting
- Sentinel watchlists and workbooks
- Microsoft Defender XDR incident correlation
- Sentinel automation rules
- Managed-identity Logic App playbooks
- End-to-end automated incident response
- Infrastructure as Code with Bicep

## Architecture

**Azure Activity + Key Vault -> Log Analytics -> Microsoft Sentinel -> KQL Detection -> Defender XDR Incident -> Automation Rule -> Logic App -> Automated Response**

Detailed architecture: [`docs/architecture.md`](docs/architecture.md)

## Detection Engineering

Custom Sentinel detections were created and validated against real Azure activity.

### Azure RBAC Changes

Detects successful Azure role-assignment creation and deletion activity.

- Medium severity
- Account entity mapping
- Persistence / Privilege Escalation
- MITRE ATT&CK **T1098 / T1098.003 - Additional Cloud Roles**

### Azure Resource Tag Changes

Detects successful Azure resource tag modifications and creates Sentinel alerts for investigation.

## Threat Hunting

Custom KQL hunting queries identify:

- Repeated RBAC changes by the same caller
- Security-control modifications
- Sentinel analytics-rule changes

All validation used real Azure telemetry generated through controlled administrative actions.

## Security Telemetry

The environment collects and validates:

| Source | Purpose |
|---|---|
| Azure Activity Log | Control-plane and RBAC activity |
| Azure Key Vault | Secret access and audit activity |
| SecurityAlert | Sentinel detection alerts |
| Defender XDR | Incident correlation and investigation |

## Automated Incident Response

The project implements a working Sentinel SOAR workflow.

When Microsoft Defender XDR adds a new Medium-severity alert to an existing incident:

**Alert Added -> Incident Updated -> Sentinel Automation Rule -> Logic App -> Automated Incident Comment**

The Logic App uses a **system-assigned managed identity** rather than stored credentials.

End-to-end testing confirmed:

- Real RBAC activity generated
- Telemetry ingested into Log Analytics
- Sentinel detection fired
- Defender XDR correlated the alert
- Automation rule executed
- Logic App playbook ran successfully
- Automated response comment was written back to the incident

## Additional Sentinel Capabilities

The project also includes:

- Critical-asset Sentinel watchlist
- Custom Security Operations workbook
- Key Vault audit monitoring
- Incident investigation workflow
- Automated analyst task creation
- Cost-aware lab cleanup

## Technologies

`Microsoft Azure` · `Microsoft Sentinel` · `Microsoft Defender XDR` · `Log Analytics` · `KQL` · `Bicep` · `Azure CLI` · `Logic Apps` · `Managed Identity` · `Azure RBAC` · `Key Vault`

## Documentation

| Document | Purpose |
|---|---|
| [`Architecture`](docs/architecture.md) | Security architecture and data flow |
| [`Implementation Guide`](docs/implementation-guide.md) | Build overview |
| [`Incident Response Runbook`](docs/incident-response-runbook.md) | Analyst response process |
| [`Validation Report`](docs/validation-report.md) | Detailed technical validation |
| [`Evidence Log`](docs/screenshot-log.md) | Screenshot evidence index |
| [`Decision Log`](docs/decision-log.md) | Key engineering decisions |
| [`Cost & Cleanup`](docs/cost-cleanup.md) | Lab cost and cleanup strategy |

## Validation Status

**Technical validation passed.**

The environment successfully demonstrated the complete workflow from Azure security activity through detection, investigation, Defender XDR correlation, and automated Sentinel response using a managed-identity Logic App.
