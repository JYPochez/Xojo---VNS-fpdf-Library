# Testing

## Testing Strategy

The library uses **visual PDF verification** through a comprehensive set of working examples. Each example generates a PDF file in the `pdf_examples/` folder that can be visually inspected for correctness.

Testing is performed across all 4 platforms: Desktop (macOS, Windows, Linux), Web, iOS, and Console.

## Working Examples (26 total)

All examples are in `PDF_Library/Examples/VNSPDFExamplesModule.xojo_code`, output to `pdf_examples/`:

| Example | Description | Tests |
|---------|-------------|-------|
| 1 | Simple Shapes | Lines, rectangles, circles, Bezier, arrows, polygons |
| 2 | Text Layouts | Cell, MultiCell, Write with alignment |
| 3 | Multiple Pages | 7 pages with shapes |
| 4 | Line Widths | Styles, dash patterns |
| 5 | UTF-8 Fonts | Unicode text with TrueType |
| 6 | Text Measurement | GetStringWidth |
| 7 | Document Metadata | Title, Author, etc. |
| 8 | Error Handling | Ok/Err/GetError |
| 9 | Images | JPEG, PNG, programmatic graphics |
| 10 | Header/Footer | Callbacks with page count |
| 11 | Links/Bookmarks | Internal/external links, outline |
| 12 | Custom Formats | AddPageFormat |
| 13 | PDF/A | ICC profiles |
| 14 | Encryption | Password protection, permissions |
| 15 | Watermark | Rotated background watermark (45 degree diagonal) |
| 16 | Formatting | Printf-style Cellf/Writef |
| 17 | Utilities | Version, JSON serialization |
| 18 | Plugin Architecture | Premium feature detection |
| 19 | Tables | SQLite-driven, multi-page |
| 20 | PDF Import | XObject templates |
| 21 | Transformations | All 18 transform methods |
| 22 | VNS PDF Graphics | Compares Xojo PDFDocument vs VNSPDFDocument, Unicode, rotations |
| 23 | File Attachments | Document-level and page-level annotations |
| 25 | Table of Contents | Automatic TOC generation |
| 26 | Bug Tests | Cross-platform testing suite for reported bugs |

## Bug Testing (Example 26)

Example 26 is a dedicated visual test suite for bugs reported by users. Currently tests:

1. **MultiCell single-line bottom border** - Verifies all 4 borders draw correctly for single-line cells
2. **SplitTextToLines first character** - Verifies long words wrap without losing characters
3. **MultiCell newline handling** - Verifies chr(10) and CRLF produce paragraph breaks
4. **MultiCell positioning** - Verifies cursor resets to left margin after MultiCell
5. **ImageFromPicture corruption** - Verifies programmatic images render correctly on all platforms

## Unit Test Template

```xojo
Sub TestDocumentCreation()
    Dim pdf As New VNSPDFDocument()

    // Test initial state
    Assert(pdf.PageCount = 0, "Initial page count should be 0")
    Assert(pdf.CurrentPage = 0, "Initial page number should be 0")
    Assert(pdf.Ok(), "Should have no errors")

    // Test page addition
    pdf.AddPage()
    Assert(pdf.PageCount = 1, "Page count should be 1")
    Assert(pdf.CurrentPage = 1, "Current page should be 1")

    // Test multiple pages
    pdf.AddPage()
    pdf.AddPage()
    Assert(pdf.PageCount = 3, "Page count should be 3")
    Assert(pdf.CurrentPage = 3, "Current page should be 3")
End Sub
```

## Cross-Platform Testing Checklist

- [ ] macOS Desktop - all examples generate correct PDFs
- [ ] Windows Desktop - ImageFromPicture uses JPEG (not PNG)
- [ ] Linux Desktop - ImageFromPicture uses JPEG (not PNG)
- [ ] Web - all examples generate correct PDFs
- [ ] iOS - string indexing is 0-based, no system zlib, JPEG for images
- [ ] Console - all examples generate correct PDFs
