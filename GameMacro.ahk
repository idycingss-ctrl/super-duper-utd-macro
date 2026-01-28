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
Global SessionWins := 0
Global SessionLosses := 0
Global SessionEfficiencySum := 0
Global SessionEfficiencyCount := 0
Global SessionStartTime := 0
Global BestMatchMinutes := 0
Global MacroRunning := False

; --- POLLING CONFIGURATION ---
Global PollInterval := 100          ; Check every 100ms
Global MaxPollAttempts := 50        ; 50 * 100ms = 5 seconds max timeout
Global PlacementTimeout := 30       ; 30 * 100ms = 3 seconds for placement
Global UpgradeTimeout := 20         ; 20 * 100ms = 2 seconds for upgrade check

; --- INITIALIZE CONFIGURATION ---
IfNotExist, config.ini
{
    Config_SaveToFile()
}
Config_LoadFromFile()

; ==============================================================================
; === HOTKEYS ===
; ==============================================================================
F11::ExitApp

F3::ShowConfigGUI()  

F5::
    if (MacroRunning) {
        SoundBeep, 500, 300
        Log("Macro is already running! Press F10 to stop first.")
        return
    }
    
    MacroRunning := True
    SoundBeep, 750, 200
    SessionWins := 0
    SessionLosses := 0
    SessionEfficiencySum := 0
    SessionEfficiencyCount := 0
    BestMatchMinutes := 0
    SessionStartTime := A_TickCount
    LobbySequence()
    if (!MacroRunning)
        return
    Sleep, 500
    GuardDog()
    Loop {
        if (!MacroRunning)
            break
            
        GameFinished := False 
        StartTime := A_TickCount 
        LogStart("New Game - Voting Phase")
        
        Strategy_Execute(CurrentStrategy)
        
        Loop {
            if (!MacroRunning)
                break
                
            if (GameFinished) {
                break 
            }
            
            GuardDog() 
            Sleep, 1000 
            
            if (!GameFinished && MacroRunning)
                SafeClick(Spot_WaitClick.x, Spot_WaitClick.y) 
        }
        
        if (!MacroRunning)
            break
            
        Sleep, 2000 
    }
    MacroRunning := False
return

F7::
LogError("Debug")
return

F10::
    if (MacroRunning) {
        MacroRunning := False
        GameFinished := True
        SoundBeep, 400, 500
        Log("Macro stopped! Press F5 to restart.")
    } else {
        SoundBeep, 300, 200
        Log("Macro is not running.")
    }
return

; ==============================================================================
; === LOBBY SEQUENCE ===
; ==============================================================================

LobbySequence() {
    if (!MacroRunning)
        return
        
    if !FindText(X, Y, 0, 647, 233, 735, 0.2, 0.2, Text_Lobby)
        return

    if (!MacroRunning)
        return
    Click, 60, 570
    Sleep, 2500
    
    if (!MacroRunning)
        return
    Click, 604, 472
    Sleep, 2500

    if (!MacroRunning)
        return
    Send, e 
    Sleep, 2500
    
    if (!MacroRunning)
        return
    Send, j
    Sleep, 2500
    
    if (!MacroRunning)
        return
    Click, 570, 821  
    Sleep, 2500
    
    if (!MacroRunning)
        return
    Click, 1284, 484
    Sleep, 2500

    if (!MacroRunning)
        return
    Click, 1206, 829
    Sleep, 2500

     if (!MacroRunning)
        return
    Click, 1579, 740
    Sleep, 2500

    Loop {
        if (!MacroRunning)
            return
        if (FindText(X, Y, 0, 0, 1920, 1080, 0.2, 0.2, Text_SwitchUnits))
            break
        Sleep, 500
        if (!MacroRunning)
            return
    }
    TiltCameraDown()
    Sleep, 1000
}

; ==============================================================================
; === DISCONNECT HANDLER ===
; ==============================================================================

HandleDisconnect() {
    static ReconnectAttempts := 0
    static FirstDisconnectTime := 0
    
    if (!MacroRunning)
        return
    
    if (ReconnectAttempts = 0)
        FirstDisconnectTime := A_TickCount
    
    ElapsedTime := A_TickCount - FirstDisconnectTime
    if (ElapsedTime > 21600000) {
        LogError("6 hour reconnect limit reached - stopping macro")
        MacroRunning := false
        MsgBox, Reconnect limit reached (6 hours). Macro stopped.
        return
    }
    
    if (ReconnectAttempts = 0)
        ReconnectDelay := 30000
    else if (ReconnectAttempts = 1)
        ReconnectDelay := 60000
    else if (ReconnectAttempts = 2)
        ReconnectDelay := 120000
    else if (ReconnectAttempts = 3)
        ReconnectDelay := 300000
    else
        ReconnectDelay := 600000
    
    ReconnectAttempts++
    
    WaitForInternet(ReconnectDelay, ReconnectAttempts)
    
    if (!MacroRunning)
        return
    
    if WinExist("ahk_exe RobloxPlayerBeta.exe") {
        WinClose, ahk_exe RobloxPlayerBeta.exe
        Sleep, 2000
        
        Process, Close, RobloxPlayerBeta.exe
        Sleep, 1000
    }
    
    Run, %UserGameLink%
    
    WinWait, ahk_exe RobloxPlayerBeta.exe, , 30
    if (ErrorLevel) {
        LogError("Failed to launch Roblox - retrying...")
        Sleep, 3000
        return HandleDisconnect()
    }
    WinWaitActive, ahk_exe RobloxPlayerBeta.exe
    Sleep, 7000
    
    Loop, 120 {
        if (!MacroRunning)
            return
            
        if (!WinExist("ahk_exe RobloxPlayerBeta.exe")) {
            LogError("Game closed during reconnect - restarting...")
            Sleep, 2000
            return HandleDisconnect()
        }
        
        if (FindText(X, Y, 0, 647, 233, 735, 0.2, 0.2, Text_Lobby)) {
            LogError("Lobby loaded successfully")
            ReconnectAttempts := 0
            Sleep, 10000
            LobbySequence()
            return
        }
        Sleep, 1000
    }
    
    LogError("Lobby load timeout - reconnecting...")
    HandleDisconnect()
}

WaitForInternet(MinDelay, AttemptNumber) {
    global MacroRunning
    
    StartWaitTime := A_TickCount
    TotalPings := 0
    FailedPings := 0
    InternetDown := false
    DowntimeStart := 0
    
    Loop {
        if (!MacroRunning)
            return
        
        CurrentWaitTime := A_TickCount - StartWaitTime
        
        TotalPings++
        
        if (!CheckInternetConnection()) {
            FailedPings++
            
            if (!InternetDown) {
                InternetDown := true
                DowntimeStart := A_TickCount
            }
        } else {
            if (InternetDown) {
                DowntimeEnd := A_TickCount
                TotalDowntime := (DowntimeEnd - DowntimeStart) / 1000
                TotalWaitTime := (A_TickCount - StartWaitTime) / 1000
                
                LogError("Internet restored after " . Round(TotalDowntime) . "s downtime | Total wait: " . Round(TotalWaitTime) . "s | Pings: " . TotalPings . " (Failed: " . FailedPings . ") | Attempt #" . AttemptNumber)
                InternetDown := false
            }
            
            if (CurrentWaitTime >= MinDelay)
                break
        }
        
        Sleep, 5000
    }
    
    if (FailedPings = 0) {
        LogError("Reconnect attempt " . AttemptNumber . " - waited " . Round(MinDelay/1000) . "s")
    }
}

CheckInternetConnection() {
    RunWait, %ComSpec% /c ping -n 1 -w 2000 8.8.8.8 | find "TTL=" > nul, , Hide
    
    if (ErrorLevel = 0)
        return true
    
    return false
}

; ==============================================================================
; === CAM FUNCTIONS ===
; ==============================================================================

TiltCameraDown() {
    DllCall("mouse_event"
        , "UInt", 0x0008
        , "UInt", 0
        , "UInt", 0
        , "UInt", 0
        , "UPtr", 0)
    Sleep, 20
    DllCall("mouse_event"
        , "UInt", 0x0001
        , "Int", 0
        , "Int", 600
        , "UInt", 0
        , "UPtr", 0)
    Sleep, 20
    DllCall("mouse_event"
        , "UInt", 0x0010
        , "UInt", 0
        , "UInt", 0
        , "UInt", 0
        , "UPtr", 0)
}

; ==============================================================================
; === POLLING HELPER FUNCTIONS ===
; ==============================================================================

; Wait for a specific text to appear or disappear
PollForText(TextPattern, X1, Y1, X2, Y2, Tolerance1, Tolerance2, ShouldExist := true, MaxAttempts := 0) {
    global PollInterval, MaxPollAttempts, MacroRunning, GameFinished
    
    if (MaxAttempts = 0)
        MaxAttempts := MaxPollAttempts
    
    Attempts := 0
    Loop, %MaxAttempts% {
        if (!MacroRunning || GameFinished)
            return false
            
        Found := FindText(X, Y, X1, Y1, X2, Y2, Tolerance1, Tolerance2, TextPattern)
        
        if (ShouldExist && Found)
            return true
        if (!ShouldExist && !Found)
            return true
            
        Attempts++
        Sleep, %PollInterval%
    }
    
    return false
}

; Wait for UI to stabilize after a click (checks if screen content changes)
WaitForUIStabilize(Delay := 200) {
    global MacroRunning, GameFinished
    
    if (!MacroRunning || GameFinished)
        return
    
    Sleep, %Delay%
}

; ==============================================================================
; === IMPROVED SAFE ACTION FUNCTIONS ===
; ==============================================================================
; Helper function: Poll with proper timeout, return true if found, false if timeout
PollWithTimeout(TextToFind, TimeoutMs) {
    StartTime := A_TickCount
    Loop {
        ; Check if timeout exceeded
        if (A_TickCount - StartTime > TimeoutMs)
            return false
        
        ; Try to find text
        if (FindText(X, Y, 0, 0, 1000, 700, 0.3, 0.3, TextToFind))
            return true
        
        Sleep, 50  ; Small delay between checks
    }
}

SafeClick(X, Y) {
    if (!MacroRunning)
        return
    GuardDog()
    if (GameFinished) 
        return
    Click, %X%, %Y%
    Sleep, 100
}

SafePlace(SlotKey, Spot) {
    Loop {
        if (!MacroRunning)
            return
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
        
        ; 3. Poll for verification (up to 2 seconds, but exits early if found)
        if (PollWithTimeout(Text_Upg0, 2000)) {
            Name := GetUnitName(Spot)
            LogUnit(Name, "Placed Successfully")
            
            SafeClick(Spot_Empty.x, Spot_Empty.y)
            break
        }
        
        ; Placement failed - retry after delay
        MouseMove, 0, 0, 0
        Sleep, 1500
    }
}

SafeUpgradeTo(Spot, TargetText) {
    if (!MacroRunning)
        return
    if (GameFinished) 
        return
    
    ; Open menu once
    SafeClick(Spot.x, Spot.y)
    Sleep, 300
    
    ; Spam 'e' while checking for target level
    StartTime := A_TickCount
    Loop {
        if (!MacroRunning)
            return
        if (GameFinished) 
            return
        
        ; Timeout after 30 seconds
        if (A_TickCount - StartTime > 30000) {
            LogUnit("Upgrade", "Timeout")
            SafeClick(Spot_Empty.x, Spot_Empty.y)
            return
        }
        
        ; Check if target level reached
        if (FindText(X, Y, 0, 0, 1000, 700, 0.3, 0.3, TargetText)) {
            SafeClick(Spot_Empty.x, Spot_Empty.y)
            break 
        }
        
        GuardDog()
        
        ; Spam upgrade
        Send, e
        Sleep, 150  ; Short delay between upgrade attempts
    }
}

SafeMaxUpgrade(Spot) {
    if (!MacroRunning)
        return
    if (GameFinished) 
        return
    
    ; Open menu once
    SafeClick(Spot.x, Spot.y)
    Sleep, 300
    
    ; Spam 'e' while checking for max level
    StartTime := A_TickCount
    Loop {
        if (!MacroRunning)
            return
        if (GameFinished) 
            return
        
        ; Timeout after 60 seconds
        if (A_TickCount - StartTime > 60000) {
            LogUnit("Upgrade", "Timeout")
            SafeClick(Spot_Empty.x, Spot_Empty.y)
            return
        }
        
        ; Check if max level reached
        if (FindText(X, Y, 0, 0, 1000, 700, 0.3, 0.3, Text_Max)) {
            SafeClick(Spot_Empty.x, Spot_Empty.y)
            Name := GetUnitName(Spot)
            LogUnit(Name, "Max Level Reached")
            break 
        }
        
        GuardDog()
        
        ; Spam upgrade
        Send, e
        Sleep, 150  ; Short delay between upgrade attempts
    }
}

; ==============================================================================
; === GUARD DOG - PASSIVE MONITOR ===
; ==============================================================================

GuardDog() {
    Static LastCheck := 0
    
    if (!MacroRunning)
        return
    
    ; Only scan every 2 seconds
    if (A_TickCount - LastCheck < 2000) 
        return
    LastCheck := A_TickCount
    
    if (GameFinished)
        return

    if (!WinExist("ahk_exe RobloxPlayerBeta.exe")) {
        LogError("Game window closed unexpectedly")
        HandleDisconnect()
        GameFinished := True
        return
    }

    ; --- DISCONNECT CHECK ---
    if (FindText(X, Y, 0, 0, 1920, 1080, 0.2, 0.2, Text_Disconnected)) {
        HandleDisconnect()
        GameFinished := True
        return
    }

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
        
        matchMinutes := ElapsedMS / 60000.0
        if (BestMatchMinutes = 0 || matchMinutes < BestMatchMinutes)
            BestMatchMinutes := matchMinutes

        if (Result = "Win")
            SessionWins++
        else
            SessionLosses++

        totalGames := SessionWins + SessionLosses
        winRate := (totalGames > 0) ? Round((SessionWins / totalGames) * 100, 2) : 0

        sessionElapsedMS := (SessionStartTime > 0) ? (A_TickCount - SessionStartTime) : 0
        sessionMinutes := Floor(sessionElapsedMS / 60000)
        sessionSeconds := Floor(Mod(sessionElapsedMS, 60000) / 1000)
        sessionTimeStr := sessionMinutes . "m " . sessionSeconds . "s"

        efficiency := (matchMinutes > 0) ? (BestMatchMinutes / matchMinutes) : 0
        efficiencyPct := Round(efficiency * 100, 2)

        Summary := "__**Session Stats:**__`nWin Rate: **" . winRate . "%**`nWins: **" . SessionWins . "**`nLosses: **" . SessionLosses . "**`nSession Runtime: " . sessionTimeStr . "`nEfficiency: **" . efficiencyPct . "%**"

        LogFinish(TimeStr, Result, Summary)

        if (Result = "Win") {
            SessionEfficiencySum += matchMinutes
            SessionEfficiencyCount++
        }
        
        Loop {
            if (!MacroRunning)
                break
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
        Click, 1044, 178
        Sleep, 600
        mx := Spot_MagicianPath.x
        my := Spot_MagicianPath.y
        Click, %mx%, %my%
        Sleep, 1000
        return
    }

    if (FindText(X, Y, 0, 700, 1920, 900, 0.1, 0.1, Text_SwitchUnits)) {
        Click, 1044, 178
        Sleep, 500
    }

    ; --- CARD SELECTOR ---
    if (FindText(X, Y, 0, 0, 1920, 1080, 0.2, 0.2, Anchor_CardScreen)) {
        SelectBestCard()
        Sleep, 2000
    }
}
