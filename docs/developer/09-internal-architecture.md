# Internal Architecture Details

## Memory Management

- **Dictionaries**: Used for collections (pages, fonts, images, blend modes, gradients) - O(1) lookup
- **MemoryBlocks**: Used for binary data (font files, compressed streams, image data)
- **Strings**: Used for PDF content streams and page buffers
- **Arrays**: Used for ordered collections (gradient list, annotation list, attachment list)

## Page Storage

Pages are stored in a Dictionary with string keys:

```xojo
Private mPages As Dictionary
Private mPageSizes As Dictionary

// Adding a page
mPages.Value(Str(mPageNumber)) = pageContent

// Page dimensions tracked separately
mPageWidthPt, mPageHeightPt  // Current page in points
mCurPageSize As Pair          // Current page size
mPageBreakTrigger As Double   // Auto page break position
```

## State Machine

Document state is tracked internally:

```xojo
Private mState As Integer
// 0 = Nothing created yet
// 1 = Document open
// 2 = Page open
// 3 = Document closed
```

Additional state tracking:
- `mPage` - Current page counter
- `mClipNest` - Clipping path nesting depth
- Graphics state stack for SaveState/RestoreState

## Buffer Management

Content is built in a string buffer:

```xojo
Private mBuffer As String

Sub Append(content As String)
    mBuffer = mBuffer + content
End Sub
```

## Error Handling

First-error-wins pattern:

```xojo
Private mErrorMessage As String = ""

Function Ok() As Boolean
    Return mErrorMessage = ""
End Function

Sub SetError(msg As String)
    If mErrorMessage = "" Then mErrorMessage = msg
End Sub
```

## Premium Module Architecture

Premium modules use compile-time Boolean flags defined in per-project `_Premium_Constants.xojo_code` files (since v1.3). Each platform project (Desktop, Web, iOS, Console) has its own copy so flags can be set independently per target:

```xojo
// In _Premium_Constants.xojo_code (one per project)
Public Const hasPremiumVNSEncryptionModule As Boolean = False
Public Const hasPremiumVNSZlibModule As Boolean = False
Public Const hasPremiumVNSTableModule As Boolean = False
Public Const hasPremiumVNSPDFAModule As Boolean = False
Public Const hasPremiumVNSFormsModule As Boolean = False
Public Const hasPremiumVNSHTMLModule As Boolean = False
Public Const hasPremiumVNSEInvoiceModule As Boolean = False
```

When a premium module is installed, set the corresponding flag to True in each project's `_Premium_Constants.xojo_code`. The core library checks these flags at compile time to enable/disable premium features. This ensures no runtime overhead and clean separation between free and premium code.

## Key Internal Classes

- **VNSPDFPage** - Stores page content, dimensions, and resources
- **VNSPDFBlendMode** - Manages transparency and blend mode ExtGState resources
- **VNSPDFGradient** - Stores gradient shading pattern data (linear, radial, multi-stop)
- **VNSPDFOutputIntent** - Stores PDF/A output intent and ICC color profile data
- **VNSPDFAttachment** - Stores file attachment data (name, content, description)
- **VNSPDFEncryption** - Handles RC4/AES encryption, password derivation, permissions
