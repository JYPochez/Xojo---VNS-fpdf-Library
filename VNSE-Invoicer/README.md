# VNS E-Invoicer

A free standalone desktop application for creating, opening, editing, previewing, and exporting Factur-X/ZUGFeRD e-invoices, fully compliant with the European EN 16931 standard.

Built entirely with the VNS PDF Library and its premium modules — a real-world showcase of what the library can do.

## Download

Pre-built binaries are available for:
- **macOS** (Universal: Apple Silicon & Intel)
- **Windows** (x86 64-bit)
- **Linux** (x86 64-bit)

No installation required — download, unzip, and run.

## Features

### Create E-Invoices
- Multi-window document architecture — work on multiple invoices simultaneously
- Seller/buyer details with full address, VAT ID, legal registration, contact info
- Line items with quantity, unit price, unit codes, tax rate, and tax category
- Automatic tax calculation grouped by rate and category (UNTDID 5305)
- Payment info: IBAN, BIC, payment reference, payment means
- Invoice types: Commercial Invoice, Credit Note, Debit Note, and more

### Open & Verify Existing E-Invoices
- Open any Factur-X or ZUGFeRD PDF to view invoice data
- **Open any plain PDF** — add e-invoice metadata to existing invoices without regenerating the layout
- Automatic standard detection: Factur-X, ZUGFeRD 2.0, ZUGFeRD 1.0, XRechnung
- Profile detection: MINIMUM, BASIC WL, BASIC, EN 16931, EXTENDED
- Digital signature verification with integrity check:
  - Green: "Integrity verified" with signer name, certificate, and date
  - Red: "WARNING: Document may have been tampered with!"

### Validate & Export
- **3-level validation** matching European validator standards:
  - EN 16931 core business rules (BR-02 to BR-65)
  - Code list validation (invoice types, currencies, countries, payment means, VAT categories)
  - Country-specific rules: France (BR-FR), Germany (BR-DE), Italy (BR-IT), Netherlands (BR-NL)
- Auto-detects seller country from invoice data
- Export as **Factur-X** or **ZUGFeRD** with embedded CII XML (PDF/A-3b compliant)
- **Preserves original PDF pages** when re-exporting an opened PDF
- Professional PDF layout with blue accent theme and automatic page breaks for new invoices
- Code128 barcode on invoices
- Notes with subject codes (AAB, PMD, PMT) — visible and editable as `[CODE] text` format

### Digital Signatures
- Sign exported PDFs with **PAdES-B-B** (PDF Advanced Electronic Signatures)
- Built-in self-signed certificate generator (RSA 2048-bit)
- Or use your own certificate and private key files
- Configurable signing reason and location

### Batch Check
- **Check Folder**: scan an entire folder of PDFs for Factur-X/ZUGFeRD conformity
- Results show: standard, profile, validation errors, and signature status for each file

### Preferences
- Company defaults: seller name, VAT ID, address, contact info
- Payment defaults: IBAN, BIC
- Tax rates: configurable list with one rate marked as default
- Digital signature: enable/disable, certificate paths, self-signed generation

### In-App PDF Preview
- Preview invoices before exporting with zoom, thumbnails, save, and print
- Cross-platform: macOS (PDFKit), Windows (WinRT), Linux (Poppler)

## Getting Started

1. Launch the application
2. Go to **File > Settings** to set up your company details (seller info, payment defaults, tax rates)
3. Optionally enable digital signing and generate a self-signed certificate
4. Create a new invoice with **File > New Invoice** or open an existing e-invoice PDF with **File > Open**
5. Fill in buyer details and add line items — totals and tax breakdowns update automatically
6. Click **Validate** to check for errors, then **Preview** to see the PDF
7. Export with **File > Export Factur-X** or **File > Export ZUGFeRD**

## Keyboard Shortcuts

| Action | macOS | Windows/Linux |
|--------|-------|---------------|
| New Invoice | Cmd+N | Ctrl+N |
| Open | Cmd+O | Ctrl+O |
| Save | Cmd+S | Ctrl+S |
| Save As | Cmd+Shift+S | Ctrl+Shift+S |
| Preview | Cmd+Shift+P | Ctrl+Shift+P |
| Validate | Cmd+Shift+V | Ctrl+Shift+V |
| Add Line Item | Cmd+L | Ctrl+L |
| Settings | Cmd+, | Ctrl+, |

## Supported Standards

- **Factur-X** (French e-invoicing standard)
- **ZUGFeRD 2.0** (German e-invoicing standard)
- **EN 16931** (European Norm for electronic invoicing)
- **Cross Industry Invoice (CII)** XML embedded in PDF/A-3b
- 5 conformance profiles: MINIMUM, BASIC WL, BASIC, EN 16931, EXTENDED

## Built With

This app is built with the [VNS PDF Library](https://www.verynicesw.fr) for Xojo, using:
- **E-Invoice Premium Module**: Factur-X/ZUGFeRD CII XML generation, validation, PDF reading, and barcode rendering
- **Encryption Premium Module**: PAdES-B-B digital signatures with RSA PKCS#1 v1.5
- **Core Library**: PDF generation, PDF import, font embedding, page layout, compression

## License

Copyright 2026 VeryniceSW. All rights reserved.
