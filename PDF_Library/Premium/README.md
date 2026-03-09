# VNS PDF Premium Modules

**Version**: 1.0.0
**License**: Commercial (Separate Purchase Required - Modules Sold Individually)
**Compatibility**: Xojo Desktop, Web, iOS, Console

---

## Overview

This folder contains **Premium Modules** for VNS PDF Library. Each module adds specific advanced features:

### 1. **Encryption Module** (VNSPDFEncryptionPremium) - ✅ COMPLETE
- ✅ **RC4-128** (128-bit encryption, PDF Revision 3)
- ✅ **AES-128** (128-bit AES encryption, PDF Revision 4) - **RECOMMENDED**
- ✅ **AES-256** (256-bit AES encryption, PDF Revisions 5-6) - **BEST SECURITY**

### 2. **PDF/A Module** (VNSPDFAPremium) - ✅ COMPLETE
- ✅ **PDF/A-1** Output Intent support
- ✅ **PDF/X** and **PDF/E** compliance
- ✅ ICC color profile embedding

### 3. **Zlib Module** (VNSZlibPremium) - ✅ COMPLETE
- ✅ **Pure Xojo deflate compression** (zlib 1.3.1 compliant)
- ✅ **Pure Xojo inflate decompression**
- ✅ **iOS compression support** (bypasses sandboxing restrictions)
- ✅ **Adler-32 checksum** validation

### 4. **Table Module** (VNSPDFTablePremium) - ✅ COMPLETE
- ✅ **SimpleTable** - Basic table with borders
- ✅ **ImprovedTable** - Custom widths, auto number alignment
- ✅ **FancyTable** - Colored headers, alternating rows
- ✅ **Multi-page pagination** with header repetition

### 5. **E-Invoice Module** (VNSPDFEInvoicePremium) - ✅ COMPLETE
- ✅ **Create Factur-X** PDF/A-3b with embedded CII XML
- ✅ **Create ZUGFeRD** PDF/A-3b with embedded CII XML
- ✅ **ReadEInvoice** - Open any PDF and check Factur-X/ZUGFeRD conformity
- ✅ **CII XML Parser** - Parse CrossIndustryInvoice XML into data model
- ✅ **JSON export** - Full invoice data as JSON with error codes and warnings
- ✅ **5 profiles** - MINIMUM, BASIC WL, BASIC, EN 16931, EXTENDED
- ✅ **XML validation** - Comma decimals, date formats, currency/country codes

---

## Module Status Summary

| Module | Flag | Status | Description |
|--------|------|--------|-------------|
| **Encryption** | `hasPremiumVNSEncryptionModule` | ✅ Complete | RC4-128, AES-128, AES-256 |
| **PDF/A** | `hasPremiumVNSPDFAModule` | ✅ Complete | Output intents and ICC profiles |
| **Zlib** | `hasPremiumVNSZlibModule` | ✅ Complete | Pure Xojo compression for iOS |
| **Table** | `hasPremiumVNSTableModule` | ✅ Complete | Professional table generation |
| **E-Invoice** | `hasPremiumVNSEInvoiceModule` | ✅ Complete | Factur-X/ZUGFeRD create + read + validate |

---

## Encryption Module Features

| Feature | Status | Constant | Notes |
|---------|--------|----------|-------|
| **RC4-40** | ✅ FREE | `gkEncryptionRC4_40` (2) | Always available (weak) |
| **RC4-128** | ✅ PREMIUM | `gkEncryptionRC4_128` (3) | Legacy, shows deprecation warning |
| **AES-128** | ✅ PREMIUM | `gkEncryptionAES_128` (4) | **RECOMMENDED** - No warnings |
| **AES-256** | ✅ PREMIUM | `gkEncryptionAES_256` (5-6) | **BEST** - Maximum security |

---

## Files in This Folder

```
Premium/
├── README.md                              (this file)
├── VNSPDFEncryptionPremium.xojo_code     (Encryption module)
│   ├── EncryptRC4()                      ✅ RC4-128 implementation
│   ├── EncryptAESCBC()                   ✅ AES-CBC for content streams
│   ├── EncryptAESECB()                   ✅ AES-ECB for password entries
│   ├── SHA256/SHA384/SHA512()            ✅ Hash functions
│   ├── ComputeHashR6()                   ✅ Algorithm 2.B for Rev 6
│   ├── GenerateRandomIV()                ✅ IV generation
│   └── PKCS7Pad()                        ✅ PKCS7 padding
├── VNSPDFAPremium.xojo_code              (PDF/A module)
│   └── AddOutputIntent()                 ✅ Output intent creation
├── VNSZlibPremiumDeflate.xojo_code       (Compression)
│   └── Compress()                        ✅ zlib deflate
├── VNSZlibPremiumInflate.xojo_code       (Decompression)
│   └── Inflate()                         ✅ zlib inflate
├── VNSZlibPremiumAdler32.xojo_code       (Checksum)
├── VNSZlibPremiumConstants.xojo_code     (Constants)
├── VNSZlibPremiumTrees.xojo_code         (Huffman trees)
├── VNSPDFTablePremium.xojo_code          (Table module)
│   ├── SimpleTable()                     ✅ Basic tables
│   ├── ImprovedTable()                   ✅ Custom widths
│   └── FancyTable()                      ✅ Styled tables
├── VNSAESCore.xojo_code                  (AES implementation)
├── VNSAESConstants.xojo_code             (AES constants)
└── VNSSHAPRNG.xojo_code                  (SHA-based PRNG)
```

---

## Usage

### Checking Module Availability

```xojo
// Check if premium encryption is available
If hasPremiumVNSEncryptionModule Then
  pdf.SetProtection("user", "owner", True, True, True, True, True, True, True, True, _
                    VNSPDFModule.gkEncryptionAES_128)
End If

// Check if zlib compression is available (for iOS)
If hasPremiumVNSZlibModule Then
  // Compression works on iOS
End If

// Check if tables are available
If hasPremiumVNSTableModule Then
  VNSPDFTablePremium.FancyTable(pdf, headers, data, widths)
End If
```

---

## Documentation

See `docs/developer/premium/` for detailed documentation on each module:
- [01-encryption-module.md](../../docs/developer/premium/01-encryption-module.md)
- [02-zlib-module.md](../../docs/developer/premium/02-zlib-module.md)
- [03-table-module.md](../../docs/developer/premium/03-table-module.md)
- [04-pdfa-module.md](../../docs/developer/premium/04-pdfa-module.md)
- [05-html-markdown-module.md](../../docs/developer/premium/05-html-markdown-module.md)
- [07-einvoice-module.md](../../docs/developer/premium/07-einvoice-module.md)

---

*Last Updated: 2026-02-14*
