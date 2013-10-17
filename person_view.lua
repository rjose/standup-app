local widget = require('widget')
local Utils = require('utils')

local PersonView = {}

local onStaffRowRender
local dataGetter = function() return {} end

--==============================================================================
-- Module Data
--
local global = {}
global.currentPerson = ""
global.effortLeftHash = {}

local addTaskRows
local LEFT_MARGIN = 15

--==============================================================================
-- Public API
--
PersonView.getPersonView = function(person, onBackButtonRelease)
        global.currentPerson = person
        local data = dataGetter()
        local result = Utils.makeListView(person, onTaskRowRender);
        result.backButton = Utils.makeButton("Back", Utils.makeBackHandler(result, onBackButtonRelease))

        result.alpha = 0
        local list = result[1]

        if data.assignments[person] then
                addTaskRows(list, #data.assignments[person])
        end
        return result
end

PersonView.setDataGetter = function(getter)
        dataGetter = getter
end

function reduceEffortLeft(effort_left)
        -- TODO: Add logic if go negative
        local result = effort_left - 0.5
        return result
end

function increaseEffortLeft(effort_left)
        local result = effort_left + 0.5
        return result
end

function formatEffortLeft(effort_left)
        local result = string.format("%.1f d left", effort_left)
        return result
end

function handleDown(event)
        local taskData = event.target.taskData
        taskData.effort_left = reduceEffortLeft(taskData.effort_left)
        global.effortLeftHash[taskData.id].text = formatEffortLeft(taskData.effort_left)

        -- TODO: Send update to server
end

function handleUp(event)
        local taskData = event.target.taskData
        taskData.effort_left = increaseEffortLeft(taskData.effort_left)
        global.effortLeftHash[taskData.id].text = formatEffortLeft(taskData.effort_left)

        -- TODO: Send update to server
end


function renderTaskRow(row, taskData)
        -- Add ID
	local taskID = display.newText{ parent = row,
                                        text = taskData.id,
                                        font = native.systemFontBold,
                                        fontSize = 16 }
        taskID.x = taskID.contentWidth/2.0  + LEFT_MARGIN
        taskID.y = 10
        taskID:setTextColor(20, 20, 20)


        -- Add title
	local rowTitle = display.newText{ parent = row,
                                          text = taskData.name,
                                          font = native.systemFont,
                                          fontSize = 14 }
        rowTitle.x = rowTitle.contentWidth/2.0  + LEFT_MARGIN
        rowTitle.y = 30
	rowTitle:setTextColor( 50, 50, 50 )

        -- Add effort left
	local effortLeft = display.newText{ parent = row,
                                            text = formatEffortLeft(taskData.effort_left),
                                            font = native.systemFontBold,
                                            fontSize = 28 }
        effortLeft.x = effortLeft.contentWidth/2.0  + LEFT_MARGIN
        effortLeft.y = 60
        effortLeft:setTextColor(23, 178, 38)
        global.effortLeftHash[taskData.id] = effortLeft

        -- Add down control
	local downControl = display.newText{ parent = row,
                                            text = "D",
                                            font = native.systemFontBold,
                                            fontSize = 28 }
        downControl.x = row.contentWidth - 90
        downControl.y = 60
        downControl:setTextColor(0, 0, 0)
        downControl.taskData = taskData
        downControl:addEventListener("touch", handleDown)

        -- Add up control
	local upControl = display.newText{ parent = row,
                                            text = "U",
                                            font = native.systemFontBold,
                                            fontSize = 28 }
        upControl.x = row.contentWidth - 45
        upControl.y = 60
        upControl:setTextColor(0, 0, 0)
        upControl.taskData = taskData
        upControl:addEventListener("touch", handleUp)
end

--==============================================================================
-- Internal
--
onTaskRowRender = function(event)
        local data = dataGetter()
	local row = event.row

        local taskData = data.assignments[global.currentPerson][row.index]
        renderTaskRow(row, taskData)
end

addTaskRows = function(list, numRows)
        for i = 1, numRows do
                list:insertRow{ rowHeight = 85 }
        end
end

return PersonView
