# Xojo FPDF Library

A Xojo port of the popular FPDF library for PDF generation, supporting Desktop, Web, iOS, and Console applications.

[Homepage](https://www.verynicesw.fr/xojo-fpdf-pure-xojo-pdf-generation-with-full-unicode-support.html)

[More about Premium Modules](https://www.verynicesw.fr/xojo-fpdf-premium-modules.html)

## Overview

Xojo_fpdf is a pure Xojo implementation for creating PDF documents programmatically. It is based on the excellent [go-pdf/fpdf](https://codeberg.org/go-pdf/fpdf) library and the original [PHP FPDF](http://www.fpdf.org/) library.

## Features

- **Cross-Platform**: Works with Xojo Desktop, Web, iOS, and Console applications
- **Pure Xojo**: No external dependencies or plugins required
- **Shared Codebase**: Maximum code reuse between all platform targets
- **Core PDF Fonts**: Built-in support for standard PDF fonts (Helvetica, Times, Courier, etc.)
- **TrueType Fonts**: Full Unicode support with UTF-8 encoding and proper glyph spacing
- **Font Subsetting**: Automatic TrueType font optimization (98% size reduction, sparse glyph IDs)
- **Emoji Support**: Color emoji rendering with cross-platform compatibility (image-based)
- **Page Management**: Easy page creation and manipulation
- **Custom Page Sizes**: Support for standard sizes (A4, Letter, Legal, etc.) and custom dimensions
- **Flexible Units**: Work in millimeters, centimeters, inches, or points
- **Portrait/Landscape**: Automatic handling of page orientation
- **Gradients**: Linear, radial, and multi-stop gradients with PDF shading patterns (FunctionType 3 stitching)
- **Clipping Paths**: Rectangular, circular, elliptical, polygon, and text clipping with nesting support
- **Bezier Curves**: Quadratic and cubic Bezier curves for smooth curved paths
- **Arrows**: Lines with arrowheads at start, end, or both ends
- **Polygons**: Arbitrary polygon shapes from Point arrays (triangles, pentagons, stars, etc.)
- **Error Accumulation**: Graceful error handling without interrupting workflow
- **Bounds Checking**: Optional exception mode for out-of-bounds drawing detection
- **PDF Import**: Import pages from existing PDF files as XObject Form templates with full parsing, resource copying, and nested XObject support (most real-world PDFs use FlateDecode compression and require the premium Zlib module for import)
- **File Attachments**: Document-level and page annotation attachments (E-Invoice/Factur-X ready)
- **PDFGraphics Compatible**: VNSPDFGraphics provides complete Xojo PDFGraphics API compatibility
- **DrawObject Support**: Full Object2D rendering (RectShape, OvalShape, RoundRectShape, ArcShape, CurveShape, FigureShape, TextShape, PixmapShape, Group2D with rotation)
- **CJK Text Wrapping**: Intelligent character-based line breaking for Chinese, Japanese, Korean text

### Premium Modules (Optional)

**💡 Purchase Only What You Need!** Each premium module can be purchased separately:

- **🔐 Encryption Module** ✅ *Ready* - RC4-128, AES-128, AES-256 encryption with pure Xojo implementation
- **📊 Table Module** ✅ *Ready* - Professional table generation with headers, footers, pagination, and calculations
- **🗜️ Zlib Module** ✅ *Ready* - Pure Xojo compression for iOS support (bypasses sandboxing)
- **📝 Forms Module** 📋 *Planned* - Interactive PDF AcroForms with text fields, checkboxes, radio buttons, dropdowns, buttons, and signature fields
- **🔮 PDF/A Module** 📋 *Planned* - Full archival compliance with validation
- **🧾 E-Invoice Module** 📋 *Planned* - Factur-X, ZUGFeRD, EN 16931 compliant hybrid PDF/XML invoices

All premium modules are delivered as **full, unencrypted source code** - same transparency as the free version!

For details, see `docs/FEATURE_COMPARISON_PREMIUM.md`

## Installation

1. Open your Xojo project (Desktop, Web, iOS, or Console)
2. Add the `PDF_Library` folder to your project
3. The library is now ready to use

## Available Project Files

The repository includes four ready-to-use project files:

- **Xojo_fpdf_free.xojo_project** - Desktop application with GUI examples
- **Xojo_fpdf_web_free.xojo_project** - Web application with browser-based examples
- **Xojo_iospdf_free.xojo_project** - iOS application with touch-based interface
- **xojo_consolepdf_free.xojo_project** - Console application with interactive menu

All projects share the same `PDF_Library` folder for maximum code reuse. All four projects (Desktop, Web, iOS, and Console) include **23 working examples** demonstrating various PDF features.

### iOS Application

The iOS project provides a native iOS interface with 23 example buttons:

- Generates PDFs using the shared `VNSPDFExamplesModule`
- Saves PDFs to the iOS Documents folder
- Displays generation status in a text area
- Fully functional on iOS Simulator and devices

**iOS-Specific Implementation Notes**:
- Uses `iOSTextArea` for output display (API1)
- String to Text conversion via `.ToText` method (deprecated warning in newer Xojo)
- File I/O uses iOS-specific `SpecialFolder.Documents` instead of `SpecialFolder.Desktop`
- String operations use 0-based `String.Middle()` and `String.Length` (iOS API2 syntax)
- Conditional compilation handles platform differences transparently
- All PDF generation code is platform-independent with automatic iOS adaptations
- **iOS compression with Premium module**: Pure Xojo zlib implementation enables full compression on iOS (bypasses sandboxing). FREE version generates uncompressed PDFs on iOS.
- **MemoryBlock String Extraction**: iOS uses byte-by-byte extraction (`UInt8Value`/`UInt16Value`) instead of `MemoryBlock.StringValue()` which crashes on large buffers (>20MB) at high offsets

## Quick Start

### Basic Example

```xojo
// Create a new PDF document (default: A4, Portrait, Millimeters)
Dim pdf As New VNSPDFDocument()

// Set metadata (Xojo PDFDocument-compatible properties)
pdf.Title = "My First PDF"
pdf.Author = "Your Name"

// Set font and add content
pdf.SetFont("helvetica", "B", 16)
pdf.Cell(0, 10, "Hello World!", 1, 1, "C")

// Add more content
pdf.SetFont("helvetica", "", 12)
pdf.MultiCell(0, 6, "This is a longer paragraph that demonstrates the MultiCell method with automatic text wrapping.", 1, "L")

// Save the PDF (Xojo PDFDocument-compatible method)
Dim f As FolderItem = SpecialFolder.Desktop.Child("output.pdf")
pdf.Save(f)
```

### Specifying Page Format

```xojo
// Xojo PDFDocument-compatible: Use page format enum
Dim pdf As New VNSPDFDocument(VNSPDFModule.ePageFormat.Letter)

// Or use custom dimensions (width, height in points)
Dim pdf2 As New VNSPDFDocument(612.0, 792.0)  // US Letter in points

// Advanced: Full control with orientation and units
Dim pdf3 As New VNSPDFDocument( _
    VNSPDFModule.ePageOrientation.Landscape, _
    VNSPDFModule.ePageUnit.Inches, _
    VNSPDFModule.ePageFormat.Letter _
)
```

### Console Application

The console project provides an interactive menu to try all examples:

```bash
$ ./xojo_consolepdf
============================================================
Xojo FPDF Console Application
PDF Generation Examples
============================================================

Available Examples:

  1. Simple Shapes
     Lines, rectangles, circles with colors

  2. Text Layouts
     Cell, MultiCell, and Write methods with alignment

  3. Multiple Pages
     3 pages with circles, rectangles, and ellipses

  4. Line Widths
     Demonstration of different line widths and styles

  5. UTF-8 & TrueType Fonts
     TrueType font loading (requires Arial.ttf)

  6. Text Measurement
     GetStringWidth() for alignment

  7. Document Metadata
     Title, Author, Subject, Keywords

  8. Error Handling
     Ok(), Err(), GetError(), SetError(), ClearError()

  9. Image Support
     JPEG, PNG, and programmatic graphics (ImageFromPicture)

  10. Header/Footer Callbacks
      Automatic headers and footers on every page

  11. Links and Bookmarks
      Internal links, external URLs, and PDF bookmarks

  12. Custom Page Formats
      AddPageFormat() with custom dimensions and PageSize()

  13. PDF/A Compliance
      ICC color profile embedding for archival PDFs

  0. Exit

Enter example number (0-13): 1

Generating Example 1: Simple shapes...
Success! PDF generated.
PDF saved: /Users/username/Desktop/example1_shapes.pdf
File size: 2847 bytes
```

PDFs are saved to the desktop.

### Available Page Formats

- A3 (297 x 420 mm)
- A4 (210 x 297 mm) - Default
- A5 (148 x 210 mm)
- Letter (8.5 x 11 inches)
- Legal (8.5 x 14 inches)

### Unit Options

- **Millimeters** (default) - `VNSPDFModule.ePageUnit.Millimeters`
- **Centimeters** - `VNSPDFModule.ePageUnit.Centimeters`
- **Inches** - `VNSPDFModule.ePageUnit.Inches`
- **Points** (1/72 inch) - `VNSPDFModule.ePageUnit.Points`

## API Reference

### Gradient Methods

Create smooth color transitions with PDF shading patterns:

```xojo
// Linear gradient (left to right)
pdf.LinearGradient(x, y, w, h, r1, g1, b1, r2, g2, b2, x1, y1, x2, y2)
// x, y, w, h: Rectangle position and size
// r1, g1, b1: Start color (0-255)
// r2, g2, b2: End color (0-255)
// x1, y1, x2, y2: Gradient vector (normalized 0-1)
// Example: (0, 0, 1, 0) = left to right
//          (0, 0, 0, 1) = top to bottom

// Radial gradient (center to edge)
pdf.RadialGradient(x, y, w, h, r1, g1, b1, r2, g2, b2, x1, y1, x2, y2, r)
// x1, y1: Starting circle center (normalized 0-1)
// x2, y2: Ending circle center (normalized 0-1)
// r: Ending circle radius (normalized 0-1)

// Multi-stop linear gradient (rainbow gradients)
pdf.LinearGradientMultiStop(x, y, w, h, stops(), x1, y1, x2, y2)
// stops: Array of Pairs where Left = position (0.0-1.0), Right = Color
// Example: Rainbow gradient
Dim stops() As Pair
stops.Add(0.0 : Color.Red)
stops.Add(0.25 : Color.Yellow)
stops.Add(0.5 : Color.Green)
stops.Add(0.75 : Color.Cyan)
stops.Add(1.0 : Color.Blue)
pdf.LinearGradientMultiStop(10, 10, 100, 50, stops, 0, 0, 1, 0)
```

**VNSPDFGraphics Brush Support:**

VNSPDFGraphics supports Xojo's gradient brushes (LinearGradientBrush, RadialGradientBrush, PictureBrush):

```xojo
Dim g As New VNSPDFGraphics(pdf)

// LinearGradientBrush - multi-stop gradients supported
Dim lgb As New LinearGradientBrush
lgb.StartPoint = New Point(0, 0)
lgb.EndPoint = New Point(100, 0)
lgb.GradientStops.Add(0.0 : Color.Red)
lgb.GradientStops.Add(0.5 : Color.Yellow)
lgb.GradientStops.Add(1.0 : Color.Blue)
g.Brush = lgb
g.FillRectangle(10, 10, 100, 50)

// RadialGradientBrush
Dim rgb As New RadialGradientBrush
rgb.StartPoint = New Point(50, 25)
rgb.EndRadius = 50
g.Brush = rgb
g.FillOval(10, 70, 100, 50)
```

### Clipping Methods

Confine rendering to specific shapes:

```xojo
// Rectangular clipping
pdf.ClipRect(x, y, w, h, outline)

// Circular clipping
pdf.ClipCircle(x, y, r, outline)

// Elliptical clipping
pdf.ClipEllipse(x, y, rx, ry, outline)

// Text-shaped clipping
pdf.ClipText(x, y, "TEXT", outline)

// Rounded rectangle clipping
pdf.ClipRoundedRect(x, y, w, h, r, "1234", outline)
// r: corner radius
// "1234": which corners to round (top-left, top-right, bottom-right, bottom-left)

// Polygon clipping
Dim points() As Pair
points.Append(New Pair(x1, y1))
points.Append(New Pair(x2, y2))
points.Append(New Pair(x3, y3))
pdf.ClipPolygon(points, outline)

// End clipping (restore graphics state)
pdf.ClipEnd()
// Note: Clipping can be nested - call ClipEnd() for each clipping operation
```

### Example: Gradient with Clipping

```xojo
// Create circular clipping region
pdf.ClipCircle(100, 100, 50, False)

// Fill with gradient
pdf.LinearGradient(50, 50, 100, 100, 255, 0, 0, 0, 0, 255, 0, 0, 1, 0)

// Restore graphics state
pdf.ClipEnd()
```

### Bezier Curves and Arrows

Draw smooth curves and lines with arrowheads:

```xojo
// Quadratic Bezier curve (one control point)
pdf.Curve(10, 50, 50, 30, 90, 50, "D")
// (10, 50): Start point
// (50, 30): Control point
// (90, 50): End point
// "D": Draw (outline only)

// Cubic Bezier curve (two control points)
pdf.CurveBezierCubic(10, 70, 30, 60, 60, 80, 90, 70, "D")
// (10, 70): Start point
// (30, 60): First control point
// (60, 80): Second control point
// (90, 70): End point
// "D": Draw, "F": Fill, "DF": Draw and Fill

// Filled Bezier curve
pdf.SetFillColor(200, 220, 255)
pdf.SetDrawColor(0, 0, 200)
pdf.CurveBezierCubic(10, 90, 30, 80, 60, 100, 90, 90, "DF")

// Simple arrow (end only)
pdf.Arrow(20, 120, 80, 120, False, True, 3)
// (20, 120): Start point
// (80, 120): End point
// False: No arrow at start
// True: Arrow at end
// 3: Arrowhead size

// Bidirectional arrow
pdf.Arrow(20, 140, 80, 140, True, True, 3)
// True, True: Arrows at both ends

// Diagonal arrow with custom size
pdf.Arrow(20, 160, 80, 180, False, True, 5)
// 5: Larger arrowhead

// Polygon - triangle
Dim triangle() As Point
triangle.Add(New Point(100, 120))
triangle.Add(New Point(130, 120))
triangle.Add(New Point(115, 100))
pdf.SetDrawColor(255, 0, 0)
pdf.Polygon(triangle, "D")  // Outline only

// Polygon - filled pentagon
Dim pentagon() As Point
pentagon.Add(New Point(150, 120))
pentagon.Add(New Point(170, 115))
pentagon.Add(New Point(165, 95))
pentagon.Add(New Point(145, 95))
pentagon.Add(New Point(140, 115))
pdf.SetFillColor(0, 200, 100)
pdf.Polygon(pentagon, "F")  // Fill only

// Polygon - filled and outlined hexagon
Dim hexagon() As Point
hexagon.Add(New Point(180, 120))
hexagon.Add(New Point(195, 115))
hexagon.Add(New Point(195, 100))
hexagon.Add(New Point(180, 95))
hexagon.Add(New Point(165, 100))
hexagon.Add(New Point(165, 115))
pdf.SetDrawColor(0, 0, 128)
pdf.SetFillColor(200, 220, 255)
pdf.Polygon(hexagon, "DF")  // Fill and outline
```

## Project Structure

```
PDF_Library/
├── VNSPDFModule.xojo_code          # Global constants, enums, and utilities
└── Core/
    └── VNSPDFDocument.xojo_code    # Main document class with all PDF operations
```

**Key Classes**:
- `VNSPDFDocument` - Main class for PDF creation and manipulation
- `VNSPDFModule` - Module containing enums, constants, and helper functions

**Available Methods**:

*Page & Document*:
- `AddPage()` - Add a new page to the document
- `AddPageFormat(orientation, width, height)` - Add page with custom dimensions
- `SetPage(pageNum)` - Navigate to a specific page (for adding content to earlier pages)
- `PageNo()` - Get current page number
- `PageCount()` - Get total number of pages in document
- `PageSize(pageNum, ByRef width, ByRef height)` - Get dimensions of specific page
- `GetPageSize(ByRef width, ByRef height)` - Get current page dimensions
- `SetAutoPageBreak(enable, margin)` - Enable/disable automatic page breaks
- `GetAutoPageBreak(ByRef enable, ByRef margin)` - Get auto page break settings

*Xojo PDFDocument-Compatible Properties* (read/write):
- `Title` - Document title metadata
- `Author` - Author name metadata
- `Subject` - Subject/description metadata
- `Keywords` - Comma-separated keywords
- `Creator` - Application name
- `Language` - Document language (e.g., "en-US")
- `CurrentPage` - Current page number (1-based)
- `PageHeight` - Current page height in points
- `PageWidth` - Current page width in points
- `Landscape` - True if current page is landscape orientation
- `Compressed` - Enable/disable stream compression
- `Graphics` - VNSPDFGraphics object for drawing

*Legacy Metadata Methods* (still supported):
- `SetTitle(title)`, `SetAuthor(author)`, `SetSubject(subject)`, `SetKeywords(keywords)`, `SetCreator(creator)`, `SetLang(lang)`

*Text Output*:
- `SetFont(family, style, size)` - Set the current font
- `SetFontSize(size)` - Change font size without changing family/style
- `SetFontStyle(style)` - Change font style without changing family/size
- `GetFontFamily()` - Get current font family
- `GetFontStyle()` - Get current font style
- `GetFontSize(ByRef ptSize, unitSize)` - Get font size in points and user units
- `SetWordSpacing(space)` - Set spacing between words in user units
- `GetWordSpacing()` - Get current word spacing value
- `SetUnderlineThickness(thickness)` - Set underline thickness multiplier (default 1.0)
- `GetUnderlineThickness()` - Get underline thickness multiplier
- `SetTextRenderingMode(mode)` - Set text rendering mode (0-7: fill, stroke, invisible, clip, etc.)
- `GetStringWidth(text)` - Calculate text width for alignment
- `Cell(w, h, text, border, ln, align, fill)` - Output a cell with text
- `MultiCell(w, h, text, border, align, fill)` - Output text with automatic wrapping
- `Write(h, text)` - Output flowing text
- `WriteLinkString(h, displayStr, targetStr)` - Write text with clickable URL link
- `WriteLinkID(h, displayStr, linkID)` - Write text with internal link ID
- `WriteAligned(width, lineHeight, text, align)` - Write text with alignment (L/C/R)
- `SplitLines(text, width)` - Split text into lines that fit within width
- `Text(x, y, text)` - Output text at specific coordinates

*Graphics*:
- `Line(x1, y1, x2, y2)` - Draw a line
- `Rect(x, y, w, h, style)` - Draw a rectangle
- `RoundedRect(x, y, w, h, r, corners, style)` - Draw a rectangle with rounded corners
- `RoundedRectExt(x, y, w, h, rTL, rTR, rBR, rBL, style)` - Draw a rectangle with different radius per corner
- `Circle(x, y, r, style)` - Draw a circle
- `Ellipse(x, y, rx, ry, style)` - Draw an ellipse
- `Arc(x, y, rx, ry, degRotate, degStart, degEnd, style)` - Draw an elliptical arc
- `Curve(x0, y0, cx, cy, x1, y1, style)` - Draw a quadratic Bezier curve
- `CurveBezierCubic(x0, y0, cx0, cy0, cx1, cy1, x1, y1, style)` - Draw a cubic Bezier curve
- `Arrow(x1, y1, x2, y2, startArrow, endArrow, arrowSize)` - Draw a line with arrowheads
- `Polygon(points() As Point, style)` - Draw a closed polygon from array of Point objects
- `SetTextColor(r, g, b)` - Set text color
- `SetFillColor(r, g, b)` - Set fill color
- `SetDrawColor(r, g, b)` - Set draw color
- `GetTextColor(ByRef r, g, b)` - Get text color RGB components
- `GetFillColor(ByRef r, g, b)` - Get fill color RGB components
- `GetDrawColor(ByRef r, g, b)` - Get draw color RGB components
- `SetLineWidth(width)` - Set line width
- `GetLineWidth()` - Get current line width
- `SetLineCapStyle(style)` - Set line cap style ("butt", "round", "square")
- `GetLineCapStyle()` - Get current line cap style
- `SetLineJoinStyle(style)` - Set line join style ("miter", "round", "bevel")
- `GetLineJoinStyle()` - Get current line join style
- `SetDashPattern(dashArray(), dashPhase)` - Set line dash pattern
- `SetAlpha(alpha, blendMode)` - Set transparency (0.0-1.0) and blend mode
- `GetAlpha()` - Get current alpha transparency value
- `GetBlendMode()` - Get current blend mode

*Images*:
- `Image(imagePath, x, y, w, h)` - Embed JPEG or PNG image
- `RegisterImage(imagePath, imageKey)` - Pre-register image for reuse
- `Emoji(emojiChar, x, y, size)` - Add color emoji at position (Desktop, iOS/Web planned, Console not supported)

*Links and Bookmarks*:
- `AddLink()` - Create a new internal link placeholder (returns linkID)
- `SetLink(linkID, y, pageNum)` - Define destination for an internal link
- `Link(x, y, w, h, linkID)` - Create clickable area for internal link
- `LinkString(x, y, w, h, url)` - Create clickable area for external URL
- `Bookmark(text, level, y)` - Add bookmark to PDF outline/sidebar

*PDF/A Compliance*:
- `AddOutputIntent(subtype, outputCondition, info, iccProfile)` - Add ICC color profile for PDF/A compliance

*Output*:
- `Save(file As FolderItem)` - Save PDF to file (Xojo PDFDocument-compatible)
- `ToData() As MemoryBlock` - Get PDF as MemoryBlock (Xojo PDFDocument-compatible)
- `SaveToFile(path)` - Save PDF to file (legacy method, still supported)
- `Output()` - Get PDF as String (legacy method, still supported)

*Margins & Positioning*:
- `SetMargins(left, top, right)` - Set page margins
- `GetMargins(ByRef left, top, right, bottom)` - Get all margin values
- `GetCellMargin()` - Get cell margin (spacing inside cells)
- `SetX(x)`, `SetY(y)`, `SetXY(x, y)` - Set cursor position
- `GetX()`, `GetY()` - Get current cursor position

*Compression*:
- `SetCompression(enable)` - Enable/disable stream compression (default: true)
- `GetCompression()` - Get current compression state
- **Note**: Desktop/Web/Console use system zlib; iOS requires **Premium Zlib module** for full compression (pure Xojo implementation bypasses sandboxing)

*Header/Footer*:
- `SetHeaderFunc(delegate)` - Set callback for automatic page headers
- `SetFooterFunc(delegate)` - Set callback for automatic page footers
- `PageNo()` - Get current page number (for use in header/footer)
- `FontFamily()`, `FontStyle()`, `FontSizePt()` - Get current font info (for state management)

*Error Handling*:
- `Ok()` - Returns true if no error occurred
- `Err()` - Returns true if an error occurred
- `GetError()` - Get error message string
- `SetError(message)` - Set an error (first error wins)
- `ClearError()` - Clear error state

*File Attachments*:
- `AddAttachment(filename, content, description)` - Add document-level file attachment
- `AddAttachmentAnnotation(filename, content, x, y, w, h, description)` - Add page annotation attachment

### VNSPDFGraphics - PDFGraphics Compatible API

Drop-in replacement for Xojo's native PDFGraphics class:

```xojo
// Use Graphics property (Xojo PDFDocument-compatible)
Dim pdf As New VNSPDFDocument()
Dim g As VNSPDFGraphics = pdf.Graphics

// Same API as Xojo's Graphics/PDFGraphics
g.DrawingColor = Color.Blue
g.FillRectangle(100, 100, 200, 50)
g.DrawText("Hello World!", 100, 200)

// Full Object2D support with rotation
Dim rect As New RectShape
rect.X = 150
rect.Y = 150
rect.Width = 100
rect.Height = 50
rect.FillColor = Color.Orange
rect.Rotation = 0.785  // 45 degrees
g.DrawObject(rect, 0, 0)

// Save using Xojo-compatible method
pdf.Save(SpecialFolder.Desktop.Child("output.pdf"))
```

*Properties*: Bold, Italic, Underline, FontName, FontSize, DrawingColor, PenSize, LineCap, LineJoin, CharacterSpacing, Width, Height

*Drawing*: DrawLine, DrawRectangle, FillRectangle, DrawOval, FillOval, DrawRoundRectangle, FillRoundRectangle, DrawPolygon, FillPolygon, DrawPath, FillPath, DrawPicture

*Text*: DrawText (with rotation), DrawTextBlock (word-wrap, CJK), TextWidth, TextHeight

*Object2D*: DrawObject supports RectShape, OvalShape, RoundRectShape, ArcShape, CurveShape, FigureShape, TextShape (with HorizontalAlignment), PixmapShape, Group2D (with rotation)

*Transforms*: Rotate, Translate, Scale, Transform

*State*: SaveState, RestoreState, ResetState

*Clipping*: Clip, ClipToRectangle, ClipToPath, ClipEnd

*Navigation*: NextPage

See `docs/developer/18-wrapper-classes.md` for complete PDFGraphics API compatibility reference.

## Current Status

**Version**: 1.1.1 (Production Ready)

**Xojo Compatibility**:
- Xojo 2025r3.1 with API2
- **✅ API2 Compliant** - Fully migrated from API1 to API2
- Desktop, Web, iOS, Console: Full support with platform-specific optimizations

**Implemented Features**:
- ✅ Document initialization
- ✅ Page management (AddPage, SetPage, PageNo, PageCount, multiple pages)
- ✅ Multiple page formats and orientations
- ✅ Unit conversion system (mm, cm, inches, points)
- ✅ Error accumulation pattern (Ok, Err, GetError, SetError, ClearError)
- ✅ Document metadata (Title, Author, Subject, Keywords, Creator, Language)
- ✅ UTF-16BE encoding for metadata (Unicode support)
- ✅ Core PDF fonts (Helvetica, Times, Courier, Symbol, ZapfDingbats)
- ✅ Font styles (Bold, Italic, Bold-Italic)
- ✅ Text rendering with proper positioning
- ✅ Text width measurement (GetStringWidth) for alignment
- ✅ Cell method with borders, alignment, and fill colors
- ✅ MultiCell method with automatic text wrapping
- ✅ Write method for flowing text
- ✅ Graphics primitives (Line, Rect, RoundedRect, Circle, Ellipse, Arc, Polygon)
- ✅ Rounded rectangles with selective corner rounding
- ✅ Elliptical arcs with rotation support
- ✅ Bezier curves (quadratic and cubic) for smooth curved paths
- ✅ Arrow lines with arrowheads at start, end, or both ends
- ✅ Polygon drawing with Point arrays for arbitrary shapes (triangles, pentagons, stars, etc.)
- ✅ Colors (RGB) for text, fill, and draw operations
- ✅ Line styles (width, cap, join, dash patterns)
- ✅ Alpha transparency and blend modes (Normal, Multiply, Screen, Overlay, etc.)
- ✅ PDF file output (SaveToFile, Output)
- ✅ Image support (JPEG, PNG with RGB/Grayscale/CMYK color spaces)
- ✅ TrueType font embedding with full UTF-8/Unicode support
- ✅ Comprehensive Unicode rendering with proper glyph spacing (CJK, Cyrillic, RTL scripts, math symbols, currencies)
- ✅ **Arabic text shaping** - Automatic contextual letter forms (isolated, initial, medial, final) with proper RTL rendering
- ✅ Stream compression (FlateDecode/zlib) - 27-60% file size reduction on text/vector content (Desktop/Web/Console via system libs; **iOS fully supported with Premium Zlib module**)
- ✅ Header/Footer callbacks (SetHeaderFunc, SetFooterFunc) with automatic invocation on every page
- ✅ Internal links (AddLink, SetLink, Link) for navigation within PDF
- ✅ External links (LinkString) to web URLs
- ✅ Bookmarks/Outlines for PDF sidebar navigation with hierarchical structure
- ✅ PDF/A compliance support (AddOutputIntent with ICC color profile embedding)
- ✅ Full iOS compatibility with conditional compilation for string operations, file I/O, and MobilePDFViewer display
- ✅ **Font subsetting** for TrueType fonts (98% file size reduction with sparse glyph IDs)
- ✅ **Color emoji support** via image-based rendering (cross-platform compatibility)
- ✅ **Document encryption** with password protection and permissions (RC4-40/128, AES-128/256)
  - RC4-40 (Revision 2) - Weak, not recommended
  - RC4-128 (Revision 3) - Legacy, deprecated (triggers warnings in Acrobat)
  - **AES-128 (Revision 4) - RECOMMENDED** for modern security
  - **AES-256 (Revisions 5-6) - BEST** for sensitive data
  - Pure Xojo AES implementation (VNSAESCore) - no Xojo Crypto limitations
- ✅ **Premium Table Module** (VNSPDFTablePremium) for automatic table generation
  - SimpleTable() - Equal-width columns with basic formatting
  - ImprovedTable() - Custom column widths with auto number alignment
  - FancyTable() - Professional styling with colored headers and alternating rows
  - Header repetition on page breaks via AcceptPageBreakFunc callback
  - SQLite-based data handling with RowSet for flexibility
  - Multi-page pagination with proper border handling
  - **Advanced Table Footers** (v1.1.0) - Subtotals and grand totals
    - Grand footers: Overall totals at end of table (all table types)
    - Intermediate footers: Subtotals at group breaks (all table types via footerConfig.GroupByColumn)
    - Multi-calculation cells: Combine SUM, AVG, MIN, MAX, COUNT in single cell
    - Template-based formatting with placeholders: `"{sum} items ({count} rows)"`
    - Custom styling for intermediate vs grand footers
    - Per-calculation number formatting (e.g., `%.2f` for currency)

**New in v1.1.0**:
- ✅ **VNSPDFGraphics API** - Complete Xojo PDFGraphics API compatibility (43 features)
- ✅ **DrawObject support** - Full Object2D rendering with rotation (RectShape, OvalShape, RoundRectShape, ArcShape, CurveShape, FigureShape, TextShape, PixmapShape, Group2D)
- ✅ **File attachments** - Document-level and page annotation attachments (E-Invoice/Factur-X ready)
- ✅ **DrawTextBlock** - Word-wrap with CJK character-based line breaking
- ✅ **Clipping methods** - Clip, ClipToRectangle, ClipToPath, ClipEnd
- ✅ **Transformation methods** - Rotate, Translate, Scale, Transform matrix
- ✅ **State management** - SaveState, RestoreState, ResetState
- ✅ **Bounds checking** - Optional exception mode (`gkRaiseExceptionOnOutOfBounds`)
- ✅ **23 working examples** across all 4 platforms

**New in v1.1.1** (Bug fixes from community feedback):
- ✅ **MultiCell single-line bottom border** - Fixed missing bottom border when border=1 on single-line cells
- ✅ **SplitTextToLines first character** - Fixed off-by-one error dropping first character of wrapped words
- ✅ **MultiCell newline handling** - Fixed Chr(10) and CRLF being ignored (all text on one line)
- ✅ **MultiCell positioning** - Fixed cursor not returning to left margin after MultiCell
- ✅ **ImageFromPicture on Windows/Linux** - Fixed PNG corruption (RGBA vs RGB mismatch) by forcing JPEG on Windows and Linux
- ✅ **Example 26** - Cross-platform bug test suite verifying all fixes on macOS, Windows 11, and Ubuntu 22.04 ARM64

**In Development**:
- 🔨 Native color emoji fonts for Web (SBIX, COLR/CPAL, SVG-in-OpenType) - Desktop/iOS working

**💡 Premium Modules Available Separately**: Each premium module (Encryption, Table, Zlib, PDF/A, E-Invoice) can be purchased individually. You only pay for the features you need! See `docs/FEATURE_COMPARISON_PREMIUM.md` for details.

## License

**Free Version**: This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

**Premium Modules**: Premium modules (Encryption, Table, Zlib, PDF/A, E-Invoice) are licensed separately and require purchase.

The free version is a Xojo port of:
- [go-pdf/fpdf](https://codeberg.org/go-pdf/fpdf) (MIT License) - Go implementation
- [PHP FPDF](http://www.fpdf.org/) by Olivier Plathey - Original library

## Credits

- Original FPDF by Olivier Plathey
- Go port by Kurt Jung and contributors
- Xojo port by Very Nice Software

## Contributing

This is currently in active development. Contributions and suggestions are welcome!

## Contact

Email: jypochez@verynicesw.fr

## Example Use Cases

- **Invoices and Reports**: Generate business documents programmatically
- **E-Invoices** 📋: Create hybrid PDF/XML electronic invoices compliant with Factur-X, ZUGFeRD, EN 16931 (Premium E-Invoice Module - Planned)
- **Certificates**: Create personalized certificates on-demand
- **Labels and Badges**: Print custom labels with barcodes
- **Forms**: Pre-fill PDF forms with data
- **Data Export**: Export database records to PDF
- **Web Reports**: Generate PDF reports from web applications
- **Secure Documents**: Password-protected PDFs with encryption (Premium Encryption Module)
- **Professional Tables**: Automated table generation with headers, footers, and pagination (Premium Table Module)
- **Archival PDFs**: PDF/A compliant documents with ICC profiles for long-term preservation

## Support

For bugs, feature requests, or questions, please contact jypochez@verynicesw.fr

---

**Note**: This library is production-ready (v1.1.0). Check the git history and `VERSION_HISTORY.md` for the latest updates.


