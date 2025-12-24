#NoEnv
#SingleInstance Force
SetBatchLines -1
SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Client
CoordMode, Pixel, Client
#Include FindText.ahk

; ==============================================================================
; === SETTINGS ===
; ==============================================================================
Global LogFile   := "CardLog.txt"
Global DebugMode := 0      ; 0 = Click Active. 1 = Log Only (No Click).
Global LoopState := 0      ; 0 = Off, 1 = On
Global Text_Upg0	 := "|<>*91$55.zzzlzzXU8zzzszznU7DzzkQTtlnXQ10A3wssk00U01yQQM60000zCCAQS0k0T776CD0M0DnXb7k200rtk3Xs10A3wy1ly0s71yTXt"
Global Text_Upg1	 := "|<>*88$61.zzzzzzzzzzzzzzzDzzryzzzzzbzzVm7zzzznzznkXzzzztzzlkN4mMb0sDtkC0M030M3ww70A41UAFyTXX6QMX48yDllXCAFm0T7ss1bUA1XznwQ0nk60k7tySkNwHmQ7wzDKDzzzzzyTz07zzzzzzbz47zzzzzztz7zzzzzzzzzz"
Global Text_Upg2  	 := "|<>*84$63.zzzzzzzzzzzzzzzDzzjzjzzzzlzzkkMTzzzyDzyA0XzzzzlzzXU6DzzzkC7wsMl11kA10Db778001001wwkt010000D7w7C1kk601sz1tkC60k0TbkT81s108Hww0t0D0A10DbU389y1kC3ww0tlzzzzzzXzyMTzzzzzyDzX7zzzzzztzsw"
Global Text_Max 	 := "|<>*92$55.zsHzDbnw7zwMz7Vkw1zwQD3kwAAvyS31kD0DAzD00s7kDaDbU0Q1s7n7nk0A0w3tXltVa0C1wnwwtm060SRySTs3U77AzDDw7s7VaTbbyHy7tnztzzzzzznk"
Global Text_SwitchUnits := "|<>*129$87.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzbzznzzwzzzzzwzkDzyAzzXzsyDzXA0zznXzwTz7lzwsXDzzwTzXzsyDzz4TbCH0sQ3z7l8wkUslW061U7sy81U61W4E0UA0z7l0A0s406AQPX7sy8lX7sU0lX3wQT7X74Mb606AQTXXsQMsX40kVlVUAQTU374MU76CA61XXw0ssX63tnnksQwzsDDAwzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzw"
Global Spot_VoteSkip := {x: 1044, y: 178}
Global Text_RestartBtn := "|<>*147$53.w3zzzbzzzs3zzzDzzzk3zzyTzzzb63YwyHCTC830tk4QS0F60nUAFw12AtaAMXs20NnAMsDnWDk6A1sTb41UQ83kzDA79sMbXk"
Global Text_MenuAnchor := "|<>*85$55.zzzzzzzzzzzzzzzzznrtzzzzzzltszzzzzzswwTzzzzzwSSDzzzzzkCD43s470k47U0k000E03k08010001s30s730M0MFUA3VUA00M101s1080A1k4w0k4MS1w2TUQ3jzDzlzzzzw"
Global UncapW_Picked
Global Spot_MagicianPath := {x: 1234, y: 512}

; ==============================================================================
; === 1. SAFETY ANCHOR (YOU MUST FILL THIS) ===
; ==============================================================================
; Capture the "Time Left" or "Vote ends in" text.
; The script will NOT click anything unless it sees this first.
Global Anchor_CardScreen := "|<>*132$79.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzsztzzzzzzzzzzsDsTz7zzzzzzzw7wTzXzzzzzzzy1wDzlzzzs74Tk0yC3k70Ts1U3k0C60E30Ds0k1k17608377wQMEMEV3333XXyCA8A8MX3VXU1y06C6CA1lklk0z0373771sMMQTzlzXVV3Uw0Q20Ds0lkk1sz0D1U7y0MsQ0wTkTls7zUQST2Tzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzk" ; <--- PASTE CODE HERE

; ==============================================================================
; === 2. CARD DATABASE ===
; ==============================================================================
Global Cards := []

AddCard("Lovers", "|<>*104$49.Dzzzzzzy7kzzzzzzXeTzzzzzlZDzzzzzsmy6MkkEQNSNaH8viAjCnNYwz6Lb9g2S7X/naaTDllZtr7DbgsmwnXbnqQE33lsMsSDzzzzzzz3zzzzzzz8",  4)
AddCard("Fortune", "|<>*105$58.Dzzzzzzzzkn3zzzzzzzXfDzzzzzzyChzztzzzzsuz3U1AkD3XftaCQv4taCXbNtngvaMuSQbbCni1XftmSQvCtyCjbNtngvbsuyNbbAniTXXwCD696QCU", 3)
AddCard("Death", "|<>*102$44.Dzzzzwz3ATzzzDsunzzznyCgzzyQzXfC6310suvAwtlCCinDaQvXfg3lbCsuvDUNniCgnvaQvXXAyFbCss7VWQFiDzzzzzvVzzzzzwm", 2)
AddCard("Magician", "|<>*102$69.DzzzzzDwzzzVaCDzztzbzzyCYdzzzzzzzzlpZjzzzzzzzyCghkS3C4kQ3lpZjnaNYbnWSCghzAnAwzAvlpZjlaNbblbSCghkAnAwkAvlpZitaNbatbSCghmA3AwmAvllXa9mMkW9XCDzzzynzzzzzkzzzzizzzzzwzzzzw7zzzzzw", 5)
AddCard("Emperor", "|<>*99$63.DzzzzzzzzzVa7zzzzzzzyCgzzzzzzzzlpbzzzzzzzyCjk0s7313Uloy8b4n8nASCXnCtqNCQblpyNrCE9nYyCjnCtmTCQblpaNrCntngyCAnCtaTCNblk68n1sMsQSDzzztzzzzzkzzzzDzzzzwzzzzszzzzzw", 1)

; ==============================================================================
; === 3. ZONE CONFIGURATION (1920x1080) ===
; ==============================================================================
Global ZoneL := {x1: 530,  y1: 250, x2: 790,  y2: 320, name: "LEFT  ", clickX: 660,  clickY: 600}
Global ZoneM := {x1: 830,  y1: 250, x2: 1090, y2: 320, name: "MIDDLE", clickX: 960,  clickY: 600}
Global ZoneR := {x1: 1130, y1: 250, x2: 1390, y2: 320, name: "RIGHT ", clickX: 1260, clickY: 600}

; ==============================================================================
; === 4. HOTKEYS ===
; ==============================================================================

; F1::
;     LoopState := !LoopState
;     if (LoopState) {
;         SoundBeep, 750, 200
;         SetTimer, AutoPickLoop, 500 ; Check every 500ms
;         ToolTip, [AUTO] ON - Waiting for Cards...
;         SetTimer, ClearTip, -2000
;     } else {
;         SoundBeep, 300, 200
;         SetTimer, AutoPickLoop, Off
;         ToolTip, [AUTO] OFF
;         SetTimer, ClearTip, -2000
;     }
; return

; F3::
;     DebugMode := !DebugMode
;     MsgBox, % "Debug Mode: " . (DebugMode ? "ON (Log Only)" : "OFF (Click Active)")
; return

; F10::ExitApp

; ClearTip:
;     ToolTip
; return

; ==============================================================================
; === 5. THE LOOP ===
; ==============================================================================

; AutoPickLoop:
;     ; 1. Check if the Card Screen is actually open (Using the Anchor)
;     ;    We scan the whole screen for the Anchor text.
;     if (!FindText(X, Y, 0, 0, 1920, 1080, 0, 0, Anchor_CardScreen)) {
;         return ; Anchor not found -> Screen is clear -> Do nothing
;     }

;     ; 2. Anchor Found! Proceed to selection
;     SelectBestCard()

;     ; 3. Wait for the screen to fade away so we don't double-click
;     Sleep, 1500
; return

; ==============================================================================
; === 6. LOGIC & LOGGING ===
; ==============================================================================

SelectBestCard() {
    MouseMove, 0, 0, 0
    Sleep, 150

    InfoL := GetZoneInfo(ZoneL)
    InfoM := GetZoneInfo(ZoneM)
    InfoR := GetZoneInfo(ZoneR)

    ; --- WINNER CALCULATION ---
    Winner := ""
    if (InfoL.score >= InfoM.score && InfoL.score >= InfoR.score)
        Winner := ZoneL
    else if (InfoM.score >= InfoL.score && InfoM.score >= InfoR.score)
        Winner := ZoneM
    else
        Winner := ZoneR
    
        ; --- AUTO-SCREENSHOT FOR UNKNOWNS ---
        ; Check if ANY of the cards are unknown
        if (InfoL.cardName = "Unknown" || InfoM.cardName = "Unknown" || InfoR.cardName = "Unknown") {
            ; Create temp folder if it doesn't exist
            if !InStr(FileExist("temp"), "D") {
                FileCreateDir, temp
            }

            ; Generate a unique filename using date and time
            FormatTime, FileTime,, yyyy-MM-dd_HH-mm-ss
            SnapPath := "temp\Unknown_" . FileTime . ".bmp"

            ; Capture the screen and save to the temp folder
            ; Syntax: FindText().SavePic(FileName, X1, Y1, X2, Y2)
            ; We capture the middle band where cards appear (Y 400 to 700) to keep files small
            FindText().SavePic(SnapPath, 0, 400, 1920, 700)
        }
    

    ; --- LOGGING ---
    FormatTime, TimeString,, HH:mm:ss
    LogEntry := "TIME: " . TimeString . " | L: " . InfoL.cardName . " | M: " . InfoM.cardName . " | R: " . InfoR.cardName . " | WINNER: " . Winner.name . "`n"
    FileAppend, %LogEntry%, %LogFile%

    ; --- EXECUTION ---
    if (!DebugMode) {
        Click, % Winner.clickX . ", " . Winner.clickY
    } else {
        SoundBeep, 750, 100
    }
}

GetZoneInfo(Zone) {
    for index, card in Cards {
        if (FindText(X, Y, Zone.x1, Zone.y1, Zone.x2, Zone.y2, 0, 0, card.code)) {
            return {score: card.score, cardName: card.name}
        }
    }
    return {score: 0.0, cardName: "Unknown"}
}

ClickCard(Zone) {
    Click, % Zone.clickX . ", " . Zone.clickY
    Sleep, 200
}

AddCard(Name, Code, Score) {
    Global Cards
    Cards.Push({name: Name, code: Code, score: Score})
}