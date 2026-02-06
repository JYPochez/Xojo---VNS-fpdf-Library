# 18. Xojo PDFDocument Compatibility

**Last Updated:** 2026-01-26

This chapter documents how VNSPDFDocument provides full compatibility with Xojo's native PDFDocument API, making migration and code sharing seamless.

---

## VNSPDFDocument - Drop-in Replacement for Xojo PDFDocument

### Overview

`VNSPDFDocument` is now a **drop-in replacement** for Xojo's native `PDFDocument` class. It provides:

- **Native Xojo-compatible API** - Same properties and methods as Xojo's PDFDocument
- **Graphics property** - Returns a PDFGraphics-compatible wrapper
- **Full UTF-8/Unicode support** - Arabic, Chinese, Japanese, Korean with proper text shaping
- **Advanced FPDF features** - All advanced methods accessible directly on the same object

### Constructors

```xojo
// Default constructor: A4, Portrait, Millimeters
Dim pdf As New VNSPDFDocument()

// Custom configuration with all parameters
Dim pdf As New VNSPDFDocument( _
    VNSPDFModule.ePageOrientation.Landscape, _
    VNSPDFModule.ePageUnit.Inches, _
    VNSPDFModule.ePageFormat.A4)
```

**Note:** The parameterless constructor `VNSPDFDocument()` creates a document with default settings (Portrait, Millimeters, A4), matching Xojo's PDFDocument behavior.

---

## Xojo PDFDocument-Compatible Properties

These properties match Xojo's PDFDocument API exactly:

| Property | Type | Access | Description |
|----------|------|--------|-------------|
| `Title` | String | Read/Write | Document title metadata |
| `Author` | String | Read/Write | Author name metadata |
| `Subject` | String | Read/Write | Subject/description metadata |
| `Keywords` | String | Read/Write | Comma-separated keywords |
| `Creator` | String | Read/Write | Application name |
| `Language` | String | Read/Write | Document language (e.g., "en-US") |
| `CurrentPage` | Integer | Read/Write | Current page number (1-based) |
| `PageHeight` | Double | Read | Current page height in points |
| `PageWidth` | Double | Read | Current page width in points |
| `Landscape` | Boolean | Read | True if current page is landscape |
| `Compressed` | Boolean | Read/Write | Enable/disable FlateDecode compression |
| `Graphics` | VNSPDFGraphics | Read | PDFGraphics-compatible drawing interface |

### Example Usage

```xojo
Dim pdf As New VNSPDFDocument()

// Set metadata (same as Xojo PDFDocument)
pdf.Title = "My Document"
pdf.Author = "John Doe"
pdf.Subject = "Annual Report"
pdf.Keywords = "report, 2025, financial"

// Use Graphics property (same as Xojo PDFDocument)
Dim g As VNSPDFGraphics = pdf.Graphics
g.DrawingColor = Color.Blue
g.FillRectangle(100, 100, 200, 50)
g.DrawText("Hello World", 100, 200)
```

---

## Xojo PDFDocument-Compatible Methods

These methods match Xojo's PDFDocument API:

### Save(file As FolderItem)

Save the PDF to a file (same as Xojo PDFDocument.Save).

```xojo
Dim file As FolderItem = SpecialFolder.Desktop.Child("output.pdf")
pdf.Save(file)
```

### ToData() As MemoryBlock

Get PDF content as MemoryBlock (same as Xojo PDFDocument.ToData).

```xojo
Dim pdfData As MemoryBlock = pdf.ToData()
// Use pdfData for uploads, etc.
```

### AddFonts(f As FolderItem)

Load a TrueType font file (same as Xojo PDFDocument.AddFonts).

```xojo
Dim fontFile As FolderItem = New FolderItem("/Library/Fonts/Arial.ttf", FolderItem.PathModes.Native)
pdf.AddFonts(fontFile)

// Font is now available using the filename without extension
Dim g As VNSPDFGraphics = pdf.Graphics
g.FontName = "Arial"  // Uses the loaded font
```

### ClearCache()

Clear temporary font cache (compatibility method - VNS PDF doesn't cache, so this is a no-op).

```xojo
pdf.ClearCache()
```

### Template() As JSONItem

Export document configuration as a JSON template (same as Xojo PDFDocument.Template).

```xojo
Dim template As JSONItem = pdf.Template()
// Save or share template
```

---

## VNSPDFGraphics - PDFGraphics Compatibility Wrapper

### Overview

`VNSPDFGraphics` provides full compatibility with Xojo's native `PDFGraphics` API. Access it via the `Graphics` property:

```xojo
Dim pdf As New VNSPDFDocument()
Dim g As VNSPDFGraphics = pdf.Graphics

// Now use g exactly like Xojo's PDFGraphics
g.DrawingColor = Color.Red
g.FillRectangle(100, 100, 200, 50)
```

### Key Features

- **Drop-in replacement** for Xojo's PDFGraphics
- **Full UTF-8/Unicode support** including Arabic, Chinese, Japanese, Korean
- **Complete Object2D support** with proper rotation and positioning
- **Extended features** like file attachments and annotations
- **Accessed via pdf.Graphics** - no manual instantiation needed

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `Bold` | Boolean | Enable/disable bold font style |
| `Italic` | Boolean | Enable/disable italic font style |
| `Underline` | Boolean | Enable/disable underline style |
| `FontName` | String | Current font family name |
| `FontSize` | Single | Current font size in points |
| `FontAscent` | Double | Font ascent (read-only) |
| `DrawingColor` | Color | Sets draw, fill, and text color together |
| `PenSize` | Double | Line width in points |
| `LineCap` | Graphics.LineCapTypes | Butt, Round, Square (same enum as Xojo!) |
| `LineJoin` | Graphics.LineJoinTypes | Miter, Round, Bevel (same enum as Xojo!) |
| `LineDash` | Variant | Dash pattern array or Nil for solid (identical syntax!) |
| `LineDashOffset` | Double | Dash pattern phase offset |
| `CharacterSpacing` | Integer | Extra space between characters |
| `Width` | Double | Page width in points (read-only) |
| `Height` | Double | Page height in points (read-only) |

### Drawing Methods

#### Lines and Rectangles

```xojo
g.DrawLine(x1, y1, x2, y2)
g.DrawRectangle(x, y, width, height)
g.FillRectangle(x, y, width, height)
g.DrawRoundRectangle(x, y, width, height, cornerWidth, cornerHeight)
g.FillRoundRectangle(x, y, width, height, cornerWidth, cornerHeight)
```

#### Ovals and Polygons

```xojo
g.DrawOval(x, y, width, height)
g.FillOval(x, y, width, height)

Dim points() As Point = Array(New Point(100, 100), New Point(200, 50), New Point(200, 150))
g.DrawPolygon(points)
g.FillPolygon(points)
```

#### Paths

```xojo
Dim path As New GraphicsPath
path.MoveToPoint(100, 100)
path.AddLineToPoint(200, 100)
path.AddLineToPoint(150, 50)
path.Close
g.DrawPath(path)
g.FillPath(path)
```

### Text Methods

```xojo
// Simple text
g.DrawText(text, x, y)

// Text with width constraint
g.DrawText(text, x, y, width, condense)

// Multi-line text block with word-wrap
g.DrawTextBlock(text, x, y, maxWidth, maxHeight, alignment, truncateLastLine)
// alignment: 0=Left, 1=Center, 2=Right

// Text measurement
Dim w As Double = g.TextWidth(text)
Dim h As Double = g.TextHeight()
Dim h2 As Double = g.TextHeight(text, wrapWidth)
```

### Transformation Methods

```xojo
// Rotate (angle in radians for Xojo compatibility)
g.Rotate(angle)
g.Rotate(angle, centerX, centerY)

// Translate
g.Translate(deltaX, deltaY)

// Scale
g.Scale(scaleX, scaleY)
```

### State Management

```xojo
// Save current state
g.SaveState()

// Make changes
g.DrawingColor = Color.Red
g.FontSize = 24
g.FillRectangle(100, 100, 200, 50)

// Restore previous state
g.RestoreState()
```

### Page Navigation

```xojo
// Add new page (calls pdf.AddPage internally)
g.NextPage()
```

### VNS-Only Extensions

These methods are not available in Xojo's native PDFGraphics:

```xojo
// Text annotation (sticky note)
g.AddAnnotation("This is a note", x, y)

// Document-level file attachment
g.AddEmbeddedFile("data.xml", xmlContent, "Invoice data")

// Page annotation attachment (clickable icon)
g.AddAttachmentAnnotation("invoice.xml", xmlContent, x, y, width, height, "Click to download")
```

---

## Migration Guide: Xojo PDFDocument to VNSPDFDocument

### Before (Xojo Native)

```xojo
Dim pdf As New PDFDocument(PDFDocument.PageSizes.A4)
pdf.Title = "My Document"
pdf.Author = "John Doe"

Dim g As Graphics = pdf.Graphics
g.DrawingColor = Color.Blue
g.FillRectangle(100, 100, 200, 50)
g.DrawText("Hello World", 100, 200)

pdf.Save(file)
```

### After (VNS PDF)

```xojo
Dim pdf As New VNSPDFDocument()  // Default is A4, Portrait, Millimeters
pdf.Title = "My Document"
pdf.Author = "John Doe"

Dim g As VNSPDFGraphics = pdf.Graphics
g.DrawingColor = Color.Blue
g.FillRectangle(100, 100, 200, 50)
g.DrawText("Hello World", 100, 200)

pdf.Save(file)
```

### Key Differences

| Xojo PDFDocument | VNS PDF | Notes |
|-----------------|---------|-------|
| `New PDFDocument(PageSizes.A4)` | `New VNSPDFDocument()` | VNS uses default constructor |
| `pdf.Graphics` → Graphics | `pdf.Graphics` → VNSPDFGraphics | Same property name! |
| `pdf.Save(file)` | `pdf.Save(file)` | Identical method! |
| Limited Unicode | Full UTF-8 support | Arabic, CJK with text shaping |
| No PDF Import | `ImportPage()`, `UseTemplate()` | Import existing PDFs |
| No encryption | RC4-40/128, AES-128/256 | Full encryption support |

### Advantages of VNS PDF

1. **Full UTF-8/Unicode** - Arabic text shaping, CJK word wrapping
2. **PDF Import** - Use existing PDFs as templates
3. **Encryption** - Password protection with RC4/AES
4. **Advanced features** - Gradients, transformations, clipping
5. **Cross-platform** - Desktop, Web, iOS, Console with same API
6. **File attachments** - Document-level and page-level annotations
7. **Advanced FPDF methods** - Cell, MultiCell, Write, etc. on same object

---

## Advanced FPDF Methods (Bonus)

While VNSPDFDocument provides Xojo compatibility, you can also access powerful FPDF methods directly:

### Document & Pages
```xojo
pdf.AddPage()
pdf.AddPageFormat(orientation, w, h)
pdf.SetPage(pageNum)
pdf.PageNo()
pdf.PageCount()
```

### Text Methods (FPDF-style)
```xojo
pdf.SetFont("Helvetica", "B", 16)
pdf.AddUTF8Font("Arial", "", "/path/to/arial.ttf")
pdf.Cell(w, h, text, border, ln, align, fill)
pdf.MultiCell(w, h, text, border, align, fill)
pdf.Write(h, text)
pdf.Text(x, y, text)
```

### Graphics (FPDF-style)
```xojo
pdf.Line(x1, y1, x2, y2)
pdf.Rect(x, y, w, h, style)
pdf.Circle(x, y, r, style)
pdf.Ellipse(x, y, rx, ry, style)
pdf.Polygon(points, style)
```

### Transformations
```xojo
pdf.TransformBegin()
pdf.TransformRotate(angle, x, y)
pdf.TransformScale(scaleX, scaleY, x, y)
pdf.Transform(a, b, c, d, e, f)
pdf.TransformEnd()
```

### Gradients
```xojo
pdf.LinearGradient(x, y, w, h, r1, g1, b1, r2, g2, b2, x1, y1, x2, y2)
pdf.RadialGradient(x, y, w, h, r1, g1, b1, r2, g2, b2, x1, y1, x2, y2, r)
```

### PDF Import
```xojo
Dim templateID As Integer = pdf.ImportPage(pageNum)
pdf.UseTemplate(templateID, x, y, w, h)
```

### Encryption
```xojo
pdf.SetProtection(userPass, ownerPass, permissions, algo)
// algo: 0=RC4-40, 1=RC4-128, 2=AES-128, 3=AES-256
```

---

## Best Practices

### When to Use Graphics Property vs Direct Methods

**Use Graphics property (Xojo-style) for:**
- Simple drawing tasks
- Code that must work with both Xojo and VNS
- Object2D rendering
- Standard text and shapes

**Use direct FPDF methods for:**
- Multi-line text with word wrapping (MultiCell)
- Table layouts (Cell)
- PDF import and templates
- Advanced transformations
- Gradients
- Encryption

### Example: Mixing Both APIs

```xojo
Dim pdf As New VNSPDFDocument()
pdf.Title = "Mixed API Example"

// Use Graphics for simple drawing
Dim g As VNSPDFGraphics = pdf.Graphics
g.DrawingColor = Color.Blue
g.FillRectangle(100, 100, 200, 50)

// Use FPDF methods for advanced features
pdf.SetFont("Helvetica", "", 12)
pdf.MultiCell(180, 5, longText, "1", "L", False)  // Word-wrapped text

pdf.Save(file)
```

---

*Last Updated: 2026-01-26*
