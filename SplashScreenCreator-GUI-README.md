# Professional Splash Screen Creator - GUI Interface

A user-friendly Windows Forms GUI for creating professional splash screen images with real-time preview and easy configuration.

## Features

### 🎨 Visual Interface
- **Real-time Preview**: See changes instantly as you type
- **Intuitive Layout**: Left panel for controls, right panel for preview
- **Professional Design**: Clean, modern interface with proper spacing

### 🛠️ Easy Configuration
- **Text Fields**: Main text, subtitle, and version with live preview
- **Dimension Controls**: Width and height with numeric spinners (200-2000px width, 100-1000px height)
- **Color Schemes**: Dropdown with 5 professional themes
- **Output Path**: Text field with browse button for easy file selection

### 💾 File Management
- **Save/Load Configurations**: JSON-based configuration files for reuse
- **Multiple Formats**: PNG, JPG, BMP support with automatic format detection
- **Browse Dialog**: Easy file selection with proper filters

### 🎯 Real-time Features
- **Live Preview**: Updates automatically as you change settings
- **Responsive Scaling**: Preview scales to fit while maintaining aspect ratio
- **High Quality**: Anti-aliased rendering with professional effects

## Quick Start

### Launch the GUI
1. **Double-click**: `Launch-SplashScreenCreator-GUI.bat`
2. **Or run directly**: `SplashScreenCreatorGUI.ps1` in PowerShell

### Create Your First Splash Screen
1. **Enter Text**: Fill in Main Text, Subtitle, and Version fields
2. **Choose Dimensions**: Set width and height (default: 400x200)
3. **Select Color Scheme**: Choose from Professional, Corporate, Modern, Green, or Red
4. **Preview**: Watch the live preview update automatically
5. **Save**: Click "Save Image" and choose your output location

## Interface Guide

### Left Panel - Controls

#### Text Configuration
- **Main Text**: Large, prominent text (e.g., "GPA", "ACME")
- **Subtitle Text**: Secondary text (e.g., "Enhanced Backup Manager")
- **Version Text**: Version information (e.g., "V2", "V1.0")

#### Dimensions
- **Width**: 200-2000 pixels (default: 400)
- **Height**: 100-1000 pixels (default: 200)
- Font sizes automatically scale based on dimensions

#### Color Schemes
- **Professional**: Blue gradient, perfect for business apps
- **Corporate**: Dark gradient, sophisticated look
- **Modern**: Bright blue, contemporary design
- **Green**: Eco-friendly, nature themes
- **Red**: Bold, attention-grabbing

#### Output Configuration
- **Output Path**: Where to save the image
- **Browse Button**: Opens file dialog for easy selection
- **Format Detection**: Automatically detects PNG/JPG/BMP from extension

#### Action Buttons
- **Generate Preview**: Refresh the preview (automatic on changes)
- **Save Image**: Export the current design to file

### Right Panel - Preview

#### Live Preview
- **Real-time Updates**: Changes reflect immediately
- **Scaled Display**: Maintains aspect ratio in preview window
- **High Quality**: Shows exactly how the final image will look

#### Tips Section
- Helpful hints for optimal usage
- Format recommendations
- Dimension guidelines

### Menu Bar

#### File Menu
- **Load Configuration**: Import saved settings from JSON file
- **Save Configuration**: Export current settings to JSON file
- **Exit**: Close the application

## Configuration Files

### Save Settings
Use the File menu to save your current configuration as a JSON file:

```json
{
    "MainText": "GPA",
    "SubtitleText": "Enhanced Backup Manager",
    "VersionText": "V2",
    "Width": 400,
    "Height": 200,
    "ColorScheme": "Professional",
    "OutputPath": "SplashScreen.png"
}
```

### Load Settings
Load previously saved configurations to quickly recreate designs or use as templates for new projects.

## Usage Examples

### Company Branding
1. **Main Text**: "ACME Corp"
2. **Subtitle**: "Business Management Suite"
3. **Version**: "V3.0"
4. **Scheme**: Corporate
5. **Dimensions**: 600x300

### Application Splash
1. **Main Text**: "MyApp"
2. **Subtitle**: "Professional Tools"
3. **Version**: "V1.5"
4. **Scheme**: Modern
5. **Dimensions**: 400x200

### Product Launch
1. **Main Text**: "EcoTrack"
2. **Subtitle**: "Environmental Monitor"
3. **Version**: "V2.1"
4. **Scheme**: Green
5. **Dimensions**: 800x400

## Tips for Best Results

### Text Guidelines
- **Keep main text short**: 1-4 characters work best (e.g., "GPA", "ACME")
- **Descriptive subtitles**: Explain what the application does
- **Clear versioning**: Use standard formats like "V1.0", "Version 2.3"

### Dimension Recommendations
- **Dialog splash screens**: 400x200 to 500x250
- **Desktop applications**: 600x300 to 800x400
- **Large displays**: 1000x500 or larger
- **Mobile/compact**: 300x150 to 400x200

### Color Scheme Selection
- **Professional**: Business applications, corporate software
- **Corporate**: Enterprise tools, serious applications
- **Modern**: Tech apps, contemporary software
- **Green**: Environmental, eco-friendly, health apps
- **Red**: Gaming, alerts, bold applications

### File Format Choice
- **PNG**: Best quality, supports transparency (recommended)
- **JPG**: Smaller file size, good for web use
- **BMP**: Uncompressed, largest file size

## Troubleshooting

### GUI Won't Start
- **Check PowerShell**: Ensure PowerShell is available
- **Execution Policy**: Run `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
- **.NET Framework**: Ensure Windows Forms is available

### Preview Not Updating
- **Click Generate**: Use the "Generate Preview" button
- **Check Text Fields**: Ensure fields aren't empty
- **Restart Application**: Close and reopen if issues persist

### Save Errors
- **Check Path**: Ensure output directory exists
- **File Permissions**: Verify write access to target folder
- **File Extension**: Use .png, .jpg, or .bmp extensions

### Memory Issues
- **Large Dimensions**: Reduce size if system runs low on memory
- **Close Preview**: Application automatically cleans up resources

## System Requirements

- **Operating System**: Windows 7 or later
- **PowerShell**: Version 5.1 or later
- **.NET Framework**: 4.5 or later (for Windows Forms)
- **Memory**: 100MB+ available RAM
- **Disk Space**: Minimal (output files vary by dimensions)

## Integration

### With Command-Line Tool
The GUI complements the command-line `SplashScreenCreator.ps1`:
- **GUI**: Interactive design and preview
- **Command-line**: Batch processing and automation
- **Shared**: Same color schemes and output quality

### With Other Applications
- **Export**: Save images for use in any application
- **Configurations**: Reuse settings across projects
- **Formats**: Compatible with most image viewers and editors

## Author

Created by Gianpaolo Albanese  
Enhanced with AI Assistant (Kiro)  
Date: December 23, 2025  
Version 1.0 - GUI Interface

## Support

For issues or questions:
1. Check this README for common solutions
2. Verify system requirements are met
3. Try the command-line version for comparison
4. Restart the application if problems persist