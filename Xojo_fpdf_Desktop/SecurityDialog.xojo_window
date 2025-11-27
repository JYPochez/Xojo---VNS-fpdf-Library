#tag DesktopWindow
Begin DesktopWindow SecurityDialog
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF
   Composite       =   False
   DefaultLocation =   1
   FullScreen      =   False
   HasBackgroundColor=   False
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   False
   HasMinimizeButton=   True
   HasTitleBar     =   True
   Height          =   580
   ImplicitInstance=   False
   MacProcID       =   0
   MaximumHeight   =   580
   MaximumWidth    =   550
   MenuBar         =   0
   MenuBarVisible  =   False
   MinimumHeight   =   580
   MinimumWidth    =   550
   Resizeable      =   False
   Title           =   "PDF Security Settings"
   Type            =   1
   Visible         =   True
   Width           =   550
   Begin DesktopLabel lblTitle
      AllowAutoDeactivate=   True
      Bold            =   True
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   14.0
      FontUnit        =   0
      Height          =   24
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Configure PDF Security"
      TextAlignment   =   2
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   20
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   510
   End
   Begin DesktopLabel lblEncryption
      AllowAutoDeactivate=   True
      Bold            =   True
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Encryption Level:"
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   60
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   150
   End
   Begin DesktopPopupMenu popEncryption
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   22
      Index           =   -2147483648
      InitialValue    =   "Revision 4: AES-128 (RECOMMENDED)\nRevision 5: AES-256 (BEST - For Sensitive Data)\nRevision 6: AES-256 PDF 2.0 (BEST - For Sensitive Data)\nRevision 3: RC4-128 (LEGACY - Broken Encryption)\nRevision 2: RC4-40 (WEAK - Not Recommended)"
      Italic          =   False
      Left            =   180
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Scope           =   0
      SelectedRowIndex=   0
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   58
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   350
   End
   Begin DesktopLabel lblUserPassword
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "User Password:"
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   100
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   150
   End
   Begin DesktopTextField txtUserPassword
      AllowAutoDeactivate=   True
      AllowFocusRing  =   True
      AllowSpellChecking=   False
      AllowTabs       =   False
      BackgroundColor =   &cFFFFFF
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Format          =   ""
      HasBorder       =   True
      Height          =   22
      Hint            =   "Required to open PDF"
      Index           =   -2147483648
      Italic          =   False
      Left            =   180
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      MaximumCharactersAllowed=   0
      Password        =   False
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   98
      Transparent     =   False
      Underline       =   False
      ValidationMask  =   ""
      Visible         =   True
      Width           =   350
   End
   Begin DesktopLabel lblOwnerPassword
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   5
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Owner Password:"
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   130
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   150
   End
   Begin DesktopTextField txtOwnerPassword
      AllowAutoDeactivate=   True
      AllowFocusRing  =   True
      AllowSpellChecking=   False
      AllowTabs       =   False
      BackgroundColor =   &cFFFFFF
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Format          =   ""
      HasBorder       =   True
      Height          =   22
      Hint            =   "Optional (defaults to user password)"
      Index           =   -2147483648
      Italic          =   False
      Left            =   180
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      MaximumCharactersAllowed=   0
      Password        =   False
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   6
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   128
      Transparent     =   False
      Underline       =   False
      ValidationMask  =   ""
      Visible         =   True
      Width           =   350
   End
   Begin DesktopLabel lblPermissions
      AllowAutoDeactivate=   True
      Bold            =   True
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   7
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Document Permissions:"
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   170
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   200
   End
   Begin DesktopCheckBox chkAllowPrint
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Allow Printing"
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   40
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   8
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   200
      Transparent     =   False
      Underline       =   False
      Value           =   True
      Visible         =   True
      VisualState     =   1
      Width           =   240
   End
   Begin DesktopCheckBox chkAllowModify
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Allow Modifying Content"
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   40
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   9
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   230
      Transparent     =   False
      Underline       =   False
      Value           =   True
      Visible         =   True
      VisualState     =   1
      Width           =   240
   End
   Begin DesktopCheckBox chkAllowCopy
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Allow Copying Text/Graphics"
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   40
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   10
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   260
      Transparent     =   False
      Underline       =   False
      Value           =   True
      Visible         =   True
      VisualState     =   1
      Width           =   240
   End
   Begin DesktopCheckBox chkAllowAnnotations
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Allow Annotations/Comments"
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   40
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   11
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   290
      Transparent     =   False
      Underline       =   False
      Value           =   True
      Visible         =   True
      VisualState     =   1
      Width           =   240
   End
   Begin DesktopCheckBox chkAllowFillForms
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Allow Filling Forms"
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   40
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   12
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   320
      Transparent     =   False
      Underline       =   False
      Value           =   True
      Visible         =   True
      VisualState     =   1
      Width           =   240
   End
   Begin DesktopCheckBox chkAllowExtract
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Allow Text Extraction (Accessibility)"
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   40
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   13
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   350
      Transparent     =   False
      Underline       =   False
      Value           =   True
      Visible         =   True
      VisualState     =   1
      Width           =   300
   End
   Begin DesktopCheckBox chkAllowAssemble
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Allow Page Assembly (Insert/Rotate/Delete)"
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   40
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   14
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   380
      Transparent     =   False
      Underline       =   False
      Value           =   True
      Visible         =   True
      VisualState     =   1
      Width           =   350
   End
   Begin DesktopCheckBox chkAllowPrintHighQuality
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Allow High-Quality Printing"
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   40
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   15
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   410
      Transparent     =   False
      Underline       =   False
      Value           =   True
      Visible         =   True
      VisualState     =   1
      Width           =   240
   End
   Begin DesktopLabel lblNote
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   9.0
      FontUnit        =   0
      Height          =   60
      Index           =   -2147483648
      Italic          =   True
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Multiline       =   True
      Scope           =   0
      Selectable      =   False
      TabIndex        =   16
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Note: Leave user password blank to create an unencrypted PDF.\n\nRevision 4 (AES-128) is recommended for modern security.\nRevisions 5-6 (AES-256) provide the highest security for sensitive documents.\n\nAES encryption now works via pure Xojo implementation (no Crypto API limitations)."
      TextAlignment   =   0
      TextColor       =   &c808080
      Tooltip         =   ""
      Top             =   450
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   510
   End
   Begin DesktopButton btnOK
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Generate PDF"
      Default         =   True
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   32
      Index           =   -2147483648
      Italic          =   False
      Left            =   340
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   17
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   528
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   190
   End
   Begin DesktopButton btnCancel
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   True
      Caption         =   "Cancel"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   32
      Index           =   -2147483648
      Italic          =   False
      Left            =   140
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   18
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   528
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   180
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Property, Flags = &h0
		AllowAnnotations As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		AllowAssemble As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		AllowCopy As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		AllowExtract As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		AllowFillForms As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		AllowModify As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		AllowPrint As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		AllowPrintHighQuality As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		EncryptionRevision As Integer = 3
	#tag EndProperty

	#tag Property, Flags = &h0
		OwnerPassword As String
	#tag EndProperty

	#tag Property, Flags = &h0
		UserCancelled As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		UserPassword As String
	#tag EndProperty


#tag EndWindowCode

#tag Events btnOK
	#tag Event
		Sub Pressed()
		  // Get values from form
		  Select Case popEncryption.SelectedRowIndex
		  Case 0
		    EncryptionRevision = VNSPDFModule.gkEncryptionAES128  // AES-128 (RECOMMENDED)
		  Case 1
		    EncryptionRevision = VNSPDFModule.gkEncryptionAES256  // AES-256 (BEST)
		  Case 2
		    EncryptionRevision = VNSPDFModule.gkEncryptionAES256_PDF2  // AES-256 PDF 2.0 (BEST)
		  Case 3
		    EncryptionRevision = VNSPDFModule.gkEncryptionRC4_128  // RC4-128 (LEGACY - Broken)
		  Case 4
		    EncryptionRevision = VNSPDFModule.gkEncryptionRC4_40  // RC4-40 (WEAK)
		  End Select

		  UserPassword = txtUserPassword.Text.Trim
		  OwnerPassword = txtOwnerPassword.Text.Trim

		  // Get all 8 permission values
		  AllowPrint = chkAllowPrint.Value
		  AllowModify = chkAllowModify.Value
		  AllowCopy = chkAllowCopy.Value
		  AllowAnnotations = chkAllowAnnotations.Value
		  AllowFillForms = chkAllowFillForms.Value
		  AllowExtract = chkAllowExtract.Value
		  AllowAssemble = chkAllowAssemble.Value
		  AllowPrintHighQuality = chkAllowPrintHighQuality.Value

		  UserCancelled = False
		  Self.Close
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events btnCancel
	#tag Event
		Sub Pressed()
		  UserCancelled = True
		  Self.Close
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="HasTitleBar"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
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
		Name="Interfaces"
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
		Name="Width"
		Visible=true
		Group="Size"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Type"
		Visible=true
		Group="Frame"
		InitialValue="0"
		Type="Types"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Frame"
		InitialValue="Untitled"
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasCloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasFullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Visible=true
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DefaultLocation"
		Visible=true
		Group="Behavior"
		InitialValue="2"
		Type="Locations"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Window Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="&cFFFFFF"
		Type="ColorGroup"
		EditorType="ColorGroup"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Background"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Menus"
		InitialValue=""
		Type="DesktopMenuBar"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=true
		Group="Deprecated"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EncryptionRevision"
		Visible=false
		Group="Behavior"
		InitialValue="4"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="UserPassword"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="OwnerPassword"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowPrint"
		Visible=false
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowModify"
		Visible=false
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowCopy"
		Visible=false
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowAnnotations"
		Visible=false
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowFillForms"
		Visible=false
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowExtract"
		Visible=false
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowAssemble"
		Visible=false
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowPrintHighQuality"
		Visible=false
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="UserCancelled"
		Visible=false
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
