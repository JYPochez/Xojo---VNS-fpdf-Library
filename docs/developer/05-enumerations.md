# Enumerations

## ePageFormat

**Location**: `VNSPDFModule`

Standard PDF page formats.

```xojo
Enum ePageFormat
    A3 = 0          // 297 x 420 mm
    A4 = 1          // 210 x 297 mm (most common)
    A5 = 2          // 148 x 210 mm
    Letter = 3      // 8.5 x 11 inches (US standard)
    Legal = 4       // 8.5 x 14 inches (US legal)
    Custom = 5      // Custom size via AddPageFormat or Constructor(width, height)
End Enum
```

**Usage**:
```xojo
Dim pdf As New VNSPDFDocument(, , VNSPDFModule.ePageFormat.Letter)
```

## ePageOrientation

**Location**: `VNSPDFModule`

Page orientation options.

```xojo
Enum ePageOrientation
    Portrait = 0    // Vertical (height > width)
    Landscape = 1   // Horizontal (width > height)
End Enum
```

**Usage**:
```xojo
Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageOrientation.Landscape)
```

**Notes**:
- Portrait is the default orientation
- Landscape automatically swaps width and height dimensions

## ePageUnit

**Location**: `VNSPDFModule`

Unit of measurement for coordinates and dimensions.

```xojo
Enum ePageUnit
    Points = 0       // 1/72 inch (PDF native unit)
    Millimeters = 1  // mm (default, most common internationally)
    Centimeters = 2  // cm
    Inches = 3       // inches (US standard)
End Enum
```

**Usage**:
```xojo
Dim pdf As New VNSPDFDocument(, VNSPDFModule.ePageUnit.Inches)
```

**Conversion Factors**:
- 1 inch = 72 points
- 1 inch = 25.4 millimeters
- 1 inch = 2.54 centimeters

## ePathSegmentType

**Location**: `VNSPDFModule`

Path segment types for `VNSPDFGraphicsPath`. See [19-graphicspath.md](19-graphicspath.md) for full documentation.

```xojo
Enum ePathSegmentType
    MoveTo = 0              // Move to point without drawing
    LineTo = 1              // Straight line to point
    CubicBezierTo = 2       // Cubic Bezier curve (2 control points)
    QuadraticBezierTo = 3   // Quadratic Bezier curve (1 control point)
    CloseSubpath = 4        // Close current subpath back to start
    Rectangle = 5           // Axis-aligned rectangle
End Enum
```

**Usage**:
```xojo
Dim seg As New VNSPDFPathSegment(VNSPDFModule.ePathSegmentType.LineTo, 100, 200)
```

## eTextAlignment

**Location**: `VNSPDFModule`

Text alignment options for MultiCell, WriteAligned, and other text methods.

```xojo
Enum eTextAlignment
    Left = 0        // Left-aligned (default)
    Center = 1      // Center-aligned
    Right = 2       // Right-aligned
    Justify = 3     // Justified (even word spacing)
End Enum
```

**Usage**:
```xojo
pdf.MultiCell(190, 6, text, 1, "J", True)  // Most methods use string "L"/"C"/"R"/"J"
```

**Note**: Most text methods accept string alignment parameters (`"L"`, `"C"`, `"R"`, `"J"`) rather than this enum. The enum is used internally and by the Table module.

## eColumnAlignment

**Location**: `VNSPDFModule`

Column alignment options for the Table premium module.

```xojo
Enum eColumnAlignment
    Left = 0
    Center = 1
    Right = 2
End Enum
```

**Usage**:
```xojo
manualTable.AddColumn("Product", 60.0, VNSPDFModule.eColumnAlignment.Left)
manualTable.AddColumn("Price", 30.0, VNSPDFModule.eColumnAlignment.Right)
```

## eFooterCalcType

**Location**: `VNSPDFModule`

Footer calculation types for the Table premium module's automatic footer row.

```xojo
Enum eFooterCalcType
    None = 0        // No calculation
    Sum = 1         // Sum of column values
    Average = 2     // Average of column values
    Minimum = 3     // Minimum value
    Maximum = 4     // Maximum value
    Count = 5       // Count of rows
End Enum
```

**Usage**:
```xojo
manualTable.SetFooterCalc(2, VNSPDFModule.eFooterCalcType.Sum)  // Sum column 2
```

## eBarcodeType

**Location**: `VNSPDFModule`

Barcode types supported by the premium Barcode module (part of E-Invoice module). Free barcodes (QR, Code128) also available via `DrawQRCode`/`DrawCode128`.

```xojo
Enum eBarcodeType
    QRCode = 0      // 2D QR Code
    Code128 = 1     // 1D Code 128 (alphanumeric)
    EAN13 = 2       // 1D EAN-13 (retail)
    EAN8 = 3        // 1D EAN-8 (small retail)
    UPCA = 4        // 1D UPC-A (US retail)
    Code39 = 5      // 1D Code 39 (industrial)
    ITF = 6         // 1D Interleaved 2 of 5 (logistics)
    Codabar = 7     // 1D Codabar (libraries, blood banks)
    DataMatrix = 8  // 2D DataMatrix (industrial)
    PDF417 = 9      // 2D PDF417 (transport, ID cards)
End Enum
```

**Usage**:
```xojo
VNSPDFBarcode.DrawBarcode(pdf, VNSPDFModule.eBarcodeType.QRCode, 10, 10, 40, 40, "https://example.com")
```

## Drawing Styles (String Constants)

Drawing methods (Rect, Circle, Ellipse, Polygon, etc.) use String parameters for style:

- `"D"` - Draw/stroke outline only
- `"F"` - Fill interior only
- `"DF"` or `"FD"` - Fill and draw/stroke

**Example**:
```xojo
pdf.Rect(10, 10, 50, 30, "D")   // Outline only
pdf.Rect(10, 50, 50, 30, "F")   // Fill only
pdf.Rect(10, 90, 50, 30, "DF")  // Fill and outline
```
