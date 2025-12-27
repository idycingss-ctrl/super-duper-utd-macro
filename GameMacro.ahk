#NoEnv
#SingleInstance Force
SetBatchLines -1
SetWorkingDir %A_ScriptDir%

; --- COORDINATE MODES & DPI FIX ---
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
DllCall("SetThreadDpiAwarenessContext", "ptr", -3) 

; --- IMPORTS ---
#Include FindText.ahk
#Include CardSelector.ahk 
#Include Strings.ahk
#Include Logger.ahk
#Include Config.ahk
#Include Strategy.ahk
#Include ConfigGUI.ahk

; --- GLOBAL VARIABLES ---
Global GameFinished := False
Global StartTime := 0
Global CurrentStrategy := "Default"

; --- INITIALIZE CONFIGURATION ---
IfNotExist, config.ini
{
    Config_SaveToFile()
}
Config_LoadFromFile()

; ==============================================================================
; === HOTKEYS ===
; ==============================================================================

F3::ShowConfigGUI()  ; Open configuration GUI (changed from F4)

F5::
    SoundBeep, 750, 200
    LobbySequence()
    Sleep, 500
    GuardDog()
    Loop {
        ; --- RESET FLAGS FOR NEW GAME ---
        GameFinished := False 
        StartTime := A_TickCount 
        LogStart("New Game - Voting Phase")
        
        ; NOW execute the strategy after game has started
        Strategy_Execute(CurrentStrategy)
        
        Loop {
            if (GameFinished) {
                break 
            }
            
            GuardDog() 
            Sleep, 1000 
            
            if (!GameFinished)
                SafeClick(Spot_WaitClick.x, Spot_WaitClick.y) 
        }
        
        Sleep, 2000 
    }
return

F10::ExitApp

; ==============================================================================
; === LOBBY SEQUENCE ===
; ==============================================================================

LobbySequence() {
    ; Check if lobby text exists
    if !FindText(X, Y, 0, 647, 233, 735, 0.2, 0.2, Text_Lobby)
        return

    ; --- Sequence actions ---
    Click, 60, 600
    Sleep, 2500
    Click, 955, 485
    Sleep, 2500

    Send, {w down}{a down}
    Sleep, 4000
    Send, {w up}{a up}
    Sleep, 4000

    Click, 152, 579
    Sleep, 2500
    Click, 568, 477
    Sleep, 2500
    Click, 1281, 493
    Sleep, 2500
    Click, 1227, 830
    Sleep, 2500
    Click, 1563, 747
    Sleep, 2500

    Loop {
        if (FindText(X, Y, 0, 0, 1920, 1080, 0.2, 0.2, Text_SwitchUnits))
            break
        Sleep, 500
    }
}

; ==============================================================================
; === SAFE ACTION FUNCTIONS ===
; ==============================================================================

SafeClick(X, Y) {
    GuardDog()
    if (GameFinished) 
        return
    Click, %X%, %Y%
    Sleep, 100
}

SafePlace(SlotKey, Spot) {
    Loop {
        GuardDog()
        if (GameFinished) 
            return
            
        ; 1. Try to place the unit
        Send, %SlotKey%
        Sleep, 150
        SafeClick(Spot.x, Spot.y) ; Ghost
        SafeClick(Spot.x, Spot.y) ; Confirm
        Sleep, 600
        
        ; 2. Open menu to check success
        SafeClick(Spot.x, Spot.y) 
        Sleep, 500
        
        ; 3. Verify placement
        if (FindText(X, Y, 0, 0, 1000, 700, 0.3, 0.3, Text_Upg0)) {
            Name := GetUnitName(Spot)
            LogUnit(Name, "Placed Successfully")
            
            SafeClick(Spot_Empty.x, Spot_Empty.y)
            break
        }
        
        MouseMove, 0, 0, 0
        Sleep, 1500
    }
}

SafeUpgradeTo(Spot, TargetText) {
    Loop {
        if (GameFinished) 
            return
        SafeClick(Spot.x, Spot.y)
        Sleep, 500
        
        if (FindText(X, Y, 0, 0, 1000, 700, 0.3, 0.3, TargetText)) {
            SafeClick(Spot_Empty.x, Spot_Empty.y)
            break 
        }
        
        GuardDog()
        Send, e
        Sleep, 1000
    }
}

SafeMaxUpgrade(Spot) {
    Loop {
        if (GameFinished) 
            return
        SafeClick(Spot.x, Spot.y)
        Sleep, 500
        
        if (FindText(X, Y, 0, 0, 1000, 700, 0.3, 0.3, Text_Max)) {
            SafeClick(Spot_Empty.x, Spot_Empty.y)
            Name := GetUnitName(Spot)
            LogUnit(Name, "Max Level Reached")
            break 
        }
        
        GuardDog()
        Send, e
        Sleep, 1000
    }
}

; ==============================================================================
; === GUARD DOG - PASSIVE MONITOR ===
; ==============================================================================

GuardDog() {
    Static LastCheck := 0
    
    ; Only scan every 2 seconds
    if (A_TickCount - LastCheck < 2000) 
        return
    LastCheck := A_TickCount
    
    if (GameFinished)
        return

    ; --- RESTART CHECK ---
    if (FindText(X, Y, 0, 500, 1920, 850, 0.1, 0.1, Text_RestartBtn)) {
        ElapsedMS := A_TickCount - StartTime
        Minutes := Floor(ElapsedMS / 60000)
        Seconds := Floor(Mod(ElapsedMS, 60000) / 1000)
        TimeStr := Minutes . "m " . Seconds . "s"
        
        if (FindText(X, Y, 0, 180, 1920, 420, 0.2, 0.2, Text_Defeat)) {
            Result := "Defeat"
        } else {
            Result := "Win"
        }
        
        LogFinish(TimeStr, Result)
        
        Loop {
            Click, %X%, %Y%
            Sleep, 1000
            
            if (!FindText(X, Y, 0, 500, 1920, 850, 0.1, 0.1, Text_RestartBtn)) {
                break
            }
        }
        
        Sleep, 3500 
        ResetGameStats()
        GameFinished := True
        return
    }

    ; --- START / WAVE SKIP ---
    if (FindText(X, Y, 0, 0, 1920, 1080, 0.1, 0.1, Text_StartAnchor)) {
        vx := Spot_VoteSkip.x
        vy := Spot_VoteSkip.y
        Click, %vx%, %vy%
        Sleep, 600
        mx := Spot_MagicianPath.x
        my := Spot_MagicianPath.y
        Click, %mx%, %my%
        Sleep, 1000
        return
    }

    if (FindText(X, Y, 0, 700, 1920, 900, 0.1, 0.1, Text_SwitchUnits)) {
        vx := Spot_VoteSkip.x
        vy := Spot_VoteSkip.y
        Click, %vx%, %vy%
        Sleep, 500
    }

    ; --- CARD SELECTOR ---
    if (FindText(X, Y, 0, 0, 1920, 1080, 0.2, 0.2, Anchor_CardScreen)) {
        SelectBestCard()
        Sleep, 2000
    }
}