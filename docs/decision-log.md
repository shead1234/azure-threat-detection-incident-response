# Decision Log

## Key Design Decisions

### 1. Infrastructure as Code

**Decision:** Use Bicep for repeatable deployment of core Sentinel resources.

**Reason:** Provides version-controlled, reproducible infrastructure instead of relying only on manual portal configuration.

---

### 2. Azure Activity as Primary Control-Plane Telemetry

**Decision:** Send Azure Activity Logs to the central Log Analytics workspace.

**Reason:** Provides visibility into administrative actions such as RBAC changes and resource modifications.

---

### 3. Key Vault as Additional Security Telemetry

**Decision:** Use Azure Key Vault audit logging instead of deploying a dedicated test VM.

**Reason:** Key Vault provided meaningful security telemetry while avoiding unnecessary compute cost and quota limitations.

---

### 4. KQL-Based Detection Engineering

**Decision:** Build custom detections for Azure resource changes and RBAC role-assignment activity.

**Reason:** Demonstrates detection engineering against real Azure administrative telemetry rather than relying only on built-in rules.

---

### 5. Managed Identity for Playbook Authentication

**Decision:** Use a system-assigned managed identity for the Logic App.

**Reason:** Avoids stored credentials and supports least-privilege access to Microsoft Sentinel.

---

### 6. Defender XDR-Aware Automation

**Decision:** Support both new incidents and incidents updated when Defender XDR adds alerts.

**Reason:** Live testing showed Defender XDR correlating related Sentinel alerts into existing incidents. The automation design was adjusted to match the actual incident lifecycle.

---

### 7. Disable Test Detection Rules After Validation

**Decision:** Leave controlled-test analytics rules disabled when continuous detection is unnecessary.

**Reason:** Prevents repeated lab alerts and unnecessary noise while preserving the rules as deployable infrastructure.

---

## Outcome

These decisions produced a repeatable Azure SIEM/SOAR environment with real telemetry, custom detection engineering, least-privilege automation, Defender XDR-aware incident handling, and validated automated response.
