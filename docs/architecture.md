# Architecture

## Overview

This project uses Microsoft Sentinel as the central SIEM/SOAR platform for Azure security telemetry.

Azure control-plane and Key Vault activity is collected in Log Analytics, analyzed with KQL, correlated into Microsoft Defender XDR incidents, and processed through Sentinel automation and a managed-identity Logic App.

---

## Security Operations Flow

```text
Azure Activity Log + Key Vault Audit Logs
                  |
                  v
        Log Analytics Workspace
                  |
                  v
          Microsoft Sentinel
        /         |          \
   Analytics   Hunting     Workbook
     Rules     Queries     + Watchlist
        \         |          /
                  v
       Microsoft Defender XDR
                  |
                  v
       Sentinel Automation Rules
                  |
                  v
          Logic App Playbook
                  |
                  v
      Automated Incident Response
---

## Core Components

| Component | Purpose |
|---|---|
| Log Analytics | Central security telemetry repository |
| Microsoft Sentinel | SIEM and SOAR platform |
| Azure Activity Log | Azure control-plane telemetry |
| Azure Key Vault | Security audit telemetry |
| KQL Analytics Rules | Detect administrative security changes |
| Threat Hunting | Investigate related activity |
| Sentinel Watchlist | Track critical assets |
| Sentinel Workbook | Security operations dashboard |
| Defender XDR | Incident correlation and investigation |
| Automation Rules | Trigger response workflows |
| Logic App | Automated incident response |
| Managed Identity | Credential-free playbook authentication |

---

## Automated Response

The final response workflow supports Microsoft Defender XDR correlation:

**New Alert -> Existing Incident Updated -> Sentinel Automation Rule -> Logic App Playbook -> Automated Incident Comment**

The Logic App uses a system-assigned managed identity with least-privilege Microsoft Sentinel permissions.

## Design Goals

- Infrastructure as Code
- Real Azure telemetry
- KQL detection engineering
- Threat hunting
- Defender XDR-aware incident handling
- Managed-identity automation
- Least-privilege access
- Repeatable validation
