# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Development setup documentation (DEVELOPMENT.md)
- Contributing guidelines (CONTRIBUTING.md)
- GitHub issue and PR templates
- GitHub Actions CI/CD workflow for build validation
- .gitignore file for proper version control
- Comprehensive changelog

### Changed
- Enhanced README.md structure and formatting
- Improved project documentation overall

### Fixed
- GitHub Actions release workflow now handles existing releases properly
- Release workflow can now upload assets to existing releases using `gh release upload --clobber`
- Added robust error handling for release creation/update scenarios

## [0.9.9] - 2025-01-XX

### Added
- Initial PowerShell GUI application for HEIC conversion
- Support for multiple output formats (JPG, PNG, BMP, GIF)
- Batch conversion with progress indicator
- Folder selection dialog
- Windows Forms-based user interface
- PS2EXE build script for executable creation

### Features
- Simple drag-and-drop style interface
- Real-time progress tracking during conversion
- Error handling for common scenarios
- Integration with ImageMagick for image processing

---

## Release Notes

### Version 0.9.9
This is the initial stable release of the HEIC Converter tool. It provides a complete solution for converting HEIC image files to common formats using a user-friendly Windows GUI.

**Key Features:**
- Batch conversion of HEIC files
- Support for JPG, PNG, BMP, and GIF output formats
- Progress tracking during conversion
- Simple folder selection interface
- Compiled executable for easy distribution

**Requirements:**
- Windows 10 or later
- ImageMagick installed and in system PATH
- PowerShell 5.1 or later (for development)

**Known Limitations:**
- Windows-only compatibility
- Requires ImageMagick external dependency
- No support for other input formats beyond HEIC