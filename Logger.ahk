; ==============================================================================
; === LOGGER.AHK - "Safe Anywhere" Version ===
; ==============================================================================

#Include GameMacro.ahk
#Include CardSelector.ahk 
#Include Strings.ahk

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

LogFinish(Duration, Result) {
    
    CardData := GetStatsString()

    Desc := "Result: **" . Result . "**`nDuration: " . Duration . "`n`n__**Card Summary:**__`n```yaml`n" . CardData . "```"
    
    SendWebhook("🏁 Run Complete", Desc, 16776960)
}

LogError(ErrorMsg) {
    SendWebhook("⚠️ Bot Error", ErrorMsg, 15548997)
}
GetUnitName(Spot) {
    ; Compare coordinates to identify the unit
    if (Spot.x == Spot_HillAce.x && Spot.y == Spot_HillAce.y)
        return "Ace"
    if (Spot.x == Spot_GroundKirito.x && Spot.y == Spot_GroundKirito.y)
        return "Kirito 1"
    if (Spot.x == Spot_GroundKirito2.x && Spot.y == Spot_GroundKirito2.y)
        return "Kirito 2"
    if (Spot.x == Spot_GroundMiku.x && Spot.y == Spot_GroundMiku.y)
        return "Miku"
    if (Spot.x == Spot_GroundSpeed.x && Spot.y == Spot_GroundSpeed.y)
        return "Speedwagon"
    if (Spot.x == Spot_GroundSJW.x && Spot.y == Spot_GroundSJW.y)
        return "Sung Jin Woo"
    if (Spot.x == Spot_GroundAkainu1.x && Spot.y == Spot_GroundAkainu1.y)
        return "Akainu 1"
    if (Spot.x == Spot_GroundAkainu2.x && Spot.y == Spot_GroundAkainu2.y)
        return "Akainu 2"
        
    return "Unknown Unit"
}



