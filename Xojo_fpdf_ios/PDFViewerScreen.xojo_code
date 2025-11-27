#tag MobileScreen
Begin MobileScreen PDFViewerScreen
   BackButtonCaption=   ""
   Compatibility   =   ""
   ControlCount    =   1
   Device = 7
   HasNavigationBar=   True
   LargeTitleDisplayMode=   2
   Left            =   0
   Orientation = 0
   ScaleFactor     =   0.0
   TabBarVisible   =   True
   TabIcon         =   0
   TintColor       =   
   Title           =   "PDF Viewer"
   Top             =   0
   Begin MobilePDFViewer PDFViewer1
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AutoLayout      =   PDFViewer1, 1, <Parent>, 1, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   PDFViewer1, 3, TopLayoutGuide, 4, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   PDFViewer1, 2, <Parent>, 2, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   PDFViewer1, 4, <Parent>, 4, False, +1.00, 4, 1, 0, , True
      BackgroundColor =   &c00000000
      Content         =   ""
      ControlCount    =   0
      DisplayMode     =   1
      Enabled         =   True
      HasThumbnails   =   False
      Height          =   747
      Left            =   0
      LockedInPosition=   False
      Page            =   1
      PageCount       =   0
      Scope           =   0
      TintColor       =   &c00000000
      Top             =   65
      Visible         =   True
      Width           =   375
      _ClosingFired   =   False
   End
End
#tag EndMobileScreen

#tag WindowCode
	#tag Event
		Sub Activated()
		  // Screen is now active - load the PDF if it was set
		  System.DebugLog("PDFViewerScreen.Activated: PDFFile = " + If(PDFFile = Nil, "Nil", PDFFile.Name))
		  
		  If PDFFile <> Nil Then
		    LoadPDF(PDFFile)
		  Else
		    System.DebugLog("PDFViewerScreen.Activated: PDFFile is STILL Nil!")
		  End If
		End Sub
	#tag EndEvent

	#tag Event
		Sub Opening()
		  System.DebugLog("PDFViewerScreen.Opening: PDFFile = " + If(PDFFile = Nil, "Nil", PDFFile.Name))
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub LoadPDF(file As FolderItem)
		  // Store the file reference
		  PDFFile = file
		  
		  // Load it immediately if the screen is already open
		  If PDFFile <> Nil And PDFFile.Exists Then
		    // Debug: Check file size
		    Dim bs As BinaryStream = BinaryStream.Open(PDFFile)
		    Dim fileSize As Integer = bs.Length
		    bs.Close()
		    
		    // Set the title
		    Self.Title = PDFFile.Name
		    
		    // Set the document on the viewer
		    PDFViewer1.Document = PDFFile
		    
		    // Explicitly set DisplayMode to SinglePageContinuous after loading
		    // This ensures all pages are visible with vertical scrolling
		    PDFViewer1.DisplayMode = MobilePDFViewer.DisplayModes.SinglePageContinuous
		    
		    // Debug output
		    System.DebugLog("LoadPDF: Loaded " + PDFFile.Name + " (" + Str(fileSize) + " bytes)")
		    System.DebugLog("LoadPDF: DisplayMode set to SinglePageContinuous")
		  Else
		    System.DebugLog("LoadPDF ERROR: Invalid file")
		  End If
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		PDFFile As FolderItem
	#tag EndProperty


#tag EndWindowCode

#tag Events PDFViewer1
	#tag Event
		Sub Opening()
		  // PDFViewer control is now ready
		  // Document will be set in Screen.Opening event
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="Index"
		Visible=true
		Group="ID"
		InitialValue="-2147483648"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Super"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Left"
		Visible=true
		Group="Position"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Top"
		Visible=true
		Group="Position"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackButtonCaption"
		Visible=true
		Group="Behavior"
		InitialValue=""
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasNavigationBar"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="TabIcon"
		Visible=true
		Group="Behavior"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Behavior"
		InitialValue="Untitled"
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="LargeTitleDisplayMode"
		Visible=true
		Group="Behavior"
		InitialValue="2"
		Type="MobileScreen.LargeTitleDisplayModes"
		EditorType="Enum"
		#tag EnumValues
			"0 - Automatic"
			"1 - Always"
			"2 - Never"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="TabBarVisible"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="TintColor"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="ColorGroup"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ControlCount"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ScaleFactor"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Double"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
