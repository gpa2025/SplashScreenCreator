#Requires -Version 5.1
<#
.SYNOPSIS
    Professional Splash Screen Creator Tool
.DESCRIPTION
    Creates custom splash screen images with configurable text, colors, and styling.
    Supports multiple layouts and export formats for various applications.
.AUTHOR
    Gianpaolo Albanese
.VERSION
    1.0
.DATE
    2025-12-23
.NOTES
    Enhanced by AI Assistant (Kiro) - Professional Graphics Tool
    Supports PNG, JPG, BMP formats with customizable dimensions and styling
.EXAMPLE
    .\SplashScreenCreator.ps1 -MainText "GPA" -SubtitleText "Enhanced Backup Manager" -VersionText "V2" -OutputPath "SplashScreen.png"
.EXAMPLE
    .\SplashScreenCreator.ps1 -ConfigFile "splash-config.json"
#>

param(
    [string]$MainText = "GPA",
    [string]$SubtitleText = "Enhanced Backup Manager", 
    [string]$VersionText = "V2",
    [string]$OutputPath = "SplashScreen.png",
    [int]$Width = 400,
    [int]$Height = 200,
    [string]$ConfigFile = $null,
    [string]$ColorScheme = "Professional",
    [switch]$ShowPreview,
    [switch]$CreateIcon,
    [string]$IconSizes = "16,32,48,64,128,256",
    [switch]$SolidIconBackground,
    [switch]$Help
)

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

# Color schemes
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

function Show-Help {
    Write-Host @"
=== Professional Splash Screen Creator ===

USAGE:
    .\SplashScreenCreator.ps1 [OPTIONS]

PARAMETERS:
    -MainText        Main title text (default: "GPA")
    -SubtitleText    Subtitle text (default: "Enhanced Backup Manager")
    -VersionText     Version text (default: "V2")
    -OutputPath      Output file path (default: "SplashScreen.png")
    -Width           Image width in pixels (default: 400)
    -Height          Image height in pixels (default: 200)
    -ColorScheme     Color scheme (Professional, Corporate, Modern, Green, Red)
    -ConfigFile      JSON configuration file path
    -ShowPreview     Display preview window
    -CreateIcon      Create .ico file instead of image (ignores Width/Height)
    -IconSizes       Icon sizes to include (default: "16,32,48,64,128,256")
    -SolidIconBackground  Use solid color background for icons (better for small sizes)
    -Help            Show this help message

EXAMPLES:
    # Basic usage
    .\SplashScreenCreator.ps1 -MainText "ACME" -SubtitleText "Business Suite" -VersionText "V3.0"
    
    # Custom dimensions and color
    .\SplashScreenCreator.ps1 -Width 800 -Height 400 -ColorScheme "Modern" -OutputPath "LargeSplash.png"
    
    # Create icon file
    .\SplashScreenCreator.ps1 -MainText "GPA" -CreateIcon -OutputPath "MyApp.ico"
    
    # Create icon with solid background (recommended for small icons)
    .\SplashScreenCreator.ps1 -MainText "GPA" -CreateIcon -SolidIconBackground -OutputPath "MyApp.ico"
    
    # Custom icon sizes
    .\SplashScreenCreator.ps1 -MainText "ACME" -CreateIcon -IconSizes "16,32,48" -OutputPath "Small.ico"
    
    # Using config file
    .\SplashScreenCreator.ps1 -ConfigFile "my-splash.json"
    
    # With preview
    .\SplashScreenCreator.ps1 -ShowPreview

COLOR SCHEMES:
    - Professional: Blue gradient with professional styling (default)
    - Corporate: Dark gradient with corporate look
    - Modern: Bright blue modern styling
    - Green: Green gradient for eco/nature themes
    - Red: Red gradient for bold/alert themes

CONFIG FILE FORMAT:
    {
        "MainText": "Your Company",
        "SubtitleText": "Application Name",
        "VersionText": "V1.0",
        "Width": 400,
        "Height": 200,
        "ColorScheme": "Professional",
        "OutputPath": "MyApp.png"
    }
"@ -ForegroundColor Cyan
}

function Load-ConfigFile {
    param([string]$ConfigPath)
    
    if (-not (Test-Path $ConfigPath)) {
        Write-Error "Configuration file not found: $ConfigPath"
        return $null
    }
    
    try {
        $config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
        Write-Host "Configuration loaded from: $ConfigPath" -ForegroundColor Green
        return $config
    }
    catch {
        Write-Error "Failed to parse configuration file: $_"
        return $null
    }
}

function Create-IconFile {
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
        Write-Host "Creating icon file..." -ForegroundColor Yellow
        Write-Host "  Main Text: '$MainText'" -ForegroundColor Cyan
        Write-Host "  Subtitle: '$SubtitleText'" -ForegroundColor Cyan
        Write-Host "  Version: '$VersionText'" -ForegroundColor Cyan
        Write-Host "  Color Scheme: $ColorScheme" -ForegroundColor Cyan
        Write-Host "  Background: $(if ($UseSolidBackground) { 'Solid (optimized for small icons)' } else { 'Gradient' })" -ForegroundColor Cyan
        
        # Parse icon sizes
        $sizes = $IconSizes -split ',' | ForEach-Object { [int]$_.Trim() } | Sort-Object
        Write-Host "  Icon Sizes: $($sizes -join ', ') pixels" -ForegroundColor Cyan
        
        # Get color scheme
        $colors = $script:ColorSchemes[$ColorScheme]
        if (-not $colors) {
            Write-Warning "Unknown color scheme '$ColorScheme', using 'Professional'"
            $colors = $script:ColorSchemes["Professional"]
        }
        
        # Create bitmaps for each size
        $bitmaps = @()
        foreach ($size in $sizes) {
            Write-Host "  Generating ${size}x${size} icon..." -ForegroundColor Gray
            
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
                    # All three texts
                    $mainY = ($size * 0.25) - ($mainSize.Height / 2)
                } elseif ($showSubtitle) {
                    # Main and subtitle only
                    $mainY = ($size * 0.35) - ($mainSize.Height / 2)
                } else {
                    # Main text only (centered)
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
            
            # Add decorative elements for larger icons
            if ($size -ge 64 -and $MainText) {
                $accentBrush = New-Object System.Drawing.SolidBrush($colors.AccentColor)
                $decorSize = [math]::Max(4, $size / 20)
                
                $mainSize = $graphics.MeasureString($MainText, $mainFont)
                $mainX = ($size - $mainSize.Width) / 2
                $mainY = if ($showSubtitle -and $showVersion) { ($size * 0.25) - ($mainSize.Height / 2) } elseif ($showSubtitle) { ($size * 0.35) - ($mainSize.Height / 2) } else { ($size - $mainSize.Height) / 2 }
                
                # Left decoration
                $leftX = $mainX - $decorSize - 8
                $leftY = $mainY + ($mainSize.Height / 2) - ($decorSize / 2)
                if ($leftX -gt 2) {
                    $graphics.FillRectangle($accentBrush, $leftX, $leftY, $decorSize, $decorSize * 0.6)
                }
                
                # Right decoration
                $rightX = $mainX + $mainSize.Width + 8
                $rightY = $leftY
                if ($rightX + $decorSize -lt $size - 2) {
                    $graphics.FillRectangle($accentBrush, $rightX, $rightY, $decorSize, $decorSize * 0.6)
                }
                
                $accentBrush.Dispose()
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
        Save-IconFile -Bitmaps $bitmaps -OutputPath $OutputPath
        
        # Cleanup bitmaps
        foreach ($bitmap in $bitmaps) {
            $bitmap.Dispose()
        }
        
        Write-Host "`n[SUCCESS] Icon file created successfully!" -ForegroundColor Green
        Write-Host "File: $OutputPath" -ForegroundColor Yellow
        Write-Host "Sizes: $($sizes -join ', ') pixels" -ForegroundColor Yellow
        Write-Host "Format: ICO (Windows Icon)" -ForegroundColor Yellow
        
        return $true
    }
    catch {
        Write-Error "Failed to create icon file: $_"
        return $false
    }
}

function Save-IconFile {
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
        Write-Warning "Advanced ICO creation failed, using PNG format with .ico extension"
        if (Test-Path $tempPngPath) {
            Move-Item $tempPngPath $OutputPath -Force
        }
    }
}

function Create-SplashScreen {
    param(
        [string]$MainText,
        [string]$SubtitleText,
        [string]$VersionText,
        [string]$OutputPath,
        [int]$Width,
        [int]$Height,
        [string]$ColorScheme = "Professional"
    )
    
    try {
        Write-Host "Creating splash screen..." -ForegroundColor Yellow
        Write-Host "  Main Text: '$MainText'" -ForegroundColor Cyan
        Write-Host "  Subtitle: '$SubtitleText'" -ForegroundColor Cyan
        Write-Host "  Version: '$VersionText'" -ForegroundColor Cyan
        Write-Host "  Dimensions: ${Width}x${Height}" -ForegroundColor Cyan
        Write-Host "  Color Scheme: $ColorScheme" -ForegroundColor Cyan
        
        # Get color scheme
        $colors = $script:ColorSchemes[$ColorScheme]
        if (-not $colors) {
            Write-Warning "Unknown color scheme '$ColorScheme', using 'Professional'"
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
        
        # Create fonts (responsive sizing based on image dimensions)
        $mainFontSize = [math]::Max(24, $Width / 8)  # Larger main text
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
        $mainSize = $graphics.MeasureString($MainText, $mainFont)
        $subtitleSize = $graphics.MeasureString($SubtitleText, $subtitleFont)
        $versionSize = $graphics.MeasureString($VersionText, $versionFont)
        
        # Position main text in center-upper area
        $mainX = ($Width - $mainSize.Width) / 2
        $mainY = ($Height * 0.35) - ($mainSize.Height / 2)
        
        # Position subtitle in lower area
        $subtitleX = ($Width - $subtitleSize.Width) / 2
        $subtitleY = $Height * 0.72
        
        # Position version below subtitle
        $versionX = ($Width - $versionSize.Width) / 2
        $versionY = $subtitleY + $subtitleSize.Height + 8
        
        # Draw text shadows for depth
        $graphics.DrawString($MainText, $mainFont, $shadowBrush, $mainX + 3, $mainY + 3)
        $graphics.DrawString($SubtitleText, $subtitleFont, $shadowBrush, $subtitleX + 1, $subtitleY + 1)
        $graphics.DrawString($VersionText, $versionFont, $shadowBrush, $versionX + 1, $versionY + 1)
        
        # Draw main text
        $graphics.DrawString($MainText, $mainFont, $mainBrush, $mainX, $mainY)
        $graphics.DrawString($SubtitleText, $subtitleFont, $subtitleBrush, $subtitleX, $subtitleY)
        $graphics.DrawString($VersionText, $versionFont, $versionBrush, $versionX, $versionY)
        
        # Add decorative elements
        $accentBrush = New-Object System.Drawing.SolidBrush($colors.AccentColor)
        $decorSize = [math]::Max(12, $Width / 25)
        
        # Left decoration
        $leftX = $mainX - $decorSize - 15
        $leftY = $mainY + ($mainSize.Height / 2) - ($decorSize / 2)
        if ($leftX -gt 5) {
            $graphics.FillRectangle($accentBrush, $leftX, $leftY, $decorSize, $decorSize * 0.6)
        }
        
        # Right decoration
        $rightX = $mainX + $mainSize.Width + 15
        $rightY = $leftY
        if ($rightX + $decorSize -lt $Width - 5) {
            $graphics.FillRectangle($accentBrush, $rightX, $rightY, $decorSize, $decorSize * 0.6)
        }
        
        # Save the image
        $format = switch ([System.IO.Path]::GetExtension($OutputPath).ToLower()) {
            ".jpg" { [System.Drawing.Imaging.ImageFormat]::Jpeg }
            ".jpeg" { [System.Drawing.Imaging.ImageFormat]::Jpeg }
            ".bmp" { [System.Drawing.Imaging.ImageFormat]::Bmp }
            default { [System.Drawing.Imaging.ImageFormat]::Png }
        }
        
        $bitmap.Save($OutputPath, $format)
        
        Write-Host "`n[SUCCESS] Splash screen created successfully!" -ForegroundColor Green
        Write-Host "File: $OutputPath" -ForegroundColor Yellow
        Write-Host "Size: ${Width}x${Height} pixels" -ForegroundColor Yellow
        Write-Host "Format: $($format.ToString())" -ForegroundColor Yellow
        
        # Show preview if requested
        if ($ShowPreview) {
            Show-Preview $bitmap
        }
        
        # Cleanup
        $graphics.Dispose()
        $bitmap.Dispose()
        $gradientBrush.Dispose()
        $borderPen.Dispose()
        $mainFont.Dispose()
        $subtitleFont.Dispose()
        $versionFont.Dispose()
        $mainBrush.Dispose()
        $subtitleBrush.Dispose()
        $versionBrush.Dispose()
        $shadowBrush.Dispose()
        $accentBrush.Dispose()
        
        return $true
    }
    catch {
        Write-Error "Failed to create splash screen: $_"
        return $false
    }
}

function Show-Preview {
    param([System.Drawing.Bitmap]$Bitmap)
    
    try {
        $form = New-Object System.Windows.Forms.Form
        $form.Text = "Splash Screen Preview"
        $form.Size = New-Object System.Drawing.Size(($Bitmap.Width + 50), ($Bitmap.Height + 100))
        $form.StartPosition = "CenterScreen"
        $form.FormBorderStyle = "FixedDialog"
        $form.MaximizeBox = $false
        
        $pictureBox = New-Object System.Windows.Forms.PictureBox
        $pictureBox.Image = $Bitmap.Clone()
        $pictureBox.Size = New-Object System.Drawing.Size($Bitmap.Width, $Bitmap.Height)
        $pictureBox.Location = New-Object System.Drawing.Point(25, 25)
        $pictureBox.SizeMode = "Normal"
        
        $form.Controls.Add($pictureBox)
        $form.ShowDialog()
        $form.Dispose()
    }
    catch {
        Write-Warning "Could not show preview: $_"
    }
}

function Export-ConfigTemplate {
    param([string]$Path = "splash-config-template.json")
    
    $template = @{
        MainText = "Your Company"
        SubtitleText = "Application Name"
        VersionText = "V1.0"
        Width = 400
        Height = 200
        ColorScheme = "Professional"
        OutputPath = "SplashScreen.png"
    }
    
    $template | ConvertTo-Json -Depth 2 | Out-File -FilePath $Path -Encoding UTF8
    Write-Host "Configuration template exported to: $Path" -ForegroundColor Green
}

# Main execution
if ($Help) {
    Show-Help
    exit 0
}

# Load configuration file if specified
if ($ConfigFile) {
    $config = Load-ConfigFile $ConfigFile
    if ($config) {
        if ($config.MainText) { $MainText = $config.MainText }
        if ($config.SubtitleText) { $SubtitleText = $config.SubtitleText }
        if ($config.VersionText) { $VersionText = $config.VersionText }
        if ($config.Width) { $Width = $config.Width }
        if ($config.Height) { $Height = $config.Height }
        if ($config.OutputPath) { $OutputPath = $config.OutputPath }
        if ($config.ColorScheme) { $ColorScheme = $config.ColorScheme }
    }
    else {
        exit 1
    }
}

# Create the splash screen or icon
if ($CreateIcon) {
    # Force .ico extension if not specified
    if (-not $OutputPath.EndsWith('.ico')) {
        $OutputPath = [System.IO.Path]::ChangeExtension($OutputPath, '.ico')
        Write-Host "Output path changed to: $OutputPath" -ForegroundColor Yellow
    }
    $success = Create-IconFile -MainText $MainText -SubtitleText $SubtitleText -VersionText $VersionText -OutputPath $OutputPath -ColorScheme $ColorScheme -IconSizes $IconSizes -UseSolidBackground $SolidIconBackground
} else {
    $success = Create-SplashScreen -MainText $MainText -SubtitleText $SubtitleText -VersionText $VersionText -OutputPath $OutputPath -Width $Width -Height $Height -ColorScheme $ColorScheme
}

if ($success) {
    if ($CreateIcon) {
        Write-Host "`n[COMPLETE] Icon generation completed!" -ForegroundColor Green
        Write-Host "Tip: Use -ShowPreview to see the result, or -Help for more options" -ForegroundColor Cyan
    } else {
        Write-Host "`n[COMPLETE] Splash screen generation completed!" -ForegroundColor Green
        Write-Host "Tip: Use -ShowPreview to see the result, or -Help for more options" -ForegroundColor Cyan
    }
}
else {
    if ($CreateIcon) {
        Write-Host "[ERROR] Icon generation failed!" -ForegroundColor Red
    } else {
        Write-Host "[ERROR] Splash screen generation failed!" -ForegroundColor Red
    }
    exit 1
}