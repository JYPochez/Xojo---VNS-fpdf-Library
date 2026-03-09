# VNSPDFEInvoicePremium Module

**Status**: ✅ Available
**Location**: `PDF_Library/Premium/EInvoiceModule/`
**Module Flag**: `hasPremiumVNSEInvoiceModule`

---

## Activation

### Step 1: Add the Module Files to Your Project

In the Xojo IDE, create a `Premium` folder inside the `PDF_Library` folder of your project (if it does not already exist), then create an `EInvoiceModule` subfolder inside it. Drag the following files into that folder:

- `VNSPDFEInvoicePremium.xojo_code` — Main module (create, read, validate)
- `VNSPDFEInvoice.xojo_code` — Invoice data model
- `VNSPDFEInvoiceParty.xojo_code` — Seller/buyer party data model
- `VNSPDFEInvoiceLineItem.xojo_code` — Line item data model
- `VNSPDFEInvoiceTaxBreakdown.xojo_code` — Tax breakdown data model
- `VNSPDFEInvoiceXMLGenerator.xojo_code` — CII XML generator (write direction)
- `VNSPDFEInvoiceXMLParser.xojo_code` — CII XML parser (read direction)
- `VNSPDFEInvoiceValidator.xojo_code` — Profile-aware validation

### Step 2: Enable the Module Flag

Open `PDF_Library/VNSPDFModule.xojo_code` and set the following constant to `True`:

```xojo
hasPremiumVNSEInvoiceModule = True
```

This constant is set to `False` by default. The library checks this flag at runtime to determine whether e-invoice features are available.

---

## Overview

The E-Invoice Premium Module provides full Factur-X and ZUGFeRD electronic invoicing capabilities for EU-compliant B2B invoicing. It supports both **creating** e-invoice PDFs with embedded CII XML and **reading** existing PDFs to extract and validate their e-invoice data.

### EU ViDA Mandate

The EU Value in Digital Age (ViDA) directive mandates structured electronic invoicing for B2B transactions starting 2026-2027. Factur-X (France/EU) and ZUGFeRD (Germany) are the primary hybrid PDF standards, combining human-readable PDF with machine-readable CII XML.

### Supported Standards

| Standard | Version | XML Format | Filename |
|----------|---------|------------|----------|
| Factur-X | 1.0 | UN/CEFACT CII | `factur-x.xml` |
| ZUGFeRD | 2.0 | UN/CEFACT CII | `zugferd-invoice.xml` |

### Conformance Profiles

| Profile | Level | Line Items | Description |
|---------|-------|------------|-------------|
| MINIMUM | 0 | No | Basic invoice identification only |
| BASIC WL | 1 | No | Without line items, payment details required |
| BASIC | 2 | Yes | Line items with product/quantity/price |
| EN 16931 | 3 | Yes | Full EU standard compliance (recommended) |
| EXTENDED | 4 | Yes | Additional fields beyond EN 16931 |

---

## Features

### Creating E-Invoice PDFs

- Generate Factur-X or ZUGFeRD compliant PDF/A-3b documents
- Embedded CII (CrossIndustryInvoice) XML per EN 16931
- Self-contained PDF/A-3b: sRGB ICC output intent, XMP metadata with extension schemas
- Profile-aware validation before generation (rejects invalid invoices)
- No dependency on the PDF/A premium module

### Reading E-Invoice PDFs (ReadEInvoice)

- Open any PDF file and check if it contains a valid Factur-X/ZUGFeRD e-invoice
- Extract embedded CII XML from PDF catalog structure
- Parse XML into structured invoice data model
- Validate against detected profile
- Return complete results as JSON with error codes and warnings
- Detect common XML format issues (comma decimals, invalid dates, wrong currency codes)
- **Digital signature detection**: find PDF signatures (PAdES), verify hash integrity, check certificate info
- Report signer name, reason, location, date, filter/subfilter, field name
- SHA-256 hash verification (signatureValid) and whole-file coverage check
- X.509 certificate subject/issuer extraction and self-signed detection

---

## Usage

### Creating a Factur-X Invoice

```xojo
// 1. Create invoice data
Dim invoice As New VNSPDFEInvoice
invoice.InvoiceNumber = "INV-2026-001"
invoice.InvoiceDate = New DateTime(2026, 2, 14)
invoice.DueDate = New DateTime(2026, 3, 14)
invoice.Currency = "EUR"
invoice.InvoiceTypeCode = "380"
invoice.BuyerReference = "PO-2026-042"
invoice.PaymentMeansCode = "30"
invoice.IBAN = "FR7630001007941234567890185"
invoice.BIC = "BNPAFRPP"

// 2. Set seller
Dim seller As New VNSPDFEInvoiceParty
seller.Name = "Acme Corp"
seller.VATNumber = "FR12345678901"
seller.AddressLine1 = "123 Main Street"
seller.City = "Paris"
seller.PostalCode = "75001"
seller.CountryCode = "FR"
invoice.Seller = seller

// 3. Set buyer
Dim buyer As New VNSPDFEInvoiceParty
buyer.Name = "Client Ltd"
buyer.VATNumber = "DE987654321"
buyer.AddressLine1 = "456 Oak Avenue"
buyer.City = "Berlin"
buyer.PostalCode = "10115"
buyer.CountryCode = "DE"
invoice.Buyer = buyer

// 4. Add line items
Dim item1 As New VNSPDFEInvoiceLineItem
item1.LineID = "1"
item1.ProductName = "Consulting Services"
item1.Quantity = 10
item1.UnitCode = "HUR"
item1.UnitPrice = 150.00
item1.NetAmount = 1500.00
item1.TaxRate = 20.0
item1.TaxCategoryCode = VNSPDFEInvoicePremium.eTaxCategoryCode.StandardRate
invoice.AddLineItem(item1)

// 5. Add tax breakdown
Dim tax As New VNSPDFEInvoiceTaxBreakdown
tax.TaxableAmount = 1500.00
tax.TaxAmount = 300.00
tax.TaxRate = 20.0
tax.TaxCategoryCode = VNSPDFEInvoicePremium.eTaxCategoryCode.StandardRate
invoice.AddTaxBreakdown(tax)

// 6. Set totals
invoice.LineTotalAmount = 1500.00
invoice.TaxTotalAmount = 300.00
invoice.GrandTotalAmount = 1800.00

// 7. Create PDF and embed e-invoice
Dim pdf As New VNSPDFDocument
pdf.SetFont("Helvetica", "", 12)
pdf.Cell(0, 10, "Invoice INV-2026-001")
// ... add visual invoice layout ...

VNSPDFEInvoicePremium.CreateFacturXInvoice(pdf, invoice, _
    VNSPDFEInvoicePremium.eFacturXProfile.EN16931)

pdf.Save("invoice_facturx.pdf")
```

### Creating a ZUGFeRD Invoice

```xojo
// Same invoice data setup as above, then:
VNSPDFEInvoicePremium.CreateZUGFeRDInvoice(pdf, invoice, _
    VNSPDFEInvoicePremium.eFacturXProfile.EN16931)
```

### Reading an E-Invoice PDF

```xojo
// Read from file path
Dim result As JSONItem = VNSPDFEInvoicePremium.ReadEInvoice("/path/to/invoice.pdf")

// Or read from in-memory data
Dim pdfData As String = myBinaryStream.Read(myBinaryStream.Length)
Dim result As JSONItem = VNSPDFEInvoicePremium.ReadEInvoiceFromData(pdfData)

// Check result using type-safe enum keys
Dim k As VNSPDFEInvoicePremium.eInvoiceJSONKey  // shorthand alias

If result.Value(k.Valid.ToString) = True Then
  Dim invoiceJSON As JSONItem = result.Value(k.Invoice.ToString)
  Dim invoiceNumber As String = invoiceJSON.Value(k.InvoiceNumber.ToString)
  Dim grandTotal As String = invoiceJSON.Value(k.GrandTotalAmount.ToString)
  Dim standard As String = result.Value(k.Standard.ToString)   // "Factur-X" or "ZUGFeRD"
  Dim profile As String = result.Value(k.Profile.ToString)      // "EN 16931", etc.
  Dim warningCount As Integer = result.Value(k.WarningCount.ToString)
Else
  Dim errorCode As String = result.Value(k.ErrorCode.ToString)  // "EINV-001", etc.
  Dim errorMsg As String = result.Value(k.Error.ToString)
End If
```

### Reading Signature Info from E-Invoice PDFs

```xojo
Dim result As JSONItem = VNSPDFEInvoicePremium.ReadEInvoice("/path/to/signed_invoice.pdf")
Dim k As VNSPDFEInvoicePremium.eInvoiceJSONKey

Dim sigCount As Integer = result.Value(k.SignatureCount.ToString)
If sigCount > 0 Then
  Dim sigs As JSONItem = result.Value(k.Signatures.ToString)
  For i As Integer = 0 To sigs.Count - 1
    Dim sig As JSONItem = sigs.ChildAt(i)
    Dim signer As String = sig.Value(k.SignerName.ToString)
    Dim valid As Boolean = sig.Value(k.SignatureValid.ToString)
    Dim covers As Boolean = sig.Value(k.SignatureCoversWholeFile.ToString)
    Dim selfSigned As Boolean = sig.Value(k.SelfSigned.ToString)
    // Display or process signature info...
  Next
End If
```

### Checking Module Availability

```xojo
If hasPremiumVNSEInvoiceModule Then
  // E-Invoice features available
  VNSPDFEInvoicePremium.CreateFacturXInvoice(pdf, invoice, profile)
End If
```

---

## ReadEInvoice JSON Output

### Conformant Invoice

```json
{
  "valid": true,
  "errorCode": "EINV-000",
  "error": "",
  "standard": "Factur-X",
  "profile": "EN 16931",
  "invoice": {
    "invoiceNumber": "INV-2026-001",
    "invoiceDate": "2026-02-14",
    "dueDate": "2026-03-14",
    "currency": "EUR",
    "invoiceTypeCode": "380",
    "buyerReference": "PO-2026-042",
    "paymentMeansCode": "30",
    "iban": "FR7630001007941234567890185",
    "bic": "BNPAFRPP",
    "paymentReference": "",
    "note": "",
    "seller": {
      "name": "Acme Corp",
      "vatNumber": "FR12345678901",
      "addressLine1": "123 Main Street",
      "city": "Paris",
      "postalCode": "75001",
      "countryCode": "FR"
    },
    "buyer": {
      "name": "Client Ltd",
      "vatNumber": "DE987654321",
      "addressLine1": "456 Oak Avenue",
      "city": "Berlin",
      "postalCode": "10115",
      "countryCode": "DE"
    },
    "lineItems": [
      {
        "lineID": "1",
        "productName": "Consulting Services",
        "quantity": 10.0,
        "unitCode": "HUR",
        "unitPrice": "150",
        "netAmount": "1500",
        "taxRate": "20",
        "taxCategoryCode": "S"
      }
    ],
    "taxBreakdowns": [
      {
        "taxableAmount": "1500",
        "taxAmount": "300",
        "taxRate": "20",
        "taxCategoryCode": "S"
      }
    ],
    "lineTotalAmount": "1500",
    "taxTotalAmount": "300",
    "grandTotalAmount": "1800"
  },
  "warnings": [],
  "warningCount": 0,
  "signatureCount": 1,
  "signatures": [
    {
      "signerName": "C=FR, O=VeryniceSW, CN=VNS PDF Test Signer",
      "signingReason": "E-Invoice Signing",
      "signingLocation": "Paris, France",
      "signingDate": "D:20260214120000+00'00'",
      "signatureFilter": "Adobe.PPKLite",
      "signatureSubFilter": "ETSI.CAdES.detached",
      "signatureFieldName": "Signature1",
      "signatureValid": true,
      "signatureCoversWholeFile": true,
      "certificateSubject": "C=FR, O=VeryniceSW, CN=VNS PDF Test Signer",
      "certificateIssuer": "C=FR, O=VeryniceSW, CN=VNS PDF Test Signer",
      "selfSigned": true
    }
  ]
}
```

### Non-Conformant Result

```json
{
  "valid": false,
  "errorCode": "EINV-002",
  "error": "EINV-002 No embedded XML attachment found",
  "standard": "",
  "profile": ""
}
```

---

## Error Codes

| Code | Constant | Description |
|------|----------|-------------|
| EINV-000 | `kErrCodeNoError` | No error, invoice is conformant |
| EINV-001 | `kErrCodeInvalidPDF` | PDF failed to open or parse |
| EINV-002 | `kErrCodeNoXMLAttachment` | No embedded e-invoice XML found in PDF |
| EINV-003 | `kErrCodeXMLParseFailed` | CII XML content could not be parsed into invoice model |
| EINV-004 | `kErrCodeValidationFailed` | Invoice parsed but failed profile validation |
| EINV-005 | `kErrCodeZUGFeRD1Obsolete` | ZUGFeRD 1.0 detected (obsolete, unsupported) |

All error code constants are **Public** scope, accessible as `VNSPDFEInvoicePremium.kErrCodeNoError`, etc.

---

## XML Validation Warnings

ReadEInvoice performs additional XML-level format checks and returns warnings (non-blocking issues). Warnings are included in the JSON result even when `valid` is `true`.

### Numeric Format Warnings

| Code | Description |
|------|-------------|
| EINV-W01 | Comma used as decimal separator instead of dot (auto-corrected) |
| EINV-W02 | Thousand separator or spaces in number (auto-corrected) |
| EINV-W03 | Currency symbol embedded in numeric value (auto-corrected) |
| EINV-W04 | Value cannot be parsed as a valid number |

### Date Format Warnings

| Code | Description |
|------|-------------|
| EINV-W10 | Date format code is not 102 (YYYYMMDD) |
| EINV-W11 | Date contains separators, wrong length, or non-numeric characters |
| EINV-W12 | Date has invalid month, day, or unusual year |

### Code Validation Warnings

| Code | Description |
|------|-------------|
| EINV-W20 | Currency code is not 3 characters or not uppercase (ISO 4217) |
| EINV-W21 | Currency code is not a commonly used ISO 4217 currency |
| EINV-W22 | Country code is not 2 characters or not uppercase (ISO 3166-1) |

### Business Logic Warnings

| Code | Description |
|------|-------------|
| EINV-W30 | Invoice type code is not a recognized UN/CEFACT code |
| EINV-W31 | Negative due payable amount on a standard invoice (type 380) |
| EINV-W40 | Missing required CII XML structure element |

---

## API Reference

### VNSPDFEInvoicePremium (Main Module)

```xojo
// Create e-invoice PDFs
Sub CreateFacturXInvoice(doc As VNSPDFDocument, invoice As VNSPDFEInvoice, _
    profile As eFacturXProfile)
Sub CreateZUGFeRDInvoice(doc As VNSPDFDocument, invoice As VNSPDFEInvoice, _
    profile As eFacturXProfile)

// Read e-invoice PDFs
Function ReadEInvoice(filePath As String) As JSONItem
Function ReadEInvoiceFromData(pdfData As String) As JSONItem

// Utility
Function GetVersionString() As String

// Profile enum
Enum eFacturXProfile
  Minimum = 0
  BasicWL = 1
  Basic = 2
  EN16931 = 3
  Extended = 4
End Enum

// Tax category codes (UNTDID 5305)
Enum eTaxCategoryCode
  StandardRate = 0       // "S" - Standard VAT rate
  ZeroRated = 1          // "Z" - Zero-rated goods/services
  Exempt = 2             // "E" - VAT exempt
  ReverseCharge = 3      // "AE" - Reverse charge (B2B cross-border)
  IntraCommunitySupply = 4  // "K" - Intra-community supply (EU)
  ExportOutsideEU = 5    // "G" - Export outside EU (free of VAT)
  OutsideScopeOfVAT = 6  // "O" - Outside scope of VAT
  CanaryIslandsTax = 7   // "L" - Canary Islands IGIC tax
  CeutaMelillaTax = 8    // "M" - Ceuta and Melilla IPSI tax
End Enum

// Enum extension methods (defined in VNSPDFEInvoicePremium module scope)

// eInvoiceJSONKey — type-safe JSON key access for ReadEInvoice results
Enum eInvoiceJSONKey
  // Result-level keys (0-7)
  Valid = 0, ErrorCode = 1, Error = 2, Standard = 3, Profile = 4
  Invoice = 5, Warnings = 6, WarningCount = 7
  // Invoice-level keys (10-27)
  InvoiceNumber = 10, InvoiceDate = 11, DueDate = 12, Currency = 13
  InvoiceTypeCode = 14, BuyerReference = 15, PaymentMeansCode = 16
  IBAN = 17, BIC = 18, PaymentReference = 19, Note = 20, Seller = 21
  Buyer = 22, LineItems = 23, TaxBreakdowns = 24, LineTotalAmount = 25
  TaxTotalAmount = 26, GrandTotalAmount = 27
  // Party-level keys (30-40)
  Name = 30, VATNumber = 31, LegalRegistrationID = 32, AddressLine1 = 33
  AddressLine2 = 34, City = 35, PostalCode = 36, CountryCode = 37
  ContactName = 38, ContactEmail = 39, ContactPhone = 40
  // Line item-level keys (50-58)
  LineID = 50, ProductName = 51, ProductDescription = 52, Quantity = 53
  UnitCode = 54, UnitPrice = 55, NetAmount = 56, TaxRate = 57
  TaxCategoryCode = 58
  // Tax breakdown-level keys (60-61)
  TaxableAmount = 60, TaxAmount = 61
  // Signature-level keys (70-83)
  Signatures = 70, SignatureCount = 71, SignerName = 72, SigningReason = 73
  SigningLocation = 74, SigningDate = 75, SignatureFilter = 76
  SignatureSubFilter = 77, SignatureCoversWholeFile = 78
  SignatureFieldName = 79, SignatureValid = 80, SelfSigned = 81
  CertificateSubject = 82, CertificateIssuer = 83
End Enum
Function ToString(Extends key As eInvoiceJSONKey) As String    // enum → JSON key string
Function ToEInvoiceJSONKey(Extends key As String) As eInvoiceJSONKey  // JSON key string → enum

// eTaxCategoryCode — UNTDID 5305 VAT category codes
Function ToString(Extends code As eTaxCategoryCode) As String   // enum → XML code ("S", "AE", etc.)
Function ToTaxCategory(Extends code As String) As eTaxCategoryCode  // XML code → enum

// eFacturXProfile — conformance profile conversion
Function ToString(Extends profile As eFacturXProfile) As String  // enum → conformance level string
Function ToFacturXProfile(Extends profile As String) As eFacturXProfile  // string → enum

// Error code constants (Public)
Const kErrCodeNoError = "EINV-000"
Const kErrCodeInvalidPDF = "EINV-001"
Const kErrCodeNoXMLAttachment = "EINV-002"
Const kErrCodeXMLParseFailed = "EINV-003"
Const kErrCodeValidationFailed = "EINV-004"
Const kErrCodeZUGFeRD1Obsolete = "EINV-005"

// Standard filenames (Public)
Const kFacturXFilename = "factur-x.xml"
Const kZUGFeRDFilename = "zugferd-invoice.xml"
```

### VNSPDFEInvoice (Data Model)

```xojo
// Invoice identification
Property InvoiceNumber As String
Property InvoiceDate As DateTime
Property DueDate As DateTime
Property InvoiceTypeCode As String       // "380" = Invoice, "381" = Credit note
Property Currency As String              // ISO 4217 (e.g. "EUR")

// References
Property BuyerReference As String
Property PaymentReference As String
Property Note As String

// Payment
Property PaymentMeansCode As String      // "30" = Credit transfer, "42" = Payment to bank account
Property IBAN As String
Property BIC As String

// Parties
Property Seller As VNSPDFEInvoiceParty
Property Buyer As VNSPDFEInvoiceParty

// Totals
Property LineTotalAmount As Double
Property TaxTotalAmount As Double
Property GrandTotalAmount As Double

// Collections
Sub AddLineItem(item As VNSPDFEInvoiceLineItem)
Sub AddTaxBreakdown(tb As VNSPDFEInvoiceTaxBreakdown)
Function LineItems() As VNSPDFEInvoiceLineItem()
Function TaxBreakdowns() As VNSPDFEInvoiceTaxBreakdown()
```

### VNSPDFEInvoiceParty

```xojo
Property Name As String
Property VATNumber As String
Property LegalRegistrationID As String
Property AddressLine1 As String
Property AddressLine2 As String
Property City As String
Property PostalCode As String
Property CountryCode As String           // ISO 3166-1 alpha-2 (e.g. "FR")
Property ContactName As String
Property ContactEmail As String
Property ContactPhone As String
```

### VNSPDFEInvoiceLineItem

```xojo
Property LineID As String
Property ProductName As String
Property ProductDescription As String
Property Quantity As Double
Property UnitCode As String              // UN/ECE Rec 20 (e.g. "HUR", "C62", "KGM")
Property UnitPrice As Double
Property NetAmount As Double
Property TaxRate As Double
Property TaxCategoryCode As VNSPDFEInvoicePremium.eTaxCategoryCode
```

### VNSPDFEInvoiceTaxBreakdown

```xojo
Property TaxableAmount As Double
Property TaxAmount As Double
Property TaxRate As Double
Property TaxCategoryCode As VNSPDFEInvoicePremium.eTaxCategoryCode
```

### VNSPDFEInvoiceXMLParser

```xojo
// Parse CII XML into data model
Function ParseCII(xmlContent As String) As VNSPDFEInvoice

// Detect standard/profile from XML content
Function DetectStandard(xmlContent As String, xmlFilename As String = "") As String   // "Factur-X", "ZUGFeRD", or "XRechnung"
Function DetectProfile(xmlContent As String) As String     // "EN 16931", "BASIC", "EXTENDED", etc.

// Serialize invoice to JSON
Function InvoiceToJSON(invoice As VNSPDFEInvoice) As JSONItem

// XML validation
Function ValidateXMLContent(xmlContent As String) As String()

// Warnings management
Function GetWarnings() As String()
Sub ClearWarnings()
```

### VNSPDFEInvoiceValidator

```xojo
// Validate invoice against profile requirements
// Returns array of error messages (empty = valid)
Function Validate(invoice As VNSPDFEInvoice, _
    profile As VNSPDFEInvoicePremium.eFacturXProfile) As String()
```

### VNSPDFEInvoiceXMLGenerator

```xojo
// Generate CII XML from invoice data model
Function GenerateCII(invoice As VNSPDFEInvoice, _
    profile As VNSPDFEInvoicePremium.eFacturXProfile, _
    isZUGFeRD As Boolean) As String

// XML utility
Function XmlEscape(text As String) As String
```

---

## Validation Rules by Profile

### MINIMUM (all profiles)

- BT-1: Invoice number is required
- BT-2: Invoice issue date is required
- BT-3: Invoice type code is required
- BT-5: Currency code is required (3 characters, ISO 4217)
- BG-4: Seller party is required (BT-27: name, BT-40: country code)
- BG-7: Buyer party is required (BT-44: name, BT-55: country code)
- BG-23: At least one tax breakdown is required

### BASIC WL (adds to MINIMUM)

- BT-81: Payment means code is required
- BT-31: Seller VAT number required when VAT applies

### BASIC (adds to BASIC WL)

- BG-25: At least one line item is required
- BT-126: Line ID is required for each line item
- BT-153: Product name is required for each line item
- BT-129: Quantity must be positive

### EN 16931 (adds to BASIC)

- BT-10: Buyer reference is required
- BR-CO-10: Sum of line totals must equal sum of tax basis amounts

---

## Tax Category Codes (UNTDID 5305)

The `eTaxCategoryCode` enum represents VAT category codes from the UN/EDIFACT Data Element 5305 standard, used in Factur-X/ZUGFeRD invoices for both line items and tax breakdowns.

| Enum Value | XML Code | Description | When to Use |
|------------|----------|-------------|-------------|
| `StandardRate` | S | Standard VAT rate | Most common — goods/services subject to normal VAT (e.g. 20% FR, 19% DE) |
| `ZeroRated` | Z | Zero-rated | Taxable but rate is 0% (e.g. UK zero-rated food, children's clothing) |
| `Exempt` | E | VAT exempt | Exempt by law (e.g. medical, education, insurance) |
| `ReverseCharge` | AE | Reverse charge | B2B cross-border within EU — buyer self-assesses VAT |
| `IntraCommunitySupply` | K | Intra-community supply | Supply of goods between EU member states |
| `ExportOutsideEU` | G | Export outside EU | Goods exported outside EU — free of VAT |
| `OutsideScopeOfVAT` | O | Outside scope of VAT | Transaction not subject to VAT at all |
| `CanaryIslandsTax` | L | Canary Islands tax | IGIC tax (Impuesto General Indirecto Canario) |
| `CeutaMelillaTax` | M | Ceuta and Melilla tax | IPSI tax (Impuesto sobre la Producción, los Servicios y la Importación) |

### Usage Example

```xojo
// Set tax category on a line item
Dim item As New VNSPDFEInvoiceLineItem
item.TaxCategoryCode = VNSPDFEInvoicePremium.eTaxCategoryCode.StandardRate
item.TaxRate = 20.0

// Set tax category on a tax breakdown
Dim tax As New VNSPDFEInvoiceTaxBreakdown
tax.TaxCategoryCode = VNSPDFEInvoicePremium.eTaxCategoryCode.StandardRate
tax.TaxRate = 20.0

// Convert enum to XML string code using extension method
Dim code As String = VNSPDFEInvoicePremium.eTaxCategoryCode.ReverseCharge.ToString
// Returns "AE"

// Convert XML string code to enum using extension method
Dim enumVal As VNSPDFEInvoicePremium.eTaxCategoryCode = "AE".ToTaxCategory
// Returns eTaxCategoryCode.ReverseCharge

// Profile enum to string conversion
Dim profileStr As String = VNSPDFEInvoicePremium.eFacturXProfile.EN16931.ToString
// Returns "EN 16931"

// String to profile enum conversion
Dim profileEnum As VNSPDFEInvoicePremium.eFacturXProfile = "EN 16931".ToFacturXProfile
// Returns eFacturXProfile.EN16931
```

### Common Scenarios

- **Domestic B2B invoice**: Use `StandardRate` with your country's VAT rate
- **Export to non-EU country**: Use `ExportOutsideEU` with rate 0.0
- **EU cross-border B2B**: Use `ReverseCharge` with rate 0.0 (buyer accounts for VAT)
- **EU intra-community goods**: Use `IntraCommunitySupply` with rate 0.0
- **Medical/education services**: Use `Exempt` with rate 0.0

---

## Implementation Details

### PDF/A-3b Compliance

CreateFacturXInvoice and CreateZUGFeRDInvoice automatically handle:

1. Embedded CII XML as PDF file attachment with `/AFRelationship /Data`
2. XMP metadata with PDF/A-3b identification (`pdfaid:part=3, conformance=B`)
3. Factur-X or ZUGFeRD extension schema in XMP
4. sRGB ICC output intent (minimal 392-byte profile, self-contained)
5. PDF version set to 1.7

### ReadEInvoice PDF Navigation

The reader navigates the PDF catalog structure:

```
Catalog
  └── /Names
       └── /EmbeddedFiles
            └── /Names array
                 └── [filename, filespec_ref, ...]
                      └── filespec /EF /F → stream → decode → XML
```

Recognized filenames: `factur-x.xml`, `zugferd-invoice.xml`, `xrechnung.xml`

### CII XML Parser

The parser handles both namespaced (`rsm:`, `ram:`, `udt:`) and non-namespaced tag formats. Numeric values with format errors (commas, thousand separators, currency symbols) are auto-corrected during parsing with warnings.

---

## Compatibility

| PDF Reader | Create | Read |
|------------|--------|------|
| Adobe Acrobat | ✅ Full | ✅ Full |
| Preview (macOS) | ✅ Visual | N/A |
| Mustang (Java) | ✅ Tested | ✅ Tested |
| Ghostscript | ✅ Visual | N/A |

---

## Platform Support

| Platform | Create | Read | Notes |
|----------|--------|------|-------|
| Desktop (macOS/Windows/Linux) | ✅ | ✅ | Full support |
| Web | ✅ | ✅ | Full support |
| Console | ✅ | ✅ | Full support |
| iOS | ✅ | ✅ | Requires Premium Zlib for compression |

---

## Examples

- **Example 30**: Creates a Factur-X EN 16931 invoice with visual layout and embedded CII XML
- **Example 31**: Opens any PDF file and checks for Factur-X/ZUGFeRD conformity, displays invoice data as JSON

---

*Last Updated: 2026-02-14* (signature detection added)
