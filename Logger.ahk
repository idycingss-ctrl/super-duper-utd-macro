; ==============================================================================
; === LOGGER.AHK - "Safe Anywhere" Version ===
; ==============================================================================

SendWebhook(Title, Message, Color, IncludeScreenshot := false) {
    ; Define Globals so we can access them
    Global WebhookURL, WebhookQueue
    
    ; 1. SAFETY CHECK: Initialize the Queue if it's missing
    if !IsObject(WebhookQueue)
        WebhookQueue := []

    ; 2. CONFIGURATION CHECK: Set URL if missing
    if (WebhookURL = "")
        WebhookURL := "https://discord.com/api/webhooks/1452661525990084702/NwPuAhPZu0D_3jtDp542qbRWGQ_IzNoBunTvcA_8r6cK373-_K_Eg_spiP1VPEDyI0Ei"
    
    tempFile := ""
    jsonFile := A_Temp . "\payload.json"
    
    ; Capture screenshot if needed
    if (IncludeScreenshot) {
        pToken := Gdip_Startup()
        SysGet, VirtualWidth, 78
        SysGet, VirtualHeight, 79
        pBitmap := Gdip_BitmapFromScreen("0|0|" . VirtualWidth . "|" . VirtualHeight)
        
        tempFile := A_Temp . "\discord_ss.png"
        Gdip_SaveBitmapToFile(pBitmap, tempFile)
        Gdip_DisposeImage(pBitmap)
        Gdip_Shutdown(pToken)
    }
    
    SafeTitle := JsonEscape(Title)
    SafeMsg   := JsonEscape(Message)
    
    ; Build JSON
    jsonContent := "{"
    jsonContent .= """embeds"":[{"
    jsonContent .= """title"":""" . SafeTitle . ""","
    jsonContent .= """description"":""" . SafeMsg . ""","
    if (IncludeScreenshot)
        jsonContent .= """image"":{""url"":""attachment://discord_ss.png""},"
    jsonContent .= """color"":" . Color
    jsonContent .= "}]"
    jsonContent .= "}"
    
    ; If screenshot, use curl with file upload
    if (IncludeScreenshot) {
        FileDelete, %jsonFile%
        FileAppend, %jsonContent%, %jsonFile%
        
        command := "curl -s -X POST -F ""payload_json=<" . jsonFile . """ -F ""file=@" . tempFile . """ """ . WebhookURL . """"
        RunWait, %comspec% /c %command%, , Hide
        
        FileDelete, %jsonFile%
        FileDelete, %tempFile%
    } else {
        ; Normal webhook without screenshot
        Payload := jsonContent
        
        try {
            WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
            WebRequest.Open("POST", WebhookURL, true)
            WebRequest.SetRequestHeader("Content-Type", "application/json")
            WebRequest.SetRequestHeader("User-Agent", "Mozilla/5.0")
            WebRequest.Option(9) := 2048 
            
            WebhookQueue.Push(WebRequest)
            WebRequest.Send(Payload)
            
            SetTimer, CleanupWebhooks, -10000
        } catch e {
        }
    }
}

; --- HELPER FUNCTIONS ---

CleanupWebhooks:
    WebhookQueue := []
return

JsonEscape(String) {
    String := StrReplace(String, "\", "\\")
    String := StrReplace(String, """", "\""")
    String := StrReplace(String, "`n", "\n")
    return String
}

; --- SHORTCUT FUNCTIONS ---
LogStart(MapName) {
    SendWebhook("🚀 New Run Started", "Map: **" . MapName . "**", 5763719)
}

LogUnit(UnitName, Action) {
    SendWebhook("⚔️ Unit Action", "Unit: **" . UnitName . "**`nAction: " . Action, 3447003)
}

LogFinish(Duration, Result, Summary := "") {
    
    CardData := GetStatsString()

    Desc := "Result: **" . Result . "**`nDuration: " . Duration
    if (Summary != "")
        Desc .= "`n" . Summary
    Desc .= "`n`n__**Card Summary:**__`n```yaml`n" . CardData . "```"
    
    SendWebhook("🏁 Run Complete", Desc, 16776960, true)  ; Screenshot enabled
}

LogError(ErrorMsg) {
    SendWebhook("⚠️ Bot Error", ErrorMsg, 15548997)
}

GetUnitName(Spot) {
    Global

    if (!IsObject(Spot))
        return "Unknown Unit"

    Loop, %SpotCount% {
        spotIdx := A_Index - 1
        if (Spot.x == Spots%spotIdx%_X && Spot.y == Spots%spotIdx%_Y) {
            spotUnitName := Spots%spotIdx%_Unit
            if (spotUnitName != "" && spotUnitName != A_Space)
                return spotUnitName
            return "Unknown Unit"
        }
    }

    return "Unknown Unit"
}