local Button = {}
Button._type = "Button"

function Button.new(tag, x, y, w, h)
    local self = setmetatable({}, {__index = Button})

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
    self.text = "Button"
    self.textColour = {1, 1, 1, 1}
    self.textFont = love.graphics.newFont(12)
    self.textAlign = "center"
    self.callOnReleased = false
    self.onClick = function() end -- override me!
    self.baseWidth = w
    self.baseHeight = h
    self.baseX = x
    self.baseY = y

    return self
end

function Button.update(self, dt)
    if self.display then
        -- do nothing
    end
end

function Button.mousepressed(self, x, y, button)
    if self.display then
        if not self.callOnReleased then
            if x > self.x and x < self.x + self.w and y > self.y and y < self.y + self.h then
                self.onClick()
            end
        end
    end
end

function Button.mousereleased(self, x, y, button)
    if self.display then
        if self.callOnReleased then
            if x > self.x and x < self.x + self.w and y > self.y and y < self.y + self.h then
                self.onClick()
            end
        end
    end
end

function Button.mousemoved(self, x, y, dx, dy)
    if self.display then
        -- do nothing
    end
end

function Button.draw(self)
    if self.display then
        love.graphics.setColor(self.bgColour)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h, self.roundness, self.roundness)

        love.graphics.setColor(self.borderColour)
        love.graphics.setLineWidth(self.borderSize)
        love.graphics.rectangle("line", self.x, self.y, self.w, self.h, self.roundness, self.roundness)

        love.graphics.setColor(self.textColour)
        love.graphics.setFont(self.textFont)
        love.graphics.printf(self.text, self.x, self.y + (self.h / 2) - (self.textFont:getHeight() / 2), self.w, self.textAlign)
    end
end

setmetatable(Button, {__call = function(_, ...) return Button.new(...) end})

return Button