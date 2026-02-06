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

### ImageFromPicture corruption on Windows/Linux
**Symptom**: Multi-colored noise instead of clean image.
**Cause**: Picture.ToData(PNG) on Windows/Linux produces RGBA (4 channels), PDF expects RGB (3 channels).
**Fix**: Force JPEG format on Windows/Linux/iOS/Web. JPEG auto-converts RGBA to RGB.

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
