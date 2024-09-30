local Window = {}

function Window.new(tag, x, y, w, h)
    local self = setmetatable({}, {__index = Window})

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
    self.movable = true

    self.members = {}

    return self
end

function Window.update(self, dt)
    if self.display then
        for _, member in ipairs(self.members) do
            member:update(dt)
        end
    end
end

-- mouse functions for movement
function Window.mousepressed(self, x, y, button)
    if self.display then
        if self.movable then
            if x > self.x and x < self.x + self.w and y > self.y and y < self.y + 20 then
                self.dragging = true
                self.draggingX = x - self.x
                self.draggingY = y - self.y
            end
        end

        for _, member in ipairs(self.members) do
            -- dont press the member if its being clipped by the window
            if x > self.x and x < self.x + self.w and y > self.y and y < self.y + self.h then
                member:mousepressed(x - self.x, y - self.y - (self.movable and 20 or 0), button)
            end
        end
    end
end

function Window.mousereleased(self, x, y, button)
    if self.display then
        if self.dragging then
            self.dragging = false
        end

        for _, member in ipairs(self.members) do
            if x > self.x and x < self.x + self.w and y > self.y and y < self.y + self.h then
                member:mousereleased(x - self.x, y - self.y - (self.movable and 20 or 0), button)
            end
        end
    end
end

function Window.mousemoved(self, x, y, dx, dy)
    if self.display then
        if self.dragging then
            self.x = x - self.draggingX
            self.y = y - self.draggingY
        end

        for _, member in ipairs(self.members) do
            if x > self.x and x < self.x + self.w and y > self.y and y < self.y + self.h then
                member:mousemoved(x - self.x, y - self.y - (self.movable and 20 or 0), dx, dy)
            end
        end
    end
end

function Window.add(self, member)
    table.insert(self.members, member)
end

function Window.remove(self, member)
    for i, m in ipairs(self.members) do
        if m == member then
            table.remove(self.members, i)
            break
        end
    end
end

function Window.draw(self)
    if self.display then
        love.graphics.push()
        -- if movement, draw a title bar and translate down a little bit
        if self.movable then
            love.graphics.setColor(self.bgColour)
            love.graphics.rectangle("fill", self.x, self.y, self.w, 20)
            love.graphics.setColor(self.borderColour)
            love.graphics.rectangle("line", self.x, self.y, self.w, 20)
            -- display the title
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.print(self.tag, self.x + 5, self.y + 4)
            love.graphics.translate(0, 20)
        end
        -- do some scissoring to make sure objects in the window don't go outside of it
        love.graphics.stencil(function()
            love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
        end, "replace", 1)
        love.graphics.setStencilTest("greater", 0)

        -- draw the window
        love.graphics.setColor(self.bgColour)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h, self.roundness, self.roundness)
        
        love.graphics.setColor(self.borderColour)
        love.graphics.setLineWidth(self.borderSize)
        love.graphics.rectangle("line", self.x, self.y, self.w, self.h, self.roundness, self.roundness)

        -- draw the members
        -- translate the members so they are drawn relative to the window
        love.graphics.push()
        love.graphics.translate(self.x, self.y)
        for _, member in ipairs(self.members) do
            member:draw()
        end
        love.graphics.pop()
        
        love.graphics.setStencilTest()
        love.graphics.pop()
    end
end

setmetatable(Window, {__call = function(_, ...) return Window.new(...) end})

return Window