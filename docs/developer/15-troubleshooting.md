# Troubleshooting

## Common Issues

### Pages not appearing in document

**Solution**: Ensure `AddPage()` is called before adding content.

---

### Unexpected dimensions

**Solution**: Check unit of measurement matches your values (Millimeters, Inches, Points, Centimeters).

---

### Errors not shown

**Solution**: Use the error checking methods:
```xojo
If pdf.Err() Then
    MessageBox pdf.GetError()
End If
// Or: If Not pdf.Ok() Then ...
```

---

## Known Bug Fixes (v1.1.1)

### MultiCell single-line bottom border
**Symptom**: Single-line MultiCell with `border=1` missing bottom border.
**Cause**: Border logic only handled multi-line cells; single-line used incomplete border.
**Fix**: Detect `lines.Count = 1` to use full border string including bottom.

### First character missing in long word wrapping
**Symptom**: When a long word wraps to next line, first character is dropped.
**Cause**: Desktop/Console/Web loop started at `i = 1` instead of `i = 0`.
**Fix**: Loop starts at 0, matching API2 0-based `.Middle()` indexing.

### Newlines ignored in MultiCell
**Symptom**: Explicit newlines (chr(10)) and CRLF ignored, all text on one line.
**Cause**: SplitTextToLines only split on spaces.
**Fix**: Strip chr(13), split by chr(10) into paragraphs, then word-wrap each.

### MultiCell positioning incorrect
**Symptom**: Cell after MultiCell offset to the right instead of left margin.
**Cause**: `ln=1` parameter moved to continuation point, not left margin.
**Fix**: Changed to `ln=2`, explicitly reset mCurrentX/mCurrentY after loop.

### ImageFromPicture corruption on ALL platforms
**Symptom**: Black rectangles or multi-colored noise instead of clean image on all platforms (macOS, Windows, Linux).
**Cause**: `New Picture(w, h)` creates RGBA pictures (4 channels) on ALL platforms including macOS. `Picture.ToData(PNG)` preserves the alpha channel, but PDF expects RGB (3 channels via DeviceRGB). The RGBA-to-RGB mismatch causes black rectangles or color artifacts.
**Fix**: Always use JPEG format on all platforms. JPEG has no alpha channel by design, so Xojo automatically converts RGBA to RGB. At QualityHigh, compression is visually lossless for programmatic graphics.

### Color object overloads always return black
**Symptom**: `SetTextColor(Color.RGB(255, 0, 0))` produces black text instead of red. `GetTextColor()` returns wrong Color values.
**Cause**: Code used API1-era `\ 256` division (Color range was 0-65535 in API1). In API2, `Color.Red/Green/Blue` returns 0-255, so `255 \ 256 = 0`. Similarly, getters used `* 256` producing wrong values.
**Fix**: Use `c.Red`, `c.Green`, `c.Blue` directly without any conversion. API2 Color is consistent across all platforms. Fixed in v1.3.

### SetDisplayMode has no effect on PDF viewer
**Symptom**: Calling `SetDisplayMode("fullwidth", "continuous")` has no visible effect when opening the PDF.
**Cause**: Prior to v1.3, `SetDisplayMode()` stored the values but never wrote `/OpenAction` or `/PageLayout` to the PDF catalog.
**Fix**: Added `PutDisplayMode()` called from `PutCatalog`. Fixed in v1.3. Contribution: Geoff Bridges.

### Font subsetter broken glyph rendering (v1.2)
**Symptom**: TrueType fonts loaded via `AddUTF8Font()` render as boxes (□) for certain fonts (e.g., Verdana, Trebuchet MS) while others work fine (Arial, Georgia).
**Cause**: Font subsetter always wrote the `loca` table in long format (4-byte entries) but preserved the original `indexToLocFormat` in the head table. Fonts with `indexToLocFormat=0` (short/2-byte loca) had a mismatch: head said short, but loca was long. PDF viewers read wrong offsets → garbled glyphs.
**Fix**: Force `indexToLocFormat=1` (long) in the subset head table since the subset loca always uses 4-byte entries.

### System font auto-load causes garbled text for core fonts
**Symptom**: Text using Helvetica, Times, or Courier in HTML/Markdown import renders as garbled characters.
**Cause**: The font resolver found system `.ttf`/`.ttc` files matching core PDF font names (e.g., `/System/Library/Fonts/Helvetica.ttc`) and loaded them as TrueType fonts instead of using the built-in core PDF fonts.
**Fix**: Core PDF font names (Helvetica, Times, Courier, Symbol, ZapfDingbats) and generic CSS families (sans-serif, serif, monospace) are now resolved directly without auto-loading. System font auto-load only applies to non-core fonts.

---

## Platform-Specific Issues

### iOS: String indexing is 0-based
iOS uses 0-based string indexing while Desktop/Web/Console use 1-based. All string operations must use conditional compilation:
```xojo
#If TargetiOS Then
  For i As Integer = 0 To txt.Length - 1
    Dim char As String = txt.Middle(i, 1)
  Next
#Else
  For i As Integer = 1 To Len(txt)
    Dim char As String = Mid(txt, i, 1)
  Next
#EndIf
```

### iOS: No system zlib compression
iOS sandboxing blocks system zlib. Without Premium Zlib module, iOS PDFs have zero compression.

### iOS: MemoryBlock.StringValue() crashes on large buffers
Use byte-by-byte extraction for large MemoryBlocks on iOS.

### iOS: Use JPEG for images, not PNG
iOS Picture.ToData(PNG) produces RGBA data. Use JPEG which auto-converts to RGB.

### macOS Preview: No attachment annotation icons
macOS Preview shows attachments in Inspector sidebar but doesn't render clickable annotation icons on pages. Use Adobe Acrobat Reader for full file attachment annotation support.

### PDF Import: Most PDFs require Premium Zlib
Real-world PDFs use FlateDecode compression with PNG predictors. The Premium Zlib module is required for importing most modern PDFs.
