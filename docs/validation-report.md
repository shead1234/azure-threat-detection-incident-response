# Validation Report

## Project

**Azure Threat Detection and Automated Incident Response with Microsoft Sentinel**

**Organization:** Northstar Retail Group  
**Environment:** Development / Portfolio Lab  
**Primary Region:** East US  
**Validation Status:** Passed

---

## 1. Executive Summary

This project was validated using real Azure resources, real Microsoft Sentinel telemetry, controlled Azure administrative activity, scheduled analytics rules, Microsoft Defender XDR incident correlation, threat-hunting queries, a Sentinel watchlist, a custom security operations workbook, automation rules, and a managed-identity Logic App playbook.

The completed environment successfully demonstrated the following security operations workflow:

**Azure security activity -> telemetry ingestion -> KQL detection -> Microsoft Sentinel alert -> Defender XDR incident correlation -> automated incident response -> validation**

The final SOAR validation confirmed that a real Azure RBAC change generated security telemetry, was detected by Microsoft Sentinel, was correlated into an existing incident by Microsoft Defender XDR, triggered an incident-update automation rule, invoked a Logic App playbook, and automatically added a response comment to the Sentinel incident.

No simulated or dummy evidence was used for the final validation results.

---

## 2. Environment Validation

| Component | Validation | Result |
|---|---|---|
| Azure Resource Group | Created with required project tags | PASS |
| Log Analytics Workspace | Deployed with Bicep and operational | PASS |
| Microsoft Sentinel | Successfully onboarded to the workspace | PASS |
| Azure Activity diagnostics | Subscription Activity Log exported to Log Analytics | PASS |
| AzureActivity table | Real administrative activity successfully ingested | PASS |
| Key Vault diagnostics | AuditEvent logs exported to Log Analytics | PASS |
| AZKVAuditLogs table | Real Key Vault SecretGet and SecretSet activity validated | PASS |
| Microsoft Defender XDR | Sentinel workspace connected and operating with incident correlation | PASS |

---

## 3. Infrastructure and Sentinel Onboarding Validation

The project infrastructure was deployed through Bicep and Azure CLI.

The Microsoft Sentinel onboarding deployment initially encountered a missing resource-provider registration for `Microsoft.OperationsManagement`. The provider was registered and the deployment was repeated successfully.

Sentinel onboarding was then verified through the Microsoft SecurityInsights onboarding state and through the Azure portal.

### Result

**PASS**

### Evidence

- `01-resource-group-tags.png`
- Screenshot 02 - Log Analytics Workspace What-If
- Screenshot 03 - Log Analytics Workspace
- Screenshot 04 - Sentinel Onboarding What-If
- Screenshot 05 - Sentinel Enabled

---

## 4. Azure Activity Telemetry Validation

A subscription-level diagnostic setting was configured to send Azure Activity Log categories to the project Log Analytics workspace.

Enabled categories included:

- Administrative
- Security
- ServiceHealth
- Alert
- Recommendation
- Policy
- Autoscale
- ResourceHealth

Controlled resource-group tag changes were performed and successfully observed in the `AzureActivity` table.

### Result

**PASS**

### Evidence

- Screenshot 06 - Azure Activity KQL Validation

---

## 5. Azure Resource Tag Change Detection

A custom KQL detection was created to identify successful Azure resource tag write operations.

The corresponding scheduled Microsoft Sentinel analytics rule successfully generated alerts and incidents from controlled tag modifications.

Additional validation confirmed:

- Incident generation
- Entity enrichment
- Account entity mapping
- Azure resource entity mapping
- Incident investigation workflow

The rule was disabled after testing to prevent unnecessary lab alerts.

### Result

**PASS**

### Evidence

- Screenshot 07 - Tag Analytics Rule What-If
- Screenshot 08 - Live Tag Detection Rule
- Screenshot 09 - Incidents Generated
- Screenshot 10 - Tag Change Incident
- Screenshot 11 - Tag Incident Investigation
- Screenshot 12 - Entity and Grouping Validation

---

## 6. Azure RBAC Change Detection

A custom scheduled analytics rule was created to detect successful Azure RBAC role assignment creation and deletion operations.

The detection distinguished actions as:

- Role Assignment Created or Updated
- Role Assignment Deleted

Controlled Reader-role assignments were used to generate real RBAC administrative events.

Validation confirmed:

- Azure Activity Log event generation
- AzureActivity ingestion
- KQL detection
- Medium-severity Sentinel alerts
- Account entity mapping
- MITRE ATT&CK mapping
- Persistence tactic
- Privilege Escalation tactic
- T1098 Account Manipulation
- T1098.003 Additional Cloud Roles

The rule was restored to its intended configuration after testing:

- Frequency: `PT5M`
- Lookback: `PT30M`
- Final state: Disabled

The disabled state prevents repeated lab alerts while preserving the detection as deployable infrastructure-as-code.

### Result

**PASS**

### Evidence

- Screenshot 13 - RBAC Analytics Rule What-If
- Screenshot 14 - Live RBAC Detection Rule
- Screenshot 15 - RBAC Change Incident
- Screenshot 16 - RBAC Incident Investigation
- Screenshot 17 - RBAC Create/Delete Incident Correlation

---

## 7. Threat Hunting Validation

Two custom threat-hunting queries were validated against real project telemetry.

### Repeated RBAC Changes by Caller

The query successfully identified repeated RBAC administrative activity associated with the controlled role-assignment creation and deletion tests.

### Security Control Changes

The query successfully identified security-sensitive changes involving:

- Azure RBAC
- Microsoft Sentinel analytics-rule modifications

### Result

**PASS**

### Evidence

- Screenshot 18 - RBAC Threat Hunting Validation
- Screenshot 19 - Security Control Threat Hunt

---

## 8. Azure Key Vault Security Telemetry

Azure Key Vault was deployed as an additional security telemetry source.

Configuration included:

- Azure RBAC authorization
- Soft delete
- AuditEvent diagnostic logging
- Dedicated Log Analytics destination

A temporary Key Vault Secrets Officer role assignment was used to generate authenticated data-plane activity.

Real successful operations were validated in `AZKVAuditLogs`, including:

- SecretSet
- SecretGet
- HTTP success responses
- RBAC authorization

The temporary test secret and role assignment were cleaned up after validation.

### Result

**PASS**

### Evidence

- Screenshot 20 - Key Vault Telemetry What-If
- Screenshot 21 - Key Vault Audit Telemetry Validation

---

## 9. Critical Asset Watchlist

A Microsoft Sentinel watchlist named `critical-assets` was deployed.

The watchlist contains the project's primary security assets:

- Log Analytics workspace
- Key Vault
- Project resource group

The `_GetWatchlist('critical-assets')` KQL function successfully returned all three live entries after synchronization.

### Result

**PASS**

### Evidence

- Screenshot 22 - Sentinel Watchlist What-If
- Screenshot 23 - Sentinel Watchlist KQL Validation

---

## 10. Security Operations Workbook

A custom Microsoft Sentinel workbook was deployed:

**Northstar Sentinel Security Operations Dashboard**

The workbook contains four operational panels:

1. Recent Security-Control Changes
2. Key Vault Security Activity
3. Critical Assets
4. Security Activity Trend

The workbook initially required a configuration adjustment so that it appeared correctly under Microsoft Sentinel workbooks.

After changing its category to `sentinel`, the workbook appeared in Sentinel and rendered live project data successfully.

### Result

**PASS**

### Evidence

- Screenshot 24 - Workbook What-If
- Screenshot 24.5 - Workbook What-If Summary
- Screenshot 25 - Live Workbook Upper Section
- Screenshot 25.5 - Live Workbook Lower Section

---

## 11. Incident Automation Rule

An automation rule was deployed for Medium-severity Sentinel incidents.

The original automation workflow automatically created the incident task:

**Perform automated-response validation**

A controlled Medium RBAC incident confirmed that the task was added automatically by the automation rule.

### Result

**PASS**

### Evidence

- Screenshot 26 - Sentinel Automation Rule What-If
- Screenshot 27 - Automated Incident Task Validation

---

## 12. Logic App Playbook

A Consumption Logic App was deployed:

`logic-nrg-sentinel-response-dev-eus-001`

The playbook uses:

- Microsoft Sentinel incident trigger
- System-assigned managed identity
- Microsoft Sentinel API connection
- Managed identity authentication
- Automated incident comment action

The Logic App managed identity was granted:

**Microsoft Sentinel Responder**

Microsoft Sentinel was granted:

**Microsoft Sentinel Automation Contributor**

The playbook successfully executed and added an automated comment to a Microsoft Sentinel incident.

### Result

**PASS**

### Evidence

- Screenshot 28 - Sentinel Response Playbook What-If
- Screenshot 29 - Sentinel Playbook Automation What-If
- Screenshot 30 - Logic App Playbook Run Success
- Screenshot 31 - Sentinel Automated Response Comment

---

## 13. Defender XDR Incident Correlation Finding

During validation, newly generated RBAC alerts were repeatedly correlated by Microsoft Defender XDR into an existing Microsoft Sentinel incident rather than creating a new incident.

This behavior affected an automation rule configured only for:

**Incident Created**

The project was adjusted to support the actual Defender-integrated incident lifecycle.

A second automation rule was created with:

- Trigger: Incident Updated
- Severity: Medium
- Array condition: Alerts
- Change type: Added
- Action: Run Logic App playbook

This design allows automated response when Microsoft Defender XDR adds a new Sentinel alert to an existing correlated incident.

The condition is scoped specifically to alert additions, preventing the Logic App's own incident comment from recursively triggering another playbook execution.

### Result

**PASS**

This adjustment represents the final production-style SOAR workflow used by the project.

---

## 14. End-to-End SOAR Validation

The final controlled validation followed this sequence:

1. A temporary Azure Reader role assignment was created.
2. Azure generated a successful `Microsoft.Authorization/roleAssignments/write` Activity Log event.
3. The Activity Log event was exported into the `AzureActivity` table.
4. The RBAC scheduled analytics rule detected the event.
5. Microsoft Sentinel generated a Medium-severity security alert.
6. Microsoft Defender XDR correlated the alert into the existing RBAC incident.
7. The incident-update automation rule detected that a new alert had been added.
8. The automation rule invoked the Sentinel Logic App playbook.
9. The Logic App's system-assigned managed identity authenticated successfully.
10. The Logic App added an automated response comment to the Sentinel incident.
11. Logic App run history showed successful trigger and action execution.
12. The incident Activity Log showed both the successful automation-rule execution and the playbook-generated comment.

The automated comment stated that the Northstar response playbook executed successfully and that the incident was processed by the managed-identity Logic App.

### Result

**PASS - END-TO-END SOAR VALIDATED**

### Evidence

- Screenshot 30 - Logic App Playbook Run Success
- Screenshot 31 - Sentinel Automated Response Comment

---

## 15. Cleanup Validation

Temporary resources and permissions used during testing were removed after validation.

Confirmed cleanup included:

- Temporary Azure Reader role assignments removed
- Temporary Key Vault Secrets Officer role assignment removed
- Temporary Key Vault test secret removed from active secrets
- RBAC detection analytics rule returned to disabled state
- RBAC detection rule lookback restored to `PT30M`
- No additional test VM was deployed
- Failed VM capacity/quota testing did not result in an active compute resource

The deployed security platform resources remain available for portfolio demonstration and future validation.

### Result

**PASS**

---

## 16. Final Validation Status

| Security Capability | Status |
|---|---|
| Infrastructure as Code | PASS |
| Microsoft Sentinel Onboarding | PASS |
| Azure Activity Telemetry | PASS |
| Azure RBAC Detection | PASS |
| Resource Change Detection | PASS |
| Key Vault Audit Telemetry | PASS |
| Threat Hunting | PASS |
| Sentinel Watchlists | PASS |
| Security Operations Workbook | PASS |
| Incident Automation | PASS |
| Managed Identity Playbook | PASS |
| Defender XDR Correlation Handling | PASS |
| Automated Incident Response | PASS |
| End-to-End SOAR Validation | PASS |
| Test Resource Cleanup | PASS |

## Overall Result

**PROJECT TECHNICAL VALIDATION PASSED**

The project successfully demonstrates practical Azure security monitoring, detection engineering, threat hunting, Microsoft Sentinel incident management, Microsoft Defender XDR correlation behavior, infrastructure-as-code deployment, managed identities, least-privilege RBAC, security automation, and automated incident response.

