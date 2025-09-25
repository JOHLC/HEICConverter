# Build Script for HEIC Converter
# This script builds the executable and performs validation

param(
    [switch]$SkipValidation,
    [switch]$Verbose,
    [string]$OutputPath = "..\HEICConverter.exe"
)

Write-Host "🔨 HEIC Converter Build Script" -ForegroundColor Green
Write-Host "==============================" -ForegroundColor Green

# Set verbose preference
if ($Verbose) {
    $VerbosePreference = "Continue"
}

# Check prerequisites
Write-Host "`n📋 Checking Prerequisites..." -ForegroundColor Cyan

# Check PowerShell version
$psVersion = $PSVersionTable.PSVersion
Write-Host "PowerShell Version: $psVersion" -ForegroundColor White
if ($psVersion.Major -lt 5) {
    Write-Error "❌ PowerShell 5.0 or later is required"
    exit 1
}

# Check if PS2EXE module is available
Write-Host "`n🔍 Checking PS2EXE Module..." -ForegroundColor Cyan
try {
    $ps2exeModule = Get-Module -Name PS2EXE -ListAvailable
    if ($ps2exeModule) {
        Write-Host "✅ PS2EXE module found - Version: $($ps2exeModule.Version)" -ForegroundColor Green
    } else {
        Write-Host "⚠️  PS2EXE module not found. Installing..." -ForegroundColor Yellow
        Install-Module -Name PS2EXE -Force -AllowClobber -Scope CurrentUser
        Write-Host "✅ PS2EXE module installed" -ForegroundColor Green
    }
} catch {
    Write-Error "❌ Error with PS2EXE module: $($_.Exception.Message)"
    exit 1
}

# Run validation if not skipped
if (-not $SkipValidation) {
    Write-Host "`n🧪 Running Validation..." -ForegroundColor Cyan
    try {
        & "$PSScriptRoot\validate.ps1"
        if ($LASTEXITCODE -ne 0) {
            Write-Error "❌ Validation failed"
            exit 1
        }
        Write-Host "✅ Validation passed" -ForegroundColor Green
    } catch {
        Write-Error "❌ Validation error: $($_.Exception.Message)"
        exit 1
    }
}

# Build the executable
Write-Host "`n🔨 Building Executable..." -ForegroundColor Cyan

$buildScriptPath = Join-Path $PSScriptRoot "..\build\PS2EXE\PS2EXE.ps1"
$sourceScriptPath = Join-Path $PSScriptRoot "..\build\PS2EXE\HEICConverter.ps1"
$buildDir = Split-Path $buildScriptPath -Parent

if (-not (Test-Path $buildScriptPath)) {
    Write-Error "❌ Build script not found: $buildScriptPath"
    exit 1
}

if (-not (Test-Path $sourceScriptPath)) {
    Write-Error "❌ Source script not found: $sourceScriptPath"
    exit 1
}

try {
    # Change to build directory
    Push-Location $buildDir
    
    # Remove existing exe if present
    if (Test-Path "HEICConverter.exe") {
        Remove-Item "HEICConverter.exe" -Force
        Write-Verbose "Removed existing executable"
    }
    
    # Run the build script
    Write-Host "Running PS2EXE..." -ForegroundColor White
    & ".\PS2EXE.ps1"
    
    if ($LASTEXITCODE -ne 0) {
        throw "PS2EXE returned exit code $LASTEXITCODE"
    }
    
    # Check if executable was created
    if (-not (Test-Path "HEICConverter.exe")) {
        throw "Executable was not created"
    }
    
    $exe = Get-Item "HEICConverter.exe"
    Write-Host "✅ Executable built successfully" -ForegroundColor Green
    Write-Host "📊 Build Statistics:" -ForegroundColor Cyan
    Write-Host "   File size: $([math]::Round($exe.Length / 1MB, 2)) MB" -ForegroundColor White
    Write-Host "   Build time: $($exe.LastWriteTime)" -ForegroundColor White
    Write-Host "   Location: $($exe.FullName)" -ForegroundColor White
    
    # Copy to output path if specified and different
    $outputFullPath = Join-Path $buildDir $OutputPath
    if ($OutputPath -ne "..\HEICConverter.exe" -or -not (Test-Path $outputFullPath)) {
        Copy-Item "HEICConverter.exe" $OutputPath -Force
        Write-Host "📁 Copied to: $OutputPath" -ForegroundColor Green
    }
    
} catch {
    Write-Error "❌ Build failed: $($_.Exception.Message)"
    exit 1
} finally {
    Pop-Location
}

Write-Host "`n🎉 Build Complete!" -ForegroundColor Green
Write-Host "📦 Ready for distribution" -ForegroundColor White

# Provide next steps
Write-Host "`n📝 Next Steps:" -ForegroundColor Cyan
Write-Host "   • Test the executable: .\HEICConverter.exe" -ForegroundColor White
Write-Host "   • For release: Create tag with git tag v<version>" -ForegroundColor White
Write-Host "   • Push tag to trigger GitHub Actions release: git push origin --tags" -ForegroundColor White