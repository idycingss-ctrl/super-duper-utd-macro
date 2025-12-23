; ==============================================================================
; === LOGGER.AHK - "Safe Anywhere" Version ===
; ==============================================================================

; Note: We removed the global variables from the top because 
; they don't run when included at the bottom.

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
    SendWebhook("🏁 Run Complete", "Result: **" . Result . "**`nDuration: " . Duration, 16776960)
}

LogError(ErrorMsg) {
    SendWebhook("⚠️ Bot Error", ErrorMsg, 15548997)
}
GetUnitName(SpotObj) {
    X := SpotObj.x
    Y := SpotObj.y
    
    ; --- RESTORE YOUR COORDINATES HERE ---
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

    return "Unknown Unit (" . X . "," . Y . ")"
}

LogScreenshot(Reason) {
    Global WebhookURL
    
    ; 1. Create the Screenshots folder if it doesn't exist
    FileCreateDir, %A_ScriptDir%\Screenshots
    
    ; 2. Generate a unique filename based on time
    FormatTime, TimeString,, yyyy-MM-dd_HH-mm-ss
    ScreenshotPath := A_ScriptDir . "\Screenshots\Restart_" . TimeString . ".png"
    
    ; 3. Use FindText to save the Full Screen
    ; Arguments: SavePic(FileName, X, Y, X2, Y2)
    try {
        FindText().SavePic(ScreenshotPath, 0, 0, A_ScreenWidth, A_ScreenHeight)
    } catch {
        ; Fallback if FindText syntax differs in your version
        SendWebhook("⚠️ Screenshot Error", "FindText failed to save image.", 15548997)
        return
    }

    ; 4. Check if file exists before uploading
    if !FileExist(ScreenshotPath)
        return

    ; 5. Upload to Discord using Curl (Built-in on Windows 10/11)
    if (WebhookURL != "") {
        SafeReason := JsonEscape(Reason)
        
        ; JSON Payload for the Embed text
        JsonPayload := "{""content"": null, ""embeds"": [{""title"": ""📸 Restart Triggered"", ""description"": ""Trigger: **" . SafeReason . "**"", ""color"": 16711680}]}"
        
        ; Escape quotes for Command Line
        JsonPayload := StrReplace(JsonPayload, """", "\""")
        
        ; Run Curl to upload the file + embed
        Run, curl -F "file=@%ScreenshotPath%" -F "payload_json=%JsonPayload%" "%WebhookURL%",, Hide
    }
}