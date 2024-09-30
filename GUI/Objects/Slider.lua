-- like FillBar, but has a knob and the value is more locked to the mouse position instead of using dx, dy

local Slider = {}
Slider._type = "Slider"

function Slider.new(tag, x, y, w, h)
    local self = setmetatable({}, {__index = Slider})

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
    self.text = "Slider"
    self.textColour = {1, 1, 1, 1}
    self.textFont = love.graphics.newFont(12)
    self.textAlign = "center"
    self.callOnReleased = false
    self.onUpdate = function(value) end -- override me!
    self.value = 0
    self.min = 0
    self.max = 100
    self.step = 1
    self.dragging = false
    self.knobSize = 20
    self.knobColour = {0.3, 0.3, 0.3, 1}
    self.knobBorderColour = {0.4, 0.4, 0.4, 1}
    self.knobBorderSize = 2
    self.knobRoundness = 4

    return self
end

function Slider.update(self, dt)
    if self.display then
        -- do nothing
    end
end

function Slider.mousepressed(self, x, y, button)
    if self.display then
        if x > self.x and x < self.x + self.w and y > self.y and y < self.y + self.h then
            self.dragging = true
            self:mousemoved(x, y, 0, 0)
        end
    end
end

function Slider.mousereleased(self, x, y, button)
    if self.display then
        self.dragging = false
    end
end

function Slider.mousemoved(self, x, y, dx, dy)
    if self.display then
        -- doesn't clamp mouse position properly, but ig it's fine? idk if i get sick of it ill just change a small value
        if self.dragging then
            local newValue = self.min + (x - self.x) / self.w * (self.max - self.min)
            newValue = math.max(self.min, math.min(self.max, newValue))
            self.value = math.floor(newValue / self.step) * self.step
            self:onUpdate(self.value)
        end
    end
end

function Slider.getValue(self)
    return self.value
end

function Slider.draw(self)
    if self.display then
        love.graphics.setColor(self.bgColour)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h, self.roundness, self.roundness)
        love.graphics.setColor(self.borderColour)
        love.graphics.setLineWidth(self.borderSize)
        love.graphics.rectangle("line", self.x, self.y, self.w, self.h, self.roundness, self.roundness)

        love.graphics.setColor(self.knobColour)
        love.graphics.rectangle("fill", self.x + (self.value - self.min) / (self.max - self.min) * (self.w - self.knobSize), self.y, self.knobSize, self.h, self.knobRoundness, self.knobRoundness)
        love.graphics.setColor(self.knobBorderColour)
        love.graphics.setLineWidth(self.knobBorderSize)
        love.graphics.rectangle("line", self.x + (self.value - self.min) / (self.max - self.min) * (self.w - self.knobSize), self.y, self.knobSize, self.h, self.knobRoundness, self.knobRoundness)

        love.graphics.setColor(self.textColour)
        love.graphics.setFont(self.textFont)
        love.graphics.printf(self.text, self.x, self.y + self.h / 2 - self.textFont:getHeight() / 2, self.w, self.textAlign)
    end
end

setmetatable(Slider, {__call = function(_, ...) return Slider.new(...) end})

return Slider