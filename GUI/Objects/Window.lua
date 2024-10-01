local Window = {}
Window._type = "Window"

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
    self.resizeable = false

    self.dragging = false
    self.draggingX = 0
    self.draggingY = 0

    self.resizing = false
    self.resizingX = nil
    self.resizingY = nil
    
    self.onTop = false
    self.onBottom = false
    self.onLeft = false
    self.onRight = false

    self.baseWidth = w
    self.baseHeight = h

    self.members = {}

    return self
end

function Window.update(self, dt)
    if self.display then
        for _, member in ipairs(self.members) do
            if type(member) == "userdata" then
                goto continue
            end
            member:update(dt)
            ::continue::
        end
    end
end

-- mouse functions for movement
function Window.mousepressed(self, x, y, button)
    if self.display then
        local okToMove = true
        if self.resizeable then -- 3px safe
            -- was it corner, or a full side?
            local wasCorner = false
            local wasTopOrBottom = false
            local wasLeftOrRight = false

            if x > self.x and x < self.x + 10 and y > self.y and y < self.y + 10 then
                wasCorner = true
                self.onTop = true
                self.onLeft = true
            elseif x > self.x + self.w - 10 and x < self.x + self.w and y > self.y + self.h - 10 + (self.movable and 20 or 0) and y < self.y + self.h + (self.movable and 20 or 0) then
                wasCorner = true
                self.onBottom = true
                self.onRight = true
            elseif x > self.x and x < self.x + self.w and y > self.y and y < self.y + 10 then
                wasTopOrBottom = true
                self.onTop = true
            elseif x > self.x and x < self.x + self.w and y > self.y + self.h - 10 + (self.movable and 20 or 0) and y < self.y + self.h + (self.movable and 20 or 0) then
                wasTopOrBottom = true
                self.onBottom = true
            elseif x > self.x and x < self.x + 10 and y > self.y and y < self.y + self.h then
                wasLeftOrRight = true
                self.onLeft = true
            elseif x > self.x + self.w - 10 and x < self.x + self.w and y > self.y and y < self.y + self.h then
                wasLeftOrRight = true
                self.onRight = true
            end
            
            -- resize the window
            if wasCorner then
                self.resizing = true
                self.resizingX = x
                self.resizingY = y
                okToMove = false
            elseif wasTopOrBottom then
                self.resizing = true
                self.resizingY = y
                okToMove = false
            elseif wasLeftOrRight then
                self.resizing = true
                self.resizingX = x
                okToMove = false
            end
        end

        if self.movable and okToMove then
            if x > self.x and x < self.x + self.w and y > self.y and y < self.y + 20 then
                self.dragging = true
                self.draggingX = x - self.x
                self.draggingY = y - self.y
            end
        end

        for _, member in ipairs(self.members) do
            -- dont press the member if its being clipped by the window
            if not member.mousepressed then
                goto continue
            end
            if x > self.x and x < self.x + self.w and y > self.y and y < self.y + self.h then
                member:mousepressed(x - self.x, y - self.y - (self.movable and 20 or 0), button)
            end
            ::continue::
        end
    end
end

function Window.mousereleased(self, x, y, button)
    if self.display then
        if self.dragging then
            self.dragging = false
        end

        if self.resizing then
            self.resizing = false
            self.resizingX = nil
            self.resizingY = nil
            self.onTop = false
            self.onBottom = false
            self.onLeft = false
            self.onRight = false
        end

        for _, member in ipairs(self.members) do
            if type(member) == "userdata" or not member.mousereleased then
                goto continue
            end
            if x > self.x and x < self.x + self.w and y > self.y and y < self.y + self.h then
                member:mousereleased(x - self.x, y - self.y - (self.movable and 20 or 0), button)
            end
            ::continue::
        end
    end
end

function Window.mousemoved(self, x, y, dx, dy)
    if self.display then
        if self.dragging then
            self.x = x - self.draggingX
            self.y = y - self.draggingY
        end
        
        if self.resizeable then
            local hoveringCorner = false
            local hoveringTopOrBottom = false
            local hoveringLeftOrRight = false

            -- use x, y, w, h to determine if we are hovering over a corner or side, if a side and the top/bottom is also hovered, then it's a corner
            if x > self.x and x < self.x + 10 and y > self.y and y < self.y + 10 then
                hoveringCorner = true
            elseif x > self.x + self.w - 10 and x < self.x + self.w and y > self.y + self.h - 10 + (self.movable and 20 or 0) and y < self.y + self.h + (self.movable and 20 or 0) then
                hoveringCorner = true
            elseif x > self.x and x < self.x + self.w and y > self.y and y < self.y + 10 then
                hoveringTopOrBottom = true
            elseif x > self.x and x < self.x + self.w and y > self.y + self.h - 10 + (self.movable and 20 or 0) and y < self.y + self.h + (self.movable and 20 or 0) then
                hoveringTopOrBottom = true
            elseif x > self.x and x < self.x + 10 and y > self.y and y < self.y + self.h then
                hoveringLeftOrRight = true
            elseif x > self.x + self.w - 10 and x < self.x + self.w and y > self.y and y < self.y + self.h then
                hoveringLeftOrRight = true
            end


            if hoveringCorner then
                -- what side are we on?
                if x > self.x and x < self.x + 30 then
                    if y > self.y and y < self.y + 30 then
                        love.mouse.setCursor(love.mouse.getSystemCursor("sizenwse"))
                    elseif y > self.y + self.h - 30 and y < self.y + self.h then
                        love.mouse.setCursor(love.mouse.getSystemCursor("sizenesw"))
                    end
                end
            elseif hoveringTopOrBottom then
                love.mouse.setCursor(love.mouse.getSystemCursor("sizens"))
            elseif hoveringLeftOrRight then
                love.mouse.setCursor(love.mouse.getSystemCursor("sizewe"))
            else
                love.mouse.setCursor()
            end

            if not self.resizing then
                return
            end

            if self.resizingX then
                if self.onLeft then
                    self.w = self.w + (self.x - x)
                    self.x = x
                elseif self.onRight then
                    self.w = self.w + (x - self.x - self.w)
                end

                -- rescale members based off of baseWidth
                --[[ for _, member in ipairs(self.members) do
                    if type(member) == "userdata" then
                        goto continue
                    end
                    if member.baseWidth then
                        member.w = member.baseWidth * (self.w / self.baseWidth)
                    end
                    if member.baseHeight then
                        member.h = member.baseHeight * (self.h / self.baseHeight)
                    end
                    ::continue::
                end ]]
            end
            if self.resizingY then
                if self.onTop then
                    self.h = self.h + (self.y - y)
                    self.y = y
                elseif self.onBottom then
                    self.h = self.h + (y - self.y - self.h)
                end
                
                -- rescale members based off of baseHeight
                --[[ for _, member in ipairs(self.members) do
                    if type(member) == "userdata" then
                        goto continue
                    end
                    if member.baseWidth then
                        member.w = member.baseWidth * (self.w / self.baseWidth)
                    end
                    if member.baseHeight then
                        member.h = member.baseHeight * (self.h / self.baseHeight)
                    end
                    ::continue::
                end ]]
            end

            for _, member in ipairs(self.members) do
                -- keep it aspect-fixed, NOT STRETCHED
                if type(member) == "userdata" then
                    goto continue
                end
                -- keep it aspect-fixed based off of self.baseWidth and self.baseHeight with the current width and height
                local scale = 1
                scale = math.min(self.w / self.baseWidth, self.h / self.baseHeight)

                member.x = member.baseX * scale
                member.y = member.baseY * scale
                member.w = member.baseWidth * scale
                member.h = member.baseHeight * scale
                ::continue::
            end
        end

        for _, member in ipairs(self.members) do
            if type(member) == "userdata" or not member.mousemoved then
                goto continue
            end
            if x > self.x and x < self.x + self.w and y > self.y and y < self.y + self.h then
                member:mousemoved(x - self.x, y - self.y - (self.movable and 20 or 0), dx, dy)
            end
            ::continue::
        end
    end
end

function Window.keypressed(self, key)
    if self.display then
        for _, member in ipairs(self.members) do
            if type(member) == "userdata" or not member.keypressed then
                goto continue
            end
            member:keypressed(key)
            ::continue::
        end
    end
end

function Window.textinput(self, text)
    if self.display then
        for _, member in ipairs(self.members) do
            if type(member) == "userdata" or not member.textinput then
                goto continue
            end
            member:textinput(text)
            ::continue::
        end
    end
end

function Window.filedropped(self, file)
    if self.display then
        for _, member in ipairs(self.members) do
            if type(member) == "userdata" or not member.filedropped then
                goto continue
            end
            member:filedropped(file)
            ::continue::
        end
    end
end

function Window.add(self, member, x, y, w, h)
    if type(member) == "userdata" then
        -- create a "Sprite" object
        member = Window.Class.Sprite(member, x, y, w, h)
    end
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
        self.w = math.max(self.w, 0)
        self.h = math.max(self.h, 0)
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