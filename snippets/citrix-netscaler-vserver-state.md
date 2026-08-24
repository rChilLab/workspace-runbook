---
id: citrix-netscaler-vserver-state
title: "NetScaler/ADC – vServer Status via REST API"
language: powershell
tags: ["Citrix", "NetScaler", "ADC", "Troubleshooting"]
prerequisites: ["Firewall: outbound TCP 443 to the NSIP (management IP) allowed", "Nitro API enabled on the ADC"]
---

Query the status of all load-balancing vServers through the Nitro API, no GUI login required — a fast health check.

```powershell
$adc = "https://adc01.contoso.com"
$cred = Get-Credential

$login = Invoke-RestMethod -Uri "$adc/nitro/v1/config/login" -Method Post -Body (@{
    login = @{ username = $cred.UserName; password = $cred.GetNetworkCredential().Password }
} | ConvertTo-Json) -ContentType "application/json" -SessionVariable session

Invoke-RestMethod -Uri "$adc/nitro/v1/config/lbvserver" -WebSession $session |
    Select-Object -ExpandProperty lbvserver |
    Select-Object name, state, curstate
```
