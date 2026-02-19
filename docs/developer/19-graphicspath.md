# 19. VNSPDFGraphicsPath - Full GraphicsPath API

**Last Updated:** 2026-02-09

This chapter documents the expanded `VNSPDFGraphicsPath` class, which provides full compatibility with Xojo's native `GraphicsPath` API for PDF rendering, including cubic/quadratic Bezier curves, arcs, rounded rectangles, hit testing, and bounding box queries.

---

## Overview

`VNSPDFGraphicsPath` is a segment-based path builder that generates native PDF drawing commands. It replaces the original flat `Point` array storage with typed `VNSPDFPathSegment` objects, enabling accurate rendering of curves, arcs, and complex shapes directly in the PDF stream.

**Location**: `PDF_Library/Core/VNSPDFGraphicsPath.xojo_code`

### Architecture

```
VNSPDFGraphicsPath
  |-- mSegments() As VNSPDFPathSegment    (typed segment storage)
  |-- mCurrentPoint As Point              (current drawing position)
  |-- mStartPoint As Point                (subpath start for CloseSubpath)
  |-- mMinX/mMinY/mMaxX/mMaxY            (bounding box tracking)
  |
  |-- ToPDFCommands(doc) As String        (PDF command generation)
  |-- FlattenToPoints() As Point()        (backward-compatible sampling)
```

### Key Design Decisions

1. **Segment-based storage** instead of flat points: enables exact curve representation in PDF output.
2. **PDF command generation on VNSPDFGraphicsPath** (`ToPDFCommands`), not on VNSPDFGraphics: keeps VNSPDFGraphics under the 100KB file limit.
3. **Backward compatibility**: `GetPoints()` still works by sampling curves into ~10 points each.
4. **Coordinate convention**: All path coordinates are in **points** (1/72 inch), matching Xojo's `GraphicsPath` and `PDFGraphics` convention. Conversion to PDF coordinates (mm, Y-flip) happens inside `ToPDFCommands`.

---

## Supporting Classes

### VNSPDFPathSegment

**Location**: `PDF_Library/Core/VNSPDFPathSegment.xojo_code`

A lightweight data class representing a single path segment.

| Property | Type | Description |
|----------|------|-------------|
| `mSegmentType` | `VNSPDFModule.ePathSegmentType` | Segment type |
| `mX` | Double | End point X coordinate |
| `mY` | Double | End point Y coordinate |
| `mCp1X` | Double | First control point X (cubic/quadratic Bezier) |
| `mCp1Y` | Double | First control point Y (cubic/quadratic Bezier) |
| `mCp2X` | Double | Second control point X (cubic Bezier) or width (rectangle) |
| `mCp2Y` | Double | Second control point Y (cubic Bezier) or height (rectangle) |

**Constructor**:
```xojo
Sub Constructor(segType As VNSPDFModule.ePathSegmentType, _
    x As Double = 0, y As Double = 0, _
    cp1x As Double = 0, cp1y As Double = 0, _
    cp2x As Double = 0, cp2y As Double = 0)
```

### ePathSegmentType Enum

**Location**: `VNSPDFModule`

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

---

## VNSPDFGraphicsPath API Reference

### Construction

```xojo
Dim path As New VNSPDFGraphicsPath
```

Creates an empty path with the current point at (0, 0).

### Basic Path Operations

#### MoveToPoint

```xojo
Sub MoveToPoint(x As Double, y As Double)
```

Moves the current point without drawing. Starts a new subpath. All coordinates are in points.

#### AddLineToPoint

```xojo
Sub AddLineToPoint(x As Double, y As Double)
```

Adds a straight line from the current point to (x, y).

#### CloseSubpath

```xojo
Sub CloseSubpath()
```

Closes the current subpath by adding a straight line back to the subpath's start point (the last `MoveToPoint` position). Resets the current point to the subpath start.

**Example**:
```xojo
Dim path As New VNSPDFGraphicsPath
path.MoveToPoint(100, 100)
path.AddLineToPoint(200, 100)
path.AddLineToPoint(150, 50)
path.CloseSubpath()  // Closes triangle back to (100, 100)
```

### Rectangles

#### AddRectangle

```xojo
Sub AddRectangle(x As Double, y As Double, w As Double, h As Double)
Sub AddRectangle(r As Rect)
```

Adds an axis-aligned rectangle. Uses the PDF `re` operator for efficient output (single command instead of 4 lines + close).

**Parameters**:
- `x, y` - Top-left corner (in points)
- `w, h` - Width and height (in points)
- `r` - A Xojo `Rect` object (overload)

**Example**:
```xojo
Dim path As New VNSPDFGraphicsPath
path.AddRectangle(72, 100, 200, 150)

// Or from a Rect object:
Dim r As New Rect(72, 100, 200, 150)
path.AddRectangle(r)
```

#### AddRoundRectangle

```xojo
Sub AddRoundRectangle(x As Double, y As Double, w As Double, h As Double, cornerW As Double, cornerH As Double)
Sub AddRoundRectangle(r As Rect, cornerW As Double, cornerH As Double)
```

Adds a rounded rectangle with elliptical corner arcs.

**Parameters**:
- `x, y` - Top-left corner (in points)
- `w, h` - Width and height (in points)
- `cornerW` - Horizontal corner radius (clamped to `w/2`)
- `cornerH` - Vertical corner radius (clamped to `h/2`)

Corner radii are automatically clamped to prevent overlap. When `cornerW = w/2` and `cornerH = h/2`, the result is a stadium/pill shape.

**Implementation**: Constructed from 4 line segments and 4 quarter-arc Bezier curves using the private `AddArcCorner` helper.

**Example**:
```xojo
Dim path As New VNSPDFGraphicsPath
// Symmetric corners
path.AddRoundRectangle(72, 100, 200, 80, 15, 15)

// Asymmetric corners (wide horizontal, narrow vertical)
path.AddRoundRectangle(72, 200, 200, 80, 30, 10)
```

### Curves

#### AddCurveToPoint (Cubic Bezier)

```xojo
Sub AddCurveToPoint(cp1x As Double, cp1y As Double, cp2x As Double, cp2y As Double, x As Double, y As Double)
```

Adds a cubic Bezier curve from the current point to (x, y) using two control points. Maps directly to the PDF `c` operator.

**Parameters**:
- `cp1x, cp1y` - First control point
- `cp2x, cp2y` - Second control point
- `x, y` - End point

**Example**:
```xojo
Dim path As New VNSPDFGraphicsPath
path.MoveToPoint(72, 200)
path.AddCurveToPoint(72, 100, 300, 100, 300, 200)  // Arch shape
```

#### AddQuadraticCurveToPoint

```xojo
Sub AddQuadraticCurveToPoint(cpX As Double, cpY As Double, x As Double, y As Double)
```

Adds a quadratic Bezier curve from the current point to (x, y) using one control point. Stored natively as a quadratic segment, then converted to cubic in `ToPDFCommands` using the standard conversion:

```
cubic_cp1 = start + 2/3 * (quad_cp - start)
cubic_cp2 = end   + 2/3 * (quad_cp - end)
```

**Parameters**:
- `cpX, cpY` - Control point
- `x, y` - End point

**Example**:
```xojo
Dim path As New VNSPDFGraphicsPath
path.MoveToPoint(72, 300)
path.AddQuadraticCurveToPoint(200, 200, 350, 300)
```

#### AddArc

```xojo
Sub AddArc(x As Double, y As Double, radius As Double, startRadian As Double, endRadian As Double, counterClockwise As Boolean = False)
```

Adds a circular arc centered at (x, y). If the path is non-empty, an implicit line is drawn from the current point to the arc's start. If the path is empty, a `MoveToPoint` is used instead.

**Parameters**:
- `x, y` - Arc center
- `radius` - Arc radius (in points)
- `startRadian` - Start angle in radians (0 = right/3 o'clock)
- `endRadian` - End angle in radians
- `counterClockwise` - Sweep direction (default: clockwise)

**Implementation**: The arc is split into segments of max 60 degrees, each approximated by a cubic Bezier curve using the formula `alpha = 4/3 * tan(halfAngle / 2)`. This matches the approach used in `VNSPDFDocument.Ellipse` (kappa = 0.5522847498 for 90-degree arcs).

**Example**:
```xojo
Const kPi As Double = 3.14159265358979
Const kTwoPi As Double = 6.28318530717959

// Full circle
Dim circle As New VNSPDFGraphicsPath
circle.AddArc(200, 200, 50, 0, kTwoPi)

// Half circle
Dim half As New VNSPDFGraphicsPath
half.AddArc(200, 200, 50, 0, kPi)

// Pac-Man shape
Dim pacman As New VNSPDFGraphicsPath
Dim mouthAngle As Double = kPi / 6
pacman.MoveToPoint(200, 200)  // Center
pacman.AddLineToPoint(200 + 50 * Cos(mouthAngle), 200 + 50 * Sin(mouthAngle))
pacman.AddArc(200, 200, 50, mouthAngle, kTwoPi - mouthAngle)
pacman.CloseSubpath()
```

### Query Methods

#### IsEmpty

```xojo
Function IsEmpty() As Boolean
```

Returns `True` if the path has no segments.

#### IsRectangle

```xojo
Function IsRectangle() As Boolean
```

Returns `True` if the path consists of exactly one `Rectangle` segment (added via `AddRectangle`).

#### Handle

```xojo
Function Handle() As Ptr
```

Returns `Nil`. Provided for compatibility with Xojo's `GraphicsPath.Handle` property.

#### Bounds

```xojo
Function Bounds() As Rect
```

Returns the bounding rectangle of the path. Bounds are tracked incrementally as segments are added, including control points for curves. Returns `Rect(0, 0, 0, 0)` for empty paths.

**Note**: For Bezier curves, the bounding box includes control points, which may overestimate the actual tight bounds.

#### Contains (Hit Testing)

```xojo
Function Contains(x As Double, y As Double) As Boolean
Function Contains(pt As Point) As Boolean
```

Returns `True` if the specified point is inside the path using the **even-odd (ray casting) rule**. The path is first flattened to line segments (curves are sampled), then a ray-casting algorithm counts edge crossings.

**Example**:
```xojo
Dim circle As New VNSPDFGraphicsPath
circle.AddArc(200, 200, 50, 0, 6.28318530717959)

Dim insideCenter As Boolean = circle.Contains(200, 200)    // True
Dim outsideFar As Boolean = circle.Contains(100, 100)      // False
```

### Segment Access

#### GetSegments

```xojo
Function GetSegments() As VNSPDFPathSegment()
```

Returns the raw segment array. Use this for programmatic inspection of path contents.

#### GetPoints (Backward Compatible)

```xojo
Function GetPoints() As Point()
```

Returns a flattened array of `Point` objects for backward compatibility. Curves are sampled into approximately 10 points each. Rectangles are expanded to 5 points (4 corners + closing point).

This method preserves the original API contract so existing code that uses `GetPoints()` continues to work.

#### CurrentPoint

```xojo
Property CurrentPoint As Point  // Read-only
```

Returns the current drawing position.

### PDF Command Generation

#### ToPDFCommands

```xojo
Function ToPDFCommands(doc As VNSPDFDocument) As String
```

Generates PDF path construction commands for all segments. This is the core method that converts the high-level path representation into PDF stream content.

**Coordinate conversion**: Path coordinates (in points) are converted through:
1. Points to millimeters: `value * gkPointsToMM`
2. Millimeters to scaled units: `value * doc.GetConversionRatio()`
3. Y-axis flip: `(pageHeight - y_mm) * scaleFactor`

**PDF operators generated**:

| Segment Type | PDF Operator | Example |
|-------------|-------------|---------|
| MoveTo | `m` | `100.00 700.00 m` |
| LineTo | `l` | `200.00 700.00 l` |
| CubicBezierTo | `c` | `cp1x cp1y cp2x cp2y x y c` |
| QuadraticBezierTo | `c` | Converted to cubic, then `c` |
| CloseSubpath | `h` | `h` |
| Rectangle | `re` | `x y w h re` |

**Note**: Quadratic Bezier curves are automatically promoted to cubic using the standard 2/3 control point conversion formula.

---

## VNSPDFDocument Methods

Two methods were added to `VNSPDFDocument` to support path rendering:

### RenderPath

```xojo
Sub RenderPath(pathCommands As String, style As String = "D")
```

Appends pre-built path commands to the page buffer and applies the specified drawing operation.

**Parameters**:
- `pathCommands` - PDF path operators (output from `ToPDFCommands`)
- `style` - Drawing style: `"D"` (stroke), `"F"` (fill), `"DF"`/`"FD"` (fill and stroke)

**PDF operators applied**:
- `"D"` -> `S` (stroke)
- `"F"` -> `f` (fill, non-zero winding)
- `"DF"` -> `B` (fill and stroke)

### ClipPath

```xojo
Sub ClipPath(pathCommands As String, outline As Boolean)
```

Clips subsequent drawing operations to the specified path. Wraps the path in a `q`/`Q` (save/restore graphics state) pair and applies the `W` (clip) operator.

**Parameters**:
- `pathCommands` - PDF path operators (output from `ToPDFCommands`)
- `outline` - If `True`, also strokes the clipping path outline (`S`); if `False`, uses `n` (no-op painting)

Call `ClipEnd()` to restore the previous clipping state.

---

## VNSPDFGraphics Integration

The following `VNSPDFGraphics` methods now use `ToPDFCommands` for accurate rendering of curves and complex paths:

### DrawPath

```xojo
Sub DrawPath(path As VNSPDFGraphicsPath, autoClose As Boolean = False)
```

Strokes the path outline. If `autoClose` is `True`, appends the `h` (close) operator before stroking.

### FillPath

```xojo
Sub FillPath(path As VNSPDFGraphicsPath, autoClose As Boolean = False)
```

Fills the path interior. If `autoClose` is `True`, appends the `h` (close) operator before filling.

### ClipToPath

```xojo
Sub ClipToPath(path As VNSPDFGraphicsPath)
```

Clips subsequent drawing to the path. Call `ClipEnd()` to restore. Now supports curves and complex shapes (previously limited to polygon clipping).

---

## Usage Examples

### Basic Shapes

```xojo
Dim pdf As New VNSPDFDocument()
Dim g As VNSPDFGraphics = pdf.Graphics

// Rectangle
Dim rect As New VNSPDFGraphicsPath
rect.AddRectangle(72, 100, 200, 80)
g.DrawingColor = &c0000CC
g.DrawPath(rect)

// Rounded rectangle
Dim rr As New VNSPDFGraphicsPath
rr.AddRoundRectangle(72, 200, 200, 80, 15, 15)
g.DrawingColor = &cCCDDFF
g.FillPath(rr)

// Triangle with close
Dim tri As New VNSPDFGraphicsPath
tri.MoveToPoint(172, 320)
tri.AddLineToPoint(72, 400)
tri.AddLineToPoint(272, 400)
tri.CloseSubpath()
g.DrawingColor = &cCC0000
g.DrawPath(tri)
```

### Curves

```xojo
// Cubic Bezier arch
Dim arch As New VNSPDFGraphicsPath
arch.MoveToPoint(72, 200)
arch.AddCurveToPoint(72, 100, 300, 100, 300, 200)
g.DrawingColor = &c0000FF
g.DrawPath(arch)

// S-curve from two cubics
Dim sCurve As New VNSPDFGraphicsPath
sCurve.MoveToPoint(72, 400)
sCurve.AddCurveToPoint(150, 340, 200, 340, 250, 400)
sCurve.AddCurveToPoint(300, 460, 350, 460, 430, 400)
g.DrawPath(sCurve)
```

### Arcs and Circles

```xojo
Const kPi As Double = 3.14159265358979
Const kTwoPi As Double = 6.28318530717959

// Full circle
Dim circle As New VNSPDFGraphicsPath
circle.AddArc(200, 200, 50, 0, kTwoPi)
g.DrawingColor = &c009900
g.DrawPath(circle)

// Pac-Man
Dim pacman As New VNSPDFGraphicsPath
Dim mouth As Double = kPi / 6
pacman.MoveToPoint(200, 400)
pacman.AddLineToPoint(200 + 50 * Cos(mouth), 400 + 50 * Sin(mouth))
pacman.AddArc(200, 400, 50, mouth, kTwoPi - mouth)
pacman.CloseSubpath()
g.DrawingColor = &cFFCC00
g.FillPath(pacman)
```

### Clipping

```xojo
// Clip text to a rounded rectangle
Dim clipPath As New VNSPDFGraphicsPath
clipPath.AddRoundRectangle(72, 100, 300, 120, 20, 20)

g.ClipToPath(clipPath)
g.FontSize = 14
For i As Integer = 1 To 10
    g.DrawText("This text is clipped to the rounded rectangle", 75, 110 + i * 16)
Next
g.ClipEnd()
```

### Hit Testing

```xojo
Dim shape As New VNSPDFGraphicsPath
shape.AddArc(200, 200, 60, 0, 6.28318530717959)

If shape.Contains(200, 200) Then
    // Point is inside the circle
End If

If shape.Contains(New Point(300, 300)) Then
    // Point is outside the circle
End If

// Get bounding box
Dim bounds As Rect = shape.Bounds
```

---

## Xojo GraphicsPath Compatibility

The following table compares `VNSPDFGraphicsPath` with Xojo's native `GraphicsPath`:

| Feature | Xojo GraphicsPath | VNSPDFGraphicsPath |
|---------|-------------------|---------------------|
| MoveToPoint | Yes | Yes |
| AddLineToPoint | Yes | Yes |
| AddCurveToPoint (cubic) | Yes | Yes |
| AddQuadraticCurveToPoint | Yes | Yes |
| AddArc | Yes | Yes |
| AddRectangle | Yes | Yes (2 overloads) |
| AddRoundRectangle | Yes | Yes (2 overloads) |
| CloseSubpath | Yes | Yes |
| IsEmpty | Yes | Yes |
| IsRectangle | Yes | Yes |
| Bounds | Yes | Yes |
| Contains | Yes | Yes (even-odd rule) |
| Handle | Returns Ptr | Returns Nil |
| CurrentPoint | Yes | Yes |

**Not implemented** (not applicable for PDF):
- `AddEllipse` - Use `AddArc(x, y, radius, 0, 2*Pi)` instead, or build with `AddRoundRectangle` for ellipses.

---

## Internal Implementation Details

### Arc Approximation

Arcs are approximated using cubic Bezier curves. The algorithm:

1. Normalize start/end angles based on sweep direction.
2. Split the total angle into segments of max 60 degrees.
3. For each segment, compute cubic Bezier control points using:
   ```
   alpha = 4/3 * tan(halfAngle / 2)
   cp1 = center + radius * (cos(start) - alpha * sin(start), sin(start) + alpha * cos(start))
   cp2 = center + radius * (cos(end) + alpha * sin(end), sin(end) - alpha * cos(end))
   ```

This is the same approach used by `VNSPDFDocument.Ellipse` (kappa = 0.5522847498 for 90-degree arcs) and produces visually identical results.

### Rounded Rectangle Construction

`AddRoundRectangle` is constructed from 8 segments:
1. `MoveToPoint` to top edge start (after top-left corner)
2. `AddLineToPoint` along top edge
3. `AddArcCorner` for top-right corner (90-degree elliptical arc)
4. `AddLineToPoint` along right edge
5. `AddArcCorner` for bottom-right corner
6. `AddLineToPoint` along bottom edge
7. `AddArcCorner` for bottom-left corner
8. `AddLineToPoint` along left edge + `AddArcCorner` for top-left corner + `CloseSubpath`

The private `AddArcCorner` helper computes a single cubic Bezier curve for each elliptical quarter-arc.

### Flattening (Curve Sampling)

`FlattenToPoints()` converts all segments to a `Point` array:
- **MoveTo/LineTo**: Added directly
- **CubicBezierTo**: Sampled at 10 evenly-spaced `t` values using De Casteljau's formula
- **QuadraticBezierTo**: Sampled at 10 evenly-spaced `t` values
- **CloseSubpath**: Adds the first point again
- **Rectangle**: Expanded to 5 points (4 corners + closing point)

This is used by `GetPoints()` (backward compatibility) and `Contains()` (hit testing).

---

## Example 29

Example 29 in `VNSPDFExamplesModule` demonstrates all features across 6 pages:

| Page | Content |
|------|---------|
| 1 | Basic shapes: rectangles, triangles, pentagons, round rectangles, IsEmpty/IsRectangle/Bounds queries |
| 2 | Curves: cubic Bezier, quadratic Bezier, S-curves, filled curve shapes |
| 3 | Arcs: full circle, half circle, quarter arc, counterclockwise, Pac-Man |
| 4 | Round rectangles gallery: various radii, asymmetric corners, colors, Rect overload |
| 5 | Complex paths: star polygon, Bounds visualization, round-rect clipping, Contains hit testing, combined curve+line paths |
| 6 | Backward compatibility: old MoveToPoint/AddLineToPoint API, autoClose, GetPoints flattening, GetSegments, Handle |

**Output**: `pdf_examples/example29_graphicspath.pdf`

```xojo
Dim result As Dictionary = VNSPDFExamplesModule.GenerateExample29()
If result.Value("pdf") <> Nil Then
    // Save the PDF
End If
```

---

## Platform Notes

- **All platforms** (Desktop, Web, iOS, Console): Fully supported. The path implementation is pure math with no platform-specific APIs.
- **iOS string indexing**: No impact. Path operations use `Double` coordinates, not string operations.
- **Performance**: `ToPDFCommands` generates the PDF stream in a single pass. Complex paths with many segments (100+) should still be fast since it is only string concatenation.
