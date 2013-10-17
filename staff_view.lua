local Utils = require('utils')

local StaffView = {}

local onStaffRowRender
local dataGetter = function() return {} end

--==============================================================================
-- Module Data
--
local global = {}
global.currentTrack = nil

--==============================================================================
-- Public API
--
StaffView.getStaffView = function(track, onStaffRowTouch)
        global.currentTrack = track
        local data = dataGetter()
        local result = Utils.makeListView(track .. " Staff", onStaffRowRender, onStaffRowTouch);
        result.alpha = 0
        local list = result[1]

        if data.trackStaff[track] then
                Utils.addSimpleRows(list, #data.trackStaff[track])
        end
        return result
end

StaffView.setDataGetter = function(getter)
        dataGetter = getter
end

--==============================================================================
-- Internal
--
onStaffRowRender = function(event)
        local data = dataGetter()
	local row = event.row

        local personName = data.trackStaff[global.currentTrack][row.index]
        Utils.addRowText(row, personName)
end



return StaffView
