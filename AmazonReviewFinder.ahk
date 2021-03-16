#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

+.::
Send, ^C
clipInfo := ClipBoard
msgbox, Format("ClipInfo: {}", clipInfo)
; Run, https://www.autohotkey.com/

return