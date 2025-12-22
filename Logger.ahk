SetBatchLines, -1
#NoEnv
#SingleInstance Force

; ==============================================================================
; === LOGGER.AHK - Discord Webhook Integration ===
; ==============================================================================

; --- CONFIGURATION ---
; PASTE YOUR WEBHOOK URL INSIDE THE QUOTES BELOW
Global WebhookURL := "PASTE_YOUR_WEBHOOK_HERE"

; --- COLORS (Decimal Format for Discord) ---
Global Color_Green  := 5763719  ; Success/Start
Global Color_Red    := 15548997 ; Error/Stop
Global Color_Blue   := 3447003  ; Info/Status
Global Color_Gold   := 16776960 ; Loots/RNG

; ==============================================================================
; === HELPER FUNCTIONS (Call these in your main script) ===
; ==============================================================================

LogStart(MapName) {
    Msg := "Bot started on map: **" . MapName . "**"
    SendWebhook("🚀 New Run Started", Msg, Color_Green)
}

LogUnit(UnitName, Action) {
    ; E.g. LogUnit("Speedwagon", "Placed")
    Msg := "Unit: **" . UnitName . "**`nAction: " . Action . "`nTime: " . A_Hour . ":" . A_Min
    SendWebhook("⚔️ Unit Action", Msg, Color_Blue)
}

LogFinish(Duration, Result) {
    Msg := "Game Finished!`nResult: **" . Result . "**`nEst Duration: " . Duration
    SendWebhook("🏁 Run Complete", Msg, Color_Gold)
}

LogError(ErrorMsg) {
    SendWebhook("⚠️ Bot Error", ErrorMsg, Color_Red)
}

;============================================
;===============LOOKUP TABLE=================
;============================================
GetUnitName(SpotObj) {
    X := SpotObj.x
    Y := SpotObj.y
    
    ; --- DEFINE YOUR MAPPINGS HERE ---
    ; Just match the coordinates from your Config
    
    if (X = 795  && Y = 415)
        return "Ace (Hill)"
        
    if (X = 940  && Y = 485)
        return "Kirito"
        
    if (X = 836  && Y = 502)
        return "Miku"
        
    if (X = 1250 && Y = 570)
        return "Speedwagon"
        
    if (X = 1160 && Y = 460)
        return "Akainu (Spot 1)"
        
    if (X = 485  && Y = 510)
        return "Akainu (Spot 2)"
        
    if (X = 820  && Y = 677)
        return "Sung Jin Woo"

    ; Fallback if coordinates don't match anything
    return "Unknown Unit (" . X . "," . Y . ")"
}


; ==============================================================================
; === CORE WEBHOOK FUNCTION ===
; ==============================================================================

SendWebhook(Title, Message, Color) {
    Global WebhookURL
    
    ; 1. Sanitize Inputs (Escape quotes and backslashes for JSON)
    SafeTitle := JsonEscape(Title)
    SafeMsg   := JsonEscape(Message)
    
    ; 2. Build JSON Payload manually
    ; Note: AHK v1 Quote escaping is done by doubling them: ""
    Payload := "{""embeds"":[{""title"":""" . SafeTitle . """,""description"":""" . SafeMsg . """,""color"":" . Color . "}]}"

    ; 3. Send HTTP POST Request
    try {
        WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        WebRequest.Open("POST", WebhookURL, true) ; True = Async (Don't freeze bot waiting for reply)
        WebRequest.SetRequestHeader("Content-Type", "application/json")
        WebRequest.Send(Payload)
    } catch e {
        ; If internet is down, don't crash the bot, just ignore log
    }
}

JsonEscape(String) {
    ; Escape backslashes first
    String := StrReplace(String, "\", "\\")
    ; Escape double quotes
    String := StrReplace(String, """", "\""")
    ; Escape newlines
    String := StrReplace(String, "`n", "\n")
    return String
}