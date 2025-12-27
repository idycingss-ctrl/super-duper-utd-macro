; ==============================================================================
; === LOGGER.AHK - "Safe Anywhere" Version ===
; ==============================================================================

SendWebhook(Title, Message, Color) {
    ; Define Globals so we can access them
    Global WebhookURL, WebhookQueue
    
    ; 1. SAFETY CHECK: Initialize the Queue if it's missing
    ; This fixes the issue where the bot "stops" because the array wasn't created.
    if !IsObject(WebhookQueue)
        WebhookQueue := []

    ; 2. CONFIGURATION CHECK: Set URL if missing
    if (WebhookURL = "")
        WebhookURL := "https://discord.com/api/webhooks/1452661525990084702/NwPuAhPZu0D_3jtDp542qbRWGQ_IzNoBunTvcA_8r6cK373-_K_Eg_spiP1VPEDyI0Ei" ; <--- PASTE IT HERE NOW
        
    SafeTitle := JsonEscape(Title)
    SafeMsg   := JsonEscape(Message)
    Payload   := "{""embeds"":[{""title"":""" . SafeTitle . """,""description"":""" . SafeMsg . """,""color"":" . Color . "}]}"

    try {
        WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        WebRequest.Open("POST", WebhookURL, true) ; Async = True
        WebRequest.SetRequestHeader("Content-Type", "application/json")
        WebRequest.SetRequestHeader("User-Agent", "Mozilla/5.0")
        WebRequest.Option(9) := 2048 
        
        ; 3. KEEP ALIVE: Save object to Global Array
        WebhookQueue.Push(WebRequest)
        
        WebRequest.Send(Payload)
        
        ; 4. CLEANUP: Clear memory after 10 seconds
        SetTimer, CleanupWebhooks, -10000
    } catch e {
        ; If this catches an error, it usually means WebhookQueue was missing
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
    
    SendWebhook("🏁 Run Complete", Desc, 16776960)
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



