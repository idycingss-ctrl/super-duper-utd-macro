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

    ; ==============================================================================
    ; === 1. CONFIGURATION ===
    ; ==============================================================================

    ; Slot Keys
    Global Key_Kirito     := 1
    Global Key_Ace        := 2
    Global Key_Speedwagon := 3
    Global Key_Miku       := 4
    Global Key_Akainu     := 5 ; (Assuming 5 and 6 for Akainus)
    Global Key_SJW        := 6

    ; Unit Spots
    Global Spot_HillAce       := {x: 795,  y: 415}
    Global Spot_GroundKirito  := {x: 940,  y: 485}
    Global Spot_GroundMiku    := {x: 836,  y: 502}
    Global Spot_GroundSpeed   := {x: 1250, y: 570}
    Global Spot_GroundAkainu1 := {x: 1160, y: 460}
    Global Spot_GroundAkainu2 := {x: 485,  y: 510}
    Global Spot_GroundSJW     := {x: 820, y: 677}
    Global Spot_Empty         := {x: 100,  y: 100} 

    Global RSpot_Speed := {x: 1249, y: 532}
    Global RSpot_SJW := {x: 890,  y: 505}
    Global RSpot_Miku := {x: 1155,  y: 619}
    Global RSpot_Ace := {x: 729,  y: 390}  


    ; Upgrade Search Region (As requested)
    ; x1: 330, y1: 430, x2: 603, y2: 460
    Global UX1 := 330, UY1 := 430, UX2 := 603, UY2 := 460
    Global Spot_WaitClick := {x: 70, y: 200}
    Global GameFinished := False
	Global StartTime := 0
    ; ==============================================================================
    ; === 2. THE STRATEGY ===
    ; ==============================================================================

    F5::
    SoundBeep, 750, 200
    
    Loop {
        FileAppend, Starting New Game Loop...`n, %LogFile%
        
        ; --- RESET FLAGS FOR NEW GAME ---
        GameFinished := False 
		StartTime := A_TickCount 
        ; We do NOT use SetTimer anymore. GuardDog handles it.
        LogStart("New Game - Voting Phase")
        ; --- RUN STRATEGY ---
        ExecuteStrategy()
        
        ; --- WAIT FOR GAME TO END ---
        ; If strategy finishes, we sit here until GuardDog sees the button
        Loop {
            if (GameFinished) {
                FileAppend, Loop Broken - Preparing next game...`n, %LogFile%
                break 
            }
            
            GuardDog() ; <--- Checks for restart button
            
            Sleep, 1000 
            ; Anti-AFK click (only if game isn't finished)
            if (!GameFinished)
                SafeClick(Spot_WaitClick.x, Spot_WaitClick.y) 
        }
        
        Sleep, 2000 
    }
return
    F10::ExitApp

    ExecuteStrategy() {

        
        
         SafePlace(Key_Speedwagon, Spot_GroundSpeed)
        
        
         SafePlace(Key_Ace, Spot_HillAce)
        
        
         SafeUpgradeTo(Spot_GroundSpeed, Text_Upg1)
        
        
         SafePlace(Key_Kirito, Spot_GroundKirito)
        
        
         SafeMaxUpgrade(Spot_GroundSpeed)
        
        
         SafeMaxUpgrade(Spot_GroundKirito)
        
		  SafePlace(Key_SJW, Spot_GroundSJW)
         Sleep, 500

         SafePlace(Key_Akainu, Spot_GroundAkainu1)
         SafePlace(Key_Akainu, Spot_GroundAkainu2)

         SafePlace(Key_Miku, Spot_GroundMiku)
         Sleep, 500
         SafeMaxUpgrade(Spot_GroundMiku)

         SafeMaxUpgrade(Spot_GroundSJW)
        
         SafeMaxUpgrade(Spot_HillAce)
        
         



    }
    ; ==============================================================================
    ; === 3. SAFE ACTION FUNCTIONS ===
    ; ==============================================================================

    ; This helper ensures a card check happens before every mouse click
    SafeClick(X, Y) {
        GuardDog()
        if (GameFinished) 
                return
        Click, % X . ", " . Y
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
            Sleep, 600 ; Wait for placement animation
            
            ; 2. Open the menu to check success
            SafeClick(Spot.x, Spot.y) 
            Sleep, 500
            
            ; 3. BROAD SEARCH for "Upgrade (0)"
            ; Instead of a tiny box, we search the whole upper-left quadrant (0,0 to 1000,700)
            ; And we use 0.3 tolerance to be safer.
            if (FindText(X, Y, 0, 0, 1000, 700, 0.3, 0.3, Text_Upg0)) {
                
                ; --- NEW: LOG SUCCESS ---
                FileAppend, SUCCESS: Unit placed at %A_Hour%:%A_Min%`n, %LogFile%
                Name := GetUnitName(Spot)
            LogUnit(Name, "Placed Successfully")
                
                SafeClick(Spot_Empty.x, Spot_Empty.y) ; Close menu
                break ; EXIT THE LOOP
            }
            
            ; --- NEW: LOG RETRY ---
            FileAppend, RETRY: Failed to see Upgrade(0). Trying again...`n, %LogFile%
            
            MouseMove, 0, 0, 0
            Sleep, 1500 ; Wait for more money
        }
    }

    SafeUpgradeTo(Spot, TargetText) {
        Loop {
            if (GameFinished) 
                return
            SafeClick(Spot.x, Spot.y) ; Select unit
            Sleep, 500
            
            ; Broad search with higher tolerance
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
            SafeClick(Spot.x, Spot.y) ; Select unit
            Sleep, 500
            
            ; Broad search for (MAX)
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
    ; === 4. PASSIVE PROTECTOR ===
    ; ==============================================================================

    GuardDog() {
    if (GameFinished)
        return

    ; --- B. RESTART CHECK (Moved to top priority) ---
    ; Search Y: 500 to 850 (Bottom half of screen)
    if (FindText(X, Y, 0, 500, 1920, 850, 0.1, 0.1, Text_RestartBtn)) {
        ElapsedMS := A_TickCount - StartTime
        Minutes := Floor(ElapsedMS / 60000)
        Seconds := Floor(Mod(ElapsedMS, 60000) / 1000)
        TimeStr := Minutes . "m " . Seconds . "s"
        
        if (FindText(X, Y, 0, 180, 1920, 420, 0.2, 0.2, Text_Defeat)) {
    Result := "Defeat"
    FileAppend, RESTART FOUND - Run took %TimeStr% - DEFEAT`n, %LogFile%
} else {
    Result := "Win"
    FileAppend, RESTART FOUND - Run took %TimeStr% - WIN`n, %LogFile%
}
 

        ; --- NOW PASS THE REAL TIME TO DISCORD ---
        LogFinish(TimeStr, Result)
	
        
        Loop {
            ; 1. Click the coordinates found by FindText
            Click, %X%, %Y%
            
            ; 2. Wait a moment for the game to register the click
            Sleep, 1000
            
            ; 3. Check if the button is still there
            if (!FindText(X, Y, 0, 500, 1920, 850, 0.1, 0.1, Text_RestartBtn)) {
                FileAppend, Button disappeared. Teleporting...`n, %LogFile%
                break ; EXIT LOOP -> Button is gone!
            }
            
            ; If code reaches here, button is still visible, so the Loop repeats and clicks again.
        }
        
        ; 4. Wait for the black screen/teleport to finish
        Sleep, 3500 
        
        ; 5. Flip the switch to restart the bot
        GameFinished := True
        return
    }

    ; --- A. Start / Wave Skip ---
    if (FindText(X, Y, 0, 0, 1920, 1080, 0.1, 0.1, Text_StartAnchor)) {
        Click, % Spot_VoteSkip.x . ", " . Spot_VoteSkip.y
        Sleep, 600
        Click, % Spot_MagicianPath.x . ", " . Spot_MagicianPath.y
        Sleep, 1000
        return
    }

    if (FindText(X, Y, 0, 700, 1920, 900, 0.1, 0.1, Text_SwitchUnits)) {
        Click, % Spot_VoteSkip.x . ", " . Spot_VoteSkip.y
        Sleep, 500
    }

    ; --- C. Card Selector ---
    if (FindText(X, Y, 0, 0, 1920, 1080, 0.2, 0.2, Anchor_CardScreen)) {
        SelectBestCard()
        Sleep, 2000
    }
}

    #Include Logger.ahk 