# Architecture Overview

The Xojo FPDF library follows a modular architecture with clear separation of concerns:

```
PDF_Library/
├── VNSPDFModule.xojo_code              # Global utilities, constants, enums
├── Core/
│   ├── VNSPDFDocument.xojo_code        # Main PDF document (drop-in Xojo PDFDocument replacement)
│   ├── VNSPDFGraphics.xojo_code        # Xojo PDFGraphics-compatible wrapper
│   ├── VNSPDFGraphicsPath.xojo_code    # Graphics path for DrawPath/FillPath
│   └── VNSPDFPathSegment.xojo_code     # Path segment data
├── Text/
│   └── VNSPDFFont.xojo_code            # Font management and metrics
├── Media/
│   └── VNSPDFImage.xojo_code           # JPEG/PNG image parser
├── Compression/
│   ├── VNSZlibModule.xojo_code         # zlib interface (native-first routing)
│   └── VNSZlibModuleTest.xojo_code     # Compression round-trip tests
├── Examples/
│   └── VNSPDFExamplesModule.xojo_code  # 33 working examples
├── Import/                              # PDF Import system
│   ├── VNSPDFReader.xojo_code          # PDF parser and page extractor
│   ├── VNSPDFParser.xojo_code          # Object parsing and type system
│   ├── VNSPDFTokenizer.xojo_code       # Lexical analysis
│   ├── VNSPDFStreamReader.xojo_code    # Binary stream handling
│   ├── VNSPDFStreamDecoder.xojo_code   # Stream decompression
│   ├── VNSPDFLZWDecoder.xojo_code      # LZW decompression
│   ├── VNSPDFImportedPage.xojo_code    # Imported page data
│   ├── VNSPDFXrefReader.xojo_code      # Cross-reference table reader
│   ├── VNSPDFTextExtractor.xojo_code   # Text extraction from PDF
│   ├── VNSPDFCMapParser.xojo_code      # CMap parsing for text
│   └── VNSPDFType*.xojo_code           # 10 PDF type classes
└── Premium/                             # Premium modules (require license)
    ├── EncryptionModule/                # AES encryption + Digital Signatures
    ├── TableModule/                     # High-level table API
    ├── ZlibModule/                      # Pure Xojo zlib for iOS
    ├── PDFAModule/                      # PDF/A output intents
    ├── FormsModule/                     # AcroForms (82% complete)
    ├── EInvoiceModule/                  # E-Invoice + Barcodes (10 types)
    └── HTMLMarkdownModule/              # LoadHTML/LoadMarkdown
```

See [Chapter 16: Premium Modules](16-premium-modules.md) for detailed file listing per module.

## FREE vs PREMIUM Versions

The library is available in two configurations:

### FREE Version
- **Core PDF features**: All text, graphics, images, fonts, links, bookmarks, transformations
- **PDF Import**: Import pages from existing PDFs as XObject templates
- **Basic encryption**: RC4-40 (40-bit)
- **Basic compression**: FlateDecode/zlib on Desktop/Web/Console (iOS blocked)
- **Basic barcodes**: QR Code + Code 128 (via DrawQRCode/DrawCode128)
- **Platform support**: Desktop, Web, iOS, Console
- **Examples**: 33 working examples demonstrating all features
- **License**: Open-source with full source code

### PREMIUM Version (Requires License)
- **All FREE features** plus:
- **Enhanced encryption**: RC4-128, AES-128, AES-256 (Revisions 2-6)
- **Digital Signatures**: PAdES-B-B PDF signing, XAdES-BES XML signing
- **Table generation**: SimpleTable, ImprovedTable, FancyTable, ManualTable with auto pagination
- **iOS compression**: Pure Xojo zlib implementation
- **E-Invoice**: Factur-X/ZUGFeRD EN 16931 with CII XML and conformity checker
- **Barcodes**: 10 types (QR, Code128, EAN-13, EAN-8, UPC-A, Code 39, ITF, Codabar, DataMatrix, PDF417)
- **HTML/Markdown Import**: LoadHTML(), LoadMarkdown() with block CSS, merge fields, external images
- **License**: Commercial (EUR 50 per module, Bundle: Buy 2, Get 1 Free = EUR 100)

See [Chapter 16: Premium Modules](16-premium-modules.md) for detailed information.

## Supported Platforms

The library supports all major Xojo platforms:

- **Desktop** - Windows, macOS, Linux applications
- **Web** - Server-side PDF generation for web apps
- **iOS** - Native iOS mobile applications
- **Console** - Command-line utilities and server processes

## Design Principles

1. **VNS Prefix**: All classes use the `VNS` prefix to avoid conflicts with Xojo framework classes
2. **Shared Code**: Maximum code reuse between all platform targets
3. **Error Accumulation**: Errors are accumulated rather than thrown, allowing operations to continue
4. **Immutable Configuration**: Core document settings (unit, orientation, format) are set at initialization
5. **Platform Abstraction**: Platform-specific code is isolated using conditional compilation
