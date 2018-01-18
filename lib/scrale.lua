local scrale = {
  _VERSION     = "scrale v0.1.2",
  _DESCRIPTION = "Scale and center your desired low resolution game the best it can be in desktop window / desktop fullscreen on Mac / PC or in iOS / Android mobile devices based on native resolution",
  _URL         = "",
  _LICENSE     = [[
    MIT LICENSE
    Copyright (c) 2018 Martin Braun
    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:
    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  ]]
}

local fsWidth, fsHeight, uc = nil, nil, canvas and canvas.use or love.graphics.setCanvas

scrale.canvas = nil

scrale.gW, scrale.gH = 800, 600 -- game size
function scrale.getGameSize() return scrale.gW, scrale.gH end

scrale.slX, scrale.slY = 1, 1 -- scale factor (not required for drawing)
function scrale.getScale() return scrale.slX, scrale.slY end

scrale.oX, scrale.oY = 0, 0 -- offset to canvas (not required for drawing)
function scrale.getOffset() return scrale.oX, scrale.oY end

function scrale.init(fsW, fsH) -- fullscreen size
	fsWidth, fsHeight = fsW, fsH

	local gW, gH = fsW, fsH -- game size
	local os = love.system.getOS()
	local m = os == "Android" or os == "iOS" -- mobile?
	local wW, wH, flags = love.window.getMode() -- window size + flags
	local sW, sH -- screen size
	local slX, slY = 1, 1 -- scale factor
	local oX, oY = 0, 0 -- offset
	
	assert(flags.fullscreentype == "desktop", "Only desktop fullscreen is supported.")
	if flags.fullscreen or m then

		sW, sH = love.graphics.getDimensions()

		-- calc game size
		if gW == nil and gH ~= nil then
			gW = gH * (sW / sH)
		elseif gH == nil and gW ~= nil then
			gH = gW * (sH / sW)
		elseif gH == nil and gW == nil then
			gW, gH = sW, sH
		end

		slX, slY = sW / gW, sH / gH -- calc scale factor
		if slX < slY then -- keep aspect ratio
			slY = slX
		else 
			slX = slY
		end

		oX, oY = (sW - gW * slX) / 2, (sH - gH * slY) / 2 -- calc offset

		if m then
			love.window.setMode(sW, sH, { fullscreen = false }) -- mobile: no fs suggested
		end

	else -- window mode on desktop

		sW, sH = love.window.getDesktopDimensions()
		gW, gH = wW, wH -- game size = window size
		slX, slY = scrale.slX, scrale.slY
		local updW = false

		while gW * 2 < sW and gH * 2 < sH do -- resize window for better fit
			gW, gH = gW * 2, gH * 2
			slX, slY = slX * 2, slY * 2
			updW = true
		end

		if updW then
			love.window.setMode(gW, gH, { fullscreen = false }) -- sorry for the flickering
		end

	end
	
	scrale.canvas = love.graphics.newCanvas(gW, gH)
	scrale.gW, scrale.gH = gW, gH
	scrale.slX, scrale.slY = slX, slY
	scrale.oX, scrale.oY = oX, oY
end

function scrale.setFullscreen(fullscreen, fullscreenType)
	love.window.setFullscreen(fullscreen, fullscreenType)
	scrale.init(fsWidth, fsHeight)
end

function scrale.toggleFullscreen()
	local wW, wH, flags = love.window.getMode()
	scrale.setFullscreen(not flags.fullscreen, flags.fullscreentype)
end

function scrale.drawOnCanvas(clear)
    uc(scrale.canvas)
    if clear then love.graphics.clear({ 0, 0, 0, 255 }) end
end

function scrale.nativeToCanvas(x, y)
  return (x - scrale.oX) / scrale.slX, (y - scrale.oY) / scrale.slY
end

function scrale.draw()	
	uc(nil)
	love.graphics.setColor({ 255, 255, 255, 255 })
	love.graphics.draw(scrale.canvas, scrale.oX, scrale.oY, 0, scrale.slX, scrale.slY, 0, 0, 0, 0)
end

return scrale
