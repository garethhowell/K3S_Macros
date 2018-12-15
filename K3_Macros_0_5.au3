#comments-start
This script written by Iain Kelly (M0PCB)

Send Macro commands to an ELecraft K3 Transceiver on COMPORT 12 at 38400Baud 8N1 using Key combinations, primarily for use with a ShuttlePROv2 controller.

History:
Version 0.1 (06/01/2013) is all hard coded with required functions by M0PCB, future versions may include the ability to customise.
Version 0.2 (08/01/2013) adds final conditional Macro for SSB mode and split function, also adds variables for comport and baudrate. Hotkeys and macros are still hard coded.
Version 0.3 (09/01/2013) added USB mode selection between 5MHz and 5.5MHz, removed TrayTip in help function.
Version 0.4 (10/01/2013) added ATU bypass and enable for AmpOn and AmpOff functions.
Version 0.4.1 (13/01/2013) modified VFOB tuning rate to 10Hz from 50Hz for Jog wheel. 
Version 0.5 (03/03/2013) modified mode change macros to include filter bandwidth settings for JT65/RTTY/SSB and CW, modified serial port config, modified reading info from radio 
						 so now works with VSPE as well as LP-Bridge. Also added CW APF macro. Added automatic VOX on/off betwene SSB and data modes.
#comments-end


#AutoIt3Wrapper_OutFile_X64=N
#include "CommMG.au3"
#include <String.au3>
#include <Array.au3>

Global $error, $rawfreq, $freq, $mode, $baud, $comport, $apfstate, $ic

$comport = 12
$baud = 38400

_CommSetDllPath("C:\m0pcb\commg.dll")

HotKeySet("^!{F12}", "_Exit") ;If you press Ctrl-Shift-F12 the script will stop
HotKeySet("+{F1}", "_ShowMacros") ;If you press SHIFT + F1, the script will show witch sites you have on witch keys
HotKeySet("^!{NUMPAD9}", "_Split") 
HotKeySet("^!{NUMPAD6}", "_ClearSplit")
HotKeySet("^!{NUMPAD0}", "_SetSSB") 
HotKeySet("^!{NUMPAD1}", "_SetCW") 
HotKeySet("^!{NUMPAD2}", "_SetRTTY") 
HotKeySet("^!{NUMPAD3}", "_SetJT65") 
HotKeySet("^!{NUMPADADD}", "_BandUp") 
HotKeySet("^!{NUMPADSUB}", "_BandDwn") 
HotKeySet("^!{NUMPAD4}", "_PlayM1") 
HotKeySet("^!{NUMPAD5}", "_PlayM2") 
HotKeySet("^!{NUMPAD7}", "_AmpOn") 
HotKeySet("^!{NUMPAD8}", "_AmpOff") 
HotKeySet("^!{F1}", "_TuneAup10Hz") 
HotKeySet("^!{F2}", "_TuneAup50Hz") 
HotKeySet("^!{F3}", "_TuneAup100Hz") 
HotKeySet("^!{F4}", "_TuneAup200Hz") 
HotKeySet("^!{F5}", "_TuneAup1kHz") 
HotKeySet("^!{F6}", "_TuneAup2kHz") 
HotKeySet("^!{F7}", "_TuneAup5kHz") 
HotKeySet("^+!{F1}", "_TuneAdwn10Hz") 
HotKeySet("^+!{F2}", "_TuneAdwn50Hz") 
HotKeySet("^+!{F3}", "_TuneAdwn100Hz") 
HotKeySet("^+!{F4}", "_TuneAdwn200Hz") 
HotKeySet("^+!{F5}", "_TuneAdwn1kHz") 
HotKeySet("^+!{F6}", "_TuneAdwn2kHz") 
HotKeySet("^+!{F7}", "_TuneAdwn5kHz") 
HotKeySet("^!{F8}", "_TuneBup10Hz")
HotKeySet("^!+{F8}", "_TuneBdwn10Hz")
HotKeySet("^!{NUMPADMULT}", "_AtuSet")
HotKeySet("^!{NUMPADDIV}","_ApfSet")

While 1
Sleep(100)
WEnd

Func _Exit()
Sleep(100)
Exit
EndFunc ;==> _Exit()

Func _ShowMacros()
MsgBox(0, "M0PCB's K3 Controller / Macro Sender V1", "To Exit use Ctrl-Alt-F12")
EndFunc

Func _Split()
   
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommClearInputBuffer()
   _CommSendString("MD;", 0) ;sends mode query
   $mode = _CommGetLine(";", 0, 0) ;stores received data as a String
   _CommCloseport()
   
   Switch $mode
	  Case "MD1;", "MD2;" ;if mode is LSB, USB split set to plus 5kHz and audio switched with sub receiver
		 _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
		 _CommSendString("SWT13;SWT13;FT1;UPB7;RT0;XT0;SB1;MN111;MP001;MN255;", 0)
		 _CommCloseport()
	  Case "MD3;" ;if mode is CW split set to plus 2kHz and audio switched with sub receiver
		 _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
		 _CommSendString("SWT13;SWT13;FT1;UPB5;RT0;XT0;SB1;MN111;MP001;MN255;", 0)
		 _CommCloseport()
	  Case "MD6;" ;if mode is set to DATA the split set to plus 5kHz but no sub-rx or audio settings.
		 _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
		 _CommSendString("SWT13;SWT13;FT1;UPB5;RT0;XT0;", 0)
		 _CommCloseport()
   EndSwitch
   
EndFunc

Func _ClearSplit() ;resets radio to single receiver mode and no split
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("FT0;RT0;XT0;LN0;SQ000;SB0;", 0)
   _CommCloseport()
EndFunc

Func _SetSSB() ;sets radio to SSB mode depending on frequency band
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommClearInputBuffer()
   _CommSendString("VX;", 0) ; check to see if VOX is enabled
   local $vox = _CommGetLine(";", 0, 0)
   _CommClearInputBuffer()
   _CommCloseport()
   
   If $vox = "VX1;" Then ;if VOX enabled then disable vox for SSB
	  _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
	  _CommClearInputBuffer()
	  _CommSendString("SWH09;", 0)
	  _CommClosePort()
   EndIf
   
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommClearInputBuffer()
   _CommSendString("FA;", 1) ;query of VFOA for frequency
   $rawfreq = _CommGetLine(";", 0, 0) ;saved to $rawfreq as FAxxxxxxxxxxx
   _CommCloseport()
      
   $freq = StringTrimLeft($rawfreq, 4) ;remove first 4 characters of string so have a raw number. Can cope with bands up to 144MHz
   
   If $freq < 10000000 Then ;if freq less than 10MHz then set radio to LSB mode
	  If $freq >= 5000000 AND $freq <=5500000 Then ;if freq is in the 5MHz band then set to USB and 2.7kHz filter
		  _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
		 _CommSendString("MD2;PC100;BW0270;", 0)
		 _CommCloseport()
		 Else
	  	 _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
		 _CommSendString("MD1;PC100;BW0270;", 0)
		 _CommCloseport()
	  EndIf
   ElseIf $freq > 10000000 Then ;if freq greater than 10MHz then set radio to USB and 2.7kHz filter
		 _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
		 _CommSendString("MD2;PC100;BW0270;", 0)
		 _CommCloseport()
	  EndIf
      
EndFunc

Func _SetCW()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("MD3;PC100;BW0040;", 0)
   _CommCloseport()
EndFunc

Func _SetRTTY()
   
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommClearInputBuffer()
   _CommSendString("VX;", 0) ; check for VOX set to On
   local $vox = _CommGetLine(";", 0, 0)
   _CommClearInputBuffer()
   _CommCloseport()
   
   If $vox = "VX1;" Then ;if VOX on then change to RTTY mode as normal 
	  _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
	  _CommClearInputBuffer()
	  _CommSendString("MD6;PC100;BW0040;", 0)
	  _CommClosePort()
   ElseIf $vox = "VX0;" Then ; if VOX off then turn VOX on and enter RTTY mode
	  _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
	  _CommClearInputBuffer()
	  _CommSendString("MD6;PC100;BW0040;SWH09;", 0)
	  _CommClosePort()
   EndIf
   
EndFunc

Func _SetJT65()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommClearInputBuffer()
   _CommSendString("VX;", 0) ; check VOX state
   local $vox = _CommGetLine(";", 0, 0)
   _CommClearInputBuffer()
   _CommCloseport()
   
   If $vox = "VX1;" Then ;if VOX is on the change to JT65 mode
	  _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
	  _CommClearInputBuffer()
	  _CommSendString("MD6;PC025;BW0270;", 0)
	  _CommClosePort()
   ElseIf $vox = "VX0;" Then ; if VOX is off then turn vox on and go into JT65 mode
	  _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
	  _CommClearInputBuffer()
	  _CommSendString("MD6;PC025;BW0270;SWH09;", 0)
	  _CommClosePort()
   EndIf
EndFunc

Func _BandUp()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("SWT10;", 0)
   _CommCloseport()
EndFunc

Func _BandDwn()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("SWT09;", 0)
   _CommCloseport()
EndFunc

Func _PlayM1()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("SWT21;", 0)
   _CommCloseport()
EndFunc

Func _PlayM2()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("SWT31;", 0)
   _CommCloseport()
EndFunc

Func _AmpOn()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("MN023;MP001;MN255;PC009;", 0) ;Set ATU to bypass and power to 9W
   _CommCloseport()
EndFunc

Func _AmpOff()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("MN023;MP002;MN255;PC100;", 0) ;Set ATU to in-line and power to 100W
   _CommCloseport()
EndFunc

Func _TuneAup10Hz()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("UP1;", 0)
   _CommCloseport()
   EndFunc

Func _TuneAup50Hz()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("UP3;", 0)
   _CommCloseport()
EndFunc

Func _TuneAup100Hz()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("UP8;", 0)
   _CommCloseport()
EndFunc

Func _TuneAup200Hz()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("UP9;", 0)
   _CommCloseport()
EndFunc

Func _TuneAup1kHz()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("UP4;", 0)
   _CommCloseport()
EndFunc

Func _TuneAup2kHz()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("UP5;", 0)
   _CommCloseport()
EndFunc

Func _TuneAup5kHz()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("UP7;", 0)
   _CommCloseport()
EndFunc

Func _TuneAdwn10Hz()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("DN1;", 0)
   _CommCloseport()
EndFunc

Func _TuneAdwn50Hz()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("DN3;", 0)
   _CommCloseport()
EndFunc

Func _TuneAdwn100Hz()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("DN8;", 0)
   _CommCloseport()
EndFunc

Func _TuneAdwn200Hz()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("DN9;", 0)
   _CommCloseport()
EndFunc

Func _TuneAdwn1KHz()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("DN4;", 0)
   _CommCloseport()
EndFunc

Func _TuneAdwn2kHz()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("DN5;", 0)
   _CommCloseport()
EndFunc

Func _TuneAdwn5kHz()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("DN7;",0)
   _CommCloseport()
EndFunc

Func _TuneBup10Hz()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("UPB1;", 0)
   _CommCloseport()
EndFunc

Func _TuneBdwn10Hz()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("DNB1;", 0)
   _CommCloseport()
EndFunc

Func _AtuSet()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("SWH19;", 0)
   _CommCloseport()
EndFunc

Func _ApfSet()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommClearInputBuffer()
   _CommSendString("AP;", 1) ;query of APF state
   $apfstate = _CommGetLine(";", 0, 0) ;saved to $apfstate as 
   _CommCloseport()
   
   if $apfstate = "AP1;" Then ;if APF is on then turn off
	  _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
	  _CommSendString("AP0;", 0)
	  _CommCloseport()
   ElseIf $apfstate = "AP0;" Then ;if APF is off then turn on
	  _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
	  _CommSendString("AP1;", 0)
	  _CommCloseport()
   EndIf
EndFunc