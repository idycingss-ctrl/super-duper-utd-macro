; ==============================================================================
; === CONFIG GUI - Visual Configuration Editor (AHK v1.1) ===
; ==============================================================================

ShowConfigGUI() {
    Global CurrentStrategy
    Global StrategyDescText, StrategyDesc1, StrategyDesc2, StrategyDesc3
    Global CustomStrategyLabel, CustomStrategyList
    Global AddPlaceUnitBtn, AddUpgradeMaxBtn, RemoveStrategyBtn, EditStrategyBtn, ClearAllStrategyBtn
    Global UnitsList, AddUnitBtn, EditUnitBtn, RemoveUnitBtn
    Global SpotsList, AddSpotBtn, EditSpotBtn, RemoveSpotBtn
    Global ConfigLoaded, CurrentConfigFile
    
    ; FIX: Only load configuration ONCE when script starts
    if (ConfigLoaded = 0) {
        if FileExist("config.ini")
            Config_LoadFromFile("config.ini")
        ConfigLoaded := 1
    }
    
    Gui, Config:New, , Bot Configuration - %CurrentConfigFile%
    Gui, Config:Font, s10
    
    ; === TAB CONTROL ===
    Gui, Config:Add, Tab3, x10 y10 w680 h500 gOnTabChange, Keys|Coordinates|Strategy
    
    ; === TAB 1: KEYS ===
    Gui, Config:Tab, 1
    Gui, Config:Add, Text, x30 y50, Unit Key Bindings:
    ; FIX: Added AltSubmit, NoSortHdr, -Multi
    Gui, Config:Add, ListView, x30 y80 w450 h300 vUnitsList gOnUnitsListSelect AltSubmit NoSortHdr -Multi, #|Name|Key
    Gui, Config:Add, Button, x30 y390 w100 vAddUnitBtn gAddUnitAction, Add
    Gui, Config:Add, Button, x140 y390 w100 vEditUnitBtn gEditUnitAction Disabled, Edit
    Gui, Config:Add, Button, x250 y390 w100 vRemoveUnitBtn gRemoveUnitAction Disabled, Remove
    
    ; === TAB 2: COORDINATES ===
    Gui, Config:Tab, 2
    Gui, Config:Add, Text, x30 y50, Unit Placement Coordinates:
    ; FIX: Added AltSubmit, NoSortHdr, -Multi
    Gui, Config:Add, ListView, x30 y80 w500 h300 vSpotsList gOnSpotsListSelect AltSubmit NoSortHdr -Multi, #|Name|X|Y|Unit
    Gui, Config:Add, Button, x30 y390 w100 vAddSpotBtn gAddSpotAction, Add
    Gui, Config:Add, Button, x140 y390 w100 vEditSpotBtn gEditSpotAction Disabled, Edit
    Gui, Config:Add, Button, x250 y390 w100 vRemoveSpotBtn gRemoveSpotAction Disabled, Remove
    
    ; === TAB 3: STRATEGY ===
    Gui, Config:Tab, 3
    Gui, Config:Add, Text, x30 y50, Select Strategy:
    Gui, Config:Add, DropDownList, x30 y80 w200 vCurrentStrategy gOnStrategyChange, Default|Rework|Speed|Custom
    GuiControl, Config:ChooseString, CurrentStrategy, %CurrentStrategy%
    
    Gui, Config:Add, Text, x30 y120 vStrategyDescText, Strategy Descriptions:
    Gui, Config:Add, Text, x30 y150 w550 vStrategyDesc1, Default: Full placement with upgrades
    Gui, Config:Add, Text, x30 y200 w550 vStrategyDesc2, Rework: Alternative placement pattern
    Gui, Config:Add, Text, x30 y250 w550 vStrategyDesc3, Speed: Fast strategy with minimal units
    
    Gui, Config:Add, Text, x30 y120 vCustomStrategyLabel Hidden, Custom Strategy Actions:
    ; FIX: Added AltSubmit, NoSortHdr, -Multi
    Gui, Config:Add, ListView, x30 y150 w450 h250 vCustomStrategyList gOnStrategyListSelect AltSubmit NoSortHdr -Multi Hidden, #|Action|Unit/Spot
    
    Gui, Config:Add, Button, x30 y410 w100 vAddPlaceUnitBtn gAddPlaceUnitAction Hidden, Add PlaceUnit
    Gui, Config:Add, Button, x140 y410 w100 vAddUpgradeMaxBtn gAddUpgradeMaxAction Hidden, Add UpgradeMax
    Gui, Config:Add, Button, x250 y410 w100 vClearAllStrategyBtn gClearAllStrategyAction Hidden, Clear All
    Gui, Config:Add, Button, x360 y410 w100 vEditStrategyBtn gEditStrategyAction Hidden Disabled, Edit
    Gui, Config:Add, Button, x360 y450 w100 vRemoveStrategyBtn gRemoveStrategyAction Hidden Disabled, Remove
    
    UpdateStrategyControls()
    
    ; === BOTTOM BUTTONS ===
    Gui, Config:Tab
    Gui, Config:Add, Button, x50 y520 w100 gSaveConfig, Save
    Gui, Config:Add, Button, x160 y520 w100 gSaveConfigAs, Save As...
    Gui, Config:Add, Button, x270 y520 w100 gLoadConfig, Load Default
    Gui, Config:Add, Button, x380 y520 w100 gLoadConfigFrom, Load From...
    Gui, Config:Add, Button, x490 y520 w100 gConfigClose, Close
    
    Gui, Config:Show, w700 h570
    
    RefreshUnitsList()
    RefreshSpotsList()
    if (CurrentStrategy = "Custom")
        RefreshCustomStrategyList()
    return
}

; === TAB CHANGE HANDLER ===
OnTabChange:
    ; This ensures lists are refreshed when switching tabs
    ; No action needed as we keep data in sync
return

; === STRATEGY CONTROL VISIBILITY ===
UpdateStrategyControls() {
    Global CurrentStrategy
    
    if (CurrentStrategy = "Custom") {
        GuiControl, Config:Hide, StrategyDescText
        GuiControl, Config:Hide, StrategyDesc1
        GuiControl, Config:Hide, StrategyDesc2
        GuiControl, Config:Hide, StrategyDesc3
        GuiControl, Config:Show, CustomStrategyLabel
        GuiControl, Config:Show, CustomStrategyList
        GuiControl, Config:Show, AddPlaceUnitBtn
        GuiControl, Config:Show, AddUpgradeMaxBtn
        GuiControl, Config:Show, ClearAllStrategyBtn
        GuiControl, Config:Show, EditStrategyBtn
        GuiControl, Config:Show, RemoveStrategyBtn
        RefreshCustomStrategyList()
    } else {
        GuiControl, Config:Show, StrategyDescText
        GuiControl, Config:Show, StrategyDesc1
        GuiControl, Config:Show, StrategyDesc2
        GuiControl, Config:Show, StrategyDesc3
        GuiControl, Config:Hide, CustomStrategyLabel
        GuiControl, Config:Hide, CustomStrategyList
        GuiControl, Config:Hide, AddPlaceUnitBtn
        GuiControl, Config:Hide, AddUpgradeMaxBtn
        GuiControl, Config:Hide, ClearAllStrategyBtn
        GuiControl, Config:Hide, EditStrategyBtn
        GuiControl, Config:Hide, RemoveStrategyBtn
    }
}

; === UNIT MANAGEMENT FUNCTIONS ===

RefreshUnitsList() {
    Global UnitCount
    
    Gui, Config:Default
    Gui, Config:ListView, UnitsList
    
    ; Clear the list
    LV_Delete()
    
    ; Populate list from memory (already loaded)
    Loop, %UnitCount% {
        idx := A_Index - 1
        unitName := Units%idx%_Name
        unitKey := Units%idx%_Key
        LV_Add("", A_Index, unitName, unitKey)
    }
    
    ; Auto-size columns
    LV_ModifyCol(1, "Auto Integer")
    LV_ModifyCol(2, "Auto")
    LV_ModifyCol(3, "Auto")
    
    ; Disable Edit/Remove buttons if no selection
    GuiControl, Config:Disable, EditUnitBtn
    GuiControl, Config:Disable, RemoveUnitBtn
}

OnUnitsListSelect:
    Gui, Config:Default
    Gui, Config:ListView, UnitsList
    if (A_GuiEvent = "DoubleClick")
        Goto, EditUnitAction
        
    ; This works because of AltSubmit
    selectedRow := LV_GetNext()
    if (selectedRow > 0) {
        GuiControl, Config:Enable, EditUnitBtn
        GuiControl, Config:Enable, RemoveUnitBtn
    } else {
        GuiControl, Config:Disable, EditUnitBtn
        GuiControl, Config:Disable, RemoveUnitBtn
    }
return

AddUnitAction:
    Gui, AddUnit:New, , Add Unit
    Gui, AddUnit:Font, s10
    
    Gui, AddUnit:Add, Text, x20 y20, Unit Name:
    Gui, AddUnit:Add, Edit, x120 y20 w150 vAddUnitName
    Gui, AddUnit:Add, Text, x20 y60, Key:
    Gui, AddUnit:Add, Edit, x120 y60 w50 vAddUnitKey
    
    Gui, AddUnit:Add, Button, x120 y100 w80 gConfirmAddUnit Default, OK
    Gui, AddUnit:Add, Button, x210 y100 w80 gCancelAddUnit, Cancel
    
    Gui, AddUnit:Show, w300 h150
return

ConfirmAddUnit:
    Gui, AddUnit:Submit
    Gui, AddUnit:Destroy
    
    if (AddUnitName = "" || AddUnitKey = "") {
        MsgBox, Please enter both unit name and key.
        return
    }
    
    ; Find first empty slot or use the end
    Global UnitCount
    foundEmpty := false
    emptyIdx := 0
    
    Loop, %UnitCount% {
        idx := A_Index - 1
        if (Units%idx%_Name = "" || Units%idx%_Name = "ERROR") {
            foundEmpty := true
            emptyIdx := idx
            break
        }
    }
    
    if (foundEmpty) {
        ; Fill the empty slot
        Units%emptyIdx%_Name := AddUnitName
        Units%emptyIdx%_Key := AddUnitKey
    } else {
        ; Add to the end
        newIdx := UnitCount
        Units%newIdx%_Name := AddUnitName
        Units%newIdx%_Key := AddUnitKey
        UnitCount++
    }
    
    ; Refresh display
    RefreshUnitsList()
    
    ; Save to file
    
return

CancelAddUnit:
    Gui, AddUnit:Destroy
return

EditUnitAction:
    Gui, Config:Default
    Gui, Config:ListView, UnitsList
    selectedRow := LV_GetNext()
    if (!selectedRow) {
        MsgBox, Please select a unit to edit.
        return
    }
    
    unitIdx := selectedRow - 1
    currentName := Units%unitIdx%_Name
    currentKey := Units%unitIdx%_Key
    
    Gui, EditUnit:New, , Edit Unit
    Gui, EditUnit:Font, s10
    
    Gui, EditUnit:Add, Text, x20 y20, Unit Name:
    Gui, EditUnit:Add, Edit, x120 y20 w150 vEditUnitName, %currentName%
    Gui, EditUnit:Add, Text, x20 y60, Key:
    Gui, EditUnit:Add, Edit, x120 y60 w50 vEditUnitKey, %currentKey%
    
    Gui, EditUnit:Add, Button, x120 y100 w80 gConfirmEditUnit Default, OK
    Gui, EditUnit:Add, Button, x210 y100 w80 gCancelEditUnit, Cancel
    
    EditUnitIndex := unitIdx
    Gui, EditUnit:Show, w300 h150
return

ConfirmEditUnit:
    Gui, EditUnit:Submit
    Gui, EditUnit:Destroy
    
    Global EditUnitIndex
    
    ; Update in memory
    Units_Update(EditUnitIndex, EditUnitName, EditUnitKey)
    
    ; Refresh display
    RefreshUnitsList()
    
    ; Save to file
    
    
    EditUnitIndex := ""
return

CancelEditUnit:
    Gui, EditUnit:Destroy
    EditUnitIndex := ""
return

RemoveUnitAction:
    Gui, Config:Default
    Gui, Config:ListView, UnitsList
    selectedRow := LV_GetNext()
    if (!selectedRow) {
        MsgBox, Please select a unit to remove.
        return
    }
    
    unitIdx := selectedRow - 1
    unitName := Units%unitIdx%_Name
    
    MsgBox, 4, Confirm Delete, Are you sure you want to delete unit "%unitName%"?
    IfMsgBox No
        return
    
    ; Remove from memory
    Units_Remove(unitIdx)
    
    ; Refresh display
    RefreshUnitsList()
    
return

; === SPOT MANAGEMENT FUNCTIONS ===

RefreshSpotsList() {
    Global SpotCount
    
    Gui, Config:Default
    Gui, Config:ListView, SpotsList
    
    ; Clear the list
    LV_Delete()
    
    ; Populate list from memory (already loaded)
    Loop, %SpotCount% {
        idx := A_Index - 1
        spotName := Spots%idx%_Name
        spotX := Spots%idx%_X
        spotY := Spots%idx%_Y
        unitName := Spots%idx%_Unit
        LV_Add("", A_Index, spotName, spotX, spotY, unitName)
    }
    
    ; Auto-size columns
    LV_ModifyCol(1, "Auto Integer")
    LV_ModifyCol(2, "Auto")
    LV_ModifyCol(3, "Auto")
    LV_ModifyCol(4, "Auto")
    LV_ModifyCol(5, "Auto")
    
    ; Disable Edit/Remove buttons if no selection
    GuiControl, Config:Disable, EditSpotBtn
    GuiControl, Config:Disable, RemoveSpotBtn
}

OnSpotsListSelect:
    Gui, Config:Default
    Gui, Config:ListView, SpotsList
    if (A_GuiEvent = "DoubleClick")
        Goto, EditSpotAction
        
    selectedRow := LV_GetNext()
    if (selectedRow > 0) {
        GuiControl, Config:Enable, EditSpotBtn
        GuiControl, Config:Enable, RemoveSpotBtn
    } else {
        GuiControl, Config:Disable, EditSpotBtn
        GuiControl, Config:Disable, RemoveSpotBtn
    }
return

AddSpotAction:
    ; Build unit list for dropdown
    unitList := ""
    Loop, %UnitCount% {
        idx := A_Index - 1
        unitName := Units%idx%_Name
        if (A_Index = 1)
            unitList := unitName
        else
            unitList := unitList . "|" . unitName
    }
    
    Gui, AddSpot:New, , Add Spot
    Gui, AddSpot:Font, s10
    
    Gui, AddSpot:Add, Text, x20 y20, Spot Name:
    Gui, AddSpot:Add, Edit, x120 y20 w200 vAddSpotName
    Gui, AddSpot:Add, Text, x20 y60, X:
    Gui, AddSpot:Add, Edit, x120 y60 w80 vAddSpotX
    Gui, AddSpot:Add, Text, x210 y60, Y:
    Gui, AddSpot:Add, Edit, x240 y60 w80 vAddSpotY
    Gui, AddSpot:Add, Text, x20 y100, Unit:
    Gui, AddSpot:Add, DropDownList, x120 y100 w200 vAddSpotUnit, %unitList%
    if (UnitCount > 0)
        GuiControl, AddSpot:Choose, AddSpotUnit, 1
    Gui, AddSpot:Add, Button, x120 y140 w80 gConfirmAddSpot Default, OK
    Gui, AddSpot:Add, Button, x210 y140 w80 gCaptureAddSpot, Capture
    Gui, AddSpot:Add, Button, x120 y180 w170 gCancelAddSpot, Cancel
    
    Gui, AddSpot:Show, w350 h220
return

CaptureAddSpot:
    Gui, AddSpot:Submit, NoHide
    Gui, AddSpot:Hide
    ToolTip, Move mouse to desired position and press SPACE
    KeyWait, Space, D
    MouseGetPos, mx, my
    ToolTip
    GuiControl, AddSpot:, AddSpotX, %mx%
    GuiControl, AddSpot:, AddSpotY, %my%
    Gui, AddSpot:Show
return

ConfirmAddSpot:
    Gui, AddSpot:Submit
    Gui, AddSpot:Destroy
    
    if (AddSpotName = "" || AddSpotX = "" || AddSpotY = "") {
        MsgBox, Please enter spot name and coordinates.
        return
    }
    
    ; Find first empty slot or use the end
    Global SpotCount
    foundEmpty := false
    emptyIdx := 0
    
    Loop, %SpotCount% {
        idx := A_Index - 1
        if (Spots%idx%_Name = "" || Spots%idx%_Name = "ERROR") {
            foundEmpty := true
            emptyIdx := idx
            break
        }
    }
    
    if (foundEmpty) {
        ; Fill the empty slot
        Spots%emptyIdx%_Name := AddSpotName
        Spots%emptyIdx%_X := AddSpotX
        Spots%emptyIdx%_Y := AddSpotY
        Spots%emptyIdx%_Unit := AddSpotUnit
    } else {
        ; Add to the end
        newIdx := SpotCount
        Spots%newIdx%_Name := AddSpotName
        Spots%newIdx%_X := AddSpotX
        Spots%newIdx%_Y := AddSpotY
        Spots%newIdx%_Unit := AddSpotUnit
        SpotCount++
    }
    
    ; Refresh display
    RefreshSpotsList()
    

return

CancelAddSpot:
    Gui, AddSpot:Destroy
return

EditSpotAction:
    Gui, Config:Default
    Gui, Config:ListView, SpotsList
    selectedRow := LV_GetNext()
    if (!selectedRow) {
        MsgBox, Please select a spot to edit.
        return
    }
    
    spotIdx := selectedRow - 1
    currentName := Spots%spotIdx%_Name
    currentX := Spots%spotIdx%_X
    currentY := Spots%spotIdx%_Y
    currentUnit := Spots%spotIdx%_Unit
    
    ; Build unit list for dropdown
    unitList := ""
    Loop, %UnitCount% {
        idx := A_Index - 1
        unitName := Units%idx%_Name
        if (A_Index = 1)
            unitList := unitName
        else
            unitList := unitList . "|" . unitName
    }
    
    Gui, EditSpot:New, , Edit Spot
    Gui, EditSpot:Font, s10
    
    Gui, EditSpot:Add, Text, x20 y20, Spot Name:
    Gui, EditSpot:Add, Edit, x120 y20 w200 vEditSpotName, %currentName%
    Gui, EditSpot:Add, Text, x20 y60, X:
    Gui, EditSpot:Add, Edit, x120 y60 w80 vEditSpotX, %currentX%
    Gui, EditSpot:Add, Text, x210 y60, Y:
    Gui, EditSpot:Add, Edit, x240 y60 w80 vEditSpotY, %currentY%
    Gui, EditSpot:Add, Text, x20 y100, Unit:
    Gui, EditSpot:Add, DropDownList, x120 y100 w200 vEditSpotUnit, %unitList%
    GuiControl, EditSpot:ChooseString, EditSpotUnit, %currentUnit%
    Gui, EditSpot:Add, Button, x120 y140 w80 gConfirmEditSpot Default, OK
    Gui, EditSpot:Add, Button, x210 y140 w80 gCaptureEditSpot, Capture
    Gui, EditSpot:Add, Button, x120 y180 w170 gCancelEditSpot, Cancel
    
    EditSpotIndex := spotIdx
    Gui, EditSpot:Show, w350 h220
return

CaptureEditSpot:
    Gui, EditSpot:Submit, NoHide
    Gui, EditSpot:Hide
    ToolTip, Move mouse to desired position and press SPACE
    KeyWait, Space, D
    MouseGetPos, mx, my
    ToolTip
    GuiControl, EditSpot:, EditSpotX, %mx%
    GuiControl, EditSpot:, EditSpotY, %my%
    Gui, EditSpot:Show
return

ConfirmEditSpot:
    Gui, EditSpot:Submit
    Gui, EditSpot:Destroy
    
    Global EditSpotIndex
    
    ; Update in memory
    Spots_Update(EditSpotIndex, EditSpotName, EditSpotX, EditSpotY, EditSpotUnit)
    
    ; Refresh display
    RefreshSpotsList()
    
    ; Save to file

    
    EditSpotIndex := ""
return

CancelEditSpot:
    Gui, EditSpot:Destroy
    EditSpotIndex := ""
return

RemoveSpotAction:
    Gui, Config:Default
    Gui, Config:ListView, SpotsList
    selectedRow := LV_GetNext()
    if (!selectedRow) {
        MsgBox, Please select a spot to remove.
        return
    }
    
    spotIdx := selectedRow - 1
    spotName := Spots%spotIdx%_Name
    
    MsgBox, 4, Confirm Delete, Are you sure you want to delete spot "%spotName%"?
    IfMsgBox No
        return
    
    ; Remove from memory
    Spots_Remove(spotIdx)
    
    ; Refresh display
    RefreshSpotsList()
    
return

; === CUSTOM STRATEGY FUNCTIONS ===

OnStrategyChange:
    Gui, Config:Submit, NoHide
    UpdateStrategyControls()
return

RefreshCustomStrategyList() {
    Global CustomStrategyActionCount
    
    Gui, Config:Default
    Gui, Config:ListView, CustomStrategyList
    
    ; Clear the list
    LV_Delete()
    
    ; Populate list from memory (already loaded)
    Loop, %CustomStrategyActionCount% {
        idx := A_Index - 1
        actionType := CustomStrategyActions%idx%_Type
        if (actionType = "PlaceUnit") {
            unitKey := CustomStrategyActions%idx%_Key
            spotName := CustomStrategyActions%idx%_Spot
            unitName := Units_GetName(unitKey)
            LV_Add("", A_Index, "PlaceUnit", unitName . " @ " . spotName)
        } else if (actionType = "UpgradeMax") {
            spotName := CustomStrategyActions%idx%_Spot
            LV_Add("", A_Index, "UpgradeMax", spotName)
        }
    }
    
    ; Auto-size columns
    LV_ModifyCol(1, "Auto Integer")
    LV_ModifyCol(2, "Auto")
    LV_ModifyCol(3, "Auto")
    
    ; Disable Edit/Remove buttons if no selection
    GuiControl, Config:Disable, EditStrategyBtn
    GuiControl, Config:Disable, RemoveStrategyBtn
}

OnStrategyListSelect:
    Gui, Config:Default
    Gui, Config:ListView, CustomStrategyList
    
    if (A_GuiEvent = "DoubleClick") {
        Goto, EditStrategyAction
    }
    
    ; Check selection on any event (click, arrow keys, etc.)
    selectedRow := LV_GetNext()
    if (selectedRow > 0) {
        GuiControl, Config:Enable, EditStrategyBtn
        GuiControl, Config:Enable, RemoveStrategyBtn
    } else {
        GuiControl, Config:Disable, EditStrategyBtn
        GuiControl, Config:Disable, RemoveStrategyBtn
    }
return

; Hotkey for Delete key in Custom Strategy list
#IfWinActive, Bot Configuration
Delete::
    ; Check if CustomStrategyList is focused
    GuiControlGet, focusedControl, Config:FocusV
    if (focusedControl = "CustomStrategyList") {
        Goto, RemoveStrategyAction
    }
return
#IfWinActive

AddPlaceUnitAction:
    Global UnitCount, SpotCount
    
    ; Check if we have units and spots
    if (UnitCount = 0) {
        MsgBox, Please add units first before creating PlaceUnit actions.
        return
    }
    if (SpotCount = 0) {
        MsgBox, Please add spots first before creating PlaceUnit actions.
        return
    }
    
    ; Build unit list for dropdown
    unitList := ""
    Loop, %UnitCount% {
        idx := A_Index - 1
        unitName := Units%idx%_Name
        if (unitName != "" && unitName != "ERROR") {
            if (unitList = "")
                unitList := unitName
            else
                unitList := unitList . "|" . unitName
        }
    }
    
    ; Build spot list for dropdown
    spotList := ""
    Loop, %SpotCount% {
        idx := A_Index - 1
        spotName := Spots%idx%_Name
        if (spotName != "" && spotName != "ERROR") {
            if (spotList = "")
                spotList := spotName
            else
                spotList := spotList . "|" . spotName
        }
    }
    
    if (unitList = "" || spotList = "") {
        MsgBox, No valid units or spots available.
        return
    }
    
    Gui, AddAction:New, , Add PlaceUnit Action
    Gui, AddAction:Font, s10
    
    Gui, AddAction:Add, Text, x20 y20, Unit:
    Gui, AddAction:Add, DropDownList, x80 y20 w150 vAddActionUnit, %unitList%
    GuiControl, AddAction:Choose, AddActionUnit, 1
    
    Gui, AddAction:Add, Text, x20 y60, Spot:
    Gui, AddAction:Add, DropDownList, x80 y60 w200 vAddActionSpot, %spotList%
    GuiControl, AddAction:Choose, AddActionSpot, 1
    
    Gui, AddAction:Add, Button, x80 y100 w80 gConfirmAddPlaceUnit Default, OK
    Gui, AddAction:Add, Button, x170 y100 w80 gCancelAddAction, Cancel
    
    Gui, AddAction:Show, w300 h140
return

ConfirmAddPlaceUnit:
    Global AddActionUnit, AddActionSpot, CustomStrategyActionCount
    Gui, AddAction:Submit, NoHide
    Gui, AddAction:Destroy
    
    ; Validate selections
    if (AddActionUnit = "" || AddActionSpot = "") {
        MsgBox, Please select both unit and spot.
        return
    }
    
    ; Get unit key from unit name
    unitKey := Units_GetKey(AddActionUnit)
    
    if (unitKey = 0 || unitKey = "") {
        MsgBox, Error: Could not find unit key for "%AddActionUnit%"
        return
    }
    
    ; Add action to memory
    CustomStrategy_AddAction("PlaceUnit", unitKey, AddActionSpot)
    

    
    ; Then refresh display
    RefreshCustomStrategyList()
    
    ; Clear variables
    AddActionUnit := ""
    AddActionSpot := ""
return

AddUpgradeMaxAction:
    Global SpotCount
    
    ; Check if we have spots
    if (SpotCount = 0) {
        MsgBox, Please add spots first before creating UpgradeMax actions.
        return
    }
    
    ; Build spot list for dropdown
    spotList := ""
    Loop, %SpotCount% {
        idx := A_Index - 1
        spotName := Spots%idx%_Name
        if (spotName != "" && spotName != "ERROR") {
            if (spotList = "")
                spotList := spotName
            else
                spotList := spotList . "|" . spotName
        }
    }
    
    if (spotList = "") {
        MsgBox, No valid spots available.
        return
    }
    
    Gui, AddAction:New, , Add UpgradeMax Action
    Gui, AddAction:Font, s10
    
    Gui, AddAction:Add, Text, x20 y20, Spot:
    Gui, AddAction:Add, DropDownList, x80 y20 w200 vAddActionSpot, %spotList%
    GuiControl, AddAction:Choose, AddActionSpot, 1
    
    Gui, AddAction:Add, Button, x80 y60 w80 gConfirmAddUpgradeMax Default, OK
    Gui, AddAction:Add, Button, x170 y60 w80 gCancelAddAction, Cancel
    
    Gui, AddAction:Show, w300 h100
return

ConfirmAddUpgradeMax:
    Global AddActionSpot, CustomStrategyActionCount
    Gui, AddAction:Submit, NoHide
    Gui, AddAction:Destroy
    
    ; Validate selection
    if (AddActionSpot = "") {
        MsgBox, Please select a spot.
        return
    }
    
    ; Add action to memory
    CustomStrategy_AddAction("UpgradeMax", 0, AddActionSpot)
    

    
    ; Then refresh display
    RefreshCustomStrategyList()
    
    ; Clear variable
    AddActionSpot := ""
return

CancelAddAction:
    Gui, AddAction:Destroy
return

ClearAllStrategyAction:
    MsgBox, 4, Confirm Clear All, Are you sure you want to clear all custom strategy actions?
    IfMsgBox No
        return
    
    ; Clear all actions
    Global CustomStrategyActionCount
    Loop, %CustomStrategyActionCount% {
        idx := A_Index - 1
        CustomStrategyActions%idx%_Type := ""
        CustomStrategyActions%idx%_Key := ""
        CustomStrategyActions%idx%_Spot := ""
    }
    CustomStrategyActionCount := 0
    

    
    ; Refresh display
    RefreshCustomStrategyList()
return

EditStrategyAction:
    Gui, Config:Default
    Gui, Config:ListView, CustomStrategyList
    selectedRow := LV_GetNext()
    if (!selectedRow) {
        MsgBox, Please select an action to edit.
        return
    }
    
    actionIdx := selectedRow - 1
    actionType := CustomStrategyActions%actionIdx%_Type
    
    if (actionType = "PlaceUnit") {
        ; Edit PlaceUnit action
        currentKey := CustomStrategyActions%actionIdx%_Key
        currentSpot := CustomStrategyActions%actionIdx%_Spot
        currentUnit := Units_GetName(currentKey)
        
        ; Build unit list for dropdown
        unitList := ""
        Loop, %UnitCount% {
            idx := A_Index - 1
            unitName := Units%idx%_Name
            if (A_Index = 1)
                unitList := unitName
            else
                unitList := unitList . "|" . unitName
        }
        
        ; Build spot list for dropdown
        spotList := ""
        Loop, %SpotCount% {
            idx := A_Index - 1
            spotName := Spots%idx%_Name
            if (A_Index = 1)
                spotList := spotName
            else
                spotList := spotList . "|" . spotName
        }
        
        Gui, EditAction:New, , Edit PlaceUnit Action
        Gui, EditAction:Font, s10
        
        Gui, EditAction:Add, Text, x20 y20, Unit:
        Gui, EditAction:Add, DropDownList, x80 y20 w150 vEditActionUnit, %unitList%
        GuiControl, EditAction:ChooseString, EditActionUnit, %currentUnit%
        
        Gui, EditAction:Add, Text, x20 y60, Spot:
        Gui, EditAction:Add, DropDownList, x80 y60 w200 vEditActionSpot, %spotList%
        GuiControl, EditAction:ChooseString, EditActionSpot, %currentSpot%
        
        Gui, EditAction:Add, Button, x80 y100 w80 gConfirmEditPlaceUnit Default, OK
        Gui, EditAction:Add, Button, x170 y100 w80 gCancelEditAction, Cancel
        
        EditActionIndex := actionIdx
        Gui, EditAction:Show, w300 h140
        
    } else if (actionType = "UpgradeMax") {
        ; Edit UpgradeMax action
        currentSpot := CustomStrategyActions%actionIdx%_Spot
        
        ; Build spot list for dropdown
        spotList := ""
        Loop, %SpotCount% {
            idx := A_Index - 1
            spotName := Spots%idx%_Name
            if (A_Index = 1)
                spotList := spotName
            else
                spotList := spotList . "|" . spotName
        }
        
        Gui, EditAction:New, , Edit UpgradeMax Action
        Gui, EditAction:Font, s10
        
        Gui, EditAction:Add, Text, x20 y20, Spot:
        Gui, EditAction:Add, DropDownList, x80 y20 w200 vEditActionSpot, %spotList%
        GuiControl, EditAction:ChooseString, EditActionSpot, %currentSpot%
        
        Gui, EditAction:Add, Button, x80 y60 w80 gConfirmEditUpgradeMax Default, OK
        Gui, EditAction:Add, Button, x170 y60 w80 gCancelEditAction, Cancel
        
        EditActionIndex := actionIdx
        Gui, EditAction:Show, w300 h100
    }
return

ConfirmEditPlaceUnit:
    Gui, EditAction:Submit
    Gui, EditAction:Destroy
    
    Global EditActionIndex
    
    ; Get unit key from unit name
    unitKey := Units_GetKey(EditActionUnit)
    
    ; Update in memory
    CustomStrategy_UpdateAction(EditActionIndex, "PlaceUnit", unitKey, EditActionSpot)
    
    ; Refresh display
    RefreshCustomStrategyList()
    

    
    EditActionIndex := ""
return

ConfirmEditUpgradeMax:
    Gui, EditAction:Submit
    Gui, EditAction:Destroy
    
    Global EditActionIndex
    
    ; Update in memory
    CustomStrategy_UpdateAction(EditActionIndex, "UpgradeMax", 0, EditActionSpot)
    
    ; Refresh display
    RefreshCustomStrategyList()
    

    
    EditActionIndex := ""
return

CancelEditAction:
    Gui, EditAction:Destroy
    EditActionIndex := ""
return

RemoveStrategyAction:
    Gui, Config:Default
    Gui, Config:ListView, CustomStrategyList
    selectedRow := LV_GetNext()
    if (!selectedRow) {
        MsgBox, Please select an action to remove.
        return
    }
    
    actionIdx := selectedRow - 1
    
    MsgBox, 4, Confirm Delete, Are you sure you want to delete this action?
    IfMsgBox No
        return
    
    ; Remove from memory
    CustomStrategy_RemoveAction(actionIdx)
    
    ; Refresh display
    RefreshCustomStrategyList()
    
    ; Save to file
    CustomStrategy_SaveActions()
return

; === MAIN BUTTON HANDLERS ===

SaveConfig:
    Gui, Config:Submit, NoHide
    Config_SaveToFile() ; Saves to whatever file is currently loaded
    MsgBox, Saved to %CurrentConfigFile%
return

SaveConfigAs:
    Gui, Config:Submit, NoHide
    FileSelectFile, SelectedFile, S16, config.ini, Save Configuration As, Configuration Files (*.ini)
    if (SelectedFile = "")
        return
    
    ; Enforce .ini extension
    if (SubStr(SelectedFile, -3) != ".ini")
        SelectedFile := SelectedFile . ".ini"
        
    Config_SaveToFile(SelectedFile) ; Save and update current filename
    Gui, Config:Show, , Bot Configuration - %CurrentConfigFile%
    MsgBox, Saved to %SelectedFile%
return

LoadConfig:
    Config_LoadFromFile("config.ini")
    Gui, Config:Destroy
    ShowConfigGUI()
    MsgBox, Loaded Default (config.ini)
return

LoadConfigFrom:
    FileSelectFile, SelectedFile, 1, config.ini, Load Configuration From, Configuration Files (*.ini)
    if (SelectedFile = "")
        return
        
    Config_LoadFromFile(SelectedFile)
    Gui, Config:Destroy
    ShowConfigGUI()
    MsgBox, Loaded from %SelectedFile%
return

ConfigClose:
    Gui, Config:Destroy
return

