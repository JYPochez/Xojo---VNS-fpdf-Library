# VNS E-Invoicer

Desktop application for creating, opening, editing, previewing, and exporting Factur-X/ZUGFeRD e-invoices, fully compliant with the European EN 16931 standard.

Available for macOS, Windows, and Linux.

## Features

- Create new e-invoices with seller/buyer details, line items, and tax breakdowns
- Open and parse existing Factur-X/ZUGFeRD PDF invoices
- Automatic tax calculation grouped by rate and category
- Profile-aware validation (MINIMUM, BASIC WL, BASIC, EN 16931, EXTENDED)
- Export as Factur-X or ZUGFeRD with embedded CII XML (PDF/A-3b)
- In-app PDF preview with zoom, thumbnails, save, and print
- Digital signatures (PAdES-B-B) with self-signed certificate generation
- Batch folder scanning to check multiple e-invoices at once
- Code128 barcode on invoices
- Preferences for seller defaults, payment info, tax rates, and signing configuration

## Installation

Download the latest release for your platform, unzip, and run the application. No installation required.

| Platform | Download | Size |
|----------|----------|------|
| macOS (Universal) | `VNS E-Invoicer.zip` | ~15 MB |
| Windows 64-bit | `VNS E-Invoicer.zip` | ~9 MB |
| Linux 64-bit | `VNS E-Invoicer.zip` | ~22 MB |

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

## License

Copyright 2026 VeryniceSW. All rights reserved.
