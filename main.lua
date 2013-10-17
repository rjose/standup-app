local Utils = require('utils')

display.setStatusBar( display.HiddenStatusBar )


--==============================================================================
-- Mock Data
--
local tracks = {
        "Contacts",
        "Conversation",
        "Felix",
        "Future"
}

local trackStaff = {}
trackStaff["Contacts"] = {
        "Person 1",
        "Person 2"
}

--==============================================================================
-- Global Data
--
local global = {}
global.tracksView = nil
global.staffView = nil

global.currentTrack = ""

-- Handlers
local onTrackRowRender
local onTrackRowTouch
local onStaffRowRender
local onStaffRowTouch


local function getTrackView(tracks)
        print(tracks, tracks[1])
        local result = Utils.makeListView("Mobile Tracks", onTrackRowRender, onTrackRowTouch);
        local list = result[1]

        -- Add tracks
        for i = 1, #tracks do
                list:insertRow{ height = 72 }
        end

        return result
end

local function getStaffView(track)
        local result = Utils.makeListView(track .. " Staff", onStaffRowRender, onStaffRowTouch);
        local list = result[1]

        if trackStaff[track] then
                for i = 1, #trackStaff[track] do
                        list:insertRow{ height = 72 }
                end
        end
        return result
end


--==============================================================================
-- Handlers
--

-- Hande row touch events
onTrackRowTouch = function( event )
	local phase = event.phase
	local row = event.target
        local track = tracks[row.index]
        global.currentTrack = track
	
	if "press" == phase then
		print( "Pressed row: " .. row.index )

	elseif "release" == phase then
                global.staffView = getStaffView(track)

		--Transition out the list, transition in the item selected text and the back button
		transition.to( global.tracksView, { x = - global.tracksView.contentWidth,
                               time = 400, transition = easing.outExpo } )
		transition.to( global.staffView, { x = 0, time = 400, transition = easing.outExpo } )
        end
end

-- Handle row rendering
onTrackRowRender = function( event )
	local row = event.row

        local trackName = tracks[row.index]
        Utils.addRowText(row, trackName)
end


onStaffRowRender = function(event)
	local row = event.row

        local personName = trackStaff[global.currentTrack][row.index]
        Utils.addRowText(row, personName)
end

onStaffRowTouch = function(event)
        print("onStaffRowTouch")
end

----Handle the back button release event
--local function onBackRelease()
--	--Transition in the list, transition out the item selected text and the back button
--	transition.to( list, { x = 0, time = 400, transition = easing.outExpo } )
--	transition.to( staffView, { x = display.contentWidth + staffView.contentWidth * 0.5, time = 400, transition = easing.outExpo } )
--	transition.to( backButton, { alpha = 0, time = 400, transition = easing.outQuad } )
--
--        -- Remove staff view
--        --tracksView:remove(staffView)
--        staffView = nil
--end
--
----Create the back button
--backButton = widget.newButton
--{
--	width = 298,
--	height = 56,
--	label = "Back", 
--	labelYOffset = - 1,
--	onRelease = onBackRelease
--}
--backButton.alpha = 0
--backButton.x = display.contentCenterX
--backButton.y = display.contentHeight - backButton.contentHeight
--global.tracksView:insert( backButton )

local function init()
        display.setDefault( "background", 255, 255, 255 )
        global.tracksView = getTrackView(tracks)
end

init()
