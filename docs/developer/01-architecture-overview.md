# Architecture Overview

The Xojo FPDF library follows a modular architecture with clear separation of concerns:

```
PDF_Library/
├── VNSPDFModule              # Global utilities and constants
├── Core/
│   ├── VNSPDFDocument        # Main PDF document management
│   ├── VNSPDFGraphics        # Xojo PDFGraphics-compatible wrapper
│   ├── VNSPDFGraphicsPath    # Graphics path for DrawPath/FillPath
│   ├── VNSPDFPage            # Page data storage
│   ├── VNSPDFEncryption      # PDF encryption (RC4-40 free, rest premium)
│   ├── VNSPDFBlendMode       # Transparency blend modes
│   ├── VNSPDFGradient        # Gradient shading patterns
│   ├── VNSPDFOutputIntent    # PDF/A output intents
│   └── VNSPDFAttachment      # File attachment data
├── Text/
│   ├── VNSPDFFont            # Font management and metrics
│   ├── VNSPDFFontDescriptor  # TrueType font descriptor
│   ├── VNSPDFTrueTypeFont    # TrueType font parser
│   └── VNSPDFTrueTypeFontSubsetter  # Font subsetting
├── Media/
│   └── VNSPDFImage           # JPEG/PNG image parser
├── Compression/
│   ├── VNSZlibModule         # zlib compression (Desktop/Web/Console)
│   └── VNSZlibModuleTest     # Compression tests
├── Examples/
│   └── VNSPDFExamplesModule  # 23+ working examples
├── Import/                    # PDF Import system (v1.0.0)
│   ├── VNSPDFReader          # PDF parser and page extractor
│   ├── VNSPDFParser          # Object parsing and type system
│   ├── VNSPDFTokenizer       # Lexical analysis
│   ├── VNSPDFStreamReader    # Binary stream handling
│   ├── VNSPDFStreamDecoder   # Stream decompression
│   ├── VNSPDFLZWDecoder      # LZW decompression
│   ├── VNSPDFImportedPage    # Imported page data
│   ├── VNSPDFXrefReader      # Cross-reference table reader
│   ├── VNSPDFXrefEntry       # Cross-reference entry
│   ├── VNSPDFCrossReference  # Cross-reference table
│   ├── VNSPDFIndirectObject  # Indirect object wrapper
│   ├── VNSPDFIndirectObjectReference  # Object reference
│   ├── VNSPDFTextExtractor   # Text extraction from PDF
│   ├── VNSPDFTextBlock       # Text block data
│   ├── VNSPDFCMapParser      # CMap parsing for text
│   └── VNSPDFType classes    # 10 PDF type classes (Null, Boolean, Numeric, String, HexString, Name, Array, Dictionary, Stream, plus IndirectObjectReference)
└── Premium/                   # Premium modules (optional, require license)
    ├── VNSPDFEncryptionPremium   # AES-128/256 encryption (✅ WORKING)
    ├── VNSAESConstants           # AES lookup tables
    ├── VNSAESCore                # AES core implementation
    ├── VNSAESTables              # AES S-box tables
    ├── VNSAESTest                # AES test vectors
    ├── VNSPDFZlibPremium         # Pure Xojo zlib wrapper (✅ WORKING)
    ├── VNSZlibPremiumDeflate     # Deflate compression
    ├── VNSZlibPremiumInflate     # Inflate decompression
    ├── VNSZlibPremiumAdler32     # Adler32 checksum
    ├── VNSZlibPremiumTrees       # Huffman trees
    ├── VNSZlibPremiumConstants   # Compression constants
    ├── VNSPDFTablePremium        # Table generation (✅ WORKING)
    ├── VNSPDFTableAccumulator    # Table data accumulator
    ├── VNSPDFTableColumnCalc     # Column width calculator
    ├── VNSPDFTableFooterConfig   # Footer configuration
    ├── VNSPDFTableFooterStyle    # Footer styling
    ├── VNSPDFPDFAPremium         # PDF/A compliance (✅ WORKING)
    └── VNSPDFFormsPremium        # AcroForms (🔨 Coming Soon)
```

## FREE vs PREMIUM Versions

The library is available in two configurations:

### FREE Version
- **Core PDF features**: All text, graphics, images, fonts, links, bookmarks
- **PDF Import**: Import pages from existing PDFs as XObject templates (✅ v1.0.0)
- **Basic encryption**: RC4-40 (40-bit, DEPRECATED)
- **Basic compression**: FlateDecode/zlib on Desktop/Web/Console (iOS blocked)
- **Platform support**: Desktop, Web, iOS, Console
- **Examples**: 26 working examples demonstrating all features
- **License**: Open-source MIT license

### PREMIUM Version (Requires License)
- **All FREE features** plus:
- **Enhanced encryption**: RC4-128, AES-128, AES-256 (✅ FULLY WORKING)
- **PDF/A compliance**: Output Intent + ICC color profiles (✅ FULLY WORKING)
- **iOS compression**: Pure Xojo zlib implementation (✅ FULLY WORKING)
- **PNG Predictor reversal**: Required for importing modern PDFs (✅ FULLY WORKING)
- **Table generation**: SimpleTable, ImprovedTable, FancyTable with pagination (✅ FULLY WORKING)
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
