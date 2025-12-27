#NoEnv
#SingleInstance Force
SetBatchLines -1
SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Client
CoordMode, Pixel, Client
#Include FindText.ahk
#Include Strings.ahk 
#Include GameMacro.ahk 
; ==============================================================================
; === 2. CARD DATABASE ===
; ==============================================================================
Global Cards := []
Global CardStats := {} 
InitCardDatabase()

; ==============================================================================
; === 3. ZONE CONFIGURATION (1920x1080) ===
; ==============================================================================
Global ZoneL := {x1: 530,  y1: 250, x2: 790,  y2: 800, name: "LEFT  ", clickX: 660,  clickY: 600}
Global ZoneM := {x1: 830,  y1: 250, x2: 1090, y2: 800, name: "MIDDLE", clickX: 960,  clickY: 600}
Global ZoneR := {x1: 1130, y1: 250, x2: 1390, y2: 800, name: "RIGHT ", clickX: 1260, clickY: 600}

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
    Sleep, 1000

    TempDir := A_ScriptDir . "\temp"
    if !FileExist(TempDir)
        FileCreateDir, %TempDir%

    FormatTime, Timestamp,, yyyyMMdd_HHmmss
    ImagePath := TempDir . "\Card_" . Timestamp . ".png"
    
    ; Define search limits (Y is from old zones, X is full width)
    SearchX1 := 0,    SearchY1 := 250
    SearchX2 := 1920, SearchY2 := 800

    FindText().SavePic(ImagePath, SearchX1, SearchY1, SearchX2, SearchY2)

    BestCard := {}
    BestCard.score := -1
    BestCard.name  := "None"
    BestCard.x     := 0
    BestCard.y     := 0

    ; --- SCAN EVERY CARD IN DATABASE ---
    For index, card in Cards {
        ; Search the entire horizontal band for this card
        if (FindText(foundX, foundY, SearchX1, SearchY1, SearchX2, SearchY2, 0.3, 0.3, card.code)) {
            
            ; If we found this card, check if it's the best one so far
            if (card.score > BestCard.score) {
                BestCard.score := card.score
                BestCard.name  := card.name
                BestCard.x     := foundX
                BestCard.y     := foundY
            }
        }
    }

    ; --- RESULT HANDLER ---
    if (BestCard.score > -1) {
        ; 1. Update Stats
        if (!CardStats.HasKey(BestCard.name)) {
            CardStats[BestCard.name] := 1
        } else {
            CardStats[BestCard.name] += 1
        }

        ; 2. Log It
        FormatTime, TimeString,, HH:mm:ss
        LogEntry := "TIME: " . TimeString . " | SELECTED: " . BestCard.name . " (Score: " . BestCard.score . ") at X" . BestCard.x . " Y" . BestCard.y . "`n"
        FileAppend, %LogEntry%, %LogFile%

        ; 3. Execute Click at EXACT found coordinates
        if (!DebugMode) {
            Click, % BestCard.x . ", 500"
        } else {
            SoundBeep, 750, 100
        }
    } else {
        ; Fallback: No known cards detected
        FileAppend, No known cards found.`n, %LogFile%
    }
}



ClickCard(Zone) {
    Click, % Zone.clickX . ", " . Zone.clickY
    Sleep, 200
}

ResetGameStats() {
    Global CardStats
    CardStats := {}
}


GetStatsString() {
    Global CardStats
    OutputStr := ""
    
    ; Sort/Format the list
    For cName, cCount in CardStats {
        OutputStr .= cName . ": " . cCount . "`n"
    }
    
    if (OutputStr == "")
        return "No cards selected."
        
    return OutputStr
}