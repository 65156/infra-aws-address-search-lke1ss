## Fixed Variables ##
$variables      = . ".\variables.ps1" # List of variables used for script
$rollbackfile   = ".\files\rollbackdata.csv" # Rollback file generated from hash table
$rollbackhash   = @() # Rollback hash table

foreach($a in $accounts){
    $account    = $a.Account
    
    # Switch to applicable account    
    Write-Host "  ----------------"
    Write-Host "Processing $account" -f white -b magenta 
    Write-Host "  ----------------"
    Switch-RoleAlias $account admin 
    Write-Host ""
    $securityGroup  = (Get-EC2SecurityGroup -region $region)

    if($rollback = $false){$address = $address01; $newaddress = $address02}
    if($rollback = $true){$address = $address02; $newaddress = $address01} 

    # Loop through each security group and find the ip address
    foreach($grp in $securityGroup){
        $grpId      = $grp.GroupId
        $rule       = $grp.IpPermissions
        $loop       = 0
        
        foreach($ru in $rule){
            $protocol   = $ru.IpProtocol
            $fromPort   = $ru.FromPort
            $toPort     = $ru.ToPort
            $ranges      = $ru.Ipv4Ranges.CidrIp

            foreach($ip in $ranges){
                if($ip -match $address){
                    $oldaddress = $ip
                    $loop = $loop+1
                    if($loop -eq 1){Write-Host "Checking" -f black -b cyan -nonewline ; Write-Host " $grpId" -f black -b white} # displays banner once if match found
                    try {
                        Write-Host "Matched $oldaddress" -f green -nonewline ;
                        Grant-EC2SecurityGroupIngress -region $region -GroupID $grpID -IpPermissions @{IpProtocol="$protocol";FromPort=$fromPort;ToPort=$toPort;IpRanges=@("$newaddress")}                         
                        Write-Host " :: " -nonewline ; Write-Host "updated to $newaddress " -f cyan ; 
                        # Delete old rule
                        Revoke-EC2SecurityGroupIngress -region $region -GroupID $grpID -IpPermissions @{IpProtocol="$protocol";FromPort=$fromPort;ToPort=$toPort;IpRanges=@("$oldaddress")}
                        # Generate rollback pscustom object 
                        $obj = [PSCustomObject]@{
                            Account     = "$account"
                            grpId       = "$grpId"
                            protocol    = "$protocol"
                            fromport    = "$fromPort"
                            toport      = "$toPort"
                            oldaddress  = "$ip"
                            }
                        $rollbackhash += $obj # Add custom object to rollback array
                        } catch { 
                            Write-Host " :: " -nonewline ;  Write-Host "address update failed!" -f red 
                            } 
                    }
            }
        }
    }
}
    # Terminate script if rolling back
    if($rollback -eq $true){
        Write-Host " --------------- "
        Write-Host "Rollback Complete" -f white -b magenta
        Write-Host " --------------- "        
        exit}    

    # Create rollback CSV file from $rollback hash table
    $rollbackhash | Export-CSV $rollbackfile -force
    Write-Host "Exporting Rollback Data to CSV" -f white -b magenta
    $rollbackhash 

