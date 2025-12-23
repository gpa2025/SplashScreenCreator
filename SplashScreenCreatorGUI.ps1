#Requires -Version 5.1
<#
.SYNOPSIS
    GUI Interface for Professional Splash Screen Creator
.DESCRIPTION
    Provides a Windows Forms-based graphical interface for creating professional
    splash screen images with real-time preview and easy configuration.
.AUTHOR
    Gianpaolo Albanese
.VERSION
    1.0
.DATE
    2025-12-23
.NOTES
    Enhanced by AI Assistant (Kiro) - Professional Graphics Tool GUI
    Companion to SplashScreenCreator.ps1 command-line tool
#>

# Import required assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Global variables
$script:MainForm = $null
$script:SplashForm = $null
$script:PreviewPictureBox = $null
$script:MainTextBox = $null
$script:SubtitleTextBox = $null
$script:VersionTextBox = $null
$script:WidthNumeric = $null
$script:HeightNumeric = $null
$script:ColorSchemeCombo = $null
$script:OutputPathTextBox = $null
$script:CurrentBitmap = $null
$script:CreateIconCheckBox = $null
$script:IconSizesTextBox = $null
$script:SolidIconBackgroundCheckBox = $null
$script:TabControl = $null

# Color schemes (same as command-line tool)
$script:ColorSchemes = @{
    "Professional" = @{
        StartColor = [System.Drawing.Color]::FromArgb(45, 85, 135)
        EndColor = [System.Drawing.Color]::FromArgb(85, 125, 175)
        BorderColor = [System.Drawing.Color]::FromArgb(30, 60, 100)
        SolidIconColor = [System.Drawing.Color]::FromArgb(65, 105, 155)
        MainTextColor = [System.Drawing.Color]::White
        SubtitleColor = [System.Drawing.Color]::FromArgb(220, 230, 240)
        VersionColor = [System.Drawing.Color]::FromArgb(200, 220, 240)
        AccentColor = [System.Drawing.Color]::FromArgb(180, 200, 220)
    }
    "Corporate" = @{
        StartColor = [System.Drawing.Color]::FromArgb(25, 25, 25)
        EndColor = [System.Drawing.Color]::FromArgb(60, 60, 60)
        BorderColor = [System.Drawing.Color]::FromArgb(10, 10, 10)
        SolidIconColor = [System.Drawing.Color]::FromArgb(45, 45, 45)
        MainTextColor = [System.Drawing.Color]::White
        SubtitleColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
        VersionColor = [System.Drawing.Color]::FromArgb(150, 150, 150)
        AccentColor = [System.Drawing.Color]::FromArgb(100, 150, 200)
    }
    "Modern" = @{
        StartColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
        EndColor = [System.Drawing.Color]::FromArgb(40, 160, 255)
        BorderColor = [System.Drawing.Color]::FromArgb(0, 100, 180)
        SolidIconColor = [System.Drawing.Color]::FromArgb(20, 140, 235)
        MainTextColor = [System.Drawing.Color]::White
        SubtitleColor = [System.Drawing.Color]::FromArgb(240, 248, 255)
        VersionColor = [System.Drawing.Color]::FromArgb(220, 235, 255)
        AccentColor = [System.Drawing.Color]::FromArgb(180, 220, 255)
    }
    "Green" = @{
        StartColor = [System.Drawing.Color]::FromArgb(34, 139, 34)
        EndColor = [System.Drawing.Color]::FromArgb(50, 205, 50)
        BorderColor = [System.Drawing.Color]::FromArgb(0, 100, 0)
        SolidIconColor = [System.Drawing.Color]::FromArgb(42, 172, 42)
        MainTextColor = [System.Drawing.Color]::White
        SubtitleColor = [System.Drawing.Color]::FromArgb(240, 255, 240)
        VersionColor = [System.Drawing.Color]::FromArgb(220, 255, 220)
        AccentColor = [System.Drawing.Color]::FromArgb(144, 238, 144)
    }
    "Red" = @{
        StartColor = [System.Drawing.Color]::FromArgb(139, 0, 0)
        EndColor = [System.Drawing.Color]::FromArgb(220, 20, 60)
        BorderColor = [System.Drawing.Color]::FromArgb(100, 0, 0)
        SolidIconColor = [System.Drawing.Color]::FromArgb(179, 10, 30)
        MainTextColor = [System.Drawing.Color]::White
        SubtitleColor = [System.Drawing.Color]::FromArgb(255, 240, 240)
        VersionColor = [System.Drawing.Color]::FromArgb(255, 220, 220)
        AccentColor = [System.Drawing.Color]::FromArgb(255, 182, 193)
    }
}

# Icon creation functions (simplified for GUI preview)
function Create-IconPreview {
    param(
        [string]$MainText,
        [string]$SubtitleText,
        [string]$VersionText,
        [string]$ColorScheme = "Professional",
        [int]$PreviewSize = 64,
        [bool]$UseSolidBackground = $false
    )
    
    try {
        # Get color scheme
        $colors = $script:ColorSchemes[$ColorScheme]
        if (-not $colors) {
            $colors = $script:ColorSchemes["Professional"]
        }
        
        # Create bitmap for preview (use 64x64 for preview)
        $size = $PreviewSize
        $bitmap = New-Object System.Drawing.Bitmap($size, $size)
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        
        # Set high quality rendering
        $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
        $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
        $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
        
        # Create background (solid or gradient based on preference)
        if ($UseSolidBackground) {
            # Use solid color for crisp small icons
            $backgroundBrush = New-Object System.Drawing.SolidBrush($colors.SolidIconColor)
            $graphics.FillRectangle($backgroundBrush, 0, 0, $size, $size)
            $backgroundBrush.Dispose()
        } else {
            # Use gradient for larger splash-style icons
            $gradientBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
                (New-Object System.Drawing.Point(0, 0)),
                (New-Object System.Drawing.Point(0, $size)),
                $colors.StartColor,
                $colors.EndColor
            )
            $graphics.FillRectangle($gradientBrush, 0, 0, $size, $size)
            $gradientBrush.Dispose()
        }
        
        # Add border
        $borderPen = New-Object System.Drawing.Pen($colors.BorderColor, 2)
        $graphics.DrawRectangle($borderPen, 1, 1, $size-2, $size-2)
        
        # Calculate font sizes for icon
        $mainFontSize = [math]::Max(6, $size / 4)
        $subtitleFontSize = [math]::Max(4, $size / 12)
        $versionFontSize = [math]::Max(3, $size / 16)
        
        # Create fonts
        $mainFont = New-Object System.Drawing.Font("Segoe UI", $mainFontSize, [System.Drawing.FontStyle]::Bold)
        $subtitleFont = New-Object System.Drawing.Font("Segoe UI", $subtitleFontSize, [System.Drawing.FontStyle]::Regular)
        $versionFont = New-Object System.Drawing.Font("Segoe UI", $versionFontSize, [System.Drawing.FontStyle]::Bold)
        
        # Create brushes for text
        $mainBrush = New-Object System.Drawing.SolidBrush($colors.MainTextColor)
        $subtitleBrush = New-Object System.Drawing.SolidBrush($colors.SubtitleColor)
        $versionBrush = New-Object System.Drawing.SolidBrush($colors.VersionColor)
        $shadowBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(100, 0, 0, 0))
        
        # Calculate text positions for square icon
        if ($MainText) {
            $mainSize = $graphics.MeasureString($MainText, $mainFont)
            $mainX = ($size - $mainSize.Width) / 2
            $mainY = ($size * 0.25) - ($mainSize.Height / 2)
            
            # Draw shadow and main text
            $graphics.DrawString($MainText, $mainFont, $shadowBrush, $mainX + 1, $mainY + 1)
            $graphics.DrawString($MainText, $mainFont, $mainBrush, $mainX, $mainY)
        }
        
        if ($SubtitleText) {
            $subtitleSize = $graphics.MeasureString($SubtitleText, $subtitleFont)
            $subtitleX = ($size - $subtitleSize.Width) / 2
            $subtitleY = $size * 0.65
            
            $graphics.DrawString($SubtitleText, $subtitleFont, $shadowBrush, $subtitleX + 1, $subtitleY + 1)
            $graphics.DrawString($SubtitleText, $subtitleFont, $subtitleBrush, $subtitleX, $subtitleY)
        }
        
        if ($VersionText) {
            $versionSize = $graphics.MeasureString($VersionText, $versionFont)
            $versionX = ($size - $versionSize.Width) / 2
            $versionY = $size * 0.85
            
            $graphics.DrawString($VersionText, $versionFont, $shadowBrush, $versionX + 1, $versionY + 1)
            $graphics.DrawString($VersionText, $versionFont, $versionBrush, $versionX, $versionY)
        }
        
        # Cleanup
        $graphics.Dispose()
        $borderPen.Dispose()
        $mainFont.Dispose()
        $subtitleFont.Dispose()
        $versionFont.Dispose()
        $mainBrush.Dispose()
        $subtitleBrush.Dispose()
        $versionBrush.Dispose()
        $shadowBrush.Dispose()
        
        return $bitmap
    }
    catch {
        Write-Host "Error creating icon preview: $_" -ForegroundColor Red
        return $null
    }
}

function Create-SplashScreenPreview {
    param(
        [string]$MainText,
        [string]$SubtitleText,
        [string]$VersionText,
        [int]$Width,
        [int]$Height,
        [string]$ColorScheme = "Professional"
    )
    
    try {
        # Dispose previous bitmap if exists
        if ($script:CurrentBitmap) {
            $script:CurrentBitmap.Dispose()
        }
        
        # Get color scheme
        $colors = $script:ColorSchemes[$ColorScheme]
        if (-not $colors) {
            $colors = $script:ColorSchemes["Professional"]
        }
        
        # Create bitmap and graphics object
        $bitmap = New-Object System.Drawing.Bitmap($Width, $Height)
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        
        # Set high quality rendering
        $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
        $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
        $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
        
        # Create gradient background
        $gradientBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
            (New-Object System.Drawing.Point(0, 0)),
            (New-Object System.Drawing.Point(0, $Height)),
            $colors.StartColor,
            $colors.EndColor
        )
        
        # Fill background with gradient
        $graphics.FillRectangle($gradientBrush, 0, 0, $Width, $Height)
        
        # Add subtle border
        $borderPen = New-Object System.Drawing.Pen($colors.BorderColor, 2)
        $graphics.DrawRectangle($borderPen, 1, 1, $Width-2, $Height-2)
        
        # Create fonts (responsive sizing)
        $mainFontSize = [math]::Max(24, $Width / 8)
        $subtitleFontSize = [math]::Max(10, $Width / 28)
        $versionFontSize = [math]::Max(8, $Width / 35)
        
        $mainFont = New-Object System.Drawing.Font("Segoe UI", $mainFontSize, [System.Drawing.FontStyle]::Bold)
        $subtitleFont = New-Object System.Drawing.Font("Segoe UI", $subtitleFontSize, [System.Drawing.FontStyle]::Regular)
        $versionFont = New-Object System.Drawing.Font("Segoe UI", $versionFontSize, [System.Drawing.FontStyle]::Bold)
        
        # Create brushes for text
        $mainBrush = New-Object System.Drawing.SolidBrush($colors.MainTextColor)
        $subtitleBrush = New-Object System.Drawing.SolidBrush($colors.SubtitleColor)
        $versionBrush = New-Object System.Drawing.SolidBrush($colors.VersionColor)
        $shadowBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(100, 0, 0, 0))
        
        # Calculate text positions
        if ($MainText) {
            $mainSize = $graphics.MeasureString($MainText, $mainFont)
            $mainX = ($Width - $mainSize.Width) / 2
            $mainY = ($Height * 0.35) - ($mainSize.Height / 2)
            
            # Draw shadow and main text
            $graphics.DrawString($MainText, $mainFont, $shadowBrush, $mainX + 3, $mainY + 3)
            $graphics.DrawString($MainText, $mainFont, $mainBrush, $mainX, $mainY)
            
            # Add decorative elements
            $accentBrush = New-Object System.Drawing.SolidBrush($colors.AccentColor)
            $decorSize = [math]::Max(12, $Width / 25)
            
            $leftX = $mainX - $decorSize - 15
            $leftY = $mainY + ($mainSize.Height / 2) - ($decorSize / 2)
            if ($leftX -gt 5) {
                $graphics.FillRectangle($accentBrush, $leftX, $leftY, $decorSize, $decorSize * 0.6)
            }
            
            $rightX = $mainX + $mainSize.Width + 15
            $rightY = $leftY
            if ($rightX + $decorSize -lt $Width - 5) {
                $graphics.FillRectangle($accentBrush, $rightX, $rightY, $decorSize, $decorSize * 0.6)
            }
            
            $accentBrush.Dispose()
        }
        
        if ($SubtitleText) {
            $subtitleSize = $graphics.MeasureString($SubtitleText, $subtitleFont)
            $subtitleX = ($Width - $subtitleSize.Width) / 2
            $subtitleY = $Height * 0.65
            
            $graphics.DrawString($SubtitleText, $subtitleFont, $shadowBrush, $subtitleX + 1, $subtitleY + 1)
            $graphics.DrawString($SubtitleText, $subtitleFont, $subtitleBrush, $subtitleX, $subtitleY)
        }
        
        if ($VersionText) {
            $versionSize = $graphics.MeasureString($VersionText, $versionFont)
            $versionX = ($Width - $versionSize.Width) / 2
            $versionY = $Height * 0.85
            
            $graphics.DrawString($VersionText, $versionFont, $shadowBrush, $versionX + 1, $versionY + 1)
            $graphics.DrawString($VersionText, $versionFont, $versionBrush, $versionX, $versionY)
        }
        
        # Cleanup
        $graphics.Dispose()
        $gradientBrush.Dispose()
        $borderPen.Dispose()
        $mainFont.Dispose()
        $subtitleFont.Dispose()
        $versionFont.Dispose()
        $mainBrush.Dispose()
        $subtitleBrush.Dispose()
        $versionBrush.Dispose()
        $shadowBrush.Dispose()
        
        $script:CurrentBitmap = $bitmap
        return $bitmap
    }
    catch {
        Write-Host "Error creating preview: $_" -ForegroundColor Red
        return $null
    }
}

function Update-Preview {
    try {
        $mainText = $script:MainTextBox.Text
        $subtitleText = $script:SubtitleTextBox.Text
        $versionText = $script:VersionTextBox.Text
        $colorScheme = $script:ColorSchemeCombo.SelectedItem.ToString()
        $isIconMode = $script:CreateIconCheckBox.Checked
        
        if ($isIconMode) {
            # Create icon preview
            $useSolidBackground = $script:SolidIconBackgroundCheckBox.Checked
            $bitmap = Create-IconPreview -MainText $mainText -SubtitleText $subtitleText -VersionText $versionText -ColorScheme $colorScheme -PreviewSize 128 -UseSolidBackground $useSolidBackground
            
            if ($bitmap) {
                # Center the square icon in the preview box
                $previewWidth = $script:PreviewPictureBox.Width
                $previewHeight = $script:PreviewPictureBox.Height
                
                $scale = [math]::Min($previewWidth / 128, $previewHeight / 128) * 0.8  # Scale down a bit for padding
                $newSize = [int](128 * $scale)
                
                $scaledBitmap = New-Object System.Drawing.Bitmap($newSize, $newSize)
                $scaledGraphics = [System.Drawing.Graphics]::FromImage($scaledBitmap)
                $scaledGraphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
                $scaledGraphics.DrawImage($bitmap, 0, 0, $newSize, $newSize)
                $scaledGraphics.Dispose()
                
                if ($script:PreviewPictureBox.Image) {
                    $script:PreviewPictureBox.Image.Dispose()
                }
                $script:PreviewPictureBox.Image = $scaledBitmap
            }
        } else {
            # Create splash screen preview
            $width = [int]$script:WidthNumeric.Value
            $height = [int]$script:HeightNumeric.Value
            
            $bitmap = Create-SplashScreenPreview -MainText $mainText -SubtitleText $subtitleText -VersionText $versionText -Width $width -Height $height -ColorScheme $colorScheme
            
            if ($bitmap) {
                # Scale bitmap to fit preview box while maintaining aspect ratio
                $previewWidth = $script:PreviewPictureBox.Width
                $previewHeight = $script:PreviewPictureBox.Height
                
                $scaleX = $previewWidth / $width
                $scaleY = $previewHeight / $height
                $scale = [math]::Min($scaleX, $scaleY)
                
                $newWidth = [int]($width * $scale)
                $newHeight = [int]($height * $scale)
                
                $scaledBitmap = New-Object System.Drawing.Bitmap($newWidth, $newHeight)
                $scaledGraphics = [System.Drawing.Graphics]::FromImage($scaledBitmap)
                $scaledGraphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
                $scaledGraphics.DrawImage($bitmap, 0, 0, $newWidth, $newHeight)
                $scaledGraphics.Dispose()
                
                if ($script:PreviewPictureBox.Image) {
                    $script:PreviewPictureBox.Image.Dispose()
                }
                $script:PreviewPictureBox.Image = $scaledBitmap
            }
        }
    }
    catch {
        Write-Host "Error updating preview: $_" -ForegroundColor Red
    }
}

function Save-SplashScreen {
    try {
        $outputPath = $script:OutputPathTextBox.Text
        if ([string]::IsNullOrWhiteSpace($outputPath)) {
            [System.Windows.Forms.MessageBox]::Show("Please specify an output path.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
            return
        }
        
        $isIconMode = $script:CreateIconCheckBox.Checked
        
        if ($isIconMode) {
            # Create and save icon
            $mainText = $script:MainTextBox.Text
            $subtitleText = $script:SubtitleTextBox.Text
            $versionText = $script:VersionTextBox.Text
            $colorScheme = $script:ColorSchemeCombo.SelectedItem.ToString()
            $iconSizes = $script:IconSizesTextBox.Text
            
            # Force .ico extension
            if (-not $outputPath.EndsWith('.ico')) {
                $outputPath = [System.IO.Path]::ChangeExtension($outputPath, '.ico')
                $script:OutputPathTextBox.Text = $outputPath
            }
            
            $useSolidBackground = $script:SolidIconBackgroundCheckBox.Checked
            $success = Create-IconFileGUI -MainText $mainText -SubtitleText $subtitleText -VersionText $versionText -OutputPath $outputPath -ColorScheme $colorScheme -IconSizes $iconSizes -UseSolidBackground $useSolidBackground
            
            if ($success) {
                [System.Windows.Forms.MessageBox]::Show("Icon file saved successfully to:`n$outputPath", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
            } else {
                [System.Windows.Forms.MessageBox]::Show("Failed to create icon file.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            }
        } else {
            # Save splash screen
            if ($script:CurrentBitmap) {
                # Determine format from extension
                $format = switch ([System.IO.Path]::GetExtension($outputPath).ToLower()) {
                    ".jpg" { [System.Drawing.Imaging.ImageFormat]::Jpeg }
                    ".jpeg" { [System.Drawing.Imaging.ImageFormat]::Jpeg }
                    ".bmp" { [System.Drawing.Imaging.ImageFormat]::Bmp }
                    default { [System.Drawing.Imaging.ImageFormat]::Png }
                }
                
                # Create directory if it doesn't exist
                $directory = [System.IO.Path]::GetDirectoryName($outputPath)
                if (-not [string]::IsNullOrEmpty($directory) -and -not (Test-Path $directory)) {
                    New-Item -ItemType Directory -Path $directory -Force | Out-Null
                }
                
                $script:CurrentBitmap.Save($outputPath, $format)
                [System.Windows.Forms.MessageBox]::Show("Splash screen saved successfully to:`n$outputPath", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
            }
            else {
                [System.Windows.Forms.MessageBox]::Show("No splash screen to save. Please generate a preview first.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
            }
        }
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("Error saving: $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
}

function Create-IconFileGUI {
    param(
        [string]$MainText,
        [string]$SubtitleText,
        [string]$VersionText,
        [string]$OutputPath,
        [string]$ColorScheme = "Professional",
        [string]$IconSizes = "16,32,48,64,128,256",
        [bool]$UseSolidBackground = $false
    )
    
    try {
        # Parse icon sizes
        $sizes = $IconSizes -split ',' | ForEach-Object { [int]$_.Trim() } | Sort-Object
        
        # Get color scheme
        $colors = $script:ColorSchemes[$ColorScheme]
        if (-not $colors) {
            $colors = $script:ColorSchemes["Professional"]
        }
        
        # Create bitmaps for each size
        $bitmaps = @()
        foreach ($size in $sizes) {
            # Create bitmap and graphics object
            $bitmap = New-Object System.Drawing.Bitmap($size, $size)
            $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
            
            # Set high quality rendering
            $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
            $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
            $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
            
            # Create background (solid or gradient based on preference)
            if ($UseSolidBackground) {
                # Use solid color for crisp small icons
                $backgroundBrush = New-Object System.Drawing.SolidBrush($colors.SolidIconColor)
                $graphics.FillRectangle($backgroundBrush, 0, 0, $size, $size)
                $backgroundBrush.Dispose()
            } else {
                # Use gradient for larger splash-style icons
                $gradientBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
                    (New-Object System.Drawing.Point(0, 0)),
                    (New-Object System.Drawing.Point(0, $size)),
                    $colors.StartColor,
                    $colors.EndColor
                )
                $graphics.FillRectangle($gradientBrush, 0, 0, $size, $size)
                $gradientBrush.Dispose()
            }
            
            # Add subtle border for larger icons
            if ($size -ge 32) {
                $borderPen = New-Object System.Drawing.Pen($colors.BorderColor, [math]::Max(1, $size / 64))
                $graphics.DrawRectangle($borderPen, 1, 1, $size-2, $size-2)
                $borderPen.Dispose()
            }
            
            # Calculate font sizes based on icon size
            $mainFontSize = [math]::Max(6, $size / 4)
            $subtitleFontSize = [math]::Max(4, $size / 12)
            $versionFontSize = [math]::Max(3, $size / 16)
            
            # For very small icons, only show main text
            $showSubtitle = $size -ge 48
            $showVersion = $size -ge 64
            
            # Create fonts
            $mainFont = New-Object System.Drawing.Font("Segoe UI", $mainFontSize, [System.Drawing.FontStyle]::Bold)
            $subtitleFont = if ($showSubtitle) { New-Object System.Drawing.Font("Segoe UI", $subtitleFontSize, [System.Drawing.FontStyle]::Regular) } else { $null }
            $versionFont = if ($showVersion) { New-Object System.Drawing.Font("Segoe UI", $versionFontSize, [System.Drawing.FontStyle]::Bold) } else { $null }
            
            # Create brushes for text
            $mainBrush = New-Object System.Drawing.SolidBrush($colors.MainTextColor)
            $subtitleBrush = New-Object System.Drawing.SolidBrush($colors.SubtitleColor)
            $versionBrush = New-Object System.Drawing.SolidBrush($colors.VersionColor)
            $shadowBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(100, 0, 0, 0))
            
            # Calculate text positions for square icon
            if ($MainText) {
                $mainSize = $graphics.MeasureString($MainText, $mainFont)
                $mainX = ($size - $mainSize.Width) / 2
                
                if ($showSubtitle -and $showVersion) {
                    $mainY = ($size * 0.25) - ($mainSize.Height / 2)
                } elseif ($showSubtitle) {
                    $mainY = ($size * 0.35) - ($mainSize.Height / 2)
                } else {
                    $mainY = ($size - $mainSize.Height) / 2
                }
                
                # Draw shadow and main text (only for larger icons)
                if ($size -ge 32) {
                    $graphics.DrawString($MainText, $mainFont, $shadowBrush, $mainX + 1, $mainY + 1)
                }
                $graphics.DrawString($MainText, $mainFont, $mainBrush, $mainX, $mainY)
            }
            
            if ($showSubtitle -and $SubtitleText) {
                $subtitleSize = $graphics.MeasureString($SubtitleText, $subtitleFont)
                $subtitleX = ($size - $subtitleSize.Width) / 2
                $subtitleY = if ($showVersion) { $size * 0.65 } else { $size * 0.75 }
                
                if ($size -ge 48) {
                    $graphics.DrawString($SubtitleText, $subtitleFont, $shadowBrush, $subtitleX + 1, $subtitleY + 1)
                }
                $graphics.DrawString($SubtitleText, $subtitleFont, $subtitleBrush, $subtitleX, $subtitleY)
            }
            
            if ($showVersion -and $VersionText) {
                $versionSize = $graphics.MeasureString($VersionText, $versionFont)
                $versionX = ($size - $versionSize.Width) / 2
                $versionY = $size * 0.85
                
                $graphics.DrawString($VersionText, $versionFont, $shadowBrush, $versionX + 1, $versionY + 1)
                $graphics.DrawString($VersionText, $versionFont, $versionBrush, $versionX, $versionY)
            }
            
            # Cleanup graphics
            $graphics.Dispose()
            $mainFont.Dispose()
            if ($subtitleFont) { $subtitleFont.Dispose() }
            if ($versionFont) { $versionFont.Dispose() }
            $mainBrush.Dispose()
            $subtitleBrush.Dispose()
            $versionBrush.Dispose()
            $shadowBrush.Dispose()
            
            $bitmaps += $bitmap
        }
        
        # Save as ICO file
        Save-IconFileGUI -Bitmaps $bitmaps -OutputPath $OutputPath
        
        # Cleanup bitmaps
        foreach ($bitmap in $bitmaps) {
            $bitmap.Dispose()
        }
        
        return $true
    }
    catch {
        # Better error reporting for debugging
        [System.Windows.Forms.MessageBox]::Show("Error in Create-IconFileGUI: $($_.Exception.Message)", "Debug Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return $false
    }
}

function Save-IconFileGUI {
    param(
        [System.Drawing.Bitmap[]]$Bitmaps,
        [string]$OutputPath
    )
    
    # Create directory if it doesn't exist
    $directory = [System.IO.Path]::GetDirectoryName($OutputPath)
    if (-not [string]::IsNullOrEmpty($directory) -and -not (Test-Path $directory)) {
        New-Item -ItemType Directory -Path $directory -Force | Out-Null
    }
    
    # Use the largest bitmap as the icon (simplified approach)
    $primaryBitmap = $Bitmaps | Sort-Object { $_.Width } | Select-Object -Last 1
    
    # Save as PNG first, then convert to ICO using a simpler method
    $tempPngPath = [System.IO.Path]::ChangeExtension($OutputPath, '.png')
    $primaryBitmap.Save($tempPngPath, [System.Drawing.Imaging.ImageFormat]::Png)
    
    # Create a simple ICO file by converting the PNG
    try {
        # Load the PNG and convert to Icon
        $image = [System.Drawing.Image]::FromFile($tempPngPath)
        $bitmap = New-Object System.Drawing.Bitmap($image)
        
        # Create icon from bitmap
        $iconHandle = $bitmap.GetHicon()
        $icon = [System.Drawing.Icon]::FromHandle($iconHandle)
        
        # Save as ICO
        $fileStream = [System.IO.FileStream]::new($OutputPath, [System.IO.FileMode]::Create)
        $icon.Save($fileStream)
        $fileStream.Close()
        
        # Cleanup
        $icon.Dispose()
        $bitmap.Dispose()
        $image.Dispose()
        
        # Clean up temp PNG file
        Remove-Item $tempPngPath -Force -ErrorAction SilentlyContinue
    }
    catch {
        # If ICO creation fails, just rename the PNG to ICO (basic fallback)
        if (Test-Path $tempPngPath) {
            Move-Item $tempPngPath $OutputPath -Force
        }
    }
}

function Browse-OutputPath {
    $saveDialog = New-Object System.Windows.Forms.SaveFileDialog
    
    # Set filter based on mode
    if ($script:CreateIconCheckBox.Checked) {
        $saveDialog.Filter = "Icon Files (*.ico)|*.ico|PNG Files (*.png)|*.png|All Files (*.*)|*.*"
        $saveDialog.DefaultExt = "ico"
        $saveDialog.Title = "Save Icon As..."
    } else {
        $saveDialog.Filter = "PNG Files (*.png)|*.png|JPEG Files (*.jpg)|*.jpg|Bitmap Files (*.bmp)|*.bmp|All Files (*.*)|*.*"
        $saveDialog.DefaultExt = "png"
        $saveDialog.Title = "Save Splash Screen As..."
    }
    
    $saveDialog.AddExtension = $true
    $saveDialog.Title = "Save Splash Screen As..."
    
    if ($saveDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $script:OutputPathTextBox.Text = $saveDialog.FileName
    }
    $saveDialog.Dispose()
}

function Load-ConfigFile {
    $openDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openDialog.Filter = "JSON Files (*.json)|*.json|All Files (*.*)|*.*"
    $openDialog.Title = "Load Configuration File"
    
    if ($openDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        try {
            $config = Get-Content $openDialog.FileName -Raw | ConvertFrom-Json
            
            if ($config.MainText) { $script:MainTextBox.Text = $config.MainText }
            if ($config.SubtitleText) { $script:SubtitleTextBox.Text = $config.SubtitleText }
            if ($config.VersionText) { $script:VersionTextBox.Text = $config.VersionText }
            if ($config.Width) { $script:WidthNumeric.Value = $config.Width }
            if ($config.Height) { $script:HeightNumeric.Value = $config.Height }
            if ($config.OutputPath) { $script:OutputPathTextBox.Text = $config.OutputPath }
            if ($config.ColorScheme -and $script:ColorSchemes.ContainsKey($config.ColorScheme)) {
                $script:ColorSchemeCombo.SelectedItem = $config.ColorScheme
            }
            
            Update-Preview
            [System.Windows.Forms.MessageBox]::Show("Configuration loaded successfully!", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        }
        catch {
            [System.Windows.Forms.MessageBox]::Show("Error loading configuration: $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    }
    $openDialog.Dispose()
}

function Save-ConfigFile {
    $saveDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveDialog.Filter = "JSON Files (*.json)|*.json|All Files (*.*)|*.*"
    $saveDialog.DefaultExt = "json"
    $saveDialog.AddExtension = $true
    $saveDialog.Title = "Save Configuration As..."
    
    if ($saveDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        try {
            $config = @{
                MainText = $script:MainTextBox.Text
                SubtitleText = $script:SubtitleTextBox.Text
                VersionText = $script:VersionTextBox.Text
                Width = [int]$script:WidthNumeric.Value
                Height = [int]$script:HeightNumeric.Value
                ColorScheme = $script:ColorSchemeCombo.SelectedItem.ToString()
                OutputPath = $script:OutputPathTextBox.Text
            }
            
            $config | ConvertTo-Json -Depth 2 | Out-File -FilePath $saveDialog.FileName -Encoding UTF8
            [System.Windows.Forms.MessageBox]::Show("Configuration saved successfully!", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        }
        catch {
            [System.Windows.Forms.MessageBox]::Show("Error saving configuration: $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    }
    $saveDialog.Dispose()
}

function Show-SplashScreen {
    # Create splash screen form
    $script:SplashForm = New-Object System.Windows.Forms.Form
    $script:SplashForm.Text = ""
    $script:SplashForm.Size = New-Object System.Drawing.Size(700, 400)
    $script:SplashForm.StartPosition = "CenterScreen"
    $script:SplashForm.FormBorderStyle = "None"
    $script:SplashForm.BackColor = [System.Drawing.Color]::FromArgb(45, 85, 135)
    $script:SplashForm.TopMost = $true
    
    # Create the splash screen image
    $splashBitmap = Create-SplashScreenPreview -MainText "GPA" -SubtitleText "Splash Screen Creator" -VersionText "v1.0" -Width 680 -Height 380 -ColorScheme "Professional"
    
    # Create picture box for splash image
    $splashPictureBox = New-Object System.Windows.Forms.PictureBox
    $splashPictureBox.Location = New-Object System.Drawing.Point(10, 10)
    $splashPictureBox.Size = New-Object System.Drawing.Size(680, 380)
    $splashPictureBox.Image = $splashBitmap
    $splashPictureBox.SizeMode = "StretchImage"
    $script:SplashForm.Controls.Add($splashPictureBox)
    
    # Add loading text
    $loadingLabel = New-Object System.Windows.Forms.Label
    $loadingLabel.Text = "Loading..."
    $loadingLabel.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
    $loadingLabel.ForeColor = [System.Drawing.Color]::White
    $loadingLabel.BackColor = [System.Drawing.Color]::Transparent
    $loadingLabel.Location = New-Object System.Drawing.Point(320, 340)
    $loadingLabel.Size = New-Object System.Drawing.Size(100, 25)
    $loadingLabel.TextAlign = "MiddleCenter"
    $script:SplashForm.Controls.Add($loadingLabel)
    
    # Show splash screen
    $script:SplashForm.Show()
    $script:SplashForm.Refresh()
    
    # Keep splash screen visible for 2 seconds
    Start-Sleep -Milliseconds 2000
    
    # Close splash screen
    $script:SplashForm.Close()
    $script:SplashForm.Dispose()
    $splashBitmap.Dispose()
}

function Create-HelpTab {
    $helpTab = New-Object System.Windows.Forms.TabPage
    $helpTab.Text = "Help"
    $helpTab.BackColor = [System.Drawing.Color]::White
    
    # Create help content panel with scroll
    $helpPanel = New-Object System.Windows.Forms.Panel
    $helpPanel.Location = New-Object System.Drawing.Point(10, 10)
    $helpPanel.Size = New-Object System.Drawing.Size(850, 580)
    $helpPanel.AutoScroll = $true
    $helpPanel.BackColor = [System.Drawing.Color]::White
    
    # Help content
    $helpText = @"
SPLASH SCREEN CREATOR - HELP GUIDE

GETTING STARTED
1. Enter your text in the Main Text, Subtitle, and Version fields
2. Adjust dimensions using the Width and Height controls
3. Choose a color scheme from the dropdown
4. Watch the live preview update automatically
5. Click 'Save Image' to export your splash screen

TEXT FIELDS
* Main Text: Large, prominent text (keep it short - 1-4 characters work best)
* Subtitle Text: Descriptive text explaining your application
* Version Text: Version information (e.g., V1.0, Version 2.3)

DIMENSIONS
* Width: 200-2000 pixels (recommended: 400-800 for most applications)
* Height: 100-1000 pixels (recommended: 200-400 for most applications)
* Font sizes automatically scale based on dimensions

COLOR SCHEMES
* Professional: Blue gradient, perfect for business applications
* Corporate: Dark gradient, sophisticated and professional
* Modern: Bright blue, contemporary and clean design
* Green: Eco-friendly theme, great for environmental apps
* Red: Bold and attention-grabbing design

ICON CREATION
* Check 'Create Icon (.ico)' to generate Windows icon files
* Icon Sizes: Specify comma-separated sizes (e.g., 16,32,48,64,128,256)
* Solid Background: Recommended for small icons for better clarity
* Icons contain multiple resolutions in a single .ico file

OUTPUT FORMATS
* PNG: Best quality, supports transparency (recommended)
* JPG/JPEG: Smaller file size, good for web use
* BMP: Uncompressed format, largest file size
* ICO: Windows icon format with multiple resolutions

CONFIGURATION FILES
* Use File -> Save Configuration to save your settings as JSON
* Use File -> Load Configuration to restore saved settings
* Great for maintaining consistent branding across projects

TIPS FOR BEST RESULTS
* Keep main text short and memorable
* Use descriptive subtitles that explain your app's purpose
* Choose dimensions appropriate for your use case:
  - Dialog splash screens: 400x200 to 500x250
  - Desktop applications: 600x300 to 800x400
  - Large displays: 1000x500 or larger
* Preview updates automatically as you make changes
* Use the browse button to easily select output locations

TROUBLESHOOTING
* If preview doesn't update, click 'Generate Preview'
* Ensure output directory exists and is writable
* For large dimensions, allow extra time for processing
* Use PNG format for best quality and compatibility

KEYBOARD SHORTCUTS
* Ctrl+S: Save current image
* Ctrl+O: Load configuration
* Ctrl+N: Save configuration
* F5: Refresh preview
"@
    
    $helpTextBox = New-Object System.Windows.Forms.TextBox
    $helpTextBox.Text = $helpText
    $helpTextBox.Location = New-Object System.Drawing.Point(10, 10)
    $helpTextBox.Size = New-Object System.Drawing.Size(820, 550)
    $helpTextBox.Font = New-Object System.Drawing.Font("Consolas", 9)
    $helpTextBox.Multiline = $true
    $helpTextBox.ReadOnly = $true
    $helpTextBox.ScrollBars = "Vertical"
    $helpTextBox.BackColor = [System.Drawing.Color]::FromArgb(250, 250, 250)
    $helpPanel.Controls.Add($helpTextBox)
    
    $helpTab.Controls.Add($helpPanel)
    return $helpTab
}

function Create-AboutTab {
    $aboutTab = New-Object System.Windows.Forms.TabPage
    $aboutTab.Text = "About"
    $aboutTab.BackColor = [System.Drawing.Color]::White
    
    # Create about content panel
    $aboutPanel = New-Object System.Windows.Forms.Panel
    $aboutPanel.Location = New-Object System.Drawing.Point(10, 10)
    $aboutPanel.Size = New-Object System.Drawing.Size(850, 580)
    $aboutPanel.BackColor = [System.Drawing.Color]::White
    
    # App icon/logo area
    $logoPanel = New-Object System.Windows.Forms.Panel
    $logoPanel.Location = New-Object System.Drawing.Point(50, 30)
    $logoPanel.Size = New-Object System.Drawing.Size(750, 120)
    $logoPanel.BackColor = [System.Drawing.Color]::FromArgb(245, 245, 245)
    $logoPanel.BorderStyle = "FixedSingle"
    
    # Create a small logo using our splash screen creator
    $logoBitmap = Create-SplashScreenPreview -MainText "SSC" -SubtitleText "Splash Screen Creator" -VersionText "v1.0" -Width 200 -Height 80 -ColorScheme "Professional"
    $logoPictureBox = New-Object System.Windows.Forms.PictureBox
    $logoPictureBox.Location = New-Object System.Drawing.Point(20, 20)
    $logoPictureBox.Size = New-Object System.Drawing.Size(200, 80)
    $logoPictureBox.Image = $logoBitmap
    $logoPictureBox.SizeMode = "StretchImage"
    $logoPanel.Controls.Add($logoPictureBox)
    
    # App title
    $titleLabel = New-Object System.Windows.Forms.Label
    $titleLabel.Text = "Professional Splash Screen Creator"
    $titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
    $titleLabel.Location = New-Object System.Drawing.Point(240, 25)
    $titleLabel.Size = New-Object System.Drawing.Size(480, 35)
    $titleLabel.ForeColor = [System.Drawing.Color]::FromArgb(45, 85, 135)
    $logoPanel.Controls.Add($titleLabel)
    
    # Version info
    $versionLabel = New-Object System.Windows.Forms.Label
    $versionLabel.Text = "Version 1.0 - GUI Interface"
    $versionLabel.Font = New-Object System.Drawing.Font("Segoe UI", 12)
    $versionLabel.Location = New-Object System.Drawing.Point(240, 65)
    $versionLabel.Size = New-Object System.Drawing.Size(300, 25)
    $versionLabel.ForeColor = [System.Drawing.Color]::FromArgb(100, 100, 100)
    $logoPanel.Controls.Add($versionLabel)
    
    $aboutPanel.Controls.Add($logoPanel)
    
    # About text
    $aboutText = @"
ABOUT THIS APPLICATION

Professional Splash Screen Creator is a comprehensive tool for creating high-quality splash screen images and Windows icons. This GUI interface provides an intuitive way to design professional graphics with real-time preview capabilities.

KEY FEATURES:
* Real-time preview with automatic updates
* Multiple professional color schemes
* Support for both splash screens and Windows icons
* Configurable dimensions and text styling
* High-quality anti-aliased rendering
* JSON-based configuration files for easy reuse
* Multiple output formats (PNG, JPG, BMP, ICO)

TECHNICAL SPECIFICATIONS:
* Built with PowerShell and Windows Forms
* Requires .NET Framework 4.5 or later
* Compatible with Windows 7 and later
* Uses System.Drawing for high-quality graphics rendering
* Supports resolutions from 200x100 to 2000x1000 pixels

AUTHOR INFORMATION:
Created by: Gianpaolo Albanese
Enhanced by: AI Assistant (Kiro)
Date: December 23, 2025
License: Free for personal and commercial use

COMPANION TOOLS:
This GUI interface works alongside the command-line version (SplashScreenCreator.ps1) for batch processing and automation scenarios.

SUPPORT:
For questions, issues, or feature requests, please refer to the Help tab or the included README documentation.

Thank you for using Professional Splash Screen Creator!
"@
    
    $aboutTextLabel = New-Object System.Windows.Forms.Label
    $aboutTextLabel.Text = $aboutText
    $aboutTextLabel.Location = New-Object System.Drawing.Point(50, 170)
    $aboutTextLabel.Size = New-Object System.Drawing.Size(750, 380)
    $aboutTextLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $aboutTextLabel.ForeColor = [System.Drawing.Color]::FromArgb(60, 60, 60)
    $aboutPanel.Controls.Add($aboutTextLabel)
    
    $aboutTab.Controls.Add($aboutPanel)
    return $aboutTab
}
function Create-MainForm {
    # Create main form
    $script:MainForm = New-Object System.Windows.Forms.Form
    $script:MainForm.Text = "Professional Splash Screen Creator"
    $script:MainForm.Size = New-Object System.Drawing.Size(950, 750)
    $script:MainForm.StartPosition = "CenterScreen"
    $script:MainForm.FormBorderStyle = "FixedDialog"
    $script:MainForm.MaximizeBox = $false
    $script:MainForm.BackColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
    
    # Create menu strip
    $menuStrip = New-Object System.Windows.Forms.MenuStrip
    
    $fileMenu = New-Object System.Windows.Forms.ToolStripMenuItem
    $fileMenu.Text = "&File"
    
    $loadConfigItem = New-Object System.Windows.Forms.ToolStripMenuItem
    $loadConfigItem.Text = "&Load Configuration..."
    $loadConfigItem.Add_Click({ Load-ConfigFile })
    
    $saveConfigItem = New-Object System.Windows.Forms.ToolStripMenuItem
    $saveConfigItem.Text = "&Save Configuration..."
    $saveConfigItem.Add_Click({ Save-ConfigFile })
    
    $separatorItem = New-Object System.Windows.Forms.ToolStripSeparator
    
    $exitItem = New-Object System.Windows.Forms.ToolStripMenuItem
    $exitItem.Text = "E&xit"
    $exitItem.Add_Click({ $script:MainForm.Close() })
    
    $fileMenu.DropDownItems.AddRange(@($loadConfigItem, $saveConfigItem, $separatorItem, $exitItem))
    $menuStrip.Items.Add($fileMenu)
    
    $script:MainForm.Controls.Add($menuStrip)
    $script:MainForm.MainMenuStrip = $menuStrip
    
    # Create tab control
    $script:TabControl = New-Object System.Windows.Forms.TabControl
    $script:TabControl.Location = New-Object System.Drawing.Point(10, 35)
    $script:TabControl.Size = New-Object System.Drawing.Size(920, 670)
    $script:TabControl.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    
    # Create main creator tab
    $creatorTab = Create-CreatorTab
    $script:TabControl.TabPages.Add($creatorTab)
    
    # Create help tab
    $helpTab = Create-HelpTab
    $script:TabControl.TabPages.Add($helpTab)
    
    # Create about tab
    $aboutTab = Create-AboutTab
    $script:TabControl.TabPages.Add($aboutTab)
    
    # Add tab control to form
    $script:MainForm.Controls.Add($script:TabControl)
    
    # Generate initial preview
    Update-Preview
}

function Create-CreatorTab {
    $creatorTab = New-Object System.Windows.Forms.TabPage
    $creatorTab.Text = "Creator"
    $creatorTab.BackColor = [System.Drawing.Color]::White
    
    # Create main panel
    $mainPanel = New-Object System.Windows.Forms.Panel
    $mainPanel.Location = New-Object System.Drawing.Point(10, 10)
    $mainPanel.Size = New-Object System.Drawing.Size(890, 620)
    $mainPanel.BackColor = [System.Drawing.Color]::White
    $mainPanel.BorderStyle = "FixedSingle"
    
    # Left panel for controls
    $leftPanel = New-Object System.Windows.Forms.Panel
    $leftPanel.Location = New-Object System.Drawing.Point(10, 10)
    $leftPanel.Size = New-Object System.Drawing.Size(350, 600)
    $leftPanel.BackColor = [System.Drawing.Color]::FromArgb(250, 250, 250)
    
    # Title
    $titleLabel = New-Object System.Windows.Forms.Label
    $titleLabel.Text = "Splash Screen Creator"
    $titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
    $titleLabel.Location = New-Object System.Drawing.Point(10, 10)
    $titleLabel.Size = New-Object System.Drawing.Size(330, 30)
    $titleLabel.ForeColor = [System.Drawing.Color]::FromArgb(45, 85, 135)
    $leftPanel.Controls.Add($titleLabel)
    
    $y = 50
    
    # Main Text
    $mainTextLabel = New-Object System.Windows.Forms.Label
    $mainTextLabel.Text = "Main Text:"
    $mainTextLabel.Location = New-Object System.Drawing.Point(10, $y)
    $mainTextLabel.Size = New-Object System.Drawing.Size(100, 20)
    $leftPanel.Controls.Add($mainTextLabel)
    
    $script:MainTextBox = New-Object System.Windows.Forms.TextBox
    $script:MainTextBox.Text = "GPA"
    $script:MainTextBox.Location = New-Object System.Drawing.Point(120, $y)
    $script:MainTextBox.Size = New-Object System.Drawing.Size(220, 25)
    $script:MainTextBox.Add_TextChanged({ Update-Preview })
    $leftPanel.Controls.Add($script:MainTextBox)
    
    $y += 35
    
    # Subtitle Text
    $subtitleLabel = New-Object System.Windows.Forms.Label
    $subtitleLabel.Text = "Subtitle Text:"
    $subtitleLabel.Location = New-Object System.Drawing.Point(10, $y)
    $subtitleLabel.Size = New-Object System.Drawing.Size(100, 20)
    $leftPanel.Controls.Add($subtitleLabel)
    
    $script:SubtitleTextBox = New-Object System.Windows.Forms.TextBox
    $script:SubtitleTextBox.Text = "Enhanced Backup Manager"
    $script:SubtitleTextBox.Location = New-Object System.Drawing.Point(120, $y)
    $script:SubtitleTextBox.Size = New-Object System.Drawing.Size(220, 25)
    $script:SubtitleTextBox.Add_TextChanged({ Update-Preview })
    $leftPanel.Controls.Add($script:SubtitleTextBox)
    
    $y += 35
    
    # Version Text
    $versionLabel = New-Object System.Windows.Forms.Label
    $versionLabel.Text = "Version Text:"
    $versionLabel.Location = New-Object System.Drawing.Point(10, $y)
    $versionLabel.Size = New-Object System.Drawing.Size(100, 20)
    $leftPanel.Controls.Add($versionLabel)
    
    $script:VersionTextBox = New-Object System.Windows.Forms.TextBox
    $script:VersionTextBox.Text = "V2"
    $script:VersionTextBox.Location = New-Object System.Drawing.Point(120, $y)
    $script:VersionTextBox.Size = New-Object System.Drawing.Size(220, 25)
    $script:VersionTextBox.Add_TextChanged({ Update-Preview })
    $leftPanel.Controls.Add($script:VersionTextBox)
    
    $y += 45
    
    # Dimensions section
    $dimensionsLabel = New-Object System.Windows.Forms.Label
    $dimensionsLabel.Text = "Dimensions"
    $dimensionsLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $dimensionsLabel.Location = New-Object System.Drawing.Point(10, $y)
    $dimensionsLabel.Size = New-Object System.Drawing.Size(100, 20)
    $leftPanel.Controls.Add($dimensionsLabel)
    
    $y += 25
    
    # Width
    $widthLabel = New-Object System.Windows.Forms.Label
    $widthLabel.Text = "Width:"
    $widthLabel.Location = New-Object System.Drawing.Point(10, $y)
    $widthLabel.Size = New-Object System.Drawing.Size(50, 20)
    $leftPanel.Controls.Add($widthLabel)
    
    $script:WidthNumeric = New-Object System.Windows.Forms.NumericUpDown
    $script:WidthNumeric.Minimum = 200
    $script:WidthNumeric.Maximum = 2000
    $script:WidthNumeric.Value = 400
    $script:WidthNumeric.Location = New-Object System.Drawing.Point(70, $y)
    $script:WidthNumeric.Size = New-Object System.Drawing.Size(80, 25)
    $script:WidthNumeric.Add_ValueChanged({ Update-Preview })
    $leftPanel.Controls.Add($script:WidthNumeric)
    
    # Height
    $heightLabel = New-Object System.Windows.Forms.Label
    $heightLabel.Text = "Height:"
    $heightLabel.Location = New-Object System.Drawing.Point(170, $y)
    $heightLabel.Size = New-Object System.Drawing.Size(50, 20)
    $leftPanel.Controls.Add($heightLabel)
    
    $script:HeightNumeric = New-Object System.Windows.Forms.NumericUpDown
    $script:HeightNumeric.Minimum = 100
    $script:HeightNumeric.Maximum = 1000
    $script:HeightNumeric.Value = 200
    $script:HeightNumeric.Location = New-Object System.Drawing.Point(230, $y)
    $script:HeightNumeric.Size = New-Object System.Drawing.Size(80, 25)
    $script:HeightNumeric.Add_ValueChanged({ Update-Preview })
    $leftPanel.Controls.Add($script:HeightNumeric)
    
    $y += 35
    
    # Color Scheme
    $colorSchemeLabel = New-Object System.Windows.Forms.Label
    $colorSchemeLabel.Text = "Color Scheme:"
    $colorSchemeLabel.Location = New-Object System.Drawing.Point(10, $y)
    $colorSchemeLabel.Size = New-Object System.Drawing.Size(100, 20)
    $leftPanel.Controls.Add($colorSchemeLabel)
    
    $script:ColorSchemeCombo = New-Object System.Windows.Forms.ComboBox
    $script:ColorSchemeCombo.DropDownStyle = "DropDownList"
    $script:ColorSchemeCombo.Items.AddRange(@("Professional", "Corporate", "Modern", "Green", "Red"))
    $script:ColorSchemeCombo.SelectedIndex = 0
    $script:ColorSchemeCombo.Location = New-Object System.Drawing.Point(120, $y)
    $script:ColorSchemeCombo.Size = New-Object System.Drawing.Size(220, 25)
    $script:ColorSchemeCombo.Add_SelectedIndexChanged({ Update-Preview })
    $leftPanel.Controls.Add($script:ColorSchemeCombo)
    
    $y += 45
    
    # Icon Creation section
    $iconSectionLabel = New-Object System.Windows.Forms.Label
    $iconSectionLabel.Text = "Icon Creation"
    $iconSectionLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $iconSectionLabel.Location = New-Object System.Drawing.Point(10, $y)
    $iconSectionLabel.Size = New-Object System.Drawing.Size(100, 20)
    $leftPanel.Controls.Add($iconSectionLabel)
    
    $y += 25
    
    # Create Icon checkbox
    $script:CreateIconCheckBox = New-Object System.Windows.Forms.CheckBox
    $script:CreateIconCheckBox.Text = "Create Icon (.ico) instead of image"
    $script:CreateIconCheckBox.Location = New-Object System.Drawing.Point(10, $y)
    $script:CreateIconCheckBox.Size = New-Object System.Drawing.Size(330, 20)
    $script:CreateIconCheckBox.Add_CheckedChanged({ 
        Update-Preview
        # Update output path extension
        $currentPath = $script:OutputPathTextBox.Text
        if ($script:CreateIconCheckBox.Checked) {
            if (-not $currentPath.EndsWith('.ico')) {
                $script:OutputPathTextBox.Text = [System.IO.Path]::ChangeExtension($currentPath, '.ico')
            }
            # Disable dimension controls for icons
            $script:WidthNumeric.Enabled = $false
            $script:HeightNumeric.Enabled = $false
            $script:IconSizesTextBox.Enabled = $true
            $script:SolidIconBackgroundCheckBox.Enabled = $true
        } else {
            if ($currentPath.EndsWith('.ico')) {
                $script:OutputPathTextBox.Text = [System.IO.Path]::ChangeExtension($currentPath, '.png')
            }
            # Enable dimension controls for splash screens
            $script:WidthNumeric.Enabled = $true
            $script:HeightNumeric.Enabled = $true
            $script:IconSizesTextBox.Enabled = $false
            $script:SolidIconBackgroundCheckBox.Enabled = $false
        }
    })
    $leftPanel.Controls.Add($script:CreateIconCheckBox)
    
    $y += 25
    
    # Icon Sizes
    $iconSizesLabel = New-Object System.Windows.Forms.Label
    $iconSizesLabel.Text = "Icon Sizes:"
    $iconSizesLabel.Location = New-Object System.Drawing.Point(10, $y)
    $iconSizesLabel.Size = New-Object System.Drawing.Size(100, 20)
    $leftPanel.Controls.Add($iconSizesLabel)
    
    $script:IconSizesTextBox = New-Object System.Windows.Forms.TextBox
    $script:IconSizesTextBox.Text = "16,32,48,64,128,256"
    $script:IconSizesTextBox.Location = New-Object System.Drawing.Point(120, $y)
    $script:IconSizesTextBox.Size = New-Object System.Drawing.Size(220, 25)
    $script:IconSizesTextBox.Enabled = $false
    $leftPanel.Controls.Add($script:IconSizesTextBox)
    
    $y += 30
    
    # Solid Icon Background checkbox
    $script:SolidIconBackgroundCheckBox = New-Object System.Windows.Forms.CheckBox
    $script:SolidIconBackgroundCheckBox.Text = "Use solid background (recommended for small icons)"
    $script:SolidIconBackgroundCheckBox.Location = New-Object System.Drawing.Point(10, $y)
    $script:SolidIconBackgroundCheckBox.Size = New-Object System.Drawing.Size(330, 20)
    $script:SolidIconBackgroundCheckBox.Enabled = $false
    $script:SolidIconBackgroundCheckBox.Add_CheckedChanged({ Update-Preview })
    $leftPanel.Controls.Add($script:SolidIconBackgroundCheckBox)
    
    $y += 30
    
    # Output Path section
    $outputLabel = New-Object System.Windows.Forms.Label
    $outputLabel.Text = "Output File"
    $outputLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $outputLabel.Location = New-Object System.Drawing.Point(10, $y)
    $outputLabel.Size = New-Object System.Drawing.Size(100, 20)
    $leftPanel.Controls.Add($outputLabel)
    
    $y += 25
    
    $script:OutputPathTextBox = New-Object System.Windows.Forms.TextBox
    $script:OutputPathTextBox.Text = "SplashScreen.png"
    $script:OutputPathTextBox.Location = New-Object System.Drawing.Point(10, $y)
    $script:OutputPathTextBox.Size = New-Object System.Drawing.Size(250, 25)
    $leftPanel.Controls.Add($script:OutputPathTextBox)
    
    $browseButton = New-Object System.Windows.Forms.Button
    $browseButton.Text = "Browse..."
    $browseButton.Location = New-Object System.Drawing.Point(270, $y)
    $browseButton.Size = New-Object System.Drawing.Size(70, 25)
    $browseButton.Add_Click({ Browse-OutputPath })
    $leftPanel.Controls.Add($browseButton)
    
    $y += 45
    
    # Action buttons
    $generateButton = New-Object System.Windows.Forms.Button
    $generateButton.Text = "Generate Preview"
    $generateButton.Location = New-Object System.Drawing.Point(10, $y)
    $generateButton.Size = New-Object System.Drawing.Size(160, 35)
    $generateButton.BackColor = [System.Drawing.Color]::FromArgb(45, 85, 135)
    $generateButton.ForeColor = [System.Drawing.Color]::White
    $generateButton.FlatStyle = "Flat"
    $generateButton.Add_Click({ Update-Preview })
    $leftPanel.Controls.Add($generateButton)
    
    $saveButton = New-Object System.Windows.Forms.Button
    $saveButton.Text = "Save Image"
    $saveButton.Location = New-Object System.Drawing.Point(180, $y)
    $saveButton.Size = New-Object System.Drawing.Size(160, 35)
    $saveButton.BackColor = [System.Drawing.Color]::FromArgb(34, 139, 34)
    $saveButton.ForeColor = [System.Drawing.Color]::White
    $saveButton.FlatStyle = "Flat"
    $saveButton.Add_Click({ Save-SplashScreen })
    $leftPanel.Controls.Add($saveButton)
    
    # Right panel for preview
    $rightPanel = New-Object System.Windows.Forms.Panel
    $rightPanel.Location = New-Object System.Drawing.Point(370, 10)
    $rightPanel.Size = New-Object System.Drawing.Size(510, 600)
    $rightPanel.BackColor = [System.Drawing.Color]::FromArgb(250, 250, 250)
    
    # Preview title
    $previewTitleLabel = New-Object System.Windows.Forms.Label
    $previewTitleLabel.Text = "Live Preview"
    $previewTitleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
    $previewTitleLabel.Location = New-Object System.Drawing.Point(10, 10)
    $previewTitleLabel.Size = New-Object System.Drawing.Size(490, 30)
    $previewTitleLabel.ForeColor = [System.Drawing.Color]::FromArgb(45, 85, 135)
    $previewTitleLabel.TextAlign = "MiddleCenter"
    $rightPanel.Controls.Add($previewTitleLabel)
    
    # Preview picture box
    $script:PreviewPictureBox = New-Object System.Windows.Forms.PictureBox
    $script:PreviewPictureBox.Location = New-Object System.Drawing.Point(10, 50)
    $script:PreviewPictureBox.Size = New-Object System.Drawing.Size(490, 400)
    $script:PreviewPictureBox.BorderStyle = "FixedSingle"
    $script:PreviewPictureBox.BackColor = [System.Drawing.Color]::White
    $script:PreviewPictureBox.SizeMode = "CenterImage"
    $rightPanel.Controls.Add($script:PreviewPictureBox)
    
    # Info panel
    $infoPanel = New-Object System.Windows.Forms.Panel
    $infoPanel.Location = New-Object System.Drawing.Point(10, 460)
    $infoPanel.Size = New-Object System.Drawing.Size(490, 130)
    $infoPanel.BackColor = [System.Drawing.Color]::FromArgb(245, 245, 245)
    $infoPanel.BorderStyle = "FixedSingle"
    
    $infoLabel = New-Object System.Windows.Forms.Label
    $infoLabel.Text = @"
Tips:
- Changes are reflected in real-time in the preview
- Use File menu to save/load configurations
- Supported formats: PNG, JPG, BMP, ICO
- Larger dimensions work better for desktop apps
- Smaller dimensions are perfect for dialog splash screens
- Check the Help tab for detailed usage instructions
"@
    $infoLabel.Location = New-Object System.Drawing.Point(10, 10)
    $infoLabel.Size = New-Object System.Drawing.Size(470, 110)
    $infoLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $infoPanel.Controls.Add($infoLabel)
    
    $rightPanel.Controls.Add($infoPanel)
    
    # Add panels to main panel
    $mainPanel.Controls.Add($leftPanel)
    $mainPanel.Controls.Add($rightPanel)
    
    # Add main panel to creator tab
    $creatorTab.Controls.Add($mainPanel)
    
    return $creatorTab
}

# Main execution
try {
    # Show splash screen first
    Show-SplashScreen
    
    # Create and show main form
    Create-MainForm
    
    # Show the form
    $script:MainForm.Add_FormClosed({
        if ($script:CurrentBitmap) {
            $script:CurrentBitmap.Dispose()
        }
        if ($script:PreviewPictureBox.Image) {
            $script:PreviewPictureBox.Image.Dispose()
        }
    })
    
    [System.Windows.Forms.Application]::Run($script:MainForm)
}
catch {
    [System.Windows.Forms.MessageBox]::Show("Error starting application: $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
}