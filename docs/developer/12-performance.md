# Performance Considerations

## Current Implementation

- Dictionary lookups: O(1)
- String concatenation: O(n) but acceptable for current use
- Memory: Minimal overhead, pages stored as strings

## Font Subsetting (98% Size Reduction)

TrueType fonts are automatically subsetted using `VNSPDFTrueTypeFontSubsetter`:
- Full Arial Unicode font (23MB) embeds as ~500KB subset
- Only glyphs actually used in the document are included
- Sparse glyph ID subsetting - no CID remapping needed
- Rebuilds TrueType tables (cmap, glyf, hmtx, loca, maxp, head, hhea, post)

## Stream Compression (27-60% Reduction)

FlateDecode/zlib compression is applied to page content streams:
- **Desktop/Web/Console**: Uses system zlib (automatic)
- **iOS**: Requires Premium Zlib module (pure Xojo implementation)
- Typical reduction: 27-60% depending on content
- Set `pdf.Compressed = True` (enabled by default on Desktop/Web/Console)

## Image Optimization

- Images registered once and reused across multiple pages (XObject resources)
- JPEG passed through without re-encoding
- PNG parsed and embedded with proper color space handling
- ImageFromPicture: JPEG on Windows/Linux/iOS/Web, PNG on macOS (RGBA channel issue)

## Future Optimizations

- Consider StringBuilder for large content
- Implement page caching for large documents
- Stream processing for very large PDFs
