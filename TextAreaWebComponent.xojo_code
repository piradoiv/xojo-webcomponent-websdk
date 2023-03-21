#tag Class
Protected Class TextAreaWebComponent
Inherits WebSDKUIControl
	#tag Event
		Sub DrawControlInLayoutEditor(g as graphics)
		  g.DrawingColor = &c808080
		  g.DrawRoundRectangle(0, 0, g.Width, g.Height - g.FontSize - 10, 8, 8)
		  
		  Var limit As Integer = Max(0, IntegerProperty("Limit"))
		  g.DrawingColor = &c008000
		  g.FontSize = 16
		  g.DrawText("0/" + limit.ToString, 0, g.Height - 2)
		End Sub
	#tag EndEvent

	#tag Event
		Function ExecuteEvent(name as string, parameters as JSONItem) As Boolean
		  Select Case name.Lowercase
		  Case "change"
		    mText = parameters.Lookup("text", "")
		    TextChanged(mText)
		  End Select
		End Function
	#tag EndEvent

	#tag Event
		Function HandleRequest(Request As WebRequest, Response As WebResponse) As Boolean
		  // Ignored in this example
		End Function
	#tag EndEvent

	#tag Event
		Function JavaScriptClassName() As String
		  Return "Example.XojoWebComponent"
		End Function
	#tag EndEvent

	#tag Event
		Sub Serialize(js as JSONItem)
		  js.Value("limit") = mLimit
		  js.Value("text") = mText
		End Sub
	#tag EndEvent

	#tag Event
		Function SessionCSSURLs(session as WebSession) As String()
		  // Ignored in this example
		End Function
	#tag EndEvent

	#tag Event
		Function SessionHead(session as WebSession) As String
		  // Ignored in this example
		End Function
	#tag EndEvent

	#tag Event
		Function SessionJavascriptURLs(session as WebSession) As String()
		  If WebComponentFile Is Nil Then
		    #If DebugBuild
		      Var f As FolderItem = SpecialFolder.Resources.Child("XojoTextArea.js")
		      WebComponentFile = WebFile.Open(f)
		      WebComponentFile.MIMEType = "application/javascript"
		      WebComponentFile.Session = Nil
		    #Else
		      WebComponentFile = New WebFile(False)
		      WebComponentFile.Filename = "XojoTextArea.js"
		      WebComponentFile.MIMEType = "application/javascript"
		      WebComponentFile.Data = kWebComponentData
		    #EndIf
		  End If
		  
		  If JsFile Is Nil Then
		    #If DebugBuild
		      Var f As FolderItem = SpecialFolder.Resources.Child("XojoWebComponent.js")
		      JsFile = WebFile.Open(f)
		      JsFile.MIMEType = "application/javascript"
		      JsFile.Session = Nil
		    #Else
		      JsFile = New WebFile(False)
		      JsFile.Filename = "XojoWebComponent.js"
		      JsFile.MIMEType = "application/javascript"
		      JsFile.Data = kJavaScript
		    #EndIf
		  End If
		  
		  Return Array(WebComponentFile.URL, JsFile.URL)
		End Function
	#tag EndEvent


	#tag Hook, Flags = &h0
		Event TextChanged(value As String)
	#tag EndHook


	#tag Property, Flags = &h21
		Private Shared JsFile As WebFile
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mLimit
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Var newValue As Integer = Max(0, value)
			  If mLimit = newValue Then
			    Return
			  End If
			  
			  mLimit = newValue
			  UpdateControl
			End Set
		#tag EndSetter
		Limit As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mLimit As Integer = 100
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mText As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mText
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If mText = value Then
			    Return
			  End If
			  
			  mText = value
			  UpdateControl
			End Set
		#tag EndSetter
		Text As String
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private Shared WebComponentFile As WebFile
	#tag EndProperty


	#tag Constant, Name = kJavaScript, Type = String, Dynamic = False, Default = \"\"use strict\";\nvar Example;\n(function (Example) {\n    class XojoWebComponent extends XojoWeb.XojoVisualControl {\n        updateControl(data) {\n            super.updateControl(data);\n            const js \x3D JSON.parse(data);\n        }\n        render() {\n            super.render();\n            const el \x3D this.DOMElement();\n            if (!el) {\n                return;\n            }\n            this.setAttributes();\n            this.applyUserStyle();\n            this.applyTooltip(el);\n        }\n    }\n    Example.XojoWebComponent \x3D XojoWebComponent;\n})(Example || (Example \x3D {}));\n", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kWebComponentData, Type = String, Dynamic = False, Default = \"\"use strict\";\n\nconst template \x3D document.createElement(\'template\');\ntemplate.innerHTML \x3D `\n    <style>\n        div {\n            padding: 5px;\n        }\n        textarea {\n            resize: none;\n            border: 1px solid gray;\n            border-radius: 4px;\n        }\n        .normal {\n            color:green;\n        }\n        .sepaso {\n            color:red;\n        }\n    </style>\n\n    <div>\n        <textarea id\x3D\"txtArea\" cols\x3D\"20\" rows\x3D\"5\"></textarea><br>\n        <span id\x3D\"info\" class\x3D\"normal\">0/0</span>\n    </div>\n`;\n\nclass XojoTextArea extends HTMLElement {\n    #state \x3D {};\n\n    constructor() {\n        super();\n        this.root \x3D  this.attachShadow({ mode: \'closed\' });\n\n        let clone \x3D template.content.cloneNode(true);\n        this.root.append(clone);\n\n    }\n\n    // ************** Attribute Getters and Setters **********************\n    get limit() {\n        return this.getAttribute(\"limit\");\n    };\n    set limit(value) {\n        if (!isNaN(value)) this.setAttribute(\'limit\'\x2C value); //If number update attribute\n    };\n\n    //***************** End *********************************************** */\n\n\n    connectedCallback() {\n        //As soon as component is loaded in page\n        console.log(\'connectedCallback\');\n\n        //Register Event for textarea\n        this.root.getElementById(\'txtArea\').addEventListener(\'input\'\x2C (e) \x3D> {\n            this.#showInfo();\n        });\n        \n    }\n    disconnectedCallback() {\n        // When component is removed from page\n        console.log(\'connectedCallback\');\n    }\n\n    static get observedAttributes() {\n        //Define which attributes we are going to observed for any changes\n        return [\"limit\"];\n    }\n\n    attributeChangedCallback(attrName\x2C oldValue\x2C newValue) {\n        console.log(\'attributeChangedCallBack\');\n\n        if (attrName.toLowerCase() \x3D\x3D\x3D \"limit\") {\n            console.log(`Attribute limit changed from \'${oldValue \? oldValue : 0}\' to \'${newValue}\'`);\n            //Send Event up\n            this.#sentEventUp(\'Limit changed\'\x2C{oldLimit:oldValue\x2CnewLimit:newValue});\n\n            this.#showInfo();\n        }\n    }\n\n    #showInfo() {\n        let txtArea \x3D this.root.getElementById(\'txtArea\');\n        let pInfo \x3D this.root.getElementById(\'info\');\n\n        if (txtArea && pInfo) {\n            let chars \x3D txtArea.value.length;\n            let limit \x3D this.limit;\n\n            pInfo.textContent \x3D \"\";\n            pInfo.textContent \x3D `${chars}/${limit}`;\n\n            //Check limit and set class\n            if (chars > limit) pInfo.classList.replace(\'normal\'\x2C\'sepaso\');\n            else pInfo.classList.replace(\'sepaso\'\x2C\'normal\');\n        }\n        \n    }\n    \n    #sentEventUp(eventName\x2CobjToPass) {\n        //Factory to bubble up events\n\n        //console.log(\'sending event\'\x2CeventName);\n        let id \x3D this.getAttribute(\'id\');\n        if (id) objToPass[\'componentId\'] \x3D id;\n        \n        this.dispatchEvent(new CustomEvent(eventName\x2C{\n            bubbles: true\x2C\n            cancelable : false\x2C\n            composed: true\x2C\n            detail: objToPass\n        }));\n    }\n\n}\n\nwindow.customElements.define(\'xojo-textarea\'\x2C XojoTextArea);", Scope = Private
	#tag EndConstant


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
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="34"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
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
			Name="LockBottom"
			Visible=true
			Group="Position"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockHorizontal"
			Visible=true
			Group="Position"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockVertical"
			Visible=true
			Group="Position"
			InitialValue="False"
			Type="Boolean"
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
			Name="_mPanelIndex"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ControlID"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="_mName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Limit"
			Visible=true
			Group="Behavior"
			InitialValue="100"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Visual Controls"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Visual Controls"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Indicator"
			Visible=true
			Group="Visual Controls"
			InitialValue=""
			Type="WebUIControl.Indicators"
			EditorType="Enum"
			#tag EnumValues
				"0 - Default"
				"1 - Primary"
				"2 - Secondary"
				"3 - Success"
				"4 - Danger"
				"5 - Warning"
				"6 - Info"
				"7 - Light"
				"8 - Dark"
				"9 - Link"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="Text"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
