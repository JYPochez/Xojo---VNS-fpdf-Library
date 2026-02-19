# VNSZlibPremium Module

**Status**: ✅ Available
**Location**: `PDF_Library/Premium/VNSZlibPremiumDeflate.xojo_code`, `VNSZlibPremiumInflate.xojo_code`
**Module Flag**: `VNSPDFModule.hasPremiumZlibModule`

---

## Activation

### Step 1: Add the Module Files to Your Project

In the Xojo IDE, create a `Premium` folder inside the `PDF_Library` folder of your project (if it does not already exist), then create a `ZlibModule` subfolder inside it. Drag the following files into that folder:

- `VNSPDFZlibPremium.xojo_code`
- `VNSZlibPremiumAdler32.xojo_code`
- `VNSZlibPremiumConstants.xojo_code`
- `VNSZlibPremiumDeflate.xojo_code`
- `VNSZlibPremiumInflate.xojo_code`
- `VNSZlibPremiumTrees.xojo_code`

### Step 2: Enable the Module Flag

Open `PDF_Library/VNSPDFModule.xojo_code` and set the following constant to `True`:

```xojo
VNSPDFModule.hasPremiumZlibModule = True
```

This constant is set to `False` by default. The library checks this flag at runtime to determine whether pure Xojo zlib compression is available. If the flag is `False`, the library falls back to system zlib via Declares (not available on iOS due to sandboxing).

---

## Overview

The Premium Zlib module provides pure Xojo compression and decompression based on zlib 1.3.1 specification. This enables PDF stream compression on **ALL platforms including iOS**, where system library Declares are blocked by sandboxing.

### Key Benefits

| Feature | Without Module | With Module |
|---------|---------------|-------------|
| Desktop/Console | System zlib (Declares) | Pure Xojo or System |
| Web | System zlib (Declares) | Pure Xojo or System |
| iOS | No compression (larger PDFs) | **Pure Xojo compression** |
| File Size | ~40% larger on iOS | **27-60% reduction** |

---

## Architecture

### Module Structure

```
VNSZlibModule (wrapper)
├── VNSZlibPremiumDeflate (compression)
│   ├── Static Huffman encoding
│   ├── LZ77 matching
│   └── Adler-32 checksum
└── VNSZlibPremiumInflate (decompression)
    ├── Static/Dynamic Huffman decoding
    ├── LZ77 back-reference expansion
    └── Adler-32 validation
```

### VNSZlibModule (Wrapper)

The `VNSZlibModule` provides a unified API that automatically selects the best compression method:

```xojo
// Compression (automatic selection)
Function Compress(data As String) As String
  #If TargetiOS Then
    // iOS: Use pure Xojo implementation
    If VNSPDFModule.hasPremiumZlibModule Then
      Return VNSZlibPremiumDeflate.Compress(data)
    Else
      Return ""  // No compression available
    End If
  #Else
    // Desktop/Web/Console: Use system zlib
    Return SystemZlibCompress(data)
  #EndIf
End Function

// Decompression (automatic selection)
Function Decompress(data As String) As String
  #If TargetiOS Then
    If VNSPDFModule.hasPremiumZlibModule Then
      Return VNSZlibPremiumInflate.Inflate(data)
    Else
      Return ""
    End If
  #Else
    Return SystemZlibDecompress(data)
  #EndIf
End Function
```

---

## Features

### Deflate Compression (VNSZlibPremiumDeflate)

- **Static Huffman Encoding** - RFC 1951 compliant
- **LZ77 Compression** - Back-reference matching with sliding window
- **Adler-32 Checksum** - Data integrity verification
- **Zlib Header/Trailer** - Standard zlib wrapper (CMF/FLG bytes)
- **Block-based Output** - Proper block boundaries for PDF compatibility

### Inflate Decompression (VNSZlibPremiumInflate)

- **Static Huffman Decoding** - Fixed code tables per RFC 1951
- **Dynamic Huffman Decoding** - Custom code table reconstruction
- **LZ77 Expansion** - Back-reference resolution
- **Checksum Validation** - Adler-32 verification
- **Bit-level Precision** - Correct bit reversal for code lookups

---

## Usage

### Basic Compression

```xojo
// Compress data
Dim original As String = "Your data to compress..."
Dim compressed As String = VNSZlibModule.Compress(original)

If compressed <> "" Then
  // Compression successful
  Dim ratio As Double = Len(compressed) / Len(original) * 100
  // Typical ratio: 40-73% of original size
End If
```

### Basic Decompression

```xojo
// Decompress data
Dim decompressed As String = VNSZlibModule.Decompress(compressed)

If decompressed = original Then
  // Round-trip successful
End If
```

### Checking Module Availability

```xojo
If VNSPDFModule.hasPremiumZlibModule Then
  // Premium zlib available - compression works on all platforms
Else
  #If TargetiOS Then
    // iOS without premium: No compression (PDFs will be larger)
  #Else
    // Desktop/Web/Console: System zlib still available
  #EndIf
End If
```

---

## PDF Integration

The zlib module is automatically used by VNSPDFDocument for stream compression:

### Page Content Streams

```xojo
// In VNSPDFDocument.OutputContentStream():
Dim compressedData As String = VNSZlibModule.Compress(finalStreamData)
If compressedData <> "" Then
  #If TargetiOS Then
    If VNSPDFModule.hasPremiumZlibModule Then
      filterStr = "/Filter /FlateDecode"
    End If
  #Else
    filterStr = "/Filter /FlateDecode"
  #EndIf
  finalStreamData = compressedData
End If
```

### ICC Profile Streams (PDF/A)

```xojo
// ICC profiles are also compressed when available
Dim compressedData As String = VNSZlibModule.Compress(iccData)
Call Put("/Length " + Str(Len(compressedData)))
If VNSPDFModule.hasPremiumZlibModule Or Not TargetiOS Then
  Call Put("/Filter /FlateDecode")
End If
```

---

## Implementation Details

### Deflate Algorithm

1. **LZ77 Phase**
   - Scan input for repeated sequences
   - Build (distance, length) back-references
   - Use 32KB sliding window

2. **Huffman Phase**
   - Encode literals (0-255) and lengths (257-285)
   - Encode distances (0-29)
   - Use static code tables for simplicity and compatibility

3. **Block Structure**
   - BFINAL bit (1 = last block)
   - BTYPE bits (01 = static Huffman)
   - Compressed data
   - End-of-block symbol (256)

### Inflate Algorithm

1. **Header Parsing**
   - CMF byte (compression method, window size)
   - FLG byte (check bits, dictionary flag)

2. **Block Decoding**
   - Read BFINAL and BTYPE
   - For static: Use fixed code tables
   - For dynamic: Rebuild code tables from stream

3. **Symbol Expansion**
   - Literals: Output directly
   - Length/Distance pairs: Copy from output buffer

4. **Checksum Validation**
   - Compute Adler-32 of decompressed data
   - Compare with stored checksum

### Bit Reversal (Critical!)

Huffman codes in DEFLATE are stored in reverse bit order. The inflate implementation correctly reverses bits when looking up codes:

```xojo
// Reverse bits for Huffman lookup
Function ReverseBits(value As UInt32, numBits As Integer) As UInt32
  Dim result As UInt32 = 0
  For i As Integer = 0 To numBits - 1
    result = Bitwise.ShiftLeft(result, 1)
    If Bitwise.BitAnd(value, 1) <> 0 Then
      result = Bitwise.BitOr(result, 1)
    End If
    value = Bitwise.ShiftRight(value, 1)
  Next
  Return result
End Function
```

---

## Performance

### Compression Ratios

| Content Type | Typical Ratio | File Size Reduction |
|--------------|---------------|---------------------|
| Text-heavy PDFs | 27-35% | 65-73% smaller |
| Mixed content | 40-50% | 50-60% smaller |
| Image-heavy | 60-75% | 25-40% smaller |

### Speed Considerations

- Pure Xojo is slower than system zlib (~5-10x)
- Acceptable for document generation (not real-time)
- Most PDFs compress in < 1 second
- Desktop/Web/Console still use fast system zlib

---

## Testing

### Built-in Test Methods

```xojo
// Test compression/decompression round-trip
Function TestZlib() As Boolean
  Dim testData As String = "Test data for compression..."
  Dim compressed As String = VNSZlibModule.Compress(testData)
  Dim decompressed As String = VNSZlibModule.Decompress(compressed)
  Return (decompressed = testData)
End Function
```

### iOS-Specific Testing

Run Example 9 (Images) on iOS Simulator to verify:
- PDFs render correctly (not blank)
- File sizes are reasonable (compressed)
- FlateDecode filter is present in PDF

---

## Compatibility

| Platform | Compression | Decompression | Implementation |
|----------|-------------|---------------|----------------|
| Desktop | ✅ | ✅ | System zlib |
| Web | ✅ | ✅ | System zlib |
| Console | ✅ | ✅ | System zlib |
| iOS | ✅ | ✅ | **Pure Xojo** |

All platforms produce identical PDF output regardless of compression implementation used.

---

## Troubleshooting

### Blank PDFs on iOS

**Symptom**: PDFs generated on iOS appear blank in viewers.

**Cause**: Missing `/Filter /FlateDecode` in stream dictionary when compression is active.

**Solution**: Ensure VNSPDFDocument includes the filter declaration when `hasPremiumZlibModule` is true.

### Large Files on iOS (Without Module)

**Symptom**: iOS PDFs are ~40% larger than Desktop.

**Cause**: No compression available without premium zlib module.

**Solution**: Enable VNSZlibPremium module for full compression support.

---

*Last Updated: 2026-01-26*
