GUI = require("GUI")

local UIWindow = GUI.Window("Test", 0, 0, 700, 700 )
local UIButton = GUI.Button("Test", 0, 0, 100, 20)
local UISlider = GUI.Slider("Test", 0, 60, 100, 20)

local ResizeWindow = GUI.Window("Resizeable", 700, 0, 200, 150)
local ResizeButton = GUI.Button("Resizeable", 0, 0, 100, 20)
ResizeWindow.resizeable = true

local TextInput = GUI.TextInput("Test", 0, 30, 100, 20)

function UIButton:onClick()
    print("Button clicked!")
end

function UISlider:onUpdate(value)
    self.text = value
end

UIWindow:add(UIButton)
UIWindow:add(UISlider)

ResizeWindow:add(ResizeButton)
UIWindow:add(TextInput)

-- create a test image hard cpded
local testImg = love.image.newImageData(100, 100)
for x = 0, 99 do
    for y = 0, 99 do
        testImg:setPixel(x, y, love.math.random(), love.math.random(), love.math.random(), 1)
    end
end
testImg = love.graphics.newImage(testImg)

UIWindow:add(testImg, 0, 100, 100, 100)
ResizeWindow:add(testImg, 0, 30, 100, 100)

function love.load()

end

function love.update(dt)
    UIWindow:update(dt)
    ResizeWindow:update(dt)
end

function love.mousepressed(x, y, button)
    UIWindow:mousepressed(x, y, button)
    ResizeWindow:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    UIWindow:mousereleased(x, y, button)
    ResizeWindow:mousereleased(x, y, button)
end

function love.mousemoved(x, y, dx, dy)
    UIWindow:mousemoved(x, y, dx, dy)
    ResizeWindow:mousemoved(x, y, dx, dy)
end

function love.keypressed(key)
    UIWindow:keypressed(key)
    ResizeWindow:keypressed(key)
end

function love.textinput(text)
    UIWindow:textinput(text)
    ResizeWindow:textinput(text)
end

function love.draw()
    UIWindow:draw()
    ResizeWindow:draw()
end