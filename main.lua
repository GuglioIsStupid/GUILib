GUI = require("GUI")

local UIWindow = GUI.Window("Test", 0, 0, 700, 700 )
local UIButton = GUI.Button("Test", 0, 0, 100, 20)
local UIButton2 = GUI.Button("Test2", 200-50, 20, 100, 20)

function UIButton:onClick()
    print("Button clicked!")
end
function UIButton2:onClick()
    print("Button2 clicked!")
end

UIWindow:add(UIButton)
UIWindow:add(UIButton2)

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