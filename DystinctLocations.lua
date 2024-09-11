local addonName, addon = ...

addon.DystinctLocations = CreateFrame("Frame")
DL = addon.DystinctLocations

DL:RegisterEvent("PLAYER_XP_UPDATE")
DL:RegisterEvent("ZONE_CHANGED")
DL:RegisterEvent("ADDON_LOADED")

DL.Version = 1.0

DL:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local loadedAddon = ...
        if loadedAddon == addonName then
            DL.Events = 0
            DL.Data = DystinctLocationsData
            if not DL.Data then
                DL:InitializeData()
            elseif DL.Data.Version == nil then
                DL.Data.Enabled = true
                DL.Data.TomTomEnabled = true
                DL.Data.Version = DL.Version
                DL:Save()
            end
            DL.CurrentEXP = UnitXP("player")
            DL.SubZone = GetSubZoneText()
            DL:Activate()
        elseif loadedAddon == "TomTom" and DL.Data.TomTomEnabled then
            DL.TomTom = true
        end
    elseif DL.Active then
        if event == "PLAYER_XP_UPDATE" or event == "ZONE_CHANGED" then
            local info = DL:GetPlayerInfo()
            if info then
                if event == "PLAYER_XP_UPDATE" then
                    DL:RecordExperience(info)
                else
                    DL:RecordZoneChange(info)
                end
            end
        end
    end
end)

SLASH_DYSTINCTLOC1="/dystinctlocations"
SLASH_DYSTINCTLOC2="/dysloc"

SlashCmdList["DYSTINCTLOC"] = function (arg)
    if arg == 'reset' then
        print("Clear all DystinctLocations settings and data? Type /dysloc confirm if you are sure.")
    elseif arg == 'confirm' then
        DL:InitializeData()
        DL:Activate()
    elseif arg == 'toggle' then
        DL:SetEnable()
    elseif arg == 'enable' then
        DL:SetEnable(true)
    elseif arg == 'disable' then
        DL:SetEnable(false)
    elseif arg == 'tomtom' then
        DL:ToggleTomTom()
    else
        DL:Help()
    end
end

function DL:Help()
    print("DystinctLocations")
    print("- /dysloc toggle")
    print("- /dysloc enable")
    print("- /dysloc disable")
    print("- /dysloc tomtom")
    print("- /dysloc clear")
end

function DL:InitializeData()
    DL.Data = {
        UID = DL:GenerateUID(),
        ZoneChange = {},
        Experience = {},
        Version = 1.0,
        Enabled = true,
        TomTomEnabled = true
    }
    DL:Save()
end

function DL:GenerateUID()
    DL.Events = DL.Events + 1
    return tostring(GetServerTime()) .. "-" .. tostring(DL.Events)
end

function DL:Save()
    DystinctLocationsData = DL.Data
end

function DL:Activate()
    local player = DL:GetPlayerInfo()
    if player and player.level >= 70 then
        DL.Active = false
        print("DystinctLocations has been temporarily disabled automatically as your level is greater than 70.")
        print("You may use '/dysloc enable' to force enable it.")
    else
        DL.Active = DL.Data.Enabled
    end
    if DL.Active then
        print('DystinctLocations is loaded and ready to discover the world!')
    end
    DL:Save()
end

function DL:GetPlayerInfo()
    local mapID = C_Map.GetBestMapForUnit("player")
    if not mapID then
        return nil
    end
    local position = C_Map.GetPlayerMapPosition(mapID, "player")
    if not position then
        return nil
    end
    local x, y = position:GetXY()
    if not x or not y then
        return nil
    end

    local currentXP = UnitXP("player")
    local gained = currentXP - DL.CurrentEXP
    DL.CurrentEXP = currentXP

    local lastSubZone = DL.SubZone
    DL.SubZone = GetSubZoneText()

    local zoneName = GetZoneText()

    return {
        level = UnitLevel("player"),
        gained = gained,
        x = math.floor(x * 10000) / 100,
        y = math.floor(y * 10000) / 100,
        zone = zoneName,
        mapID = mapID,
        lastSubZone = lastSubZone,
        subZone = DL.SubZone,
    }
end

function DL:SetEnable(opt)
    if opt == nil then
        DL.Active = not DL.Active
        DL.Data.Enabled = DL.Active
    else
        DL.Active = opt
        DL.Data.Enabled = opt
    end
    if DL.Active then
        print('DystinctLocations is now tracking experience gain and zone change events.')
    else
        print('DystinctLocations is no longer tracking experience gain and zone change events.')
    end
    DL:Save()
end

function DL:RecordExperience(info)
    if info then
        DL.Data.Experience[DL:GenerateUID()] = {
            uid = DL.Data.UID,
            level = info.level,
            mapID = info.mapID,
            exp = info.gained,
            subZone = info.subZone,
            zone = info.zone,
            x = info.x,
            y = info.y
        }
        DL:Save()
        
        print("DystinctLocations: Experience gain event logged!")

        if DL.TomTom and DL.Data.TomTomEnabled then
            DL:SetWaypoint(info)
        end
    end
end

function DL:RecordZoneChange(info)
    if info then
        DL.Data.ZoneChange[DL:GenerateUID()] = {
            uid = DL.Data.UID,
            level = info.level,
            mapID = info.mapID,
            oldSubZone = info.lastSubZone,
            newSubZone = info.subZone,
            zone = info.zone,
            x = info.x,
            y = info.y
        }
        DL:Save()
    end
end

function DL:ToggleTomTom()
    DL.Data.TomTomEnabled = not DL.Data.TomTomEnabled
    if DL.Data.TomTomEnabled then
        print('DystinctLocations will set waypoints using TomTom when experience is gained.')
    else
        print('DystinctLocations will no longer set waypoints using TomTom when experience is gained.')
    end
    DL:Save()
end

function DL:SetWaypoint(info)
    local m = TomTom:GetCurrentPlayerPosition()
    TomTom:AddWaypoint(m, info.x/100, info.y/100, {title=info.subZone, persistent=true, crazy=false, from="DystinctLocations"})
end