using namespace System.Collections
$videoRootDir = Read-Host BiliBili Bangumi Folder
$destDir = Read-Host Destination Folder
foreach($videoDir in Get-ChildItem $videoRootDir)
{
    if(-not($videoDir.GetType().Name-eq "DirectoryInfo"))
    {
        continue
    }
    $title = "null"
    $videoFile = "null"
    $partNo = "null"
    foreach($file in Get-ChildItem $videoDir.FullName)
    {
        if($file.Extension -eq ".info")
        {
            $videoInfo = Get-Content -Path $file.FullName -Encoding UTF8
            $titleStr = [regex]::Match($videoInfo, """Title"":""([^""])*""").Groups[0].Value
            $titleStr = [regex]::Match($titleStr, """([^{"",}])*""$").Groups[0].Value
            $title = [regex]::Match($titleStr, "[^""]*[^""]").Groups[0].Value
            $partNoStr = [regex]::Match($videoInfo, """PartNo"":""([^""])*""").Groups[0].Value
            $partNo = [int]::Parse([regex]::Match($partNoStr, "\d+").Groups[0].Value)
        }
        elseif ($file.Extension -eq ".flv") 
        {
            $videoFile = $file
        }
    }
    if($title -eq "null" -or $videoFile -eq "null" -or $partNo -eq "null")
    {
        continue
    }
    $videoName = $title+"_" + [string]::Format("{0:d2}", $partNo) + $videoFile.Extension
    if(-not($destDir -match "\\$"))
    {
        $destVideoPath = $destDir +"\"+ $videoName
    }
    else 
    {
        $destVideoPath = $destDir + $videoName
    }
    $output = "Copying " + $title + "_" + [string]::Format("{0:d2}", $partNo)
    Write-Output $output
    Copy-Item -Path $videoFile.FullName -Destination $destVideoPath
}
Write-Output Complete!