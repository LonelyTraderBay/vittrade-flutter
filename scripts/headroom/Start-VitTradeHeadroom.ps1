#Requires -Version 5.1
<#
.SYNOPSIS
  Start the Headroom proxy for VitTrade (port 8787, memory enabled).
.DESCRIPTION
  Loads scripts/headroom/vittrade.headroom.env (+ optional local override),
  restarts stale proxy versions, and prints status.
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir '..\..')
$Port = 8787
$ProxyUrl = "http://127.0.0.1:$Port"
$LogDir = Join-Path $env:USERPROFILE '.headroom'
$LogFile = Join-Path $LogDir 'vittrade.jsonl'

function Import-EnvFile {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return }
    Get-Content $Path | ForEach-Object {
        $line = $_.Trim()
        if ($line -eq '' -or $line.StartsWith('#')) { return }
        $idx = $line.IndexOf('=')
        if ($idx -lt 1) { return }
        $name = $line.Substring(0, $idx).Trim()
        $value = $line.Substring($idx + 1).Trim()
        if ($name) { Set-Item -Path "Env:$name" -Value $value }
    }
}

function Get-HeadroomExe {
    $cmd = Get-Command headroom -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    $fallback = Join-Path $env:USERPROFILE '.local\bin\headroom.exe'
    if (Test-Path $fallback) { return $fallback }
    throw 'headroom not found. Install: pipx install "headroom-ai[all]"'
}

function Test-ProxyListening {
    param([int]$ListenPort)
    try {
        $conn = Get-NetTCPConnection -LocalPort $ListenPort -State Listen -ErrorAction Stop |
            Select-Object -First 1
        return [bool]$conn
    }
    catch {
        return $false
    }
}

function Get-ProxyHealthVersion {
    param([string]$Url)
    try {
        $resp = Invoke-RestMethod -Uri "$Url/health" -TimeoutSec 5
        if ($resp.version) { return [string]$resp.version }
    }
    catch { }
    return $null
}

$HeadroomExe = Get-HeadroomExe
$env:Path = "$(Split-Path $HeadroomExe);$env:Path"

Import-EnvFile (Join-Path $ScriptDir 'vittrade.headroom.env')
Import-EnvFile (Join-Path $ScriptDir 'vittrade.headroom.local.env')

if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
}

$installedVersion = & $HeadroomExe --version 2>&1 | Select-String -Pattern '\d+\.\d+\.\d+' |
    ForEach-Object { $_.Matches[0].Value } | Select-Object -First 1

$listening = Test-ProxyListening -ListenPort $Port
$runningVersion = if ($listening) { Get-ProxyHealthVersion -Url $ProxyUrl } else { $null }

if ($listening -and $runningVersion -and $installedVersion -and ($runningVersion -ne $installedVersion)) {
    Write-Host "Restarting Headroom proxy ($runningVersion -> $installedVersion)..."
    & (Join-Path $ScriptDir 'Stop-VitTradeHeadroom.ps1') -Port $Port
    Start-Sleep -Seconds 2
    $listening = $false
}

if (-not $listening) {
    Write-Host "Starting Headroom proxy on $ProxyUrl ..."
    $args = @(
        'proxy',
        '--port', "$Port",
        '--memory',
        '--log-file', $LogFile
    )
    Start-Process -FilePath $HeadroomExe -ArgumentList $args -WindowStyle Hidden
    $deadline = (Get-Date).AddSeconds(30)
    while ((Get-Date) -lt $deadline) {
        if (Test-ProxyListening -ListenPort $Port) { break }
        Start-Sleep -Milliseconds 500
    }
    if (-not (Test-ProxyListening -ListenPort $Port)) {
        throw "Headroom proxy did not start on port $Port within 30s."
    }
}

Write-Host ''
Write-Host 'VitTrade Headroom proxy is ready.'
Write-Host "  URL:      $ProxyUrl"
Write-Host "  Log:      $LogFile"
Write-Host "  Repo:     $RepoRoot"
Write-Host ''
Write-Host 'Next steps (Cursor-only):'
Write-Host '  headroom dashboard              (live savings)'
Write-Host '  headroom perf                   (session stats)'
Write-Host '  Cursor: MCP headroom connected  (Settings -> MCP)'
