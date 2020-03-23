$region = "ap-southeast-2"
$rollback = $false
#$address = "10.0.0.*"
$address = "119.225.143.*" # address to search through all security groups for (can hit wildcard addresses to hit multiple ranges.)
$newaddress = "14.202.162.232/29" # cidr range to replace
$accounts = @( 
    # accounts are dependant on account names configured in PS-AWS-SSO-AUTH.psm1
    [PSCustomObject]@{Account="PipelineProd"},
    [PSCustomObject]@{Account="PipelineDev"},
    [PSCustomObject]@{Account="LegacyProd"},
    [PSCustomObject]@{Account="LegacyDev"},
    [PSCustomObject]@{Account="SandboxD3"},
    [PSCustomObject]@{Account="SandboxICE"}
    ) 