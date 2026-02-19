#tag Class
Protected Class VNSExamplesDataSource
Implements iOSMobileTableDataSource
	#tag Method, Flags = &h0
		Sub Constructor()
		  // Initialize example titles and their corresponding constants
		  mExampleTitles.Add("Example 1: Simple Shapes")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample1)
		  mExampleTitles.Add("Example 2: Text Layouts")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample2)
		  mExampleTitles.Add("Example 3: Multiple Pages")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample3)
		  mExampleTitles.Add("Example 4: Line Widths")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample4)
		  mExampleTitles.Add("Example 5: UTF-8 & TrueType Fonts")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample5)
		  mExampleTitles.Add("Example 6: Text Measurement")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample6)
		  mExampleTitles.Add("Example 7: Document Metadata")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample7)
		  mExampleTitles.Add("Example 8: Error Handling")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample8)
		  mExampleTitles.Add("Example 9: Image Support (JPEG)")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample9)
		  mExampleTitles.Add("Example 10: Header/Footer Callbacks")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample10)
		  mExampleTitles.Add("Example 11: Links and Bookmarks")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample11)
		  mExampleTitles.Add("Example 12: Custom Page Formats")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample12)
		  mExampleTitles.Add("Example 13: PDF/A Compliance")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample13)
		  mExampleTitles.Add("Example 14: Document Encryption")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample14)
		  mExampleTitles.Add("Example 15: Watermark Header")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample15)
		  mExampleTitles.Add("Example 16: Formatting Features")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample16)
		  mExampleTitles.Add("Example 17: Utility Methods")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample17)
		  mExampleTitles.Add("Example 18: Plugin Architecture")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample18)
		  mExampleTitles.Add("Example 19: Table Generation")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample19)
		  mExampleTitles.Add("Example 20: PDF Import")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample20)
		  mExampleTitles.Add("Example 21: UTF-8 All Languages")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample21)
		  mExampleTitles.Add("Example 22: UTF Compatibility Wrapper")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample22)
		  mExampleTitles.Add("Example 23: File Attachments")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample23)
		  mExampleTitles.Add("Example 24: PDF Forms (Premium)")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample24)
		  mExampleTitles.Add("Example 26: Bug Tests")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample26)
		  mExampleTitles.Add("Example 27: HTML Import (Premium)")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample27)
		  mExampleTitles.Add("Example 28: Markdown Import (Premium)")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample28)
		  mExampleTitles.Add("Example 29: GraphicsPath")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample29)
		  mExampleTitles.Add("Example 30: E-Invoice (Premium)")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample30)
		  mExampleTitles.Add("Example 31: E-Invoice Checker (Premium)")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample31)
		  mExampleTitles.Add("Example 32: Digital Signatures (Premium)")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample32)
		  mExampleTitles.Add("Example 33: Barcodes")
		  mExampleConstants.Add(VNSPDFExamplesModule.kExample33)
		  mExampleTitles.Add("Test Zlib: Premium Compression")
		  mExampleConstants.Add(VNSPDFExamplesModule.kTestZlib)
		  mExampleTitles.Add("Test AES: Premium Encryption")
		  mExampleConstants.Add(VNSPDFExamplesModule.kTestAES)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ExampleConstant(row As Integer) As Integer
		  // Return the example constant for a given row index
		  If row >= 0 And row < mExampleConstants.Count Then
		    Return mExampleConstants(row)
		  End If
		  Return -1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RowCount(table As iOSMobileTable, section As Integer) As Integer
		  // Return number of rows for the section
		  #Pragma Unused table
		  #Pragma Unused section
		  
		  Return mExampleTitles.Count
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RowData(table As iOSMobileTable, section As Integer, row As Integer) As MobileTableCellData
		  // Provide data for each cell
		  #Pragma Unused section
		  
		  If row >= 0 And row < mExampleTitles.Count Then
		    Dim cell As MobileTableCellData = table.CreateCell(mExampleTitles(row))
		    cell.AccessoryType = MobileTableCellData.AccessoryTypes.Disclosure
		    Return cell
		  Else
		    Return table.CreateCell("")
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SectionCount(table As iOSMobileTable) As Integer
		  // Return total number of sections (just 1 for our examples)
		  #Pragma Unused table
		  
		  Return 1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SectionTitle(table As iOSMobileTable, section As Integer) As String
		  // Return section title
		  #Pragma Unused table
		  #Pragma Unused section
		  
		  Return ""
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mExampleConstants() As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mExampleTitles() As String
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
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
	#tag EndViewBehavior
End Class
#tag EndClass
