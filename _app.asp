<%'/*
'**********************************************
'      /\      | (_)
'     /  \   __| |_  __ _ _ __  ___
'    / /\ \ / _` | |/ _` | '_ \/ __|
'   / ____ \ (_| | | (_| | | | \__ \
'  /_/    \_\__,_| |\__,_|_| |_|___/
'               _/ | Digital Agency
'              |__/
'**********************************************
'* Project  : RabbitCMS
'* Developer: <Anthony Burak DURSUN>
'* E-Mail   : badursun@adjans.com.tr
'* Corp     : https://adjans.com.tr
'**********************************************
' LAST UPDATE: 28.10.2022 15:33 @badursun
'**********************************************
'*/
Class Sendgrid_Email_Plugin
	'/*
	'---------------------------------------------------------------
	' REQUIRED: Plugin Variables
	'---------------------------------------------------------------
	'*/
	Private PLUGIN_CODE, PLUGIN_DB_NAME, PLUGIN_NAME, PLUGIN_VERSION, PLUGIN_CREDITS, PLUGIN_GIT, PLUGIN_DEV_URL, PLUGIN_FILES_ROOT, PLUGIN_ICON, PLUGIN_REMOVABLE, PLUGIN_ROOT, PLUGIN_FOLDER_NAME, PLUGIN_AUTOLOAD
	Private SENDGRID_ACTIVE, SENDGRID_API_KEY, SENDGRID_API_VERSION
	Private SENDGRID_API_SEND_URL
	Private SENDGRID_TEMPLATE_WELCOME, SENDGRID_TEMPLATE_PASSREMINDER, SENDGRID_TEMPLATE_ECOM_ORDEROK, SENDGRID_TEMPLATE_ECOM_ORDERSEND, SENDGRID_TEMPLATE_ECOM_ORDERCANCEL
	Private SENDGRID_EMAIL_TO, SENDGRID_EMAIL_TO_NAME, SENDGRID_EMAIL_HTML, SENDGRID_EMAIL_SUBJECT, SENDGRID_EMAIL_FROM, SENDGRID_EMAIL_FROM_NAME
	Private SENDGRID_SIGNATURE
	'/*
	'---------------------------------------------------------------
	' REQUIRED: Plugin Variables
	'---------------------------------------------------------------
	'*/
	'/*
	'---------------------------------------------------------------
	' REQUIRED: Register Class
	'---------------------------------------------------------------
	'*/
	'/*
	'---------------------------------------------------------------
	' REQUIRED: Register Class
	'---------------------------------------------------------------
	'*/
	Public Property Get class_register()
		DebugTimer ""& PLUGIN_CODE &" class_register() Start"
		'/*
		'---------------------------------------------------------------
		' Check Register
		'---------------------------------------------------------------
		'*/
		' If CheckSettings("PLUGIN:"& PLUGIN_CODE &"") = True Then 
		' 	DebugTimer ""& PLUGIN_CODE &" class_registered"
		' 	Exit Property
		' End If
		' '/*
		' '---------------------------------------------------------------
		' ' Plugin Database
		' '---------------------------------------------------------------
		' '*/
		' Dim PluginTableName
		' 	PluginTableName = "tbl_plugin_" & PLUGIN_DB_NAME
    	
  '   	If TableExist(PluginTableName) = False Then
		' 	DebugTimer ""& PLUGIN_CODE &" table creating"
    		
  '   		Conn.Execute("SET NAMES utf8mb4;") 
  '   		Conn.Execute("SET FOREIGN_KEY_CHECKS = 0;") 
    		
  '   		Conn.Execute("DROP TABLE IF EXISTS `"& PluginTableName &"`")

  '   		q="CREATE TABLE `"& PluginTableName &"` ( "
  '   		q=q+"  `ID` int(11) NOT NULL AUTO_INCREMENT, "
  '   		q=q+"  `FILENAME` varchar(255) DEFAULT NULL, "
  '   		q=q+"  `FULL_PATH` varchar(255) DEFAULT NULL, "
  '   		q=q+"  `COMPRESS_DATE` datetime DEFAULT NULL, "
  '   		q=q+"  `COMPRESS_RATIO` double(255,0) DEFAULT NULL, "
  '   		q=q+"  `ORIGINAL_FILE_SIZE` bigint(20) DEFAULT 0, "
  '   		q=q+"  `COMPRESSED_FILE_SIZE` bigint(20) DEFAULT 0, "
  '   		q=q+"  `EARNED_SIZE` bigint(20) DEFAULT 0, "
  '   		q=q+"  `ORIGINAL_PROTECTED` int(1) DEFAULT 0, "
  '   		q=q+"  PRIMARY KEY (`ID`), "
  '   		q=q+"  KEY `IND1` (`FILENAME`) "
  '   		q=q+") ENGINE=MyISAM DEFAULT CHARSET=utf8; "
		' 	Conn.Execute(q)

  '   		Conn.Execute("SET FOREIGN_KEY_CHECKS = 1;") 

		' 	' Create Log
		' 	'------------------------------
  '   		Call PanelLog(""& PLUGIN_CODE &" için database tablosu oluşturuldu", 0, ""& PLUGIN_CODE &"", 0)

		' 	' Register Settings
		' 	'------------------------------
		' 	DebugTimer ""& PLUGIN_CODE &" class_register() End"
  '   	End If
		'/*
		'---------------------------------------------------------------
		' Plugin Settings
		'---------------------------------------------------------------
		'*/
		a=GetSettings("PLUGIN:"& PLUGIN_CODE &"", PLUGIN_CODE&"_")
		a=GetSettings(""&PLUGIN_CODE&"_CLASS", "Sendgrid_Email_Plugin")
		a=GetSettings(""&PLUGIN_CODE&"_REGISTERED", ""& Now() &"")
		a=GetSettings(""&PLUGIN_CODE&"_FOLDER", PLUGIN_FOLDER_NAME)
		a=GetSettings(""&PLUGIN_CODE&"_CODENO", "332")
		a=GetSettings(""&PLUGIN_CODE&"_PLUGIN_NAME", PLUGIN_NAME)
		'/*
		'---------------------------------------------------------------
		' Register Settings
		'---------------------------------------------------------------
		'*/
		DebugTimer ""& PLUGIN_CODE &" class_register() End"
	End Property
	'/*
	'---------------------------------------------------------------
	' REQUIRED: Register Class End
	'---------------------------------------------------------------
	'*/
	'/*
	'---------------------------------------------------------------
	' REQUIRED: Plugin Settings Panel
	'---------------------------------------------------------------
	'*/
	Public sub LoadPanel()
		'/*
		'--------------------------------------------------------
		' Sub Page
		'--------------------------------------------------------
		'*/
		If Query.Data("Page") = "SHOW:CachedFiles" Then
			Call PluginPage("Header")

			Call PluginPage("Footer")
			Call SystemTeardown("destroy")
		End If
		'/*
		'--------------------------------------------------------
		' Main Page
		'--------------------------------------------------------
		'*/
		With Response
			'------------------------------------------------------------------------------------------
				PLUGIN_PANEL_MASTER_HEADER This()
			'------------------------------------------------------------------------------------------
			.Write "<div class=""row"">"
			.Write "    <div class=""col-lg-6 col-sm-12"">"
			.Write 			PLUGIN_PANEL_INPUT(This, "input", "API_KEY", "API Key", "", TO_DB)
			.Write "    </div>"
			.Write "    <div class=""col-lg-6 col-sm-12"">"
			.Write 			PLUGIN_PANEL_INPUT(This,"select", "API_VERSION", "API Versiyonu", "1#Version 1|2#Version 2|3#Version 3", TO_DB)
			.Write "    </div>"
			.Write "</div>"
			
			.Write "<div class=""row"">"
			.Write "    <div class=""col-lg-12 col-sm-12"">"
			.Write "    	<h5 class=""d-block"">Dinamik Şablonlar"
			.Write "			<a data-toggle=""collapse"" href=""#DynamicTemplateList"" aria-expanded=""false"" aria-controls=""DynamicTemplateList"" class=""btn btn-sm btn-primary float-right mb-1"">Dinamik Şablonları Göster</a>"
			.Write "		</h5>"
			.Write "    </div>"
			.Write "    <div class=""col-lg-12 col-sm-12"">"
			.Write "    <div class=""collapse"" id=""DynamicTemplateList"">"
			.Write "    	<style>.zero-pad-input tr, .zero-pad-input td{padding:0px;} .zero-pad-input .form-group{margin-bottom:0px;}</style>"
			.Write "    	<table class=""table table-striped zero-pad-input"">"
			.Write "    		<thead>"
			.Write "    			<tr>"
			.Write "    				<td class=""p-2""><strong>Dinamik Şablon Tanımı</strong></td>"
			.Write "    				<td class=""p-2""><strong>Dinamik Şablon ID</strong></td>"
			.Write "    			</tr>"
			.Write "    		</thead>"
			.Write "    		<tbody>"

			.Write "    			<tr>"
			.Write "    				<td>Yeni Kayıt E-Postası</td>"
			.Write "    				<td>"& PLUGIN_PANEL_INPUT(This,"input","TEMPLATE_WELCOME","","",TO_DB) &"</td>"
			.Write "    			</tr>"
			.Write "    			<tr>"
			.Write "    				<td>Parolamı Unuttum E-Postası</td>"
			.Write "    				<td>"& PLUGIN_PANEL_INPUT(This,"input","TEMPLATE_PASSREMINDER","","",TO_DB) &"</td>"
			.Write "    			</tr>"
			If CMS_ECOMMERCE_STATUS = 1 Then
			.Write "    			<tr>"
			.Write "    				<td>Sipariş Tamamlandı E-Postası</td>"
			.Write "    				<td>"& PLUGIN_PANEL_INPUT(This,"input","TEMPLATE_ECOM_ORDEROK","","",TO_DB) &"</td>"
			.Write "    			</tr>"
			.Write "    			<tr>"
			.Write "    				<td>Sipariş Gönderildi E-Postası</td>"
			.Write "    				<td>"& PLUGIN_PANEL_INPUT(This,"input","TEMPLATE_ECOM_ORDERSEND","","",TO_DB) &"</td>"
			.Write "    			</tr>"
			.Write "    			<tr>"
			.Write "    				<td>Sipariş İptal Edildi E-Postası</td>"
			.Write "    				<td>"& PLUGIN_PANEL_INPUT(This,"input","TEMPLATE_ECOM_ORDERCANCEL","","",TO_DB) &"</td>"
			.Write "    			</tr>"
			End If
			.Write "    		</tbody>"
			.Write "    	</table>"
			.Write "    </div>"
			.Write "    </div>"
			.Write "</div>"

			.Write "<div class=""row"">"
			.Write "    <div class=""col-lg-12 col-sm-12"">"
			.Write "    	<hr/>"
			.Write "    </div>"
			.Write "    <div class=""col-lg-12 col-sm-12"">"
			.Write "        <a href=""https://signup.sendgrid.com/"" target=""_blank"" class=""btn btn-sm btn-primary"">"
			.Write "        	Sendgrid Hesabı Oluşturun"
			.Write "        </a>"
			.Write "        <a href=""https://mc.sendgrid.com/dynamic-templates"" target=""_blank"" class=""btn btn-sm btn-primary"">"
			.Write "        	Dinamik Şablon Nedir?"
			.Write "        </a>"
			' .Write "        <a open-iframe href=""ajax.asp?Cmd=PluginSettings&PluginName="& PLUGIN_CODE &"&Page=DELETE:CachedFiles"" class=""btn btn-sm btn-danger"">"
			' .Write "        	Tüm Önbelleği Temizle"
			' .Write "        </a>"
			.Write "    </div>"
			.Write "</div>"
		End With
	End Sub
	'/*
	'---------------------------------------------------------------
	' REQUIRED: Plugin Settings Panel
	'---------------------------------------------------------------
	'*/
	'/*
	'---------------------------------------------------------------
	' REQUIRED: Plugin Class Initialize
	'---------------------------------------------------------------
	'*/
	Private Sub class_initialize()
		'/*
		'-----------------------------------------------------------------------------------
		' REQUIRED: PluginTemplate Main Variables
		'-----------------------------------------------------------------------------------
		'*/
    	PLUGIN_CODE  			= "SENDGRID_EMAIL"
    	PLUGIN_NAME 			= "Sendgrid Email Plugin"
    	PLUGIN_VERSION 			= "1.0.0"
    	PLUGIN_GIT 				= "https://github.com/RabbitCMS-Hub/Sendgrid-Email-Plugin"
    	PLUGIN_DEV_URL 			= "https://adjans.com.tr"
    	PLUGIN_ICON 			= "zmdi-mail-send"
    	PLUGIN_CREDITS 			= "@badursun Anthony Burak DURSUN"
    	PLUGIN_FOLDER_NAME 		= "Sendgrid-Email-Plugin"
    	PLUGIN_DB_NAME 			= "sendgrid_log"
    	PLUGIN_REMOVABLE 		= True
    	PLUGIN_AUTOLOAD 		= True
    	PLUGIN_ROOT 			= PLUGIN_DIST_FOLDER_PATH(This)
    	PLUGIN_FILES_ROOT 		= PLUGIN_VIRTUAL_FOLDER(This)
		'/*
    	'-------------------------------------------------------------------------------------
    	' PluginTemplate Main Variables
    	'-------------------------------------------------------------------------------------
		'*/
		SENDGRID_ACTIVE 		= Cint( GetSettings(""&PLUGIN_CODE&"_ACTIVE", "0") )
		SENDGRID_API_KEY 		= GetSettings(""&PLUGIN_CODE&"_API_KEY", "0")
		SENDGRID_API_VERSION 	= GetSettings(""&PLUGIN_CODE&"_API_VERSION", "3")
		
		SENDGRID_API_SEND_URL 	= "https://api.sendgrid.com/v"& SENDGRID_API_VERSION &"/mail/send"

		SENDGRID_TEMPLATE_WELCOME 			= GetSettings(PLUGIN_CODE &"_TEMPLATE_WELCOME", "")
		SENDGRID_TEMPLATE_PASSREMINDER 		= GetSettings(PLUGIN_CODE &"_TEMPLATE_PASSREMINDER", "")
		SENDGRID_TEMPLATE_ECOM_ORDEROK 		= GetSettings(PLUGIN_CODE &"_TEMPLATE_ECOM_ORDEROK", "")
		SENDGRID_TEMPLATE_ECOM_ORDERSEND 	= GetSettings(PLUGIN_CODE &"_TEMPLATE_ECOM_ORDERSEND", "")
		SENDGRID_TEMPLATE_ECOM_ORDERCANCEL 	= GetSettings(PLUGIN_CODE &"_TEMPLATE_ECOM_ORDERCANCEL", "")

		SENDGRID_EMAIL_TO 		= Null
		SENDGRID_EMAIL_TO_NAME 	= Null
		SENDGRID_EMAIL_HTML 	= Null
		SENDGRID_EMAIL_SUBJECT 	= Null
		SENDGRID_EMAIL_FROM 	= Null
		SENDGRID_EMAIL_FROM_NAME= Null

		SENDGRID_SIGNATURE 		= "<div style=""font-size:8px;text-align:center;padding:4px;color:#b3b3b3;"">"& PLUGIN_NAME &" v"& PLUGIN_VERSION &"</div>"
		'/*
		'-----------------------------------------------------------------------------------
		' REQUIRED: Register Plugin to CMS
		'-----------------------------------------------------------------------------------
		'*/
		class_register()
		'/*
		'-----------------------------------------------------------------------------------
		' REQUIRED: Hook Plugin to CMS Auto Load Location WEB|API|PANEL
		'-----------------------------------------------------------------------------------
		'*/
		If SENDGRID_ACTIVE = 1 Then 
			PLUGIN_HOOK "engine:email", This()
		End If

		If PLUGIN_AUTOLOAD_AT("WEB") = True Then 			
			' Cms.BodyData = Init()
			' Cms.FooterData = "<add-footer-html>Hello World!</add-footer-html>"
		End If
	End Sub
	'/*
	'---------------------------------------------------------------
	' REQUIRED: Plugin Class Initialize
	'---------------------------------------------------------------
	'*/
	'/*
	'---------------------------------------------------------------
	' REQUIRED: Plugin Class Terminate
	'---------------------------------------------------------------
	'*/
	Private sub class_terminate()

	End Sub
	'/*
	'---------------------------------------------------------------
	' REQUIRED: Plugin Class Terminate
	'---------------------------------------------------------------
	'*/
	'/*
	'---------------------------------------------------------------
	' REQUIRED: Plugin Manager Exports
	'---------------------------------------------------------------
	'*/
	Public Property Get PluginCode() 		: PluginCode = PLUGIN_CODE 					: End Property
	Public Property Get PluginName() 		: PluginName = PLUGIN_NAME 					: End Property
	Public Property Get PluginVersion() 	: PluginVersion = PLUGIN_VERSION 			: End Property
	Public Property Get PluginGit() 		: PluginGit = PLUGIN_GIT 					: End Property
	Public Property Get PluginDevURL() 		: PluginDevURL = PLUGIN_DEV_URL 			: End Property
	Public Property Get PluginFolder() 		: PluginFolder = PLUGIN_FILES_ROOT 			: End Property
	Public Property Get PluginIcon() 		: PluginIcon = PLUGIN_ICON 					: End Property
	Public Property Get PluginRemovable() 	: PluginRemovable = PLUGIN_REMOVABLE 		: End Property
	Public Property Get PluginCredits() 	: PluginCredits = PLUGIN_CREDITS 			: End Property
	Public Property Get PluginRoot() 		: PluginRoot = PLUGIN_ROOT 					: End Property
	Public Property Get PluginFolderName() 	: PluginFolderName = PLUGIN_FOLDER_NAME 	: End Property
	Public Property Get PluginDBTable() 	: PluginDBTable = IIf(Len(PLUGIN_DB_NAME)>2, "tbl_plugin_"&PLUGIN_DB_NAME, "") 	: End Property
	Public Property Get PluginAutoload() 	: PluginAutoload = PLUGIN_AUTOLOAD 			: End Property

	Private Property Get This()
		This = Array(PluginCode, PluginName, PluginVersion, PluginGit, PluginDevURL, PluginFolder, PluginIcon, PluginRemovable, PluginCredits, PluginRoot, PluginFolderName, PluginDBTable, PluginAutoload)
	End Property
	'/*
	'---------------------------------------------------------------
	' REQUIRED: Plugin Manager Exports
	'---------------------------------------------------------------
	'*/

	'/*
	'---------------------------------------------------------------
	' 
	'---------------------------------------------------------------
	'*/
	Public Property Get SendEmail()
		Dim JSON_DATA
	    Set oJSON = New aspJSON
	        With oJSON.data
	        	.Add "personalizations", oJSON.Collection()
	        	With .item("personalizations")
					.Add 0, oJSON.Collection()
					With .item(0)
			        	.Add "to" 				, oJSON.Collection()
			        	With .item("to")
			        		' LOOP ii
							.Add 0, oJSON.Collection()
							With .item(0)
								.Add "email" 	, SENDGRID_EMAIL_TO '"badursun@gmail.com"
								.Add "name" 	, SENDGRID_EMAIL_TO_NAME '"Anthony Burak DURSUN"
			        		End With
			        		' LOOP
			        	End With
						.Add "subject" 			, SENDGRID_EMAIL_SUBJECT '"Sendgrid Email Plugin from RabbitCMS"
	        		End With
	        	End With
	        	.Add "content", oJSON.Collection()
	        	With .item("content")
					.Add 0, oJSON.Collection()
					With .item(0)
						.Add "type" 			, "text/html"
						.Add "value" 			, SENDGRID_EMAIL_HTML & SENDGRID_SIGNATURE '"and easy to do anywhere, even with cURL"
	        		End With
	        	End With
	        	.Add "from", oJSON.Collection()
	        	With .item("from")
	        		.Add "email" 				, SENDGRID_EMAIL_FROM '"noreply@rabbit-cms.com"
	        		.Add "name" 				, SENDGRID_EMAIL_FROM_NAME '"RabbitCMS"
	        	End With
	        	.Add "reply_to", oJSON.Collection()
	        	With .item("reply_to")
	        		.Add "email" 				, SENDGRID_EMAIL_FROM '"info@rabbit-cms.com"
	        		.Add "name" 				, SENDGRID_EMAIL_FROM_NAME '"Gonderen RabbitCMS"
	        	End With
	        End With
	        JSON_DATA = oJSON.JSONoutput()
	    Set oJSON = Nothing

	    Dim SendResult
	    	SendResult = XMLHttpRequest(SENDGRID_API_SEND_URL, "POST", JSON_DATA, "Bearer", SENDGRID_API_KEY, "application/json")

	    SendEmail = SendResult
	End Property
	'/*
	'---------------------------------------------------------------
	' 
	'---------------------------------------------------------------
	'*/
	'/*
	'---------------------------------------------------------------
	' 
	'---------------------------------------------------------------
	'*/
	Public Property Let setFrom(v) 		: SENDGRID_EMAIL_FROM = v 		: End Property
	Public Property Let setFromName(v) 	: SENDGRID_EMAIL_FROM_NAME = v 		: End Property
	Public Property Let setTo(v) 		: SENDGRID_EMAIL_TO = v 		: End Property
	Public Property Let setToName(v) 	: SENDGRID_EMAIL_TO_NAME = v 	: End Property
	Public Property Let setHtml(v) 		: SENDGRID_EMAIL_HTML = v 		: End Property
	Public Property Let setSubject(v) 	: SENDGRID_EMAIL_SUBJECT = v 	: End Property
	'/*
	'---------------------------------------------------------------
	' 
	'---------------------------------------------------------------
	'*/
End Class 
%>