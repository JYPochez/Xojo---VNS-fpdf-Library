# Markdown to PDF Renderer - Complete Test Suite

This file tests every supported Markdown syntax for the VNSPDFHTMLPremium.MarkdownToHTML parser.

---

## 1. Headings

# Heading Level 1
## Heading Level 2
### Heading Level 3
#### Heading Level 4
##### Heading Level 5
###### Heading Level 6

---

## 2. Text Formatting

This is a normal paragraph with plain text.

This has **bold text** using double asterisks.

This has *italic text* using single asterisks.

This has **bold and *italic* nested** together.

This has ~~strikethrough~~ text using tildes.

This has `inline code` using backticks.

---

## 3. Multiple Paragraphs

First paragraph. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.

Second paragraph. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

Third paragraph. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.

---

## 4. Unordered Lists

- First item
- Second item
- Third item with **bold** text
- Fourth item with *italic* text
- Fifth item with `code`

---

## 5. Ordered Lists

1. First numbered item
2. Second numbered item
3. Third numbered item with **bold**
4. Fourth numbered item
5. Fifth numbered item

---

## 6. Mixed Lists

Unordered list:
- Apple
- Banana
- Cherry

Followed by ordered list:
1. Step one
2. Step two
3. Step three

Back to unordered:
- Alpha
- Beta
- Gamma

---

## 7. Links

Visit [Example.com](https://www.example.com) for more info.

Link to [Xojo Documentation](https://documentation.xojo.com) site.

Text before [Google](https://www.google.com) and text after.

---

## 8. Images

Small test image (base64):

![Red square](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAIAAAAC64paAAAAG0lEQVR4nGP4z8BANiJf56jmUc2jmkc1U0UzADHNjoAymaoJAAAAAElFTkSuQmCC)

---

## 9. Blockquotes

> This is a blockquote. It should be indented from the left margin.

Normal paragraph after blockquote.

> Another blockquote with longer text. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.

---

## 10. Code Blocks

Inline: `Var x As Integer = 42` in a sentence.

Fenced code block:

```
// Multi-line code block
Var pdf As New VNSPDFDocument
pdf.SetFont("Helvetica", "", 12)
pdf.Cell(40, 10, "Hello World!")
pdf.Save(outputFile)
```

Paragraph after code block.

---

## 11. Horizontal Rules

Text before rule.

---

Text between rules.

---

Text after rules.

---

## 12. Tables

### Simple Table

| Name    | Age | City     |
|---------|-----|----------|
| Alice   | 30  | Paris    |
| Bob     | 25  | London   |
| Charlie | 35  | New York |

### Two-Column Table

| Feature     | Status  |
|-------------|---------|
| Headings    | Working |
| Bold/Italic | Working |
| Tables      | Working |
| Lists       | Working |

### Many Columns

| Col 1 | Col 2 | Col 3 | Col 4 | Col 5 | Col 6 |
|-------|-------|-------|-------|-------|-------|
| A1    | B1    | C1    | D1    | E1    | F1    |
| A2    | B2    | C2    | D2    | E2    | F2    |

---

## 13. Mixed Content

This paragraph has **bold**, *italic*, ~~strikethrough~~, `code`, and mixed formatting all together.

Here is **bold with *italic inside*** nested.

---

## 14. Special Characters

Ampersand: &, Less than: <, Greater than: >, Quote: "

French: Les caractères spéciaux sont gérés correctement.

Accented: à á â ã ä ç è é ê ë ì í î ï ñ ò ó ô õ ö ù ú û ü ý

German: Über, Straße, Größe, Gemütlichkeit

Spanish: ¡Hola! ¿Cómo estás? Niño, año, señor

---

## 15. Unicode and International Text

### French
Café crème, naïve, résumé, Château de Versailles, garçon

### German
Ärger, Öffnung, Übung, Straße, Größe, Gemütlichkeit

### Spanish
¡Buenos días! ¿Cómo estás? El niño pequeño comió piña

### Portuguese
São Paulo, ação, coração, educação

### Turkish
İstanbul, Türkiye, öğrenci, güneş

### Polish
Łódź, źródło, żółty, ćwiczenie

### Czech
Příliš žluťoučký kůň úpěl ďábelské ódy

### Arabic
بسم الله الرحمن الرحيم
مرحبا بالعالم
هذا نص تجريبي باللغة العربية

### Chinese
你好世界
这是一个中文测试段落

### Japanese
こんにちは世界
これはテストです

### Korean
안녕하세요 세계
이것은 테스트입니다

### Russian
Привет мир! Это тестовый текст на русском языке.

### Greek
Γεια σου κόσμε! Αυτό είναι ένα δοκιμαστικό κείμενο.

### Hebrew
שלום עולם! זהו טקסט לבדיקה

### Thai
สวัสดีชาวโลก นี่คือข้อความทดสอบ

---

## 16. Unicode in Tables

### Greetings Table

| Language | Greeting              | Thank You        |
|----------|-----------------------|------------------|
| French   | Bonjour, ça va ?      | Merci beaucoup   |
| German   | Guten Tag, wie geht's?| Vielen Dank      |
| Spanish  | ¡Hola! ¿Cómo estás?  | Muchas gracias   |
| Arabic   | مرحبا                 | شكرا جزيلا       |
| Chinese  | 你好                   | 谢谢              |
| Japanese | こんにちは              | ありがとう         |
| Korean   | 안녕하세요              | 감사합니다         |
| Russian  | Здравствуйте          | Спасибо          |
| Greek    | Γεια σας              | Ευχαριστώ        |
| Polish   | Dzień dobry           | Dziękuję         |

### Pricing Table with Symbols

| Product            | Price (EUR) | Price (GBP) | Notes                    |
|--------------------|-------------|-------------|--------------------------|
| Encryption Module  | € 50,00    | £ 43,00     | AES-256 & RC4-128        |
| Table Module       | € 50,00    | £ 43,00     | Auto-pagination          |
| Bundle (3 modules) | € 100,00   | £ 86,00     | Buy 2 Get 1 Free         |

---

## 17. Currency Symbols

Euro: € 1.234,56
Pound: £ 1,234.56
Yen: ¥ 123,456
Dollar: $ 1,234.56
Swiss Franc: CHF 1'234.56

---

## 18. Long Text Word Wrapping

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

Superlongwordwithoutanyspacestotestwordbreakingbehaviorwhentextexceedstheavailablewidthofthecellandneedstobeforcefullysplit at some point.

---

## 19. Colors and Inline HTML Styling

Markdown doesn't have native color support, but inline HTML can be used for colored text.

### Span Colors

This text has <span style="color:red">red text</span> inline.

This text has <span style="color:blue">blue text</span> and <span style="color:green">green text</span> together.

<span style="color:#FF6600">Orange text using hex color #FF6600.</span>

<span style="color:rgb(128,0,128)">Purple text using rgb(128,0,128).</span>

### Font Tag Colors

<font color="red">Red text via font tag.</font>

<font color="#0066CC">Blue text via font tag with hex color.</font>

<font color="green">Green text via font tag.</font>

### Mixed Colors and Formatting

<span style="color:red">**Bold red text**</span> followed by normal text.

**Bold with <span style="color:blue">blue inside</span> the bold.**

*Italic with <span style="color:green">green inside</span> the italic.*

<span style="color:red">Red with **bold** and *italic* inside.</span>

### Background Colors

<span style="background-color:yellow">Yellow highlighted text.</span>

<span style="background-color:#CCFFCC">Light green background text.</span>

<span style="color:white;background-color:navy">White text on navy background.</span>

### Font Size via Inline HTML

<span style="font-size:18pt">Large 18pt text.</span>

Normal text. <span style="font-size:8pt">Small 8pt text.</span> Normal again.

<font size="5">Font size 5 text.</font>

### Font Family Comparison

<p style="font-family:Helvetica; font-size:11pt">Helvetica (sans-serif): The quick brown fox jumps over the lazy dog. 0123456789</p>

<p style="font-family:'Times New Roman'; font-size:11pt">Times New Roman (serif): The quick brown fox jumps over the lazy dog. 0123456789</p>

<p style="font-family:'Courier New'; font-size:11pt">Courier New (monospace): The quick brown fox jumps over the lazy dog. 0123456789</p>

<p style="font-family:Arial; font-size:11pt">Arial (sans-serif): The quick brown fox jumps over the lazy dog. 0123456789</p>

<p style="font-family:Verdana; font-size:11pt">Verdana (sans-serif): The quick brown fox jumps over the lazy dog. 0123456789</p>

<p style="font-family:Georgia; font-size:11pt">Georgia (serif): The quick brown fox jumps over the lazy dog. 0123456789</p>

<p style="font-family:'Trebuchet MS'; font-size:11pt">Trebuchet MS (sans-serif): The quick brown fox jumps over the lazy dog. 0123456789</p>

<p style="font-family:Palatino; font-size:11pt">Palatino (serif): The quick brown fox jumps over the lazy dog. 0123456789</p>

### Font Families with Formatting

<p style="font-family:'Times New Roman'; font-size:12pt"><b>Bold Times</b> and <i>Italic Times</i> and <b><i>Bold Italic Times</i></b></p>

<p style="font-family:'Courier New'; font-size:11pt"><b>Bold Courier</b> and <i>Italic Courier</i> and <b><i>Bold Italic Courier</i></b></p>

<p style="font-family:Helvetica; font-size:11pt"><b>Bold Helvetica</b> and <i>Italic Helvetica</i> and <b><i>Bold Italic Helvetica</i></b></p>

### Mixed Fonts in Same Paragraph

Default font, then <span style="font-family:'Times New Roman'">switch to Times New Roman</span>, then <span style="font-family:'Courier New'">switch to Courier New</span>, then back to default.

<span style="font-family:Helvetica; color:blue">Blue Helvetica</span> mixed with <span style="font-family:'Times New Roman'; color:red">Red Times</span> and <span style="font-family:'Courier New'; color:green">Green Courier</span>.

### Font Family via Font Tag

<font face="Helvetica">Helvetica via font tag</font> - <font face="Times">Times via font tag</font> - <font face="Courier">Courier via font tag</font>

### Color Table

| Color Name | Sample                                          | Hex Code |
|------------|-------------------------------------------------|----------|
| Red        | <span style="color:red">Sample Red</span>       | #FF0000  |
| Blue       | <span style="color:blue">Sample Blue</span>     | #0000FF  |
| Green      | <span style="color:green">Sample Green</span>   | #008000  |
| Orange     | <span style="color:#FF6600">Sample Orange</span> | #FF6600  |
| Purple     | <span style="color:#800080">Sample Purple</span> | #800080  |
| Navy       | <span style="color:navy">Sample Navy</span>     | #000080  |

---

## 20. Edge Cases

Empty line above and below:



Paragraph after empty lines.

Text with    multiple   spaces    between    words.

---

## 21. External & Local Images

Tests loading images from local file paths and HTTP URLs (not just base64 data URIs).

### Local Image (same folder as Markdown)

Image loaded from `Test.pdf.jpg`:

![Test image](Test.pdf.jpg)

### HTTP URL Image

Image loaded from an external URL:

![HTML5 Badge](https://www.w3.org/html/logo/downloads/HTML5_Badge_64.png)

### Bad URL (should be skipped silently)

![Missing image](https://example.com/nonexistent-image-12345.png)

If you see this text, the bad URL was skipped correctly.

---

## 22. Test Summary

| Test Category      | Syntax Tested                    | Expected Result      |
|--------------------|----------------------------------|----------------------|
| Headings           | # through ######                 | 6 decreasing sizes   |
| Text formatting    | **bold**, *italic*, ~~strike~~   | Proper styling       |
| Code               | `inline` and fenced blocks       | Monospace font       |
| Lists              | - bullets, 1. numbers            | Proper list markers  |
| Tables             | pipe syntax with header          | Grid with borders    |
| Links              | `[text](url)`                    | Clickable text       |
| Images             | `![alt](base64)`                 | Embedded images      |
| External images    | `![alt](file)`, `![alt](url)`    | Loaded from file/URL |
| Blockquotes        | > text                           | Indented blocks      |
| Horizontal rules   | ---                              | Full-width lines     |
| Unicode            | Multi-script text                | Correct rendering    |
| Special characters | Accents, symbols, entities       | Proper display       |
| Colors             | span/font color, background      | Colored text         |
| Font sizes         | span font-size, font size attr   | Varied text sizes    |

**End of Markdown Feature Test**
