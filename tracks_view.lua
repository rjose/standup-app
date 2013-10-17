local Utils = require('utils')
local StaffView = require('staff_view')

local TracksView = {}

local onTrackRowRender
local dataGetter = function() return {} end

--==============================================================================
-- Public API
--
TracksView.getTracksView = function(onTrackRowTouch)
        local data = dataGetter()
        local result = Utils.makeListView("Mobile Tracks", onTrackRowRender, onTrackRowTouch);
        local list = result[1]

        Utils.addSimpleRows(list, #data.tracks)
        result.alpha = 0
        return result
end

TracksView.setDataGetter = function(getter)
        dataGetter = getter
end

--==============================================================================
-- Internal
--
onTrackRowRender = function( event )
        local data = dataGetter()
	local row = event.row

        local trackName = data.tracks[row.index]
        Utils.addRowText(row, trackName)
end



return TracksView
