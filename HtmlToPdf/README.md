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

- **Headings**: h1 through h6
- **Text formatting**: bold, italic, underline, strikethrough, subscript, superscript, inline code
- **Inline styles**: color, font-size, font-family, background-color, text-align
- **Paragraphs and divs**: with CSS alignment (left, center, right, justify)
- **Lists**: unordered (ul/li) and ordered (ol/li)
- **Tables**: with headers (th), rows, borders, and cell alignment
- **Images**: base64-encoded inline images
- **Links**: anchor tags with href
- **Blockquotes and code blocks**: pre-formatted text
- **Horizontal rules**: hr tags
- **Line breaks**: br tags
- **Special characters**: HTML entities (&amp; &lt; &gt; &copy; &euro; etc.)
- **Unicode**: full international text support (Latin, Arabic, Chinese, Japanese, Korean, Cyrillic, Greek, Thai, Hebrew)
- **Legacy font tag**: size, color, face attributes
- **Span styling**: inline CSS via style attribute

## Font Support

The converter automatically loads the best available font for your platform:
- **macOS**: Arial Unicode MS (full Unicode coverage)
- **Windows**: Arial
- **Linux**: Arial

Falls back to Helvetica (built-in PDF font) if no TrueType font is found.

CSS `font-family` declarations in your HTML are resolved automatically: system TrueType fonts are loaded on demand, with fallback to core PDF fonts (Helvetica, Times, Courier).

## About

This is a free demo application for the **VNS PDF Library** HTML/Markdown Import premium module. Use it to test the conversion quality on your own HTML files before purchasing.

The premium module provides `LoadHTML()` and `LoadMarkdown()` methods that you can integrate directly into your own Xojo applications.

Learn more at [verynicesw.fr](https://www.verynicesw.fr)

