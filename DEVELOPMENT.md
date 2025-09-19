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
├── HEICConverter.exe           # Pre-built executable
├── LICENSE                     # License file
├── README.md                   # User documentation
└── DEVELOPMENT.md             # This file
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
```powershell
cd build/PS2EXE
.\PS2EXE.ps1
```

This will create a new `HEICConverter.exe` in the current directory.

### Code Style
- Use descriptive variable names with camelCase for local variables
- Use PascalCase for function names
- Include comments for complex logic
- Follow PowerShell best practices for error handling

### Testing
Currently, there are no automated tests. Manual testing should cover:
1. Folder selection functionality
2. Format selection (jpg, png, bmp, gif)
3. Conversion process with progress tracking
4. Error handling for missing ImageMagick
5. Error handling for invalid folders
6. UI responsiveness during conversion

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