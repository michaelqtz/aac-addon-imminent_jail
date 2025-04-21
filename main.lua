local api = require("api")

local imminent_jail_addon = {
	name = "Imminent Jail",
	author = "Michaelqt",
	version = "1.0",
	desc = "Alerts you when at 39 or more crime points."
}

local imminentJailWindow

local clockTimer = 0
local clockResetTime = 100

local aboveCrimePointThreshold = false

local function OnUpdate(dt)
    clockTimer = clockTimer + dt
    if clockTimer > clockResetTime then
        local crimeInfo = api.Player:GetCrimeInfo()
        local crimePoints = crimeInfo.crimePoint
        local infamyPoints = crimeInfo.crimeRecord
        if crimePoints >= 39 and crimePoints < 50 then 
            aboveCrimePointThreshold = true
        else 
            aboveCrimePointThreshold = false
        end
        if infamyPoints >= 2950 and infamyPoints < 3000 then 
            imminentJailWindow.biggerText:SetText("IMMINENT PIRATE: " .. tostring(infamyPoints) .. "/3000")
            imminentJailWindow:Show(true)
        end
        if aboveCrimePointThreshold then 
            imminentJailWindow.bigText:SetText("IMMINENT JAIL: " .. tostring(crimePoints) .. "/50")
            imminentJailWindow:Show(true)
        else 
            imminentJailWindow:Show(false)
        end 
        
        clockTimer = 0	
    end    
end 

local function OnLoad()
	local settings = api.GetSettings("imminent_jail")

	imminentJailWindow = api.Interface:CreateEmptyWindow("imminentJailWindow", "UIParent")
    local bigText = imminentJailWindow:CreateChildWidget("label", "bigText", 0, true)
    bigText:SetText("IMMINENT JAIL: 39/50")
    bigText.style:SetFontSize(48)
    bigText.style:SetOutline(true)
    bigText.style:SetShadow(true)
    ApplyTextColor(bigText, FONT_COLOR.PURPLE)
    bigText:AddAnchor("CENTER", "UIParent", 0, -300)
    imminentJailWindow.bigText = bigText

    local draughtIcon = CreateItemIconButton("draughtIcon", imminentJailWindow)
    draughtIcon:Show(true)
    F_SLOT.ApplySlotSkin(draughtIcon, draughtIcon.back, SLOT_STYLE.BUFF)
    F_SLOT.SetIconBackGround(draughtIcon, "game/ui/icon/icon_item_1829.dds")
    draughtIcon:AddAnchor("TOPLEFT", bigText, -310, -20)
    draughtIcon:Clickable(false)
    imminentJailWindow.draughtIcon = draughtIcon

    local biggerText = imminentJailWindow:CreateChildWidget("label", "biggerText", 0, true)
    biggerText:SetText("IMMINENT PIRATE: 2950/3000")
    biggerText.style:SetFontSize(60)
    biggerText.style:SetOutline(true)
    biggerText.style:SetShadow(true)
    ApplyTextColor(biggerText, FONT_COLOR.RED)
    biggerText:AddAnchor("CENTER", "UIParent", 0, -100)
    imminentJailWindow.biggerText = biggerText
    
    imminentJailWindow:Show(false)


    api.On("UPDATE", OnUpdate)
	api.SaveSettings()
end

local function OnUnload()
	api.On("UPDATE", function() return end)
	if imminentJailWindow ~= nil then 
        imminentJailWindow:Show(false)
    end 
    
    imminentJailWindow = nil
end

imminent_jail_addon.OnLoad = OnLoad
imminent_jail_addon.OnUnload = OnUnload

return imminent_jail_addon
