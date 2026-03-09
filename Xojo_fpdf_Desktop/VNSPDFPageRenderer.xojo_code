#tag Class
Protected Class VNSPDFPageRenderer
	#tag Method, Flags = &h0
		Sub Constructor(pdfData As String)
		  // Initialize the PDF page renderer with raw PDF binary data.
		  // This class provides cross-platform PDF-to-Picture rendering
		  // using native APIs: PDFKit on macOS, PowerShell+Windows.Data.Pdf on Windows,
		  // and Poppler (pdftoppm) on Linux.

		  mPDFData = pdfData
		  mPageCount = 0
		  mThumbnailCache = New Dictionary
		  mCachedPageNumber = -1
		  mCachedPageDPI = 0

		  // Parse page dimensions from PDF data (cross-platform, no declares needed)
		  ParsePageDimensions()

		  #If TargetMacOS Then
		    InitMacOS()
		  #ElseIf TargetWindows Then
		    InitWindows()
		  #ElseIf TargetLinux Then
		    InitLinux()
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Destructor()
		  // Clean up native resources

		  #If TargetMacOS Then
		    If mPDFDocument <> Nil Then
		      Declare Sub release Lib "Foundation" Selector "release" (obj As Ptr)
		      release(mPDFDocument)
		      mPDFDocument = Nil
		    End If
		  #EndIf

		  #If TargetWindows Then
		    // Clean up temp file and rendered page images on Windows
		    If mWinTempFolder <> Nil And mWinTempFolder.Exists Then
		      Try
		        Dim count As Integer = mWinTempFolder.Count
		        For i As Integer = count DownTo 1
		          Try
		            mWinTempFolder.ChildAt(i - 1).Remove
		          Catch
		          End Try
		        Next
		        mWinTempFolder.Remove
		      Catch e As IOException
		        // Ignore cleanup errors
		      End Try
		    End If
		  #EndIf

		  #If TargetLinux Then
		    // Clean up temp file and rendered page images on Linux
		    If mLinuxTempFolder <> Nil And mLinuxTempFolder.Exists Then
		      Try
		        Dim count As Integer = mLinuxTempFolder.Count
		        For i As Integer = count DownTo 1
		          Try
		            mLinuxTempFolder.ChildAt(i - 1).Remove
		          Catch
		          End Try
		        Next
		        mLinuxTempFolder.Remove
		      Catch e As IOException
		        // Ignore cleanup errors
		      End Try
		    End If
		  #EndIf

		  mThumbnailCache = Nil
		  mCachedPagePicture = Nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PageCount() As Integer
		  Return mPageCount
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetPageWidth(pageNumber As Integer) As Double
		  // Returns the page width in PDF points (1 point = 1/72 inch)
		  If pageNumber < 1 Or pageNumber > mPageCount Then Return 595.0 // A4 default
		  If pageNumber > mPageWidths.LastIndex + 1 Then Return 595.0
		  Return mPageWidths(pageNumber - 1)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetPageHeight(pageNumber As Integer) As Double
		  // Returns the page height in PDF points (1 point = 1/72 inch)
		  If pageNumber < 1 Or pageNumber > mPageCount Then Return 842.0 // A4 default
		  If pageNumber > mPageHeights.LastIndex + 1 Then Return 842.0
		  Return mPageHeights(pageNumber - 1)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RenderPage(pageNumber As Integer, targetWidth As Integer, targetHeight As Integer) As Picture
		  // Render a PDF page as a Picture at the specified pixel dimensions.
		  // The page is rendered to fit within the target size while maintaining aspect ratio.
		  //
		  // Parameters:
		  //   pageNumber - 1-based page number
		  //   targetWidth, targetHeight - desired pixel dimensions

		  If pageNumber < 1 Or pageNumber > mPageCount Then Return Nil

		  // Check cache
		  If pageNumber = mCachedPageNumber And targetWidth = mCachedWidth And targetHeight = mCachedHeight And mCachedPagePicture <> Nil Then
		    Return mCachedPagePicture
		  End If

		  Dim pic As Picture

		  #If TargetMacOS Then
		    pic = RenderPageMacOS(pageNumber, targetWidth, targetHeight)
		  #ElseIf TargetWindows Then
		    pic = RenderPageWindows(pageNumber, targetWidth, targetHeight)
		  #ElseIf TargetLinux Then
		    pic = RenderPageLinux(pageNumber, targetWidth, targetHeight)
		  #EndIf

		  // Cache the result
		  If pic <> Nil Then
		    mCachedPageNumber = pageNumber
		    mCachedWidth = targetWidth
		    mCachedHeight = targetHeight
		    mCachedPagePicture = pic
		  End If

		  Return pic
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RenderThumbnail(pageNumber As Integer, maxHeight As Integer = 120) As Picture
		  // Render a small thumbnail of the specified page.
		  // Results are cached for fast subsequent access.

		  If pageNumber < 1 Or pageNumber > mPageCount Then Return Nil

		  // Check cache
		  If mThumbnailCache.HasKey(pageNumber) Then
		    Return Picture(mThumbnailCache.Value(pageNumber))
		  End If

		  // Calculate thumbnail dimensions maintaining aspect ratio
		  Dim pageW As Double = GetPageWidth(pageNumber)
		  Dim pageH As Double = GetPageHeight(pageNumber)

		  If pageH <= 0 Then pageH = 842.0
		  If pageW <= 0 Then pageW = 595.0

		  Dim thumbHeight As Integer = maxHeight
		  Dim thumbWidth As Integer = CType(pageW * (thumbHeight / pageH), Integer)

		  If thumbWidth <= 0 Then thumbWidth = 1
		  If thumbHeight <= 0 Then thumbHeight = 1

		  Dim pic As Picture

		  #If TargetMacOS Then
		    pic = RenderPageMacOS(pageNumber, thumbWidth, thumbHeight)
		  #ElseIf TargetWindows Then
		    pic = RenderPageWindows(pageNumber, thumbWidth, thumbHeight)
		  #ElseIf TargetLinux Then
		    pic = RenderPageLinux(pageNumber, thumbWidth, thumbHeight)
		  #EndIf

		  If pic <> Nil Then
		    mThumbnailCache.Value(pageNumber) = pic
		  End If

		  Return pic
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ParsePageDimensions()
		  // Parse page dimensions from the raw PDF data.
		  // This works reliably because we generate the PDF ourselves.
		  // Looks for /MediaBox [x y width height] patterns.

		  // First, count pages by finding /Type /Page (not /Type /Pages)
		  Dim pageCount As Integer = 0
		  Dim searchFrom As Integer = 0

		  // Redim arrays to a reasonable initial size
		  Redim mPageWidths(-1)
		  Redim mPageHeights(-1)

		  // Find all /Type /Page occurrences (not /Pages)
		  Do
		    Dim pos As Integer = mPDFData.IndexOf(searchFrom, "/Type /Page")
		    If pos < 0 Then Exit

		    // Check that next char is NOT 's' (to avoid /Type /Pages)
		    Dim nextPos As Integer = pos + 11
		    If nextPos < mPDFData.Length Then
		      Dim nextChar As String = mPDFData.Middle(nextPos, 1)
		      If nextChar <> "s" And nextChar <> "S" Then
		        pageCount = pageCount + 1

		        // Look for /MediaBox near this page definition
		        // Search backwards and forwards from this position within a reasonable range
		        Dim searchStart As Integer = Max(0, pos - 500)
		        Dim searchEnd As Integer = Min(mPDFData.Length, pos + 500)
		        Dim searchRange As String = mPDFData.Middle(searchStart, searchEnd - searchStart)

		        Dim mediaBoxPos As Integer = searchRange.IndexOf("/MediaBox")
		        If mediaBoxPos >= 0 Then
		          // Find the [ after /MediaBox
		          Dim bracketPos As Integer = searchRange.IndexOf(mediaBoxPos, "[")
		          If bracketPos >= 0 Then
		            Dim closeBracket As Integer = searchRange.IndexOf(bracketPos, "]")
		            If closeBracket >= 0 Then
		              Dim boxContent As String = searchRange.Middle(bracketPos + 1, closeBracket - bracketPos - 1).Trim
		              // Parse "0 0 595.28 841.89" format
		              Dim parts() As String = boxContent.Split(" ")
		              If parts.LastIndex >= 3 Then
		                Dim w As Double = Val(parts(2)) - Val(parts(0))
		                Dim h As Double = Val(parts(3)) - Val(parts(1))
		                If w > 0 And h > 0 Then
		                  mPageWidths.Add(w)
		                  mPageHeights.Add(h)
		                Else
		                  mPageWidths.Add(595.28) // A4 default
		                  mPageHeights.Add(841.89)
		                End If
		              Else
		                mPageWidths.Add(595.28)
		                mPageHeights.Add(841.89)
		              End If
		            Else
		              mPageWidths.Add(595.28)
		              mPageHeights.Add(841.89)
		            End If
		          Else
		            mPageWidths.Add(595.28)
		            mPageHeights.Add(841.89)
		          End If
		        Else
		          mPageWidths.Add(595.28)
		          mPageHeights.Add(841.89)
		        End If
		      End If
		    End If

		    searchFrom = pos + 11
		  Loop

		  mPageCount = pageCount
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub InitMacOS()
		  // Initialize PDF rendering on macOS using PDFKit framework.
		  // PDFKit provides PDFDocument and PDFPage classes with native rendering.

		  #If TargetMacOS Then
		    If mPDFData = "" Then Return

		    // Convert String to MemoryBlock for stable pointer
		    mPDFDataMB = New MemoryBlock(mPDFData.Bytes)
		    mPDFDataMB.StringValue(0, mPDFData.Bytes) = mPDFData

		    // Create NSData from raw bytes
		    Declare Function NSClassFromString Lib "Foundation" (name As CFStringRef) As Ptr
		    Dim NSDataClass As Ptr = NSClassFromString("NSData")

		    Declare Function dataWithBytes Lib "Foundation" Selector "dataWithBytes:length:" (cls As Ptr, bytes As Ptr, length As Integer) As Ptr
		    Dim nsData As Ptr = dataWithBytes(NSDataClass, mPDFDataMB, mPDFDataMB.Size)

		    If nsData = Nil Then
		      mPageCount = 0
		      Return
		    End If

		    // Create PDFDocument from NSData (PDFKit framework, part of Quartz)
		    Dim PDFDocumentClass As Ptr = NSClassFromString("PDFDocument")
		    If PDFDocumentClass = Nil Then
		      mPageCount = 0
		      Return
		    End If

		    Declare Function alloc Lib "Foundation" Selector "alloc" (cls As Ptr) As Ptr
		    Dim pdfDocAlloc As Ptr = alloc(PDFDocumentClass)

		    Declare Function initWithData Lib "Foundation" Selector "initWithData:" (obj As Ptr, data As Ptr) As Ptr
		    mPDFDocument = initWithData(pdfDocAlloc, nsData)

		    If mPDFDocument = Nil Then
		      mPageCount = 0
		      Return
		    End If

		    // Get page count from PDFKit (overrides the parsed count for accuracy)
		    Declare Function pdfPageCount Lib "Foundation" Selector "pageCount" (obj As Ptr) As Integer
		    mPageCount = pdfPageCount(mPDFDocument)
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RenderPageMacOS(pageNumber As Integer, targetWidth As Integer, targetHeight As Integer) As Picture
		  // Render a PDF page using macOS PDFKit.
		  // Uses PDFPage.thumbnailOfSize:forBox: which returns an NSImage.
		  // Then converts NSImage → TIFF data → Xojo Picture.

		  #If TargetMacOS Then
		    If mPDFDocument = Nil Then Return Nil
		    If pageNumber < 1 Or pageNumber > mPageCount Then Return Nil

		    // Get PDFPage (0-indexed)
		    Declare Function pageAtIndex Lib "Foundation" Selector "pageAtIndex:" (obj As Ptr, index As Integer) As Ptr
		    Dim pdfPage As Ptr = pageAtIndex(mPDFDocument, pageNumber - 1)

		    If pdfPage = Nil Then Return Nil

		    // Calculate render size maintaining aspect ratio
		    Dim pageW As Double = GetPageWidth(pageNumber)
		    Dim pageH As Double = GetPageHeight(pageNumber)

		    Dim scaleX As Double = targetWidth / pageW
		    Dim scaleY As Double = targetHeight / pageH
		    Dim scale As Double = Min(scaleX, scaleY)

		    Dim renderWidth As CGFloat = pageW * scale
		    Dim renderHeight As CGFloat = pageH * scale

		    If renderWidth < 1 Then renderWidth = 1
		    If renderHeight < 1 Then renderHeight = 1

		    // Use thumbnailOfSize:forBox: to render the page
		    // kPDFDisplayBoxMediaBox = 0
		    Declare Function thumbnailOfSize Lib "Foundation" Selector "thumbnailOfSize:forBox:" (obj As Ptr, w As CGFloat, h As CGFloat, box As Integer) As Ptr
		    Dim nsImage As Ptr = thumbnailOfSize(pdfPage, renderWidth, renderHeight, 0)

		    If nsImage = Nil Then Return Nil

		    // Convert NSImage to Xojo Picture via TIFF representation
		    Return NSImageToXojoPicture(nsImage)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function NSImageToXojoPicture(nsImage As Ptr) As Picture
		  // Convert an NSImage (Ptr) to a Xojo Picture object.
		  // Strategy: NSImage → TIFFRepresentation → NSData → MemoryBlock → Picture.FromData
		  //
		  // This follows the same pattern as VNSPDFModule.xojo_code (lines 514-537)
		  // which converts UIImage to Picture on iOS.

		  #If TargetMacOS Then
		    If nsImage = Nil Then Return Nil

		    // Get TIFF representation from NSImage
		    Declare Function TIFFRepresentation Lib "Foundation" Selector "TIFFRepresentation" (obj As Ptr) As Ptr
		    Dim tiffData As Ptr = TIFFRepresentation(nsImage)

		    If tiffData = Nil Then Return Nil

		    // Get data length
		    Declare Function NSDataLength Lib "Foundation" Selector "length" (obj As Ptr) As Integer
		    Dim dataLength As Integer = NSDataLength(tiffData)

		    If dataLength = 0 Then Return Nil

		    // Copy data to MemoryBlock
		    Declare Sub NSDataGetBytes Lib "Foundation" Selector "getBytes:length:" (obj As Ptr, buffer As Ptr, length As Integer)
		    Dim mb As New MemoryBlock(dataLength)
		    NSDataGetBytes(tiffData, mb, dataLength)

		    // Convert to Xojo Picture
		    Return Picture.FromData(mb)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub InitWindows()
		  // Initialize PDF rendering on Windows.
		  // Saves PDF to a temp file and pre-renders all pages using PowerShell
		  // with the Windows.Data.Pdf API (available on Windows 10+).

		  #If TargetWindows Then
		    If mPDFData = "" Then Return

		    // Create temp folder for rendered pages
		    mWinTempFolder = SpecialFolder.Temporary.Child("vnspdf_render_" + Str(Microseconds))
		    mWinTempFolder.CreateFolder()

		    // Save PDF to temp file
		    mTempFile = mWinTempFolder.Child("source.pdf")

		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(mTempFile, True)
		      stream.Write(mPDFData)
		      stream.Close()
		    Catch e As IOException
		      mPageCount = 0
		      Return
		    End Try

		    // mPageCount was already set by ParsePageDimensions()
		    // Now render all pages to PNG using PowerShell
		    If mPageCount > 0 Then
		      RenderAllPagesWindows()
		    End If
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RenderAllPagesWindows()
		  // Render all PDF pages to PNG files using PowerShell + Windows.Data.Pdf API.
		  // This renders all pages in a single PowerShell invocation for efficiency.

		  #If TargetWindows Then
		    If mTempFile = Nil Or Not mTempFile.Exists Then Return
		    If mWinTempFolder = Nil Or Not mWinTempFolder.Exists Then Return

		    Dim pdfPath As String = mTempFile.NativePath
		    Dim outFolder As String = mWinTempFolder.NativePath

		    // Pure PowerShell approach using AsTask reflection to await WinRT async tasks.
		    // Key fixes: (1) Seek stream to 0 after rendering, (2) use explicit static call for
		    // WindowsRuntimeStreamExtensions.AsStreamForRead (PS 5.1 can't resolve extension methods).
		    Dim psScript As String = _
		    "$errorLog = Join-Path '" + outFolder.ReplaceAll("'", "''") + "' 'error.log'" + EndOfLine + _
		    "try {" + EndOfLine + _
		    "  Add-Type -AssemblyName 'System.Runtime.WindowsRuntime'" + EndOfLine + _
		    "  [Windows.Data.Pdf.PdfDocument,Windows.Data.Pdf,ContentType=WindowsRuntime] | Out-Null" + EndOfLine + _
		    "  [Windows.Storage.StorageFile,Windows.Storage,ContentType=WindowsRuntime] | Out-Null" + EndOfLine + _
		    "  [Windows.Storage.Streams.InMemoryRandomAccessStream,Windows.Storage.Streams,ContentType=WindowsRuntime] | Out-Null" + EndOfLine + _
		    "" + EndOfLine + _
		    "  $allMethods = [System.WindowsRuntimeSystemExtensions].GetMethods()" + EndOfLine + _
		    "  $asTaskGeneric = ($allMethods | Where-Object {" + EndOfLine + _
		    "    $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.IsGenericMethod -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation" + Chr(96) + "1'" + EndOfLine + _
		    "  })[0]" + EndOfLine + _
		    "  $asTaskAction = ($allMethods | Where-Object {" + EndOfLine + _
		    "    $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and (-not $_.IsGenericMethod) -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncAction'" + EndOfLine + _
		    "  })[0]" + EndOfLine + _
		    "" + EndOfLine + _
		    "  if ($asTaskGeneric -eq $null) { throw 'Could not find AsTask generic method' }" + EndOfLine + _
		    "  if ($asTaskAction -eq $null) { throw 'Could not find AsTask action method' }" + EndOfLine + _
		    "" + EndOfLine + _
		    "  $pdfPath = '" + pdfPath.ReplaceAll("'", "''") + "'" + EndOfLine + _
		    "  $outFolder = '" + outFolder.ReplaceAll("'", "''") + "'" + EndOfLine + _
		    "" + EndOfLine + _
		    "  $fileOp = [Windows.Storage.StorageFile]::GetFileFromPathAsync($pdfPath)" + EndOfLine + _
		    "  $fileTask = $asTaskGeneric.MakeGenericMethod([Windows.Storage.StorageFile]).Invoke($null, @($fileOp))" + EndOfLine + _
		    "  $fileTask.Wait(-1) | Out-Null" + EndOfLine + _
		    "  $file = $fileTask.Result" + EndOfLine + _
		    "" + EndOfLine + _
		    "  $pdfOp = [Windows.Data.Pdf.PdfDocument]::LoadFromFileAsync($file)" + EndOfLine + _
		    "  $pdfTask = $asTaskGeneric.MakeGenericMethod([Windows.Data.Pdf.PdfDocument]).Invoke($null, @($pdfOp))" + EndOfLine + _
		    "  $pdfTask.Wait(-1) | Out-Null" + EndOfLine + _
		    "  $pdf = $pdfTask.Result" + EndOfLine + _
		    "" + EndOfLine + _
		    "  for ($i = 0; $i -lt $pdf.PageCount; $i++) {" + EndOfLine + _
		    "    $page = $pdf.GetPage($i)" + EndOfLine + _
		    "    $stream = New-Object Windows.Storage.Streams.InMemoryRandomAccessStream" + EndOfLine + _
		    "    $renderOp = $page.RenderToStreamAsync($stream)" + EndOfLine + _
		    "    $renderTask = $asTaskAction.Invoke($null, @($renderOp))" + EndOfLine + _
		    "    $renderTask.Wait(-1) | Out-Null" + EndOfLine + _
		    "    $stream.Seek(0) | Out-Null" + EndOfLine + _
		    "    $outPath = Join-Path $outFolder ('page_' + ($i + 1).ToString('D4') + '.png')" + EndOfLine + _
		    "    $inputStream = $stream.GetInputStreamAt(0)" + EndOfLine + _
		    "    $netStream = [System.IO.WindowsRuntimeStreamExtensions]::AsStreamForRead($inputStream)" + EndOfLine + _
		    "    $fileStream = [System.IO.File]::Create($outPath)" + EndOfLine + _
		    "    $netStream.CopyTo($fileStream)" + EndOfLine + _
		    "    $fileStream.Close()" + EndOfLine + _
		    "    $netStream.Close()" + EndOfLine + _
		    "    $stream.Dispose()" + EndOfLine + _
		    "    $page.Dispose()" + EndOfLine + _
		    "  }" + EndOfLine + _
		    "  $pdf.Dispose()" + EndOfLine + _
		    "  exit 0" + EndOfLine + _
		    "} catch {" + EndOfLine + _
		    "  ('ERROR: ' + $_.Exception.Message) | Out-File $errorLog" + EndOfLine + _
		    "  ('DETAIL: ' + $_.Exception.ToString()) | Out-File $errorLog -Append" + EndOfLine + _
		    "  exit 1" + EndOfLine + _
		    "}"

		    // Write script to temp .ps1 file
		    Dim scriptFile As FolderItem = mWinTempFolder.Child("render_pages.ps1")
		    Try
		      Dim scriptStream As BinaryStream = BinaryStream.Create(scriptFile, True)
		      scriptStream.Write(psScript)
		      scriptStream.Close()
		    Catch e As IOException
		      mWinRenderSuccess = False
		      Return
		    End Try

		    Dim sh As New Shell
		    sh.TimeOut = 30000 // 30 seconds for multi-page rendering
		    Dim cmd As String = "powershell -ExecutionPolicy Bypass -NoProfile -File """ + scriptFile.NativePath + """"
		    sh.Execute(cmd)

		    mWinRenderSuccess = (sh.ExitCode = 0)
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RenderPageWindows(pageNumber As Integer, targetWidth As Integer, targetHeight As Integer) As Picture
		  // Load a pre-rendered PNG file for the given page on Windows.
		  // If rendering failed, returns a placeholder picture.

		  #Pragma Unused pageNumber
		  #Pragma Unused targetWidth
		  #Pragma Unused targetHeight

		  #If TargetWindows Then
		    If mWinTempFolder = Nil Or Not mWinTempFolder.Exists Then
		      Return CreatePlaceholder(targetWidth, targetHeight, pageNumber)
		    End If

		    // Try to load the pre-rendered PNG
		    Dim pageFile As FolderItem = mWinTempFolder.Child("page_" + Format(pageNumber, "0000") + ".png")

		    If pageFile <> Nil And pageFile.Exists Then
		      Try
		        Dim fullPic As Picture = Picture.Open(pageFile)
		        If fullPic <> Nil Then
		          // Scale to target size maintaining aspect ratio
		          Dim scaleX As Double = targetWidth / fullPic.Width
		          Dim scaleY As Double = targetHeight / fullPic.Height
		          Dim scale As Double = Min(scaleX, scaleY)

		          Dim drawW As Integer = Max(1, CType(fullPic.Width * scale, Integer))
		          Dim drawH As Integer = Max(1, CType(fullPic.Height * scale, Integer))

		          Dim result As New Picture(drawW, drawH)
		          Dim g As Graphics = result.Graphics
		          g.DrawPicture(fullPic, 0, 0, drawW, drawH, 0, 0, fullPic.Width, fullPic.Height)
		          Return result
		        End If
		      Catch
		        // Fall through to placeholder
		      End Try
		    End If

		    Return CreatePlaceholder(targetWidth, targetHeight, pageNumber)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub InitLinux()
		  // Initialize PDF rendering on Linux using Poppler's pdftoppm command.
		  // pdftoppm is part of the poppler-utils package, pre-installed on most distributions
		  // (Ubuntu, Debian, Fedora, etc.). It renders PDF pages as PNG images.
		  //
		  // If pdftoppm is not found, pages will display a placeholder with an install message.

		  #If TargetLinux Then
		    If mPDFData = "" Then Return

		    // Create temp folder for rendered pages
		    mLinuxTempFolder = SpecialFolder.Temporary.Child("vnspdf_render_" + Str(Microseconds))
		    mLinuxTempFolder.CreateFolder()

		    // Save PDF to temp file
		    Dim tempPDF As FolderItem = mLinuxTempFolder.Child("source.pdf")

		    Try
		      Dim stream As BinaryStream = BinaryStream.Create(tempPDF, True)
		      stream.Write(mPDFData)
		      stream.Close()
		    Catch e As IOException
		      mPageCount = 0
		      Return
		    End Try

		    // mPageCount was already set by ParsePageDimensions()
		    // Now render all pages to PNG using pdftoppm
		    If mPageCount > 0 Then
		      RenderAllPagesLinux()
		    End If
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RenderAllPagesLinux()
		  // Render all PDF pages to PNG files using Poppler's pdftoppm command.
		  // pdftoppm -png -r <dpi> <input.pdf> <output_prefix>
		  // This generates files named <prefix>-01.png, <prefix>-02.png, etc.

		  #If TargetLinux Then
		    If mLinuxTempFolder = Nil Or Not mLinuxTempFolder.Exists Then Return

		    Dim pdfPath As String = mLinuxTempFolder.Child("source.pdf").NativePath
		    Dim outputPrefix As String = mLinuxTempFolder.Child("page").NativePath

		    // First check that pdftoppm is available
		    Dim checkSh As New Shell
		    checkSh.TimeOut = 5000
		    checkSh.Execute("which pdftoppm")
		    If checkSh.ExitCode <> 0 Then
		      // pdftoppm not found, try to check common paths
		      checkSh.Execute("test -x /usr/bin/pdftoppm")
		      If checkSh.ExitCode <> 0 Then
		        mLinuxRenderSuccess = False
		        Return
		      End If
		    End If

		    // Render at 150 DPI for good quality preview
		    // pdftoppm generates: page-01.png, page-02.png, etc.
		    Dim sh As New Shell
		    sh.TimeOut = 30000  // 30 seconds for multi-page rendering
		    sh.Execute("pdftoppm -png -r 150 " + ShellQuote(pdfPath) + " " + ShellQuote(outputPrefix))

		    mLinuxRenderSuccess = (sh.ExitCode = 0)
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RenderPageLinux(pageNumber As Integer, targetWidth As Integer, targetHeight As Integer) As Picture
		  // Load a pre-rendered PNG file for the given page on Linux.
		  // pdftoppm generates files named page-01.png, page-02.png, etc.
		  // If rendering failed, returns a placeholder picture with install instructions.

		  #Pragma Unused pageNumber
		  #Pragma Unused targetWidth
		  #Pragma Unused targetHeight

		  #If TargetLinux Then
		    If mLinuxTempFolder = Nil Or Not mLinuxTempFolder.Exists Then
		      Return CreatePlaceholderLinux(targetWidth, targetHeight, pageNumber)
		    End If

		    // pdftoppm names files with varying zero-padding depending on page count.
		    // Try common patterns: page-01.png, page-001.png, page-1.png
		    Dim pageFile As FolderItem

		    // Try 2-digit padding (most common for < 100 pages)
		    pageFile = mLinuxTempFolder.Child("page-" + Format(pageNumber, "00") + ".png")

		    If pageFile = Nil Or Not pageFile.Exists Then
		      // Try 3-digit padding (for 100+ pages)
		      pageFile = mLinuxTempFolder.Child("page-" + Format(pageNumber, "000") + ".png")
		    End If

		    If pageFile = Nil Or Not pageFile.Exists Then
		      // Try 1-digit (single page PDFs)
		      pageFile = mLinuxTempFolder.Child("page-" + Str(pageNumber) + ".png")
		    End If

		    If pageFile <> Nil And pageFile.Exists Then
		      Try
		        Dim fullPic As Picture = Picture.Open(pageFile)
		        If fullPic <> Nil Then
		          // Scale to target size maintaining aspect ratio
		          Dim scaleX As Double = targetWidth / fullPic.Width
		          Dim scaleY As Double = targetHeight / fullPic.Height
		          Dim scale As Double = Min(scaleX, scaleY)

		          Dim drawW As Integer = Max(1, CType(fullPic.Width * scale, Integer))
		          Dim drawH As Integer = Max(1, CType(fullPic.Height * scale, Integer))

		          Dim result As New Picture(drawW, drawH)
		          Dim g As Graphics = result.Graphics
		          g.DrawPicture(fullPic, 0, 0, drawW, drawH, 0, 0, fullPic.Width, fullPic.Height)
		          Return result
		        End If
		      Catch
		        // Fall through to placeholder
		      End Try
		    End If

		    Return CreatePlaceholderLinux(targetWidth, targetHeight, pageNumber)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CreatePlaceholderLinux(width As Integer, height As Integer, pageNumber As Integer) As Picture
		  // Create a placeholder image for Linux when pdftoppm is not available or failed.
		  // Displays a helpful message about installing poppler-utils.

		  Dim pic As New Picture(Max(1, width), Max(1, height))
		  Dim g As Graphics = pic.Graphics

		  // White background
		  g.DrawingColor = &cFFFFFF
		  g.FillRectangle(0, 0, g.Width, g.Height)

		  // Light gray border
		  g.DrawingColor = &cC0C0C0
		  g.DrawRectangle(0, 0, g.Width, g.Height)

		  // Page number
		  g.DrawingColor = &c808080
		  g.FontSize = 14
		  Dim msg As String = "Page " + Str(pageNumber)
		  g.DrawText(msg, (g.Width - g.TextWidth(msg)) / 2, g.Height / 2 - 30)

		  // Status message
		  g.FontSize = 10
		  If Not mLinuxRenderSuccess Then
		    Dim msg2 As String = "(Preview requires poppler-utils)"
		    g.DrawText(msg2, (g.Width - g.TextWidth(msg2)) / 2, g.Height / 2)
		    Dim msg3 As String = "sudo apt install poppler-utils"
		    g.DrawingColor = &c4040A0
		    g.DrawText(msg3, (g.Width - g.TextWidth(msg3)) / 2, g.Height / 2 + 20)
		  Else
		    Dim msg2 As String = "(Preview not available)"
		    g.DrawText(msg2, (g.Width - g.TextWidth(msg2)) / 2, g.Height / 2)
		  End If

		  Return pic
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ShellQuote(path As String) As String
		  // Escape a file path for safe use in shell commands on Linux.
		  // Wraps the path in single quotes and escapes any single quotes within.

		  Return "'" + path.ReplaceAll("'", "'""'""'") + "'"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CreatePlaceholder(width As Integer, height As Integer, pageNumber As Integer) As Picture
		  // Create a placeholder image when native rendering is not available.

		  Dim pic As New Picture(Max(1, width), Max(1, height))
		  Dim g As Graphics = pic.Graphics

		  // White background
		  g.DrawingColor = &cFFFFFF
		  g.FillRectangle(0, 0, g.Width, g.Height)

		  // Light gray border
		  g.DrawingColor = &cC0C0C0
		  g.DrawRectangle(0, 0, g.Width, g.Height)

		  // Page number text
		  g.DrawingColor = &c808080
		  g.FontSize = 14
		  Dim msg As String = "Page " + Str(pageNumber)
		  g.DrawText(msg, (g.Width - g.TextWidth(msg)) / 2, g.Height / 2 - 10)

		  Dim msg2 As String = "(Preview not available)"
		  g.FontSize = 10
		  g.DrawText(msg2, (g.Width - g.TextWidth(msg2)) / 2, g.Height / 2 + 15)

		  Return pic
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mPDFData As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPDFDataMB As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPageCount As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPDFDocument As Ptr
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTempFile As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mWinTempFolder As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mWinRenderSuccess As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLinuxTempFolder As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLinuxRenderSuccess As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mThumbnailCache As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCachedPageNumber As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCachedPagePicture As Picture
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCachedPageDPI As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCachedWidth As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCachedHeight As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPageWidths() As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPageHeights() As Double
	#tag EndProperty


#tag EndClass
