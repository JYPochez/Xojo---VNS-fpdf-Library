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

- **Headings**: `#` through `######`
- **Text formatting**: **bold**, *italic*, ~~strikethrough~~, `inline code`
- **Paragraphs**: separated by blank lines
- **Lists**: unordered (`-`, `*`, `+`) and ordered (`1.`, `2.`, etc.)
- **Tables**: pipe-delimited with header separator (`| --- |`)
- **Links**: `[text](url)` syntax
- **Images**: `![alt](url)` with base64 data URI support
- **Blockquotes**: `>` prefix
- **Code blocks**: fenced with triple backticks (```)
- **Horizontal rules**: `---`, `***`, or `___`
- **Line breaks**: trailing double space or backslash
- **Special characters**: HTML entities within Markdown
- **Unicode**: full international text support (Latin, Arabic, Chinese, Japanese, Korean, Cyrillic, Greek, Thai, Hebrew)

## Font Support

The converter automatically loads the best available font for your platform:
- **macOS**: Arial Unicode MS (full Unicode coverage)
- **Windows**: Arial
- **Linux**: Arial

Falls back to Helvetica (built-in PDF font) if no TrueType font is found.

## About

This is a free demo application for the **VNS PDF Library** HTML/Markdown Import premium module. Use it to test the conversion quality on your own Markdown files before purchasing.

The premium module provides `LoadHTML()` and `LoadMarkdown()` methods that you can integrate directly into your own Xojo applications.

Learn more at [verynicesw.fr](https://www.verynicesw.fr)

