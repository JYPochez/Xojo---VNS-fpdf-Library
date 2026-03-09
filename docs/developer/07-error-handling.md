# Error Handling

## Table of Contents

- [Error Accumulation Pattern](#error-accumulation-pattern)
  - [How It Works](#how-it-works)
  - [Benefits](#benefits)
  - [Example Pattern](#example-pattern)
  - [Best Practices](#best-practices)

---

## Error Accumulation Pattern

The library uses an error accumulation pattern rather than throwing exceptions. This allows operations to continue and collect multiple errors.

### How It Works

1. Operations that encounter errors call `SetError(msg)` internally
2. First error wins - subsequent SetError() calls are ignored if an error already exists
3. Calling code checks for errors using `Ok()`, `Err()`, or `GetError()`
4. `ClearError()` resets the error state

### Error Checking Methods

```xojo
// Preferred methods:
Function Ok() As Boolean      // Returns True if no errors
Function Err() As Boolean     // Returns True if errors exist
Function GetError() As String  // Returns error message string
Sub ClearError()               // Resets error state

// Internal use:
Sub SetError(msg As String)    // Sets error (first error wins)
Sub SetErrorf(format As String, args() As Variant)  // Printf-style error
```

### Benefits

- Non-blocking: Code continues executing
- First-error-wins: Most relevant error preserved
- Suitable for batch operations
- Clean error reporting

### Example Pattern

```xojo
Sub GenerateReport()
    Dim pdf As New VNSPDFDocument()

    pdf.SetFont("helvetica", "", 12)
    pdf.Cell(0, 10, "Hello World")

    // Check for errors at logical checkpoints
    If pdf.Err() Then
        LogError("PDF generation failed: " + pdf.GetError())
        Return
    End If

    // Save output
    pdf.Save(SpecialFolder.Desktop.Child("report.pdf"))

    If Not pdf.Ok() Then
        LogError("Save failed: " + pdf.GetError())
    End If
End Sub
```

### Best Practices

1. **Use Ok()/Err()**: Prefer these over checking the Error property directly
2. **Check Early**: Check for errors after initialization
3. **Check Often**: Check after groups of related operations
4. **Check Before Output**: Always check before generating final output
5. **Log Details**: Include error details via `GetError()` in logs for debugging
6. **User-Friendly Messages**: Show simplified messages to users, log full details
