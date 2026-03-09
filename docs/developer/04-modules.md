# Modules

## Table of Contents

- [VNSPDFModule](#vnspdfmodule)
  - [Global Constants](#global-constants)
    - [Page Format Dimensions](#page-format-dimensions)
    - [Unit Conversion Factors](#unit-conversion-factors)
  - [Utility Methods](#utility-methods)
    - [GetPageFormatDimensions](#getpageformatdimensions)
    - [ConvertToPoints](#converttopoints)
    - [ConvertFromPoints](#convertfrompoints)
- [Graphics State Classes](#graphics-state-classes)
  - [VNSPDFBlendMode](#vnspdfblendmode)
    - [Properties](#properties)
    - [Usage](#usage)
- [Media Classes](#media-classes)
  - [VNSPDFImage](#vnspdfimage)
    - [Constructor](#constructor)
    - [Methods](#methods)

---

## VNSPDFModule

**Location**: `PDF_Library/VNSPDFModule.xojo_code`

Global module containing constants, enumerations, and utility functions.

### Global Constants

#### Page Format Dimensions

```xojo
Const gkA3Width As Double = 297    // mm
Const gkA3Height As Double = 420   // mm
Const gkA4Width As Double = 210    // mm
Const gkA4Height As Double = 297   // mm
Const gkA5Width As Double = 148    // mm
Const gkA5Height As Double = 210   // mm
Const gkLetterWidth As Double = 8.5    // inches
Const gkLetterHeight As Double = 11    // inches
Const gkLegalWidth As Double = 8.5     // inches
Const gkLegalHeight As Double = 14     // inches
```

#### Unit Conversion Factors

```xojo
Const gkPointsPerInch As Double = 72.0
Const gkMillimetersPerInch As Double = 25.4
Const gkCentimetersPerInch As Double = 2.54
```

### Utility Methods

#### GetPageFormatDimensions
```xojo
Function GetPageFormatDimensions(format As ePageFormat) As Pair
```

**Parameters**:
- `format` - Page format enum value

**Returns**: Pair with X (width) and Y (height) in the format's native units

**Description**: Returns the dimensions for standard page formats.

**Example**:
```xojo
Dim dimensions As Pair = VNSPDFModule.GetPageFormatDimensions(VNSPDFModule.ePageFormat.A4)
Dim width As Double = dimensions.Left   // 210 mm
Dim height As Double = dimensions.Right  // 297 mm
```

#### ConvertToPoints
```xojo
Function ConvertToPoints(value As Double, unit As ePageUnit) As Double
```

**Parameters**:
- `value` - Value to convert
- `unit` - Source unit

**Returns**: Value converted to points (1/72 inch)

**Description**: Converts from any supported unit to PDF points.

**Example**:
```xojo
Dim mmValue As Double = 210  // A4 width in mm
Dim pointsValue As Double = VNSPDFModule.ConvertToPoints(mmValue, VNSPDFModule.ePageUnit.Millimeters)
// Result: ~595.28 points
```

#### ConvertFromPoints
```xojo
Function ConvertFromPoints(points As Double, unit As ePageUnit) As Double
```

**Parameters**:
- `points` - Value in points
- `unit` - Target unit

**Returns**: Value converted to specified unit

**Description**: Converts from PDF points to any supported unit.

**Example**:
```xojo
Dim points As Double = 595.28
Dim mm As Double = VNSPDFModule.ConvertFromPoints(points, VNSPDFModule.ePageUnit.Millimeters)
// Result: ~210 mm
```

#### FindSystemFontPath
```xojo
Function FindSystemFontPath(fontName As String, styleSuffix As String = "") As String
```

**Parameters**:
- `fontName` - Font family name (e.g., "Verdana", "Georgia", "DejaVu Sans")
- `styleSuffix` - Optional style suffix: "", " Bold", " Italic", " Bold Italic"

**Returns**: Full native file path if found, empty string if not found

**Description**: Recursively searches platform-specific font directories for a TrueType font file (.ttf or .ttc). Results are cached in `mSystemFontCache` for performance. This is called automatically by `AddUTF8Font()` when no file path is provided.

**Platform directories searched**:
- **macOS**: `/System/Library/Fonts`, `/Library/Fonts`, `~/Library/Fonts`
- **Windows**: `C:\Windows\Fonts`, `~\AppData\Local\Microsoft\Windows\Fonts`
- **Linux**: `/usr/share/fonts`, `/usr/local/share/fonts`, `~/.fonts`, `~/.local/share/fonts`
- **iOS**: No system font search (fonts must be bundled with the app)

**Example**:
```xojo
Dim path As String = VNSPDFModule.FindSystemFontPath("Verdana")
// macOS: "/System/Library/Fonts/Supplemental/Verdana.ttf"
// Windows: "C:\Windows\Fonts\verdana.ttf"
// Linux: "/usr/share/fonts/truetype/msttcorefonts/Verdana.ttf"

Dim boldPath As String = VNSPDFModule.FindSystemFontPath("Verdana", " Bold")
// Searches for "Verdana Bold.ttf" or "Verdana Bold.ttc"
```

## Graphics State Classes

### VNSPDFBlendMode

**Location**: `PDF_Library/Core/VNSPDFBlendMode.xojo_code`

Data structure for managing transparency and blend mode graphics state objects in PDF documents.

#### Properties

##### fillStr (Public)
```xojo
Public fillStr As String
```

Alpha value for fill operations as formatted PDF string (e.g., "0.5" for 50% opacity).

##### strokeStr (Public)
```xojo
Public strokeStr As String
```

Alpha value for stroke operations as formatted PDF string.

##### modeStr (Public)
```xojo
Public modeStr As String
```

Blend mode name (e.g., "Normal", "Multiply", "Screen", "Overlay").

##### objNum (Public)
```xojo
Public objNum As Integer = 0
```

PDF object number for this ExtGState resource. Used for referencing in page resources.

#### Usage

This class is used internally by VNSPDFDocument to manage transparency states. Users typically don't interact with this class directly - instead, use the `SetAlpha()` method on VNSPDFDocument.

**Internal Example** (from VNSPDFDocument):
```xojo
Dim bl As New VNSPDFBlendMode
bl.fillStr = "0.7"
bl.strokeStr = "0.7"
bl.modeStr = "Multiply"
bl.objNum = 15  // Assigned during PDF object creation

// Later used to generate PDF ExtGState dictionary:
// 15 0 obj
// <</Type /ExtGState /ca 0.7 /CA 0.7 /BM /Multiply>>
// endobj
```

**Notes**:
- Each unique combination of alpha and blend mode creates one VNSPDFBlendMode instance
- Instances are reused when same transparency/blend combination is requested
- PDF 1.4+ required for transparency support

## Media Classes

### VNSPDFImage

**Location**: `PDF_Library/Media/VNSPDFImage.xojo_code`

Image parser and metadata extractor for JPEG and PNG files.

#### Constructor

```xojo
Sub Constructor(imageFilePath As String)
```

**Parameters**:
- `imageFilePath` - Path to JPEG or PNG image file

**Description**: Loads and parses an image file, extracting dimensions, color space, and format information.

**Example**:
```xojo
Dim img As New VNSPDFImage("/path/to/photo.jpg")

If img.IsValid() Then
    Dim width As Integer = img.GetWidth()
    Dim height As Integer = img.GetHeight()
Else
    MsgBox "Image error: " + img.GetError()
End If
```

#### Methods

##### IsValid
```xojo
Function IsValid() As Boolean
```

**Returns**: True if image was loaded and parsed successfully

##### GetWidth
```xojo
Function GetWidth() As Integer
```

**Returns**: Image width in pixels

##### GetHeight
```xojo
Function GetHeight() As Integer
```

**Returns**: Image height in pixels

##### GetImageType
```xojo
Function GetImageType() As String
```

**Returns**: Image type ("jpeg" or "png")

##### GetColorSpace
```xojo
Function GetColorSpace() As String
```

**Returns**: PDF color space ("DeviceRGB", "DeviceGray", "DeviceCMYK")

##### GetBitsPerComponent
```xojo
Function GetBitsPerComponent() As Integer
```

**Returns**: Bits per color component (typically 8)

##### GetImageData
```xojo
Function GetImageData() As String
```

**Returns**: Raw image data as binary string

##### GetError
```xojo
Function GetError() As String
```

**Returns**: Error message if image loading failed, empty string otherwise

**Notes**:
- Automatically detects image format from file signature
- Supports JPEG (baseline, progressive)
- Supports PNG (non-interlaced, most color types)
- PNG alpha channel and indexed color supported
- CMYK JPEG images supported

---

## Premium Modules

**Location**: `PDF_Library/Premium/`

Premium modules extend the FREE version with advanced features that require a separate license.

**Pricing**: EUR 50 per module | **Bundle**: Buy 2, Get 1 Free = EUR 100 (save EUR 50)

### Module Overview

| Module | File | Status | Description |
|--------|------|--------|-------------|
| **Encryption** | VNSPDFEncryptionPremium.xojo_code | ✅ Complete | RC4-128 + AES-128/256 encryption |
| **PDF/A** | VNSPDFPDFAPremium.xojo_code | ✅ Complete | Output Intent + ICC profiles |
| **Zlib** | VNSPDFZlibPremium.xojo_code | ✅ Complete | Pure Xojo zlib for iOS compression |
| **Table** | VNSPDFTablePremium.xojo_code | ✅ Complete | SimpleTable, ImprovedTable, FancyTable |
| **Forms** | VNSPDFFormsPremium.xojo_code | 🔨 Coming Soon | Interactive PDF AcroForms |

### Module Flags

Premium module availability is controlled by Boolean constants in `VNSPDFModule.xojo_code`:

```xojo
// Module availability flags (lines 806-815)
Public Const hasPremiumVNSEncryptionModule As Boolean = False  // RC4-128 + AES
Public Const hasPremiumVNSPDFAModule As Boolean = False        // PDF/A output intents
Public Const hasPremiumVNSZlibModule As Boolean = False        // iOS compression
Public Const hasPremiumVNSTableModule As Boolean = False       // Table generation
Public Const hasPremiumVNSFormsModule As Boolean = False       // AcroForms
```

To enable a premium module:
1. Purchase the module license
2. Add the premium module file to your project
3. Set the corresponding flag to `True`
4. Rebuild your project

### VNSPDFEncryptionPremium

**Module Flag**: `hasPremiumVNSEncryptionModule`

Provides enhanced encryption beyond the FREE version's RC4-40:

**Features**:
- ✅ **RC4-128 encryption** - 128-bit RC4 (fully working)
- ✅ **AES-128 encryption** - 128-bit AES-CBC (fully working via pure Xojo AES)
- ✅ **AES-256 encryption** - 256-bit AES-CBC (fully working via pure Xojo AES)

**Usage Example**:
```xojo
If hasPremiumVNSEncryptionModule Then
    // Use RC4-128 (premium)
    pdf.SetProtection("user", "owner", True, True, True, True, _
                      VNSPDFModule.gkEncryptionRC4_128)
Else
    // Fallback to RC4-40 (free)
    pdf.SetProtection("user", "owner", True, True, True, True, _
                      VNSPDFModule.gkEncryptionRC4_40)
End If
```

### VNSPDFPDFAPremium

**Module Flag**: `hasPremiumVNSPDFAModule`

Provides PDF/A archival compliance features:

**Features**:
- ✅ **Output Intent** - Specify color reproduction characteristics
- ✅ **ICC Color Profiles** - Embed color profiles for consistency
- ✅ **Automatic sRGB Detection** - Finds system color profiles (macOS)

**Usage Example**:
```xojo
If hasPremiumVNSPDFAModule Then
    // Load ICC profile
    Dim iccProfile As MemoryBlock = LoadICCProfile()

    // Add output intent for PDF/A
    pdf.AddOutputIntent(VNSPDFModule.gkOutputIntentPDFA1, _
                        "sRGB IEC61966-2.1", _
                        "sRGB color space", _
                        iccProfile)
End If
```

### VNSPDFZlibPremium

**Module Flag**: `hasPremiumVNSZlibModule`

Provides pure Xojo zlib compression for iOS support:

**Features**:
- ✅ **iOS compression** - Pure Xojo DEFLATE implementation
- ✅ **PNG Predictor reversal** - Required for modern PDF import
- ✅ **27-60% file size reduction** - Efficient compression for all platforms

### VNSPDFTablePremium

**Module Flag**: `hasPremiumVNSTableModule`

Provides high-level declarative table API:

**Features**:
- ✅ **SimpleTable** - Basic table from RowSet data
- ✅ **ImprovedTable** - Enhanced with alternating row colors
- ✅ **FancyTable** - Full-featured with auto pagination and header repetition
- ✅ **Auto column sizing** and smart number alignment

### Detailed Documentation

For comprehensive documentation on premium modules, including:
- Installation instructions
- Feature comparisons (FREE vs PREMIUM)
- Implementation details
- Code examples
- Troubleshooting

See **[Chapter 16: Premium Modules](16-premium-modules.md)**
