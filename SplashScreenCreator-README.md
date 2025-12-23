# Professional Splash Screen Creator

A comprehensive PowerShell tool for creating professional splash screen images and Windows icons with customizable text, colors, and styling.

## Features

- **Multiple Color Schemes**: Professional, Corporate, Modern, Green, Red
- **Dual Output Modes**: Create splash screens (PNG/JPG/BMP) or Windows icons (.ico)
- **Icon Multi-Resolution**: Generate icons with multiple sizes in a single .ico file
- **Responsive Design**: Automatically scales fonts based on image dimensions
- **High Quality Output**: Anti-aliased text and graphics
- **Configuration Files**: JSON-based configuration for easy reuse
- **Preview Mode**: View splash screen before saving
- **Professional Effects**: Gradient backgrounds, text shadows, decorative elements

## Quick Start

### Basic Splash Screen
```powershell
.\SplashScreenCreator.ps1 -MainText "GPA" -SubtitleText "Enhanced Backup Manager" -VersionText "V2"
```

### Create Windows Icon
```powershell
.\SplashScreenCreator.ps1 -MainText "GPA" -CreateIcon -OutputPath "MyApp.ico"
```

### Custom Icon Sizes
```powershell
.\SplashScreenCreator.ps1 -MainText "ACME" -CreateIcon -IconSizes "16,32,48,64" -OutputPath "Small.ico"
```

### Custom Dimensions and Colors
```powershell
.\SplashScreenCreator.ps1 -Width 800 -Height 400 -ColorScheme "Modern" -OutputPath "MyApp.png"
```

### With Preview
```powershell
.\SplashScreenCreator.ps1 -ShowPreview
```

## Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `-MainText` | Main title text | "GPA" |
| `-SubtitleText` | Subtitle text | "Enhanced Backup Manager" |
| `-VersionText` | Version text | "V2" |
| `-OutputPath` | Output file path | "SplashScreen.png" |
| `-Width` | Image width in pixels (splash screens only) | 400 |
| `-Height` | Image height in pixels (splash screens only) | 200 |
| `-ColorScheme` | Color scheme name | "Professional" |
| `-ConfigFile` | JSON configuration file | - |
| `-ShowPreview` | Display preview window | - |
| `-CreateIcon` | Create .ico file instead of image | - |
| `-IconSizes` | Icon sizes for .ico files | "16,32,48,64,128,256" |
| `-Help` | Show help message | - |

## Output Modes

### Splash Screen Mode (Default)
Creates rectangular images perfect for application splash screens:
- **Formats**: PNG, JPG, BMP
- **Dimensions**: Customizable width and height
- **Use Cases**: Application startup screens, loading screens, banners

### Icon Mode (-CreateIcon)
Creates Windows icon files with multiple resolutions:
- **Format**: ICO (Windows Icon)
- **Sizes**: Multiple resolutions in one file (16x16 to 256x256)
- **Use Cases**: Application icons, file type icons, system tray icons

## Color Schemes

### Professional (Default)
- Blue gradient background
- White main text
- Light blue accents
- Perfect for business applications

### Corporate
- Dark gradient background
- White text with gray accents
- Professional corporate look

### Modern
- Bright blue gradient
- Clean, modern styling
- Great for tech applications

### Green
- Green gradient background
- Perfect for eco/nature themes

### Red
- Red gradient background
- Bold, attention-grabbing design

## Configuration Files

Create a JSON file to store your splash screen settings:

```json
{
    "MainText": "ACME Corp",
    "SubtitleText": "Business Management Suite",
    "VersionText": "V3.0",
    "Width": 600,
    "Height": 300,
    "ColorScheme": "Corporate",
    "OutputPath": "ACME-Splash.png"
}
```

Then use it:
```powershell
.\SplashScreenCreator.ps1 -ConfigFile "my-config.json"
```

## Examples

### Create Company Splash Screen
```powershell
.\SplashScreenCreator.ps1 -MainText "ACME" -SubtitleText "Business Suite" -VersionText "V3.0" -ColorScheme "Corporate"
```

### Large Format Splash Screen
```powershell
.\SplashScreenCreator.ps1 -Width 1024 -Height 512 -MainText "MyApp" -ColorScheme "Modern" -ShowPreview
```

### Application Icon (Standard Sizes)
```powershell
.\SplashScreenCreator.ps1 -MainText "GPA" -CreateIcon -OutputPath "MyApp.ico"
```

### Custom Icon Sizes
```powershell
.\SplashScreenCreator.ps1 -MainText "ACME" -CreateIcon -IconSizes "16,32,48,128" -OutputPath "CustomIcon.ico"
```

### Eco-Themed Application
```powershell
.\SplashScreenCreator.ps1 -MainText "EcoTrack" -SubtitleText "Environmental Monitor" -VersionText "V1.5" -ColorScheme "Green"
```

### System Tray Icon
```powershell
.\SplashScreenCreator.ps1 -MainText "ST" -CreateIcon -IconSizes "16,24,32" -OutputPath "SystemTray.ico"
```

## Output Formats

### Splash Screen Formats
The tool automatically detects the output format based on file extension:
- `.png` - PNG format (default, best quality, supports transparency)
- `.jpg` or `.jpeg` - JPEG format (smaller file size, good for web)
- `.bmp` - Bitmap format (uncompressed, largest file size)

### Icon Format
- `.ico` - Windows Icon format (contains multiple resolutions)

## Icon Sizes

### Standard Icon Sizes
- **16x16**: Small icons, system menus
- **32x32**: Standard desktop icons
- **48x48**: Large desktop icons
- **64x64**: Extra large desktop icons
- **128x128**: High-resolution displays
- **256x256**: Very high-resolution displays

### Common Size Combinations
- **System Tray**: "16,24,32"
- **Desktop Application**: "16,32,48,64,128,256"
- **File Type Icons**: "16,32,48"
- **Web Favicons**: "16,32,48,64"

## Installation

1. Copy `SplashScreenCreator.ps1` to your desired location
2. Ensure PowerShell execution policy allows script execution:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
3. Run the script with your desired parameters

## Requirements

- PowerShell 5.1 or later
- Windows with .NET Framework
- System.Drawing and System.Windows.Forms assemblies

## Tips

- Use `-ShowPreview` to see your splash screen before finalizing
- Start with default settings and adjust as needed
- Use configuration files for consistent branding across projects
- Larger dimensions (800x400+) work well for desktop applications
- Smaller dimensions (400x200) are perfect for dialog splash screens

## Troubleshooting

**Script won't run**: Check PowerShell execution policy
**Preview doesn't show**: Ensure Windows Forms is available
**Colors look different**: Monitor color calibration may affect appearance
**Text is cut off**: Increase image dimensions or reduce text length

## Author

Created by Gianpaolo Albanese  
Enhanced with AI Assistant (Kiro)  
Date: December 23, 2025  
Version 1.0 - Command Line Tool