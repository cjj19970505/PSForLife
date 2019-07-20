#这个脚本用来将一个文件夹里的字母文件复制并且重命名到视频文件夹中
#下载剧集和字幕后一个一个重命名实在是太麻烦了
$subFolder = "C:\Users\cjj19\Downloads\adsf\sub"
$videoFolder = "C:\Users\cjj19\Downloads\adsf"
$subFileNameMatchRegex = ".ass$"
$videoFileNameMatchRegex = ".mkv$"
foreach($subFile in Get-ChildItem -Path $subFolder)
{
    if(-not($subFile -match $subFileNameMatchRegex))
    {
        continue;
    }
    #这里的正则表达式用来提取字母文件中的集号，根据需要自行更改
    $subEpisodeNo = [int]::Parse([regex]::Match($subFile.Name, "\d\d")[0].Value)
    #这里通过集号来构建要和视频名字匹配的正则表达式，根据需要自行更改
    $searchVideoRegex = "[^\d]"+ [string]::Format("{0:D2}", $subEpisodeNo) + "[^\d]"

    $relatedVideoFile = "null"
    foreach($videoFile in Get-ChildItem -Path $videoFolder)
    {
        if(-not($videoFile.Name -match $videoFileNameMatchRegex))
        {
            continue
        }
        if($videoFile.Name -match $searchVideoRegex)
        {
            $relatedVideoFile = $videoFile
            break
        }
    }
    #新的字母命名，根据需要自行更改
    $newSubName = $relatedVideoFile.BaseName + $subFile.Extension
    $changeNameInfo = $subFile.Name + "-->" + $newSubName
    $destination=$videoFolder+"\"+$newSubName
    Write-Output $changeNameInfo
    $subFile.CopyTo($destination)
}