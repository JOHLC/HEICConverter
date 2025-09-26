<#
.SYNOPSIS
    HEIC to Image Format Converter with GUI
.DESCRIPTION
    A PowerShell GUI application for converting HEIC image files to common formats 
    (JPG, PNG, BMP, GIF) using ImageMagick. Features folder selection, format dropdown, 
    and progress tracking.
.NOTES
    Author: Joel Common (JOHLC)
    Version: 0.9.9
    Requires: Windows 10+, PowerShell 5.1+, ImageMagick in PATH
#>

# Load required assemblies
try {
    Add-Type -AssemblyName "System.Windows.Forms"
    Add-Type -AssemblyName "System.Drawing"
} catch {
    [System.Windows.Forms.MessageBox]::Show("Failed to load required Windows Forms assemblies. Please ensure you're running on Windows with .NET Framework.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    exit 1
}

# Function to check if ImageMagick is available
function Test-ImageMagickAvailable {
    try {
        $null = Get-Command "magick" -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
}

# Function to get HEIC files (case-insensitive)
function Get-HEICFiles {
    param([string]$FolderPath)
    
    if (-not (Test-Path $FolderPath)) {
        return @()
    }
    
    # Get both .heic and .HEIC files
    $heicFiles = @()
    $heicFiles += Get-ChildItem -Path $FolderPath -Filter "*.heic" -ErrorAction SilentlyContinue
    $heicFiles += Get-ChildItem -Path $FolderPath -Filter "*.HEIC" -ErrorAction SilentlyContinue
    
    # Remove duplicates (in case file system is case-insensitive)
    return $heicFiles | Sort-Object FullName -Unique
}

# Function to safely convert a single file
function Convert-HEICFile {
    param(
        [string]$InputFile,
        [string]$OutputFile
    )
    
    try {
        $result = & magick "$InputFile" "$OutputFile" 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Warning: Conversion failed for $InputFile - $result" -ForegroundColor Yellow
            return $false
        }
        return $true
    } catch {
        Write-Host "Error converting $InputFile : $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Check ImageMagick availability at startup
if (-not (Test-ImageMagickAvailable)) {
    [System.Windows.Forms.MessageBox]::Show("ImageMagick is not installed or not found in PATH.`n`nPlease install ImageMagick using:`nwinget install -e --id ImageMagick.ImageMagick`n`nOr download from: https://imagemagick.org/script/download.php#windows", "ImageMagick Required", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
    exit 1
}
# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "HEIC to Image Format Converter"
$form.Size = New-Object System.Drawing.Size(400, 250)
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.MaximizeBox = $false

# Create Folder Selection Button
$folderButton = New-Object System.Windows.Forms.Button
$folderButton.Text = "Select Folder"
$folderButton.Size = New-Object System.Drawing.Size(100, 30)
$folderButton.Location = New-Object System.Drawing.Point(150, 20)
$form.Controls.Add($folderButton)

# Create a label to display the selected folder path
$folderLabel = New-Object System.Windows.Forms.Label
$folderLabel.Size = New-Object System.Drawing.Size(300, 20)
$folderLabel.Location = New-Object System.Drawing.Point(20, 60)
$form.Controls.Add($folderLabel)

# Create a ComboBox for format selection
$comboBox = New-Object System.Windows.Forms.ComboBox
$comboBox.Items.AddRange(@("jpg", "png", "bmp", "gif"))
$comboBox.SelectedIndex = 0
$comboBox.Size = New-Object System.Drawing.Size(100, 30)
$comboBox.Location = New-Object System.Drawing.Point(150, 100)
$form.Controls.Add($comboBox)

# Create a button to start the conversion process
$convertButton = New-Object System.Windows.Forms.Button
$convertButton.Text = "Convert"
$convertButton.Size = New-Object System.Drawing.Size(100, 30)
$convertButton.Location = New-Object System.Drawing.Point(150, 140)
$form.Controls.Add($convertButton)

# Create a progress bar to show conversion progress
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Size = New-Object System.Drawing.Size(350, 30)
$progressBar.Location = New-Object System.Drawing.Point(20, 180)
$progressBar.Style = [System.Windows.Forms.ProgressBarStyle]::Continuous
$form.Controls.Add($progressBar)

# Global variable to hold selected folder path
$script:selectedFolderPath = ""

# Event handler for folder selection
$folderButton.Add_Click({
    $folderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderDialog.Description = "Select the folder containing HEIC files"
    $folderDialog.ShowNewFolderButton = $false

    # Show the folder dialog and capture the selected folder
    $dialogResult = $folderDialog.ShowDialog($form)
    
    if ($dialogResult -eq [System.Windows.Forms.DialogResult]::OK) {
        $script:selectedFolderPath = $folderDialog.SelectedPath
        Write-Host "Folder selected: $script:selectedFolderPath"
        
        # Check if folder contains HEIC files
        $heicFiles = Get-HEICFiles -FolderPath $script:selectedFolderPath
        if ($heicFiles.Count -eq 0) {
            $folderLabel.Text = "Selected Folder: $script:selectedFolderPath (No HEIC files found)"
            $folderLabel.ForeColor = [System.Drawing.Color]::Orange
        } else {
            $folderLabel.Text = "Selected Folder: $script:selectedFolderPath ($($heicFiles.Count) HEIC files)"
            $folderLabel.ForeColor = [System.Drawing.Color]::Black
        }
    } else {
        Write-Host "No folder selected"
    }
    
    # Dispose of dialog
    $folderDialog.Dispose()
})

# Event handler for conversion
$convertButton.Add_Click({
    if ([string]::IsNullOrEmpty($script:selectedFolderPath)) {
        [System.Windows.Forms.MessageBox]::Show("Please select a folder first.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    $outputFormat = $comboBox.SelectedItem
    if ([string]::IsNullOrEmpty($outputFormat)) {
        [System.Windows.Forms.MessageBox]::Show("Please select an output format.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    # Get the list of HEIC files in the selected folder
    $files = Get-HEICFiles -FolderPath $script:selectedFolderPath
    $totalFiles = $files.Count
    
    if ($totalFiles -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("No HEIC files found in the selected folder.", "No Files", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        return
    }

    # Confirm conversion
    $confirmResult = [System.Windows.Forms.MessageBox]::Show("Convert $totalFiles HEIC file(s) to .$outputFormat format?", "Confirm Conversion", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question)
    if ($confirmResult -ne [System.Windows.Forms.DialogResult]::Yes) {
        return
    }

    # Disable convert button during processing
    $convertButton.Enabled = $false
    $folderButton.Enabled = $false
    $comboBox.Enabled = $false
    
    # Update progress bar
    $progressBar.Maximum = $totalFiles
    $progressBar.Value = 0
    $progressBar.Visible = $true

    # Process files
    $successCount = 0
    $errorCount = 0
    
    try {
        # Loop through all HEIC files in the selected folder
        $files | ForEach-Object -Begin {
            $i = 0
        } -Process {
            $heicFile = $_.FullName
            $outputFile = "$($script:selectedFolderPath)\$($_.BaseName).$outputFormat"
            
            # Check if output file already exists
            if (Test-Path $outputFile) {
                $overwriteResult = [System.Windows.Forms.MessageBox]::Show("File '$($_.BaseName).$outputFormat' already exists. Overwrite?", "File Exists", [System.Windows.Forms.MessageBoxButtons]::YesNoCancel, [System.Windows.Forms.MessageBoxIcon]::Question)
                if ($overwriteResult -eq [System.Windows.Forms.DialogResult]::Cancel) {
                    return  # Exit the conversion process
                } elseif ($overwriteResult -eq [System.Windows.Forms.DialogResult]::No) {
                    $i++
                    $progressBar.Value = $i
                    return  # Skip this file
                }
            }
            
            # Perform the conversion
            if (Convert-HEICFile -InputFile $heicFile -OutputFile $outputFile) {
                $successCount++
                Write-Host "✅ Converted: $($_.Name) -> $($_.BaseName).$outputFormat"
            } else {
                $errorCount++
                Write-Host "❌ Failed: $($_.Name)"
            }
            
            # Update progress bar
            $i++
            $progressBar.Value = $i
            
            # Allow UI to update
            [System.Windows.Forms.Application]::DoEvents()
        }
        
        # Show completion message
        $message = "Conversion completed!`n`nSuccessful: $successCount`nFailed: $errorCount"
        $icon = if ($errorCount -eq 0) { [System.Windows.Forms.MessageBoxIcon]::Information } else { [System.Windows.Forms.MessageBoxIcon]::Warning }
        [System.Windows.Forms.MessageBox]::Show($message, "Conversion Complete", [System.Windows.Forms.MessageBoxButtons]::OK, $icon)
        
    } finally {
        # Re-enable controls
        $convertButton.Enabled = $true
        $folderButton.Enabled = $true
        $comboBox.Enabled = $true
        $progressBar.Value = 0
    }
})

# Show the form and ensure proper cleanup
try {
    $result = $form.ShowDialog()
} finally {
    # Dispose of form and controls
    if ($form) {
        $form.Dispose()
    }
}
