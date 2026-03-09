# HtmlToPdf - Free HTML to PDF Converter

A free standalone desktop application that converts HTML files to PDF using the VNS PDF Library.

## Download

Pre-built binaries are available for:
- **macOS** (Universal: Apple Silicon & Intel)
- **Windows** (x86 64-bit)
- **Linux** (x86 64-bit)

A test file `test_all_html_features.html` is included to demonstrate all supported features.

## Usage

1. Launch the application
2. Click **"Choose HTML File and Convert to PDF"**
3. Select your `.html` or `.htm` file
4. The PDF is saved next to your source file with the same name and a `.pdf` extension

Example: selecting `/Documents/report.html` produces `/Documents/report.pdf`

## Supported HTML Features

### Tags
- **Headings**: `<h1>` through `<h6>` with scaled sizes and bold styling
- **Text formatting**: `<b>`, `<i>`, `<u>`, `<s>`, `<sub>`, `<sup>`, `<code>`
- **Block elements**: `<p>`, `<div>`, `<blockquote>`, `<pre>`, `<hr>`, `<br>`
- **Lists**: `<ul>`, `<ol>`, `<li>` (bullets and numbered)
- **Tables**: `<table>`, `<tr>`, `<td>`, `<th>` with headers and cell alignment
- **Images**: base64 data URIs, local file paths, HTTP(S) URLs (auto-downloaded)
- **Links**: `<a href>` with styled text
- **Inline styling**: `<span style="...">` for fine-grained control
- **Legacy**: `<font>` with size, color, face attributes

### CSS Custom Properties (Variables)
```html
<style>
:root {
  --primary-color: #333;
  --card-bg: #f5f5f5;
}
</style>
<div style="color: var(--primary-color); background: var(--card-bg)">
  Styled with CSS variables
</div>
```
- `:root { --name: value; }` with `var(--name)` and `var(--name, fallback)` resolution
- Multiple `:root` blocks supported (theme overrides)
- Works in inline styles, `<style>` blocks, and shorthand properties

### CSS Selectors (`<style>` blocks)
- Class selectors (`.card { ... }`)
- Element selectors (`p { ... }`)
- Element.class selectors (`div.card { ... }`)
- ID selectors (`#header { ... }`)
- Comma-separated selectors (`.card, .url-card { ... }`)
- Merges with inline `style=""` attributes (inline takes precedence)

### Inline CSS Properties
- `color` — text color (hex, RGB, 50+ named colors)
- `font-size` — pt, px, em, %, named sizes (xx-small to xx-large)
- `font-family` — auto-maps to system TrueType or core PDF fonts
- `font-weight` — bold (numeric 100-900)
- `font-style` — italic
- `text-align` — left, center, right, justify
- `text-decoration` — underline, line-through
- `background-color` — cell, inline span, and block backgrounds

### Block-Level CSS (Box Model)
- `width`, `max-width` — px, %, constrains block content area
- `margin` — shorthand (1-4 values) and individual sides; `margin: 0 auto` centering
- `padding` — shorthand and individual sides; font-metrics-based vertical centering
- `border` — all 4 sides with individual color and width (`1px solid #333`)
- `border-radius` — rounded corners on blocks and cards
- `background-color` — block-level fill behind content and borders
- `line-height` — unitless multiplier, px, normal
- `display: none` — hide elements
- `text-transform` — uppercase, lowercase, capitalize

### Special Features
- **130+ HTML entities**: `&amp;`, `&lt;`, `&gt;`, `&copy;`, `&euro;`, Greek letters, math symbols, arrows, and more
- **Unicode**: full international text (Latin, Arabic, Chinese, Japanese, Korean, Cyrillic, Greek, Thai, Hebrew)
- **Emoji**: inline emoji rendering interleaved with text
- **Cross-page layout**: cards with `border-radius` render fully rounded on each page
- **CSS margin collapsing**: font-metrics-based spacing for proper block element gaps

## Font Support

The converter automatically loads the best available font for your platform:
- **macOS**: Arial Unicode MS (full Unicode coverage)
- **Windows**: Arial
- **Linux**: Arial

Falls back to Helvetica (built-in PDF font) if no TrueType font is found.

CSS `font-family` declarations in your HTML are resolved automatically: system TrueType fonts are loaded on demand, with fallback to core PDF fonts (Helvetica, Times, Courier).

## About

This is a free application for the **VNS PDF Library** HTML/Markdown Import premium module. Use it to test the conversion quality on your own HTML files before purchasing.

The premium module provides `LoadHTML()` and `LoadMarkdown()` methods that you can integrate directly into your own Xojo applications — one line to convert.

```xojo
pdf.LoadHTML(htmlContent, 0, imageFolder)  // One line. Done.
```

Learn more at [verynicesw.com](https://verynicesw.com)
