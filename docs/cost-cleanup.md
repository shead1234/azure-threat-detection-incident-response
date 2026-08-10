# Cost and Cleanup

## Cost Controls

This project was designed as a portfolio lab with cost awareness in mind.

Key controls included:

- No continuously running virtual machine
- Log Analytics retention limited for the lab environment
- Consumption-based Logic App
- Controlled security-event generation only during validation
- Detection rules disabled when continuous testing is not required
- Temporary permissions removed after testing

## Validation Cleanup

The following temporary test items were removed:

- Azure Reader role assignments used for RBAC testing
- Key Vault Secrets Officer test assignment
- Temporary Key Vault test secret from active secrets
- Unnecessary repeated detection activity

The RBAC analytics rule was returned to a disabled state after validation.

## Resources Intentionally Retained

The following resources remain for portfolio demonstration and future testing:

- Log Analytics workspace
- Microsoft Sentinel
- Azure Key Vault telemetry
- Analytics and hunting queries
- Sentinel watchlist
- Security operations workbook
- Automation rules
- Logic App playbook

The entire project resource group can be removed when the portfolio environment is no longer needed.
