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
