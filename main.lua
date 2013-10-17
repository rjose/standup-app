local Utils = require('utils')
local TracksView = require('tracks_view')
local StaffView = require('staff_view')

--==============================================================================
-- Module Data
--
local global = {}
global.views = {}
global.data = {}

-------------------------------------------------------------------------------- 
-- Returns app data
--
--      NOTE: This is passed to other modules as a data getter.
--
local function getData()
        return global.data
end

-------------------------------------------------------------------------------- 
-- Transitions to top view on view stack.
--
local function transitionToCurrentView()
        if #global.views < 1 then return end

        -- TODO: Do something fancier here
        global.views[#global.views].alpha = 1
end


-------------------------------------------------------------------------------- 
-- Displays track staff view on track touch.
--
local onTrackRowTouch = function( event )
	local phase = event.phase
	local row = event.target
        local track = global.data.tracks[row.index]
	
	if "press" == phase then
		print( "Pressed row: " .. row.index )

	elseif "release" == phase then
                global.views[#global.views+1] = StaffView.getStaffView(track, onStaffRowTouch)
                transitionToCurrentView()
        end
end


-------------------------------------------------------------------------------- 
-- Displays person view on staff touch.
--
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


--------------------------------------------------------------------------------
-- Pulls data and updates current view.
--
--      If there isn't a current view, the TracksView is added and then shown.
--
local function update()
        -- TODO: Make network call to get data (handle failure)
        global.data.tracks = {
                "Contacts",
                "Conversation",
                "Felix",
                "Future"
        }

        global.data.trackStaff = {}
        global.data.trackStaff["Contacts"] = {
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



--------------------------------------------------------------------------------
-- Initializes app.
--
local function init()
        display.setStatusBar( display.HiddenStatusBar )
        display.setDefault( "background", 255, 255, 255 )
        TracksView.setDataGetter(getData)
        StaffView.setDataGetter(getData)
        update()
end

init()
