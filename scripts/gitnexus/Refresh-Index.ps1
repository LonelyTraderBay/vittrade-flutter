#Requires -Version 5.1
<#
.SYNOPSIS
  Refresh the GitNexus knowledge graph for this repo.
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
Set-Location $RepoRoot

Write-Host "Refreshing GitNexus index (may take several minutes)..."
node .gitnexus/run.cjs analyze --skip-agents-md --skip-skills
node .gitnexus/run.cjs status
node .gitnexus/run.cjs doctor
