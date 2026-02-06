# Contributing

## Naming Conventions (Critical)

- **Classes**: Prefix with `VNS` (e.g., `VNSPDFDocument`) - avoids Xojo framework conflicts
- **Global constants**: `gk` prefix (e.g., `gkA4Width`)
- **Class constants**: `k` prefix (e.g., `kMinimumMargin`)
- **Enums**: `e` prefix (e.g., `ePageOrientation`)
- **Private properties**: `m` prefix (e.g., `mPages`)
- **Public properties**: No prefix
- **Delegates**: Use `#tag DelegateDeclaration`, NOT `#tag Delegate`
- **UI controls**: Meaningful names (e.g., `ButtonGeneratePDF`), NOT type-based (e.g., `Button1`)

## Code Organization

- All PDF logic in `PDF_Library/` - must be platform-independent
- Max **300 lines** per method - split if larger
- Max **30KB** per file - refactor if larger
- **No hardcoded strings** - use constants or localizable strings
- Conditional compilation only for: File I/O, PDF delivery, resource loading, UI text display

## API2 Compliance

All code must use Xojo API2 syntax:
- String: `Len()` -> `.Length`, `Mid()` -> `.Middle()`, `InStr()` -> `.IndexOf()`
- Arrays: `.Ubound` -> `.LastIndex`, `.Append()` -> `.Add()`
- Graphics: `PenWidth` -> `PenSize`, `DrawString` -> `DrawText`
- Color: `RGB()` -> `Color.RGB()`

## Testing Requirements

1. Test on **all 4 platforms**: Desktop (macOS, Windows, Linux), Web, iOS, Console
2. Test error conditions using Ok()/Err()/GetError() pattern
3. Test boundary cases
4. Be aware of iOS differences:
   - String indexing is **0-based** (not 1-based like Desktop)
   - No system zlib (Premium Zlib module needed)
   - MemoryBlock.StringValue() crashes on large buffers
   - Use JPEG format for images (not PNG)

## Adding New Classes

When creating a new class file:
1. Create the `.xojo_code` file in the appropriate `PDF_Library/` subfolder
2. Add the file reference to **ALL FOUR** `.xojo_project` files with unique hash:
   - `Xojo_fpdf_free.xojo_project` (Desktop)
   - `Xojo_fpdf_web_free.xojo_project` (Web)
   - `Xojo_iospdf_free.xojo_project` (iOS)
   - `xojo_consolepdf_free.xojo_project` (Console)
3. Also add to the premium project files if applicable

## Documentation Requirements

1. Update developer docs for API changes
2. Include usage examples
3. Document parameters and return values
4. Never disable functionality without asking - fix it instead
