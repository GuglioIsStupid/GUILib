local FileUpload = {}
FileUpload._type = "FileUpload"

function FileUpload.new(tag, x, y, w, h)
    local self = setmetatable({}, {__index = FileUpload})

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
    self.text = "File Upload"
    self.textColour = {1, 1, 1, 1}
    self.textFont = love.graphics.newFont(12)
    self.textAlign = "center"
    self.callOnReleased = false
    self.onDrop = function(self, data) end -- override me!
    self.baseWidth = w
    self.baseHeight = h
    self.baseX = x
    self.baseY = y
    self.data = nil
    self.drawable = nil -- if you want to display an image
    self.displayTextWhenData = false

    return self
end

function FileUpload.update(self, dt)
    -- do nothing
end

function FileUpload.mousepressed(self, x, y, button)
    -- do nothing
end

function FileUpload.mousereleased(self, x, y, button)
    -- do nothing
end

function FileUpload.mousemoved(self, x, y, dx, dy)
    -- do nothing
end

function FileUpload.keypressed(self, key)
    -- do nothing
end

function FileUpload.textinput(self, text)
    -- do nothing
end

function FileUpload.filedropped(self, file)
    local mx, my = love.mouse.getPosition()
    -- if dropped outside of the object, ignore
    if mx < self.x or mx > self.x + self.w or my < self.y or my > self.y + self.h*2 then
        return
    end
    -- set data
    self.data = file
    self:onDrop(file)
end

function FileUpload.draw(self)
    if self.display then
        -- draw background
        love.graphics.setColor(self.bgColour)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h, self.roundness, self.roundness)

        -- draw border
        love.graphics.setColor(self.borderColour)
        love.graphics.setLineWidth(self.borderSize)
        love.graphics.rectangle("line", self.x, self.y, self.w, self.h, self.roundness, self.roundness)

        -- draw text
        love.graphics.setColor(self.textColour)
        love.graphics.setFont(self.textFont)
        local textX = self.x
        local textY = self.y
        if self.textAlign == "center" then
            textX = textX + (self.w / 2) - (self.textFont:getWidth(self.text) / 2)
            textY = textY + (self.h / 2) - (self.textFont:getHeight() / 2)
        elseif self.textAlign == "right" then
            textX = textX + self.w - self.textFont:getWidth(self.text)
            textY = textY + (self.h / 2) - (self.textFont:getHeight() / 2)
        end
        if self.displayTextWhenData or not self.data then
            love.graphics.print(self.text, textX, textY)
        elseif self.displayTextWhenData then
            love.graphics.print(self.data:getFilename(), textX, textY)
        end

        -- draw image
        if self.drawable then
            -- scale to the size of the button
            local img = self.drawable
            local imgW, imgH = img:getDimensions()
            local scale = math.min(self.w / imgW, self.h / imgH)
            love.graphics.draw(img, self.x + (self.w / 2) - (imgW * scale / 2), self.y + (self.h / 2) - (imgH * scale / 2), 0, scale, scale)
        end
    end
end

setmetatable(FileUpload, {__call = function(_, ...) return FileUpload.new(...) end})

return FileUpload