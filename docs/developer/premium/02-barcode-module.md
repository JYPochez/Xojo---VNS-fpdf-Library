# Barcode Module - Premium Documentation

Part of the E-Invoice Premium Module for VNS PDF Library.

## Overview

The Barcode Module provides pure Xojo barcode rendering for all platforms including Console. It generates 10 barcode types using **vector rendering** - barcodes are drawn as native PDF rectangles for perfect print quality at any resolution. No raster images, no JPEG compression artifacts.

## Free vs Premium

### Free (VNSPDFDocument methods)
- `DrawQRCode(x, y, size, value)` - Uses Xojo built-in `Barcode.Image()` (raster/JPEG)
- `DrawCode128(x, y, w, h, value)` - Uses Xojo built-in `Barcode.Image()` (raster/JPEG)
- Available on Desktop, Web, iOS only (not Console - Barcode class unavailable)

### Premium (VNSPDFBarcode module)
- `DrawBarcode(doc, barcodeType, x, y, w, h, value, showText)` - **Vector rendering** (PDF rectangles)
- Perfect print quality at any resolution - no blurry bars
- Works on ALL platforms including Console
- Supports all 10 barcode types

## Supported Barcode Types

### 1D Barcodes

| Type | Enum Value | Characters | Description |
|------|-----------|------------|-------------|
| Code 128 | `eBarcodeType.Code128` | Full ASCII | Auto Code B/C switching, check digit |
| EAN-13 | `eBarcodeType.EAN13` | 12-13 digits | European Article Number, auto check digit |
| EAN-8 | `eBarcodeType.EAN8` | 7-8 digits | Compact EAN, auto check digit |
| UPC-A | `eBarcodeType.UPCA` | 11-12 digits | Universal Product Code (delegates to EAN-13) |
| Code 39 | `eBarcodeType.Code39` | 0-9, A-Z, special | Alphanumeric, auto start/stop `*` |
| ITF | `eBarcodeType.ITF` | Digits (pairs) | Interleaved 2 of 5, auto-pads odd length |
| Codabar | `eBarcodeType.Codabar` | 0-9, - $ : / . + | Auto start/stop A/B/C/D |

### 2D Barcodes

| Type | Enum Value | Capacity | Description |
|------|-----------|----------|-------------|
| QR Code | `eBarcodeType.QRCode` | ~2K bytes | ISO 18004, versions 1-10, EC level M |
| DataMatrix | `eBarcodeType.DataMatrix` | ~36 bytes | ECC 200, sizes 10x10 to 24x24 |
| PDF417 | `eBarcodeType.PDF417` | Variable | Text compaction, EC levels 0-2 |

## API Reference

### VNSPDFBarcode.DrawBarcode

```xojo
Sub DrawBarcode(doc As VNSPDFDocument, barcodeType As VNSPDFModule.eBarcodeType, _
  x As Double, y As Double, w As Double, h As Double, _
  value As String, showText As Boolean = True)
```

**Parameters:**
- `doc` - The VNSPDFDocument to draw on
- `barcodeType` - One of the `VNSPDFModule.eBarcodeType` enum values
- `x, y` - Position in current page units
- `w, h` - Size in current page units
- `value` - The data to encode
- `showText` - Show human-readable text below 1D barcodes (default: True)

### Vector Rendering (used by DrawBarcode)

The `DrawBarcode` method uses vector rendering internally. Each renderer provides two APIs:

**GetModules / GetGrid** (used by DrawBarcode for vector rendering):
```xojo
// 1D barcodes return a 0/1 module array + display text
VNSPDFBarcodeCode128.GetModules(value, ByRef displayText) As Integer()
VNSPDFBarcodeEAN.GetModulesEAN13(value, ByRef displayText) As Integer()
VNSPDFBarcodeCode39.GetModules(value, ByRef displayText) As Integer()

// 2D barcodes return a flat 0/1 grid + dimensions
VNSPDFBarcodeQR.GetGrid(value, ByRef gridSize) As Integer()
VNSPDFBarcodeDataMatrix.GetGrid(value, ByRef gridRows, ByRef gridCols) As Integer()
VNSPDFBarcodePDF417.GetGrid(value, ByRef gridRows, ByRef gridCols) As Integer()
```

**Render** (legacy raster API, returns a Picture):
```xojo
VNSPDFBarcodeQR.Render(value As String, pixelSize As Integer) As Picture
VNSPDFBarcodeCode128.Render(value As String, pixelWidth As Integer, pixelHeight As Integer, showText As Boolean) As Picture
// etc.
```

## Usage Example

```xojo
Dim doc As New VNSPDFDocument

// Free methods (Desktop/Web/iOS only)
doc.DrawQRCode(20, 20, 40, "https://example.com")
doc.DrawCode128(20, 70, 60, 25, "ABC-123")

// Premium methods (all platforms)
VNSPDFBarcode.DrawBarcode(doc, VNSPDFModule.eBarcodeType.QRCode, 20, 20, 40, 40, "https://example.com")
VNSPDFBarcode.DrawBarcode(doc, VNSPDFModule.eBarcodeType.EAN13, 20, 70, 60, 25, "5901234123457")
VNSPDFBarcode.DrawBarcode(doc, VNSPDFModule.eBarcodeType.Code39, 20, 100, 80, 25, "HELLO-123")
VNSPDFBarcode.DrawBarcode(doc, VNSPDFModule.eBarcodeType.DataMatrix, 20, 130, 30, 30, "DM-DATA")

doc.Save(SpecialFolder.Desktop.Child("barcodes.pdf"))
```

## Error Correction

- **QR Code**: Reed-Solomon over GF(256), polynomial 0x11D, EC level M (15% recovery)
- **DataMatrix**: Reed-Solomon over GF(256), polynomial 301
- **PDF417**: Reed-Solomon over GF(929), EC levels 0-2

## Files

```
VNSPDFBarcode.xojo_code          - Main dispatch module
VNSPDFBarcodeQR.xojo_code        - QR Code renderer
VNSPDFBarcodeCode128.xojo_code   - Code 128 renderer
VNSPDFBarcodeEAN.xojo_code       - EAN-13, EAN-8, UPC-A renderers
VNSPDFBarcodeCode39.xojo_code    - Code 39 renderer
VNSPDFBarcodeITF.xojo_code       - Interleaved 2 of 5 renderer
VNSPDFBarcodeCodabar.xojo_code   - Codabar renderer
VNSPDFBarcodeDataMatrix.xojo_code - DataMatrix renderer
VNSPDFBarcodePDF417.xojo_code    - PDF417 renderer
```
