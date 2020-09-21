$profileName = "xjtu1x"
$retryTimeSpan = [System.TimeSpan]::FromSeconds(10)
$connectionStartDateTime = [System.DateTime]::Now
$logFile = "$HOME\autolan.log"
enum ConnectionStatusType
{
    Disconnected
    Connected
}

function OnDisconnected {
    $disconnectedDateTime = [System.DateTime]::Now
    $connectionStartDateTime = (Get-Variable -Name "connectionStartDateTime" -Scope Global).Value
    [System.String]::Format("{0}::Disconnected", $disconnectedDateTime) | Write-Host
    Set-Variable -Name "connectionStatus" -Value [ConnectionStatusType]::Disconnected -Scope Global
    if($disconnectedDateTime - $connectionStartDateTime -lt $retryTimeSpan)
    {
        Start-Sleep -Milliseconds ($disconnectedDateTime - $connectionStartDateTime).TotalMilliseconds
    }
    netsh wlan connect name=$profileName
}
function OnConnected {
    Set-Variable -Name "connectionStatus" -Value [ConnectionStatusType]::Connected -Scope Global
    [System.String]::Format("{0}::Connected", [System.DateTime]::Now) | Write-Host
}

Register-WMIEvent -Namespace root\wmi -Class MSNdis_StatusMediaConnect -Action {OnConnected}
Register-WMIEvent -Namespace root\wmi -Class MSNdis_StatusMediaDisconnect -Action {OnDisconnected}

$connectionStatus = [ConnectionStatusType]::Disconnected
if((get-netadapter -Name "WLAN").Status.ToLower() -eq "up")
{
    $connectionStatus = [ConnectionStatusType]::Connected
}
else 
{
    netsh wlan connect name=$profileName
}