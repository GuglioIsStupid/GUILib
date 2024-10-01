local TextInput = {}
TextInput._type = "TextInput"

function TextInput.new(tag, x, y, w, h)
    local self = setmetatable({}, {__index = TextInput})

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
    self.text = ""
    self.textColour = {1, 1, 1, 1}
    self.textFont = love.graphics.newFont(12)
    self.textAlign = "left"
    self.callOnReleased = false
    self.onClick = function() end -- override me!
    self.baseWidth = w
    self.baseHeight = h
    self.baseX = x
    self.baseY = y
    self.active = false
    self.cursor = 0
    self.cursorBlink = 0
    self.cursorBlinkSpeed = 0.5
    self.cursorWidth = 2
    self.cursorColour = {1, 1, 1, 1}
    self.cursorBlinkOn = true
    self.cursorBlinkTimer = 0
    self.hint = ""

    return self
end

function TextInput.update(self, dt)
    if self.display then
        self.cursorBlinkTimer = self.cursorBlinkTimer + dt
        if self.cursorBlinkTimer > self.cursorBlinkSpeed then
            self.cursorBlinkTimer = 0
            self.cursorBlinkOn = not self.cursorBlinkOn
        end
    end
end

function TextInput.mousepressed(self, x, y, button)
    if self.display then
        if x > self.x and x < self.x + self.w and y > self.y and y < self.y + self.h then
            self.active = true
            self.cursor = #self.text
        else
            self.active = false
        end
    end
end

local utf8 = require("utf8")
function TextInput.keypressed(self, key)
    if self.display then
        if self.active then
            if key == "backspace" then
                local byteoffset = utf8.offset(self.text, -1)
                if byteoffset then
                    self.text = self.text:sub(1, byteoffset - 1) .. self.text:sub(byteoffset + 1)
                end
            elseif key == "delete" then
                if self.cursor < #self.text then
                    self.text = self.text:sub(1, self.cursor) .. self.text:sub(self.cursor + 2)
                end
            elseif key == "left" then
                if self.cursor > 0 then
                    self.cursor = self.cursor - 1
                end
            elseif key == "right" then
                if self.cursor < #self.text then
                    self.cursor = self.cursor + 1
                end
            end
        end
    end
end

function TextInput.textinput(self, text)
    if self.display then
        if self.active then
            self.text = self.text:sub(1, self.cursor) .. text .. self.text:sub(self.cursor + 1)
            self.cursor = self.cursor + 1
        end
    end
end

function TextInput.mousereleased(self, x, y, button)
    if self.display then
        if self.callOnReleased then
            if x > self.x and x < self.x + self.w and y > self.y and y < self.y + self.h then
                self.onClick()
            end
        end
    end
end

function TextInput.mousemoved(self, x, y, dx, dy)
    if self.display then
        -- do nothing
    end
end

function TextInput.draw(self)
    if self.display then
        love.graphics.setColor(self.bgColour)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h, self.roundness, self.roundness)
        love.graphics.setColor(self.borderColour)
        love.graphics.setLineWidth(self.borderSize)
        love.graphics.rectangle("line", self.x, self.y, self.w, self.h, self.roundness, self.roundness)

        love.graphics.setColor(self.textColour)
        love.graphics.setFont(self.textFont)
        local text = self.text
        local font = love.graphics.getFont()
        local width = font:getWidth(text)
        while width > self.w - 10 do
            text = text:sub(1, -2)
            width = font:getWidth(text)
        end

        if text == "" then
            if self.hint ~= "" then
                love.graphics.setColor(0.5, 0.5, 0.5, 1)
                love.graphics.printf(self.hint, self.x + 5, self.y + 5, self.w - 10, self.textAlign)
            end
        else
            love.graphics.printf(text, self.x + 5, self.y + 5, self.w - 10, self.textAlign)
        end

        if self.active and self.cursorBlinkOn then
            local font = love.graphics.getFont()
            local text = self.text:sub(1, self.cursor)
            love.graphics.setColor(self.cursorColour)
            love.graphics.setLineWidth(self.cursorWidth)
            love.graphics.line(self.x + 5 + width, self.y + 5, self.x + 5 + width, self.y + 5 + font:getHeight())
        end
    end
end

setmetatable(TextInput, {__call = function(_, ...) return TextInput.new(...) end})

return TextInput