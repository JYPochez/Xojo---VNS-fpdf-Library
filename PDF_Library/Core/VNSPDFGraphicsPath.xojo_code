#tag Class
Protected Class VNSPDFGraphicsPath
	#tag Method, Flags = &h0
		Sub AddLineToPoint(x As Double, y As Double)
		  // Add a line from the current point to the specified point
		  Dim pt As New Point(x, y)
		  mPoints.Add(pt)
		  mCurrentPoint = pt
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  // Initialize empty path
		  mCurrentPoint = New Point(0, 0)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetPoints() As Point()
		  // Return the array of points
		  Return mPoints
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoveToPoint(x As Double, y As Double)
		  // Move to a point without drawing
		  Dim pt As New Point(x, y)
		  mPoints.Add(pt)
		  mCurrentPoint = pt
		End Sub
	#tag EndMethod

	#tag Property, Flags = &h21
		Private mCurrentPoint As Point
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPoints() As Point
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mCurrentPoint
			End Get
		#tag EndGetter
		CurrentPoint As Point
	#tag EndComputedProperty


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
