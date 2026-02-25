<#
.SYNOPSIS
    基于 yt-dlp 的 YouTube 交互式下载脚本
#>

# 检查 yt-dlp 是否安装
if (-not (Get-Command "yt-dlp" -ErrorAction SilentlyContinue)) {
    Write-Host "错误: 未找到 yt-dlp。请确保已安装并添加至系统环境变量！" -ForegroundColor Red
    Pause
    Exit
}

# 设置默认下载目录为脚本当前运行目录下的 Downloads 文件夹
$DownloadDir = Join-Path -Path $PSScriptRoot -ChildPath "Downloads"
if (-not (Test-Path $DownloadDir)) {
    New-Item -ItemType Directory -Path $DownloadDir | Out-Null
}

function Show-Menu {
    Clear-Host
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "        🎬 yt-dlp 交互式下载助手         " -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan
    
    $url = Read-Host "`n👉 请输入要下载的 YouTube 链接 (输入 'q' 退出)"
    if ($url -eq 'q') { Exit }

    Write-Host "`n请选择下载模式:" -ForegroundColor Green
    Write-Host "  1. 单个视频 (默认)"
    Write-Host "  2. 整个播放列表 (Playlist)"
    $mode = Read-Host "输入你的选择 (1 或 2)"

    $getSubs = Read-Host "`n是否下载字幕 (英语)? (y/N)"
    $getCover = Read-Host "是否下载视频封面? (y/N)"

    # 初始化 yt-dlp 的参数列表
    # 默认下载最佳视频和音频并合并为 mp4
    $ytArgs = @(
        "-f", "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best",
        "--js-runtime", "node",
        "--cookies-from-browser", "firefox",
        "--merge-output-format", "mp4"
    )

    # 根据模式设置命名格式和参数
    if ($mode -eq '2') {
        # 播放列表：创建以播放列表命名的文件夹，文件名前加序号
        Write-Host "`n正在准备下载播放列表..." -ForegroundColor Cyan
        $ytArgs += "--yes-playlist"
        $ytArgs += "-o", "$DownloadDir/%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s"
    } else {
        # 单个视频：直接保存在 Downloads 目录下
        Write-Host "`n正在准备下载单个视频..." -ForegroundColor Cyan
        $ytArgs += "--no-playlist"
        $ytArgs += "-o", "$DownloadDir/%(title)s.%(ext)s"
    }

    # 处理字幕选项 (下载自动生成的和人工上传的，匹配中文和英文)
    if ($getSubs -match '^[yY]$') {
        $ytArgs += "--write-subs"
        $ytArgs += "--sub-lang", "en"
        $ytArgs += "--convert-subs"
        $ytArgs += "srt" # 将字幕统一转换为 srt 格式
    }

    # 处理封面选项
    if ($getCover -match '^[yY]$') {
        $ytArgs += "--write-thumbnail"
        $ytArgs += "--convert-thumbnails", "jpg" # 将封面统一转换为 jpg
    }

    # 添加链接
    $ytArgs += $url

    Write-Host "`n🚀 开始执行 yt-dlp...`n" -ForegroundColor Yellow
    
    # 执行命令
    & yt-dlp $ytArgs

    Write-Host "`n✅ 下载任务结束！文件保存在: $DownloadDir" -ForegroundColor Green
}

# 启动菜单
Show-Menu