print("This is the start of an awesome app")
local myTextObject = display.newText( "Will this just work?!", 50, 50, "Arial", 60 )
function screenTap()
    local r = math.random( 0, 255 )
    local g = math.random( 0, 255 )
    local b = math.random( 0, 255 )
    myTextObject:setTextColor( r, g, b )
end

display.currentStage:addEventListener( "tap", screenTap )

