# MarkdownToPdf - Free Markdown to PDF Converter

A free standalone desktop application that converts Markdown files to PDF using the VNS PDF Library.

## Download

Pre-built binaries are available for:
- **macOS** (Universal: Apple Silicon & Intel)
- **Windows** (x86 64-bit)
- **Linux** (x86 64-bit)

A test file `test_all_markdown_features.md` is included to demonstrate all supported features.

## Usage

1. Launch the application
2. Click **"Choose Markdown File and Convert to PDF"**
3. Select your `.md`, `.markdown`, or `.txt` file
4. The PDF is saved next to your source file with the same name and a `.pdf` extension

Example: selecting `/Documents/notes.md` produces `/Documents/notes.pdf`

## Supported Markdown Features

- **Headings**: `#` through `######` (h1-h6 with scaled sizes)
- **Text formatting**: **bold**, *italic*, ~~strikethrough~~, `inline code`
- **Paragraphs**: separated by blank lines
- **Lists**: unordered (`-`, `*`, `+`) and ordered (`1.`, `2.`, etc.)
- **Tables**: pipe-delimited with header separator (`| --- |`)
- **Links**: `[text](url)` syntax
- **Images**: `![alt](path)` with base64 data URIs, local file paths, and HTTP(S) URLs
- **Blockquotes**: `>` prefix with gray left bar (multi-page support)
- **Code blocks**: fenced with triple backticks (```) with gray background (multi-page support)
- **Horizontal rules**: `---`, `***`, or `___`
- **Line breaks**: trailing double space or backslash
- **Special characters**: HTML entities within Markdown (130+ supported)
- **Unicode**: full international text (Latin, Arabic, Chinese, Japanese, Korean, Cyrillic, Greek, Thai, Hebrew)
- **Emoji**: inline emoji rendering interleaved with text

## How It Works

Markdown is first converted to HTML internally, then rendered through the same CSS-aware HTML engine. This means Markdown output benefits from:

- Font-metrics-based spacing for proper block element gaps
- Multi-page code blocks and blockquotes with correct backgrounds and bars
- Automatic page breaks with content continuation
- Full Unicode and emoji support

## Font Support

The converter automatically loads the best available font for your platform:
- **macOS**: Arial Unicode MS (full Unicode coverage)
- **Windows**: Arial
- **Linux**: Arial

Falls back to Helvetica (built-in PDF font) if no TrueType font is found.

## About

This is a free application for the **VNS PDF Library** HTML/Markdown Import premium module. Use it to test the conversion quality on your own Markdown files before purchasing.

The premium module provides `LoadHTML()` and `LoadMarkdown()` methods that you can integrate directly into your own Xojo applications — one line to convert.

```xojo
pdf.LoadMarkdown(markdownContent, 0, imageFolder)  // One line. Done.
```

Learn more at [verynicesw.com](https://verynicesw.com)
