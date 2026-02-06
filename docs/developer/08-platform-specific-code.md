# Platform-Specific Code

## Conditional Compilation

Use Xojo's conditional compilation for platform-specific code:

```xojo
#If TargetDesktop Then
    // Desktop-specific code
    Dim f As FolderItem = GetFolderItem("")

#ElseIf TargetWeb Then
    // Web-specific code
    Dim wf As New WebFile

#ElseIf TargetIOS Then
    // iOS-specific code
    Dim data As MemoryBlock

#ElseIf TargetConsole Then
    // Console-specific code
    Print("Generating PDF...")

#EndIf
```

## File I/O Abstraction

When implementing file operations (future), abstract platform differences:

```xojo
Function SavePDF(data As MemoryBlock, filename As String) As Boolean
    #If TargetDesktop Then
        Dim f As FolderItem = GetFolderItem(filename)
        Dim stream As BinaryStream = BinaryStream.Create(f, True)
        stream.Write(data)
        stream.Close()
        Return True

    #ElseIf TargetWeb Then
        // Return data for download
        Dim wf As New WebFile
        wf.Data = data
        wf.MIMEType = "application/pdf"
        wf.ForceDownload = True
        ShowURL(wf.URL)
        Return True

    #ElseIf TargetIOS Then
        // Save to app documents folder
        Dim docFolder As FolderItem = SpecialFolder.Documents
        Dim f As FolderItem = docFolder.Child(filename)
        Dim stream As BinaryStream = BinaryStream.Create(f, True)
        stream.Write(data)
        stream.Close()
        Return True

    #ElseIf TargetConsole Then
        // Write to current directory
        Dim f As FolderItem = GetFolderItem(filename)
        Dim stream As BinaryStream = BinaryStream.Create(f, True)
        stream.Write(data)
        stream.Close()
        Print("PDF saved to: " + filename)
        Return True

    #EndIf
End Function
```

## Platform Detection

```xojo
## iOS-Specific Considerations

### String Indexing (0-based vs 1-based)
iOS uses 0-based string indexing, all other platforms use 1-based:
```xojo
#If TargetiOS Then
  For i As Integer = 0 To txt.Length - 1
    Dim char As String = txt.Middle(i, 1)  // 0-based
  Next
#Else
  For i As Integer = 1 To Len(txt)
    Dim char As String = Mid(txt, i, 1)  // 1-based
  Next
#EndIf
```

### No Object2D Classes
Object2D and related shape classes (`RectShape`, `OvalShape`, `ArcShape`, `CurveShape`, `FigureShape`, `TextShape`, `PixmapShape`, `Group2D`) do not exist on iOS. Methods and properties that reference these types must be excluded using `CompatibilityFlags` on the `#tag Method` or `#tag Property` line:
```
#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
```
This corresponds to unchecking "iOS" and "Android" in the Xojo IDE Inspector's "Include In" checkboxes.

**Important**: `#If Not TargetiOS Then` / `#EndIf` does NOT work to wrap `#tag Method` or `#tag Property` blocks in `.xojo_code` files. Xojo still parses and compiles the code inside. `CompatibilityFlags` is the only way to exclude entire methods/properties from a platform.

In VNSPDFGraphics, the following are excluded from iOS via CompatibilityFlags:
- Methods: `DrawObject`, `DrawRectShapeObject`, `DrawRoundRectShapeObject`, `DrawOvalShapeObject`, `DrawArcShapeObject`, `DrawCurveShapeObject`, `DrawFigureShapeObject`, `DrawTextShapeObject`, `DrawPixmapShapeObject`, `DrawGroup2DObject`
- Properties: `mInsideGroupTransform`, `mInsideGroup`, `mGroupRotation`, `mGroupX`, `mGroupY`

### Graphics API Differences
- Use `g.DrawingColor` instead of `g.ForeColor` on iOS
- Use `New Picture(w, h)` without depth parameter instead of `New Picture(w, h, 32)`
- `Format()` is not available on iOS - use `Str()` or a cross-platform helper function

### No System Zlib
iOS sandboxing blocks system zlib. Use Premium Zlib module for compression on iOS.

### MemoryBlock Crashes
`MemoryBlock.StringValue()` crashes on large buffers on iOS. Use byte-by-byte extraction.

### Image Format
Use JPEG (not PNG) on iOS - `Picture.ToData(PNG)` produces RGBA which PDF doesn't support.

### File Storage
Use `SpecialFolder.Documents` not `SpecialFolder.Desktop` on iOS.

## Windows/Linux-Specific Considerations

### ImageFromPicture Corruption
`Picture.ToData(PNG)` on Windows and Linux produces RGBA (4 channels). Force JPEG format:
```xojo
#If TargetiOS Or TargetWeb Or TargetWindows Or TargetLinux Then
  imageData = pic.ToData(Picture.Formats.JPEG, Picture.QualityHigh)
#Else  // macOS only
  imageData = pic.ToData(Picture.Formats.PNG)
#EndIf
```

## Platform Detection

```xojo
Function IsDesktop() As Boolean
    #If TargetDesktop Then
        Return True
    #Else
        Return False
    #EndIf
End Function

Function IsWeb() As Boolean
    #If TargetWeb Then
        Return True
    #Else
        Return False
    #EndIf
End Function

Function IsIOS() As Boolean
    #If TargetIOS Then
        Return True
    #Else
        Return False
    #EndIf
End Function

Function IsConsole() As Boolean
    #If TargetConsole Then
        Return True
    #Else
        Return False
    #EndIf
End Function
```
