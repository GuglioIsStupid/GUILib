GUI = require("GUI")

local UIWindow = GUI.Window("Test", 0, 0, 700, 700 )
local UIButton = GUI.Button("Test", 0, 0, 100, 20)
local UISlider = GUI.Slider("Test", 0, 60, 100, 20)

function UIButton:onClick()
    print("Button clicked!")
end

function UISlider:onUpdate(value)
    self.text = value
end

UIWindow:add(UIButton)
UIWindow:add(UISlider)

function love.load()

end

function love.update(dt)
    UIWindow:update(dt)
end

function love.mousepressed(x, y, button)
    UIWindow:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    UIWindow:mousereleased(x, y, button)
end

function love.mousemoved(x, y, dx, dy)
    UIWindow:mousemoved(x, y, dx, dy)
end

function love.draw()
    UIWindow:draw()
end