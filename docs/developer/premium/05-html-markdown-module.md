# HTML & Markdown Import Module (Premium)

**Status**: Available
**Price**: Part of Premium Bundle
**Flag**: `VNSPDFModule.hasPremiumHTMLModule`

---

## Activation

### Step 1: Add the Module Files to Your Project

In the Xojo IDE, create a `Premium` folder inside the `PDF_Library` folder of your project (if it does not already exist), then create an `HTMLMarkdownModule` subfolder inside it. Drag the following files into that folder:

- `VNSPDFHTMLPremium.xojo_code`
- `VNSPDFHTMLRenderer.xojo_code`
- `VNSPDFHTMLTableRenderer.xojo_code`
- `VNSPDFHTMLToken.xojo_code`

### Step 2: Enable the Module Flag

Open `PDF_Library/VNSPDFModule.xojo_code` and set the following constant to `True`:

```xojo
VNSPDFModule.hasPremiumHTMLModule = True
```

This constant is set to `False` by default. The library checks this flag at runtime to determine whether HTML and Markdown import features (`LoadHTML()`, `LoadMarkdown()`) are available. If the flag is `False`, these methods will return an error message indicating the premium module is required.

---

## Overview

The HTML & Markdown Import Module adds `LoadHTML()` and `LoadMarkdown()` methods to VNSPDFDocument, converting HTML or Markdown content directly to PDF using existing FPDF rendering methods. Includes robust Word/Summernote HTML cleaning to handle real-world messy HTML input.

---

## File Structure

```
PDF_Library/Premium/HTMLMarkdownModule/
├── VNSPDFHTMLPremium.xojo_code        # Main module: LoadHTML(), LoadMarkdown(), HTML cleaning, Markdown parser
├── VNSPDFHTMLRenderer.xojo_code       # HTML tokenizer + rendering engine
├── VNSPDFHTMLTableRenderer.xojo_code  # Table/image rendering + CSS parsing helpers
└── VNSPDFHTMLToken.xojo_code          # Token class: type, tag, attributes, content
```

## Architecture

The module uses a **two-phase processing pipeline**:

1. **Phase 1 - Cleaning**: `SmartCleanHTML()` aggressively strips Word/Summernote artifacts (can reduce 578KB to 182KB = 68% reduction)
2. **Phase 2 - Parse & Render**: `ParseAndRenderHTML()` tokenizes cleaned HTML and renders to PDF

For Markdown: `MarkdownToHTML()` converts Markdown to HTML first, then follows the same pipeline.

---

## Class / Module Design

### VNSPDFHTMLPremium (Protected Module)

**Public entry points (called from VNSPDFDocument delegation):**

```xojo
Sub LoadHTML(doc As VNSPDFDocument, html As String, maxWidth As Double = 0)
Sub LoadMarkdown(doc As VNSPDFDocument, markdown As String, maxWidth As Double = 0)
```

**HTML Cleaning Pipeline** (`SmartCleanHTML`):

```xojo
Protected Function SmartCleanHTML(html As String) As String
// Pipeline steps in order:
//   1. ExtractImagesFromBinaryParagraphs - save img tags before removal
//   2. RemoveBinaryDataParagraphs - strip Word docData base64 blocks
//   3. PrependImages - re-insert extracted images
//   4. RemoveHTMLComments - strip <!-- CSS blocks --> from Word
//   5. StripMSOStyleProperties - remove mso-* CSS properties
//   6. StripWordCSSClasses - remove MsoNormal, MsoPapDefault, etc.
//   7. CleanStrayBRTags - normalize <br> variants
//   8. DecodeHTMLEntities - decode &nbsp; &lt; &gt; &amp; and numeric entities
//   9. NormalizeWhitespace - collapse multiple spaces/newlines
```

**Markdown Parser:**

```xojo
Protected Function MarkdownToHTML(markdown As String) As String
// Converts Markdown to HTML supporting:
//   # Heading 1 through ###### Heading 6
//   **bold**, *italic*, ~~strikethrough~~
//   `inline code` and ``` fenced code blocks ```
//   - unordered lists, 1. ordered lists
//   [link text](url)
//   ![alt text](image path or base64)
//   > blockquotes
//   --- horizontal rules
//   | col1 | col2 | tables with |---|---| separator
```

### VNSPDFHTMLRenderer (Protected Module)

**Main rendering engine:**

```xojo
Sub ParseAndRenderHTML(doc As VNSPDFDocument, html As String, maxWidth As Double = 0)
// Tokenizes HTML then iterates tokens rendering to PDF
// Handles: p, h1-h6, b/strong, i/em, u, s/del/strike, br, hr, img, table,
//          ul/ol/li, blockquote, code/pre, span, font, a, sub, sup
// Supports text-align: left, center, right, justify on <p>/<div>
// Simulated bold/italic for UTF-8 fonts without B/I variants
```

**HTML Tokenizer:**

```xojo
Function TokenizeHTML(html As String) As VNSPDFHTMLToken()
// Splits HTML into token sequence: open, close, text, self-closing
Sub ParseTagAndAttributes(tagContent As String, token As VNSPDFHTMLToken)
// Parses tag name and attribute key-value pairs
```

**Inline style support:**

```xojo
Protected Sub ApplyInlineStyle(doc As VNSPDFDocument, token As VNSPDFHTMLToken)
// Extracts and applies font-size, color, background-color, text-decoration from style attribute
```

### VNSPDFHTMLTableRenderer (Protected Module)

**Table rendering:**

```xojo
Protected Function ParseTable(tokens() As VNSPDFHTMLToken, ByRef idx As Integer) As Dictionary()
// Parses <table> tokens into row/cell data structure
// Each row: Dictionary with "cells" (Dictionary array) and "isHeader" (Boolean)
// Each cell: Dictionary with "content", "isHeader", "align"

Protected Sub RenderTable(doc As VNSPDFDocument, rows() As Dictionary, lineHeight As Double)
// Renders parsed table with equal-width columns, borders, gray header fill
```

**Image rendering:**

```xojo
Protected Sub RenderImage(doc As VNSPDFDocument, token As VNSPDFHTMLToken, maxWidth As Double, lineHeight As Double)
// Handles base64 data: URIs via Picture.FromData() + ImageFromPicture()
// Uses native Xojo image decoding for reliable cross-platform rendering
// Respects width/height attributes; defaults to actual pixel size at 96 DPI
```

**CSS helpers:**

```xojo
Protected Function ParseCSSColor(colorStr As String) As Color
// Handles: #RRGGBB, #RGB, rgb(r,g,b), named colors (50+ color names)

Protected Function ParseStyleAttribute(styleStr As String) As Dictionary
// Parses CSS style string into key-value Dictionary

Protected Function MapCSSFontFamily(cssFontFamily As String) As String
// Maps CSS font names to PDF core fonts (Arial->Helvetica, etc.)

Protected Function ParseCSSFontSize(sizeStr As String, currentSize As Double) As Double
// Parses pt, px, em, %, and named sizes (small, medium, large, etc.)

Protected Function ParseHTMLFontSize(sizeLevel As Integer, currentSize As Double) As Double
// Converts HTML <font size="1-7"> to point sizes
```

### VNSPDFHTMLToken (Class)

```xojo
Class VNSPDFHTMLToken
  Property TokenType As String    // "open", "close", "text", "self-closing" (read-only computed)
  Property Tag As String          // "p", "b", "img", "table", "h1", etc.
  Property TagAttributes As Dictionary  // src, style, class, href, etc.
  Property Content As String      // Text content for text nodes
End Class
```

---

## Integration with Free Library

### VNSPDFDocument delegation (in free library)

```xojo
Sub LoadHTML(html As String, maxWidth As Double = 0)
  #If VNSPDFModule.hasPremiumHTMLModule Then
    VNSPDFHTMLPremium.LoadHTML(Self, html, maxWidth)
  #Else
    SetError("LoadHTML requires the premium HTML/Markdown Import module.")
  #EndIf
End Sub

Sub LoadMarkdown(markdown As String, maxWidth As Double = 0)
  #If VNSPDFModule.hasPremiumHTMLModule Then
    VNSPDFHTMLPremium.LoadMarkdown(Self, markdown, maxWidth)
  #Else
    SetError("LoadMarkdown requires the premium HTML/Markdown Import module.")
  #EndIf
End Sub
```

### VNSPDFModule constant

```xojo
Public Const hasPremiumHTMLModule As Boolean = False  // Set to True when module installed
```

---

## Supported HTML Tags

| Tag | Rendering |
|-----|-----------|
| `<p>` | Block with `text-align` support: left, center, right, justify |
| `<h1>` - `<h6>` | `SetFont()` with scaled size + bold + `MultiCell()` |
| `<b>`, `<strong>` | `SetFont(family, "B", size)` |
| `<i>`, `<em>` | `SetFont(family, "I", size)` |
| `<u>` | `SetFont(family, "U", size)` |
| `<s>`, `<del>`, `<strike>` | Strikethrough via `SetFont(family, "S", size)` |
| `<span>` | Inline formatting via style attribute |
| `<font>` | Legacy font size/color/face support |
| `<br>` | Line break via `Ln()` |
| `<hr>` | `Line()` across page width |
| `<img>` | JPEG conversion via `Picture.FromData()` + `RegisterImageFromBytes()` (handles RGBA PNGs) |
| `<table>`, `<tr>`, `<td>`, `<th>` | Equal-width columns via `Cell()`, header row with gray fill, cell text-align from `<td>` or inner `<p>` |
| `<ul>`, `<ol>`, `<li>` | Bullet/number prefix + `Cell()` |
| `<blockquote>` | Gray left border bar, indented italic gray text |
| `<code>`, `<pre>` | Monospace font (Courier) |
| `<a href>` | Rendered text (link styling) |
| `<sub>`, `<sup>` | Subscript/superscript via PDF text rise (`Ts` operator) |

## Supported Markdown Syntax

| Syntax | HTML Output |
|--------|-------------|
| `# Heading` through `######` | `<h1>` - `<h6>` |
| `**bold**` | `<b>` |
| `*italic*` | `<i>` |
| `~~strikethrough~~` | `<s>` |
| `` `code` `` | `<code>` |
| ```` ``` code block ``` ```` | `<pre><code>` |
| `- item` | `<ul><li>` |
| `1. item` | `<ol><li>` |
| `[text](url)` | `<a href>` |
| `![alt](src)` | `<img>` |
| `> quote` | `<blockquote>` |
| `---` | `<hr>` |
| `\| col \| col \|` | `<table>` |

---

## Font Mapping

| CSS Font | PDF Font |
|----------|----------|
| Helvetica, sans-serif | Helvetica (core PDF font) |
| Times, serif | Times (core PDF font) |
| Courier, monospace | Courier (core PDF font) |
| Arial, Verdana, Georgia, Trebuchet MS, Palatino, etc. | Auto-loaded from system TrueType fonts |
| Any font not found on system | Falls back to nearest core font (sans-serif→Helvetica, serif→Times, monospace→Courier) |
| Custom TrueType | Used directly if pre-loaded via `AddUTF8Font` |

---

## Usage Examples

### HTML Import (Example 27)
```xojo
Var pdf As New VNSPDFDocument
pdf.SetFont("Helvetica", "", 10)

// Load from file - auto-cleans Word/Summernote HTML
Var htmlContent As String = myFolderItem.Read
pdf.LoadHTML(htmlContent)

pdf.Save(outputFile)
```

### Markdown Import (Example 28)
```xojo
Var pdf As New VNSPDFDocument
pdf.SetFont("Helvetica", "", 10)

Var md As String = "# Report" + EndOfLine + _
  "This is **bold** and *italic*." + EndOfLine + _
  "" + EndOfLine + _
  "| Column A | Column B |" + EndOfLine + _
  "|----------|----------|" + EndOfLine + _
  "| Value 1  | Value 2  |"

pdf.LoadMarkdown(md)
pdf.Save(outputFile)
```

---

## Word/Summernote HTML Cleaning

The `SmartCleanHTML` pipeline handles real-world messy HTML from Microsoft Word and Summernote editors:

| Step | What | Impact |
|------|------|--------|
| Extract Images | Save `<img>` tags from binary paragraphs before removal | Preserves embedded images |
| Remove Binary Data | Strip `<p class="docData;...">` base64 blocks | 66% of file size (biggest impact) |
| Prepend Images | Re-insert extracted images at document start | Images available for rendering |
| Remove Comments | Strip `<!-- CSS blocks -->` from Word | 11 KB typical |
| Strip MSO Styles | Remove `mso-*` CSS properties from inline styles | Cleaner CSS |
| Strip Word Classes | Remove `MsoNormal`, `MsoPapDefault`, etc. | Cleaner HTML |
| Clean BR Tags | Normalize `<br>` variants | Consistent line breaks |
| Decode Entities | Convert `&nbsp;`, `&lt;`, `&gt;`, `&amp;`, numeric entities | Proper text |
| Normalize Whitespace | Collapse multiple spaces/newlines | 5 KB typical |

---

## Custom Tag Handlers (HTML)

Register custom delegates to intercept any HTML tag during rendering. Custom handlers are checked **before** built-in tag logic, so you can override built-in tags or handle entirely custom tags.

### API

```xojo
// Register a handler for a tag name (case-insensitive)
pdf.RegisterHTMLTagHandler(tagName As String, handler As VNSPDFModule.HTMLTagHandlerDelegate)

// Remove a specific handler
pdf.RemoveHTMLTagHandler(tagName As String)

// Remove all handlers
pdf.RemoveAllHTMLTagHandlers()

// Check if a handler exists (used internally)
pdf.HasHTMLTagHandler(tagName As String) As Boolean

// Get the handler delegate (used internally)
pdf.GetHTMLTagHandler(tagName As String) As VNSPDFModule.HTMLTagHandlerDelegate
```

### Handler Delegate Signature

```xojo
Delegate Sub HTMLTagHandlerDelegate(doc As VNSPDFDocument, token As VNSPDFHTMLToken, isClosing As Boolean)
```

- `doc`: The document being rendered into
- `token`: The HTML token with `.Tag`, `.TagAttributes`, `.Content`
- `isClosing`: `True` for closing tags (`</tag>`), `False` for opening/self-closing tags

### Example: Custom HTML Tag

```xojo
// Register before calling LoadHTML
pdf.RegisterHTMLTagHandler("company-header", AddressOf CompanyHeaderHandler)
pdf.LoadHTML("<company-header>ACME Corp</company-header><p>Hello world</p>")

Sub CompanyHeaderHandler(doc As VNSPDFDocument, token As VNSPDFHTMLToken, isClosing As Boolean)
  If Not isClosing Then
    doc.SetFont("Helvetica", "B", 20)
    doc.SetTextColor(Color.RGB(0, 0, 128))
  Else
    doc.Ln(8)
    doc.SetFont("Helvetica", "", 10)
    doc.SetTextColor(Color.RGB(0, 0, 0))
  End If
End Sub
```

### Example: Override a Built-in Tag

```xojo
// Override <h1> to use a custom font and color
pdf.RegisterHTMLTagHandler("h1", AddressOf CustomH1Handler)
```

---

## Custom Line Handlers (Markdown)

Register custom delegates to intercept Markdown lines that match a given prefix. Custom handlers are checked **before** built-in Markdown patterns (headings, lists, etc.), so custom syntax takes priority.

### API

```xojo
// Register a handler for a line prefix
pdf.RegisterMarkdownHandler(prefix As String, handler As VNSPDFModule.MarkdownLineHandlerDelegate)

// Remove a specific handler
pdf.RemoveMarkdownHandler(prefix As String)

// Remove all handlers
pdf.RemoveAllMarkdownHandlers()
```

### Handler Delegate Signature

```xojo
Delegate Function MarkdownLineHandlerDelegate(doc As VNSPDFDocument, line As String) As String
```

- `doc`: The document (for accessing document state or custom properties)
- `line`: The full trimmed Markdown line
- **Returns**: HTML string to insert, or `""` to skip the line

### Example: Warning Blocks

```xojo
pdf.RegisterMarkdownHandler(":::warning", AddressOf WarningBlockHandler)
pdf.LoadMarkdown("# Report" + Chr(10) + ":::warning This needs review")

Function WarningBlockHandler(doc As VNSPDFDocument, line As String) As String
  Var text As String = line.Middle(11)  // skip ":::warning "
  Return "<p><b>WARNING:</b> " + text + "</p>"
End Function
```

### Example: Variable Substitution

```xojo
pdf.RegisterMarkdownHandler("{{var:", AddressOf VariableHandler)
pdf.LoadMarkdown("Company: {{var:company_name}}")

Function VariableHandler(doc As VNSPDFDocument, line As String) As String
  Var varName As String = line.Middle(6, line.Length - 8)  // extract between {{var: and }}
  Select Case varName
  Case "company_name"
    Return "<b>ACME Corporation</b>"
  End Select
  Return ""
End Function
```

---

## Dependencies

- **No external dependencies** - Pure Xojo implementation
- **Required**: VNSPDFDocument (free library core)
- **Optional**: Premium Zlib Module for compressed output on iOS

---

## Known Limitations

- Table columns are equal-width (no colspan/rowspan support yet)
- Images from file paths must be accessible at render time
- CSS `margin` and `padding` properties are not fully supported
- Nested tables are not supported
- `<font>` tag support is legacy (prefer `<span style="...">`)
