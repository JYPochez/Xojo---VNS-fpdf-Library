# VNS E-Invoicer - User Manual

**Version 1.0** | macOS, Windows, Linux

VNS E-Invoicer is a desktop application for creating, editing, and exporting electronic invoices compliant with the **Factur-X** and **ZUGFeRD** standards (EN 16931).

---

## Getting Started

### First Launch

1. Open VNS E-Invoicer. A blank invoice window appears automatically.
2. Go to **File > Preferences** (Cmd+, on Mac) to configure your company details. This saves time since your company info will be pre-filled on every new invoice.

### Setting Up Preferences

The Preferences window has three sections:

**Your Company Details** - Fill in your company name, VAT number, legal registration ID, address, city, country, contact name, email, and phone. These fields auto-populate the **Seller** section of every new invoice.

**Payment Defaults** - Enter your IBAN and BIC. These pre-fill the payment section of new invoices.

**Tax Rates** - Manage a list of commonly used tax rates. Each rate has a name, percentage, tax category code, and a "Default" flag. The default rate is automatically selected when adding new line items. Pre-configured rates include standard EU rates (20%, 19%), reduced rates (10%, 5.5%), zero-rated, exempt, reverse charge, intra-community, and export.

Click **Save** to store your preferences. They persist between sessions.

---

## Creating a New Invoice

Use **File > New Invoice** (Cmd+N) to create a blank invoice.

### Invoice Details (top section)

| Field | Description |
|-------|-------------|
| Invoice Number | Your invoice reference (e.g., INV-2026-001) |
| Invoice Date | Date the invoice is issued |
| Due Date | Payment deadline |
| Note | Optional free-text note printed on the invoice |
| Invoice Type | 380 (Commercial Invoice), 381 (Credit Note), 384 (Corrected), 389 (Self-billed) |
| Currency | EUR, USD, GBP, CHF, and other common currencies |
| Buyer Reference | Purchase order number or buyer's reference |
| Payment Means | Bank transfer (30), SEPA credit (58), card (48), etc. |
| IBAN / BIC | Bank account details for payment |
| Payment Ref | Structured payment reference |

### Seller and Buyer Sections

**Seller (From)** - Pre-filled from your Preferences. Editable on new invoices; locked when opening an existing e-invoice PDF.

**Buyer (To)** - Always editable. Fill in the customer's name, VAT number, address, and contact details. At minimum, **Name** and **Country** are required.

### Adding Line Items

1. Click **Add Item** or use **Invoice > Add Line Item** (Cmd+L)
2. Fill in the editing panel at the bottom of the line items section:
   - **Product**: Item name (required)
   - **Desc**: Optional description
   - **Qty**: Quantity (required, must be > 0)
   - **Unit**: Unit of measure (C62 = piece, HUR = hour, DAY = day, KGM = kg, etc.)
   - **Price**: Unit price (required)
   - **Tax%**: Tax rate percentage
   - **TaxCat**: Tax category (S = Standard, Z = Zero-rated, E = Exempt, AE = Reverse charge, K = Intra-community, G = Export)
3. Click **Save Item** to add it to the list

The **Net Amount** is calculated automatically (Qty x Price).

**To edit a line item**: Select it in the list, click **Edit Item**. The editing panel fills with the item's values. Modify and click **Save Item**.

**To remove a line item**: Select it and click **Remove** or use **Invoice > Remove Line Item**.

### Totals (bottom-right)

Totals are calculated automatically as you add or modify line items:

- **Subtotal**: Sum of all line item net amounts
- **Tax**: Total VAT (grouped by rate and category)
- **Total**: Grand total (subtotal + tax)

---

## Opening an Existing E-Invoice

Use **File > Open** (Cmd+O) to open a Factur-X or ZUGFeRD PDF file.

The app reads the embedded XML data and populates all fields. The **Seller** fields are locked (read-only) since the original issuer's data should not be modified. You can still edit the buyer, line items, and other fields.

---

## Validating an Invoice

Before exporting, validate your invoice to catch errors:

1. Click **Validate** or use **Invoice > Validate** (Cmd+Shift+V)
2. The app checks:
   - Required fields are filled (invoice number, date, seller/buyer name and country)
   - Line items are present (required for BASIC profile and above; not required for MINIMUM and BASIC WL)
   - Each line item has a product name, quantity > 0, and a price
   - IBAN is present when payment means is bank transfer
   - Profile-specific rules (BT business terms) per the selected compliance profile (see **Profile Requirements Guide** below)
   - Totals are consistent (line totals match sum of items, tax totals match breakdowns)
3. Any errors are displayed in a dialog. Fix the issues and validate again.

Validation is **mandatory** before saving or exporting. The app will not allow export of an invalid invoice.

---

## Previewing an Invoice

Click **Preview** (Cmd+Shift+P) to see how your invoice will look as a PDF. The preview window supports:

- Page navigation (thumbnails on the left)
- Zoom in/out
- Save to file
- Print

---

## Saving and Exporting

### Save / Save As (Cmd+S / Cmd+Shift+S)

Saves the invoice as a **Factur-X** PDF (default standard). The app validates the invoice first. If there are errors, they are shown and the save is cancelled.

- **Save**: Overwrites the current file (or prompts for a location if new)
- **Save As**: Always prompts for a new file location

### Export Factur-X / Export ZUGFeRD

Use **File > Export Factur-X** or **File > Export ZUGFeRD** to explicitly choose the e-invoice standard:

- **Factur-X**: French/international standard (embedded CII XML as `factur-x.xml`)
- **ZUGFeRD**: German standard (embedded CII XML as `zugferd-invoice.xml`)

Both standards produce EN 16931 compliant invoices. The XML content is identical; only the filename and metadata differ.

### Compliance Profiles

Select the profile in the bottom-left dropdown:

| Profile | Description |
|---------|-------------|
| MINIMUM | Bare minimum fields (invoice number, date, seller, buyer, total) |
| BASIC WL | Basic without lines (no individual line items required) |
| BASIC | Basic with line items |
| EN 16931 | Full European norm compliance (recommended) |
| EXTENDED | All optional fields supported |

The **EN 16931** profile is recommended for most use cases and is selected by default.

---

## Profile Requirements Guide

Each Factur-X/ZUGFeRD profile defines a different level of detail. Higher profiles include all requirements from lower profiles plus additional fields. This chapter describes exactly what you need to fill in depending on the profile you choose.

### MINIMUM

The bare minimum for a machine-readable invoice. Suitable for simple invoices where only totals matter.

**Required fields:**

| Field | UI Location | BT Reference | Description |
|-------|------------|--------------|-------------|
| Invoice Number | Invoice Details | BT-1 | Your invoice reference |
| Invoice Date | Invoice Details | BT-2 | Date the invoice was issued |
| Invoice Type | Invoice Details | BT-3 | 380 (Invoice), 381 (Credit Note), etc. |
| Currency | Invoice Details | BT-5 | ISO 4217 currency code (EUR, USD, etc.) |
| Seller Name | Seller (From) | BT-27 | Your company name |
| Seller Country | Seller (From) | BT-40 | ISO 3166-1 two-letter country code |
| Buyer Name | Buyer (To) | BT-44 | Customer's company name |
| Buyer Country | Buyer (To) | BT-55 | Customer's country code |
| Tax Breakdown | Automatic | BG-23 | At least one tax group (auto-calculated from line items) |

**Line Items:** Not required. Totals are specified at the header level only.

**What is NOT included in the XML:** Individual line items, payment means, IBAN, seller VAT number (unless VAT applies), buyer reference.

**When to use:** Internal record keeping, simple invoices between trusted partners, or when the visual PDF already contains all details and the XML only needs to carry the minimum structured data.

---

### BASIC WL (Basic Without Lines)

Adds payment information and seller tax registration to the MINIMUM profile, but still **does not include individual line items**.

**Additional required fields** (on top of MINIMUM):

| Field | UI Location | BT Reference | Description |
|-------|------------|--------------|-------------|
| Payment Means | Invoice Details | BT-81 | How the invoice will be paid (bank transfer, SEPA, card, etc.) |
| Seller VAT Number | Seller (From) | BT-31 | Required when standard-rate VAT applies |
| IBAN | Invoice Details | BT-84 | Required when payment means is bank transfer (code 30 or 58) |

**Line Items:** Not required. Tax breakdown amounts and totals are specified at the header level.

**What is NOT included in the XML:** Individual line items (product names, quantities, unit prices). Only header-level totals and tax breakdowns are included.

**When to use:** Invoices where payment details must be machine-readable but line item details are only in the visual PDF. Common in France for Factur-X adoption at the basic level.

> **Note:** When you open a BASIC WL invoice in VNS E-Invoicer, the line items list will be empty. This is normal — the profile does not carry line item data in the XML. An informational message is displayed to explain this.

---

### BASIC

The first profile that includes **individual line items** in the XML data. Each product or service must be listed separately.

**Additional required fields** (on top of BASIC WL):

| Field | UI Location | BT Reference | Description |
|-------|------------|--------------|-------------|
| Line Items | Line Items section | BG-25 | At least one line item is required |

**Per line item, the following fields are required:**

| Field | Column | BT Reference | Description |
|-------|--------|--------------|-------------|
| Line ID | # (auto) | BT-126 | Sequential line number (auto-assigned) |
| Product Name | Product | BT-153 | Name of the product or service |
| Quantity | Qty | BT-129 | Must be greater than zero |
| Unit Price | Price | BT-146 | Price per unit |

**Optional per line item:**

| Field | Column | Description |
|-------|--------|-------------|
| Description | Desc | Additional product description |
| Unit Code | Unit | Unit of measure (C62=piece, HUR=hour, KGM=kg, etc.) |
| Tax Rate | Tax% | VAT rate for this item |
| Tax Category | TaxCat | S=Standard, Z=Zero, E=Exempt, AE=Reverse charge, etc. |

**When to use:** Invoices where the recipient needs machine-readable line item details for automated processing.

---

### EN 16931 (Recommended)

Full compliance with the European Norm EN 16931. This is the **recommended profile** for most use cases and is required for B2G (business-to-government) invoicing in many EU countries.

**Additional required fields** (on top of BASIC):

| Field | UI Location | BT Reference | Description |
|-------|------------|--------------|-------------|
| Buyer Reference | Invoice Details | BT-10 | Purchase order number or buyer's reference code |

**Additional validation rules:**

| Rule | Reference | Description |
|------|-----------|-------------|
| Line totals consistency | BR-CO-10 | Sum of all line item net amounts must equal the sum of tax basis amounts in the tax breakdown |
| Tax calculation | BG-23 | Each tax breakdown must have matching taxable amount and calculated tax |

**When to use:** Official invoices sent to government entities (mandatory in many EU countries), cross-border EU trade, or whenever full EN 16931 compliance is desired.

---

### EXTENDED

Supports all optional fields defined in the Factur-X/ZUGFeRD specification. Currently validated with the same rules as EN 16931, but allows additional metadata in the XML.

**Same requirements as EN 16931**, plus support for additional optional fields such as:
- Delivery information (delivery date, delivery address)
- Additional document references
- Allowances and charges at document and line level
- Additional party identifiers

**When to use:** Complex invoices that need to carry maximum structured data in the XML.

---

### Profile Comparison Summary

| Requirement | MINIMUM | BASIC WL | BASIC | EN 16931 | EXTENDED |
|-------------|:-------:|:--------:|:-----:|:--------:|:--------:|
| Invoice number, date, type, currency | Yes | Yes | Yes | Yes | Yes |
| Seller name + country | Yes | Yes | Yes | Yes | Yes |
| Buyer name + country | Yes | Yes | Yes | Yes | Yes |
| Tax breakdown (at least one) | Yes | Yes | Yes | Yes | Yes |
| Payment means | | Yes | Yes | Yes | Yes |
| Seller VAT (when VAT applies) | | Yes | Yes | Yes | Yes |
| IBAN (for bank transfer) | | Yes | Yes | Yes | Yes |
| Line items (product, qty, price) | | | Yes | Yes | Yes |
| Buyer reference | | | | Yes | Yes |
| Totals consistency check | | | | Yes | Yes |

### Choosing the Right Profile

- **You are just starting with e-invoicing** and want minimal effort: use **BASIC WL**
- **Your customers need line item details** for their accounting systems: use **BASIC** or higher
- **You send invoices to government entities** in the EU: use **EN 16931** (often mandatory)
- **You need maximum interoperability** and compliance: use **EN 16931** (recommended default)
- **You have specific requirements** for additional structured data: use **EXTENDED**

---

## Keyboard Shortcuts

| Action | macOS | Windows/Linux |
|--------|-------|---------------|
| New Invoice | Cmd+N | Ctrl+N |
| Open | Cmd+O | Ctrl+O |
| Save | Cmd+S | Ctrl+S |
| Save As | Cmd+Shift+S | Ctrl+Shift+S |
| Preview | Cmd+Shift+P | Ctrl+Shift+P |
| Preferences | Cmd+, | Edit > Preferences |
| Add Line Item | Cmd+L | Ctrl+L |
| Validate | Cmd+Shift+V | Ctrl+Shift+V |
| Check Folder | File > Check Folder | File > Check Folder |
| Quit | Cmd+Q | Ctrl+Q / Alt+F4 |

---

## Tips

- **Set up Preferences first** to avoid retyping your company details on every invoice.
- **Mark a default tax rate** in Preferences to speed up line item entry.
- **Use Preview** to check your layout before exporting.
- **Unsaved changes**: The app warns you before closing a window with unsaved changes. The title bar shows an asterisk (*) when there are unsaved modifications.
- **Multiple invoices**: Use File > New to open multiple invoice windows simultaneously.
- **Credit notes**: Select invoice type "381 - Credit Note" to create a credit note instead of an invoice.
- **Batch checking**: Use **File > Check Folder** to quickly scan a folder of PDFs and identify which ones are valid e-invoices.

---

## Check Folder

Use **File > Check Folder** to scan an entire folder of PDF files and identify which ones are e-invoices.

### How to Use

1. Select **File > Check Folder**
2. Choose the folder containing your PDF files
3. A results window appears showing all PDFs with their e-invoice status

### Results Columns

| Column | Description |
|--------|-------------|
| Filename | PDF file name |
| E-Invoice | **Yes** if an embedded e-invoice XML was found, **No** otherwise |
| Valid | **Yes** if the invoice passes profile validation, **No** if it fails |
| Signed | **Yes** if the PDF contains a digital signature |
| Self-Signed | **Yes** if the signature uses a self-signed certificate |
| Standard | **Factur-X**, **ZUGFeRD**, **ZUGFeRD 1.0**, or **XRechnung** |
| Profile | Conformance profile: MINIMUM, BASIC WL, BASIC, EN 16931, or EXTENDED |
| Reason | Validation errors (for invalid invoices) or signature details (for valid signed invoices) |

### Color Coding

- **Green text**: Valid e-invoice (passes all validation rules)
- **Red text**: Invalid e-invoice (has validation errors — see the Reason column)
- **Black text**: Not an e-invoice (regular PDF)

### Notes

- ZUGFeRD 1.0 files are detected but not fully supported (the format is obsolete). They appear as "ZUGFeRD 1.0" with an EINV-005 error recommending an upgrade to ZUGFeRD 2.0 or Factur-X.
- The standard (Factur-X vs ZUGFeRD) is detected from the embedded XML filename: `factur-x.xml` for Factur-X, `zugferd-invoice.xml` for ZUGFeRD.
- The Reason column scrolls horizontally to display long validation error messages.

---

## Digital Signatures

### Signing Your Invoices

VNS E-Invoicer can digitally sign exported invoices using PAdES-B-B signatures, which are recognized by Adobe Acrobat and other PDF readers.

1. Open **Preferences** and check **Digitally sign exported invoices**
2. Either browse for an existing certificate and private key (.der files), or click **Generate Self-Signed Certificate** to create one automatically using your company details
3. Optionally set a signing reason (e.g., "E-Invoice Signing") and location
4. Click **Save**

When you export an invoice, the PDF will be digitally signed. A status message confirms signing in the invoice window.

### Signature Verification

When opening an existing signed e-invoice PDF, VNS E-Invoicer displays the signature status:

- **Green text**: "Signed by: [Name] - Integrity verified" means the document has not been modified since signing
- **Red text**: "WARNING: Document may have been tampered with!" means the document content was changed after signing

### Certificate Trust Levels

- **Self-signed certificates**: Show as valid signature structure in Adobe Acrobat, but display a trust warning since the signer is not on Adobe's trusted list. Suitable for internal use and testing.
- **CA-issued certificates**: Certificates from a Certificate Authority on the [Adobe Approved Trust List (AATL)](https://helpx.adobe.com/acrobat/kb/approved-trust-list1.html) will show as fully trusted in Adobe Acrobat.
- **Qualified Electronic Signatures (QES)**: For legal equivalence to handwritten signatures in the EU, use a certificate from a Qualified Trust Service Provider (QTSP) listed on the [EU Trusted List](https://eidas.ec.europa.eu/efda/tl-browser/).

---

## Sample E-Invoices for Testing

You can download sample Factur-X and ZUGFeRD e-invoice PDFs from these sources to test with VNS E-Invoicer:

### Official Sources

- **FeRD (Forum elektronische Rechnung Deutschland)**
  https://www.ferd-net.de/download-zugferd
  Official ZUGFeRD 2.4 information packages (German and English) with sample invoices in various profiles.

- **FNFE-MPE (Forum National de la Facture Electronique)**
  https://fnfe-mpe.org/factur-x/factur-x_en/
  Official Factur-X 1.08 / ZUGFeRD 2.4 specification and sample files.

- **PDFlib Sample Invoices**
  https://www.pdflib.com/pdf-knowledge-base/zugferd-and-factur-x/
  Downloadable ZUGFeRD 1.0, ZUGFeRD 2.0, and Factur-X sample invoice PDFs.

### Community Repositories

- **ZUGFeRD corpus (GitHub)**
  https://github.com/ZUGFeRD/corpus
  Large collection of ZUGFeRD 1.0 and 2.0 test invoices including valid and intentionally invalid samples.

- **Mustang Project (GitHub)**
  https://github.com/ZUGFeRD/mustangproject
  Open-source Java library for ZUGFeRD/Factur-X with test PDF samples in the repository.

### Validators (upload your own invoices to check compliance)

- **ZUGFeRD Community Validator**
  https://www.zugferd-community.net/en/open_community/validation
  Free online validation of ZUGFeRD/Factur-X invoices.

- **Mustang Project Validator**
  https://www.mustangproject.org/
  Open-source command-line and Java library for validating ZUGFeRD/Factur-X and XRechnung invoices.

- **KoSIT Validator (Germany)**
  https://github.com/itplr-kosit/validator
  Official German XML validation engine for XRechnung and ZUGFeRD.

---

## Supported Standards

- **Factur-X** v1.0 (FNFE-MPE, France)
- **ZUGFeRD** v2.x (FeRD, Germany)
- **EN 16931** European e-invoicing norm
- **PDF/A-3b** archival compliance with embedded XML attachment

---

*VNS E-Invoicer is built with the VNS FPDF Library for Xojo.*
*Copyright VeryniceSW. All rights reserved.*
