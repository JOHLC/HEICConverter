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

## How to Use
1. Run the exe.
2. Click **Select Folder** and choose the folder with `.heic` images.
3. Choose an output format from the dropdown.
4. Click **Convert**. Files will be saved in the same folder with the new format.

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
