# Sample E-Invoices for Testing

23 sample Factur-X and ZUGFeRD e-invoice PDFs for testing with VNS E-Invoicer.
Use **File > Open** to load any of these in the app.

## PDFlib Samples (3 files)

| File | Standard | Profile |
|------|----------|---------|
| `zugferd1_invoice_basic.pdf` | ZUGFeRD 1.0 | BASIC |
| `zugferd2_invoice_basic.pdf` | ZUGFeRD 2.0 | BASIC |
| `facturx_invoice_en16931.pdf` | Factur-X | EN 16931 (with delivery receipt) |

Source: https://www.pdflib.com/pdf-knowledge-base/zugferd-and-factur-x/

## FNFE-MPE Official Factur-X Examples (7 files)

| File | Type | Profile |
|------|------|---------|
| `FNFE_Facture_FR_MINIMUM.pdf` | French invoice | MINIMUM |
| `FNFE_Facture_FR_BASICWL.pdf` | French invoice | BASIC WL |
| `FNFE_Facture_UE_MINIMUM.pdf` | EU invoice | MINIMUM |
| `FNFE_Facture_UE_BASICWL.pdf` | EU invoice | BASIC WL |
| `FNFE_Facture_DOM_MINIMUM.pdf` | DOM-TOM invoice | MINIMUM |
| `FNFE_Facture_DOM_BASICWL.pdf` | DOM-TOM invoice | BASIC WL |
| `FNFE_Avoir_FR_type381_BASIC.pdf` | Credit note (type 381) | BASIC |

Source: https://github.com/ZUGFeRD/corpus (FNFE-factur-x-examples)

## Intarsys ZUGFeRD 2.0 Examples (9 files)

| File | Profile | Description |
|------|---------|-------------|
| `intarsys_MINIMUM.pdf` | MINIMUM | Minimal invoice |
| `intarsys_EN16931_Einfach.pdf` | EN 16931 | Simple invoice |
| `intarsys_EN16931_Gutschrift.pdf` | EN 16931 | Credit note |
| `intarsys_EN16931_Miete.pdf` | EN 16931 | Rent invoice |
| `intarsys_EN16931_Rabatte.pdf` | EN 16931 | Discounts/allowances |
| `intarsys_EN16931_Rechnungskorrektur.pdf` | EN 16931 | Invoice correction |
| `intarsys_EN16931_SEPA.pdf` | EN 16931 | SEPA pre-notification |
| `intarsys_EXTENDED_Warenrechnung.pdf` | EXTENDED | Goods invoice |
| `intarsys_EXTENDED_Fremdwaehrung.pdf` | EXTENDED | Foreign currency |

Source: https://github.com/ZUGFeRD/corpus (intarsys)

## Mustang Project Examples (2 files)

| File | Description |
|------|-------------|
| `Mustang_RE-20190610_507.pdf` | Mustang-generated ZUGFeRD 2.0 invoice |
| `Mustang_RE-20201121_508.pdf` | Mustang-generated ZUGFeRD 2.0 invoice |

Source: https://github.com/ZUGFeRD/corpus (Mustangproject)

## Invalid/Fail Examples (2 files)

These files have known issues and can be used to test error handling:

| File | Issue |
|------|-------|
| `INVALID_ZUGFeRD1and2_mixed.pdf` | Contains both ZUGFeRD 1.0 and 2.0 metadata (invalid) |
| `INVALID_FX_with_UBL.pdf` | Factur-X PDF containing UBL XML instead of CII (wrong format) |

Source: https://github.com/ZUGFeRD/corpus (fail)

## License

These sample files are from public repositories and are provided for testing purposes only.
