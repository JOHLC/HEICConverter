# HEIC to Image Format Converter (PowerShell GUI)
This is a simple PowerShell-based GUI tool to convert `.heic` image files to common formats (`jpg`, `png`, `bmp`, `gif`) using [ImageMagick](https://imagemagick.org). It features a user-friendly interface with folder selection, format dropdown, and a progress bar.

## Features
- Select a folder containing `.heic` files
- Choose output format (`jpg`, `png`, `bmp`, `gif`)
- Handles batch conversion
- Simple GUI – no command-line interaction needed

## Prerequisites
- **Windows**
- **[ImageMagick](https://imagemagick.org/script/download.php)** installed and available in your system PATH  
  (Test this by running `magick -version` in PowerShell)

## How to Use
1. Select the folder containing `.heic` files.
2. Choose your desired output format from the dropdown.
3. Click **Convert**.
4. Converted files will be saved in the same folder with the new format.

## Disclaimer
This script is provided "as is" without any warranty or guarantee of any kind, express or implied.  
Use at your own risk.
- Always back up your files before running batch conversions.
- The author is not responsible for any data loss, file corruption, or system issues resulting from the use of this tool.
- Ensure you comply with any licensing terms for ImageMagick or other third-party software used in conjunction with this script.

By using this script, you agree to take full responsibility for its operation and outcomes.
