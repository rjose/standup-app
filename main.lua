local Utils = require('utils')
local TracksView = require('tracks_view')
local StaffView = require('staff_view')

--==============================================================================
-- Module Data
--
local m_data = {}

local global = {}
global.views = {}

local function getData()
        return m_data
end

local function transitionToCurrentView()
        if #global.views < 1 then return end

        -- TODO: Do something fancier here
        global.views[#global.views].alpha = 1
end


local onTrackRowTouch = function( event )
	local phase = event.phase
	local row = event.target
        local track = m_data.tracks[row.index]
	
	if "press" == phase then
		print( "Pressed row: " .. row.index )

	elseif "release" == phase then
                print("Handle touch")
                global.views[#global.views+1] = StaffView.getStaffView(track, onStaffRowTouch)
                transitionToCurrentView()
        end
end

local onStaffRowTouch = function(event)
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


local function update()
        -- TODO: Make network call to get data (handle failure)
        m_data.tracks = {
                "Contacts",
                "Conversation",
                "Felix",
                "Future"
        }

        m_data.trackStaff = {}
        m_data.trackStaff["Contacts"] = {
                "Person 1",
                "Person 2"
        }

        if #global.views == 0 then
                global.views[#global.views+1] = TracksView.getTracksView(onTrackRowTouch)
                transitionToCurrentView()
        else
                -- TODO: Refresh current view
        end
end


local function init()
        display.setStatusBar( display.HiddenStatusBar )
        display.setDefault( "background", 255, 255, 255 )
        TracksView.setDataGetter(getData)
        StaffView.setDataGetter(getData)
        update()
end

init()
