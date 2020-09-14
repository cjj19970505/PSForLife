# 自动RemoteForwading到阿里云的脚本

$retryDuration = [System.TimeSpan]::FromSeconds(10)

while($True)
{
    $beforeConnectDateTime = [System.DateTime]::Now
    ssh -4 -v -o ServerAliveInterval=10 -R 8023:localhost:22 root@123.56.57.96 -p 22
    Write-Output "Disconnected"
    $connectionTimeSpan = [System.DateTime]::Now - $beforeConnectDateTime
    if($connectionTimeSpan -lt $retryDuration)
    {
        Start-Sleep -Milliseconds ($retryDuration-$connectionTimeSpan).TotalMilliseconds
    }
}
