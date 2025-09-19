# Validation Script for HEIC Converter
# Validates PowerShell syntax and basic functionality

Write-Host "🧪 HEIC Converter Validation Script" -ForegroundColor Green
Write-Host "===================================" -ForegroundColor Green

# Check PowerShell version
Write-Host "`n📋 System Information:" -ForegroundColor Cyan
Write-Host "PowerShell Version: $($PSVersionTable.PSVersion)" -ForegroundColor White
Write-Host "OS: $($PSVersionTable.OS)" -ForegroundColor White

# Validate PowerShell script syntax
Write-Host "`n🔍 Validating PowerShell Script Syntax..." -ForegroundColor Cyan
$scriptPath = Join-Path $PSScriptRoot "..\build\PS2EXE\HEICConverter.ps1"

if (-not (Test-Path $scriptPath)) {
    Write-Error "❌ PowerShell script not found: $scriptPath"
    exit 1
}

try {
    $errors = $null
    $null = [System.Management.Automation.PSParser]::Tokenize((Get-Content $scriptPath -Raw), [ref]$errors)
    
    if ($errors) {
        Write-Error "❌ PowerShell syntax errors found:"
        $errors | ForEach-Object { Write-Error "   $_" }
        exit 1
    } else {
        Write-Host "✅ PowerShell script syntax is valid" -ForegroundColor Green
    }
} catch {
    Write-Error "❌ Error validating PowerShell syntax: $($_.Exception.Message)"
    exit 1
}

# Check if ImageMagick is available
Write-Host "`n🔍 Checking ImageMagick Installation..." -ForegroundColor Cyan
try {
    $magickVersion = magick -version 2>$null
    if ($magickVersion) {
        Write-Host "✅ ImageMagick is installed and accessible" -ForegroundColor Green
        $versionLine = ($magickVersion -split "`n")[0]
        Write-Host "   $versionLine" -ForegroundColor White
    } else {
        Write-Warning "⚠️  ImageMagick not found in PATH"
        Write-Host "   Install with: winget install -e --id ImageMagick.ImageMagick" -ForegroundColor Yellow
    }
} catch {
    Write-Warning "⚠️  ImageMagick not found in PATH"
    Write-Host "   Install with: winget install -e --id ImageMagick.ImageMagick" -ForegroundColor Yellow
}

# Check if PS2EXE module is available
Write-Host "`n🔍 Checking PS2EXE Module..." -ForegroundColor Cyan
try {
    $ps2exeModule = Get-Module -Name PS2EXE -ListAvailable
    if ($ps2exeModule) {
        Write-Host "✅ PS2EXE module is available" -ForegroundColor Green
        Write-Host "   Version: $($ps2exeModule.Version)" -ForegroundColor White
    } else {
        Write-Warning "⚠️  PS2EXE module not found"
        Write-Host "   Install with: Install-Module -Name PS2EXE -Force -AllowClobber" -ForegroundColor Yellow
    }
} catch {
    Write-Warning "⚠️  Error checking PS2EXE module: $($_.Exception.Message)"
}

# Validate build script
Write-Host "`n🔍 Validating Build Script..." -ForegroundColor Cyan
$buildScriptPath = Join-Path $PSScriptRoot "..\build\PS2EXE\PS2EXE.ps1"

if (-not (Test-Path $buildScriptPath)) {
    Write-Error "❌ Build script not found: $buildScriptPath"
    exit 1
}

try {
    $errors = $null
    $null = [System.Management.Automation.PSParser]::Tokenize((Get-Content $buildScriptPath -Raw), [ref]$errors)
    
    if ($errors) {
        Write-Error "❌ Build script syntax errors found:"
        $errors | ForEach-Object { Write-Error "   $_" }
        exit 1
    } else {
        Write-Host "✅ Build script syntax is valid" -ForegroundColor Green
    }
} catch {
    Write-Error "❌ Error validating build script: $($_.Exception.Message)"
    exit 1
}

# Check for required files
Write-Host "`n🔍 Checking Required Files..." -ForegroundColor Cyan
$requiredFiles = @(
    "..\build\PS2EXE\icon.ico",
    "..\README.md",
    "..\LICENSE",
    "..\CHANGELOG.md"
)

foreach ($file in $requiredFiles) {
    $filePath = Join-Path $PSScriptRoot $file
    if (Test-Path $filePath) {
        Write-Host "✅ Found: $file" -ForegroundColor Green
    } else {
        Write-Warning "⚠️  Missing: $file"
    }
}

Write-Host "`n🎉 Validation Complete!" -ForegroundColor Green
Write-Host "Ready for development and building." -ForegroundColor White