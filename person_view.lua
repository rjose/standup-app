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
                -- TODO: Add tasks
                Utils.addSimpleRows(list, #data.assignments[person])
        end
        return result
end

PersonView.setDataGetter = function(getter)
        dataGetter = getter
end

--==============================================================================
-- Internal
--
onTaskRowRender = function(event)
        local data = dataGetter()
	local row = event.row

        local taskData = data.assignments[global.currentPerson][row.index]
        Utils.addRowText(row, taskData.name)
end

return PersonView
