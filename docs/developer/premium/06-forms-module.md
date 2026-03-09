# VNSPDFFormsPremium Module

**Status**: ✅ Available
**Location**: `PDF_Library/Premium/FormsModule/VNSPDFFormsPremium.xojo_code`
**Module Flag**: `hasPremiumVNSFormsModule`

---

## Activation

### Step 1: Add the Module Files to Your Project

In the Xojo IDE, create a `Premium` folder inside the `PDF_Library` folder of your project (if it does not already exist), then create a `FormsModule` subfolder inside it. Drag the following file into that folder:

- `VNSPDFFormsPremium.xojo_code`

### Step 2: Enable the Module Flag

Open `PDF_Library/VNSPDFModule.xojo_code` and set the following constant to `True`:

```xojo
hasPremiumVNSFormsModule = True
```

This constant is set to `False` by default. The library checks this flag at runtime to determine whether PDF AcroForms features are available. If the flag is `False`, form-related methods will not be functional.

---

## Overview

The Premium Forms module provides PDF AcroForms (interactive forms) support, allowing you to create fillable PDF documents with standard form controls. It uses Xojo's native `PDFControl` classes directly, making the API familiar and easy to use.

---

## Features

- **Text Fields** (`PDFTextField`): Single-line text input with optional password masking, max character limit, and spell checking
- **Text Areas** (`PDFTextArea`): Multi-line text input with configurable font size
- **Checkboxes** (`PDFCheckBox`): Toggle controls with custom caption and initial state
- **Radio Buttons** (`PDFRadioButton`): Grouped options with automatic parent/child structure and mutual exclusivity
- **Push Buttons** (`PDFButton`): Clickable buttons with ResetForm, SendForm, SendPDFFile, and URI actions
- **Combo Boxes** (`PDFComboBox`): Drop-down selection with editable text
- **List Boxes** (`PDFListBox`): Scrollable selection list
- **Popup Menus** (`PDFPopupMenu`): Drop-down selection (non-editable)
- **Signature Fields** (`PDFSignature`): Placeholder fields for digital signatures

### Additional Capabilities

- Automatic AcroForm dictionary generation
- Text field appearance streams for pre-filled values
- Page-aware field placement (0 = current page, or specify page number)
- Coordinate conversion (Xojo top-left origin to PDF bottom-left origin)
- Radio button grouping with parent/child PDF object structure
- PDF string escaping for special characters

---

## Usage

### Basic Example

```xojo
Dim pdf As New VNSPDFDocument()

// Text field
Dim nameField As New PDFTextField(1, 50, 700, 200, 20, "userName")
nameField.Text = "John Doe"
nameField.FontSize = 12
pdf.AddControl(nameField)

// Checkbox
Dim agreeBox As New PDFCheckBox(1, 50, 650, 20, 20, "agree")
agreeBox.Caption = "I agree to the terms"
agreeBox.Value = True
pdf.AddControl(agreeBox)

// Combo box
Dim countryCombo As New PDFComboBox(1, 50, 600, 200, 20, "country")
countryCombo.AddRow("France")
countryCombo.AddRow("Germany")
countryCombo.AddRow("United States")
pdf.AddControl(countryCombo)

pdf.Save(outputFile)
```

### Radio Button Groups

Radio buttons with the same group name are automatically linked:

```xojo
Dim radio1 As New PDFRadioButton(1, 50, 500, 15, 15, "gender")
radio1.Caption = "Male"
radio1.Value = True  // Selected by default
pdf.AddControl(radio1)

Dim radio2 As New PDFRadioButton(1, 50, 480, 15, 15, "gender")
radio2.Caption = "Female"
pdf.AddControl(radio2)
```

### Push Button with URL Action

```xojo
Dim btn As New PDFButton(1, 50, 400, 120, 30, "visitSite")
btn.Caption = "Visit Website"
btn.URL = "https://example.com"
pdf.AddControl(btn)
```

### Signature Field Placeholder

```xojo
Dim sig As New PDFSignature(1, 50, 300, 200, 50, "signature1")
pdf.AddControl(sig)
```

---

## API Reference

### Public Methods (Extends VNSPDFDocument)

#### AddControl
```xojo
Sub AddControl(Extends doc As VNSPDFDocument, control As PDFControl)
```
Adds a PDF form control to the document. Accepts any Xojo `PDFControl` subclass (`PDFTextField`, `PDFTextArea`, `PDFCheckBox`, `PDFRadioButton`, `PDFButton`, `PDFComboBox`, `PDFListBox`, `PDFPopupMenu`, `PDFSignature`).

**Parameters**:
- `control` - A Xojo `PDFControl` instance with position, size, and field-specific properties set

**Notes**:
- Page 0 is interpreted as "current page"
- Field data is stored internally and rendered during PDF output
- Radio buttons with the same `Name` are automatically grouped

#### HasFormFields
```xojo
Function HasFormFields(Extends doc As VNSPDFDocument) As Boolean
```
Returns `True` if the document has any form fields added via `AddControl`.

#### FormFieldCount
```xojo
Function FormFieldCount(Extends doc As VNSPDFDocument) As Integer
```
Returns the number of form fields in the document.

#### GetVersionString
```xojo
Function GetVersionString() As String
```
Returns the module version string.

---

## Supported Control Types

| Xojo Class | PDF Field Type | Key Properties |
|------------|---------------|----------------|
| `PDFTextField` | Text | Text, Password, ReadOnly, MaximumCharactersAllowed, AllowSpellChecking |
| `PDFTextArea` | Text (multiline) | Text, FontSize |
| `PDFCheckBox` | CheckBox | Caption, Value (Boolean) |
| `PDFRadioButton` | RadioButton | Caption, Value (Boolean), Name (group) |
| `PDFButton` | PushButton | Caption, URL |
| `PDFComboBox` | Choice (combo) | Rows (AddRow), InitialValue |
| `PDFListBox` | Choice (list) | Rows (AddRow), InitialValue |
| `PDFPopupMenu` | Choice (popup) | Rows (AddRow), InitialValue |
| `PDFSignature` | Signature | (placeholder only) |

---

## Internal Architecture

The module uses `Extends` methods on `VNSPDFDocument` so the API feels native:

1. `AddControl` extracts properties from the Xojo `PDFControl` into a `Dictionary`
2. Field dictionaries are stored in the document's internal form fields array
3. During PDF output, `PutFormFields` generates PDF objects for each field type
4. `PutAcroForm` creates the `/AcroForm` dictionary referencing all field objects
5. Radio buttons are grouped automatically by field name using parent/child objects

### PDF Object Generation

Each field type has a dedicated generator:
- `PutTextField` - Text fields and text areas
- `PutCheckBox` - Checkboxes with black border + checkmark appearance (matches Xojo native style)
- `PutRadioButtonGroup` + `PutRadioButtonWidget` - Grouped radio buttons
- `PutButton` - Push buttons with ResetForm, SendForm, SendPDFFile, and URI actions
- `BuildActionDictionary` - Shared action generation for buttons and checkboxes
- `PutChoiceField` - Combo boxes, list boxes, popup menus
- `PutSignatureField` - Signature placeholders

---

## Example

See **Example 24** in `VNSPDFExamplesModule.xojo_code` for a complete demonstration of all 9 control types on a single form page.

---

*Part of the Xojo FPDF Premium Module collection.*
