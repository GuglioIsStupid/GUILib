local path = (...):gsub("%.init$", "") .. "."

local GUI = {
    _VERSION     = 'GUI v0.0.1',
    _DESCRIPTION = 'A simple GUI library for LÖVE',
    _AUTHOR = "GuglioIsStupid",
    _LICENSE = [[
        MIT LICENSE

        Copyright © 2024 GuglioIsStupid

        Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
        
        The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
        
        THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    ]],

    _TRY_EXCEPT = function(t, e)
        local status, err = pcall(t)
        if not status then
            e(err)
        end
    end
}

local function _init()
    GUI.Window = require(path .. "Objects.Window")
    GUI.Button = require(path .. "Objects.Button")
end

_init()

return GUI