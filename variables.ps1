$region = "ap-southeast-2"
$rollback = $false
$replace = $false
$address01 = "10.131.106.144/32" # Address to Find        \\
$address02 = "10.131.111.207/32" # Address to add & optionally replace // Rollback will inverse these addresses

$accounts = @( 
    # accounts are dependant on account names configured in PS-AWS-SSO-AUTH.psm1
    [PSCustomObject]@{Account="PipelineProd"},
    [PSCustomObject]@{Account="PipelineDev"},
    [PSCustomObject]@{Account="LegacyProd"},
    [PSCustomObject]@{Account="LegacyDev"},
    [PSCustomObject]@{Account="SandboxD3"},
    [PSCustomObject]@{Account="SandboxICE"}
    ) 