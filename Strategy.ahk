; ==============================================================================
; === STRATEGY.AHK - Strategy Definitions (AHK v1.1) ===
; ==============================================================================

Strategy_Execute_Default() {
    Global Key_Speedwagon, Key_SJW, Key_Kirito, Key_Ace, Key_Akainu, Key_Miku
    Global Spot_GroundSpeed, Spot_GroundSJW, Spot_GroundKirito, Spot_HillAce
    Global Spot_GroundAkainu1, Spot_GroundAkainu2, Spot_GroundMiku, Spot_GroundKirito2
    Global Text_Upg1
    
    SafePlace(Key_Speedwagon, Spot_GroundSpeed)
    SafePlace(Key_SJW, Spot_GroundSJW)
    Sleep, 500
    
    SafeUpgradeTo(Spot_GroundSpeed, Text_Upg1)
    SafePlace(Key_Kirito, Spot_GroundKirito)
    SafeMaxUpgrade(Spot_GroundSpeed)
    SafeMaxUpgrade(Spot_GroundKirito)
    
    SafePlace(Key_Ace, Spot_HillAce)
    SafePlace(Key_Akainu, Spot_GroundAkainu1)
    SafePlace(Key_Akainu, Spot_GroundAkainu2)
    
    SafePlace(Key_Miku, Spot_GroundMiku)
    Sleep, 500
    SafeMaxUpgrade(Spot_GroundMiku)
    SafeMaxUpgrade(Spot_GroundSJW)
    
    SafePlace(Key_Kirito, Spot_GroundKirito2)
    Sleep, 500
    SafeMaxUpgrade(Spot_GroundKirito2)
}

Strategy_Execute_Rework() {
    Global Key_Speedwagon, Key_SJW, Key_Miku, Key_Ace
    Global RSpot_Speed, RSpot_SJW, RSpot_Miku, RSpot_Ace
    
    SafePlace(Key_Speedwagon, RSpot_Speed)
    SafePlace(Key_SJW, RSpot_SJW)
    SafeMaxUpgrade(RSpot_Speed)
    SafeMaxUpgrade(RSpot_SJW)
    SafePlace(Key_Miku, RSpot_Miku)
    Sleep, 500
    SafeMaxUpgrade(RSpot_Miku)
    SafePlace(Key_Ace, RSpot_Ace)
    Sleep, 500
    SafeMaxUpgrade(RSpot_Ace)
}

Strategy_Execute_Speed() {
    Global Key_Speedwagon, Key_Kirito, Key_Ace
    Global Spot_GroundSpeed, Spot_GroundKirito, Spot_HillAce
    
    SafePlace(Key_Speedwagon, Spot_GroundSpeed)
    SafeMaxUpgrade(Spot_GroundSpeed)
    SafePlace(Key_Kirito, Spot_GroundKirito)
    SafeMaxUpgrade(Spot_GroundKirito)
    SafePlace(Key_Ace, Spot_HillAce)
}

Strategy_Execute_Custom() {
    Global Key_Kirito, Key_Ace, Key_Speedwagon, Key_Miku, Key_Akainu, Key_SJW
    Global Spot_HillAce, Spot_GroundKirito, Spot_GroundKirito2, Spot_GroundMiku
    Global Spot_GroundSpeed, Spot_GroundAkainu1, Spot_GroundAkainu2, Spot_GroundSJW
    Global RSpot_Speed, RSpot_SJW, RSpot_Miku, RSpot_Ace
    Global CustomStrategyActionCount
    
    ; Load custom strategy actions
    CustomStrategy_LoadActions()
    
    ; Execute each action
    Loop, %CustomStrategyActionCount% {
        idx := A_Index - 1
        actionType := CustomStrategyActions%idx%_Type
        
        if (actionType = "PlaceUnit") {
            unitKey := CustomStrategyActions%idx%_Key
            spotName := CustomStrategyActions%idx%_Spot
            
            ; Get spot object from name
            spot := GetSpotFromName(spotName)
            if (spot) {
                SafePlace(unitKey, spot)
            }
        } else if (actionType = "UpgradeMax") {
            spotName := CustomStrategyActions%idx%_Spot
            
            ; Get spot object from name
            spot := GetSpotFromName(spotName)
            if (spot) {
                SafeMaxUpgrade(spot)
            }
        }
    }
}

GetSpotFromName(spotName) {
    return Spots_GetSpot(spotName)
}

Strategy_Execute(strategyName := "Default") {
    if (strategyName = "Default")
        Strategy_Execute_Default()
    else if (strategyName = "Rework")
        Strategy_Execute_Rework()
    else if (strategyName = "Speed")
        Strategy_Execute_Speed()
    else if (strategyName = "Custom")
        Strategy_Execute_Custom()
    else
        Strategy_Execute_Default()
}