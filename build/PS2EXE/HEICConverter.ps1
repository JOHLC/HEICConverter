# HEIC to Image Format Converter Script with Full GUI and Progress Indicator
# Author: Joel Common (JOHLC)

# Load Windows Forms for folder and format selection dialog
Add-Type -AssemblyName "System.Windows.Forms"
Add-Type -AssemblyName "System.Drawing"

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "HEIC to Image Format Converter"
$form.Size = New-Object System.Drawing.Size(500, 320)  # Increased size to prevent text wrapping
$form.MinimumSize = New-Object System.Drawing.Size(450, 300)  # Set minimum size
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

# Load and set the application icon
try {
    $iconPath = Join-Path $PSScriptRoot "icon.ico"
    if (Test-Path $iconPath) {
        $form.Icon = New-Object System.Drawing.Icon($iconPath)
    }
} catch {
    # Icon loading failed, continue without icon
    Write-Host "Failed to load icon: $($_.Exception.Message)"
}

# Create Folder Selection Button
$folderButton = New-Object System.Windows.Forms.Button
$folderButton.Text = "Select Folder"
$folderButton.Size = New-Object System.Drawing.Size(120, 35)
$folderButton.Location = New-Object System.Drawing.Point(20, 20)
$folderButton.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left
$form.Controls.Add($folderButton)

# Create a label to display the selected folder path
$folderLabel = New-Object System.Windows.Forms.Label
$folderLabel.Size = New-Object System.Drawing.Size(440, 40)  # Increased height for better text display
$folderLabel.Location = New-Object System.Drawing.Point(20, 70)
$folderLabel.Text = "No folder selected"
$folderLabel.AutoEllipsis = $true  # Add ellipsis for long paths
$folderLabel.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
$form.Controls.Add($folderLabel)

# Create a label for format selection
$formatLabel = New-Object System.Windows.Forms.Label
$formatLabel.Text = "Output Format:"
$formatLabel.Size = New-Object System.Drawing.Size(100, 20)
$formatLabel.Location = New-Object System.Drawing.Point(20, 125)
$formatLabel.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left
$form.Controls.Add($formatLabel)

# Create a ComboBox for format selection
$comboBox = New-Object System.Windows.Forms.ComboBox
$comboBox.Items.AddRange(@("jpg", "png", "bmp", "gif"))
$comboBox.SelectedIndex = 0
$comboBox.Size = New-Object System.Drawing.Size(120, 30)
$comboBox.Location = New-Object System.Drawing.Point(130, 122)
$comboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList  # Prevent manual editing
$comboBox.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left
$form.Controls.Add($comboBox)

# Create a button to start the conversion process
$convertButton = New-Object System.Windows.Forms.Button
$convertButton.Text = "Convert Files"
$convertButton.Size = New-Object System.Drawing.Size(120, 35)
$convertButton.Location = New-Object System.Drawing.Point(20, 165)
$convertButton.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left
$form.Controls.Add($convertButton)

# Create a progress bar to show conversion progress
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Size = New-Object System.Drawing.Size(440, 25)
$progressBar.Location = New-Object System.Drawing.Point(20, 220)
$progressBar.Style = [System.Windows.Forms.ProgressBarStyle]::Continuous
$progressBar.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
$form.Controls.Add($progressBar)

# Create a status label
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Ready to convert HEIC files"
$statusLabel.Size = New-Object System.Drawing.Size(440, 20)
$statusLabel.Location = New-Object System.Drawing.Point(20, 255)
$statusLabel.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
$form.Controls.Add($statusLabel)

# Global variable to hold selected folder path
$global:folderPath = ""

# Event handler for folder selection
$folderButton.Add_Click({
    $folderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderDialog.Description = "Select the folder containing HEIC files"
    $folderDialog.ShowNewFolderButton = $false

    # Show the folder dialog and capture the selected folder
    $dialogResult = $folderDialog.ShowDialog()
    
    if ($dialogResult -eq "OK") {
        $global:folderPath = $folderDialog.SelectedPath
        Write-Host "Folder selected: $global:folderPath"  # Debugging message
        $folderLabel.Text = "Selected: $global:folderPath"
        $statusLabel.Text = "Folder selected. Choose format and click Convert Files."
        
        # Count HEIC files in the selected folder (case-insensitive by extension)
        $heicFiles = Get-ChildItem -Path $global:folderPath -File -ErrorAction SilentlyContinue | Where-Object { $_.Extension -ieq ".heic" }
        if ($heicFiles.Count -gt 0) {
            $statusLabel.Text = "Found $($heicFiles.Count) HEIC file(s). Ready to convert."
        } else {
            $statusLabel.Text = "No HEIC files found in selected folder."
        }
    } else {
        Write-Host "No folder selected"  # Debugging message
        $statusLabel.Text = "No folder selected."
    }
})

# Event handler for conversion
$convertButton.Add_Click({
    if ([string]::IsNullOrEmpty($global:folderPath)) {
        [System.Windows.Forms.MessageBox]::Show("Please select a folder first.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        $statusLabel.Text = "Please select a folder containing HEIC files."
        return
    }

    # Check if ImageMagick is available
    try {
        $null = Get-Command "magick" -ErrorAction Stop
    } catch {
        [System.Windows.Forms.MessageBox]::Show("ImageMagick 'magick' command not found. Please ensure ImageMagick is installed and in your PATH.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        $statusLabel.Text = "ImageMagick not found. Please install ImageMagick."
        return
    }

    $outputFormat = $comboBox.SelectedItem
    $statusLabel.Text = "Starting conversion to .$outputFormat format..."

    # Get the list of .heic files in the selected folder
    $files = Get-ChildItem -Path $global:folderPath -Filter *.heic -ErrorAction SilentlyContinue
    $totalFiles = $files.Count

    if ($totalFiles -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("No HEIC files found in the selected folder.", "No Files Found", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        $statusLabel.Text = "No HEIC files found in selected folder."
        return
    }

    # Update progress bar max value
    $progressBar.Maximum = $totalFiles
    $progressBar.Value = 0
    
    # Disable the convert button during conversion
    $convertButton.Enabled = $false
    $convertButton.Text = "Converting..."

    # Loop through all .heic files in the selected folder
    $files | ForEach-Object -Begin {
        $i = 0
        $successCount = 0
        $errorCount = 0
    } -Process {
        $heicFile = $_.FullName
        $outputFile = Join-Path $global:folderPath "$($_.BaseName).$outputFormat"
        
        try {
            # Update status for current file
            $statusLabel.Text = "Converting: $($_.Name) ($($i + 1) of $totalFiles)"
            $form.Refresh()  # Force UI update
            [System.Windows.Forms.Application]::DoEvents()
            
            # Perform the conversion using ImageMagick
            $result = & magick "$heicFile" "$outputFile" 2>&1
            
            if ($LASTEXITCODE -eq 0) {
                $successCount++
            } else {
                $errorCount++
                Write-Host "Error converting $($_.Name): $result"
            }
        } catch {
            $errorCount++
            Write-Host "Exception converting $($_.Name): $($_.Exception.Message)"
        }
        
        # Update progress bar
        $i++
        $progressBar.Value = $i
    }
    
    # Re-enable the convert button
    $convertButton.Enabled = $true
    $convertButton.Text = "Convert Files"
    
    # Show completion message
    if ($errorCount -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Conversion completed successfully!`n$successCount file(s) converted.", "Conversion Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        $statusLabel.Text = "Conversion completed! $successCount file(s) converted successfully."
    } else {
        [System.Windows.Forms.MessageBox]::Show("Conversion completed with some errors.`n$successCount file(s) converted successfully.`n$errorCount file(s) failed.", "Conversion Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        $statusLabel.Text = "Conversion completed. $successCount successful, $errorCount failed."
    }
})

# Show the form
$form.ShowDialog()
