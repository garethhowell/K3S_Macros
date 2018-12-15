#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_Description=A set of marcos to allow a Griffin Powermate to K3S control an Elecraft K3S transceiver
#AutoIt3Wrapper_Res_Fileversion=001
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#comments-start
This script written by Gareth Howell (M5KVK) but based heavily on a similar one by
Iain Kelly (M0PCB) for a ShuttlePro

Send Macro commands to an ELecraft K3 Transceiver on COMPORT 18 at 38400Baud 8N1 using Key combinations, primarily for use with a Griffin Powermate.
#comments-end
#include "CommMG64.au3"
#include <String.au3>
#include <Array.au3>

Global $error, $rawfreq, $freq, $mode, $baud, $comport, $apfstate, $ic

$comport = 18
$baud = 38400

_CommSetDllPath("C:\Users\gareth\OneDrive\M5KVK\K3S_Macros\commg64.dll")

HotKeySet("^!{F12}", "_Exit") ;If you press Ctrl-Shift-F12 the script will stop
HotKeySet("+{F1}", "_ShowMacros") ;If you press SHIFT + F1, the script will show witch sites you have on witch keys
HotKeySet("^{RIGHT}", "_TuneAup10Hz")
#HotKeySet("^!{F2}", "_TuneAup50Hz")
#HotKeySet("^!{F3}", "_TuneAup100Hz")
#HotKeySet("^!{F4}", "_TuneAup200Hz")
#HotKeySet("^!{F5}", "_TuneAup1kHz")
#HotKeySet("^!{F6}", "_TuneAup2kHz")
#HotKeySet("^!{F7}", "_TuneAup5kHz")
HotKeySet("^{LEFT}", "_TuneAdwn10Hz")
#HotKeySet("^+!{F2}", "_TuneAdwn50Hz")
#HotKeySet("^+!{F3}", "_TuneAdwn100Hz")
#HotKeySet("^+!{F4}", "_TuneAdwn200Hz")
#HotKeySet("^+!{F5}", "_TuneAdwn1kHz")
#HotKeySet("^+!{F6}", "_TuneAdwn2kHz")
#HotKeySet("^+!{F7}", "_TuneAdwn5kHz")
#HotKeySet("^!{F8}", "_TuneBup10Hz")
HotKeySet("^!+{F8}", "_TuneBdwn10Hz")

While 1
Sleep(100)
WEnd

Func _Exit()
Sleep(100)
Exit
EndFunc ;==> _Exit()

Func _ShowMacros()
MsgBox(0, "M5KVK's K3S Controller / Macro Sender V1", "To Exit use Ctrl-Alt-F12")
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
