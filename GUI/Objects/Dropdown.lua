local Dropdown = {}
Dropdown.__type = "Dropdown"

function Dropdown.new(tag, x, y, w, h)
    local self = setmetatable({}, {__index = Dropdown})

    self.tag = tag
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.display = true
    self.bgColour = {0.1, 0.1, 0.1, 1}
    self.borderColour = {0.2, 0.2, 0.2, 1}
    self.borderSize = 2
    self.roundness = 4
    self.text = "Dropdown"
    self.textColour = {1, 1, 1, 1}
    self.textFont = love.graphics.newFont(12)
    self.textAlign = "center"
    self.callOnReleased = false
    self.onClick = function() end -- override me!
    self.baseWidth = w
    self.baseHeight = h
    self.baseX = x
    self.baseY = y
    self.active = false
    self.options = {}
    self.selected = 1
    self.optionHeight = 20
    self.optionColour = {0.1, 0.1, 0.1, 1}
    self.optionBorderColour = {0.2, 0.2, 0.2, 1}
    self.optionBorderSize = 2
    self.optionRoundness = 4
    self.optionTextColour = {1, 1, 1, 1}
    self.optionTextFont = love.graphics.newFont(12)
    self.optionTextAlign = "center"
    self.optionTextOffset = 0
    self.optionText = {
        {
            text = "Option 1",
            onClick = function() end
        },
        {
            text = "Option 2",
            onClick = function() end
        },
        {
            text = "Option 3",
            onClick = function() end
        }
    }

    return self
end

function Dropdown.update(self, dt)
    if self.display then
        -- do nothing
    end
end

function Dropdown.mousepressed(self, x, y, button)
    if self.display then
        if not self.callOnReleased then
            if not self.active then
                if x > self.x and x < self.x + self.w and y > self.y and y < self.y + self.h then
                    self.active = true
                end
            else
                -- set an option if able to, else close the dropdown
                for i, option in ipairs(self.optionText) do
                    if x > self.x and x < self.x + self.w and y > self.y + self.h + (i-1)*self.optionHeight and y < self.y + self.h + i*self.optionHeight then
                        option.onClick()
                        self.selected = i
                    end
                end

                -- close the dropdown if clicked anywhere else but the dropdown
                self.active = false
            end
        end
    end
end

function Dropdown.mousereleased(self, x, y, button)
    if self.display then
        if self.active then
            for i, option in ipairs(self.optionText) do
                if x > self.x and x < self.x + self.w and y > self.y + self.h + (i-1)*self.optionHeight and y < self.y + self.h + i*self.optionHeight then
                    option.onClick()
                    self.selected = i
                    self.active = false
                end
            end
        end
    end
end

function Dropdown.mousemoved(self, x, y, dx, dy)
    if self.display then
        -- do nothing
    end
end

function Dropdown.addOption(self, text, onClick)
    table.insert(self.optionText, {text = text, onClick = onClick})
end

function Dropdown.setOptions(self, options)
    self.optionText = options
end

function Dropdown.draw(self)
    if self.display then
        love.graphics.setColor(self.bgColour)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h, self.roundness, self.roundness)
        love.graphics.setColor(self.borderColour)
        love.graphics.setLineWidth(self.borderSize)
        love.graphics.rectangle("line", self.x, self.y, self.w, self.h, self.roundness, self.roundness)
        love.graphics.setColor(self.textColour)
        love.graphics.setFont(self.textFont)
        love.graphics.printf(self.optionText[self.selected].text, self.x, self.y, self.w, self.textAlign)
        if self.active then
            for i, option in ipairs(self.optionText) do
                love.graphics.setColor(self.optionColour)
                love.graphics.rectangle("fill", self.x, self.y + self.h + (i-1)*self.optionHeight, self.w, self.optionHeight, self.optionRoundness, self.optionRoundness)
                love.graphics.setColor(self.optionBorderColour)
                love.graphics.setLineWidth(self.optionBorderSize)
                love.graphics.rectangle("line", self.x, self.y + self.h + (i-1)*self.optionHeight, self.w, self.optionHeight, self.optionRoundness, self.optionRoundness)
                love.graphics.setColor(self.optionTextColour)
                love.graphics.setFont(self.optionTextFont)
                love.graphics.printf(option.text, self.x, self.y + self.h + (i-1)*self.optionHeight + self.optionTextOffset, self.w, self.optionTextAlign)
            end
        end
    end
end

setmetatable(Dropdown, {__call = function(_, ...) return Dropdown.new(...) end})

return Dropdown