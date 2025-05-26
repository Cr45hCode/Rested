-- TODO: Add show/hide toggle command
-- TODO: Add time to fully rested

local LeftText = MainMenuExpBar:CreateFontString("ExperienceLeft", "OVERLAY", "GameTooltipText")
LeftText:SetFont("Fonts\\ARIALN.TTF", 12, "THINOUTLINE")
LeftText:SetPoint("LEFT", 10, 2)
LeftText:SetTextColor(1,1,1,1)

local RestedFrame = CreateFrame("Frame")
RestedFrame:RegisterEvent("ADDON_LOADED")
RestedFrame:RegisterEvent("PLAYER_XP_UPDATE")
RestedFrame:RegisterEvent("PLAYER_LEVEL_UP")
RestedFrame:RegisterEvent("UPDATE_EXHAUSTION")
RestedFrame:RegisterEvent("UNIT_PET")
RestedFrame:RegisterEvent("UNIT_PET_EXPERIENCE")
-- Suggested events from the `XPBarText` AddOn
RestedFrame:RegisterEvent("ZONE_CHANGED")
RestedFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
RestedFrame:RegisterEvent("PLAYER_CONTROL_LOST")
RestedFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
RestedFrame:RegisterEvent("PLAYER_LEAVING_WORLD")
RestedFrame:RegisterEvent("CINEMATIC_START")
RestedFrame:RegisterEvent("CINEMATIC_STOP")

RestedFrame:SetScript("OnEvent", function()
    if event == "ADDON_LOADED" and arg1 == "Rested" then
        DEFAULT_CHAT_FRAME:AddMessage("[|cFF0ABCDERested|r] v" .. GetAddOnMetadata("Rested","Version"))

        UpdateXPBarText()
    elseif event == "PLAYER_XP_UPDATE" or event == "PLAYER_LEVEL_UP"  or event == "UPDATE_EXHAUSTION" or event == "UNIT_PET" and arg1 == "player" or event == "UNIT_PET_EXPERIENCE" or event == "ZONE_CHANGED" or event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_CONTROL_LOST" or event == "CINEMATIC_START" or event == "CINEMATIC_STOP" or event == "PLAYER_ENTERING_WORLD" then
        UpdateXPBarText()
    end

end)

function UpdateXPBarText()
    local playerLevel = UnitLevel("player")
    local restedXP = GetXPExhaustion() or 0
    local isResting = IsResting()

    local nextLevelXP = tonumber(UnitXPMax("player"))
    -- local currentXP = tonumber(UnitXP("player"))
    -- local xpleft = nextLevelXP - currentXP

    local maxRest = nextLevelXP * 1.5
    local restedPercent = tonumber(string.format("%.2f", restedXP / maxRest * 100)) or 0
    -- local isRested = (restedPercent == 100)
    -- local timeToFullRested = GetTimeToWellRested() or 0
    
    if playerLevel < 60 then
        if restedXP then
            -- local txtRemainingTime = (isResting and not isRested and timeToFullRested and (" |cFF0ABCDE" .. timeToFullRested .. " until fully rested|r") or "")
            local txtRemainingTime = ""
            LeftText:SetText("Rested XP: " .. restedXP .. " / " .. maxRest .. " (|cFF0ABCDE" .. restedPercent .. "%|r)" .. txtRemainingTime)
        else
            LeftText:SetText("")
        end
    elseif playerLevel == 60 then
        LeftText:SetTextColor(1,1,1,0)
    end
end