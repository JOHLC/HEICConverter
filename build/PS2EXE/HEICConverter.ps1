# HEIC to Image Format Converter Script with Full GUI and Progress Indicator
# Author: YourName

# Load Windows Forms for folder and format selection dialog
Add-Type -AssemblyName "System.Windows.Forms"

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "HEIC to Image Format Converter"
$form.Size = New-Object System.Drawing.Size(400, 250)  # Adjusted size

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
        $folderLabel.Text = "Selected Folder: $global:folderPath"
    } else {
        Write-Host "No folder selected"  # Debugging message
    }
})

# Event handler for conversion
$convertButton.Add_Click({
    if ([string]::IsNullOrEmpty($global:folderPath)) {
        [System.Windows.Forms.MessageBox]::Show("Please select a folder first.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    $outputFormat = $comboBox.SelectedItem
    [System.Windows.Forms.MessageBox]::Show("Starting conversion to .$outputFormat", "Conversion Started", [System.Windows.Forms.MessageBoxButtons]::OK)

    # Get the list of .heic files in the selected folder
    $files = Get-ChildItem -Path $global:folderPath -Filter *.heic
    $totalFiles = $files.Count

    # Update progress bar max value
    $progressBar.Maximum = $totalFiles
    $progressBar.Value = 0

    # Loop through all .heic files in the selected folder
    $files | ForEach-Object -Begin {
        $i = 0
    } -Process {
        $heicFile = $_.FullName
        $outputFile = "$($global:folderPath)\$($_.BaseName).$outputFormat"
        
        # Perform the conversion using ImageMagick
        magick "$heicFile" "$outputFile"
        
        # Update progress bar
        $i++
        $progressBar.Value = $i
    }

    [System.Windows.Forms.MessageBox]::Show("Conversion completed!", "Done", [System.Windows.Forms.MessageBoxButtons]::OK)
})

# Show the form
$form.ShowDialog()
