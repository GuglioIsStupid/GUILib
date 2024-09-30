local Sprite = {}
Sprite.__type = "Sprite"

-- image data
function Sprite.new(self, img, x, y, w, h)
    local self = setmetatable({}, {__index = Sprite})

    self.img = img
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.display = true
    self.baseWidth = w
    self.baseHeight = h
    self.baseX = x
    self.baseY = y

    return self
end

function Sprite.update(self, dt)
    if self.display then
        -- do nothing
    end
end

function Sprite.mousepressed(self, x, y, button)
    if self.display then
        -- do nothing
    end
end

function Sprite.mousereleased(self, x, y, button)
    if self.display then
        -- do nothing
    end
end

function Sprite.mousemoved(self, x, y, dx, dy)
    if self.display then
        -- do nothing
    end
end

function Sprite.draw(self)
    if self.display then
        love.graphics.draw(self.img, self.x, self.y, 0, self.w / self.img:getWidth(), self.h / self.img:getHeight())
    end
end

setmetatable(Sprite, {__call = Sprite.new})

return Sprite