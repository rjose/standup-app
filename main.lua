local Utils = require('utils')
local TracksView = require('tracks_view')
local StaffView = require('staff_view')
local PersonView = require('person_view')

--==============================================================================
-- Module Data
--
local global = {}
global.views = {}
global.data = {}

local onStaffRowTouch

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

local function popView()
        local view = table.remove(global.views)
        view.alpha = 0

        -- TODO: Do some kind of transition
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
                global.views[#global.views+1] = StaffView.getStaffView(track, onStaffRowTouch, popView)
                transitionToCurrentView()
        end
end


-------------------------------------------------------------------------------- 
-- Displays person view on staff touch.
--
onStaffRowTouch = function(event)
	local phase = event.phase
	local row = event.target

	if "press" == phase then
		print( "Pressed row: " .. row.index )

	elseif "release" == phase then
                local track = global.views[#global.views].data.track
                local trackStaff = global.data.trackStaff[track]
                local person = trackStaff[row.index]

                -- TODO: Add function for updating effort left
                global.views[#global.views+1] = PersonView.getPersonView(person, popView)
                transitionToCurrentView()
        end
end


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
        global.data.assignments = {}
        global.data.assignments["Person 1"] = {
                {["id"] = "MOB-123", ["name"] = "Implement awesomeness", ["effort_left"] = 2},
                {["id"] = "MOB-456", ["name"] = "Add something new", ["effort_left"] = 0.5},
                {["id"] = "MOB-000", ["name"] = "12345678901234567890123456789012", ["effort_left"] = 0.5}
        }

        if #global.views == 0 then
                -- TODO: Remove this
                global.views[#global.views+1] = PersonView.getPersonView("Person 1", popView)

                --global.views[#global.views+1] = TracksView.getTracksView(onTrackRowTouch)
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
        PersonView.setDataGetter(getData)

        update()
end

init()
