# HEIC to Image Format Converter (PowerShell GUI)
A simple PowerShell GUI tool to batch convert `.heic` image files to common formats (`jpg`, `png`, `bmp`, `gif`) using [ImageMagick](https://imagemagick.org). Features folder selection, format dropdown, and a live progress bar.

## Features
- Select a folder of `.heic` files
- Choose output format (`jpg`, `png`, `bmp`, `gif`)
- Batch conversion with progress indicator
- Simple GUI — no command-line use needed

## Prerequisites
- **Windows**
- **ImageMagick** installed and added to your system PATH  
  You can install it via [winget](https://learn.microsoft.com/en-us/windows/package-manager/winget/) with this command:

  ```powershell
  winget install -e --id ImageMagick.ImageMagic
  ```

  Or download from the [official ImageMagick website](https://imagemagick.org/script/download.php#windows).

## How to Use
1. **Download**: Get the latest `HEICConverter.exe` from the [Releases](https://github.com/JOHLC/HEICConverter/releases) page.
2. **Run**: Double-click the exe to launch the application.
3. **Select Folder**: Click **Select Folder** and choose the folder containing `.heic` images.
4. **Choose Format**: Select your desired output format from the dropdown (jpg, png, bmp, gif).
5. **Convert**: Click **Convert**. Converted files will be saved in the same folder with the new format.

## Screenshots
![HEIC Converter Interface](https://via.placeholder.com/400x250?text=GUI+Screenshot+Here)
*The simple and intuitive interface makes conversion easy*

## Troubleshooting

### Common Issues
- **"magick command not found"**: Ensure ImageMagick is installed and added to your system PATH
- **No files converted**: Check that your folder contains `.heic` files (case-sensitive)
- **Application won't start**: Make sure you have Windows 10 or later

### Getting Help
- Check the [Issues](https://github.com/JOHLC/HEICConverter/issues) page for common problems
- Create a new issue if you encounter bugs or need help

## Development
Interested in contributing? See our [Development Guide](DEVELOPMENT.md) and [Contributing Guidelines](CONTRIBUTING.md).

### Quick Start for Developers
1. Clone the repository
2. Install ImageMagick and PS2EXE module
3. Run the PowerShell script directly: `.\build\PS2EXE\HEICConverter.ps1`
4. Build executable: `.\build\PS2EXE\PS2EXE.ps1`

## Disclaimer
This script is provided “as is” with no warranty or guarantee of any kind.  
Use at your own risk.

- Always back up your files before running batch operations.
- The author is not liable for data loss, corruption, or other issues.
- Make sure you follow licensing terms for ImageMagick or any other third-party tools used with this script.

By using this script, you accept full responsibility for its use and effects.

## License
Free to use and modify for personal or commercial use.  
**Redistribution, republishing, or resale of this script is not allowed.**  
See [LICENSE](LICENSE) for full terms.
