; ==============================================================================
; === CONFIG.AHK - Centralized Configuration (AHK v1.1) ===
; ==============================================================================

; --- GLOBAL CONFIGURATION VARIABLES ---

; Dynamic Units (Name, Key pairs)
Global UnitCount := 0

; Dynamic Spots (Name, x, y, UnitName pairs)
Global SpotCount := 0

; Legacy compatibility - keep for now
Global Spot_Empty := {x: 100, y: 100}

; Upgrade Region
Global UX1 := 330
Global UY1 := 430
Global UX2 := 603
Global UY2 := 460

; Misc Spots
Global Spot_WaitClick := {x: 70, y: 200}
Global Spot_VoteSkip := {x: 1700, y: 950}
Global Spot_MagicianPath := {x: 960, y: 540}

; Strategy
Global CurrentStrategy := "Default"

; Custom Strategy
Global CustomStrategyActionCount := 0

; ==============================================================================
; === CONFIGURATION FUNCTIONS ===
; ==============================================================================

Config_LoadFromFile(filename := "config.ini") {
    Global CurrentConfigFile, CurrentStrategy
    
    if (filename != "")
        CurrentConfigFile := filename
        
    ; Load General Settings
    IniRead, CurrentStrategy, %CurrentConfigFile%, General, Strategy, Default
    
    ; Load Lists
    Units_LoadFromFile()
    Spots_LoadFromFile()
    CustomStrategy_LoadActions()
}

Config_SaveToFile(filename := "config.ini") {
    Global CurrentConfigFile
    Global CurrentStrategy
    
    if (filename != "")
        CurrentConfigFile := filename
        
    ; Save General Settings
    IniWrite, %CurrentStrategy%, %CurrentConfigFile%, General, Strategy
    
    ; Save Lists
    Units_SaveToFile()
    Spots_SaveToFile()
    CustomStrategy_SaveActions()
}

; ==============================================================================
; === UNIT MANAGEMENT FUNCTIONS ===
; ==============================================================================

Units_LoadFromFile() {
    Global
    Local idx, vName, vKey
    IniRead, UnitCount, %CurrentConfigFile%, Units, Count, 0
    Loop, %UnitCount% {
        idx := A_Index - 1
        IniRead, vName, %CurrentConfigFile%, Units, Unit%idx%_Name, %A_Space%
        IniRead, vKey,  %CurrentConfigFile%, Units, Unit%idx%_Key, %A_Space%
        Units%idx%_Name := vName
        Units%idx%_Key := vKey
    }
}

Units_LoadDefaults() {
    Global
    
    UnitCount := 6
    Units0_Name := "Kirito"
    Units0_Key := 1
    Units1_Name := "Ace"
    Units1_Key := 2
    Units2_Name := "Speedwagon"
    Units2_Key := 3
    Units3_Name := "Miku"
    Units3_Key := 4
    Units4_Name := "Akainu"
    Units4_Key := 5
    Units5_Name := "SJW"
    Units5_Key := 6
}

Units_SaveToFile() {
    Global
    Local idx
    IniWrite, %UnitCount%, %CurrentConfigFile%, Units, Count
    Loop, %UnitCount% {
        idx := A_Index - 1
        IniWrite, % Units%idx%_Name, %CurrentConfigFile%, Units, Unit%idx%_Name
        IniWrite, % Units%idx%_Key,  %CurrentConfigFile%, Units, Unit%idx%_Key
    }
}

Units_GetKey(unitName) {
    Global
    Local idx, currentName, currentKey
    
    Loop, %UnitCount% {
        idx := A_Index - 1
        currentName := Units%idx%_Name
        currentKey := Units%idx%_Key
        if (currentName = unitName) {
            return currentKey
        }
    }
    return 0
}

Units_GetName(unitKey) {
    Global
    Local idx, currentName, currentKey
    
    Loop, %UnitCount% {
        idx := A_Index - 1
        currentName := Units%idx%_Name
        currentKey := Units%idx%_Key
        if (currentKey = unitKey) {
            return currentName
        }
    }
    return ""
}

Units_Remove(unitIdx) {
    Global
    Local srcIdx, dstIdx, lastIdx
    
    if (unitIdx < 0 || unitIdx >= UnitCount)
        return
    
    ; Shift all units after this one down
    Loop, % UnitCount - unitIdx - 1 {
        srcIdx := unitIdx + A_Index
        dstIdx := srcIdx - 1
        
        Units%dstIdx%_Name := Units%srcIdx%_Name
        Units%dstIdx%_Key := Units%srcIdx%_Key
    }
    
    UnitCount--
    
    ; Clear last unit slot
    lastIdx := UnitCount
    Units%lastIdx%_Name := ""
    Units%lastIdx%_Key := ""
}

Units_Update(unitIdx, unitName, unitKey) {
    Global
    
    if (unitIdx < 0 || unitIdx >= UnitCount)
        return
    
    Units%unitIdx%_Name := unitName
    Units%unitIdx%_Key := unitKey
}

; ==============================================================================
; === SPOT MANAGEMENT FUNCTIONS ===
; ==============================================================================

Spots_LoadFromFile() {
    Global
    Local idx, vName, vX, vY, vUnit
    
    IniRead, SpotCount, %CurrentConfigFile%, Spots, Count, 0
    Loop, %SpotCount% {
        idx := A_Index - 1
        IniRead, vName, %CurrentConfigFile%, Spots, Spot%idx%_Name, %A_Space%
        IniRead, vX,    %CurrentConfigFile%, Spots, Spot%idx%_X, 0
        IniRead, vY,    %CurrentConfigFile%, Spots, Spot%idx%_Y, 0
        IniRead, vUnit, %CurrentConfigFile%, Spots, Spot%idx%_Unit, %A_Space%
        Spots%idx%_Name := vName
        Spots%idx%_X := vX
        Spots%idx%_Y := vY
        Spots%idx%_Unit := vUnit
    }
}

Spots_LoadDefaults() {
    Global
    
    SpotCount := 8
    Spots0_Name := "Spot_HillAce"
    Spots0_X := 545
    Spots0_Y := 370
    Spots0_Unit := "Ace"
    Spots1_Name := "Spot_GroundKirito"
    Spots1_X := 1819
    Spots1_Y := 733
    Spots1_Unit := "Kirito"
    Spots2_Name := "Spot_GroundKirito2"
    Spots2_X := 1594
    Spots2_Y := 591
    Spots2_Unit := "Kirito"
    Spots3_Name := "Spot_GroundMiku"
    Spots3_X := 933
    Spots3_Y := 617
    Spots3_Unit := "Miku"
    Spots4_Name := "Spot_GroundSpeed"
    Spots4_X := 333
    Spots4_Y := 900
    Spots4_Unit := "Speedwagon"
    Spots5_Name := "Spot_GroundAkainu1"
    Spots5_X := 1456
    Spots5_Y := 520
    Spots5_Unit := "Akainu"
    Spots6_Name := "Spot_GroundAkainu2"
    Spots6_X := 1219
    Spots6_Y := 511
    Spots6_Unit := "Akainu"
    Spots7_Name := "Spot_GroundSJW"
    Spots7_X := 64
    Spots7_Y := 682
    Spots7_Unit := "SJW"
}

Spots_SaveToFile() {
    Global
    Local idx
    
    IniWrite, %SpotCount%, %CurrentConfigFile%, Spots, Count
    Loop, %SpotCount% {
        idx := A_Index - 1
        IniWrite, % Spots%idx%_Name, %CurrentConfigFile%, Spots, Spot%idx%_Name
        IniWrite, % Spots%idx%_X,    %CurrentConfigFile%, Spots, Spot%idx%_X
        IniWrite, % Spots%idx%_Y,    %CurrentConfigFile%, Spots, Spot%idx%_Y
        IniWrite, % Spots%idx%_Unit, %CurrentConfigFile%, Spots, Spot%idx%_Unit
    }
}

Spots_GetSpot(spotName) {
    Global
    Local idx
    
    Loop, %SpotCount% {
        idx := A_Index - 1
        if (Spots%idx%_Name = spotName) {
            return {x: Spots%idx%_X, y: Spots%idx%_Y}
        }
    }
    return 0
}

Spots_Remove(spotIdx) {
    Global
    Local srcIdx, dstIdx, lastIdx
    
    if (spotIdx < 0 || spotIdx >= SpotCount)
        return
    
    ; Shift all spots after this one down
    Loop, % SpotCount - spotIdx - 1 {
        srcIdx := spotIdx + A_Index
        dstIdx := srcIdx - 1
        
        Spots%dstIdx%_Name := Spots%srcIdx%_Name
        Spots%dstIdx%_X := Spots%srcIdx%_X
        Spots%dstIdx%_Y := Spots%srcIdx%_Y
        Spots%dstIdx%_Unit := Spots%srcIdx%_Unit
    }
    
    SpotCount--
    
    ; Clear last spot slot
    lastIdx := SpotCount
    Spots%lastIdx%_Name := ""
    Spots%lastIdx%_X := ""
    Spots%lastIdx%_Y := ""
    Spots%lastIdx%_Unit := ""
}

Spots_Update(spotIdx, spotName, spotX, spotY, unitName := "") {
    Global
    
    if (spotIdx < 0 || spotIdx >= SpotCount)
        return
    
    Spots%spotIdx%_Name := spotName
    Spots%spotIdx%_X := spotX
    Spots%spotIdx%_Y := spotY
    Spots%spotIdx%_Unit := unitName
}

; ==============================================================================
; === CUSTOM STRATEGY FUNCTIONS ===
; ==============================================================================

CustomStrategy_LoadActions() {
    Global
    Local idx, vType, vKey, vSpot
    
    IniRead, CustomStrategyActionCount, %CurrentConfigFile%, CustomStrategy, Count, 0
    Loop, %CustomStrategyActionCount% {
        idx := A_Index - 1
        IniRead, vType, %CurrentConfigFile%, CustomStrategy, Action%idx%_Type, %A_Space%
        IniRead, vKey,  %CurrentConfigFile%, CustomStrategy, Action%idx%_Key, %A_Space%
        IniRead, vSpot, %CurrentConfigFile%, CustomStrategy, Action%idx%_Spot, %A_Space%
        CustomStrategyActions%idx%_Type := vType
        CustomStrategyActions%idx%_Key := vKey
        CustomStrategyActions%idx%_Spot := vSpot
    }
}

CustomStrategy_SaveActions() {
    Global
    Local idx
    
    IniWrite, %CustomStrategyActionCount%, %CurrentConfigFile%, CustomStrategy, Count
    Loop, %CustomStrategyActionCount% {
        idx := A_Index - 1
        IniWrite, % CustomStrategyActions%idx%_Type, %CurrentConfigFile%, CustomStrategy, Action%idx%_Type
        IniWrite, % CustomStrategyActions%idx%_Key,  %CurrentConfigFile%, CustomStrategy, Action%idx%_Key
        IniWrite, % CustomStrategyActions%idx%_Spot, %CurrentConfigFile%, CustomStrategy, Action%idx%_Spot
    }
}

CustomStrategy_AddAction(actionType, unitKey := 0, spotName := "") {
    Global
    
    ; Get the current index
    idx := CustomStrategyActionCount
    
    ; Set the action data
    CustomStrategyActions%idx%_Type := actionType
    
    if (actionType = "PlaceUnit") {
        CustomStrategyActions%idx%_Key := unitKey
        CustomStrategyActions%idx%_Spot := spotName
    } else if (actionType = "UpgradeMax") {
        CustomStrategyActions%idx%_Key := 0
        CustomStrategyActions%idx%_Spot := spotName
    }
    
    ; Increment the count
    CustomStrategyActionCount++
}

CustomStrategy_RemoveAction(actionIdx) {
    Global
    Local srcIdx, dstIdx, lastIdx
    
    if (actionIdx < 0 || actionIdx >= CustomStrategyActionCount)
        return
    
    ; Shift all actions after this one down
    Loop, % CustomStrategyActionCount - actionIdx - 1 {
        srcIdx := actionIdx + A_Index
        dstIdx := srcIdx - 1
        
        CustomStrategyActions%dstIdx%_Type := CustomStrategyActions%srcIdx%_Type
        CustomStrategyActions%dstIdx%_Key := CustomStrategyActions%srcIdx%_Key
        CustomStrategyActions%dstIdx%_Spot := CustomStrategyActions%srcIdx%_Spot
    }
    
    CustomStrategyActionCount--
    
    ; Clear last action slot
    lastIdx := CustomStrategyActionCount
    CustomStrategyActions%lastIdx%_Type := ""
    CustomStrategyActions%lastIdx%_Key := ""
    CustomStrategyActions%lastIdx%_Spot := ""
}

CustomStrategy_UpdateAction(actionIdx, actionType, unitKey := 0, spotName := "") {
    Global
    
    if (actionIdx < 0 || actionIdx >= CustomStrategyActionCount)
        return
    
    CustomStrategyActions%actionIdx%_Type := actionType
    
    if (actionType = "PlaceUnit") {
        CustomStrategyActions%actionIdx%_Key := unitKey
        CustomStrategyActions%actionIdx%_Spot := spotName
    } else if (actionType = "UpgradeMax") {
        CustomStrategyActions%actionIdx%_Spot := spotName
    }
}