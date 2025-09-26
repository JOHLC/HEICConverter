# Development Guide

## Overview
This project is a PowerShell-based GUI application for converting HEIC image files to common formats (JPG, PNG, BMP, GIF) using ImageMagick.

## Prerequisites

### System Requirements
- Windows 10 or later
- PowerShell 5.1 or PowerShell Core 7.x
- ImageMagick installed and added to system PATH

### Development Tools
- PowerShell ISE or VS Code with PowerShell extension
- PS2EXE module for building executables
- Git for version control

## Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/JOHLC/HEICConverter.git
cd HEICConverter
```

### 2. Install ImageMagick
Install ImageMagick using winget:
```powershell
winget install -e --id ImageMagick.ImageMagic
```

Verify installation:
```powershell
magick -version
```

### 3. Install PS2EXE Module
```powershell
Install-Module -Name PS2EXE -Force -AllowClobber
```

## Project Structure

```
HEICConverter/
├── build/
│   └── PS2EXE/
│       ├── HEICConverter.ps1    # Main PowerShell script
│       ├── PS2EXE.ps1          # Build script for creating executable
│       └── icon.ico            # Application icon
├── scripts/
│   ├── build.ps1               # Comprehensive build script
│   ├── update-version.ps1      # Version management script
│   └── validate.ps1            # Code validation script
├── .github/
│   └── workflows/
│       ├── build.yml           # CI/CD build and validation
│       └── release.yml         # Automated release creation
├── HEICConverter.exe           # Pre-built executable
├── LICENSE                     # License file
├── README.md                   # User documentation
├── DEVELOPMENT.md             # This file
├── CONTRIBUTING.md            # Contribution guidelines
└── CHANGELOG.md               # Version history
```

## Development Workflow

### Running the Application
To run the PowerShell script directly:
```powershell
cd build/PS2EXE
.\HEICConverter.ps1
```

### Building the Executable
To build a new executable:

#### Option 1: Using the Build Script (Recommended)
```powershell
cd scripts
.\build.ps1
```

This will:
- Validate prerequisites (PS2EXE module, PowerShell version)
- Run syntax validation
- Build the executable
- Provide build statistics

#### Option 2: Manual Build
```powershell
cd build/PS2EXE
.\PS2EXE.ps1
```

#### Build Options
```powershell
# Build with verbose output
.\build.ps1 -Verbose

# Skip validation (faster build)
.\build.ps1 -SkipValidation

# Custom output location
.\build.ps1 -OutputPath "C:\MyBuilds\HEICConverter.exe"
```

### Code Style
- Use descriptive variable names with camelCase for local variables
- Use PascalCase for function names
- Include comments for complex logic
- Follow PowerShell best practices for error handling

### Testing
#### Automated Validation
```powershell
cd scripts
.\validate.ps1  # Validates syntax, dependencies, and file structure
```

#### Manual Testing Checklist
Manual testing should cover:
- [ ] Application starts without errors
- [ ] ImageMagick detection works properly
- [ ] Folder selection functionality 
- [ ] HEIC file detection (both .heic and .HEIC)
- [ ] Format selection (jpg, png, bmp, gif)
- [ ] Conversion process with progress tracking
- [ ] Error handling for missing ImageMagick
- [ ] Error handling for invalid/empty folders
- [ ] File overwrite confirmation dialogs
- [ ] UI responsiveness during conversion
- [ ] Proper completion messages with statistics
- [ ] Resource cleanup (no memory leaks)
- [ ] Built executable works as expected

#### Test Data
For testing, create a folder with sample HEIC files:
- Mix of `.heic` and `.HEIC` extensions
- Various file sizes
- Include some invalid/corrupted files to test error handling
Recent enhancements include:
- **Enhanced error handling**: Proper ImageMagick availability checking
- **Input validation**: Folder validation and HEIC file detection
- **UI improvements**: Better progress reporting and user feedback
- **Resource management**: Proper disposal of Windows Forms objects
- **Case-insensitive file detection**: Supports both `.heic` and `.HEIC` files
- **Overwrite protection**: Confirmation dialogs for existing files
- **Better UX**: Disabled controls during processing, detailed completion messages

### Release Management
Use the version management script to update versions:
```powershell
cd scripts
# Dry run to see what would change
.\update-version.ps1 -NewVersion "1.0.0" -WhatIf

# Apply version update
.\update-version.ps1 -NewVersion "1.0.0"

# Update version and create git tag
.\update-version.ps1 -NewVersion "1.0.0" -CreateTag
```

### Automated Releases
EXE creation is fully automated via GitHub Actions:
1. **On every push/PR**: Build validation and artifact creation
2. **On tag push** (`v*`): Automatic release with executable attachment
3. **Version management**: Automatic version injection during release builds

To create a release:
```bash
git tag v1.0.0
git push origin v1.0.0
```
This triggers the automated release workflow.

## Troubleshooting

### Common Issues
1. **ImageMagick not found**: Ensure ImageMagick is installed and in PATH
2. **PS2EXE module missing**: Install the PS2EXE module as described above
3. **GUI not displaying**: Ensure Windows Forms assemblies are available

### Debugging
- Use `Write-Host` statements for debugging (visible in PowerShell console)
- Use PowerShell ISE debugger for step-through debugging
- Check Windows Event Viewer for application errors

## Contributing
Please see CONTRIBUTING.md for contribution guidelines.

## Version History
- v0.9.9: Current version with GUI and batch conversion support