display.setStatusBar( display.HiddenStatusBar ) 

-- Import the widget library
local widget = require( "widget" )

-- create a constant for the left spacing of the row content
local LEFT_PADDING = 10

--Set the background to white
display.setDefault( "background", 255, 255, 255 )

--Create a group to hold our widgets & images
local widgetGroup = display.newGroup()

-- The gradient used by the title bar
local titleGradient = graphics.newGradient( 
	{ 189, 203, 220, 255 }, 
	{ 89, 116, 152, 255 }, "down" )

-- Create toolbar to go at the top of the screen
local titleBar = display.newRect( 0, 0, display.contentWidth, 32 )
titleBar.y = display.statusBarHeight + ( titleBar.contentHeight * 0.5 )
titleBar:setFillColor( titleGradient )
titleBar.y = display.screenOriginY + titleBar.contentHeight * 0.5

-- create embossed text to go on toolbar
local titleText = display.newEmbossedText( "Mobile Tracks", 0, 0, native.systemFontBold, 20 )
titleText:setReferencePoint( display.CenterReferencePoint )
titleText:setTextColor( 255 )
titleText.x = 160
titleText.y = titleBar.y

-- create a shadow underneath the titlebar (for a nice touch)
local shadow = display.newImage( "shadow.png" )
shadow:setReferencePoint( display.TopLeftReferencePoint )
shadow.x, shadow.y = 0, titleBar.y + titleBar.contentHeight * 0.5
shadow.xScale = 320 / shadow.contentWidth
shadow.alpha = 0.45


-- Forward reference for our back button & tableview
local backButton, list

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

-- TODO: Package all glocal items into one object
local currentTrack = ""

-- Handle row rendering
local function onRowRender( event )
	local row = event.row

        local trackName = tracks[row.index]
	
	local rowTitle = display.newText( row, trackName, 0, 0, native.systemFontBold, 16 )
	rowTitle.x = row.x - ( row.contentWidth * 0.5 ) + ( rowTitle.contentWidth * 0.5 ) + LEFT_PADDING
	rowTitle.y = row.contentHeight * 0.5
	rowTitle:setTextColor( 0, 0, 0 )
	
	local rowArrow = display.newImage( row, "rowArrow.png", false )
	rowArrow.x = row.x + ( row.contentWidth * 0.5 ) - rowArrow.contentWidth
	rowArrow.y = row.contentHeight * 0.5
end

local staffView

local function onStaffRowRender(event)
	local row = event.row

        local personName = trackStaff[currentTrack][row.index]
	
	local rowTitle = display.newText( row, personName, 0, 0, native.systemFontBold, 16 )
	rowTitle.x = row.x - ( row.contentWidth * 0.5 ) + ( rowTitle.contentWidth * 0.5 ) + LEFT_PADDING
	rowTitle.y = row.contentHeight * 0.5
	rowTitle:setTextColor( 0, 0, 0 )
	
	local rowArrow = display.newImage( row, "rowArrow.png", false )
	rowArrow.x = row.x + ( row.contentWidth * 0.5 ) - rowArrow.contentWidth
	rowArrow.y = row.contentHeight * 0.5
end

local function onStaffRowTouch(event)
        print("onStaffRowTouch")
end

local function getStaffView(track)
        local result = widget.newTableView
        {
        	top = 38,
        	width = 320, 
        	height = 448,
        	maskFile = "mask-320x448.png",
        	onRowRender = onStaffRowRender,
        	onRowTouch = onStaffRowTouch,
        }


        widgetGroup:insert( result )

        if trackStaff[track] then
                for i = 1, #trackStaff[track] do
                	result:insertRow{
                		height = 72,
                	}
                end
        end
        return result
end

-- Hande row touch events
local function onRowTouch( event )
	local phase = event.phase
	local row = event.target
        local track = tracks[row.index]
        currentTrack = track
	
	if "press" == phase then
		print( "Pressed row: " .. row.index )

	elseif "release" == phase then
                --Text to show which item we selected
                staffView = getStaffView(track)

                -- Construct an assignment view and transition to it

		---- Update the item selected text
		--staffView.text = "You selected item " .. row.index
		--
		----Transition out the list, transition in the item selected text and the back button
		transition.to( list, { x = - list.contentWidth, time = 400, transition = easing.outExpo } )
		transition.to( staffView, { x = 0, time = 400, transition = easing.outExpo } )
		transition.to( backButton, { alpha = 1, time = 400, transition = easing.outQuad } )
		--
		--print( "Tapped and/or Released row: " .. row.index )
	end
end

-- Create a tableView
list = widget.newTableView
{
	top = 38,
	width = 320, 
	height = 448,
	maskFile = "mask-320x448.png",
	onRowRender = onRowRender,
	onRowTouch = onRowTouch,
}

--Insert widgets/images into a group
widgetGroup:insert( list )
widgetGroup:insert( titleBar )
widgetGroup:insert( titleText )
widgetGroup:insert( shadow )


--Handle the back button release event
local function onBackRelease()
	--Transition in the list, transition out the item selected text and the back button
	transition.to( list, { x = 0, time = 400, transition = easing.outExpo } )
	transition.to( staffView, { x = display.contentWidth + staffView.contentWidth * 0.5, time = 400, transition = easing.outExpo } )
	transition.to( backButton, { alpha = 0, time = 400, transition = easing.outQuad } )

        -- Remove staff view
        --widgetGroup:remove(staffView)
        staffView = nil
end

--Create the back button
backButton = widget.newButton
{
	width = 298,
	height = 56,
	label = "Back", 
	labelYOffset = - 1,
	onRelease = onBackRelease
}
backButton.alpha = 0
backButton.x = display.contentCenterX
backButton.y = display.contentHeight - backButton.contentHeight
widgetGroup:insert( backButton )

-- insert rows into list (tableView widget)
for i = 1, #tracks do
	list:insertRow{
		height = 72,
	}
end
