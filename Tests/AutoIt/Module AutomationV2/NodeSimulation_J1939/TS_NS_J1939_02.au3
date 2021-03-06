;===============================Test Cases/Test Data ========================================
; Critical (C)		:		Y
; TestCase No.		:		TS_NS_J1939_02
; TestCases			:		API's handling for multiple node's
; Test Data			:		cfxNSJ1939_01.cfx
; Test Setup		:		1.Repeat the above test case till step
;                           2 for multiple DLLs.
;                           3.Attach those files to different nodes.
;                           4.Press "Build Load"
;                           5.If all the DLLs are build properly enable Key handlers for more than one node.
;                           6.Make the message window active.
;                           7.Press key a

;~
; Expected Results  : 		The no. of messages sent should match with the no. of node's whose key handlers are enabled
;================================Test Procedure =======================================================
ConsoleWrite(@CRLF)
ConsoleWrite("****Start : TS_NS_J1939_02.au3****"&@CRLF)


_launchApp()

WinActivate($WIN_BUSMASTER)
local $ChannelInfo=0,$CANIdInfo=0,$SrcInfo=0
if winexists($WIN_BUSMASTER) then
     _loadConfig("cfxNSJ1939_02.cfx")
		 sleep(1000)
         _ActivateJ1939()                                                                  ;Activate J1939 Message window
		sleep(1000)

	_J1939NodeSimConfigMenu()
     $TVHWD=_GetJ1939CppTVHWD()																; Fetch the handle of tree view
	_GUICtrlTreeView_Expand($TVHWD,"",True)													; Expand the tree view items
	sleep(1000)

	_BuildLoadAllJ1939() 	                                                             ; Click on 'Build and Load All' icon
	sleep(1000)
	_GUICtrlTreeView_Expand($TVHWD,"",True)
;~ 	WinMenuSelectItem($WIN_BUSMASTER,"",$J1939Menu,$J1939NodeSimMenu,"&Build All")
;~ 	sleep(1000)
;~ 	WinMenuSelectItem($WIN_BUSMASTER,"",$J1939Menu,$J1939NodeSimMenu,"&Load All")
;~ 	sleep(1000)

	;_EnableAllHandlers()																		; Click on 'Enable/Disable All key handlers' icon
	 _EnableAllKeyHandlersforJ1939()
	sleep(1500)

	_ConnectDisconnect()																	; Connect the tool
	sleep(700)
    send("^{F4}")
	send("a")																				; Invoke key handler
	sleep(4000)

	_DisableOverwriteMode()																	; Disable overwrite mode

	_ConnectDisconnect()																	; Disconnect the tool
	sleep(700)

	_UnLoadALLJ1939()																			; Click on 'Unload All' menu item

	send("^{F4}")																			; Close output window
	send("^{F4}")
	sleep(1000)
	$handle=ControlGetHandle($WIN_BUSMASTER,"",200)
	_GUICtrlListView_ClickItem($handle,0)
	sleep(1000)
    $rCount=_GetJ1939MsgWinItemCount()
	If $rCount>=4 Then

	     $Data1=_GetJ1939MsgWinInfo(0)                                                              ;Fetch the column entries of message window
	     $Data2=_GetJ1939MsgWinInfo(1)
	     $Data3=_GetJ1939MsgWinInfo(2)
	     $Data4=_GetJ1939MsgWinInfo(3)

        for $i=0 to 11
		ConsoleWrite("Data1 " &$Data1[$i] & @CRLF)
		ConsoleWrite("Data2 " &$Data2[$i] & @CRLF)
		ConsoleWrite("Data3 " &$Data3[$i] & @CRLF)
		ConsoleWrite("Data4 " &$Data4[$i] & @CRLF)
		Next


	    ConsoleWrite("$Data1[1]" & $Data1[1] & @CRLF)
	    ConsoleWrite("$Data2[1]" & $Data2[1] & @CRLF)
	     If($Data1[9]="Rx" And $Data2[9]="Rx" And $Data3[9]="Rx" And $Data4[9]="Rx") Then
		     $ChannelInfo=1
	     Else
		     $ChannelInfo=0
	     EndIf

	     If($Data1[2]="0x005" Or $Data3[2]="0x005") Then
		     $CANIdInfo=1
	     Else
		     $CANIdInfo=0
	    EndIf

	    If($Data1[6]=05 Or $Data3[6]=05) Then
		     $SrcInfo=1
	     Else
		    $SrcInfo=0
		EndIf
	EndIf



	 ConsoleWrite("Channel Info " & $ChannelInfo & @CRLF)
	ConsoleWrite("CAN id " & $CANIdInfo & @CRLF)
	 ConsoleWrite("Src Address " & $SrcInfo & @CRLF)

	 If($ChannelInfo=1 And $SrcInfo=1 And $CANIdInfo=1) Then
		_WriteResult("Pass","TS_J1939Node_02")
    Else
	_WriteResult("Fail","TS_J1939Node_02")
    EndIf
EndIf

$isAppNotRes=_CloseApp()															; Close the app

if $isAppNotRes=1 Then
	_WriteResult("Warning","TS_J1939Node_02")
EndIf


ConsoleWrite("****End : TS_J1939Node_02.au3****"&@CRLF)
ConsoleWrite(@CRLF)



