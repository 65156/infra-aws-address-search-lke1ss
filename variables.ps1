$region = "ap-southeast-2"
$rollback = $false
$address01 = "119.225.143.*" # Address to Find        \\
$address02 = "14.202.162.232/29" # Address to Replace // Rollback will inverse these addresses

$accounts = @( 
    # accounts are dependant on account names configured in PS-AWS-SSO-AUTH.psm1
    #[PSCustomObject]@{Account="PipelineProd"},
    #[PSCustomObject]@{Account="PipelineDev"},
    #[PSCustomObject]@{Account="LegacyProd"},
    #[PSCustomObject]@{Account="LegacyDev"},
    #[PSCustomObject]@{Account="SandboxD3"},
    [PSCustomObject]@{Account="SandboxICE"}
    ) 