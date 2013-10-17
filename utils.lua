local widget = require('widget')

local Utils = {}

--==============================================================================
-- "Constants"
--
local LEFT_PADDING = 10
local TITLE_GRADIENT = graphics.newGradient(
	{ 189, 203, 220, 255 }, 
	{ 89, 116, 152, 255 }, "down" )

--==============================================================================
-- Static Declarations
--
local makeTitleBar
local makeTitle
local makeTitleShadow
local makeList

--==============================================================================
-- Public API
--

Utils.addSimpleRows = function(list, numRows)
        for i = 1, numRows do
                list:insertRow{ height = 72 }
        end
end

Utils.addRowText = function(row, text)
	local rowTitle = display.newText( row, text, 0, 0, native.systemFontBold, 16 )
	rowTitle.x = row.x - ( row.contentWidth * 0.5 ) + ( rowTitle.contentWidth * 0.5 ) + LEFT_PADDING
	rowTitle.y = row.contentHeight * 0.5
	rowTitle:setTextColor( 0, 0, 0 )

	local rowArrow = display.newImage( row, "rowArrow.png", false )
	rowArrow.x = row.x + ( row.contentWidth * 0.5 ) - rowArrow.contentWidth
	rowArrow.y = row.contentHeight * 0.5
end

Utils.makeListView = function(title, onRowRender, onRowTouch)
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

--==============================================================================
-- Internal functions
--

makeTitleBar = function()
        -- Create toolbar to go at the top of the screen
        local titleBar = display.newRect( 0, 0, display.contentWidth, 32 )
        titleBar.y = display.statusBarHeight + ( titleBar.contentHeight * 0.5 )
        titleBar:setFillColor( TITLE_GRADIENT )
        titleBar.y = display.screenOriginY + titleBar.contentHeight * 0.5

        return titleBar
end

makeTitle = function(titleBar, title)
        local titleText = display.newEmbossedText( title, 0, 0, native.systemFontBold, 20 )
        titleText:setReferencePoint( display.CenterReferencePoint )
        titleText:setTextColor( 255 )
        titleText.x = 160
        titleText.y = titleBar.y

        return titleText
end

makeTitleShadow = function(titleBar)
        local shadow = display.newImage( "shadow.png" )
        shadow:setReferencePoint( display.TopLeftReferencePoint )
        shadow.x, shadow.y = 0, titleBar.y + titleBar.contentHeight * 0.5
        shadow.xScale = 320 / shadow.contentWidth
        shadow.alpha = 0.45
        return shadow
end

makeList = function(onRowRender, onRowTouch)
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


return Utils
