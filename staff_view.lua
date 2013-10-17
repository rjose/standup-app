local widget = require('widget')
local Utils = require('utils')

local StaffView = {}

local onStaffRowRender
local dataGetter = function() return {} end

--==============================================================================
-- Module Data
--
local global = {}
global.currentTrack = nil

-- TODO: Move this to utils
function makeButton(text, onRelease)
        local result = widget.newButton
        {
                width = 60,
                height = 25,
                label = text,
                labelYOffset = - 1,
                onRelease = onRelease
        }
        return result
end

function makeBackHandler(view, onBackButtonRelease)
        local result = function(event)
                view.backButton.alpha = 0
                view.backButton = nil
                onBackButtonRelease(event)
        end
        return result
end

--==============================================================================
-- Public API
--
StaffView.getStaffView = function(track, onStaffRowTouch, onBackButtonRelease)
        global.currentTrack = track
        local data = dataGetter()
        local result = Utils.makeListView(track .. " Staff", onStaffRowRender, onStaffRowTouch);
        result.backButton = makeButton("Back", makeBackHandler(result, onBackButtonRelease))

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
