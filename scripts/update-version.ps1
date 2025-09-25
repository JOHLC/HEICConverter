# Version Management Script for HEIC Converter
# This script helps update version numbers across all project files

param(
    [Parameter(Mandatory=$true)]
    [string]$NewVersion,
    [switch]$WhatIf,
    [switch]$CreateTag
)

# Validate version format (semantic versioning)
if ($NewVersion -notmatch '^\d+\.\d+\.\d+(-[a-zA-Z0-9]+)?$') {
    Write-Error "❌ Invalid version format. Please use semantic versioning (e.g., 1.0.0 or 1.0.0-beta)"
    exit 1
}

# Files that contain version information
$VersionFiles = @{
    "..\build\PS2EXE\PS2EXE.ps1" = @{
        Pattern = '-Version "([^"]+)"'
        Replacement = '-Version "' + $NewVersion + '"'
        Description = "PowerShell build script"
    }
    "..\CHANGELOG.md" = @{
        Pattern = '## \[Unreleased\]'
        Replacement = "## [Unreleased]`n`n## [$NewVersion] - $(Get-Date -Format 'yyyy-MM-dd')"
        Description = "Changelog file"
    }
}

Write-Host "🔄 Version Update Script" -ForegroundColor Green
Write-Host "======================" -ForegroundColor Green
Write-Host "Updating version to: $NewVersion" -ForegroundColor Cyan

if ($WhatIf) {
    Write-Host "🔍 DRY RUN MODE - No changes will be made" -ForegroundColor Yellow
}

$updateCount = 0
$errorCount = 0

foreach ($file in $VersionFiles.Keys) {
    $filePath = Join-Path $PSScriptRoot $file
    $config = $VersionFiles[$file]
    
    Write-Host "`n📄 Processing: $($config.Description) ($file)" -ForegroundColor Cyan
    
    if (-not (Test-Path $filePath)) {
        Write-Warning "⚠️  File not found: $filePath"
        $errorCount++
        continue
    }
    
    try {
        $content = Get-Content $filePath -Raw
        
        if ($content -match $config.Pattern) {
            $oldValue = $Matches[0]
            $newContent = $content -replace $config.Pattern, $config.Replacement
            
            if ($WhatIf) {
                Write-Host "   Would change: $oldValue" -ForegroundColor Red
                Write-Host "   To: $($config.Replacement -replace '`n.*$', '')" -ForegroundColor Green
            } else {
                Set-Content $filePath -Value $newContent -NoNewline
                Write-Host "✅ Updated successfully" -ForegroundColor Green
                $updateCount++
            }
        } else {
            Write-Warning "⚠️  Pattern not found in file"
            $errorCount++
        }
    } catch {
        Write-Error "❌ Error processing file: $($_.Exception.Message)"
        $errorCount++
    }
}

# Summary
Write-Host "`n📊 Summary:" -ForegroundColor Cyan
Write-Host "   Files updated: $updateCount" -ForegroundColor Green
Write-Host "   Errors: $errorCount" -ForegroundColor $(if ($errorCount -gt 0) { 'Red' } else { 'Green' })

if ($WhatIf) {
    Write-Host "`n💡 Run without -WhatIf to apply changes" -ForegroundColor Yellow
} elseif ($updateCount -gt 0 -and $errorCount -eq 0) {
    Write-Host "`n✨ Version update complete!" -ForegroundColor Green
    
    # Check if in git repository
    if (Test-Path (Join-Path $PSScriptRoot "..\.git")) {
        Write-Host "`n📝 Next steps:" -ForegroundColor Cyan
        Write-Host "   1. Review and update CHANGELOG.md manually with specific changes"
        Write-Host "   2. Test the application: cd build\PS2EXE && .\HEICConverter.ps1"
        Write-Host "   3. Build executable: cd build\PS2EXE && .\PS2EXE.ps1"
        Write-Host "   4. Commit changes: git add . && git commit -m `"chore: bump version to $NewVersion`""
        
        if ($CreateTag) {
            Write-Host "   5. Creating git tag..." -ForegroundColor Yellow
            try {
                Set-Location (Join-Path $PSScriptRoot "..")
                git tag "v$NewVersion"
                Write-Host "✅ Created tag: v$NewVersion" -ForegroundColor Green
                Write-Host "   6. Push: git push origin main --tags"
            } catch {
                Write-Warning "⚠️  Failed to create git tag: $($_.Exception.Message)"
            }
        } else {
            Write-Host "   5. Create tag: git tag v$NewVersion"
            Write-Host "   6. Push: git push origin main --tags"
            Write-Host "`n💡 Use -CreateTag parameter to automatically create the git tag"
        }
    }
} else {
    Write-Warning "⚠️  Version update incomplete due to errors"
    exit 1
}