# Youtube Downloader

## 简介
这是一个基于 `yt-dlp` 的 PowerShell 交互式下载脚本，用来下载 YouTube 的单个视频或整个播放列表。脚本会把文件保存到项目目录下的 `Downloads/`。

## 主要功能
- 交互式输入 YouTube 链接（输入 `q` 退出）
- 下载模式二选一：
	- 单个视频（默认）
	- 整个播放列表（Playlist）
- 可选能力：
	- 下载字幕并统一转换为 `srt`
	- 下载视频封面并统一转换为 `jpg`
- 默认下载“最佳画质视频 + 最佳音频”并合并输出为 `mp4`

## 环境要求
运行脚本前请确保以下依赖已就绪：

- Windows + PowerShell（建议 PowerShell 7 或 Windows PowerShell 5.1）
- 已安装 `yt-dlp`，并且命令行可直接运行 `yt-dlp`
- 已安装 Node.js（脚本使用 `--js-runtime node`）
- 已安装 Firefox（脚本使用 `--cookies-from-browser firefox` 读取 Cookies）

## 快速开始
1. 安装依赖
	 - `yt-dlp`：确保 `yt-dlp` 已加入系统环境变量（PATH）
	 - Node.js：确保命令行可运行 `node -v`
	 - Firefox：确保已安装并可正常启动

2. 运行脚本
	 - 在项目根目录打开 PowerShell，执行：
		 - `./script.ps1`

	 如果你遇到“脚本执行被策略禁止”的提示，可以仅对当前会话放开：
	 - `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass`
	 然后再运行：
	 - `./script.ps1`

## 使用方法（交互流程）
脚本启动后会依次询问：

1. 输入 YouTube 链接
	 - 输入一个视频链接或播放列表链接
	 - 输入 `q` 直接退出

2. 选择下载模式
	 - `1`：单个视频（默认）
	 - `2`：整个播放列表

3. 是否下载字幕
	 - 输入 `y` 或 `Y`：下载字幕并转换为 `srt`
	 - 直接回车/输入其他：不下载字幕

4. 是否下载封面
	 - 输入 `y` 或 `Y`：下载缩略图并转换为 `jpg`
	 - 直接回车/输入其他：不下载封面

选择完毕后脚本会拼接参数并调用 `yt-dlp` 开始下载。

## 输出目录与命名规则
脚本默认将下载目录设置为：项目根目录下的 `Downloads/`（若不存在会自动创建）。

- 单个视频：
	- 输出模板：`Downloads/%(title)s.%(ext)s`
- 播放列表：
	- 会按播放列表标题创建子目录
	- 输出模板：`Downloads/%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s`

## 下载内容与格式说明
脚本默认的下载与合并策略：

- 格式选择：优先选择 `mp4` 视频 + `m4a` 音频（或退化到最佳可用）
- 合并：输出统一为 `mp4`（`--merge-output-format mp4`）

字幕与封面：

- 字幕：脚本当前设置为下载 `en`（英文）字幕，并转换为 `srt`
- 封面：下载缩略图并转换为 `jpg`
