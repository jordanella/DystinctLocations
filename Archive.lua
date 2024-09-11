local addonName, addon = ...

addon.DystinctLocations = CreateFrame("Frame")
DL = addon.DystinctLocations

DL:SetScript("OnEvent", function(self, event, loadedAddon)
    if event == "ADDON_LOADED" and loadedAddon == addonName then
        self:Initialize()
    end
end)

function DL:Initialize()
    local mapID = 0
    if mapID == 0 then
        return
    else
        DL.Progress = 0
        DL:ScheduleScrape(mapID, 1000, 10)
    end
end

DL:RegisterEvent("ADDON_LOADED")

function DL:ScoutAreas(mapID, position)
    local areaIDs = C_MapExplorationInfo.GetExploredAreaIDsAtPosition(mapID, position)
    local areaString = areaIDs and table.concat(areaIDs, ", ") or "none"
    return areaString
end

function DL:ScrapeMap(mapID, x_iterations, y_iterations, x_position)
    DL.Data = {}
    local y_position = 0
    local step = 1 / x_iterations
    for i=1,x_iterations do
        DL.Data[math.floor(x_position * 1000)] = {}
        for j=1,y_iterations do
            local areaString = DL:ScoutAreas(mapID, CreateVector2D(x_position, y_position))
            if areaString ~= "none" then
                DL.Data[math.floor(x_position * 1000)][math.floor(y_position * 1000)] = areaString
            end
            y_position = y_position + step
        end
        x_position = x_position + step
        y_position = 0
    end
end

function DL:ScheduleScrape(mapID, iterations, segments)
    C_Timer.NewTicker(
        2,
        function()
            DL:ScrapeMap(mapID, iterations, iterations/segments, DL.Progress)
            DL.Progress = DL.Progress + 1 / iterations
            DystinctLocationsData = DL.Data
        end,
        segments
    )
end