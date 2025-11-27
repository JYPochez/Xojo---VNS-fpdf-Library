#tag MobileScreen
Begin MobileScreen Screen1
   BackButtonCaption=   ""
   Compatibility   =   ""
   ControlCount    =   3
   Device = 7
   HasNavigationBar=   True
   LargeTitleDisplayMode=   2
   Left            =   0
   Orientation = 0
   ScaleFactor     =   0.0
   TabBarVisible   =   True
   TabIcon         =   0
   TintColor       =   
   Title           =   "Xojo FPDF Examples"
   Top             =   0
   Begin MobileSwitch SwitchDisplayPDF
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AutoLayout      =   SwitchDisplayPDF, 8, , 0, False, +1.00, 4, 1, 31, , True
      AutoLayout      =   SwitchDisplayPDF, 1, <Parent>, 1, False, +1.00, 4, 1, 20, , True
      AutoLayout      =   SwitchDisplayPDF, 2, <Parent>, 1, False, +1.00, 4, 1, 80, , True
      AutoLayout      =   SwitchDisplayPDF, 3, TopLayoutGuide, 4, False, +1.00, 4, 1, 10, , True
      ControlCount    =   0
      Enabled         =   True
      Height          =   31
      Left            =   20
      LockedInPosition=   False
      Scope           =   0
      TintColor       =   
      Top             =   75
      Value           =   True
      Visible         =   True
      Width           =   60
      _ClosingFired   =   False
   End
   Begin iOSMobileTable TableExamples
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AllowRefresh    =   False
      AllowSearch     =   False
      AutoLayout      =   TableExamples, 1, <Parent>, 1, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   TableExamples, 3, SwitchDisplayPDF, 4, False, +1.00, 4, 1, 10, , True
      AutoLayout      =   TableExamples, 2, <Parent>, 2, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   TableExamples, 4, txtOutput, 3, False, +1.00, 4, 1, 0, , True
      ControlCount    =   0
      EditingEnabled  =   False
      EditingEnabled  =   False
      Enabled         =   True
      EstimatedRowHeight=   -1
      Format          =   0
      Height          =   546
      Left            =   0
      LockedInPosition=   False
      Scope           =   0
      SectionCount    =   0
      TintColor       =   
      Top             =   116
      Visible         =   True
      Width           =   375
      _ClosingFired   =   False
      _OpeningCompleted=   False
   End
   Begin iOSTextArea txtOutput
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AutoLayout      =   txtOutput, 1, <Parent>, 1, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   txtOutput, 4, <Parent>, 4, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   txtOutput, 2, <Parent>, 2, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   txtOutput, 8, , 0, False, +1.00, 4, 1, 150, , True
      BorderColor     =   
      BorderStyle     =   1
      Editable        =   False
      Height          =   150.0
      KeyboardType    =   0
      Left            =   0
      LockedInPosition=   False
      Scope           =   0
      Text            =   ""
      TextAlignment   =   0
      TextColor       =   &c00000000
      TextFont        =   "System		12"
      TextSize        =   0
      Top             =   662
      Visible         =   True
      Width           =   375.0
   End
   Begin MobileLabel Label1
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      Alignment       =   0
      AutoLayout      =   Label1, 1, SwitchDisplayPDF, 2, False, +1.00, 4, 1, *kStdControlGapH, , True
      AutoLayout      =   Label1, 2, <Parent>, 2, False, +1.00, 4, 1, -*kStdGapCtlToViewH, , True
      AutoLayout      =   Label1, 8, , 0, False, +1.00, 4, 1, 30, , True
      AutoLayout      =   Label1, 4, SwitchDisplayPDF, 4, False, +1.00, 4, 1, 0, , True
      ControlCount    =   0
      Enabled         =   True
      Height          =   30
      Left            =   88
      LineBreakMode   =   0
      LockedInPosition=   False
      MaximumCharactersAllowed=   0
      Scope           =   0
      SelectedText    =   ""
      SelectionLength =   0
      SelectionStart  =   0
      Text            =   "Display Generated PDF"
      TextColor       =   &c000000
      TextFont        =   "System Bold		"
      TextSize        =   0
      TintColor       =   
      Top             =   76
      Visible         =   True
      Width           =   267
      _ClosingFired   =   False
   End
End
#tag EndMobileScreen

#tag WindowCode
	#tag Event
		Sub Opening()
		  // Create and assign the DataSource
		  mDataSource = New VNSExamplesDataSource
		  TableExamples.DataSource = mDataSource
		End Sub
	#tag EndEvent


	#tag Property, Flags = &h21
		Private mDataSource As VNSExamplesDataSource
	#tag EndProperty


#tag EndWindowCode

#tag Events TableExamples
	#tag Event
		Sub SelectionChanged(section As Integer, row As Integer)
		  #Pragma Unused section
		  
		  // Call appropriate GenerateExampleN() based on row (row is 0-based)
		  Dim exampleNumber As Integer = row + 1
		  Dim result As Dictionary
		  
		  Select Case exampleNumber
		  Case 1
		    result = VNSPDFExamplesModule.GenerateExample1()
		  Case 2
		    result = VNSPDFExamplesModule.GenerateExample2()
		  Case 3
		    result = VNSPDFExamplesModule.GenerateExample3()
		  Case 4
		    result = VNSPDFExamplesModule.GenerateExample4()
		  Case 5
		    result = VNSPDFExamplesModule.GenerateExample5()
		  Case 6
		    result = VNSPDFExamplesModule.GenerateExample6()
		  Case 7
		    result = VNSPDFExamplesModule.GenerateExample7()
		  Case 8
		    result = VNSPDFExamplesModule.GenerateExample8()
		  Case 9
		    result = VNSPDFExamplesModule.GenerateExample9()
		  Case 10
		    result = VNSPDFExamplesModule.GenerateExample10()
		  Case 11
		    result = VNSPDFExamplesModule.GenerateExample11()
		  Case 12
		    result = VNSPDFExamplesModule.GenerateExample12()
		  Case 13
		    result = VNSPDFExamplesModule.GenerateExample13()
		  Case 14
		    // Use RC4-40 (revision 2) which is available in FREE version
	    result = VNSPDFExamplesModule.GenerateExample14(VNSPDFModule.gkEncryptionRC4_40, "user123", "owner456", True, True, True, True, True, True, True, True)
		  Case 15
		    result = VNSPDFExamplesModule.GenerateExample15()
		  Case 16
		    result = VNSPDFExamplesModule.GenerateExample16()
		  Case 17
		    result = VNSPDFExamplesModule.GenerateExample17()
		  Case 18
		    result = VNSPDFExamplesModule.GenerateExample18()
		  Case 19
		    result = VNSPDFExamplesModule.GenerateExample19()
		  Case 20
		    // Test Zlib - special test, not a PDF example
		    result = VNSPDFExamplesModule.TestZlib()
		  Case 21
		    // Test AES - special test, not a PDF example
		    result = VNSPDFExamplesModule.TestAES()
		  End Select

		  // Build output message
		  Dim msg As String

		  // Handle test results (different format than PDF examples)
		  If exampleNumber >= 20 Then
		    // TestZlib and TestAES return "passed" (Boolean) and "output" (String)
		    If result = Nil Then
		      msg = "ERROR: Test returned Nil" + EndOfLine
		    Else
		      Dim passed As Boolean = result.Value("passed")
		      Dim output As String = result.Value("output")
		      msg = output
		      If passed Then
		        msg = msg + EndOfLine + "ALL TESTS PASSED!" + EndOfLine
		      Else
		        msg = msg + EndOfLine + "SOME TESTS FAILED!" + EndOfLine
		      End If
		    End If
		    // iOS API2: iOSTextArea.Text requires Text type (converted from String)
		    txtOutput.Text = msg.ToText
		    Return
		  End If

		  // Check if result is nil
		  If result = Nil Then
		    msg = "ERROR: Example " + Str(exampleNumber) + " returned Nil" + EndOfLine
		  ElseIf Not result.HasKey("status") Then
		    msg = "ERROR: Result has no 'status' key" + EndOfLine
		  Else
		    msg = result.Value("status")

		    // Check if there's an error in the result
		    If result.HasKey("error") Then
		      msg = msg + "ERROR: " + result.Value("error") + EndOfLine
		    End If
		  End If
		  
		  // Save PDF if successful
		  Dim pdfFile As FolderItem
		  If result <> Nil And result.HasKey("pdf") Then
		    Dim pdfData As String = result.Value("pdf")
		    Dim filename As String = result.Value("filename")
		    
		    // Check if PDF data is empty
		    #If TargetiOS Then
		      Dim pdfSize As Integer = VNSPDFModule.StringLenB(pdfData)
		    #Else
		      Dim pdfSize As Integer = pdfData.LenB
		    #EndIf
		    
		    If pdfSize = 0 Then
		      msg = msg + "WARNING: PDF data is empty (0 bytes)!" + EndOfLine
		    End If
		    
		    Try
		      // Save to Documents folder on iOS
		      Dim docsFolder As FolderItem = SpecialFolder.Documents
		      pdfFile = docsFolder.Child(filename)
		      
		      Dim stream As BinaryStream = BinaryStream.Create(pdfFile, True)
		      stream.Write(pdfData)
		      stream.Close()
		      
		      msg = msg + "PDF saved: " + pdfFile.NativePath + EndOfLine
		      msg = msg + "File size: " + Str(pdfSize) + " bytes" + EndOfLine
		      
		      // Display PDF if switch is ON
		      If SwitchDisplayPDF.Value Then
		        Dim pdfScreen As New PDFViewerScreen
		        pdfScreen.PDFFile = pdfFile
		        pdfScreen.Title = "Example " + Str(exampleNumber)
		        Self.PushTo(pdfScreen)
		      End If
		      
		    Catch e As IOException
		      msg = msg + "Error saving file: " + e.Message + EndOfLine
		    End Try
		  End If
		  
		  msg = msg + EndOfLine
		  
		  // iOS API2: iOSTextArea.Text requires Text type (converted from String)
		  txtOutput.Text = msg.ToText
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
