local widget = require( "widget" )

display.setStatusBar( display.HiddenStatusBar )

--==============================================================================
-- "Constants"
--
local LEFT_PADDING = 10
local TITLE_GRADIENT = graphics.newGradient(
	{ 189, 203, 220, 255 }, 
	{ 89, 116, 152, 255 }, "down" )

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

--==============================================================================
-- Utils
--
local function addRowText(row, text)
	local rowTitle = display.newText( row, text, 0, 0, native.systemFontBold, 16 )
	rowTitle.x = row.x - ( row.contentWidth * 0.5 ) + ( rowTitle.contentWidth * 0.5 ) + LEFT_PADDING
	rowTitle.y = row.contentHeight * 0.5
	rowTitle:setTextColor( 0, 0, 0 )

	local rowArrow = display.newImage( row, "rowArrow.png", false )
	rowArrow.x = row.x + ( row.contentWidth * 0.5 ) - rowArrow.contentWidth
	rowArrow.y = row.contentHeight * 0.5
end

local function makeTitleBar()
        -- Create toolbar to go at the top of the screen
        local titleBar = display.newRect( 0, 0, display.contentWidth, 32 )
        titleBar.y = display.statusBarHeight + ( titleBar.contentHeight * 0.5 )
        titleBar:setFillColor( TITLE_GRADIENT )
        titleBar.y = display.screenOriginY + titleBar.contentHeight * 0.5

        return titleBar
end

local function makeTitle(titleBar, title)
        local titleText = display.newEmbossedText( title, 0, 0, native.systemFontBold, 20 )
        titleText:setReferencePoint( display.CenterReferencePoint )
        titleText:setTextColor( 255 )
        titleText.x = 160
        titleText.y = titleBar.y

        return titleText
end

local function makeTitleShadow(titleBar)
        local shadow = display.newImage( "shadow.png" )
        shadow:setReferencePoint( display.TopLeftReferencePoint )
        shadow.x, shadow.y = 0, titleBar.y + titleBar.contentHeight * 0.5
        shadow.xScale = 320 / shadow.contentWidth
        shadow.alpha = 0.45
        return shadow
end






local function makeList(onRowRender, onRowTouch)
        result = widget.newTableView
        {
                top = 38,
                width = 320,
                height = 448,
                maskFile = "mask-320x448.png",
                onRowRender = onRowRender,
                onRowTouch = onRowTouch,
        }
        return result
end

local function makeListView(title, onRowRender, onRowTouch)
        local result = display.newGroup()
        local list = makeList(onRowRender, onRowTouch)
        local titleBar = makeTitleBar()
        local titleText = makeTitle(titleBar, title)
        local shadow = makeTitleShadow(titleBar)

        result:insert( list )
        result:insert( titleBar )
        result:insert( titleText )
        result:insert( shadow )
        return result
end

local function getTrackView(tracks)
        print(tracks, tracks[1])
        local result = makeListView("Mobile Tracks", onTrackRowRender, onTrackRowTouch);
        local list = result[1]

        -- Add tracks
        for i = 1, #tracks do
                list:insertRow{ height = 72 }
        end

        return result
end

local function getStaffView(track)
        local result = makeListView(track .. " Staff", onStaffRowRender, onStaffRowTouch);
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
        addRowText(row, trackName)
end


onStaffRowRender = function(event)
	local row = event.row

        local personName = trackStaff[global.currentTrack][row.index]
        addRowText(row, personName)
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
