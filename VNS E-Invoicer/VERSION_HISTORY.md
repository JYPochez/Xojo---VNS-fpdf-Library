# Version History - VNS E-Invoicer

## v1.0.1 (2026-02-20)

### Bug Fixes
- **Fix zlib crash on macOS ARM64**: Compiled app crashed (SIGSEGV) when decompressing PDF streams in Check Folder. Root cause: zlib declares used UInt32 for destLen/sourceLen but macOS LP64 `unsigned long` is 8 bytes. The 8-byte write to a 4-byte ByRef variable corrupted the stack. Fixed by using UInt64 on macOS/Linux, UInt32 on Windows.

### Architecture
- **Per-project premium constants**: Premium feature flags (hasPremiumVNS*) moved from shared VNSPDFModule to per-project module (VNS_E_Invoicer_Premium_Constants), preventing cross-project conflicts when compiling different configurations.

---

## v1.0.0 (2026-02-18)

### Build & Distribution
- Configure macOS code signing (Developer ID, App Sandbox, Hardened Runtime, Notarization)
- Add provisioning profile copy step to build automation
- Set app version to 1.0.0, category to Finance

### Features
- **Invoice Editor**: Multi-window document-based interface for creating and editing e-invoices
- **Open E-Invoices**: Parse existing Factur-X/ZUGFeRD PDFs, populate UI, lock seller fields
- **Validation**: Profile-aware validation (MINIMUM through EXTENDED) with detailed error messages
- **PDF Preview**: In-app preview with zoom, thumbnails, save, and print
- **Export**: Factur-X and ZUGFeRD export with embedded CII XML (PDF/A-3b)
- **Professional PDF Layout**: Blue accent theme with seller/buyer blocks, line items table, tax summary, payment info
- **Code128 Barcode**: Invoice number barcode rendered on PDF output
- **Digital Signatures**: PAdES-B-B signing on export when enabled in settings
- **Self-Signed Certificates**: Generate RSA 2048-bit keypair + X.509 certificate from settings
- **Signature Verification**: Green "Integrity verified" or red tampering warning when opening signed invoices
- **Check Folder**: Batch scan a folder of PDFs for e-invoice conformity with 8-column results (Filename, E-Invoice, Valid, Signed, Self-Signed, Standard, Profile, Reason)
- **Settings**: Company defaults (seller info, payment, tax rates), digital signature configuration
- **Profile Detection**: Automatically detect and set profile popup when opening existing e-invoices
- **Smart Open**: Distinguish structural errors from validation warnings — invoices with minor issues still load

### Documentation
- User manual covering setup, preferences, invoice editing, validation, export, digital signatures, Check Folder, profile requirements guide
- 23 sample Factur-X/ZUGFeRD PDFs from official sources (PDFlib, FNFE-MPE, Intarsys, Mustang) plus 2 invalid samples for testing
- README with features, installation, getting started guide, keyboard shortcuts
