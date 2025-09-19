# Version Management Script for HEIC Converter
# This script helps update version numbers across all project files

param(
    [Parameter(Mandatory=$true)]
    [string]$NewVersion,
    [switch]$WhatIf
)

# Files that contain version information
$VersionFiles = @{
    "build/PS2EXE/PS2EXE.ps1" = @{
        Pattern = '-Version "([^"]+)"'
        Replacement = '-Version "$NewVersion"'
    }
    "CHANGELOG.md" = @{
        Pattern = '## \[Unreleased\]'
        Replacement = "## [Unreleased]`n`n## [$NewVersion] - $(Get-Date -Format 'yyyy-MM-dd')"
    }
}

Write-Host "🔄 Updating version to: $NewVersion" -ForegroundColor Green

foreach ($file in $VersionFiles.Keys) {
    $filePath = Join-Path $PSScriptRoot $file
    
    if (-not (Test-Path $filePath)) {
        Write-Warning "⚠️  File not found: $filePath"
        continue
    }
    
    $content = Get-Content $filePath -Raw
    $config = $VersionFiles[$file]
    
    if ($content -match $config.Pattern) {
        $newContent = $content -replace $config.Pattern, $config.Replacement
        
        if ($WhatIf) {
            Write-Host "📄 Would update: $file" -ForegroundColor Yellow
            Write-Host "   Old: $($Matches[0])" -ForegroundColor Red
            Write-Host "   New: $($config.Replacement)" -ForegroundColor Green
        } else {
            Set-Content $filePath -Value $newContent -NoNewline
            Write-Host "✅ Updated: $file" -ForegroundColor Green
        }
    } else {
        Write-Warning "⚠️  Pattern not found in: $file"
    }
}

if ($WhatIf) {
    Write-Host "`n💡 Run without -WhatIf to apply changes" -ForegroundColor Cyan
} else {
    Write-Host "`n✨ Version update complete!" -ForegroundColor Green
    Write-Host "📝 Next steps:" -ForegroundColor Cyan
    Write-Host "   1. Review and update CHANGELOG.md manually"
    Write-Host "   2. Test the application"
    Write-Host "   3. Commit changes: git add . && git commit -m `"chore: bump version to $NewVersion`""
    Write-Host "   4. Create tag: git tag v$NewVersion"
    Write-Host "   5. Push: git push origin main --tags"
}